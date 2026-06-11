public async Task<ServiceResult> GetMyOrdersAsync(string userId, OrderQueryDto query)
{
            
            if (string.IsNullOrEmpty(userId))
            {
                return ServiceResult.Error("Unauthorized");
            }
            return await GetOrdersInternal(userId, query);
        
}

public async Task<ServiceResult> GetAllOrdersAsync(OrderQueryDto query)
{
            return await GetOrdersInternal(null, query);
        
}

public async Task<ServiceResult> GetByIdAsync(string userId, int id)
{
            var order = await _orderRepository.GetWithDetailsAsync(id);
            if (order == null)
            {
                return ServiceResult.Error("Order not found");
            }

            
            if (string.IsNullOrEmpty(userId))
            {
                return ServiceResult.Error("Unauthorized");
            }

            var isAdmin = IsAdmin();
            if (!isAdmin && !string.Equals(order.UserId, userId, StringComparison.OrdinalIgnoreCase))
            {
                return ServiceResult.Error("Forbidden");
            }

            var details = order.OrderItems ?? new List<OrderItem>();
            var statusHistory = await TryGetStatusHistoryAsync(id);
            if (statusHistory.Count == 0)
            {
                statusHistory = BuildFallbackStatusHistory(order);
            }
            var activityLogs = await TryGetActivityLogsAsync(id);
            var bill = await _billRepository.GetByOrderWithDetailsAsync(id);
            return ServiceResult.Success(new { order, details, statusHistory, activityLogs, bill });
        
}

public async Task<ServiceResult> GetStatusHistoryAsync(string userId, int id)
{
            var order = await _orderRepository.GetByIdAsync(id);
            if (order == null)
            {
                return ServiceResult.Error("Order not found");
            }

            
            if (string.IsNullOrEmpty(userId))
            {
                return ServiceResult.Error("Unauthorized");
            }

            var isAdmin = IsAdmin();
            if (!isAdmin && !string.Equals(order.UserId, userId, StringComparison.OrdinalIgnoreCase))
            {
                return ServiceResult.Error("Forbidden");
            }

            var history = await TryGetStatusHistoryAsync(id);
            if (history.Count == 0)
            {
                history = BuildFallbackStatusHistory(order);
            }
            return ServiceResult.Success(history);
        
}

public async Task<ServiceResult> ValidateCouponAsync(ValidateCouponDto dto)
{
            if (dto.Items == null || dto.Items.Count == 0)
            {
                return ServiceResult.Error("Cart is empty.");
            }

            if (string.IsNullOrWhiteSpace(dto.CouponCode))
            {
                return ServiceResult.Error("Coupon code is required.");
            }

            var (isValidItems, itemValidationMessage, subtotalAmount, _) = await BuildOrderItemsAsync(dto.Items);
            if (!isValidItems)
            {
                return ServiceResult.Error(itemValidationMessage);
            }

            var validation = await _couponRepository.ValidateAsync(dto.CouponCode, subtotalAmount);
            if (!validation.IsValid || validation.Coupon == null)
            {
                return ServiceResult.Error(validation.Message);
            }

            var finalAmount = Math.Max(0, subtotalAmount - validation.DiscountAmount);
            return Ok(new
            {
                couponCode = validation.Coupon.Code,
                couponName = validation.Coupon.Name,
                discountAmount = validation.DiscountAmount,
                subtotalAmount,
                finalAmount,
                message = validation.Message
            });
        
}

public async Task<ServiceResult> CreateAsync(string userId, CreateOrderDto dto)
{
            
            if (string.IsNullOrEmpty(userId)) return ServiceResult.Error("Unauthorized");

            var result = await _orderService.CreateOrderAsync(userId, dto);
            if (!result.IsSuccess) return ServiceResult.Error(result.Message);

            // result.Data contains an anonymous object with order, details, bill, subtotalAmount, etc.
            var data = (dynamic)result.Data;
            return ServiceResult.Success(result.Data);
        
}

public async Task<ServiceResult> UpdateStatusAsync(string userId, int id, UpdateStatusDto dto)
{
            if (string.IsNullOrWhiteSpace(dto.Status))
            {
                return ServiceResult.Error("Status is required");
            }

            var order = await _orderRepository.GetByIdAsync(id);
            if (order == null)
            {
                return ServiceResult.Error("Order not found");
            }

            var previousStatus = OrderFlowRules.CanonicalizeOrderStatus(order.OrderStatus);
            var nextStatus = OrderFlowRules.CanonicalizeOrderStatus(dto.Status);
            if (!OrderFlowRules.IsKnownOrderStatus(nextStatus))
            {
                return ServiceResult.Error("Order status is invalid.");
            }

            if (string.Equals(previousStatus, nextStatus, StringComparison.OrdinalIgnoreCase))
            {
                return ServiceResult.Success(order);
            }

            if (nextStatus == OrderFlowRules.OrderStatusCancelled)
            {
                if (!OrderFlowRules.CanAdminCancelOrderStatus(previousStatus))
                {
                    return ServiceResult.Error("Đơn đang giao hàng (Shipping) không thể hủy trực tiếp. Hãy dùng luồng 'Yêu cầu hoàn/trả' để xử lý.");
                }

                await using var cancelTransaction = await _unitOfWork.BeginTransactionAsync();
                await CancelOrderCoreAsync(
                    order,
                    previousStatus,
                    userId,
                    "Admin",
                    string.IsNullOrWhiteSpace(dto.Note) ? "Admin hủy đơn hàng" : dto.Note);
                await cancelTransaction.CommitAsync();
                return ServiceResult.Success(order);
            }

            if (!OrderFlowRules.IsValidAdminOrderTransition(previousStatus, nextStatus))
            {
                return ServiceResult.Error("Valid flow: WaitingPayment -> Confirmed after payment, or COD Pending -> Confirmed -> Shipping -> Received -> Completed.");
            }

            if (nextStatus == OrderFlowRules.OrderStatusConfirmed &&
                OrderFlowRules.IsBankTransfer(order.PaymentMethod) &&
                order.TotalAmount > 0 &&
                !OrderFlowRules.IsPaidPaymentStatus(order.PaymentStatus))
            {
                return ServiceResult.Error("Bank transfer orders must be paid before moving to Confirmed.");
            }

            var actorUserId = userId;
            if (previousStatus == OrderFlowRules.OrderStatusPending &&
                nextStatus == OrderFlowRules.OrderStatusConfirmed &&
                OrderFlowRules.IsCashOnDelivery(order.PaymentMethod) &&
                await IsOrderStatusExpiredAsync(order, OrderFlowRules.OrderStatusPending, _pendingCodTimeout))
            {
                await AutoCancelExpiredOrderAsync(
                    order,
                    previousStatus,
                    $"Hệ thống tự hủy đơn COD vì admin không xác nhận trong {FormatTimeout(_pendingCodTimeout)}.");
                return ServiceResult.Error($"Đơn COD đã quá hạn xác nhận sau {FormatTimeout(_pendingCodTimeout)} và đã được hệ thống tự hủy.");
            }

            if (previousStatus == OrderFlowRules.OrderStatusConfirmed &&
                nextStatus == OrderFlowRules.OrderStatusShipping &&
                await IsOrderStatusExpiredAsync(order, OrderFlowRules.OrderStatusConfirmed, _preparingTimeout))
            {
                await AutoCancelExpiredOrderAsync(
                    order,
                    previousStatus,
                    $"Hệ thống tự hủy đơn vì admin không chuyển sang giao hàng trong {FormatTimeout(_preparingTimeout)}.");
                return ServiceResult.Error($"Đơn đã quá hạn chuẩn bị hàng sau {FormatTimeout(_preparingTimeout)} và đã được hệ thống tự hủy.");
            }

            order.OrderStatus = nextStatus;
            await _orderRepository.UpdateAsync(order);
            await SyncBillStatusAsync(order.Id, nextStatus);

            await AddStatusHistoryAsync(
                order.Id,
                previousStatus,
                nextStatus,
                string.IsNullOrWhiteSpace(dto.Note)
                    ? OrderFlowRules.FormatOrderStatusChange(previousStatus, nextStatus)
                    : dto.Note,
                actorUserId,
                GetActorType());
            await AddActivityLogAsync(
                order.Id,
                ActivityOrderStatusChanged,
                "Cập nhật trạng thái đơn hàng",
                string.IsNullOrWhiteSpace(dto.Note)
                    ? OrderFlowRules.FormatOrderStatusChange(previousStatus, nextStatus)
                    : dto.Note,
                previousStatus,
                nextStatus,
                actorUserId,
                GetActorType());

            // Gửi thông báo cho User về việc thay đổi trạng thái đơn hàng (Đã tự động gửi qua AddActivityLogAsync)
            /*
            await _notificationService.CreateAsync(
                userId: order.UserId,
                title: "Cập nhật đơn hàng",
                message: $"Đơn hàng #{order.Id} của bạn đã chuyển sang trạng thái: {OrderFlowRules.ToVietnameseOrderStatus(nextStatus)}.",
                url: "/shop/orders",
                isAdmin: false
            );
            */

            return ServiceResult.Success(order);
        
}

public async Task<ServiceResult> UpdatePaymentStatusAsync(string userId, int id, UpdatePaymentStatusDto dto)
{
            if (string.IsNullOrWhiteSpace(dto.PaymentStatus))
            {
                return ServiceResult.Error("Payment status is required");
            }

            var order = await _orderRepository.GetByIdAsync(id);
            if (order == null)
            {
                return ServiceResult.Error("Order not found");
            }

            var previousPaymentStatus = OrderFlowRules.CanonicalizePaymentStatus(order.PaymentStatus);
            var nextPaymentStatus = OrderFlowRules.CanonicalizePaymentStatus(dto.PaymentStatus);
            if (!OrderFlowRules.IsKnownPaymentStatus(nextPaymentStatus))
            {
                return ServiceResult.Error("Payment status is invalid.");
            }

            if (string.Equals(previousPaymentStatus, nextPaymentStatus, StringComparison.OrdinalIgnoreCase))
            {
                return ServiceResult.Success(order);
            }

            if (!OrderFlowRules.IsValidAdminPaymentTransition(previousPaymentStatus, nextPaymentStatus))
            {
                return ServiceResult.Error("Payment flow must be Unpaid/Pending -> Paid/Failed. Refunds must use the refund transfer flow.");
            }

            var previousOrderStatus = OrderFlowRules.CanonicalizeOrderStatus(order.OrderStatus);
            var canOnlyRefundPayment = OrderFlowRules.IsRefundFlowOrderStatus(previousOrderStatus);
            if (canOnlyRefundPayment)
            {
                return ServiceResult.Error("Cancelled or returned orders must use the refund transfer flow.");
            }

            if (OrderFlowRules.IsRefundPaymentStatus(nextPaymentStatus))
            {
                return ServiceResult.Error("Refund statuses are managed by the refund transfer flow.");
            }

            if (nextPaymentStatus == OrderFlowRules.PaymentStatusPaid &&
                OrderFlowRules.IsCashOnDelivery(order.PaymentMethod) &&
                previousOrderStatus != OrderFlowRules.OrderStatusReceived &&
                previousOrderStatus != OrderFlowRules.OrderStatusCompleted)
            {
                return ServiceResult.Error("COD can be marked as paid only after user confirms receiving the order.");
            }

            if (nextPaymentStatus == OrderFlowRules.PaymentStatusPaid &&
                OrderFlowRules.IsBankTransfer(order.PaymentMethod))
            {
                var latestTransferSubmission = await _orderActivityLogRepository.GetLatestByOrderAndTypeAsync(
                    order.Id,
                    ActivityBankTransferSubmitted);
                if (latestTransferSubmission == null)
                {
                    if (order.CreatedAt.Add(_bankTransferTimeout) < DateTime.Now)
                    {
                        await AutoCancelExpiredOrderAsync(
                            order,
                            previousOrderStatus,
                            $"Hệ thống tự hủy đơn chuyển khoản vì user chưa xác nhận đã chuyển khoản trong {FormatTimeout(_bankTransferTimeout)}.");
                        return ServiceResult.Error($"Đơn chuyển khoản đã quá hạn xác nhận sau {FormatTimeout(_bankTransferTimeout)} và đã được hệ thống tự hủy.");
                    }

                    return ServiceResult.Error("User has not submitted transfer confirmation yet.");
                }

                if (latestTransferSubmission.CreatedAt > order.CreatedAt.Add(_bankTransferTimeout))
                {
                    await AutoCancelExpiredOrderAsync(
                        order,
                        previousOrderStatus,
                        $"Hệ thống tự hủy đơn chuyển khoản vì user xác nhận chuyển khoản sau hạn {FormatTimeout(_bankTransferTimeout)}.");
                    return ServiceResult.Error($"User xác nhận chuyển khoản sau hạn {FormatTimeout(_bankTransferTimeout)} nên đơn đã được hệ thống tự hủy.");
                }
            }

            order.PaymentStatus = nextPaymentStatus;
            var nextOrderStatus = previousOrderStatus;
            if (nextPaymentStatus == OrderFlowRules.PaymentStatusPaid && previousOrderStatus == OrderFlowRules.OrderStatusWaitingPayment)
            {
                nextOrderStatus = OrderFlowRules.OrderStatusConfirmed;
                order.OrderStatus = nextOrderStatus;
            }

            if (nextPaymentStatus == OrderFlowRules.PaymentStatusFailed &&
                OrderFlowRules.CanAdminCancelOrderStatus(previousOrderStatus))
            {
                await using var transaction = await _unitOfWork.BeginTransactionAsync();
                order.PaymentStatus = OrderFlowRules.PaymentStatusFailed;
                await CancelOrderCoreAsync(
                    order,
                    previousOrderStatus,
                    userId,
                    "Admin",
                    "Admin đánh dấu thanh toán thất bại và hủy đơn.");
                await transaction.CommitAsync();
                return ServiceResult.Success(order);
            }

            await _orderRepository.UpdateAsync(order);
            if (!string.Equals(previousOrderStatus, nextOrderStatus, StringComparison.OrdinalIgnoreCase))
            {
                await SyncBillStatusAsync(order.Id, nextOrderStatus);
                await AddStatusHistoryAsync(
                    order.Id,
                    previousOrderStatus,
                    nextOrderStatus,
                    $"Admin xác nhận thanh toán. {OrderFlowRules.FormatPaymentStatusChange(previousPaymentStatus, nextPaymentStatus)}",
                    userId,
                    "Admin");
            }
            await SyncBillPaymentStatusAsync(order.Id, order.PaymentStatus);
            await AddActivityLogAsync(
                order.Id,
                ActivityPaymentStatusChanged,
                "Cập nhật trạng thái thanh toán",
                OrderFlowRules.FormatPaymentStatusChange(previousPaymentStatus, nextPaymentStatus),
                previousPaymentStatus,
                nextPaymentStatus,
                userId,
                "Admin");

            // Gửi thông báo cho User về việc thay đổi trạng thái thanh toán (Đã tự động gửi qua AddActivityLogAsync)
            /*
            await _notificationService.CreateAsync(
                userId: order.UserId,
                title: "Thanh toán đơn hàng",
                message: $"Thanh toán đơn hàng #{order.Id} đã cập nhật: {OrderFlowRules.ToVietnamesePaymentStatus(nextPaymentStatus)}.",
                url: "/shop/orders",
                isAdmin: false
            );
            */

            return ServiceResult.Success(order);
        
}

public async Task<ServiceResult> SubmitBankTransferAsync(string userId, int id, SubmitBankTransferDto dto)
{
            var order = await _orderRepository.GetByIdAsync(id);
            if (order == null)
            {
                return ServiceResult.Error("Order not found");
            }

            
            if (string.IsNullOrEmpty(userId))
            {
                return ServiceResult.Error("Unauthorized");
            }

            if (!string.Equals(order.UserId, userId, StringComparison.OrdinalIgnoreCase))
            {
                return ServiceResult.Error("Forbidden");
            }

            if (!OrderFlowRules.IsBankTransfer(order.PaymentMethod))
            {
                return ServiceResult.Error("This order does not use Bank Transfer payment method.");
            }

            var orderStatus = OrderFlowRules.CanonicalizeOrderStatus(order.OrderStatus);
            if (orderStatus != OrderFlowRules.OrderStatusWaitingPayment)
            {
                return ServiceResult.Error("Only waiting-payment orders can submit transfer confirmation.");
            }

            var paymentStatus = OrderFlowRules.CanonicalizePaymentStatus(order.PaymentStatus);
            if (paymentStatus is OrderFlowRules.PaymentStatusPaid or OrderFlowRules.PaymentStatusFailed or OrderFlowRules.PaymentStatusRefunded)
            {
                return ServiceResult.Error("Order payment is already finalized.");
            }

            var latestTransferSubmission = await _orderActivityLogRepository.GetLatestByOrderAndTypeAsync(
                order.Id,
                ActivityBankTransferSubmitted);
            if (latestTransferSubmission != null)
            {
                return Ok(new
                {
                    message = "Transfer confirmation has already been submitted.",
                    submittedAt = latestTransferSubmission.CreatedAt
                });
            }

            if (order.CreatedAt.Add(_bankTransferTimeout) < DateTime.Now)
            {
                await AutoCancelExpiredOrderAsync(
                    order,
                    orderStatus,
                    $"Hệ thống tự hủy đơn chuyển khoản vì user chưa xác nhận đã chuyển khoản trong {FormatTimeout(_bankTransferTimeout)}.");
                return ServiceResult.Error($"Đơn chuyển khoản đã quá hạn xác nhận sau {FormatTimeout(_bankTransferTimeout)} và đã được hệ thống tự hủy.");
            }

            var note = string.IsNullOrWhiteSpace(dto.Note)
                ? "User xác nhận đã chuyển khoản."
                : dto.Note.Trim();
            var previousPaymentStatus = paymentStatus;

            await using var transaction = await _unitOfWork.BeginTransactionAsync();

            if (paymentStatus == OrderFlowRules.PaymentStatusUnpaid)
            {
                order.PaymentStatus = OrderFlowRules.PaymentStatusPending;
                await _orderRepository.UpdateAsync(order);
                await SyncBillPaymentStatusAsync(order.Id, order.PaymentStatus);
            }

            await AddActivityLogAsync(
                order.Id,
                ActivityBankTransferSubmitted,
                "User xác nhận chuyển khoản",
                note,
                previousPaymentStatus,
                order.PaymentStatus,
                userId,
                "User");

            await transaction.CommitAsync();

            // Gửi thông báo cho Admin khi user gửi xác nhận chuyển khoản (Đã tự động gửi qua AddActivityLogAsync)
            /*
            await _notificationService.CreateAsync(
                userId: null,
                title: "Xác nhận chuyển khoản",
                message: $"Khách hàng vừa gửi xác nhận chuyển khoản cho đơn hàng #{order.Id}.",
                url: $"/shop/orders",
                isAdmin: true
            );
            */

            return Ok(new
            {
                message = "Transfer confirmation submitted successfully.",
                submittedAt = DateTime.Now
            });
        
}

public async Task<ServiceResult> SubmitRefundTransferAsync(string userId, int id, SubmitRefundTransferDto dto)
{
            var order = await _orderRepository.GetByIdAsync(id);
            if (order == null)
            {
                return ServiceResult.Error("Order not found");
            }

            var orderStatus = OrderFlowRules.CanonicalizeOrderStatus(order.OrderStatus);
            if (!OrderFlowRules.IsRefundFlowOrderStatus(orderStatus))
            {
                return ServiceResult.Error("Refund transfer can be submitted only after order is cancelled or returned.");
            }

            var previousPaymentStatus = OrderFlowRules.CanonicalizePaymentStatus(order.PaymentStatus);
            if (previousPaymentStatus == OrderFlowRules.PaymentStatusRefunded)
            {
                return ServiceResult.Error("Refund has already been confirmed by user.");
            }

            if (previousPaymentStatus == OrderFlowRules.PaymentStatusRefundTransferred)
            {
                return ServiceResult.Success(new { message = "Refund transfer has already been submitted.", order });
            }

            if (previousPaymentStatus != OrderFlowRules.PaymentStatusRefundPending)
            {
                return ServiceResult.Error("This order is not waiting for refund transfer.");
            }

            var note = string.IsNullOrWhiteSpace(dto.Note)
                ? "Admin confirmed refund transfer was sent."
                : dto.Note.Trim();
            var adminUserId = userId;

            await using var transaction = await _unitOfWork.BeginTransactionAsync();

            order.PaymentStatus = OrderFlowRules.PaymentStatusRefundTransferred;
            await _orderRepository.UpdateAsync(order);
            await SyncBillPaymentStatusAsync(order.Id, order.PaymentStatus);

            await AddActivityLogAsync(
                order.Id,
                ActivityRefundTransferSubmitted,
                "Admin da chuyen hoan tien",
                note,
                previousPaymentStatus,
                order.PaymentStatus,
                adminUserId,
                "Admin");
            await AddActivityLogAsync(
                order.Id,
                ActivityPaymentStatusChanged,
                "Cap nhat trang thai thanh toan",
                OrderFlowRules.FormatPaymentStatusChange(previousPaymentStatus, order.PaymentStatus),
                previousPaymentStatus,
                order.PaymentStatus,
                adminUserId,
                "Admin");

            await transaction.CommitAsync();

            // Gửi thông báo cho User khi Admin hoàn tiền (Đã tự động gửi qua AddActivityLogAsync)
            /*
            await _notificationService.CreateAsync(
                userId: order.UserId,
                title: "Hoàn tiền đơn hàng",
                message: $"Admin đã chuyển khoản hoàn tiền cho đơn hàng #{order.Id}. Vui lòng kiểm tra tài khoản và xác nhận.",
                url: "/shop/orders",
                isAdmin: false
            );
            */

            return Ok(new
            {
                message = "Refund transfer submitted. Waiting for user confirmation.",
                order
            });
        
}

public async Task<ServiceResult> ConfirmRefundReceivedAsync(string userId, int id)
{
            var order = await _orderRepository.GetByIdAsync(id);
            if (order == null)
            {
                return ServiceResult.Error("Order not found");
            }

            
            if (string.IsNullOrEmpty(userId))
            {
                return ServiceResult.Error("Unauthorized");
            }

            if (!string.Equals(order.UserId, userId, StringComparison.OrdinalIgnoreCase))
            {
                return ServiceResult.Error("Forbidden");
            }

            var orderStatus = OrderFlowRules.CanonicalizeOrderStatus(order.OrderStatus);
            if (!OrderFlowRules.IsRefundFlowOrderStatus(orderStatus))
            {
                return ServiceResult.Error("Refund receipt can be confirmed only after order is cancelled or returned.");
            }

            var previousPaymentStatus = OrderFlowRules.CanonicalizePaymentStatus(order.PaymentStatus);
            if (previousPaymentStatus != OrderFlowRules.PaymentStatusRefundTransferred)
            {
                return ServiceResult.Error("Admin has not submitted refund transfer yet.");
            }

            await using var transaction = await _unitOfWork.BeginTransactionAsync();

            order.PaymentStatus = OrderFlowRules.PaymentStatusRefunded;
            await _orderRepository.UpdateAsync(order);
            await SyncBillPaymentStatusAsync(order.Id, order.PaymentStatus);

            await AddActivityLogAsync(
                order.Id,
                ActivityRefundReceivedConfirmed,
                "User xac nhan da nhan hoan tien",
                "User confirmed refund money was received.",
                previousPaymentStatus,
                order.PaymentStatus,
                userId,
                "User");
            await AddActivityLogAsync(
                order.Id,
                ActivityPaymentStatusChanged,
                "Cap nhat trang thai thanh toan",
                OrderFlowRules.FormatPaymentStatusChange(previousPaymentStatus, order.PaymentStatus),
                previousPaymentStatus,
                order.PaymentStatus,
                userId,
                "User");

            await transaction.CommitAsync();

            // Gửi thông báo cho Admin khi user xác nhận đã nhận được tiền hoàn (Đã tự động gửi qua AddActivityLogAsync)
            /*
            await _notificationService.CreateAsync(
                userId: null,
                title: "User đã nhận hoàn tiền",
                message: $"Khách hàng đã xác nhận nhận được tiền hoàn cho đơn hàng #{order.Id}.",
                url: $"/shop/orders",
                isAdmin: true
            );
            */

            return Ok(new
            {
                message = "Refund receipt confirmed.",
                order
            });
        
}

public async Task<ServiceResult> ReceiveOrderAsync(string userId, int id)
{
            var order = await _orderRepository.GetByIdAsync(id);
            if (order == null)
            {
                return ServiceResult.Error("Order not found");
            }

            
            if (string.IsNullOrEmpty(userId))
            {
                return ServiceResult.Error("Unauthorized");
            }

            if (!string.Equals(order.UserId, userId, StringComparison.OrdinalIgnoreCase))
            {
                return ServiceResult.Error("Forbidden");
            }

            var previousStatus = OrderFlowRules.CanonicalizeOrderStatus(order.OrderStatus);
            if (previousStatus != OrderFlowRules.OrderStatusShipping)
            {
                return ServiceResult.Error("You can confirm receipt only when the order is in Shipping status.");
            }

            if (await IsOrderStatusExpiredAsync(order, OrderFlowRules.OrderStatusShipping, _shippingTimeout))
            {
                await AutoCancelExpiredOrderAsync(
                    order,
                    previousStatus,
                    $"Hệ thống tự hủy đơn vì user không xác nhận đã nhận hàng trong {FormatTimeout(_shippingTimeout)}.");
                return ServiceResult.Error($"Đơn giao hàng đã quá hạn sau {FormatTimeout(_shippingTimeout)} và đã được hệ thống tự hủy.");
            }

            if (!OrderFlowRules.IsPaidPaymentStatus(order.PaymentStatus) && !OrderFlowRules.IsCashOnDelivery(order.PaymentMethod))
            {
                return ServiceResult.Error("Order must be paid before confirming receipt.");
            }

            await using var transaction = await _unitOfWork.BeginTransactionAsync();

            order.OrderStatus = OrderFlowRules.OrderStatusReceived;
            var previousPaymentStatus = OrderFlowRules.CanonicalizePaymentStatus(order.PaymentStatus);
            if (OrderFlowRules.IsCashOnDelivery(order.PaymentMethod))
            {
                order.PaymentStatus = OrderFlowRules.PaymentStatusPaid;
            }

            await _orderRepository.UpdateAsync(order);
            await SyncBillStatusAsync(order.Id, order.OrderStatus);
            await SyncBillPaymentStatusAsync(order.Id, order.PaymentStatus);

            await AddStatusHistoryAsync(
                order.Id,
                previousStatus,
                order.OrderStatus,
                "User xác nhận đã nhận hàng.",
                userId,
                "User");
            await AddActivityLogAsync(
                order.Id,
                ActivityOrderStatusChanged,
                "User xác nhận nhận hàng",
                "User xác nhận đã nhận được hàng.",
                previousStatus,
                order.OrderStatus,
                userId,
                "User");
            if (!string.Equals(previousPaymentStatus, order.PaymentStatus, StringComparison.OrdinalIgnoreCase))
            {
                await AddActivityLogAsync(
                    order.Id,
                    ActivityPaymentStatusChanged,
                    "Cập nhật trạng thái thanh toán",
                    "COD được ghi nhận đã thanh toán khi user xác nhận nhận hàng.",
                    previousPaymentStatus,
                    order.PaymentStatus,
                    userId,
                    "User");
            }

            await transaction.CommitAsync();

            // Gửi thông báo cho Admin khi user nhận được hàng (Đã tự động gửi qua AddActivityLogAsync)
            /*
            await _notificationService.CreateAsync(
                userId: null,
                title: "Đơn hàng đã giao",
                message: $"Khách hàng đã xác nhận đã nhận đơn hàng #{order.Id}.",
                url: $"/shop/orders",
                isAdmin: true
            );
            */

            return ServiceResult.Success(new { message = "Order received successfully", order });
        
}

public async Task<ServiceResult> CancelOrderAsync(string userId, int id)
{
            var order = await _orderRepository.GetByIdAsync(id);
            if (order == null)
            {
                return ServiceResult.Error("Order not found");
            }

            
            if (string.IsNullOrEmpty(userId))
            {
                return ServiceResult.Error("Unauthorized");
            }

            var isAdmin = IsAdmin();
            if (!isAdmin && !string.Equals(order.UserId, userId, StringComparison.OrdinalIgnoreCase))
            {
                return ServiceResult.Error("Forbidden");
            }

            var previousStatus = OrderFlowRules.CanonicalizeOrderStatus(order.OrderStatus);
            var canCancel = isAdmin
                ? OrderFlowRules.CanAdminCancelOrderStatus(previousStatus)
                : OrderFlowRules.CanUserCancelOrderStatus(previousStatus);
            if (!canCancel)
            {
                return BadRequest(new
                {
                    message = isAdmin
                        ? "Admin can cancel only orders before shipping. Use return/refund flow for shipped/completed orders."
                        : "You can cancel only orders before shipping. For shipped/completed orders, submit a return/refund request."
                });
            }

            await using var transaction = await _unitOfWork.BeginTransactionAsync();
            await CancelOrderCoreAsync(
                order,
                previousStatus,
                userId,
                isAdmin ? "Admin" : "User",
                isAdmin
                    ? "Admin hủy đơn hàng."
                    : "User hủy đơn hàng.");
            await transaction.CommitAsync();

            return ServiceResult.Success(new { message = "Đã hủy đơn hàng thành công.", order });
        
}

public async Task<ServiceResult> GetOpenReturnRequestsAsync(
            string? keyword = null,
            string? paymentStatus = null,
            string? paymentMethod = null,
            DateTime? fromDate = null,
            DateTime? toDate = null,
            decimal? minTotal = null,
            decimal? maxTotal = null,
            int page = 1,
            int pageSize = 20)
{
            page = page <= 0 ? 1 : page;
            pageSize = pageSize <= 0 ? 20 : Math.Min(pageSize, 100);

            var (orders, totalCount) = await _orderRepository.SearchAsync(
                null,
                keyword,
                OrderFlowRules.OrderStatusReturnRequested,
                paymentStatus,
                paymentMethod,
                fromDate,
                toDate,
                minTotal,
                maxTotal,
                page,
                pageSize,
                "createdAt",
                "desc");

            var returnRequestItems = new List<object>();
            foreach (var order in orders)
            {
                var latestRequest = await _orderActivityLogRepository.GetLatestByOrderAndTypeAsync(
                    order.Id,
                    ActivityReturnRequestOpened);

                returnRequestItems.Add(new
                {
                    order,
                    returnRequestNote = latestRequest?.Description,
                    returnRequestAt = latestRequest?.CreatedAt,
                    returnRequestByUserId = latestRequest?.ActorUserId
                });
            }

            return Ok(new
            {
                items = returnRequestItems,
                totalCount,
                page,
                pageSize,
                totalPages = (int)Math.Ceiling((double)totalCount / pageSize)
            });
        
}

public async Task<ServiceResult> RequestReturnOrRefundAsync(string userId, int id, ReturnRequestDto dto)
{
            var order = await _orderRepository.GetByIdAsync(id);
            if (order == null)
            {
                return ServiceResult.Error("Order not found");
            }

            
            if (string.IsNullOrEmpty(userId))
            {
                return ServiceResult.Error("Unauthorized");
            }

            if (!string.Equals(order.UserId, userId, StringComparison.OrdinalIgnoreCase))
            {
                return ServiceResult.Error("Forbidden");
            }

            var canonicalStatus = OrderFlowRules.CanonicalizeOrderStatus(order.OrderStatus);
            if (canonicalStatus != OrderFlowRules.OrderStatusReceived)
            {
                return ServiceResult.Error("Chỉ được yêu cầu hoàn/trả sau khi đã nhận hàng và trước khi đơn hoàn tất.");
            }

            var hasBankTransferSubmission = false;
            if (OrderFlowRules.IsBankTransfer(order.PaymentMethod))
            {
                var latestTransferSubmission = await _orderActivityLogRepository.GetLatestByOrderAndTypeAsync(
                    order.Id,
                    ActivityBankTransferSubmitted);
                hasBankTransferSubmission = latestTransferSubmission != null;
            }

            if (!OrderFlowRules.HasMoneyReceivedForRefund(
                    order.PaymentMethod,
                    order.PaymentStatus,
                    hasBankTransferSubmission,
                    order.TotalAmount))
            {
                return ServiceResult.Error("Chi duoc yeu cau hoan/tra khi don da duoc thanh toan.");
            }

            var receivedAt = await GetLatestStatusChangedAtAsync(order.Id, OrderFlowRules.OrderStatusReceived)
                ?? order.CreatedAt;
            if (receivedAt.Add(_returnRequestWindow) < DateTime.Now)
            {
                await CompleteExpiredReceivedOrderAsync(
                    order,
                    canonicalStatus,
                    $"Hệ thống tự hoàn tất đơn vì đã quá hạn yêu cầu hoàn/trả sau {FormatTimeout(_returnRequestWindow)}.");
                return ServiceResult.Error($"Đã quá hạn yêu cầu hoàn/trả sau {FormatTimeout(_returnRequestWindow)} kể từ lúc nhận hàng. Đơn đã được hệ thống tự hoàn tất.");
            }

            var reason = string.IsNullOrWhiteSpace(dto.Reason)
                ? "User yêu cầu hoàn/trả hàng."
                : dto.Reason.Trim();

            var hasAnyRequest = await HasAnyReturnRequestAsync(order.Id);
            if (hasAnyRequest)
            {
                return ServiceResult.Error("This order already has a return/refund request or has already been returned.");
            }

            await using var transaction = await _unitOfWork.BeginTransactionAsync();

            order.OrderStatus = OrderFlowRules.OrderStatusReturnRequested;
            await _orderRepository.UpdateAsync(order);
            await SyncBillStatusAsync(order.Id, order.OrderStatus);

            await AddStatusHistoryAsync(
                order.Id,
                canonicalStatus,
                order.OrderStatus,
                "User gửi yêu cầu hoàn/trả hàng.",
                userId,
                "User");
            await AddActivityLogAsync(
                order.Id,
                ActivityReturnRequestOpened,
                "User yêu cầu hoàn/trả",
                reason,
                canonicalStatus,
                order.OrderStatus,
                userId,
                "User");

            await transaction.CommitAsync();

            // Gửi thông báo cho Admin khi user yêu cầu hoàn/trả (Đã tự động gửi qua AddActivityLogAsync)
            /*
            await _notificationService.CreateAsync(
                userId: null,
                title: "Yêu cầu hoàn/trả hàng",
                message: $"Đơn hàng #{order.Id} vừa gửi yêu cầu hoàn/trả: \"{reason}\".",
                url: $"/shop/orders",
                isAdmin: true
            );
            */

            return Ok(new
            {
                message = "Đã gửi yêu cầu hoàn/trả. Admin sẽ xem xét yêu cầu của bạn.",
                orderId = order.Id
            });
        
}

public async Task<ServiceResult> ResolveReturnOrRefundRequestAsync(string userId, int id, ResolveReturnRequestDto dto)
{
            var order = await _orderRepository.GetByIdAsync(id);
            if (order == null)
            {
                return ServiceResult.Error("Order not found");
            }

            var hasOpenRequest = await HasOpenReturnRequestAsync(order.Id);
            if (!hasOpenRequest)
            {
                return ServiceResult.Error("This order has no open return/refund request.");
            }

            var adminUserId = userId;
            var resolveNote = string.IsNullOrWhiteSpace(dto.Note)
                ? "Admin xử lý yêu cầu hoàn/trả."
                : dto.Note.Trim();
            var previousStatus = OrderFlowRules.CanonicalizeOrderStatus(order.OrderStatus);
            if (previousStatus != OrderFlowRules.OrderStatusReturnRequested)
            {
                return ServiceResult.Error("Chỉ có thể xử lý yêu cầu hoàn/trả khi đơn đang ở trạng thái ReturnRequested.");
            }

            if (!dto.IsApproved)
            {
                await using var rejectTransaction = await _unitOfWork.BeginTransactionAsync();

                order.OrderStatus = OrderFlowRules.OrderStatusCompleted;
                await _orderRepository.UpdateAsync(order);
                await SyncBillStatusAsync(order.Id, order.OrderStatus);

                await AddStatusHistoryAsync(
                    order.Id,
                    previousStatus,
                    order.OrderStatus,
                    "Admin từ chối yêu cầu hoàn/trả. Đơn được hoàn tất.",
                    adminUserId,
                    "Admin");
                await AddActivityLogAsync(
                    order.Id,
                    ActivityReturnRequestRejected,
                    "Admin từ chối hoàn/trả",
                    resolveNote,
                    previousStatus,
                    order.OrderStatus,
                    adminUserId,
                    "Admin");

                await rejectTransaction.CommitAsync();

                // Gửi thông báo cho User khi Admin từ chối yêu cầu (Đã tự động gửi qua AddActivityLogAsync)
                /*
                await _notificationService.CreateAsync(
                    userId: order.UserId,
                    title: "Từ chối yêu cầu hoàn/trả",
                    message: $"Admin đã từ chối yêu cầu hoàn/trả hàng của đơn hàng #{order.Id}. Lý do: \"{resolveNote}\".",
                    url: "/shop/orders",
                    isAdmin: false
                );
                */

                return ServiceResult.Success(new { message = "Đã từ chối yêu cầu hoàn/trả." });
            }

            await using var transaction = await _unitOfWork.BeginTransactionAsync();

            await ReturnOrderCoreAsync(
                order,
                previousStatus,
                adminUserId,
                "Admin",
                resolveNote);

            await transaction.CommitAsync();

            // Gửi thông báo cho User khi Admin duyệt yêu cầu (Đã tự động gửi qua AddActivityLogAsync)
            /*
            await _notificationService.CreateAsync(
                userId: order.UserId,
                title: "Phê duyệt hoàn/trả hàng",
                message: $"Admin đã đồng ý yêu cầu hoàn/trả hàng của đơn hàng #{order.Id} và chuyển trạng thái sang Đã hoàn/trả.",
                url: "/shop/orders",
                isAdmin: false
            );
            */

            return Ok(new
            {
                message = "Đã duyệt yêu cầu hoàn/trả và chuyển đơn sang trạng thái Returned.",
                order
            });
        
}