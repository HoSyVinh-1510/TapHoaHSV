import re

def process():
    orig_path = r'd:\FW-Test\FW-test\BaseCore\original_orders_controller.cs'
    ctrl_path = r'd:\FW-Test\FW-test\BaseCore\BaseCore.APIService\Controllers\OrdersController.cs'
    
    with open(orig_path, 'r', encoding='utf-8') as f:
        content = f.read()

    # Find the class definition to get everything before it
    class_match = re.search(r'public class OrdersController.*?\n\s*\{', content)
    header = content[:class_match.end()]
    
    header += '''
        private readonly IOrderService _orderService;

        public OrdersController(IOrderService orderService)
        {
            _orderService = orderService;
        }

        private string? GetUserId()
        {
            return User.FindFirst(System.Security.Claims.ClaimTypes.NameIdentifier)?.Value;
        }

        private string? GetRole()
        {
            return User.FindFirst(System.Security.Claims.ClaimTypes.Role)?.Value;
        }
'''

    methods_str = []
    
    # Use regex to find methods starting with [Http or [Authorize and ending with public async Task<IActionResult> Name(...)
    method_pattern = re.compile(r'((?:\[\w+(?:\(.*?\))?\]\s*)*)public async Task<IActionResult> (\w+)\((.*?)\)', re.DOTALL)
    
    for match in method_pattern.finditer(content):
        attrs = match.group(1).strip()
        name = match.group(2)
        params_str = match.group(3)
        
        # Build the call params
        call_params = []
        if 'GetUserId()' in content[match.end():] or 'IsAdmin()' in content[match.end():] or name in ['GetMyOrders', 'GetById', 'GetStatusHistory', 'UpdateStatus', 'SubmitBankTransfer', 'SubmitRefundTransfer', 'ConfirmRefundReceived', 'ReceiveOrder', 'CancelOrder', 'RequestReturnOrRefund', 'ResolveReturnOrRefundRequest']:
            call_params.append('GetUserId()')
            if name in ['GetMyOrders', 'GetById', 'GetStatusHistory', 'UpdateStatus', 'ConfirmRefundReceived', 'ReceiveOrder', 'CancelOrder', 'GetOpenReturnRequests', 'ResolveReturnOrRefundRequest']:
                call_params.append('GetRole()')
                
        # we actually just pass GetUserId(), GetRole() everywhere if needed, let's look at the parameters of IOrderService
        # wait, I can just read IOrderService.cs to know exactly what parameters to pass!
        pass

process()
