const fs = require('fs');
const path = require('path');

const words = new Set();

function walk(dir) {
  const list = fs.readdirSync(dir);
  list.forEach(file => {
    file = path.join(dir, file);
    const stat = fs.statSync(file);
    if (stat && stat.isDirectory()) {
      walk(file);
    } else if (file.endsWith('.js') || file.endsWith('.jsx')) {
      const content = fs.readFileSync(file, 'utf8');
      const matches = content.match(/[^\s"'\`]*\uFFFD[^\s"'\`]*/g);
      if (matches) {
        matches.forEach(m => words.add(m));
      }
    }
  });
}

walk('BaseCore/BaseCore.WebClient/src');
console.log(Array.from(words).join('\n'));
