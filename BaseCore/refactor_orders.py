import re

def process():
    ctrl_path = r'd:\FW-Test\FW-test\BaseCore\BaseCore.APIService\Controllers\OrdersController.cs'
    with open(ctrl_path, 'r', encoding='utf-8') as f:
        content = f.read()
    
    service_methods = []
    
    # Remove all [FromBody], [FromQuery] from method parameters
    content = re.sub(r'\[From(Body|Query|Route)\]\s*', '', content)
    
    # Match methods
    method_pattern = re.compile(r'public async Task<IActionResult> (\w+)\((.*?)\)\s*\{', re.DOTALL)
    
    for match in method_pattern.finditer(content):
        method_name = match.group(1)
        params = match.group(2)
        start_idx = match.end()
        
        brace_count = 1
        end_idx = -1
        for i in range(start_idx, len(content)):
            if content[i] == '{':
                brace_count += 1
            elif content[i] == '}':
                brace_count -= 1
            if brace_count == 0:
                end_idx = i
                break
                
        if end_idx != -1:
            body = content[start_idx:end_idx]
            
            # transform body
            body = re.sub(r'return BadRequest\(new\s*\{\s*message\s*=\s*(.*?)\s*\}\);', r'return ServiceResult.Error(\1);', body)
            body = re.sub(r'return NotFound\(new\s*\{\s*message\s*=\s*(.*?)\s*\}\);', r'return ServiceResult.Error(\1);', body)
            body = re.sub(r'return Unauthorized\(\);', r'return ServiceResult.Error("Unauthorized");', body)
            body = re.sub(r'return Forbid\(\);', r'return ServiceResult.Error("Forbidden");', body)
            body = re.sub(r'return Ok\((.*?)\);', r'return ServiceResult.Success(\1);', body)
            body = re.sub(r'return Ok\(\);', r'return ServiceResult.Success();', body)
            body = re.sub(r'return CreatedAtAction\(.*?,\s*new\s*\{\s*id\s*=\s*.*?\}\s*,\s*(.*?)\);', r'return ServiceResult.Success(\1);', body, flags=re.DOTALL)

            
            if 'GetUserId()' in body:
                body = body.replace('var userId = GetUserId();', '')
                body = body.replace('var adminUserId = GetUserId();', 'var adminUserId = userId;')
                body = body.replace('GetUserId()', 'userId')
                if params:
                    service_params = 'string userId, ' + params
                else:
                    service_params = 'string userId'
            else:
                service_params = params
                
            service_method = f'public async Task<ServiceResult> {method_name}Async({service_params})\n{{{body}\n}}'
            service_methods.append(service_method)

    with open('methods_extracted.cs', 'w', encoding='utf-8') as f:
        f.write('\n\n'.join(service_methods))
        
    print(f"Extracted {len(service_methods)} methods into methods_extracted.cs")

process()
