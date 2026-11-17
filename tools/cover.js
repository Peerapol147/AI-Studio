#!/usr/bin/env node
// Render a Short cover (1080x1920 JPG) in the channel's cover system.
// Use: node tools/cover.js <project-dir> <th|en>   (reads <project>/cover.json)
// Writes <project>/cover-<lang>.jpg and renders/<slug>-<lang>-thumb.jpg
// cover.json: {"channel":"knowledge","photo":"assets/footage/x.jpg","focus":"50% 40%","bg_transform":"translateY(300px)" (optional: push the face below the headline),
//   "sticker":{"photo":"assets/footage/y.jpg","focus":"50% 50%"},          (optional round inset)
//   "th":{"kicker":"รู้ไหม?","lines":["ไม่หิวน้ำ","แต่[ขาดน้ำ]"]}, "en":{...}}   [word] = yellow highlight
const fs=require('fs'), path=require('path'), {chromium}=require('playwright');
const [proj, lang]=process.argv.slice(2);
const root=path.resolve(__dirname,'..'), P=path.resolve(proj);
const cfg=JSON.parse(fs.readFileSync(path.join(P,'cover.json'),'utf8'));
const L=cfg[lang]; if(!L) throw new Error('no '+lang+' in cover.json');
const tpl=fs.readFileSync(path.join(root,'channels',cfg.channel||'knowledge','cover','template.html'),'utf8');
const url=f=>'file://'+path.join(P,f);
const esc=s=>s.replace(/&/g,'&amp;').replace(/</g,'&lt;');
const n=L.lines.length, max=L.max||(n>=3?150:(lang==='en'?180:170));
const lines=L.lines.map(t=>`<span class="line" data-max="${max}">${esc(t).replace(/\[(.+?)\]/g,'<span class="hl">$1</span>')}</span>`).join('');
const st=cfg.sticker?`<div class="sticker" style="top:${cfg.sticker.top||1150}px"><img src="${url(cfg.sticker.photo)}" style="object-position:${cfg.sticker.focus||'50% 50%'}"/></div>`:'';
const html=tpl.replace('%%FONTS%%','file://'+path.join(root,'assets/fonts/fonts.css')).replace('%%PHOTO%%',url(cfg.photo))
  .replace('%%FOCUS%%',cfg.focus||'50% 50%').replace('%%BGT%%',cfg.bg_transform||'none').replace('%%STICKER%%',st).replace('%%KICKER%%',esc(L.kicker)).replace('%%LINES%%',lines);
const tmp=path.join(P,`.cover-${lang}.html`); fs.writeFileSync(tmp,html);
(async()=>{
  const b=await chromium.launch(); const pg=await b.newPage({viewport:{width:1080,height:1920}});
  await pg.goto('file://'+tmp); await pg.waitForSelector('body[data-ready="1"]'); await pg.waitForTimeout(200);
  const out=path.join(P,`cover-${lang}.jpg`); await pg.screenshot({path:out,type:'jpeg',quality:88});
  await b.close(); fs.unlinkSync(tmp);
  const slug=path.basename(P).split('-').slice(4).join('-');
  fs.mkdirSync(path.join(P,'renders'),{recursive:true}); fs.copyFileSync(out,path.join(P,'renders',`${slug}-${lang}-thumb.jpg`));
  console.log(out, (fs.statSync(out).size/1024|0)+' KB');
})();
