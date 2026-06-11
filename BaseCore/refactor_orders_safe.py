import re

def process():
    ctrl_path = r'd:\FW-Test\FW-test\BaseCore\BaseCore.APIService\Controllers\OrdersController.cs'
    svc_path = r'd:\FW-Test\FW-test\BaseCore\BaseCore.Services\OrderService.cs'
    
    with open(ctrl_path, 'r', encoding='utf-8') as f:
        content = f.read()

    # Find where the first public method starts
    method_pattern = re.compile(r'public async Task<IActionResult> (\w+)\((.*?)\)\s*\{', re.DOTALL)
    first_match = method_pattern.search(content)
    
    header_end = first_match.start()
    
    header = content[:header_end]
    header = header.replace('namespace BaseCore.APIService.Controllers', 'namespace BaseCore.Services')
    header = header.replace('using Microsoft.AspNetCore.Mvc;', 'using BaseCore.Services.Models;\nusing Microsoft.AspNetCore.Http;')
    header = header.replace('using Microsoft.AspNetCore.Authorization;', '')
    header = header.replace('public class OrdersController : BaseApiController', 'public class OrderService : IOrderService')
    header = header.replace('public OrdersController(', 'public OrderService(')
    
    header = re.sub(r'\[Route\(".*?"\)\]', '', header)
    header = re.sub(r'\[ApiController\]', '', header)
    header = re.sub(r'\[Authorize.*?\]', '', header)
    
    public_methods = []
    private_methods_start = len(content)
    
    for match in method_pattern.finditer(content):
        method_name = match.group(1)
        params = match.group(2)
        params = re.sub(r'\[From(Body|Query|Route)\]\s*', '', params)
        
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
            
            body = re.sub(r'return BadRequest\(new\s*\{\s*message\s*=\s*(.*?)\s*\}\);', r'return ServiceResult.Error(\1);', body)
            body = re.sub(r'return NotFound\(new\s*\{\s*message\s*=\s*(.*?)\s*\}\);', r'return ServiceResult.Error(\1);', body)
            body = re.sub(r'return Unauthorized\(\);', r'return ServiceResult.Error("Unauthorized");', body)
            body = re.sub(r'return Forbid\(\);', r'return ServiceResult.Error("Forbidden");', body)
            body = re.sub(r'return Ok\((.*?)\);', r'return ServiceResult.Success(\1);', body, flags=re.DOTALL)
            body = re.sub(r'return Ok\(\);', r'return ServiceResult.Success();', body)
            body = re.sub(r'return CreatedAtAction\(.*?,\s*new\s*\{\s*id\s*=\s*.*?\}\s*,\s*(.*?)\);', r'return ServiceResult.Success(\1);', body, flags=re.DOTALL)

            if 'GetUserId()' in body or 'IsAdmin()' in body:
                body = body.replace('var userId = GetUserId();', '')
                body = body.replace('var adminUserId = GetUserId();', 'var adminUserId = userId;')
                body = body.replace('GetUserId()', 'userId')
                body = body.replace('var isAdmin = IsAdmin();', 'var isAdmin = role == "Admin";')
                body = body.replace('IsAdmin()', 'role == "Admin"')
                if params.strip():
                    service_params = 'string userId, string role, ' + params
                else:
                    service_params = 'string userId, string role'
            else:
                service_params = params
                
            public_methods.append(f'public async Task<ServiceResult> {method_name}Async({service_params})\n{{{body}\n}}')
            private_methods_start = end_idx + 1

    private_section = content[private_methods_start:]
    # Replace anything related to Ok(), BadRequest() etc in private methods just in case? No, they don't return IActionResult.
    
    with open(svc_path, 'w', encoding='utf-8') as f:
        f.write(header)
        f.write('\n\n'.join(public_methods))
        f.write(private_section)
        
    print(f"Generated OrderService.cs perfectly")

process()
