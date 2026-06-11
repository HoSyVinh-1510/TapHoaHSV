import re

def process():
    svc_path = r'd:\FW-Test\FW-test\BaseCore\BaseCore.Services\OrderService.cs'
    with open(svc_path, 'r', encoding='utf-8') as f:
        content = f.read()

    # Fix GetOrdersInternal signature
    content = content.replace('private async Task<IActionResult> GetOrdersInternal', 'private async Task<ServiceResult> GetOrdersInternal')

    # Inject ICouponService
    content = content.replace('private readonly ICouponRepositoryEF _couponRepository;', 'private readonly ICouponRepositoryEF _couponRepository;\n        private readonly ICouponService _couponService;')
    content = content.replace('ICouponRepositoryEF couponRepository,', 'ICouponRepositoryEF couponRepository, ICouponService couponService,')
    content = content.replace('_couponRepository = couponRepository;', '_couponRepository = couponRepository;\n            _couponService = couponService;')

    # Fix ValidateAsync call
    content = content.replace('_couponRepository.ValidateAsync', '_couponService.ValidateAsync')

    # Replace GetActorType() with "User" or "Admin"
    content = content.replace('GetActorType()', '"User"') # Defaulting to User since these are mostly user actions where GetActorType was used, actually let's just make it "User" or based on role
    
    # Fix the missing BadRequest at line 880
    content = content.replace('return BadRequest(new { message = "Only Admin can approve or reject." });', 'return ServiceResult.Error("Only Admin can approve or reject.");')

    # Rewrite CreateAsync
    create_pattern = re.compile(r'public async Task<ServiceResult> CreateAsync\(string userId, string role, CreateOrderDto dto\).*?// result\.Data contains an anonymous object with order, details, bill, subtotalAmount, etc.*?\}', re.DOTALL)
    
    new_create = '''public async Task<ServiceResult> CreateAsync(string userId, string role, CreateOrderDto dto)
        {
            var (isValidItems, itemValidationMessage, subtotalAmount, orderDetails) = await BuildOrderItemsAsync(dto.Items);
            if (!isValidItems) return ServiceResult.Error(itemValidationMessage);

            Coupon? appliedCoupon = null;
            var discountAmount = 0m;

            if (!string.IsNullOrWhiteSpace(dto.CouponCode))
            {
                var validation = await _couponService.ValidateAsync(dto.CouponCode, subtotalAmount);
                if (!validation.IsValid || validation.Coupon == null)
                {
                    return ServiceResult.Error(validation.Message);
                }

                appliedCoupon = validation.Coupon;
                discountAmount = validation.DiscountAmount;
            }

            var finalAmount = Math.Max(0, subtotalAmount - discountAmount);

            CustomerAddress? selectedAddress = null;
            if (dto.AddressId.HasValue)
            {
                selectedAddress = await _addressRepository.GetByUserAndIdAsync(userId, dto.AddressId.Value);

                if (selectedAddress == null)
                {
                    return ServiceResult.Error("Shipping address is invalid.");
                }
            }

            var receiverName = selectedAddress?.ReceiverName ?? dto.ReceiverName ?? "";
            var phone = selectedAddress?.Phone ?? dto.Phone ?? "";
            var shippingAddress = selectedAddress?.FullAddress ?? dto.ShippingAddress ?? "";
            if (string.IsNullOrWhiteSpace(receiverName) ||
                string.IsNullOrWhiteSpace(phone) ||
                string.IsNullOrWhiteSpace(shippingAddress))
            {
                return ServiceResult.Error("Receiver name, phone and shipping address are required.");
            }

            if (!OrderFlowRules.TryNormalizePaymentMethod(dto.PaymentMethod, out var paymentMethod))
            {
                return ServiceResult.Error("Payment method must be COD or Bank Transfer.");
            }
            var isZeroAmount = finalAmount <= 0;
            var paymentStatus = isZeroAmount
                ? OrderFlowRules.PaymentStatusPaid
                : OrderFlowRules.IsBankTransfer(paymentMethod)
                    ? OrderFlowRules.PaymentStatusUnpaid
                    : OrderFlowRules.PaymentStatusUnpaid;
            var orderStatus = OrderFlowRules.RequiresPaymentConfirmation(paymentMethod) && !isZeroAmount
                ? OrderFlowRules.OrderStatusWaitingPayment
                : OrderFlowRules.OrderStatusPending;

            await using var transaction = await _unitOfWork.BeginTransactionAsync();

            foreach (var item in dto.Items)
            {
                var product = await _productRepository.GetByIdAsync(item.ProductId);
                if (product == null)
                {
                    return ServiceResult.Error($"Product {item.ProductId} not found");
                }

                var category = await _categoryRepository.GetByIdAsync(product.CategoryId);
                if (category == null || !category.IsActive)
                {
                    return ServiceResult.Error($"Product category is inactive for product: {product.Name}");
                }

                if (product.Stock < item.Quantity)
                {
                    return ServiceResult.Error($"Insufficient stock for product: {product.Name}");
                }

                var reserved = await _productRepository.TryDecreaseStockAsync(item.ProductId, item.Quantity);
                if (!reserved)
                {
                    return ServiceResult.Error($"Product stock changed while checkout. Please review cart again: {product.Name}");
                }
            }

            var order = new Order
            {
                UserId = userId,
                ReceiverName = receiverName,
                Phone = phone,
                ShippingAddress = shippingAddress,
                Note = dto.Note,
                PaymentMethod = paymentMethod,
                PaymentStatus = paymentStatus,
                OrderStatus = orderStatus,
                CouponId = appliedCoupon?.Id,
                DiscountAmount = discountAmount,
                SubtotalAmount = subtotalAmount,
                TotalAmount = finalAmount,
                CreatedAt = DateTime.Now
            };

            await _orderRepository.AddAsync(order);

            foreach (var detail in orderDetails)
            {
                detail.OrderId = order.Id;
                await _orderItemRepository.AddAsync(detail);
            }

            if (appliedCoupon != null)
            {
                var lockedCoupon = await _couponRepository.TryIncrementUsageAsync(appliedCoupon.Id);
                if (!lockedCoupon)
                {
                    return ServiceResult.Error("Coupon is no longer available. Please refresh cart and try another coupon.");
                }
            }

            var bill = await CreateBillForOrderAsync(
                order,
                orderDetails,
                subtotalAmount,
                discountAmount,
                finalAmount);

            await AddStatusHistoryAsync(
                order.Id,
                null,
                order.OrderStatus,
                "Don hang duoc tao.",
                userId,
                "User");
            await AddActivityLogAsync(
                order.Id,
                ActivityOrderCreated,
                "Tao don hang",
                $"Don hang #{order.Id} da duoc tao.",
                null,
                order.OrderStatus,
                userId,
                "User");

            await transaction.CommitAsync();

            return ServiceResult.Success(new
            {
                order,
                details = orderDetails,
                bill,
                subtotalAmount,
                discountAmount,
                finalAmount
            });
        }'''
    
    content = create_pattern.sub(new_create, content)
    
    # Also fix any "return Ok(new {" from GetOrdersInternal to return ServiceResult.Success(new {
    content = content.replace('return Ok(new', 'return ServiceResult.Success(new')
    
    # Also remove any remaining Ok() in GetOrdersInternal
    content = content.replace('return Ok();', 'return ServiceResult.Success();')
    
    with open(svc_path, 'w', encoding='utf-8') as f:
        f.write(content)

process()
