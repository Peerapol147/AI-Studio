// usage: node edges.js <index.html> <step frames> <outdir> [mode]  mode=edges|plain
const {chromium}=require('playwright'); const fs=require('fs'), path=require('path');
const [,,file,stepS,out,mode='edges']=process.argv; const step=+stepS;
const GSAP=process.env.GSAP;
(async()=>{
 fs.mkdirSync(out,{recursive:true});
 let html=fs.readFileSync(file,'utf8').replace(/<script src="https:\/\/cdn.jsdelivr.net\/npm\/gsap[^"]*"><\/script>/,`<script src="file://${GSAP}"></script>`);
 if(mode==='edges') html=html.replace('</head>','<style>.sc{background:#00ff00!important}.vig,#title,#tshade,.cap,#flash{display:none!important}body,#root,#stage{background:#00ff00!important}</style></head>');
 const tmp=path.join(path.dirname(file),'_'+mode+'.html'); fs.writeFileSync(tmp,html);
 const b=await chromium.launch(); const p=await b.newPage({viewport:{width:1080,height:1920},deviceScaleFactor:0.5});
 await p.goto('file://'+tmp,{waitUntil:'domcontentloaded'}); await p.waitForFunction(()=>[...document.images].every(i=>i.complete)&&window.__timelines); await p.waitForTimeout(1500);
 const dur=await p.evaluate(()=>window.__timelines.main.duration());
 const res=[]; const N=Math.floor(dur*30);
 for(let f=0;f<=N;f+=step){ const t=f/30;
   await p.evaluate(t=>{window.__timelines.main.seek(t,false)},t);
   if(mode==='edges'){
     const buf=await p.screenshot({type:'png'}); fs.writeFileSync(path.join(out,`f${String(f).padStart(4,'0')}.png`),buf);
   } else { await p.screenshot({path:path.join(out,`f${String(f).padStart(4,'0')}.jpg`),type:'jpeg',quality:70}); }
 }
 await b.close(); console.log('frames',N, 'dur',dur);
})();
