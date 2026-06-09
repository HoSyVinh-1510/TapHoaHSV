const fs = require('fs');
const path = require('path');

const map = {
  'B\uFFFD" Lọc': 'Bộ Lọc',
  'T\uFFFD\x18i đa': 'Tối đa',
  'ch\uFFFD\x18i': 'chối',
  'cu\uFFFD\x18i': 'cuối',
  'xu\uFFFD\x18ng': 'xuống',
  '\uFFFD\x18ính': 'đính',
  '\uFFFD\x18ọc': 'đọc',
  '\uFFFD\x18ăng': 'đăng',
  'S\uFFFD" địa': 'Số địa',
  'h\uFFFD\x1Ci': 'hồi',
  'h\uFFFD\x14 trợ': 'hỗ trợ',
  'm\uFFFD\x14i': 'mỗi',
  'H\uFFFD\x1C Sỹ': 'Hồ Sỹ',
  'h\uFFFD\x1C sỹ': 'hồ sỹ',
  'G\uFFFD"p': 'Gộp',
  '\uFFFD\x1D Vui': ' Vui',
  'đ\uFFFD)': 'đ)',
  '|| "\uFFFD\x1C"': '|| ""'
};

function fixFile(filePath) {
  let content = fs.readFileSync(filePath, 'utf8');
  let original = content;
  
  for (const [wrong, right] of Object.entries(map)) {
    content = content.split(wrong).join(right);
  }

  // Fix product loading logic
  content = content.split('productApi.search').join('productApi.getAll');
  
  if (content !== original) {
    fs.writeFileSync(filePath, content, 'utf8');
    console.log('Fixed', filePath);
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
