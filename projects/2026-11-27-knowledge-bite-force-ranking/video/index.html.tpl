<!doctype html>
<!-- GENERATED: edit index.html.tpl / episode.json / ../look.json, then run `python3 build_index.py` -->
<!-- look: %%LOOKNAME%% -->
<html lang="th"><head><meta charset="UTF-8"/><meta name="viewport" content="width=1080, height=1920"/>
<link rel="stylesheet" href="fonts/fonts.css"/>
<script src="https://cdn.jsdelivr.net/npm/gsap@3.15.0/dist/gsap.min.js"></script>
<style>
*{margin:0;padding:0;box-sizing:border-box}
html,body{width:1080px;height:1920px;overflow:hidden;background:#000}
#root{%%VARS%%}
#root{position:relative;width:1080px;height:1920px;overflow:hidden;font-family:var(--font),sans-serif;background:var(--bg)}
#stage{position:absolute;left:0;top:0;width:1080px;height:1920px;transform-origin:50% 40%}
.sc{position:absolute;left:0;top:0;width:1080px;height:1920px;overflow:hidden;opacity:0;background:radial-gradient(ellipse at 50% 38%,var(--bg2) 0%,var(--bg) 100%)}
.kb{position:absolute;left:0;top:0;width:1080px;height:1920px}
.vid{position:absolute;left:0;top:0;width:1080px;height:1920px;object-fit:cover}
.gslot{position:absolute;left:0;top:0;width:1080px;height:1920px}
.vig{position:absolute;left:0;top:0;width:1080px;height:1920px;background:radial-gradient(ellipse at 50% 45%,rgba(0,0,0,0) 55%,rgba(0,0,0,.45) 100%)}
#flash{position:absolute;left:0;top:0;width:1080px;height:1920px;background:#fff;opacity:0;z-index:40;pointer-events:none}
/* ---- hook title (Y 240-700 band); opening variants ---- */
#tshade{position:absolute;left:0;top:0;width:1080px;height:880px;opacity:0;z-index:45;
  background:linear-gradient(rgba(0,0,0,.62) 0%,rgba(0,0,0,.4) 55%,rgba(0,0,0,0) 100%)}
#title{position:absolute;left:60px;top:250px;width:960px;z-index:50;display:flex;flex-direction:column;align-items:center;gap:14px;transform-origin:50% 40%}
#title .tl{font-weight:var(--tw);line-height:1.42;white-space:nowrap;color:var(--text);text-align:center;
  -webkit-text-stroke:.15em var(--ink);paint-order:stroke fill;stroke-linejoin:round;text-shadow:0 10px 0 rgba(0,0,0,.4)}
#title em{font-style:normal;color:var(--accent)}
/* Thai: upper vowel + tone mark stack ~1.07-1.25 em above the baseline (ทั้ง, เพิ่ง). A highlight plate is an
   inline-block of line-height 1.12 so it does not hang into the next line (stomach-growl frame 0 bug) */
#title .tl em{display:inline-block;line-height:1.12;padding-top:.38em;padding-bottom:.24em}
.op-midstory #title{top:250px}
.op-midstory #title{gap:14px}
.op-midstory #title .tl{-webkit-text-stroke:0;color:var(--ink);background:var(--accent);padding:.16em 26px 0;border-radius:18px;text-shadow:none}
.op-midstory #title em{color:var(--text);-webkit-text-stroke:10px var(--ink);paint-order:stroke fill}
.op-pov #title{align-items:flex-start}
.op-pov #title .tl{text-align:left}
.kick{font-weight:var(--tw);white-space:nowrap;line-height:1}
.kick.pov{font-size:64px;color:var(--ink);background:var(--accent);padding:10px 28px;border-radius:999px;margin-bottom:10px}
/* cover layouts (frame 0 = the thumbnail) */
.cv-card #title{background:var(--panel);border-radius:44px;box-shadow:0 0 0 9px var(--ink),0 26px 60px rgba(0,0,0,.5);padding:34px 40px 40px}
.cv-card #title .tl{-webkit-text-stroke:0;color:var(--paneltext);text-shadow:none}
.cv-card #title em{color:var(--ink);background:var(--accent);padding:.38em 16px .24em;border-radius:16px}
/* midstory + card: the line already sits on an accent plate -> ink text, highlighted word inverted (accent on ink), no stroke */
.op-midstory.cv-card #title .tl{color:var(--ink)}
.op-midstory.cv-card #title em{-webkit-text-stroke:0;color:var(--accent);background:var(--ink);padding:.38em 16px .24em;border-radius:16px}
.cv-tilt #title{gap:30px;padding:0 16px}
.cv-tilt #title .tl:nth-of-type(odd){transform:rotate(-3deg)}
.cv-tilt #title .tl:nth-of-type(even){transform:rotate(2.5deg)}
.cv-tilt #title .tl em{padding:0 0 4px;background:none;border-bottom:16px solid var(--accent);color:var(--text)}
.kick.num{font-size:170px;color:var(--accent);-webkit-text-stroke:24px var(--ink);paint-order:stroke fill;text-shadow:0 14px 0 rgba(0,0,0,.4)}
/* ---- captions: centred X 510, Y ~1130-1250 (safe X 120-900 / Y 1100-1300) ---- */
#caps{position:absolute;left:0;top:0;width:1080px;height:1920px;z-index:60;pointer-events:none}
.cap{position:absolute;left:10px;width:1000px;top:1190px;height:0;text-align:center}
.cap span{position:absolute;left:0;width:1000px;bottom:-52px;display:block;font-weight:var(--cw);line-height:1.18;white-space:nowrap;transform-origin:50% 80%;color:#fff}
.cap em{font-style:normal}
.cap-stroke .cap span{-webkit-text-stroke:17px #000;paint-order:stroke fill}
.cap-stroke .cap em{color:var(--accent)}
.cap-box .cap span{left:50%;width:auto;transform-origin:50% 80%;padding:6px 30px 12px;border-radius:26px;background:var(--panel);box-shadow:0 0 0 6px var(--ink);color:var(--paneltext)}
.cap-box .cap em{color:var(--ink);background:var(--accent);padding:0 12px;border-radius:12px}
.cap-pop .cap span{-webkit-text-stroke:10px #000;paint-order:stroke fill}
.cap-pop .cap em{display:inline-block;color:var(--ink);-webkit-text-stroke:0;background:var(--accent);padding:0 18px;border-radius:16px;transform:rotate(-2deg)}
.cap-underline .cap span{-webkit-text-stroke:17px #000;paint-order:stroke fill}
.cap-underline .cap em{display:inline-block;line-height:1.05;padding-bottom:8px;border-bottom:18px solid var(--accent);border-radius:4px}
/* ---- EPISODE CSS (editor adds the episode's own graphics styles here) ---- */
.card{position:absolute;border-radius:30px;overflow:hidden;box-shadow:0 0 0 8px var(--ink),0 30px 70px rgba(0,0,0,.6);transform-origin:50% 50%}
.card img{width:100%;height:100%;object-fit:cover;display:block}
.kick.num{font-size:150px!important}
#ep{position:absolute;left:0;top:0;width:1080px;height:1920px;z-index:30;pointer-events:none}
#ep .g{position:absolute;opacity:0}
.out{-webkit-text-stroke:.14em var(--ink);paint-order:stroke fill;white-space:nowrap}
#rshade{left:0;top:0;width:1080px;height:800px;background:linear-gradient(rgba(3,20,27,.78),rgba(3,20,27,.5) 62%,rgba(3,20,27,0))}
#rank{left:60px;top:250px;width:960px;height:140px;display:flex;align-items:center;justify-content:center;gap:28px}
#rk-num{flex:none;width:136px;height:136px;border-radius:50%;background:var(--accent);color:var(--ink);font-weight:900;font-size:100px;line-height:1;
  display:flex;align-items:center;justify-content:center;box-shadow:0 0 0 8px var(--ink),0 12px 0 rgba(0,0,0,.35)}
#rk-num span{display:block;transform:translateY(-4px)}
#rk-name{font-weight:900;font-size:96px;line-height:1.4;color:var(--text)}
#count{left:60px;top:398px;width:960px;height:180px;display:flex;align-items:center;justify-content:center;gap:20px}
#cn-lbl{font-weight:700;font-size:52px;color:var(--text)}
#cn-val{font-weight:900;font-size:150px;line-height:1.2;color:var(--accent);font-variant-numeric:tabular-nums}
#cn-unit{font-weight:900;font-size:76px;color:var(--text)}
.rowc{left:0;width:1080px;display:flex;justify-content:center}
.pill{display:inline-flex;align-items:center;gap:14px;font-weight:700;font-size:52px;line-height:1.35;padding:6px 32px 10px;border-radius:999px;
  color:var(--ink);background:var(--accent);box-shadow:0 0 0 6px var(--ink),0 10px 0 rgba(0,0,0,.35);white-space:nowrap}
.pill.est{background:var(--accent2)}
.pill svg{width:54px;height:54px;flex:none}
#tag{top:592px}
#cmp{top:700px;flex-direction:column;align-items:center;gap:6px}
#cmp .pill{font-size:60px;background:var(--panel);color:var(--text);box-shadow:0 0 0 6px var(--accent),0 10px 0 rgba(0,0,0,.35)}
#cmp .pill b{color:var(--accent);font-weight:900}
.mb{position:absolute;width:78px;height:78px;border-radius:50%;background:var(--panel);box-shadow:0 0 0 5px var(--ink);color:var(--accent);display:flex;align-items:center;justify-content:center}
.mb svg{width:56px;height:56px}
#wv-chip{position:absolute;font-weight:900;font-size:64px;line-height:1.2;color:var(--accent);white-space:nowrap}
#bikes17{left:0;top:0;width:1080px;height:1920px}
#bikes10{left:0;top:690px;width:1080px;height:200px}
#bikes10 .mb{width:72px;height:72px}
#bikes10 .mb svg{width:50px;height:50px}
#no1{left:340px;top:820px;width:400px;height:220px}
#no1-t{position:absolute;left:0;top:0;width:400px;text-align:center;font-weight:900;font-size:190px;line-height:1.1;color:var(--text)}
#no1-x{position:absolute;left:30px;top:100px;width:340px;height:26px;border-radius:13px;background:var(--accent2);box-shadow:0 0 0 6px var(--ink);transform-origin:0 50%}
#no1-q{position:absolute;left:330px;top:-20px;font-weight:900;font-size:150px;color:var(--accent2)}
/* comparison bar: ONE bar that stretches across the ranks (linear kgf; the man bar stays as the reference) */
#bars{left:0;top:0;width:1080px;height:1920px}
.bar{position:absolute;border-radius:14px;box-shadow:0 0 0 5px var(--ink)}
#bm{background:rgba(255,255,255,.85)}
#bb{background:linear-gradient(90deg,var(--bg2),var(--accent))}
#bseg{border-radius:0 14px 14px 0;box-shadow:none;background:var(--accent)}
#bseg.st{background:repeating-linear-gradient(135deg,var(--accent2) 0 14px,rgba(255,181,71,.25) 14px 28px)}
.bl{position:absolute;font-weight:700;color:var(--text);white-space:nowrap;line-height:1.3}
/* guess */
.gfill{position:absolute;left:0;top:0;width:1080px;height:1920px}
.gfill > img{position:absolute;left:0;top:0;width:1080px;height:1920px;object-fit:cover}
.gr{position:absolute;left:150px;width:750px;height:112px;display:flex;align-items:center;gap:26px}
.gr .n{flex:none;width:104px;height:104px;border-radius:50%;background:var(--panel);color:var(--text);font-weight:900;font-size:70px;display:flex;align-items:center;justify-content:center;box-shadow:0 0 0 6px var(--ink)}
.gr .s{flex:1;height:96px;border-radius:24px;border:6px dashed rgba(255,255,255,.55);background:rgba(3,20,27,.45);display:flex;align-items:center;justify-content:center;font-weight:900;font-size:64px;color:rgba(255,255,255,.6)}
.gr.one .n{background:var(--accent);color:var(--ink)}
.gr.one .s{border:6px solid var(--accent);background:rgba(8,50,63,.85);color:var(--accent);font-size:84px}
/* twist: computer model */
#gx-twist_model{background:var(--ink);overflow:hidden}
#tm-grid{position:absolute;left:-120px;top:-120px;width:1320px;height:2160px;opacity:.5;
  background-image:linear-gradient(rgba(92,242,227,.16) 2px,transparent 2px),linear-gradient(90deg,rgba(92,242,227,.16) 2px,transparent 2px);background-size:60px 60px}
#tm-win{position:absolute;left:60px;top:430px;width:960px;height:560px;border-radius:24px;border:4px solid rgba(92,242,227,.6);background:rgba(4,32,43,.75)}
#tm-bar{position:absolute;left:0;top:0;width:952px;height:52px;border-bottom:3px solid rgba(92,242,227,.45);display:flex;align-items:center;gap:14px;padding-left:22px}
#tm-bar i{width:18px;height:18px;border-radius:50%;background:rgba(92,242,227,.55)}
#tm-svg{position:absolute;left:30px;top:100px;width:900px;height:360px}
#tm-scan{position:absolute;left:30px;top:70px;width:6px;height:440px;background:var(--accent);box-shadow:0 0 30px var(--accent)}
#tm-read{position:absolute;left:0;top:470px;width:952px;text-align:center;font-weight:700;font-size:46px;color:var(--accent)}
#tm-lbl{position:absolute;left:0;top:270px;width:1080px;display:flex;justify-content:center}
#tm-lbl .pill{font-size:64px}
#lbl-real,#lbl-meas{top:270px}
#lbl-real .pill,#lbl-meas .pill{font-size:66px}
#lbl-real .pill svg,#lbl-meas .pill svg{width:64px;height:64px}
#champ{left:90px;top:250px;width:900px;height:390px;border-radius:40px;background:var(--panel);box-shadow:0 0 0 8px var(--accent),0 24px 50px rgba(0,0,0,.5);
  display:flex;flex-direction:column;align-items:center;justify-content:center;gap:0}
#champ .a{font-weight:700;font-size:62px;color:var(--text);line-height:1.35}
#champ .b{font-weight:900;font-size:92px;color:var(--accent);line-height:1.35}
#champ .c{font-weight:900;font-size:76px;color:var(--text);line-height:1.3}
#btns{left:150px;top:1330px;width:750px;height:120px;display:flex;gap:50px}
.bt{flex:1;height:116px;border-radius:999px;display:flex;align-items:center;justify-content:center;gap:16px;font-weight:900;font-size:76px;color:var(--ink);box-shadow:0 0 0 7px var(--ink),0 12px 0 rgba(0,0,0,.4)}
.bt svg{width:70px;height:70px}
#bt-y{background:var(--accent)} #bt-n{background:var(--accent2)}
</style></head><body>
<div id="root" class="%%CAPSTYLE%% %%OPENING%%" data-composition-id="main" data-start="0" data-duration="%%DUR%%" data-width="1080" data-height="1920"
 data-motion-blur="on" data-motion-blur-events="on">
<svg width="0" height="0" style="position:absolute" aria-hidden="true"><defs>
%%ICONS%%
</defs></svg>
<div id="stage" data-layout-allow-overflow data-layout-allow-overlap>
<div id="scenes" data-layout-allow-overflow data-layout-allow-overlap style="position:absolute;left:0;top:0;width:1080px;height:1920px;z-index:0;isolation:isolate">
%%SCENES%%
</div>
<!-- EPISODE GRAPHICS: editor adds the episode's own layers here (charts, icons, cards); fill #g-<shot id> slots -->
<svg width="0" height="0" style="position:absolute" aria-hidden="true"><defs><symbol id="ic-moto" viewBox="0 0 24 24"><path d="m18 14-1-3"/><path d="m3 9 6 2a2 2 0 0 1 2-2h2a2 2 0 0 1 1.99 1.81"/><path d="M8 17h3a1 1 0 0 0 1-1 6 6 0 0 1 6-6 1 1 0 0 0 1-1v-.75A5 5 0 0 0 17 5"/><circle cx="19" cy="17" r="3"/><circle cx="5" cy="17" r="3"/></symbol></defs></svg>
<div id="gx-guess" class="gfill"><img src="assets/croc-open-bg.jpg" alt=""/><div class="gr" id="gr5" style="top:330px"><div class="n">5</div><div class="s">?</div></div><div class="gr" id="gr4" style="top:470px"><div class="n">4</div><div class="s">?</div></div><div class="gr" id="gr3" style="top:610px"><div class="n">3</div><div class="s">?</div></div><div class="gr" id="gr2" style="top:750px"><div class="n">2</div><div class="s">?</div></div><div class="gr one" id="gr1" style="top:890px"><div class="n">1</div><div class="s">?</div></div></div>
<div id="gx-r5_human" class="gfill"><img src="assets/tiger-bg.jpg" alt=""/></div>
<div id="gx-twist_model" class="gfill"><div id="tm-grid"></div>
 <div id="tm-lbl"><span class="pill"><svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><use href="#ic-cpu"/></svg>คำนวณจากโมเดลในคอม</span></div>
 <div id="tm-win"><div id="tm-bar"><i></i><i></i><i></i></div>
  <svg id="tm-svg" viewBox="0 0 900 360" fill="none" stroke-linecap="round" stroke-linejoin="round">
   <defs><clipPath id="tm-clip"><path d="M40,200 C110,150 250,124 410,120 L492,34 L540,122 C640,126 735,146 796,172 L880,86 L858,196 L888,300 L798,230 C735,254 640,272 545,276 L522,334 L470,278 C330,280 200,266 118,246 C80,236 52,220 40,200 Z"/></clipPath></defs>
   <g id="tm-mesh" clip-path="url(#tm-clip)" stroke="rgba(92,242,227,.5)" stroke-width="2"><line x1="0" y1="40" x2="900" y2="40"/><line x1="0" y1="64" x2="900" y2="64"/><line x1="0" y1="88" x2="900" y2="88"/><line x1="0" y1="112" x2="900" y2="112"/><line x1="0" y1="136" x2="900" y2="136"/><line x1="0" y1="160" x2="900" y2="160"/><line x1="0" y1="184" x2="900" y2="184"/><line x1="0" y1="208" x2="900" y2="208"/><line x1="0" y1="232" x2="900" y2="232"/><line x1="0" y1="256" x2="900" y2="256"/><line x1="0" y1="280" x2="900" y2="280"/><line x1="0" y1="304" x2="900" y2="304"/><line x1="0" y1="328" x2="900" y2="328"/><line x1="40" y1="0" x2="40" y2="360"/><line x1="76" y1="0" x2="76" y2="360"/><line x1="112" y1="0" x2="112" y2="360"/><line x1="148" y1="0" x2="148" y2="360"/><line x1="184" y1="0" x2="184" y2="360"/><line x1="220" y1="0" x2="220" y2="360"/><line x1="256" y1="0" x2="256" y2="360"/><line x1="292" y1="0" x2="292" y2="360"/><line x1="328" y1="0" x2="328" y2="360"/><line x1="364" y1="0" x2="364" y2="360"/><line x1="400" y1="0" x2="400" y2="360"/><line x1="436" y1="0" x2="436" y2="360"/><line x1="472" y1="0" x2="472" y2="360"/><line x1="508" y1="0" x2="508" y2="360"/><line x1="544" y1="0" x2="544" y2="360"/><line x1="580" y1="0" x2="580" y2="360"/><line x1="616" y1="0" x2="616" y2="360"/><line x1="652" y1="0" x2="652" y2="360"/><line x1="688" y1="0" x2="688" y2="360"/><line x1="724" y1="0" x2="724" y2="360"/><line x1="760" y1="0" x2="760" y2="360"/><line x1="796" y1="0" x2="796" y2="360"/><line x1="832" y1="0" x2="832" y2="360"/><line x1="868" y1="0" x2="868" y2="360"/></g>
   <path id="tm-out" d="M40,200 C110,150 250,124 410,120 L492,34 L540,122 C640,126 735,146 796,172 L880,86 L858,196 L888,300 L798,230 C735,254 640,272 545,276 L522,334 L470,278 C330,280 200,266 118,246 C80,236 52,220 40,200 Z" stroke="#5CF2E3" stroke-width="5" pathLength="1" stroke-dasharray="1 1"/>
   <path id="tm-jaw" d="M40,200 C70,214 110,222 160,222" stroke="#FFB547" stroke-width="6" pathLength="1" stroke-dasharray="1 1"/>
   <circle id="tm-eye" cx="128" cy="184" r="9" stroke="#5CF2E3" stroke-width="4"/>
  </svg>
  <div id="tm-scan"></div>
  <div id="tm-read">แรงกัด ~1,860 กก. (จากโมเดล)</div>
 </div>
</div>
<div id="ep">
 <div class="g" id="rshade"></div>
 <div class="g" id="rank"><div id="rk-num"><span id="rk-n">5</span></div><div id="rk-name" class="out">เสือโคร่ง</div></div>
 <div class="g" id="count"><div id="cn-lbl" class="out">แรงกัด</div><div id="cn-val" class="out">~0</div><div id="cn-unit" class="out">กก.</div></div>
 <div class="g rowc" id="tag"><span class="pill" id="tag-p"><svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.2" stroke-linecap="round" stroke-linejoin="round"><use id="tag-ic" href="#ic-circle-help"/></svg><span id="tag-t">ประมาณจากกะโหลก</span></span></div>
 <div class="g rowc" id="cmp"><span class="pill" id="cmp-t">เกือบ <b>2 เท่า</b> ของผู้ชาย</span></div>
 <div class="g" id="bikes10"><div class="mb" id="mt0"><svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.2" stroke-linecap="round" stroke-linejoin="round"><use href="#ic-moto"/></svg></div><div class="mb" id="mt1"><svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.2" stroke-linecap="round" stroke-linejoin="round"><use href="#ic-moto"/></svg></div><div class="mb" id="mt2"><svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.2" stroke-linecap="round" stroke-linejoin="round"><use href="#ic-moto"/></svg></div><div class="mb" id="mt3"><svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.2" stroke-linecap="round" stroke-linejoin="round"><use href="#ic-moto"/></svg></div><div class="mb" id="mt4"><svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.2" stroke-linecap="round" stroke-linejoin="round"><use href="#ic-moto"/></svg></div><div class="mb" id="mt5"><svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.2" stroke-linecap="round" stroke-linejoin="round"><use href="#ic-moto"/></svg></div><div class="mb" id="mt6"><svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.2" stroke-linecap="round" stroke-linejoin="round"><use href="#ic-moto"/></svg></div><div class="mb" id="mt7"><svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.2" stroke-linecap="round" stroke-linejoin="round"><use href="#ic-moto"/></svg></div><div class="mb" id="mt8"><svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.2" stroke-linecap="round" stroke-linejoin="round"><use href="#ic-moto"/></svg></div><div class="mb" id="mt9"><svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.2" stroke-linecap="round" stroke-linejoin="round"><use href="#ic-moto"/></svg></div></div>
 <div class="g" id="bars"><div class="bar" id="bm"></div><div class="bar" id="bb"></div><div class="bar" id="bseg"></div>
  <div class="bl out" id="bml">ผู้ชาย ~86</div><div class="bl out" id="bbl">เสือ ~150</div></div>
 <div class="g" id="bikes17"><div class="mb" id="mb0"><svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.2" stroke-linecap="round" stroke-linejoin="round"><use href="#ic-moto"/></svg></div><div class="mb" id="mb1"><svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.2" stroke-linecap="round" stroke-linejoin="round"><use href="#ic-moto"/></svg></div><div class="mb" id="mb2"><svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.2" stroke-linecap="round" stroke-linejoin="round"><use href="#ic-moto"/></svg></div><div class="mb" id="mb3"><svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.2" stroke-linecap="round" stroke-linejoin="round"><use href="#ic-moto"/></svg></div><div class="mb" id="mb4"><svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.2" stroke-linecap="round" stroke-linejoin="round"><use href="#ic-moto"/></svg></div><div class="mb" id="mb5"><svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.2" stroke-linecap="round" stroke-linejoin="round"><use href="#ic-moto"/></svg></div><div class="mb" id="mb6"><svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.2" stroke-linecap="round" stroke-linejoin="round"><use href="#ic-moto"/></svg></div><div class="mb" id="mb7"><svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.2" stroke-linecap="round" stroke-linejoin="round"><use href="#ic-moto"/></svg></div><div class="mb" id="mb8"><svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.2" stroke-linecap="round" stroke-linejoin="round"><use href="#ic-moto"/></svg></div><div class="mb" id="mb9"><svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.2" stroke-linecap="round" stroke-linejoin="round"><use href="#ic-moto"/></svg></div><div class="mb" id="mb10"><svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.2" stroke-linecap="round" stroke-linejoin="round"><use href="#ic-moto"/></svg></div><div class="mb" id="mb11"><svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.2" stroke-linecap="round" stroke-linejoin="round"><use href="#ic-moto"/></svg></div><div class="mb" id="mb12"><svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.2" stroke-linecap="round" stroke-linejoin="round"><use href="#ic-moto"/></svg></div><div class="mb" id="mb13"><svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.2" stroke-linecap="round" stroke-linejoin="round"><use href="#ic-moto"/></svg></div><div class="mb" id="mb14"><svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.2" stroke-linecap="round" stroke-linejoin="round"><use href="#ic-moto"/></svg></div><div class="mb" id="mb15"><svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.2" stroke-linecap="round" stroke-linejoin="round"><use href="#ic-moto"/></svg></div><div class="mb" id="mb16"><svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.2" stroke-linecap="round" stroke-linejoin="round"><use href="#ic-moto"/></svg></div><div id="wv-chip" class="out">×0</div></div>
 <div class="g" id="no1"><div id="no1-t" class="out">#1</div><div id="no1-x"></div><div id="no1-q" class="out">?</div></div>
 <div class="g rowc" id="lbl-real"><span class="pill est"><svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.2" stroke-linecap="round" stroke-linejoin="round"><use href="#ic-circle-x"/></svg>ไม่ได้วัดจากตัวจริง</span></div>
 <div class="g rowc" id="lbl-meas"><span class="pill"><svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.2" stroke-linecap="round" stroke-linejoin="round"><use href="#ic-circle-check"/></svg>นับเฉพาะวัดจริง</span></div>
 <div class="g" id="champ"><div class="a">วัดจริงสูงสุด =</div><div class="b out">จระเข้น้ำเค็ม</div><div class="c">~1,670 กก.</div></div>
 <div class="g" id="btns"><div class="bt" id="bt-y"><svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.4" stroke-linecap="round" stroke-linejoin="round"><use href="#ic-circle-check"/></svg>ถูก</div><div class="bt" id="bt-n"><svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.4" stroke-linecap="round" stroke-linejoin="round"><use href="#ic-circle-x"/></svg>ผิด</div></div>
</div>
<div id="flash"></div>
</div>
<div id="tshade"></div>
<div id="title">
%%TITLE%%
</div>
<div id="caps">
%%CAPS%%
</div>
<audio id="vo" class="clip" data-start="0" data-duration="%%DUR%%" data-track-index="30" data-volume="1" src="%%VO%%"></audio>
%%MUSIC%%
</div>

<script>
/* Brainrot v3: closed-form motion, everything a function of t (seek-safe). Look (palette/font/caption/opening/
   transition) comes from look.json via CSS variables + classes. Pacing: hook/twist shots = fast camera (punchier
   push + drift + the look's transition); setup/explain/reveal/share/cta = hold the picture (slow push only). */
(function(){
const D=%%DATA%%, DUR=D.dur, CAPT=D.capt, SC=D.sc, TR=D.look.transition;
const clamp=(x,a=0,b=1)=>Math.min(b,Math.max(a,x)), lerp=(a,b,u)=>a+(b-a)*u;
const eo=x=>{x=clamp(x);return 1-Math.pow(1-x,3)}, eio=x=>{x=clamp(x);return x*x*x*(x*(6*x-15)+10)};
const S=(tau,w,z)=>{if(tau<=0)return 0; if(z<1){const wd=w*Math.sqrt(1-z*z);
  return 1-Math.exp(-z*w*tau)*(Math.cos(wd*tau)+z*w/wd*Math.sin(wd*tau));} return 1-Math.exp(-w*tau)*(1+w*tau);};
const $=id=>document.getElementById(id), f2=v=>v.toFixed(2);
const FASTB={hook:1,twist:1};
const XF=0.12;
// entry of shot s (the look's transition; fast beats always get it, hold beats get a soft 0.1 s match)
// the look's transition: inside hook/twist and wherever the beat changes; other cuts inside one beat = soft match
const kind=(s,prev)=>(s.beat==='loop')?'match':(FASTB[s.beat]||s.beat!==prev.beat)?TR:'match';
SC.forEach((s,i)=>{s.next=SC[i+1]; s.el=$('sh-'+s.id); s.kb=$('kb-'+s.id); s.el.style.zIndex=String(i+1); s.k=i?kind(s,SC[i-1]):'none';});
function sceneState(s,t){
  if(t<s.a) return null;
  const nx=s.next, end=nx?nx.a:DUR+1, u=t-s.a; let o=1,tx=0,ty=0,sc=1;
  if(s.k==='whip') tx=1080*(1-eo(u/XF)); else if(s.k==='slide') ty=1920*(1-eo(u/0.16));
  else if(s.k==='zoom'){o=eio(u/0.1); sc=1+0.3*(1-S(u,18,0.9));} else if(s.k==='match') o=eio(u/0.1);
  if(nx){ if(nx.k==='flash'){ if(t>=end) return null; }
    else { if(t>=end+(nx.k==='slide'?0.16:XF)) return null;
      if(t>=end&&nx.k==='whip') tx=-1080*eo((t-end)/XF); if(t>=end&&nx.k==='slide') ty=-480*eo((t-end)/0.16); } }
  return {o,tx,ty,sc};
}
function scenes(t){
  let fl=0;
  SC.forEach(s=>{const r=sceneState(s,t);
    if(s.k==='flash'&&t>=s.a&&t<s.a+0.067) fl=1-(t-s.a)/0.067;
    if(!r){s.el.style.opacity='0';return;}
    s.el.style.opacity=r.o.toFixed(4); s.el.style.transform=`translate(${f2(r.tx)}px,${f2(r.ty)}px) scale(${r.sc.toFixed(4)})`;
    const uu=clamp((t-s.a)/Math.max(0.3,s.b-s.a));
    if(s.beat==='hook'&&s.still){ s.kb.style.transform=`scale(${lerp(1.0,1.06,uu).toFixed(5)})`; return; }
    if(s.beat==='loop'){ s.kb.style.transform=`scale(${lerp(1.06,1.0,uu).toFixed(5)})`; return; } // ends on the frame-0 scale
    if(FASTB[s.beat]){ const k=lerp(1.04,1.12,eio(uu)), rr=lerp(0.8,-0.8,uu), dx=12*Math.sin(t*1.9+s.a), dy=9*Math.cos(t*1.4+s.a);
      s.kb.style.transform=`translate(${f2(dx)}px,${f2(dy)}px) rotate(${rr.toFixed(3)}deg) scale(${k.toFixed(5)})`; }
    else { const k=lerp(1.0,1.08,eio(uu)), dy=-18*uu, rr=lerp(-0.5,0.5,uu);  // hold: 8 % push + 1 deg drift, no cut
      s.kb.style.transform=`translateY(${f2(dy)}px) rotate(${rr.toFixed(3)}deg) scale(${k.toFixed(5)})`; }
  });
  $('flash').style.opacity=f2(clamp(fl));
}
// hook title: full from frame 0 (no fade-in), breathes, leaves at the end of the hook, springs back for the loop seam
function title(t){
  const he=D.hookEnd, back=DUR-0.3;
  let v=1; if(t>=he&&t<back) v=1-clamp((t-he)/0.12); if(t>=back) v=S(t-back,22,0.7);
  const br=1+0.02*(1-Math.cos(t*Math.PI*2/1.6));
  $('title').style.opacity=f2(clamp(v)); $('tshade').style.opacity=f2(clamp(v));
  $('title').style.transform=`scale(${(br*(0.9+0.1*clamp(v))).toFixed(4)})`;
}
// captions: spring in on the word; last chunk clears before the loop seam
const capEls=CAPT.map((s,i)=>$('c'+i).querySelector('span'));
const BOX=document.getElementById('root').classList.contains('cap-box');
function captions(t){
  let i=-1; for(let k=0;k<CAPT.length;k++) if(t>=CAPT[k]) i=k;
  if(i<0) return; const a=S(t-CAPT[i],30,0.6), fade=i===CAPT.length-1?1-clamp((t-(DUR-0.17))/0.1):1;
  capEls[i].style.opacity=f2(fade);
  const tr=`translateY(${f2(22*(1-a))}px) scale(${(0.78+0.22*a).toFixed(4)})`;
  capEls[i].style.transform=BOX?`translateX(-50%) ${tr}`:tr;
}
// EPISODE MOTION (bite-force-ranking). Word times from words.json, shot times from shots-th.json.
// Numbers = research.md "ตัวเลขที่ล็อกใช้ในคลิป" (kgf); every counter lands exactly on its value.
['guess','r5_human','twist_model'].forEach(id=>{const g=$('g-'+id), x=$('gx-'+id); if(g&&x) g.appendChild(x);});
const R=[
 {n:5,name:'เสือโคร่ง',sh:'เสือ',val:150,a:8.30,na:9.30,c0:12.88,c1:13.40,tag:'ประมาณจากกะโหลก',ta:11.10,est:1,e:16.44},
 {n:4,name:'ไฮยีนา',sh:'ไฮยีนา',val:460,a:16.52,na:17.40,c0:20.20,c1:21.06,tag:'วัดได้ 1 ตัว',ta:18.70,est:1,e:22.10},
 {n:3,name:'อัลลิเกเตอร์',sh:'อัลลิเกเตอร์',val:960,a:22.18,na:23.26,c0:25.20,c1:26.08,tag:'วัดจริง',ta:24.68,est:0,e:27.12},
 {n:2,name:'จระเข้น้ำเค็ม',sh:'จระเข้',val:1670,a:27.20,na:28.24,c0:31.36,c1:32.38,tag:'วัดจริง',ta:30.88,est:0,e:33.44},
 {n:1,name:'ฉลามขาว',sh:'ฉลามขาว',val:1860,a:33.52,na:34.62,c0:36.42,c1:37.38,tag:'ประมาณจากโมเดล',ta:36.14,est:1,e:38.34}];
const MAN=86, fmt=v=>Math.round(v).toLocaleString('en-US');
const win=(t,a,b,fi=0.15,fo=0.15)=>clamp(Math.min((t-a)/fi,(b-t)/fo));
const show=(el,o,tr)=>{el.style.opacity=f2(clamp(o)); if(tr!==undefined) el.style.transform=tr;};
const pop=(t,a)=>t<a?0:S(t-a,20,0.55);           // spring 0 -> 1 with overshoot
const setTxt=(el,s)=>{if(el.textContent!==s) el.textContent=s;};
// value of the bar/counter at t: holds, then eases from the previous rank's value to this one while the number is spoken
function kgf(t){
  let v=0;
  for(const r of R){ if(t<r.c0) break; v=lerp(v,r.val,eio((t-r.c0)/(r.c1-r.c0))); }
  if(t>=42.34) v=lerp(1860,1670,S(t-42.34,12,0.75));    // "ถ้านับแค่ที่วัดจริง": the model-only part drops away
  return v;
}
const rankAt=t=>{let k=-1; R.forEach((r,i)=>{if(t>=r.a) k=i;}); return k;};
// still cards: second parallax layer over the blurred backdrop (frame 0 / last frame = identity)
const CARDS=SC.map(s=>({s,el:$('cd-'+s.id)})).filter(c=>c.el);
function cards(t){
  CARDS.forEach(({s,el})=>{ if(t<s.a-0.05||t>s.b+0.2) return;
    const u=clamp((t-s.a)/Math.max(0.3,s.b-s.a)), p=s.beat==='loop'?1-u:u, rot=(s.beat==='hook'||s.beat==='loop')?0:(p-0.5)*1.4;
    el.style.transform=`translateY(${f2(-26*p)}px) rotate(${rot.toFixed(3)}deg) scale(${(1+0.06*p).toFixed(4)})`; });
}
function hookGfx(t){
  // 17 motorbikes drop in one by one on "รถเวฟสิบเจ็ดคัน กดลงมา" (1.96 -> 2.96), count stops at 17
  const vis=win(t,1.9,3.72,0.05,0.15);
  show($('bikes17'),vis);
  let landed=0;
  for(let k=0;k<17;k++){ const row=Math.floor(k/6), col=k%6, ta=1.96+k*0.0588;
    const x=540+(col-2.5)*118-39, y=836+row*92, a=pop(t,ta); if(t>=ta+0.08) landed++;
    $('mb'+k).style.left=x+'px'; $('mb'+k).style.top=y+'px';
    $('mb'+k).style.opacity=f2(clamp((t-ta)/0.05));
    $('mb'+k).style.transform=`translateY(${f2(-260*(1-a))}px) scale(${(0.6+0.4*clamp(a,0,1.2)).toFixed(3)})`; }
  const ch=$('wv-chip'); ch.style.left=(540+(5-2.5)*118-50)+'px'; ch.style.top=(836+2*92-2)+'px';
  setTxt(ch,'×'+landed); ch.style.transform=`scale(${(1+0.25*(landed>0?Math.exp(-((t-(1.96+(landed-1)*0.0588))*12)):0)).toFixed(3)})`;
  // "แต่ยังไม่ใช่อันดับหนึ่งนะ": #1 gets struck through + ?
  const n1=win(t,3.80,5.40,0.06,0.15);
  show($('no1'),n1,`scale(${(0.7+0.3*clamp(pop(t,3.80),0,1.15)).toFixed(3)})`);
  $('no1-x').style.transform=`rotate(-14deg) scaleX(${eo((t-4.10)/0.18).toFixed(3)})`;
  show($('no1-q'),clamp((t-4.32)/0.08),`rotate(${(12*Math.sin(t*7)).toFixed(2)}deg) scale(${(0.6+0.4*clamp(pop(t,4.32),0,1.2)).toFixed(3)})`);
}
function guessGfx(t){
  if(t<5.3||t>8.4) return;
  [5,4,3,2,1].forEach((n,i)=>{ const ta=n===1?6.74:5.48+i*0.12, a=pop(t,ta), el=$('gr'+n);
    el.style.opacity=f2(clamp((t-ta)/0.08));
    el.style.transform=`translateX(${f2(-420*(1-clamp(a,0,1.2)))}px)`; });
  const q=$('gr1').querySelector('.s'); q.style.transform=`scale(${(1+0.06*Math.sin((t-6.74)*9)).toFixed(4)})`;
  $('gr1').querySelector('.s').style.boxShadow=`0 0 ${f2(20+18*Math.sin(t*9))}px var(--accent)`;
}
function rankGfx(t){
  const k=rankAt(t), on=win(t,8.30,38.34,0.08,0.12);
  show($('rshade'),Math.max(on,win(t,40.38,45.46,0.1,0.15)));
  if(k<0||on<=0){ ['rank','count','tag'].forEach(id=>show($(id),0)); return; }
  const r=R[k];
  // rank badge: one circle, the number flips (squash spring) on each "อันดับ ..."
  const fl=pop(t,r.a); setTxt($('rk-n'),String(r.n));
  show($('rank'),on);
  $('rk-num').style.transform=`scale(${(0.55+0.45*fl).toFixed(4)}) rotate(${f2(-90*(1-clamp(fl,0,1)))}deg)`;
  const nm=pop(t,r.na); setTxt($('rk-name'),r.name);
  $('rk-name').style.opacity=f2(clamp((t-r.na)/0.08)); $('rk-name').style.transform=`translateX(${f2(60*(1-nm))}px)`;
  // counter (kgf): lands exactly on the research value
  const cOn=t>=r.c0?clamp((t-r.c0)/0.1):0, v=kgf(t), done=t>=r.c1;
  show($('count'),cOn*on,`scale(${(done?1+0.12*Math.exp(-(t-r.c1)*9)*Math.cos((t-r.c1)*30):1).toFixed(4)})`);
  setTxt($('cn-val'),'~'+(done?fmt(r.val):fmt(Math.round(v/10)*10)));
  // evidence tag on every rank
  const tg=pop(t,r.ta); setTxt($('tag-t'),r.tag); $('tag-p').className='pill'+(r.est?' est':'');
  $('tag-ic').setAttribute('href',r.est?'#ic-circle-help':'#ic-circle-check');
  show($('tag'),(t>=r.ta?clamp((t-r.ta)/0.08):0)*on,`scale(${(0.6+0.4*clamp(tg,0,1.2)).toFixed(4)})`);
}
function cmpGfx(t){
  // one comparison chip, its text changes: tiger ~2x man, hyena ~5x man, alligator ~ 10 Wave motorbikes
  let txt=null, a=0, o=0;
  if(t>=14.38&&t<16.44){txt='เกือบ <b>2 เท่า</b> ของผู้ชาย'; a=14.38; o=win(t,14.38,16.44,0.08,0.12);}
  else if(t>=21.06&&t<22.10){txt='<b>≈5 เท่า</b>แรงกัดผู้ชาย'; a=21.06; o=win(t,21.06,22.10,0.08,0.12);}
  else if(t>=26.08&&t<27.12){txt='<b>≈ เวฟ 10 คัน</b>'; a=26.08; o=win(t,26.08,27.12,0.08,0.12);}
  if(txt!==null&&$('cmp-t').innerHTML!==txt) $('cmp-t').innerHTML=txt;
  $('cmp').style.top=(t>=26?790:700)+'px';
  show($('cmp'),o,`scale(${(0.6+0.4*clamp(pop(t,a),0,1.2)).toFixed(4)})`);
  const b10=win(t,25.9,27.12,0.05,0.12); show($('bikes10'),b10);
  for(let k=0;k<10;k++){ const ta=25.9+k*0.035, e=$('mt'+k), pp=pop(t,ta);
    e.style.left=(540+(k-4.5)*84-36)+'px'; e.style.top='0px';
    e.style.opacity=f2(clamp((t-ta)/0.05)); e.style.transform=`translateY(${f2(-120*(1-clamp(pp,0,1.2)))}px)`; }
}
function barGfx(t){
  const o=win(t,12.24,45.46,0.2,0.2); show($('bars'),o);
  if(o<=0) return;
  // m = 1 on r5_human: the same bars zoom up to the middle (man ~86 vs tiger ~150), then return to the track
  const m=clamp(S(t-14.14,13,0.8)*(1-S(t-16.44,13,0.8)),0,1.08);
  const ppk=lerp(770/1860,3.0,m), x0=lerp(130,120,m);
  const v=kgf(t); let r=R[0]; R.forEach(q=>{if(t>=q.c0) r=q;});   // the animal whose value the bar shows
  const yM=lerp(1336,830,m), hM=lerp(22,72,m), yB=lerp(1368,935,m), hB=lerp(44,110,m);
  const land=R.find(q=>t>=q.c1&&t<q.c1+0.6), wob=land?1+0.04*Math.exp(-(t-land.c1)*8)*Math.sin((t-land.c1)*28):1;
  const wMain=Math.max(0,Math.min(v,1670))*ppk*wob, wSeg=Math.max(0,v-1670)*ppk*wob;
  const bm=$('bm'), bb=$('bb'), bs=$('bseg');
  Object.assign(bm.style,{left:x0+'px',top:yM+'px',height:hM+'px',width:f2(MAN*ppk)+'px'});
  Object.assign(bb.style,{left:x0+'px',top:yB+'px',height:hB+'px',width:f2(Math.max(v>0?8:0,wMain))+'px',opacity:v>0?'1':'0'});
  bb.style.borderRadius=wSeg>1?'14px 0 0 14px':'14px';
  Object.assign(bs.style,{left:f2(x0+wMain)+'px',top:yB+'px',height:hB+'px',width:f2(wSeg)+'px',opacity:wSeg>1?'1':'0'});
  bs.className='bar'+(t>=40.46?' st':'');
  // labels: right of each bar (bigger while zoomed)
  const fs=lerp(40,64,m), bml=$('bml'), bbl=$('bbl');
  Object.assign(bml.style,{left:f2(x0+MAN*ppk+18)+'px',top:f2(yM+hM/2-fs*0.7)+'px',fontSize:f2(fs)+'px'});
  const nm=t>=42.34?'จระเข้ ~1,670 (วัดจริง)':(r.sh+' ~'+(v>=r.val-0.5&&t>=r.c1?fmt(r.val):fmt(Math.round(v/10)*10)));
  setTxt(bml,'ผู้ชาย ~86'); setTxt(bbl,v>0?nm:'');
  const wAll=wMain+wSeg, inside=wAll>560&&m<0.1;
  const fs2=lerp(40,72,m);
  Object.assign(bbl.style,{fontSize:f2(fs2)+'px',top:f2(yB+hB/2-fs2*0.68)+'px'});
  if(inside){ bbl.style.left=f2(x0+18)+'px'; } else bbl.style.left=f2(x0+wAll+18)+'px';
}
function twistGfx(t){
  if(t>=38.2&&t<=40.6){ const u=t-38.34;
    $('tm-grid').style.transform=`translate(${f2((u*40)%60)}px,${f2((u*25)%60)}px)`;
    $('tm-out').style.strokeDashoffset=(1-eio(u/0.9)).toFixed(4);
    $('tm-jaw').style.strokeDashoffset=(1-eio((u-0.6)/0.4)).toFixed(4);
    $('tm-mesh').style.opacity=f2(clamp((u-0.3)/0.6)*(0.75+0.25*Math.sin(u*14)));
    $('tm-scan').style.transform=`translateX(${f2(892*((u*0.8)%1))}px)`;
    $('tm-read').style.opacity=f2(clamp((u-0.62)/0.15)*(t<39.3?(Math.sin(u*40)>0?1:0.3):1));
    $('tm-win').style.transform=`scale(${(0.94+0.06*S(u,12,0.8)).toFixed(4)})`;
    $('tm-lbl').style.transform=`scale(${(0.6+0.4*clamp(pop(t,38.42),0,1.2)).toFixed(4)})`;
    $('tm-svg').style.transform=`translateX(${f2(-14*u)}px) rotate(${f2(-1+u)}deg)`; }
  show($('lbl-real'),win(t,40.46,42.26,0.06,0.1),`scale(${(0.6+0.4*clamp(pop(t,40.46),0,1.2)).toFixed(4)})`);
  show($('lbl-meas'),win(t,42.34,43.66,0.06,0.1),`scale(${(0.6+0.4*clamp(pop(t,42.34),0,1.2)).toFixed(4)})`);
  const ch=pop(t,43.74);
  show($('champ'),win(t,43.74,45.46,0.06,0.12),`translateY(${f2(-12*Math.sin((t-43.74)*2.2))}px) scale(${(0.5+0.5*clamp(ch,0,1.15)).toFixed(4)})`);
}
function ctaGfx(t){
  const o=win(t,45.54,48.06,0.06,0.1); show($('btns'),o);
  const py=pop(t,45.6), pn=pop(t,45.78);
  const hy=t>=47.08?1+0.14*Math.exp(-(t-47.08)*6)*Math.cos((t-47.08)*20):1, hn=t>=47.94?1+0.14*Math.exp(-(t-47.94)*6)*Math.cos((t-47.94)*20):1;
  const br=1+0.025*Math.sin(t*6);
  $('bt-y').style.transform=`scale(${((0.4+0.6*clamp(py,0,1.2))*hy*br).toFixed(4)})`;
  $('bt-n').style.transform=`scale(${((0.4+0.6*clamp(pn,0,1.2))*hn/br).toFixed(4)})`;
}
function episode(t){ cards(t); hookGfx(t); guessGfx(t); rankGfx(t); cmpGfx(t); barGfx(t); twistGfx(t); ctaGfx(t); }
function render(t){ scenes(t); title(t); captions(t); episode(t); }
const proxy={_t:0}; Object.defineProperty(proxy,'t',{get(){return this._t;},set(v){this._t=v;render(v);}});
const tl=gsap.timeline({paused:true});
tl.to(proxy,{t:%%DUR%%,duration:%%DUR%%,ease:'none'},0);
render(0);
if(document.fonts&&document.fonts.ready)document.fonts.ready.then(()=>render(proxy._t));
window.__timelines=window.__timelines||{}; window.__timelines["main"]=tl;
})();
</script>
</body></html>
