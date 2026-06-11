import re

def process():
    ctrl_path = r'd:\FW-Test\FW-test\BaseCore\BaseCore.APIService\Controllers\OrdersController.cs'
    svc_path = r'd:\FW-Test\FW-test\BaseCore\BaseCore.Services\OrderService.cs'
    
    with open(ctrl_path, 'r', encoding='utf-8') as f:
        content = f.read()

    # Create OrderService content
    svc_content = content
    svc_content = svc_content.replace('namespace BaseCore.APIService.Controllers', 'namespace BaseCore.Services')
    svc_content = svc_content.replace('using Microsoft.AspNetCore.Mvc;', 'using BaseCore.Services.Models;\nusing Microsoft.AspNetCore.Http;')
    svc_content = svc_content.replace('using Microsoft.AspNetCore.Authorization;', '')
    svc_content = svc_content.replace('public class OrdersController : BaseApiController', 'public class OrderService : IOrderService')
    svc_content = svc_content.replace('public OrdersController(', 'public OrderService(')
    
    # Remove controller attributes
    svc_content = re.sub(r'\[Route\(".*?"\)\]', '', svc_content)
    svc_content = re.sub(r'\[ApiController\]', '', svc_content)
    svc_content = re.sub(r'\[Authorize.*?\]', '', svc_content)
    svc_content = re.sub(r'\[HttpGet.*?\]', '', svc_content)
    svc_content = re.sub(r'\[HttpPost.*?\]', '', svc_content)
    svc_content = re.sub(r'\[HttpPut.*?\]', '', svc_content)
    svc_content = re.sub(r'\[From(Body|Query|Route)\]\s*', '', svc_content)
    
    # We will build OrderService.cs from this
    method_pattern = re.compile(r'public async Task<IActionResult> (\w+)\((.*?)\)\s*\{', re.DOTALL)
    
    # find all public methods to transform
    for match in method_pattern.finditer(svc_content):
        method_name = match.group(1)
        params = match.group(2)
        start_idx = match.end()
        
        brace_count = 1
        end_idx = -1
        for i in range(start_idx, len(svc_content)):
            if svc_content[i] == '{':
                brace_count += 1
            elif svc_content[i] == '}':
                brace_count -= 1
            if brace_count == 0:
                end_idx = i
                break
                
        if end_idx != -1:
            body = svc_content[start_idx:end_idx]
            
            # transform body
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
                if params:
                    service_params = 'string userId, string role, ' + params
                else:
                    service_params = 'string userId, string role'
            else:
                service_params = params
                
            new_header = f'public async Task<ServiceResult> {method_name}Async({service_params})'
            # replace the original header and body
            
            svc_content = svc_content[:match.start()] + new_header + '\n{' + body + svc_content[end_idx:]

    with open(svc_path, 'w', encoding='utf-8') as f:
        f.write(svc_content)
        
    print(f"Generated OrderService.cs")

process()
