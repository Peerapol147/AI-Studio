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
/* check: 19 scenes x (radial .sc + radial .vig) = 38 "heavy overlay" elements -> black-capture warning.
   Solid scene bg, radial only on the 3 graphic shots, one shared vignette instead of one per scene */
.sc{background:var(--bg)}
#sh-then,#sh-now,#sh-orbit{background:radial-gradient(ellipse at 50% 38%,var(--bg2) 0%,var(--bg) 100%)}
.vig{display:none}
#vigAll{position:absolute;left:0;top:0;width:1080px;height:1920px;z-index:4;pointer-events:none;background:radial-gradient(ellipse at 50% 45%,rgba(0,0,0,0) 55%,rgba(0,0,0,.45) 100%)}
#ep{position:absolute;left:0;top:0;width:1080px;height:1920px;z-index:5;pointer-events:none}
#ep svg{position:absolute;left:0;top:0}
#ep .eg{opacity:0}
.ep-t{position:absolute;font-weight:900;line-height:1;white-space:nowrap;color:var(--text);
  -webkit-text-stroke:.12em var(--ink);paint-order:stroke fill;text-shadow:0 10px 0 rgba(0,0,0,.35);opacity:0}
#yr{left:0;width:1080px;top:390px;height:330px;text-align:center;transform-origin:540px 165px}
#yr span{position:absolute;left:0;width:1080px;top:0;font-size:300px;line-height:330px;transform-origin:50% 50%}
#yr span{-webkit-text-stroke:36px var(--ink);paint-order:stroke fill}
#yrA{color:var(--accent2)}
#yrB{color:var(--accent)}
#wk{left:270px;width:540px;top:780px;height:120px;text-align:center;font-size:76px;line-height:120px;-webkit-text-stroke:0;
  color:var(--ink);background:var(--accent);border-radius:60px;box-shadow:0 0 0 8px var(--ink),0 18px 40px rgba(0,0,0,.45);text-shadow:none;transform-origin:50% 50%}
#cnt{left:0;width:1080px;top:470px;height:420px;text-align:center;transform-origin:540px 210px}
#cnt .n{display:block;font-size:280px;line-height:300px}
#cnt .n b{color:var(--accent2)}
#cnt .c{display:block;font-size:110px;line-height:130px;-webkit-text-stroke:16px var(--ink);paint-order:stroke fill}
#cnt .n{-webkit-text-stroke:34px var(--ink);paint-order:stroke fill}
#smp{left:690px;top:310px;height:64px;padding:0 26px;font-size:38px;line-height:64px;-webkit-text-stroke:0;font-weight:700;text-shadow:none;
  color:var(--paneltext);background:var(--panel);border-radius:32px;box-shadow:0 0 0 4px var(--ink)}
.lbl{font-family:var(--font),sans-serif;font-weight:900;font-size:46px;fill:var(--text);stroke:var(--ink);stroke-width:12px;paint-order:stroke fill;stroke-linejoin:round}
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
<div id="vigAll"></div>
<div id="ep" data-layout-allow-overflow data-layout-allow-overlap>
<svg width="1080" height="1920" viewBox="0 0 1080 1920" data-layout-allow-overflow>
 <defs>
  <radialGradient id="gSun"><stop offset="0" style="stop-color:var(--text)"/><stop offset=".35" style="stop-color:var(--accent2)"/><stop offset="1" style="stop-color:var(--accent2);stop-opacity:0"/></radialGradient>
  <radialGradient id="gCme"><stop offset="0" style="stop-color:var(--text)"/><stop offset=".4" style="stop-color:var(--accent2)"/><stop offset="1" style="stop-color:var(--accent2);stop-opacity:0"/></radialGradient>
  <radialGradient id="gDot"><stop offset="0" style="stop-color:var(--text)"/><stop offset=".45" style="stop-color:var(--accent)"/><stop offset="1" style="stop-color:var(--accent);stop-opacity:0"/></radialGradient>
 </defs>
 <!-- sun shot: wifi going dark = "เน็ตดับ" -->
 <g id="wifi" class="eg">
  <g transform="scale(11) translate(-12 -12)" fill="none" stroke-linecap="round" stroke-linejoin="round">
   <g stroke="var(--ink)" stroke-width="3.6"><path d="M12 20h.01"/><path d="M2 8.82a15 15 0 0 1 20 0"/><path d="M5 12.859a10 10 0 0 1 14 0"/><path d="M8.5 16.429a5 5 0 0 1 7 0"/></g>
   <path id="wa0" d="M12 20h.01" stroke="var(--accent)" stroke-width="2.4"/>
   <path id="wa3" d="M2 8.82a15 15 0 0 1 20 0" stroke="var(--accent)" stroke-width="2"/>
   <path id="wa2" d="M5 12.859a10 10 0 0 1 14 0" stroke="var(--accent)" stroke-width="2"/>
   <path id="wa1" d="M8.5 16.429a5 5 0 0 1 7 0" stroke="var(--accent)" stroke-width="2"/>
   <line id="wsl" x1="3" y1="3" x2="21" y2="21" pathLength="1" stroke-dasharray="1" stroke="var(--text)" stroke-width="2.4"/>
  </g>
 </g>
 <!-- 1859 → now: poles + one telegraph wire that never cuts (sparks, battery pulled, then the icons it feeds today) -->
 <g id="wireG" class="eg">
  <g id="poles"></g>
  <path id="wire" fill="none" stroke="var(--text)" stroke-width="7" stroke-linecap="round" pathLength="1" stroke-dasharray="1"/>
  <path id="wireHot" fill="none" stroke="var(--accent2)" stroke-width="12" stroke-linecap="round" opacity="0"/>
  <g id="sparks"></g>
  <g id="pulses"></g>
  <g id="bat">
   <rect id="batSock" x="-100" y="-62" width="200" height="124" rx="22" fill="none" stroke="var(--text)" stroke-width="5" stroke-dasharray="14 12" opacity="0"/>
   <line id="batLead" x1="0" y1="60" x2="0" y2="200" stroke="var(--text)" stroke-width="7" stroke-linecap="round"/>
   <g id="batBody">
    <rect id="batFill" x="-62" y="-34" width="118" height="68" rx="8" fill="var(--accent)"/>
    <g transform="scale(9) translate(-12 -12)"><use href="#ic-battery" width="24" height="24" style="color:var(--ink)" stroke-width="3.6"/><use href="#ic-battery" width="24" height="24" style="color:var(--text)"/></g>
   </g>
  </g>
  <g id="tg">
   <g fill="none" stroke-linecap="round" stroke-linejoin="round">
    <rect x="-90" y="22" width="180" height="34" rx="8" fill="var(--panel)" stroke="var(--text)" stroke-width="8"/>
    <circle cx="-48" cy="6" r="12" fill="var(--text)"/>
    <g id="tgLever"><line x1="-48" y1="6" x2="70" y2="-14" stroke="var(--text)" stroke-width="12"/><circle cx="74" cy="-22" r="22" fill="var(--accent2)" stroke="var(--ink)" stroke-width="6"/></g>
   </g>
  </g>
  <g id="nowIc">
   <g id="ni0"><line class="drop" stroke="var(--text)" stroke-width="6"/><circle r="84" fill="var(--panel)" stroke="var(--accent)" stroke-width="7"/><g transform="scale(4.6) translate(-12 -12)"><use href="#ic-wifi" width="24" height="24" style="color:var(--accent)"/></g></g>
   <g id="ni1"><line class="drop" stroke="var(--text)" stroke-width="6"/><circle r="84" fill="var(--panel)" stroke="var(--accent)" stroke-width="7"/><g transform="scale(4.6) translate(-12 -12)"><use href="#ic-map-pin" width="24" height="24" style="color:var(--accent)"/></g><text class="lbl" y="-104" text-anchor="middle">GPS</text></g>
   <g id="ni2"><line class="drop" stroke="var(--text)" stroke-width="6"/><circle r="84" fill="var(--panel)" stroke="var(--accent)" stroke-width="7"/><g transform="scale(4.6) translate(-12 -12)"><use href="#ic-smartphone" width="24" height="24" style="color:var(--accent)"/></g></g>
   <g id="ni3"><line class="drop" stroke="var(--text)" stroke-width="6"/><circle r="84" fill="var(--panel)" stroke="var(--accent2)" stroke-width="7"/><g transform="scale(4.6) translate(-12 -12)"><use href="#ic-plug" width="24" height="24" style="color:var(--accent2)"/></g></g>
  </g>
 </g>
 <!-- orbit, seen from above: the storm crosses Earth's orbit where Earth was not yet -->
 <g id="orb" class="eg">
  <circle id="oRing" cx="540" cy="730" r="330" fill="none" stroke="var(--accent)" stroke-width="6" pathLength="1" stroke-dasharray="1" opacity=".75"/>
  <path id="oGap" fill="none" stroke="var(--accent)" stroke-width="16" stroke-linecap="round" pathLength="1" stroke-dasharray="1"/>
  <circle id="oSunG" cx="540" cy="730" r="150" fill="url(#gSun)"/>
  <circle id="oSun" cx="540" cy="730" r="62" fill="var(--accent2)" stroke="var(--ink)" stroke-width="6"/>
  <circle id="oHit" r="40" fill="none" stroke="var(--accent2)" stroke-width="8" opacity="0"/>
  <ellipse id="oCme" rx="70" ry="44" fill="url(#gCme)"/>
  <g id="oEarth"><circle r="62" fill="url(#gDot)" opacity=".6"/><circle r="30" fill="var(--accent)" stroke="var(--ink)" stroke-width="6"/><text class="lbl" x="0" y="-52" text-anchor="middle">โลก</text></g>
 </g>
</svg>
<div id="yr" class="ep-t"><span id="yrA">1859</span><span id="yrB">ตอนนี้</span></div>
<div id="wk" class="ep-t">~1 สัปดาห์</div>
<div id="cnt" class="ep-t"><span class="n">55<b>+</b></span><span class="c">ประเทศ</span></div>
<div id="smp" class="ep-t">ภาพตัวอย่าง</div>
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
// EPISODE MOTION: editor adds functions of t for the episode graphics and calls them in render()
// word times from assets/audio/words.json (character-level): shot edges come from shots-th.json via SC
const SH={}; SC.forEach(s=>SH[s.id]=s);
const Wd={yr:4.40, wire:4.45, sparkW:7.96, fire:8.68, batIn:9.76, pull:10.90, send:11.80, tgW:13.22, nowW:15.52,
  net:15.98, gps:16.48, phone:16.62, elec:17.36, gone:17.86, orbW:22.98, earthW:23.46, week:24.84, n55:30.32};
const NS='http://www.w3.org/2000/svg', mk=(tag,at,par)=>{const e=document.createElementNS(NS,tag);for(const k in at)e.setAttribute(k,at[k]);par.appendChild(e);return e;};
const hash=n=>{const x=Math.sin(n*127.1+311.7)*43758.5453;return x-Math.floor(x);};   // seeded, deterministic
const WY=880, PX=[150,540,930], SPAN=390;
const wireY=(x,sag)=>{const f=(((x-150)%SPAN)+SPAN)%SPAN/SPAN;return WY+sag*Math.sin(Math.PI*f);};
const wireD=sag=>{let d='';for(let x=-30;x<=1110;x+=15)d+=(d?'L':'M')+x+' '+wireY(x,sag).toFixed(1);return d;};
// static parts built once (not timed clips): poles, spark rays, morse pulses
const poleEls=PX.map(x=>{const g=mk('g',{},$('poles'));
  mk('line',{x1:x,y1:WY,x2:x,y2:1130,stroke:'var(--ink)','stroke-width':22,'stroke-linecap':'round'},g);
  mk('line',{x1:x,y1:WY,x2:x,y2:1130,stroke:'var(--text)','stroke-width':12,'stroke-linecap':'round'},g);
  mk('line',{x1:x-58,y1:WY+22,x2:x+58,y2:WY+22,stroke:'var(--text)','stroke-width':10,'stroke-linecap':'round'},g);
  mk('circle',{cx:x,cy:WY,r:11,fill:'var(--accent2)',stroke:'var(--ink)','stroke-width':4},g); return g;});
const rays=[]; PX.forEach((x,i)=>{for(let k=0;k<11;k++){const a=-Math.PI*(0.05+0.9*hash(i*31+k))-(k%3===0?0:0), l=60+90*hash(i*17+k*3);
  rays.push({x,i,k,a:k%4===3?Math.PI*0.15+0.7*hash(k+i):a,l,el:mk('line',{stroke:k%2?'var(--accent2)':'var(--text)','stroke-width':k%2?7:5,'stroke-linecap':'round'},$('sparks'))});}});
const MORSE=[0,1,0,0,1,1,0,1,0,0,1,0];   // 0 = dot, 1 = dash, spaced along the wire
const pulses=MORSE.map((m,k)=>({m,off:k*112,el:mk('rect',{height:16,rx:8,fill:'var(--accent)'},$('pulses'))}));
const op=(id,v)=>{$(id).style.opacity=f2(clamp(v));};
const inShot=(t,id,pad)=>t>=SH[id].a&&t<SH[id].b+(pad||0);
const fadeIO=(t,a,b)=>clamp(eio((t-a)/0.1))*(1-clamp(eio((t-b)/0.1)));
function epWifi(t){
  const s=SH.sun; if(t<s.a||t>=s.b){op('wifi',0);return;}
  const a=S(t-s.a,15,0.6), sc=0.55+0.45*a;
  $('wifi').setAttribute('transform',`translate(540 905) scale(${sc.toFixed(4)})`); op('wifi',a*1.6);
  // arcs switch off one by one, outer first, while "ดวงอาทิตย์" is said; flicker just before each goes
  [['wa3',1.58],['wa2',1.76],['wa1',1.94],['wa0',2.10]].forEach(([id,tk])=>{const fl=(t>tk-0.16&&t<tk)?0.65+0.35*Math.cos(t*70):1;
    $(id).style.opacity=f2(lerp(1,0.16,eio((t-tk)/0.12))*fl);});
  $('wsl').setAttribute('stroke-dashoffset',f2(1-eo((t-2.10)/0.18)));
}
function epYear(t){
  const y=SH.y1859, n=SH.now; if(t<y.a||t>=n.b){op('yr',0);return;}
  const a=S(t-Wd.yr,12,0.55), m=t<SH.storm.a?0:S(t-SH.storm.a,11,0.85);
  const big=(0.45+0.55*a)*(1+0.05*clamp((t-y.a)/(y.b-y.a)));
  // big year (centre Y 555) springs into a small tag at the top-left (Y ~300) and stays as the wire's date
  const sc=lerp(big,0.27,m), tx=lerp(0,-362,m), ty=lerp(0,-215,m);
  $('yr').style.transform=`translate(${f2(tx)}px,${f2(ty)}px) scale(${sc.toFixed(4)})`; op('yr',a*2);
  const f=clamp((t-Wd.nowW)/0.22);   // flip 1859 -> ตอนนี้ on "แต่ตอนนี้"
  $('yrA').style.transform=`scaleY(${f2(Math.max(0,1-2*f))})`; $('yrB').style.transform=`scaleY(${f2(Math.max(0,2*f-1))})`;
  $('yrA').style.opacity=f<0.5?'1':'0'; $('yrB').style.opacity=f>=0.5?'1':'0';
}
function epWire(t){
  const y=SH.y1859, sp=SH.spark, n=SH.now;
  let g=0; if(t>=y.a&&t<SH.storm.a+0.1) g=1-clamp(eio((t-SH.storm.a)/0.1)); if(t>=sp.a&&t<n.b) g=clamp(eio((t-sp.a)/0.1));
  op('wireG',g); if(g<=0) return;
  const sag=36*(1-eio((t-Wd.tgW)/0.5));
  $('wire').setAttribute('d',wireD(sag)); $('wireHot').setAttribute('d',wireD(sag));
  $('wire').setAttribute('stroke-dashoffset',f2(1-eo((t-Wd.wire)/0.6)));
  // poles rise from the ground with the wire, shrink away at "สมัยนั้น" (only the wire stays)
  poleEls.forEach((p,i)=>{const up=S(t-(Wd.wire+0.07*i),13,0.62), dn=1-eio((t-(Wd.tgW+0.06*i))/0.32), k=clamp(up,0,1.2)*dn;
    p.setAttribute('transform',`translate(0 ${1130*(1-k)}) scale(1 ${Math.max(0.001,k).toFixed(4)})`); p.style.opacity=f2(clamp(k*3));});
  // sparks on "ประกายไฟ": bursts at the pole tops, crackle again twice, wire glows hot
  const hot=t>=Wd.fire&&t<sp.b+0.1?(1-clamp((t-Wd.fire)/1.1))*(0.55+0.45*Math.abs(Math.sin(t*53)*Math.sin(t*31+1))):0;
  $('wireHot').setAttribute('opacity',f2(hot));
  rays.forEach(r=>{let L=0,o=0;[0,0.34,0.7].forEach((d,j)=>{const t0=Wd.fire+d+0.05*r.i; if(t>=t0&&t<t0+0.5){const u=(t-t0)/0.5;
      const sz=(j?0.6:1)*(0.6+0.4*hash(r.k+j*7)); L=r.l*sz*S(t-t0,22,0.5); o=Math.max(o,(1-u)*(j?0.8:1));}});
    const yy=wireY(r.x,sag), x2=r.x+Math.cos(r.a)*L, y2=yy+Math.sin(r.a)*L, x1=r.x+Math.cos(r.a)*L*0.35, y1=yy+Math.sin(r.a)*L*0.35;
    r.el.setAttribute('x1',f2(x1));r.el.setAttribute('y1',f2(y1));r.el.setAttribute('x2',f2(x2));r.el.setAttribute('y2',f2(y2));r.el.style.opacity=f2(o);});
  const shake=t>=Wd.fire?7*Math.exp(-(t-Wd.fire)*4)*Math.sin(t*90):0;
  $('wireG').setAttribute('transform',`translate(${f2(shake)} ${f2(shake*0.6)})`);
  // morse pulses: one bright dot runs before the fire; from the battery shot on, a dot-dash train keeps flowing
  const flowOn=t>=SH.battery.a+0.15?clamp((t-SH.battery.a-0.15)/0.3):0, bump=1+0.45*Math.exp(-Math.max(0,t-Wd.send)*5)*(t>=Wd.send?1:0);
  const x0=t>=SH.then.a?40:210;
  pulses.forEach((p,k)=>{let x,w=p.m?54:18,o=flowOn;
    if(t<SH.battery.a&&k===0&&t>=Wd.sparkW+0.05&&t<Wd.fire){x=lerp(-20,1100,eio((t-Wd.sparkW-0.05)/(Wd.fire-Wd.sparkW-0.05)));w=40;o=1;}
    else x=((t-SH.battery.a)*300+p.off)%1344-120;
    if(x<x0||x>1060) o=0;
    const yy=wireY(x,sag); p.el.setAttribute('x',f2(x-w*bump/2)); p.el.setAttribute('y',f2(yy-8*bump)); p.el.setAttribute('width',f2(w*bump));
    p.el.setAttribute('height',f2(16*bump)); p.el.style.opacity=f2(o);});
}
function epBattery(t){
  const b=SH.battery; if(t<b.a||t>=SH.then.a+0.4){op('bat',0);return;}
  const a=S(t-b.a-0.04,13,0.6), P=t>=Wd.pull?S(t-Wd.pull,10,0.55):0, out=1-clamp(eio((t-SH.then.a)/0.35));
  op('bat',clamp(a*2)*out);
  $('bat').setAttribute('transform',`translate(210 ${f2(WY-210+60*(1-a))})`);
  // pulled out on "ถอดแบต": lifts up-left and dims, a dashed socket is left; the lead to the wire stays
  $('batBody').setAttribute('transform',`translate(${f2(130*P)} ${f2(-175*P)}) rotate(${f2(14*P)})`);
  $('batBody').style.opacity=f2(1-0.55*clamp(P));
  $('batFill').setAttribute('width',f2(118*(1-0.8*clamp(P))));
  $('batSock').style.opacity=f2(clamp(P)*0.9);
  $('batLead').setAttribute('y2',f2(210-0*P));
}
function epTele(t){
  const th=SH.then, n=SH.now; if(t<th.a||t>=n.b){op('tg',0);op('nowIc',0);return;}
  const a=S(t-Wd.tgW,13,0.6), split=t>=Wd.net?eio((t-Wd.net)/0.25):0;
  const tap=12*Math.pow(Math.max(0,Math.sin(t*13)),6);
  $('tg').setAttribute('transform',`translate(540 ${WY-70}) scale(${f2(clamp(a,0,1.3)*1.25*(1-split))})`); op('tg',clamp(a*2)*(1-split));
  $('tgLever').setAttribute('transform',`rotate(${f2(tap)} -48 6)`);
  op('nowIc',t>=Wd.net?1:0);
  // the one telegraph breaks into what runs on electricity now, each on its word, all hung on the same wire
  const SX=[175,415,655,895], TI=[Wd.net,Wd.gps,Wd.phone,Wd.elec];
  SX.forEach((sx,i)=>{const m=S(t-TI[i],12,0.62), x=lerp(540,sx,clamp(m,0,1.1)), yy=WY-200, k=0.25+0.75*m;
    const glow=t>=Wd.gone?1+0.12*Math.exp(-(t-Wd.gone)*5)*Math.sin((t-Wd.gone)*30+i):1;
    const g=$('ni'+i); g.setAttribute('transform',`translate(${f2(x)} ${f2(yy+8*Math.sin(t*3+i))}) scale(${f2(Math.max(0,k*glow))})`);
    g.style.opacity=f2(clamp(m*3)); const dl=g.querySelector('.drop'); dl.setAttribute('x1',0);dl.setAttribute('x2',0);dl.setAttribute('y1',80);dl.setAttribute('y2',f2((WY-yy)/Math.max(0.3,k)));});
}
function epOrbit(t){
  const o=SH.orbit; if(t<o.a||t>=o.b){op('orb',0);return;}
  const u=clamp((t-o.a)/(o.b-o.a)); op('orb',1);
  $('orb').setAttribute('transform',`rotate(${f2(lerp(-5,3,u))} 540 730) translate(540 730) scale(${f2(lerp(0.94,1.06,eio(u)))}) translate(-540 -730)`);
  $('oRing').setAttribute('stroke-dashoffset',f2(1-eo((t-o.a)/0.3)));
  const sa=S(t-o.a,14,0.6); $('oSun').setAttribute('r',f2(62*clamp(sa,0,1.2))); $('oSunG').setAttribute('r',f2(150*clamp(sa)*(1+0.06*Math.sin(t*9))));
  const R=330, ac=-58*Math.PI/180, ae=(-96+7*u)*Math.PI/180;          // crossing point / Earth a little behind it
  const ex=540+R*Math.cos(ae), ey=730+R*Math.sin(ae), ea=S(t-o.a-0.05,13,0.6), ep=t>=Wd.earthW?1+0.25*Math.exp(-(t-Wd.earthW)*6):1;
  $('oEarth').setAttribute('transform',`translate(${f2(ex)} ${f2(ey)}) scale(${f2(clamp(ea,0,1.2)*ep)})`);
  const r=lerp(70,560,eio((t-Wd.orbW)/0.95)), cx=540+r*Math.cos(ac), cy=730+r*Math.sin(ac);
  $('oCme').setAttribute('transform',`translate(${f2(cx)} ${f2(cy)}) rotate(${f2(ac*180/Math.PI)}) scale(${f2(lerp(0.6,1.5,clamp((r-70)/490)))})`);
  $('oCme').style.opacity=f2(clamp((t-Wd.orbW)/0.08)*(1-clamp((r-480)/80)));
  const px=540+R*Math.cos(ac), py=730+R*Math.sin(ac), th=t-Wd.earthW;   // the storm reaches the orbit on "โลก"
  $('oHit').setAttribute('cx',f2(px)); $('oHit').setAttribute('cy',f2(py));
  $('oHit').setAttribute('r',f2(30+90*eo(th/0.5))); $('oHit').setAttribute('opacity',f2(th>0?1-clamp(th/0.5):0));
  // the gap Earth still had to travel = the "~1 week" (label on the next shot, on the word)
  $('oGap').setAttribute('d',`M${f2(ex)} ${f2(ey)} A${R} ${R} 0 0 1 ${f2(px)} ${f2(py)}`);
  $('oGap').setAttribute('stroke-dashoffset',f2(1-eo((t-Wd.earthW-0.1)/0.35)));
}
function epLabels(t){
  // "~1 สัปดาห์" on the word (miss shot), "55+ ประเทศ" on "ห้าสิบห้า", "ภาพตัวอย่าง" over the 2013 SOHO picture
  const m=SH.miss; if(t>=Wd.week&&t<m.b){const a=S(t-Wd.week,13,0.55); op('wk',clamp(a*2)); $('wk').style.transform=`scale(${f2(0.4+0.6*a)}) rotate(${f2(-3+1.5*Math.sin(t*2))}deg)`;} else op('wk',0);
  const c=SH.count; if(t>=Wd.n55&&t<c.b){const a=S(t-Wd.n55,11,0.5); op('cnt',clamp(a*2)); $('cnt').style.transform=`scale(${f2((0.3+0.7*a)*(1+0.04*(t-Wd.n55)))})`;} else op('cnt',0);
  const y=SH.y2012; if(t>=y.a&&t<y.b){const a=S(t-y.a,16,0.8); op('smp',a); $('smp').style.transform=`translateY(${f2(-20*(1-a))}px)`;} else op('smp',0);
}
function episode(t){ epWifi(t); epYear(t); epWire(t); epBattery(t); epTele(t); epOrbit(t); epLabels(t); }
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
