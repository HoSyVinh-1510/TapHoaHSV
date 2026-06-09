const fs = require('fs');
const path = require('path');

const words = new Set();
const classNames = new Set();

function walk(dir) {
  const list = fs.readdirSync(dir);
  list.forEach(file => {
    file = path.join(dir, file);
    const stat = fs.statSync(file);
    if (stat && stat.isDirectory()) {
      walk(file);
    } else if (file.endsWith('.js') || file.endsWith('.jsx')) {
      const content = fs.readFileSync(file, 'utf8');
      
      // find words with \uFFFD
      const matches = content.match(/[^\s"'\`]*\uFFFD[^\s"'\`]*/g);
      if (matches) {
        matches.forEach(m => words.add(m));
      }

      // find words with 'à'
      const matchesA = content.match(/[a-zA-Z]*à[a-zA-Z]*/g);
      if (matchesA) {
          matchesA.forEach(m => words.add(m));
      }
      
      // find classNames with à
      const classes = content.match(/className=(["'{][^>]*?["'}])/g);
      if (classes) {
          classes.forEach(c => {
              if (c.includes('à')) classNames.add(c);
          });
      }
    }
  });
}

walk('BaseCore/BaseCore.WebClient/src');
console.log('Words:', Array.from(words));
console.log('ClassNames:', Array.from(classNames));
