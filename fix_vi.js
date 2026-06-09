const fs = require('fs');
const path = require('path');

const map = {
  '\uFFFD\x18ơn': 'đơn',
  '\uFFFD\x18iện': 'điện',
  '\uFFFD\x18Ồ': 'đề',
  '\uFFFD\x18ủ': 'đủ',
  '\uFFFD\x18ãi': 'đãi',
  '\uFFFD\x18ang': 'đang',
  '\uFFFD\x18ổng': 'động', // hoạt động, tự động
  'S\uFFFD\x18': 'Số',
  's\uFFFD\x18': 'số',
  't\uFFFD\x18i': 'tối', // tối đa, tối thiểu
  '\uFFFD\x18ầu': 'đầu',
  '\uFFFD\x18đánh': 'đánh',
  '\uFFFD\x18ánh': 'đánh',
  '\uFFFD\x18ịa': 'địa',
  '\uFFFD\x18ịnh': 'định',
  '\uFFFD\x18ường': 'đường',
  'ph\uFFFD\x18': 'phố',
  'tr\uFFFD\x18ng': 'trống', // để trống
  '\uFFFD\x18a': 'đa', // tối đa
  '50.000\uFFFD\x18': '50.000đ',
  '100.000\uFFFD\x18': '100.000đ',
  '200.000\uFFFD\x18': '200.000đ',
  '\uFFFD\x18)': 'đ)',
  '\uFFFD\x18 }': 'đ }',
  'T\uFFFD\x1Cn': 'Tồn',
  't\uFFFD\x1Cn': 'tồn',
  '\uFFFD\x1A': 'đ', // VND () -> VND (đ)
  'L\uFFFD\x14i': 'Lỗi',
  'l\uFFFD\x14i': 'lỗi',
  'H\uFFFD\x14': 'Hỗ',
  'lu\uFFFD\x1Cng': 'luồng',
  '\uFFFD\x18ã': 'đã',
  '\uFFFD\x18ược': 'được',
  '\uFFFD\x18ây': 'đây',
  'cu\uFFFD\x1Ci': 'cuối',
  'n\uFFFD"i': 'nội', // nội dung, nổi bật? usually nội dung
  'N\uFFFD"i': 'Nội',
  '\uFFFD\x18ầy': 'đầy',
  'mu\uFFFD\x18n': 'muốn',
  '\uFFFD\x18ặt': 'đặt',
  'th\uFFFD\x18ng': 'thống',
  '\uFFFD\x18ến': 'đến',
  'b\uFFFD"': 'bộ',
  '\uFFFDx': 'đã', // 'x' -> đã? "không x trạng thái" -> "không ở trạng thái", or "không rõ trạng thái". I will ignore x if not sure.
  'l\uFFFD!.': 'lệ.', 
  'd\uFFFD\x19ch': 'dịch',
  'M\uFFFD\x18i': 'Mỗi',
  'm\uFFFD\x18i': 'mỗi',
  'b\uFFFD\x19': 'bị',
  'T\uFFFD\x19i': 'Tải',
  't\uFFFD\x19i': 'tải',
  'v\uFFFD\x19': 'vị',
  '\uFFFD\x18iều': 'điều',
  'ki\uFFFD!n': 'kiện',
  'c\uFFFD"t': 'cột',
  'm\uFFFD"t': 'một',
  'bu\uFFFD"c': 'buộc',
  'H\uFFFD"p': 'Hộp',
  'C\uFFFD\uFFFDT': 'CỘT', // CT TRÁI -> CỘT TRÁI
  'h\uFFFD i': 'hồi', // phản hồi
  'phản h\uFFFD i': 'phản hồi', // to be safe
  'câu h\uFFFD i': 'câu hỏi',
  'h\uFFFD"i': 'hội', // trò chuyện nội bộ -> hội thoại
  '\uFFFD \uFFFD"i': 'đổi',
  '\uFFFD \uFFFD i': 'đổi', // thay đổi
  'ch\uFFFD i': 'chối', 
  'Hư\uFFFD:ng': 'Hướng',
  's\uFFFD:m': 'sớm', 
  'v\uFFFD:i': 'với', 
  'l\uFFFD9ch': 'lịch',
  'L\uFFFD9ch': 'Lịch',
  'G\uFFFD\x18i': 'Gửi',
  'g\uFFFD\x18i': 'gửi',
  'chuy\uFFFD\x18n': 'chuyển',
  'cu\uFFFD c': 'cuộc',
  'h\uFFFD  trợ': 'hỗ trợ', 
  'H\uFFFD  trợ': 'Hỗ trợ',
  't\uFFFD i thiỒu': 'tối thiểu',
  'hi\uFFFD!u': 'hiệu',
  'Hi\uFFFD!n': 'Hiện',
  'Hi\uFFFD!u': 'Hiệu',
  'Trư\uFFFD:c': 'Trước',
  'Ch\uFFFD0': 'Chỉ', 
  'Dư\uFFFD:i': 'Dưới',
  'di\uFFFD!n': 'diện', 
  'thư\uFFFD:c': 'thước', 
  '\uFFFD ính': 'đính', 
  '\uFFFD ọc': 'đọc', 
  'xu\uFFFD ng': 'xuống',
  't\uFFFD:i': 'tới',
  '\uFFFD Ēng': 'đăng',
  'm\uFFFD i': 'mọi', // mọi người? or mới? "m i trang" -> "mỗi trang"
  'm\uFFFD i trang': 'mỗi trang',
  'HiỒn thị': 'Hiển thị',
  'TĒng': 'Tăng',
  '\uFFFDánh': 'đánh',
  't\uFFFD i \uFFFD a': 'tối đa',
  'T\uFFFD i \uFFFD a': 'Tối đa',
  'li\uFFFD!u': 'liệu',
  'dữ li\uFFFD!u': 'dữ liệu',
  'T\uFFFD0nh': 'Tỉnh',
  'thành ph\uFFFD ': 'thành phố',
  'Thành ph\uFFFD ': 'Thành phố',
  '\uFFFD ể': 'để',
  'Đ\uFFFD ể': 'Để',
  '\uFFFD Ồ': 'để' // "để bắt đầu" -> " Ồ bắt  ầu". So  Ồ = để.
};

function fixFile(filePath) {
  let content = fs.readFileSync(filePath, 'utf8');
  let original = content;
  
  for (const [wrong, right] of Object.entries(map)) {
    content = content.split(wrong).join(right);
  }
  
  if (content !== original) {
    fs.writeFileSync(filePath, content, 'utf8');
    console.log('Fixed VI', filePath);
  }
}

function walk(dir) {
  const list = fs.readdirSync(dir);
  list.forEach(file => {
    file = path.join(dir, file);
    const stat = fs.statSync(file);
    if (stat && stat.isDirectory()) {
      walk(file);
    } else if (file.endsWith('.js') || file.endsWith('.jsx')) {
      fixFile(file);
    }
  });
}

walk('BaseCore/BaseCore.WebClient/src');
