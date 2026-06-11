import re

def process():
    path = r'd:\FW-Test\FW-test\BaseCore\BaseCore.Services\OrderService.cs'
    with open(path, 'r', encoding='utf-8') as f:
        content = f.read()

    # The end of the file looks like:
    #         private static string FormatTimeout(TimeSpan timeout)
    #         {
    #             return OrderFlowRules.FormatDurationVietnamese(timeout);
    #         }
    # 
    #     }
    # 
    # private async Task<ServiceResult> GetOrdersInternal(string? userId, OrderQueryDto query)
    
    # We will remove any trailing spaces and braces after FormatTimeout and just put them properly.
    format_timeout_idx = content.rfind('private static string FormatTimeout(TimeSpan timeout)')
    if format_timeout_idx != -1:
        # keep everything up to this method
        # then append GetOrdersInternal properly inside the class
        get_orders_idx = content.find('private async Task<ServiceResult> GetOrdersInternal', format_timeout_idx)
        if get_orders_idx != -1:
            # We have both methods. Let's extract GetOrdersInternal body.
            get_orders_body = content[get_orders_idx:]
            # strip any trailing outer braces from get_orders_body
            get_orders_body = get_orders_body.rstrip().rstrip('}').rstrip()
            
            # Now we recreate the end of the file
            # the class ends after GetOrdersInternal, so we add the final brace.
            content_before_get_orders = content[:get_orders_idx]
            # remove any extra '}' between format_timeout and get_orders
            content_before_get_orders = content_before_get_orders.replace('}\n\n    }\n\n', '}\n\n')
            content_before_get_orders = content_before_get_orders.replace('}\r\n\r\n    }\r\n\r\n', '}\r\n\r\n')
            
            final_content = content_before_get_orders + '        ' + get_orders_body + '\n    }\n}'
            
            with open(path, 'w', encoding='utf-8') as f:
                f.write(final_content)
                
process()
