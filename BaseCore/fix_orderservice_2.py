import re

def process():
    orig_path = r'd:\FW-Test\FW-test\BaseCore\original_orders_controller.cs'
    svc_path = r'd:\FW-Test\FW-test\BaseCore\BaseCore.Services\OrderService.cs'
    
    with open(orig_path, 'r', encoding='utf-16') as f:
        orig = f.read()
        
    with open(svc_path, 'r', encoding='utf-8') as f:
        svc = f.read()

    # Find GetOrdersInternal
    getorders_pattern = re.compile(r'private async Task<IActionResult> GetOrdersInternal\(string\? userId, OrderQueryDto query\).*?\}\s*\}', re.DOTALL)
    # Wait, simple brace matching is better for the whole method body.
    match = re.search(r'private async Task<IActionResult> GetOrdersInternal', orig)
    if match:
        start_idx = match.start()
        brace_count = 0
        in_method = False
        end_idx = -1
        for i in range(start_idx, len(orig)):
            if orig[i] == '{':
                brace_count += 1
                in_method = True
            elif orig[i] == '}':
                brace_count -= 1
            
            if in_method and brace_count == 0:
                end_idx = i + 1
                break
        
        getorders_body = orig[start_idx:end_idx]
        getorders_body = getorders_body.replace('Task<IActionResult>', 'Task<ServiceResult>')
        getorders_body = getorders_body.replace('return Ok(new', 'return ServiceResult.Success(new')
        
        # Remove GetOrdersInternal if it somehow partially exists
        svc = re.sub(r'private async Task<(IActionResult|ServiceResult)> GetOrdersInternal.*', '', svc, flags=re.DOTALL)
        
        svc = svc[:svc.rfind('}')] + '\n' + getorders_body + '\n}'
        
    svc = svc.replace('CouponId = appliedCoupon?.Id,', 'CouponCode = appliedCoupon?.Code ?? dto.CouponCode,')
    svc = svc.replace('SubtotalAmount = subtotalAmount,\n', '')

    svc = svc.replace('return BadRequest(new { message = "Only Admin can approve or reject." });', 'return ServiceResult.Error("Only Admin can approve or reject.");')

    with open(svc_path, 'w', encoding='utf-8') as f:
        f.write(svc)

process()
