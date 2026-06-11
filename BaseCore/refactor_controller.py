import re

def process():
    ctrl_path = r'd:\FW-Test\FW-test\BaseCore\BaseCore.APIService\Controllers\OrdersController.cs'
    
    with open(ctrl_path, 'r', encoding='utf-8') as f:
        content = f.read()

    # Find where the first public method starts
    method_pattern = re.compile(r'public async Task<IActionResult> (\w+)\((.*?)\)\s*\{', re.DOTALL)
    
    methods = list(method_pattern.finditer(content))
    if not methods:
        return
        
    first_match = methods[0]
    header_end = first_match.start()
    header = content[:header_end]
    
    # Rewrite header fields and constructor
    # We find class OrdersController
    class_start = header.find('public class OrdersController')
    class_body_start = header.find('{', class_start) + 1
    
    new_header = header[:class_body_start] + '''
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
    
    new_methods = []
    
    for i, match in enumerate(methods):
        method_name = match.group(1)
        params = match.group(2)
        
        start_idx = match.end()
        brace_count = 1
        end_idx = -1
        for j in range(start_idx, len(content)):
            if content[j] == '{':
                brace_count += 1
            elif content[j] == '}':
                brace_count -= 1
            if brace_count == 0:
                end_idx = j
                break
                
        # the body in original content
        original_body = content[start_idx:end_idx]
        
        # Get parameter names
        param_names = []
        # strip attributes from params
        clean_params = re.sub(r'\[.*?\]', '', params)
        for p in clean_params.split(','):
            p = p.strip()
            if p:
                parts = p.split(' ')
                param_names.append(parts[-1])
        
        call_params = ', '.join(param_names)
        
        if 'GetUserId()' in original_body or 'IsAdmin()' in original_body:
            if call_params:
                call_params = 'GetUserId(), GetRole(), ' + call_params
            else:
                call_params = 'GetUserId(), GetRole()'
                
        # Controller method body
        method_body = f'''
            var result = await _orderService.{method_name}Async({call_params});
            if (!result.IsSuccess)
            {{
                return BadRequest(new {{ message = result.Message }});
            }}
            return result.Data == null ? Ok() : Ok(result.Data);
        '''
        
        # Include attributes and signature from original content
        if i == 0:
            signature = content[first_match.start():first_match.end()]
        else:
            prev_end = methods[i-1].end()
            # find the end of previous method's body
            p_brace_count = 1
            p_end_idx = -1
            for j in range(prev_end, len(content)):
                if content[j] == '{':
                    p_brace_count += 1
                elif content[j] == '}':
                    p_brace_count -= 1
                if p_brace_count == 0:
                    p_end_idx = j
                    break
            signature = content[p_end_idx+1:match.end()]
            
        new_methods.append(signature + '\n{' + method_body + '\n}')
        
    final_content = new_header + ''.join(new_methods) + '\n    }\n}'
    
    with open(ctrl_path, 'w', encoding='utf-8') as f:
        f.write(final_content)
        
    print(f"Refactored {len(methods)} methods in OrdersController.cs")

process()
