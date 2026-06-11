import re
import sys

def main():
    file_path = r'd:\FW-Test\FW-test\BaseCore\BaseCore.APIService\Controllers\OrdersController.cs'
    with open(file_path, 'r', encoding='utf-8') as f:
        content = f.read()

    # Find the Create method boundaries
    start_pattern = r'public async Task<IActionResult> Create\(\[FromBody\] CreateOrderDto dto\)'
    start_match = re.search(start_pattern, content)
    if not start_match:
        print("Create method not found.")
        return

    start_idx = start_match.start()
    
    # Simple brace matching to find the end of the method
    brace_count = 0
    in_method = False
    end_idx = -1
    for i in range(start_idx, len(content)):
        if content[i] == '{':
            brace_count += 1
            in_method = True
        elif content[i] == '}':
            brace_count -= 1
        
        if in_method and brace_count == 0:
            end_idx = i + 1
            break
            
    if end_idx == -1:
        print("Could not find end of Create method.")
        return

    original_method = content[start_idx:end_idx]
    
    new_method = '''public async Task<IActionResult> Create([FromBody] CreateOrderDto dto)
        {
            var userId = GetUserId();
            if (string.IsNullOrEmpty(userId)) return Unauthorized();

            var result = await _orderService.CreateOrderAsync(userId, dto);
            if (!result.IsSuccess) return BadRequest(new { message = result.Message });

            // result.Data contains an anonymous object with order, details, bill, subtotalAmount, etc.
            var data = (dynamic)result.Data;
            return CreatedAtAction(nameof(GetById), new { id = data.order.Id }, result.Data);
        }'''
        
    new_content = content[:start_idx] + new_method + content[end_idx:]
    with open(file_path, 'w', encoding='utf-8') as f:
        f.write(new_content)
    
    print("Replaced Create method in OrdersController.cs")

if __name__ == '__main__':
    main()
