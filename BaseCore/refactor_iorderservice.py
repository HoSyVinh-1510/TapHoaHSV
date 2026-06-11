import re

def process():
    svc_path = r'd:\FW-Test\FW-test\BaseCore\BaseCore.Services\OrderService.cs'
    isvc_path = r'd:\FW-Test\FW-test\BaseCore\BaseCore.Services\IOrderService.cs'
    
    with open(svc_path, 'r', encoding='utf-8') as f:
        content = f.read()

    method_pattern = re.compile(r'public async Task<ServiceResult> (\w+Async)\((.*?)\)')
    
    methods = []
    for match in method_pattern.finditer(content):
        methods.append(f'        Task<ServiceResult> {match.group(1)}({match.group(2)});')
        
    isvc_content = '''using BaseCore.DTO;
using BaseCore.Services.Models;
using System.Threading.Tasks;

namespace BaseCore.Services
{
    public interface IOrderService
    {
''' + '\n'.join(methods) + '''
    }
}'''
    
    with open(isvc_path, 'w', encoding='utf-8') as f:
        f.write(isvc_content)
        
    print(f"Generated IOrderService.cs with {len(methods)} methods.")

process()
