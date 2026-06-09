const fs = require('fs');
const path = require('path');

const map = {
  'Ồ': 'ể',
  'Ē': 'ă'
};

function fixFile(filePath) {
  let content = fs.readFileSync(filePath, 'utf8');
  let original = content;
  
  for (const [wrong, right] of Object.entries(map)) {
    content = content.split(wrong).join(right);
  }
  
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
