// static server rooted at the project folder (so fonts/audio reachable via ../../../assets)
const http=require('http'),fs=require('fs'),path=require('path');
const types={'.html':'text/html; charset=utf-8','.js':'text/javascript; charset=utf-8','.json':'application/json','.css':'text/css','.woff2':'font/woff2','.png':'image/png'};
module.exports=(root)=>new Promise(res=>{const s=http.createServer((q,r)=>{const f=path.join(root,decodeURIComponent(q.url.split('?')[0]));
 fs.readFile(f,(e,d)=>{if(e){r.writeHead(404);r.end();return;} r.writeHead(200,{'Content-Type':types[path.extname(f)]||'application/octet-stream'});r.end(d);});});
 s.listen(0,()=>res({server:s,port:s.address().port}));});
