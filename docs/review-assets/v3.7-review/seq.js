const {chromium}=require('playwright'); const fs=require('fs'),path=require('path');
const [,,file,out,a,b,step]=process.argv;
(async()=>{fs.mkdirSync(out,{recursive:true});
 let h=fs.readFileSync(file,'utf8').replace(/<script src="https:\/\/cdn.jsdelivr.net\/npm\/gsap[^"]*"><\/script>/,`<script src="file://${process.env.GSAP}"></script>`);
 const tmp=file.replace('.html','._s.html'); fs.writeFileSync(tmp,h);
 const br=await chromium.launch(); const p=await br.newPage({viewport:{width:1080,height:1920},deviceScaleFactor:0.25});
 await p.goto('file://'+tmp,{waitUntil:'domcontentloaded'}); await p.waitForFunction(()=>window.__timelines&&document.fonts.status==='loaded'); await p.waitForTimeout(500);
 for(let f=Math.round(a*30);f<=Math.round(b*30);f+=+step){const t=f/30;
  await p.evaluate(t=>{window.__timelines.main.seek(t,false);document.querySelectorAll('.cap').forEach(e=>{const s=+e.dataset.start,d=+e.dataset.duration;e.style.display=(t>=s&&t<s+d)?'':'none'});},t);
  await p.screenshot({path:path.join(out,`f${String(f).padStart(4,'0')}.png`)});}
 await br.close();})();
