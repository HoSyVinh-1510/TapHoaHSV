const fs = require('fs');
const path = require('path');

const map = {
  'msgửid': 'msg.id',
  'msgửimageUrl': 'msg.imageUrl',
  'zoomớin': 'zoom-in',
  'itemớid': 'item.id',
  'itemớisDefault': 'item.isDefault',
  'formớinline': 'form-inline',
  'activityLogửid': 'activityLog.id',
  'addressItemớid': 'addressItem.id',
  'addressItemớisDefault': 'addressItem.isDefault',
  'currentAdmớid': 'currentAdm.id',
  'admớid': 'adm.id',
  'admớinitial': 'adm.initial',
  'errorMsgửincludes': 'errorMsg.includes',
  'comớimage': 'col-image', // let's guess col-image or just leave it... actually, let's search for comớimage first
  'anày': 'any',
  'monàospace': 'monospace',
  ':nàot(': ':not('
};

function fixFile(filePath) {
  let content = fs.readFileSync(filePath, 'utf8');
  let original = content;
  
  for (const [wrong, right] of Object.entries(map)) {
    if (wrong === 'comớimage') continue; // skip for now
    content = content.split(wrong).join(right);
  }
  
  if (content !== original) {
    fs.writeFileSync(filePath, content, 'utf8');
    console.log('Fixed vars', filePath);
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
