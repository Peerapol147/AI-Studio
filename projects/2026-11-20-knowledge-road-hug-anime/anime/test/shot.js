const {chromium}=require('playwright');const path=require('path');
(async()=>{const [,,page,out,w,h]=process.argv;const b=await chromium.launch({args:['--use-angle=swiftshader','--enable-unsafe-swiftshader','--ignore-gpu-blocklist']});
const {server,port}=await require('../serve.js')(path.resolve(__dirname,'../../../..'));
const p=await b.newPage({viewport:{width:+w||600,height:+h||600}}); p.on('pageerror',e=>console.log('E',e.message.slice(0,200)));p.on('console',m=>{if(m.type()==='error'||m.text().startsWith('LOG'))console.log('C',m.text().slice(0,300))});
await p.goto(`http://localhost:${port}/projects/2026-11-20-knowledge-road-hug-anime/anime/${page}`);await p.waitForFunction(()=>window.done,{timeout:90000});
await p.screenshot({path:out});await b.close();server.close();})();
