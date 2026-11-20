const {chromium}=require('playwright');
(async()=>{const b=await chromium.launch({args:['--use-angle=swiftshader','--enable-unsafe-swiftshader','--ignore-gpu-blocklist']});
const p=await b.newPage({viewport:{width:1080,height:1920}}); p.on('console',m=>console.log('C',m.text())); p.on('pageerror',e=>console.log('E',e.message));
const {server,port}=await require('../serve.js')(require('path').resolve(__dirname,'../../../..'));await p.goto('http://localhost:'+port+'/projects/2026-11-20-knowledge-road-hug-anime/anime/test/perf.html'); await p.waitForFunction(()=>window.T&&window.T.bg,{timeout:60000});
console.log('bg ms',await p.evaluate(()=>T.bg));
for(let i=0;i<3;i++){const t=Date.now(); const d=await p.evaluate(()=>frameTest()); await p.screenshot({path:__dirname+'/perf'+i+'.png'}); console.log('frame',d,'total',Date.now()-t);}
await b.close();server.close();})();
