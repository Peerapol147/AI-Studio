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
/* ---- EPISODE CSS ---- */
.gslot{background:url(assets/stars.png) center/cover,radial-gradient(ellipse at 50% 42%,var(--bg2) 0%,var(--bg) 72%)}
#gw{position:absolute;left:0;top:0;width:1080px;height:1920px;z-index:5;opacity:0;transform-origin:50% 50%}
#gw video,#gw canvas{position:absolute;left:0;top:0;width:1080px;height:1920px}
#eg{position:absolute;left:0;top:0;width:1080px;height:1920px;z-index:6;pointer-events:none}
.grp{position:absolute;left:0;top:0;width:1080px;height:1920px;opacity:0}
.pill{position:absolute;display:flex;align-items:center;gap:14px;white-space:nowrap;font-weight:700;line-height:1;border-radius:999px}
.ico{width:1em;height:1em;flex:none}
/* time capsule (top-left, Y 240-330) */
#tcap{position:absolute;left:56px;top:248px;height:88px;border-radius:999px;background:var(--accent);box-shadow:0 0 0 7px var(--ink),0 14px 0 rgba(0,0,0,.35);overflow:hidden;opacity:0;transform-origin:0 50%;z-index:58}
#tcap .tt{position:absolute;left:0;top:0;height:88px;display:flex;align-items:center;gap:12px;padding:0 34px;white-space:nowrap;font-weight:900;font-size:56px;line-height:1;color:var(--ink)}
#tmeas{position:absolute;left:-3000px;top:0;visibility:hidden}
#tmeas .tt{position:static;display:inline-flex;align-items:center;gap:12px;padding:0 34px;white-space:nowrap;font-weight:900;font-size:56px;line-height:1}
/* thailand marker */
#thai{position:absolute;left:0;top:0;opacity:0}
#thai .dot{position:absolute;left:-14px;top:-14px;width:28px;height:28px;border-radius:50%;background:var(--accent2);box-shadow:0 0 0 6px var(--ink)}
#thai .lab{position:absolute;left:24px;top:-74px;font-weight:900;font-size:50px;color:var(--text);-webkit-text-stroke:9px var(--ink);paint-order:stroke fill;white-space:nowrap}
/* counters */
.big{position:absolute;left:0;width:1080px;text-align:center;font-weight:900;white-space:nowrap;line-height:1;color:var(--accent);-webkit-text-stroke:.09em var(--ink);paint-order:stroke fill;text-shadow:0 12px 0 rgba(0,0,0,.4)}
.unit{font-size:.42em;color:var(--text);margin-left:.15em}
.card{position:absolute;left:90px;width:900px;border-radius:40px;background:var(--panel);box-shadow:0 0 0 8px var(--ink),0 24px 60px rgba(0,0,0,.55)}
.small{font-weight:700;color:var(--paneltext);text-align:center;white-space:nowrap;line-height:1.3}
#x4{position:absolute;left:690px;top:390px;font-weight:900;font-size:150px;line-height:1;color:var(--ink);background:var(--accent2);padding:6px 34px 14px;border-radius:32px;box-shadow:0 0 0 8px var(--ink);transform-origin:50% 50%}
#arrow{position:absolute;left:150px;top:700px;width:900px;height:240px;transform-origin:0 50%}
#arrow svg{position:absolute;left:0;top:0;width:900px;height:240px;overflow:visible}
#arrow .t{position:absolute;left:70px;top:0;height:240px;display:flex;align-items:center;font-weight:900;font-size:98px;color:var(--ink);white-space:nowrap}
.side{position:absolute;top:1296px;font-size:66px;padding:16px 36px 20px;box-shadow:0 0 0 7px var(--ink);transform-origin:50% 50%}
.side.day{background:var(--accent);color:var(--ink)}
.side.night{background:var(--panel);color:var(--text)}
#jetlab{position:absolute;left:96px;top:782px;font-size:34px;padding:12px 24px;background:rgba(16,8,10,.82);color:var(--text);border-radius:18px;font-weight:700}
#clock{position:absolute;left:290px;top:470px;width:500px;height:500px}
#mstxt{top:1280px;font-size:104px}
#mssub{top:1410px;font-size:70px;color:var(--text)}
#slowtag{left:540px;top:1300px;font-size:58px;padding:16px 34px 20px;background:var(--panel);color:var(--text);box-shadow:0 0 0 7px var(--ink)}

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
<!-- EPISODE GRAPHICS -->
<div id="gw" data-layout-allow-overflow data-layout-allow-overlap>
 <video id="v-globe" class="clip" data-start="0" data-duration="%%DUR%%" data-media-start="0" data-track-index="3" muted playsinline src="assets/globe-v.mp4"></video>
 <canvas id="glo" width="1080" height="1920"></canvas>
 <div id="thai"><div class="dot"></div><div class="lab">ไทย</div></div>
</div>
<div id="eg" data-layout-allow-overflow data-layout-allow-overlap>
 <div class="grp" id="gp-jet"><div class="pill" id="jetlab">คลื่นกระแทกจริง เมื่อเครื่องบินเร็วกว่าเสียง (NASA)</div></div>
 <div class="grp" id="gp-speedo"><div class="big" id="spd" style="top:1292px;font-size:160px">~0<span class="unit">กม./ชม.</span></div></div>
 <div class="grp" id="gp-storm">
  <div class="card" style="top:430px;height:430px"></div>
  <div class="small" style="position:absolute;left:90px;width:900px;top:472px;font-size:50px">ลมแรงสุดที่เคยวัดได้</div>
  <div class="big" id="wind" style="top:580px;font-size:190px">0<span class="unit">กม./ชม.</span></div>
  <div id="x4">×4</div>
 </div>
 <div class="grp" id="gp-east"><div id="arrow"><svg viewBox="0 0 900 240"><path d="M0 62 H640 V0 L900 120 L640 240 V178 H0 Z" fill="var(--accent)" stroke="var(--ink)" stroke-width="12" stroke-linejoin="round"/></svg><div class="t">ตะวันออก</div></div></div>
 <div class="grp" id="gp-six">
  <div class="pill side day" id="sixd" style="left:70px"><svg class="ico" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.6" stroke-linecap="round"><circle cx="12" cy="12" r="4.5" fill="currentColor"/><path d="M12 1.5v3M12 19.5v3M1.5 12h3M19.5 12h3M4.6 4.6l2.1 2.1M17.3 17.3l2.1 2.1M4.6 19.4l2.1-2.1M17.3 6.7l2.1-2.1"/></svg>6 เดือน</div>
  <div class="pill side night" id="sixn" style="left:590px"><svg class="ico" viewBox="0 0 24 24" fill="currentColor"><path d="M20.5 14.5A8.5 8.5 0 0 1 9.5 3.5a8.5 8.5 0 1 0 11 11z"/></svg>6 เดือน</div>
 </div>
 <div class="grp" id="gp-slow"><div class="pill" id="slowtag">หมุนช้าลงทีละนิด</div></div>
 <div class="grp" id="gp-ms">
  <svg id="clock" viewBox="0 0 500 500"><circle cx="250" cy="250" r="226" fill="var(--panel)" stroke="var(--ink)" stroke-width="18"/><circle cx="250" cy="250" r="214" fill="none" stroke="var(--accent)" stroke-width="8"/><g id="ticks"></g><line id="hm" x1="250" y1="250" x2="250" y2="120" stroke="var(--text)" stroke-width="16" stroke-linecap="round"/><line id="hs" x1="250" y1="280" x2="250" y2="62" stroke="var(--accent2)" stroke-width="8" stroke-linecap="round"/><circle cx="250" cy="250" r="18" fill="var(--accent2)" stroke="var(--ink)" stroke-width="6"/></svg>
  <div class="big" id="mstxt"></div>
  <div class="big" id="mssub"></div>
 </div>
 <div class="grp" id="gp-choose">
  <div class="pill side day" id="chd" style="left:56px"><svg class="ico" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.6" stroke-linecap="round"><circle cx="12" cy="12" r="4.5" fill="currentColor"/><path d="M12 1.5v3M12 19.5v3M1.5 12h3M19.5 12h3M4.6 4.6l2.1 2.1M17.3 17.3l2.1 2.1M4.6 19.4l2.1-2.1M17.3 6.7l2.1-2.1"/></svg>กลางวัน</div>
  <div class="pill side night" id="chn" style="left:570px"><svg class="ico" viewBox="0 0 24 24" fill="currentColor"><path d="M20.5 14.5A8.5 8.5 0 0 1 9.5 3.5a8.5 8.5 0 1 0 11 11z"/></svg>กลางคืน</div>
 </div>
</div>

<div id="flash"></div>
</div>
<div id="tcap"><div class="tt" id="tA"></div><div class="tt" id="tB"></div></div>
<div id="tmeas"></div>
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
// globe state: pure functions of t (shared by the page and tools/bake_globe via node)
const RAD=Math.PI/180, PHI=12*RAD, CPH=Math.cos(PHI), SPH=Math.sin(PHI);
const SHOT={}; SC.forEach((s,i)=>{SHOT[s.id]=s; s.i=i;});
const HIT=0.38, STOP2=10.04;               // "หยุด" (hook hit) / "หยุดปุ๊บ" (words.json)
const T_EAST=SHOT.east.a+0.08;             // "ตะวันออก"
const nrm=v=>{const l=Math.hypot(v[0],v[1],v[2])||1;return [v[0]/l,v[1]/l,v[2]/l];};
const FRONT=nrm([-0.5,0.38,0.78]);
// longitude at the centre of the disc (deg). Surface moves to the RIGHT (east) while it spins.
function lonC(t){
  if(t<SHOT.jet.a) return 100-40*Math.min(t,HIT);            // spins, dead stop on "หยุด"
  if(t<SHOT.traffic.a) return 128-14*(Math.min(t,STOP2)-SHOT.speedo.a);   // spins with Thailand, stops on "หยุดปุ๊บ"
  if(t<SHOT.storm.a) return 128-14*(STOP2-SHOT.speedo.a);     // east: stopped
  if(t<SHOT.slow.a) return 108;                               // daynight / six months / orbit: not spinning
  if(t<SHOT.choose.a){const u=t-SHOT.slow.a; return 128-(16*u-2.5*u*u);}  // real: spins, a little slower
  if(t<SHOT.loop.a) return 133+6*(SHOT.loop.a-t);
  return 100+40*(DUR-t);                                      // loop: ends on the frame-0 globe
}
// per-shot target state of the globe
const st=(x,y,r,L,soft,flat,night)=>({x,y,r,L,soft,flat,night});
const GT={
  hook:()=>st(540,1080,400,FRONT,0.22,0,0.5),
  speedo:()=>st(540,820,330,FRONT,0.22,0,0.5),
  stop:()=>st(540,820,330,FRONT,0.22,0,0.5),
  east:()=>st(330,820,290,FRONT,0.22,0,0.5),
  daynight:t=>{const u=clamp((t-SHOT.daynight.a)/(SHOT.daynight.b-SHOT.daynight.a));
    return st(540,840,390,nrm([-0.9,0.12,0.55-0.6*u]),0.1,0,1);},
  sixmonth:()=>st(540,820,350,nrm([-1,0.1,0.02]),0.08,0,1),
  orbit:t=>{const th=Math.PI*eio((t-SHOT.orbit.a)/(SHOT.orbit.b-SHOT.orbit.a)); const sn=Math.sin(th), cs=Math.cos(th);
    return st(540+330*cs,780+150*sn,100*(1+0.25*sn),nrm([-cs,0.06,-sn]),0.08,0,1);},
  slow:()=>st(540,830,370,FRONT,0.22,0,0.5),
  choose:()=>st(540,830,380,[-1,0,0],0.012,0.85,1),
  loop:()=>GT.hook(),
};
const GL=Object.keys(GT);
const isG=s=>!!(s&&GT[s.id]);
function curShot(t){let k=0; for(let i=0;i<SC.length;i++) if(t>=SC[i].a) k=i; return SC[k];}
function prevG(s){for(let i=s.i-1;i>=0;i--) if(isG(SC[i])) return SC[i]; return null;}
const mixS=(A,B,k)=>({x:lerp(A.x,B.x,k),y:lerp(A.y,B.y,k),r:lerp(A.r,B.r,k),L:nrm([lerp(A.L[0],B.L[0],k),lerp(A.L[1],B.L[1],k),lerp(A.L[2],B.L[2],k)]),
  soft:lerp(A.soft,B.soft,k),flat:lerp(A.flat,B.flat,k),night:lerp(A.night,B.night,k)});
function gstate(t){
  const s=curShot(t); let alpha=1, zoom=1, g;
  if(isG(s)){
    const p=prevG(s), tgt=GT[s.id](t), u=t-s.a;
    if(!p) g=tgt;
    else { const pe=GT[p.id](p.b-0.001); const k=s.beat==='loop'?eio(u/0.62):S(u,13,0.8); g=mixS(pe,tgt,k); }
    const pv=SC[s.i-1];
    if(pv&&!isG(pv)){ alpha=eio(u/0.1); zoom=1+0.3*(1-S(u,18,0.9)); }     // enters with the look's zoom
  } else {
    const pv=SC[s.i-1]; if(!isG(pv)||t-s.a>=0.12) return null;
    g=GT[pv.id](t); alpha=1-(t-s.a)/0.12;
  }
  g.alpha=alpha; g.zoom=zoom; g.lon=lonC(t); g.id=s.id; return g;
}
// sun + orbit path (orbit shot) and the low sun glow on the left (day/night shots), baked into the globe plate
function sunInfo(t){ const sa=SHOT.orbit.a, ob=SHOT.orbit.b;
  const so=t<sa?0:eio((t-sa)/0.3)*(t>ob?Math.max(0,1-(t-ob)/0.12):1);
  const th=Math.PI*eio((t-sa)/(ob-sa));
  const on=t>=SHOT.daynight.a&&t<SHOT.calmearth.a+0.12;
  return {so:on?so:0, behind:t>=sa&&t<ob+0.12&&Math.sin(th)<0, left:on&&t<sa+0.3?0.5*(1-so):0};
}


// ===== earth-stops: one NASA globe (Blue Marble day + Black Marble night) mapped onto a sphere. The sphere itself is
// baked per frame into assets/globe-v.mp4 by bake_globe.py from the same state.js (the render browser has no WebGL and
// a per-pixel canvas made the runtime miss its ready deadline); this page shows/zooms that plate and draws the light
// overlays (Thailand marker, shock rings, spin arrow, speed lines) from the same state.
const CSS=getComputedStyle($('root')), COL=n=>CSS.getPropertyValue(n).trim();
const C_ACC=COL('--accent')||'#FFE14D', C_ACC2=COL('--accent2')||'#FF6FAE', C_TXT=COL('--text')||'#FFFFFF';
const hexA=(h,a)=>{h=h.replace('#','');const n=parseInt(h.length===3?h.split('').map(c=>c+c).join(''):h,16);return `rgba(${n>>16&255},${n>>8&255},${n&255},${a})`;};
const rnd=(i,k)=>{const x=Math.sin(i*127.1+k*311.7)*43758.5453;return x-Math.floor(x);};
function project(g,latD,lonD){ const la=latD*RAD, dl=(lonD-g.lon)*RAD;
  const X=Math.cos(la)*Math.sin(dl), Y=Math.sin(la), Z=Math.cos(la)*Math.cos(dl);
  const y=Y*CPH-Z*SPH, z=Y*SPH+Z*CPH; return {x:g.x+X*g.r, y:g.y-y*g.r, vis:z>0.05};}
const ctxU=$('glu').getContext('2d'), ctxO=$('glo').getContext('2d'); let ctx=ctxO;
// speed lines + debris flying east (to the right) after a stop
function streaks(t,t0,g,n,a){ if(t<t0) return; const u=t-t0, fade=a*Math.min(1,u/0.06);
  for(let i=0;i<n;i++){ const sp=1500+rnd(i,1)*2200, len=90+rnd(i,2)*320, y=g.y+(rnd(i,3)*2-1)*g.r*1.15;
    const x=g.x-g.r*0.7+((u*sp+rnd(i,4)*1500)%1700); const w=2+rnd(i,5)*6;
    const lg=ctx.createLinearGradient(x-len,y,x,y); const c=i%5===0?C_ACC:C_TXT;
    lg.addColorStop(0,hexA(c,0)); lg.addColorStop(1,hexA(c,0.75*fade));
    ctx.strokeStyle=lg; ctx.lineWidth=w; ctx.lineCap='round'; ctx.beginPath(); ctx.moveTo(x-len,y); ctx.lineTo(x,y); ctx.stroke(); }
  for(let i=0;i<Math.round(n/3);i++){ const sp=700+rnd(i,6)*1100, y0=g.y+(rnd(i,7)*2-1)*g.r*0.9;
    const x=g.x+g.r*0.2+((u*sp+rnd(i,8)*900)%1300), y=y0+Math.sin(u*3+i)*14, s=5+rnd(i,9)*12;
    ctx.save(); ctx.translate(x,y); ctx.rotate(u*(4+rnd(i,10)*8)); ctx.fillStyle=hexA(i%3?'#c9c2d8':C_ACC2,0.9*fade);
    ctx.fillRect(-s/2,-s/2,s,s*0.7); ctx.restore(); } }
// curved arrow over the globe showing the spin direction (west -> east)
function spinArrow(g,t,a,spd){ if(a<=0) return; const R=g.r*1.13, a0=200*RAD, a1=335*RAD;
  ctx.save(); ctx.globalAlpha=a; ctx.lineCap='round'; ctx.strokeStyle='rgba(0,0,0,.55)'; ctx.lineWidth=22;
  ctx.beginPath(); ctx.arc(g.x,g.y,R,a0,a1); ctx.stroke(); ctx.strokeStyle=C_ACC; ctx.lineWidth=12; ctx.setLineDash([46,26]);
  ctx.lineDashOffset=-t*spd; ctx.beginPath(); ctx.arc(g.x,g.y,R,a0,a1); ctx.stroke(); ctx.setLineDash([]);
  const hx=g.x+R*Math.cos(a1), hy=g.y+R*Math.sin(a1), dir=a1+Math.PI/2;
  ctx.translate(hx,hy); ctx.rotate(dir); ctx.fillStyle=C_ACC; ctx.strokeStyle='rgba(0,0,0,.6)'; ctx.lineWidth=6;
  ctx.beginPath(); ctx.moveTo(34,0); ctx.lineTo(-18,-30); ctx.lineTo(-18,30); ctx.closePath(); ctx.stroke(); ctx.fill(); ctx.restore(); }
function rings(cx,cy,t,t0){ if(t<t0||t>t0+1.6) return; for(let k=0;k<3;k++){ const u=(t-t0-k*0.16)/1.1; if(u<=0||u>=1) continue;
  ctx.strokeStyle=hexA(k===1?C_ACC2:C_ACC,0.9*(1-u)); ctx.lineWidth=16*(1-u)+3; ctx.beginPath(); ctx.arc(cx,cy,40+620*eo(u),0,7); ctx.stroke(); } }
function win(t,a,b,fi,fo){ fi=fi||0.15; fo=fo||0.12; if(t<a||t>=b+fo) return 0; return Math.min(eio((t-a)/fi), t>b?1-(t-b)/fo:1); }
const ctx=$('glo').getContext('2d');
function globe(t){
  ctx.clearRect(0,0,1080,1920);
  const g=gstate(t), th=$('thai'), w=$('gw'); th.style.opacity='0';
  if(!g){ w.style.opacity='0'; return; }
  w.style.opacity=f2(g.alpha); w.style.transform=`scale(${g.zoom.toFixed(4)})`;
  if(t>=SHOT.speedo.a&&t<SHOT.traffic.a){ const p=project(g,14,100.5); const a=win(t,SHOT.speedo.a+0.15,SHOT.stop.b,0.2)*(p.vis?1:0);
    th.style.opacity=f2(a); const pop=1+0.25*(1-S(t-SHOT.speedo.a-0.15,16,0.5));
    th.style.transform=`translate(${f2(p.x)}px,${f2(p.y)}px) scale(${pop.toFixed(3)})`;
    rings(p.x,p.y,t,STOP2); }
  if(g.id==='speedo'||g.id==='stop') spinArrow(g,t,win(t,SHOT.speedo.a+0.2,STOP2-0.02,0.25,0.08),70);
  if(g.id==='slow') spinArrow(g,t,win(t,SHOT.slow.a+0.15,SHOT.slow.b,0.2),lerp(70,30,clamp((t-SHOT.slow.a)/1.58)));
  if(t<SHOT.jet.a) streaks(t,HIT,g,46,1);
  else if(t>=SHOT.stop.a&&t<SHOT.traffic.a+0.12) streaks(t,STOP2,g,40,1);
  else if(t>=SHOT.east.a&&t<SHOT.storm.a+0.12) streaks(t,SHOT.east.a,g,56,1);
}
// shake 4 frames on each stop
function shake(t){ let dx=0,dy=0; [HIT,STOP2].forEach(h=>{ const f=Math.floor((t-h)*30); if(f>=0&&f<4){ const A=[26,-20,13,-7][f]; dx=A; dy=-A*0.6; } });
  $('stage').style.transform=dx?`translate(${dx}px,${dy}px)`:''; }
// time capsule: one capsule, text + width morph
const TC=[[SHOT.feet.a,'ตอนนี้'],[SHOT.stop.a+0.08,'วินาทีแรก'],[SHOT.daynight.a,'ต่อมา'],[SHOT.sixmonth.a,'ทั้งปี'],[24.98,'✓ของจริง']];
const TC_OUT=SHOT.choose.a-0.25;
const CHK='<svg class="ico" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="4" stroke-linecap="round" stroke-linejoin="round"><path d="M3.5 12.5l5.5 5.5L20.5 6"/></svg>';
const tHTML=s=>s.startsWith('✓')?CHK+s.slice(1):s;
const meas=$('tmeas'); meas.innerHTML=TC.map(x=>`<div class="tt">${tHTML(x[1])}</div>`).join('');
let tcW=null;
function capsule(t){ const el=$('tcap');
  if(!tcW||tcW.some(w=>!w)) tcW=[...meas.children].map(c=>c.getBoundingClientRect().width);
  let k=-1; TC.forEach((x,i)=>{if(t>=x[0]) k=i;});
  if(k<0||t>=TC_OUT+0.4){ el.style.opacity='0'; return; }
  const a=S(t-TC[0][0],20,0.6), out=t>=TC_OUT?1-eio((t-TC_OUT)/0.3):1;
  el.style.opacity=f2(clamp(Math.min(1,(t-TC[0][0])/0.08)*out));
  el.style.transform=`scale(${(lerp(0.4,1,a)*lerp(0.6,1,out)).toFixed(4)})`;
  const u=t-TC[k][0], w0=k?tcW[k-1]:tcW[0], w=lerp(w0,tcW[k],S(u,18,0.7)); el.style.width=f2(w)+'px';
  const A=$('tA'), B=$('tB'); const m=eio(u/0.22);
  A.innerHTML=tHTML(TC[k][1]); A.style.transform=`translateY(${f2(60*(1-m))}px)`; A.style.opacity=f2(k?m:1);
  if(k){ B.innerHTML=tHTML(TC[k-1][1]); B.style.transform=`translateY(${f2(-60*m)}px)`; B.style.opacity=f2(1-m); } else B.style.opacity='0';
  if(k===TC.length-1){ const p=S(u,22,0.35); el.style.boxShadow=`0 0 0 ${f2(7+10*(1-p))}px var(--ink),0 14px 0 rgba(0,0,0,.35)`; }
}
const fmt=n=>Math.round(n).toString().replace(/\B(?=(\d{3})+(?!\d))/g,',');
function grp(id,a){ const e=$(id); e.style.opacity=f2(clamp(a)); return e; }
function overlays(t){
  grp('gp-jet',win(t,SHOT.jet.a+0.15,SHOT.jet.b,0.2,0.1));
  // speedo: count 0 -> 1,600 on "หนึ่งพันหกร้อย ... ชั่วโมง"
  const sa=win(t,SHOT.speedo.a+0.1,SHOT.speedo.b,0.2,0.1); grp('gp-speedo',sa);
  if(sa>0){ const v=1600*eo(clamp((t-7.3)/(8.85-7.3))); const done=t>=8.85;
    $('spd').innerHTML='~'+fmt(done?1600:Math.round(v/10)*10)+'<span class="unit">กม./ชม.</span>';
    const p=done?1+0.14*(1-S(t-8.85,20,0.35)):1+0.015*Math.sin(t*40)*(t>7.3?1:0); $('spd').style.transform=`scale(${p.toFixed(4)})`; }
  // storm: 408 km/h then x4 on "สี่เท่า"
  const wa=win(t,SHOT.storm.a+0.06,SHOT.storm.b,0.15,0.1); const ws=grp('gp-storm',wa);
  if(wa>0){ const u=S(t-SHOT.storm.a,16,0.7); ws.style.transform=`translateY(${f2(80*(1-u))}px)`;
    const v=408*eo(clamp((t-15.95)/(16.9-15.95))); $('wind').innerHTML=fmt(t>=16.9?408:v)+'<span class="unit">กม./ชม.</span>';
    const x=t<17.42?0:S(t-17.42,17,0.45); $('x4').style.opacity=f2(clamp(x*3)); $('x4').style.transform=`rotate(${f2(lerp(-30,8,x))}deg) scale(${(0.2+0.8*x).toFixed(4)})`; }
  // east arrow
  const ea=win(t,SHOT.east.a,SHOT.east.b,0.06,0.1); grp('gp-east',ea);
  if(ea>0){ const u=S(t-T_EAST,15,0.62); $('arrow').style.transform=`translateX(${f2(-500*(1-u)+14*Math.sin((t-T_EAST)*9))}px) scaleX(${(0.3+0.7*clamp(u*1.2)).toFixed(4)})`; }
  // six months
  const xa=win(t,SHOT.sixmonth.a,SHOT.sixmonth.b,0.1,0.1); grp('gp-six',xa);
  if(xa>0){ const d=S(t-21.22,16,0.5), n=S(t-21.4,16,0.5);
    $('sixd').style.transform=`scale(${d.toFixed(4)}) rotate(-3deg)`; $('sixn').style.transform=`scale(${n.toFixed(4)}) rotate(3deg)`;
    $('sixd').style.opacity=f2(clamp(d*2)); $('sixn').style.opacity=f2(clamp(n*2)); }
  // slow
  const la=win(t,SHOT.slow.a+0.3,SHOT.slow.b,0.2,0.1); grp('gp-slow',la);
  if(la>0){ const u=S(t-SHOT.slow.a-0.3,14,0.6); $('slowtag').style.transform=`translateX(-50%) translateY(${f2(40*(1-u))}px)`; }
  // ms: clock + typed number (ราว 1.8 ms ~ 0.002 s per 100 years: research.md 6)
  const ma=win(t,SHOT.ms.a,SHOT.ms.b,0.1,0.12); const mg=grp('gp-ms',ma);
  if(ma>0){ const u=t-SHOT.ms.a; mg.style.transform=`scale(${(1+0.25*(1-S(u,18,0.9))).toFixed(4)})`; mg.style.transformOrigin='50% 40%';
    $('hs').setAttribute('transform',`rotate(${f2(u*140)} 250 250)`); $('hm').setAttribute('transform',`rotate(${f2(40+u*12)} 250 250)`);
    const full='ราว +0.002 วินาที', n=Math.floor(clamp((t-35.96)/(37.1-35.96))*full.length+(t>=35.96?1:0));
    $('mstxt').textContent=full.slice(0,Math.min(full.length,n)); $('mssub').textContent=t>=37.58?'/ 100 ปี':'';
    $('mssub').style.transform=`scale(${(t>=37.58?S(t-37.58,18,0.5):0).toFixed(4)})`; }
  // choose
  const ca=win(t,SHOT.choose.a+0.1,SHOT.loop.a,0.2,0.3); grp('gp-choose',ca);
  if(ca>0){ const i1=S(t-SHOT.choose.a-0.1,16,0.55), i2=S(t-SHOT.choose.a-0.25,16,0.55);
    const hd=t>=40.88&&t<41.88?S(t-40.88,20,0.4):0, hn=t>=41.88?S(t-41.88,20,0.4):0;
    $('chd').style.transform=`scale(${(i1*(1+0.16*hd)*(hn?0.92:1)).toFixed(4)}) rotate(-3deg)`;
    $('chn').style.transform=`scale(${(i2*(1+0.16*hn)*(hd?0.92:1)).toFixed(4)}) rotate(3deg)`;
    $('chd').style.opacity=f2(hn?0.55:1); $('chn').style.opacity=f2(hd?0.55:1); }
}
const TICKS=$('ticks'); if(TICKS&&!TICKS.childNodes.length){ let h=''; for(let i=0;i<12;i++){ const a=i*30*RAD; h+=`<line x1="${250+180*Math.sin(a)}" y1="${250-180*Math.cos(a)}" x2="${250+(i%3?196:204)*Math.sin(a)}" y2="${250-(i%3?196:204)*Math.cos(a)}" stroke="var(--text)" stroke-width="${i%3?6:12}" stroke-linecap="round"/>`; } TICKS.innerHTML=h; }
function episode(t){ globe(t); shake(t); capsule(t); overlays(t); }

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
