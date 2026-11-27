const {chromium}=require('playwright'); const fs=require('fs'),path=require('path');
(async()=>{const b=await chromium.launch(); const p=await b.newPage({viewport:{width:1080,height:1920},deviceScaleFactor:0.5});
const out=process.argv[2]; const res=[];
for(const f of process.argv.slice(3)){ let h=fs.readFileSync(f,'utf8').replace(/<script src="https:\/\/cdn.jsdelivr.net\/npm\/gsap[^"]*"><\/script>/,`<script src="file://${process.env.GSAP}"></script>`);
 const tmp=f.replace('.html','._r.html'); fs.writeFileSync(tmp,h);
 await p.goto('file://'+tmp,{waitUntil:'domcontentloaded'}); await p.waitForFunction(()=>window.__timelines&&document.fonts.status==='loaded'); await p.waitForTimeout(500);
 await p.evaluate(()=>{window.__timelines.main.seek(0,false)});
 const m=await p.evaluate(()=>[...document.querySelectorAll('#title .tl, #title .kick')].map(e=>{const r=e.getBoundingClientRect();const fs=parseFloat(getComputedStyle(e).fontSize);return {c:e.className,fs,cx:Math.round(r.left+r.width/2),top:Math.round(r.top),bot:Math.round(r.bottom)}}));
 res.push([path.basename(f),m]);
 await p.screenshot({path:path.join(out,path.basename(f).replace('.html','.png'))}); }
console.log(JSON.stringify(res)); await b.close();})();
