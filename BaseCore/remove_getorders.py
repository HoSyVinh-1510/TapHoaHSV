import re

def process():
    path = r'd:\FW-Test\FW-test\BaseCore\BaseCore.APIService\Controllers\OrdersController.cs'
    with open(path, 'r', encoding='utf-8') as f:
        content = f.read()

    # Find the start of GetOrdersInternal
    pattern = re.compile(r'private async Task<IActionResult> GetOrdersInternal\(string\? userId, OrderQueryDto query\).*?\}\s*\}', re.DOTALL)
    
    # We can match braces to be safe
    match = re.search(r'\s*private async Task<IActionResult> GetOrdersInternal', content)
    if match:
        start_idx = match.start()
        brace_count = 0
        in_method = False
        end_idx = -1
        for i in range(match.end(), len(content)):
            if content[i] == '{':
                brace_count += 1
                in_method = True
            elif content[i] == '}':
                brace_count -= 1
            
            if in_method and brace_count == 0:
                end_idx = i + 1
                break
        
        if end_idx != -1:
            content = content[:start_idx] + content[end_idx:]
            
            with open(path, 'w', encoding='utf-8') as f:
                f.write(content)

process()
