const fs = require('fs');
const path = require('path');

const map = {
  'nàotification': 'notification',
  'nào': 'no' // wait, "nào" could be "thế nào" in Vietnamese. Better just do 'nàotification' and similar known broken words.
};

function fixFile(filePath) {
  let content = fs.readFileSync(filePath, 'utf8');
  let original = content;
  
  content = content.replace(/nàotification/g, 'notification');
  content = content.replace(/nàode/g, 'node');
  
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
