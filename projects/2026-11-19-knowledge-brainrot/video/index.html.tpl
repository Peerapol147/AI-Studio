<!doctype html>
<!-- GENERATED: edit index.html.tpl, then run `python3 build_index.py` -->
<html lang="th"><head><meta charset="UTF-8"/><meta name="viewport" content="width=1080, height=1920"/>
<link rel="stylesheet" href="fonts/fonts.css"/>
<script src="https://cdn.jsdelivr.net/npm/gsap@3.15.0/dist/gsap.min.js"></script>
<script src="vendor/flubber.min.js"></script>
<style>
*{margin:0;padding:0;box-sizing:border-box}
html,body{width:1080px;height:1920px;overflow:hidden;background:#000}
#root{position:relative;width:1080px;height:1920px;overflow:hidden;font-family:'Kanit',sans-serif;background:#0B1026}
#stage{position:absolute;left:0;top:0;width:1080px;height:1920px;transform-origin:50% 40%}
.sc{position:absolute;left:0;top:0;width:1080px;height:1920px;overflow:hidden;opacity:0}
.kb{position:absolute;left:0;top:0;width:1080px;height:1920px}
.vid{position:absolute;left:0;top:0;width:1080px;height:1920px;object-fit:cover}
.vig{position:absolute;left:0;top:0;width:1080px;height:1920px;background:radial-gradient(ellipse at 50% 45%,rgba(11,16,38,0) 55%,rgba(11,16,38,.5) 100%)}
.dbg{position:absolute;left:0;top:0;width:1080px;height:1920px;background:radial-gradient(ellipse at 50% 38%,#3A2477 0%,#22184F 45%,#0B1026 100%)}
.stars{position:absolute;left:0;top:0;width:1080px;height:1920px;overflow:visible}
.ov{position:absolute;left:0;top:0;width:1080px;height:1920px;overflow:visible}
#tshade{position:absolute;left:0;top:0;width:1080px;height:880px;background:linear-gradient(rgba(6,8,24,.78) 0%,rgba(6,8,24,.55) 55%,rgba(6,8,24,0) 100%)}
#title{position:absolute;left:0;top:0;width:1080px;height:760px}
#title .tl{position:absolute;left:0;width:1080px;text-align:center;font-weight:900;line-height:1;white-space:nowrap;color:#fff;
  -webkit-text-stroke:26px #10080A;paint-order:stroke fill;transform-origin:50% 60%;text-shadow:0 12px 0 rgba(0,0,0,.45)}
.pill{position:absolute;left:0;top:0;height:96px;border-radius:48px;border:7px solid #10080A;opacity:0;white-space:nowrap;
  box-shadow:0 10px 0 rgba(0,0,0,.35);transform-origin:50% 50%}
.pill .tx{position:absolute;top:50%;left:96px;transform:translateY(-54%);font-weight:900;font-size:50px;white-space:nowrap;color:#10080A}
.pill .bd{position:absolute;left:12px;top:9px;width:64px;height:64px;border-radius:32px;background:#10080A;display:flex;align-items:center;justify-content:center}
.pill .bd svg{width:44px;height:44px;color:#fff;position:absolute;left:10px;top:10px}
.ic{overflow:visible}
#meas{position:absolute;left:-3000px;top:0;font-weight:900;font-size:50px;white-space:nowrap;visibility:hidden}
/* dictionary card (Oxford / +230% / definition / "supposed") */
#card{position:absolute;left:120px;top:400px;width:800px;height:610px;border-radius:40px;background:#FFF8EE;opacity:0;
  box-shadow:0 0 0 8px #10080A,0 30px 70px rgba(0,0,0,.55);transform-origin:50% 50%;overflow:hidden}
#card .hw{position:absolute;left:60px;top:46px;font-weight:900;font-size:124px;line-height:1.05;color:#10080A}
#card .pos{position:absolute;left:66px;top:186px;font-weight:400;font-size:40px;color:#6B5B7B}
#card .uline{position:absolute;left:60px;top:240px;width:600px;height:14px;border-radius:7px;background:#FF6FAE;transform-origin:0 50%}
#cnt{position:absolute;left:60px;top:290px;width:680px;height:300px}
#cnt .num{position:absolute;left:0;top:0;font-weight:900;font-size:150px;line-height:1;color:#12894A;-webkit-text-stroke:0}
#cnt .sub{position:absolute;left:4px;top:176px;font-weight:700;font-size:40px;color:#3B2D55;display:flex;align-items:center;gap:14px}
#cnt .sub svg{width:48px;height:48px;color:#1FAE5B}
#def{position:absolute;left:60px;top:286px;width:690px}
#def .ln{position:relative;font-weight:700;font-size:54px;line-height:70px;color:#2A2140;white-space:nowrap}
#def .gl{position:relative;margin-top:16px;font-weight:700;font-size:42px;line-height:56px;color:#7A3E8F;white-space:nowrap}
#sup{position:relative;display:inline-block;z-index:1}
#supbg{position:absolute;left:-8px;top:6px;height:62px;width:0;background:#FFE14D;border-radius:10px;z-index:-1}
#caret{display:inline-block;width:5px;height:50px;background:#10080A;vertical-align:-8px;margin-left:4px}
/* glitch word (registry: rgb-glitch-text, adapted) */
.hf-catalog-rgb-glitch-text{position:absolute;left:0;top:0;width:1080px;text-align:center;font-weight:900;font-size:120px;line-height:1.2;opacity:0}
.hf-catalog-rgb-glitch-text span,.hf-catalog-rgb-glitch-text strong{position:absolute;left:0;top:0;width:1080px;text-align:center}
.hf-catalog-rgb-glitch-text span:first-child{color:#ef4444;transform:translateX(var(--hf-glitch-red,0px))}
.hf-catalog-rgb-glitch-text span:nth-child(2){color:#22d3ee;transform:translateX(var(--hf-glitch-blue,0px))}
.hf-catalog-rgb-glitch-text strong{color:#FFE14D;-webkit-text-stroke:22px #10080A;paint-order:stroke fill}
.hf-catalog-rgb-glitch-text span{-webkit-text-stroke:22px currentColor;paint-order:stroke fill;opacity:.85}
/* chips, panels */
.chip{position:absolute;left:0;top:0;height:110px;padding:0 34px 0 30px;border-radius:30px;border:7px solid #10080A;background:#1A1440;
  display:flex;align-items:center;gap:16px;color:#fff;font-weight:900;font-size:76px;white-space:nowrap;opacity:0;box-shadow:0 10px 0 rgba(0,0,0,.4);transform-origin:50% 50%}
.chip svg{width:64px;height:64px;color:#FFE14D}
#panel{position:absolute;left:120px;top:400px;width:800px;height:540px;border-radius:40px;background:#1A1440;opacity:0;
  box-shadow:0 0 0 7px #FFF8EE,0 0 0 14px #10080A,0 30px 70px rgba(0,0,0,.5)}
#panel .hd{position:absolute;left:56px;top:40px;display:flex;align-items:center;gap:18px;color:#fff;font-weight:900;font-size:70px}
#panel .hd svg{width:76px;height:76px;color:#FFE14D}
.row{position:absolute;left:56px;width:690px;height:110px}
.row .lb{position:absolute;left:0;top:18px;color:#fff;font-weight:700;font-size:50px}
.row .tr{position:absolute;left:200px;top:24px;width:470px;height:64px;border-radius:32px;background:rgba(255,255,255,.12)}
.row .bar{position:absolute;left:200px;top:24px;height:64px;width:0;border-radius:32px;border:6px solid #10080A}
#src{position:absolute;left:0;top:300px;width:1080px;text-align:center;color:rgba(255,255,255,.88);font-weight:700;font-size:40px;opacity:0;
  display:flex;justify-content:center;align-items:center;gap:12px}
#src svg{width:44px;height:44px;color:#FFE14D}
.bub{position:absolute;left:0;top:0;width:300px;height:300px;border-radius:150px;border:8px solid #10080A;opacity:0;
  display:flex;flex-direction:column;align-items:center;justify-content:center;font-weight:900;font-size:58px;color:#10080A;box-shadow:0 12px 0 rgba(0,0,0,.35)}
.bub svg{width:84px;height:84px;color:#10080A}
#trickT{position:absolute;left:0;top:300px;width:1080px;text-align:center;font-weight:900;font-size:150px;line-height:1;white-space:nowrap;opacity:0;
  color:#FFE14D;-webkit-text-stroke:24px #10080A;paint-order:stroke fill;transform-origin:50% 60%}
#trickT b{color:#fff;font-size:110px}
#note{position:absolute;left:120px;top:1340px;width:780px;text-align:center;color:#fff;font-weight:700;font-size:40px;opacity:0;
  -webkit-text-stroke:10px #10080A;paint-order:stroke fill}
#ctext{position:absolute;left:180px;top:0;width:720px;text-align:center;opacity:0}
#ctext .q1{font-weight:900;font-size:80px;line-height:1.08;color:#10080A;white-space:nowrap}
#ctext .q2{display:inline-block;margin-top:8px;font-weight:900;font-size:96px;line-height:1.08;color:#10080A;white-space:nowrap;padding:0 22px;border-radius:22px;background:#FFE14D}
#ctext .q3{margin-top:14px;font-weight:700;font-size:44px;color:#B0306F;display:flex;align-items:center;justify-content:center;gap:12px;white-space:nowrap}
#ctext .q3 svg{width:50px;height:50px;color:#B0306F}
#gbars{position:absolute;left:0;top:0;width:1080px;height:1920px;z-index:40;pointer-events:none}
#gbars div{position:absolute;left:0;width:1080px;opacity:0;mix-blend-mode:screen}
#caps{position:absolute;left:0;top:0;width:1080px;height:1920px;z-index:60;pointer-events:none}
/* captions: centred on X 510 (safe band X 120-900), text box ~Y 1130-1245 */
.cap{position:absolute;left:10px;width:1000px;top:1190px;height:0;text-align:center}
.cap span{position:absolute;left:0;width:1000px;bottom:-52px;display:block;color:#fff;font-weight:700;line-height:1.18;white-space:nowrap;
  -webkit-text-stroke:17px #000;paint-order:stroke fill;transform-origin:50% 80%}
.cap em{font-style:normal;color:#FFE14D}
</style></head><body>
<div id="root" data-composition-id="main" data-start="0" data-duration="%%DUR%%" data-width="1080" data-height="1920"
 data-motion-blur="on" data-motion-blur-events="on">
<svg width="0" height="0" style="position:absolute" aria-hidden="true"><defs>
%%ICONS%%
<filter id="rgbx" x="-10%" y="-10%" width="120%" height="120%" color-interpolation-filters="sRGB">
  <feColorMatrix in="SourceGraphic" type="matrix" values="1 0 0 0 0  0 0 0 0 0  0 0 0 0 0  0 0 0 1 0" result="r"/>
  <feOffset id="rgbR" in="r" dx="0" dy="0" result="ro"/>
  <feColorMatrix in="SourceGraphic" type="matrix" values="0 0 0 0 0  0 1 0 0 0  0 0 0 0 0  0 0 0 1 0" result="g"/>
  <feColorMatrix in="SourceGraphic" type="matrix" values="0 0 0 0 0  0 0 0 0 0  0 0 1 0 0  0 0 0 1 0" result="b"/>
  <feOffset id="rgbB" in="b" dx="0" dy="0" result="bo"/>
  <feBlend in="ro" in2="g" mode="screen" result="rg"/><feBlend in="rg" in2="bo" mode="screen"/>
</filter></defs></svg>

<div id="stage" data-layout-allow-overflow data-layout-allow-overlap>
<div id="scenes" data-layout-allow-overflow data-layout-allow-overlap style="position:absolute;left:0;top:0;width:1080px;height:1920px;z-index:0;isolation:isolate">
  <div class="sc" id="sh-hook"><div class="kb" id="kb-hook">%%V_HOOK%%</div><div class="vig"></div></div>
  <div class="sc" id="sh-bed"><div class="kb" id="kb-bed">%%V_BED%%</div><div class="vig"></div></div>
  <div class="sc gsc" id="sh-g1"><div class="dbg"></div><svg class="stars" viewBox="0 0 1080 1920"></svg></div>
  <div class="sc" id="sh-noproof"><div class="kb" id="kb-noproof">%%V_NOPROOF%%</div><div class="vig"></div></div>
  <div class="sc gsc" id="sh-g2"><div class="dbg"></div><svg class="stars" viewBox="0 0 1080 1920"></svg></div>
  <div class="sc" id="sh-heavy"><div class="kb" id="kb-heavy">%%V_HEAVY%%</div><div class="vig"></div></div>
  <div class="sc gsc" id="sh-g3"><div class="dbg"></div><svg class="stars" viewBox="0 0 1080 1920"></svg></div>
  <div class="sc" id="sh-stress"><div class="kb" id="kb-stress">%%V_STRESS%%</div><div class="vig"></div></div>
  <div class="sc" id="sh-scrollbed"><div class="kb" id="kb-scrollbed">%%V_SCROLLBED%%</div><div class="vig"></div></div>
  <div class="sc gsc" id="sh-g4"><div class="dbg"></div><svg class="stars" viewBox="0 0 1080 1920"></svg></div>
  <div class="sc" id="sh-sleep"><div class="kb" id="kb-sleep">%%V_SLEEP%%</div><div class="vig"></div></div>
  <div class="sc gsc" id="sh-g5"><div class="dbg"></div><svg class="stars" viewBox="0 0 1080 1920"></svg></div>
  <div class="sc" id="sh-loop"><div class="kb" id="kb-loop">%%V_LOOP%%</div><div class="vig"></div></div>
</div>

<div id="over" data-layout-allow-overflow data-layout-allow-overlap style="position:absolute;left:0;top:0;width:1080px;height:1920px;z-index:10">
  <!-- dictionary card: Oxford -> +230% -> definition -> zoom on "supposed" -->
  <div id="card"><div class="hw">brain rot</div><div class="pos">(n.)</div><div class="uline" id="uline"></div>
    <div id="cnt"><div class="num" id="num">+0%</div>
      <div class="sub"><svg class="ic"><use href="#ic-trending-up"/></svg>การใช้คำนี้ 2023 → 2024</div></div>
    <div id="def"><div class="ln" id="dl1">the <span id="sup"><span id="supbg"></span>supposed</span> deterioration</div>
      <div class="ln" id="dl2">of a person's mental or</div><div class="ln" id="dl3">intellectual state…</div>
      <div class="gl" id="dgl">= ความเสื่อมที่ “คนคิดว่า” เกิด</div></div>
  </div>
  <div class="hf-catalog-rgb-glitch-text" id="gw1"><span>= คนคิดว่า</span><span>= คนคิดว่า</span><strong>= คนคิดว่า</strong></div>
  <!-- focus meter -->
  <div id="src"><svg class="ic"><use href="#ic-book-open"/></svg>Psychological Bulletin 2025</div>
  <div id="panel"><div class="hd"><svg class="ic"><use href="#ic-target"/></svg>เทสสมาธิ</div>
    <div class="row" style="top:190px"><div class="lb">ดูน้อย</div><div class="tr"></div><div class="bar" id="bar1" style="background:#3DDC84"></div></div>
    <div class="row" style="top:340px"><div class="lb">ดูหนัก</div><div class="tr"></div><div class="bar" id="bar2" style="background:#FFA53D"></div></div>
  </div>
  <!-- correlation bubbles -->
  <div class="bub" id="bubA" style="background:#FFA53D"><svg class="ic"><use href="#ic-smartphone"/></svg>ดูหนัก</div>
  <div class="bub" id="bubB" style="background:#7FD3FF"><svg class="ic"><use href="#ic-target"/></svg>สมาธิแย่</div>
  <!-- chips -->
  <div class="chip" id="clock2"><svg class="ic"><use href="#ic-moon"/></svg>02:00</div>
  <div class="chip" id="chipS" style="background:#5B2A86"><svg class="ic"><use href="#ic-zap"/></svg>เครียด</div>
  <div class="chip" id="chipL" style="background:#1E3A8A"><svg class="ic"><use href="#ic-smartphone"/></svg>เลื่อน</div>
  <div id="trickT">ทริก <b>1 ข้อ</b></div>
  <svg class="ov" id="gsvg" viewBox="0 0 1080 1920" width="1080" height="1920"><g id="glayer"></g></svg>
  <div id="ctext"><div class="q1">คืนนี้เลื่อนถึง</div><div class="q2" id="q2">กี่โมง?</div>
    <div class="q3" id="q3"><svg class="ic"><use href="#ic-message-circle"/></svg>ตอบในคอมเมนต์</div></div>
  <div class="pill" id="pill"><div class="bd" id="pillBd"><svg class="ic" id="pillIc"><use id="pillUse" href="#ic-circle-x"/></svg></div>
    <span class="tx" id="pillA"></span><span class="tx" id="pillB"></span></div>
  <div id="note">นอนไม่หลับบ่อย ปรึกษาแพทย์</div>
  <div id="tshade"></div>
  <div id="title"><div class="tl" id="tl1">Brainrot</div><div class="tl" id="tl2">ทำสมองพัง</div><div class="tl" id="tl3">จริงไหม?</div></div>
  <div id="meas"></div>
</div>
</div>
<div id="gbars"><div id="gb0"></div><div id="gb1"></div><div id="gb2"></div></div>

<div id="caps" data-track-kind="captions">
%%CAPS%%
</div>

<audio id="vo" class="clip" data-start="0" data-duration="%%DUR%%" data-track-index="30" data-volume="1" src="assets/vo-th.mp3"></audio>
<audio id="music" class="clip" data-start="0" data-duration="%%DUR%%" data-track-index="31" data-volume="0.1" src="assets/music-jamendo-b386828e.mp3"></audio>
</div>

<script>
/* Motion: closed-form springs (motion-broll engine, from the cat-water episode). Shot times = assets/audio/shots-th.json,
   word anchors = words.json (both injected by build_index.py). ONE character: the cartoon brain (own SVG, pink #FF6FAE)
   morphs with flubber normal -> melt -> back (brain-ok) -> comment bubble, and springs between poses (never pops).
   One pill morphs belief -> Oxford -> truth -> no-evidence -> correlation. Everything is a function of t. */
(function(){
const D=%%DATA%%, DUR=D.dur, CAPT=D.capt, K=D.k, SH=D.sh;
const T={},H={}; for(const k in SH){T[k]=SH[k].start; if(SH[k].hit!=null)H[k]=SH[k].hit;}
const NS='http://www.w3.org/2000/svg';

// ---------- spring kit ----------
const clamp=(x,a=0,b=1)=>Math.min(b,Math.max(a,x)), lerp=(a,b,u)=>a+(b-a)*u;
const eo=x=>{x=clamp(x);return 1-Math.pow(1-x,3)}, eio=x=>{x=clamp(x);return x*x*x*(x*(6*x-15)+10)}, ei=x=>{x=clamp(x);return x*x*x};
const S=(tau,w,z)=>{if(tau<=0)return 0;
  if(z<1){const wd=w*Math.sqrt(1-z*z);return 1-Math.exp(-z*w*tau)*(Math.cos(wd*tau)+z*w/wd*Math.sin(wd*tau));}
  return 1-Math.exp(-w*tau)*(1+w*tau);};
const MORPH=[15,0.84],FAST=[26,0.8],SLOW=[8,0.95],BOUNCE=[18,0.55],POP=[22,0.5],OUT=[30,1];
const track=(v0,keys,def=MORPH)=>{let p=v0;const ks=[];for(const k of keys){const d=k[1]-p;p=k[1];const sp=k[2]||def;if(d!==0)ks.push([k[0],d,sp[0],sp[1]]);}
  return t=>{let v=v0;for(const k of ks)v+=k[1]*S(t-k[0],k[2],k[3]);return v;};};
const hex=h=>[1,3,5].map(i=>parseInt(h.slice(i,i+2),16));
const mix=(a,b,u)=>{const x=hex(a),y=hex(b);return `rgb(${x.map((v,i)=>Math.round(lerp(v,y[i],clamp(u)))).join(',')})`;};
const $=id=>document.getElementById(id);
const el=(tag,attrs,parent)=>{const e=document.createElementNS(NS,tag);for(const k in attrs)e.setAttribute(k,attrs[k]);parent.appendChild(e);return e;};
const show=(e,o)=>{e.style.opacity=o<0.003?'0':o.toFixed(4);return o>=0.003;};
const f2=v=>v.toFixed(2);
// window visibility: spring in at a, quick fade at b (cut)
const win=(t,a,b,sp=POP)=>{if(t<a||t>=b+0.1)return 0; const i=S(t-a,sp[0],sp[1]); const o=t>b?1-clamp((t-b)/0.08):1; return Math.max(0,i)*o;};
const pinO=(t,a,b)=>(t<a||t>=b+0.1)?0:clamp((t-a)/0.06)*(t>b?1-clamp((t-b)/0.08):1);
const meas=$('meas'); const wcache={};
const tw=txt=>{if(wcache[txt])return wcache[txt]; meas.textContent=txt; const w=meas.offsetWidth;
  if(document.fonts&&document.fonts.status==='loaded'&&w>0)wcache[txt]=w; return w||txt.length*28;};
const PINK='#FF6FAE',YEL='#FFE14D',GRN='#3DDC84',ORG='#FFA53D',RED='#FF4D5E',INK='#10080A';
const G=$('glayer');

// ---------- scenes ----------
// entries: cut (hard) | whip (0.12 s push) | zoom (zoom punch-in, 0.1 s fade) | match (0.1 s crossfade)
const SC=[
 {id:'sh-hook',a:0,kb:'kb-hook',s0:1.0,s1:1.06,org:'50% 62%',in:'none',still:1},
 {id:'sh-bed',a:T.bed,kb:'kb-bed',s0:1.03,s1:1.09,r0:0.6,r1:-0.6,org:'40% 30%',in:'whip'},
 {id:'sh-g1',a:T.melt,in:'zoom'},
 {id:'sh-noproof',a:T.noproof,kb:'kb-noproof',s0:1.02,s1:1.08,r0:-0.6,r1:0.5,org:'45% 30%',in:'cut'},
 {id:'sh-g2',a:T.brainok,in:'zoom'},
 {id:'sh-heavy',a:T.heavy,kb:'kb-heavy',s0:1.04,s1:1.1,r0:0.8,r1:-0.8,org:'60% 40%',in:'whip'},
 {id:'sh-g3',a:T.focus,in:'zoom'},
 {id:'sh-stress',a:T.stress,kb:'kb-stress',s0:1.02,s1:1.08,r0:-0.5,r1:0.5,org:'40% 30%',in:'cut'},
 {id:'sh-scrollbed',a:T.scrollbed,kb:'kb-scrollbed',s0:1.03,s1:1.08,r0:0.5,r1:-0.5,org:'40% 30%',in:'match'},
 {id:'sh-g4',a:T.trick,in:'zoom'},
 {id:'sh-sleep',a:T.sleep,kb:'kb-sleep',s0:1.02,s1:1.07,r0:-0.5,r1:0.5,org:'60% 40%',in:'whip'},
 {id:'sh-g5',a:T.comment,in:'zoom'},
 {id:'sh-loop',a:T.loop,kb:'kb-loop',s0:1.05,s1:1.0,org:'50% 62%',in:'match',still:1},
];
SC.forEach((s,i)=>{s.next=SC[i+1]; s.b=s.next?s.next.a:DUR; $(s.id).style.zIndex=String(i+1); if(s.kb)$(s.kb).style.transformOrigin=s.org;});
const XF=0.12;
function sceneState(s,t){
  if(t<s.a)return null;
  const nx=s.next, end=nx?nx.a:DUR+1, u=t-s.a; let o=1,tx=0,sc=1;
  if(s.in==='whip'){ tx=1080*(1-eo(u/XF)); }
  else if(s.in==='zoom'){ o=eio(u/0.1); sc=1+0.3*(1-S(u,18,0.9)); }
  else if(s.in==='match'){ o=eio(u/0.1); }
  if(nx){
    if(nx.in==='whip'){ if(t>=end+XF)return null; if(t>=end) tx=-1080*eo((t-end)/XF); }
    else if(nx.in==='cut'){ if(t>=end)return null; }
    else { if(t>=end+XF)return null; if(nx.in==='zoom'&&t>end-0.1) sc*=1+0.5*ei((t-end+0.1)/0.22); }
  }
  return {o,tx,sc};
}
function scenes(t){
  SC.forEach(s=>{const r=sceneState(s,t), e=$(s.id);
    if(!r){e.style.opacity='0';return;}
    e.style.opacity=r.o.toFixed(4); e.style.transform=`translateX(${f2(r.tx)}px) scale(${r.sc.toFixed(4)})`;
    if(!s.kb)return;
    const uu=clamp((t-s.a)/Math.max(0.3,(s.b-s.a)));
    const k=lerp(s.s0,s.s1,s.still?uu:eio(0.1+0.9*uu));
    if(s.still){ $(s.kb).style.transform=`scale(${k.toFixed(5)})`; return; }   // hook / loop: pure push (frame 0 = last frame)
    const rr=lerp(s.r0,s.r1,uu), dx=10*Math.sin(t*1.7+s.a), dy=8*Math.cos(t*1.3+s.a);
    $(s.kb).style.transform=`translate(${f2(dx)}px,${f2(dy)}px) rotate(${rr.toFixed(3)}deg) scale(${k.toFixed(5)})`;
  });
}
// stars in the graphic backdrops (deterministic), drifting + twinkling
const STARS=[]; document.querySelectorAll('.stars').forEach((sv,j)=>{for(let i=0;i<46;i++){const x=(i*233+j*97)%1080, y=(i*421+j*151)%1920, r=2+(i%4);
  STARS.push({e:el('circle',{cx:x,cy:y,r,fill:i%7?'#C9C3FF':'#FF6FAE',opacity:.5},sv),x,y,i,j});}});
function stars(t){STARS.forEach(s=>{s.e.setAttribute('cy',f2(((s.y-t*(30+s.i%5*12))%1920+1920)%1920)); s.e.setAttribute('opacity',f2(0.25+0.45*(0.5+0.5*Math.sin(t*3+s.i))));});}

// ---------- zoom punches (Oxford, ทริก) + glitch (คนคิดว่า, สัมพันธ์): registry zoom-through / rgb-glitch-text, adapted ----------
const PUNCH=[K.oxford,K.trick];
const GL=[T.supposed,T.corr], GLD=0.134; // 4 frames
const GOFF=[[16,-12,-14],[-10,14,10],[20,-8,-18],[-6,6,8]];
function fx(t){
  let p=0; PUNCH.forEach(a=>{const u=t-a; if(u>=0&&u<0.8)p+=0.085*Math.exp(-u*7)*Math.cos(u*13);});
  let gi=-1; GL.forEach(a=>{if(t>=a&&t<a+GLD)gi=Math.floor((t-a)*30);});
  const st=$('stage');
  if(gi>=0){const o=GOFF[gi%4]; $('rgbR').setAttribute('dx',o[0]); $('rgbB').setAttribute('dx',o[1]); st.style.filter='url(#rgbx)';
    st.style.transform=`translateX(${o[2]}px) scale(${(1+p+0.03).toFixed(4)})`;}
  else { st.style.filter='none'; st.style.transform=`scale(${(1+p).toFixed(4)})`; }
  ['gb0','gb1','gb2'].forEach((id,i)=>{const b=$(id); if(gi<0){b.style.opacity='0';return;}
    const y=[(300+gi*410)%1500,(820+gi*290)%1500,(560+gi*530)%1500][i]+120, h=[26,60,14][i];
    b.style.top=y+'px'; b.style.height=h+'px'; b.style.background=['#22d3ee','#ef4444','#FFFFFF'][i]; b.style.opacity=['.55','.45','.6'][i];
    b.style.transform=`translateX(${(i%2?-1:1)*(20+gi*9)}px)`;});
}

// ---------- hook title: complete at frame 0 (no fade-in), breathes 1.0<->1.04, back in the last ~0.3 s (loop) ----------
const TL=[['tl1',248,170],['tl2',414,138],['tl3',560,150]];
TL.forEach(([id,y,s])=>{$(id).style.top=y+'px'; $(id).style.fontSize=s+'px';});
const TBACK=DUR-0.3;
function title(t){
  let o,sc;
  if(t<TBACK){ const out=eo((t-(T.bed-0.04))/0.12); o=1-out; sc=1+0.25*out; }
  else { const a=S(t-TBACK,26,0.8); o=clamp(a*1.4); sc=1+0.12*(1-a); }
  show($('title'),o); show($('tshade'),t<TBACK?o:clamp((t-T.loop)/0.4));
  const br=1+0.04*(0.5-0.5*Math.cos(t*2*Math.PI/0.9)), live=t<TBACK?1:0;
  TL.forEach(([id],i)=>{const e=$(id);
    e.style.transform=`translateY(${f2(live*3*Math.sin(t*3+i))}px) rotate(${f2(i===1?-1.2*live*Math.sin(t*2.4):0)}deg) scale(${((t<TBACK?br:1)*sc).toFixed(4)})`;});
}

// ---------- the brain (one character) ----------
const BN='M-190 40 C-215 -30 -170 -110 -100 -120 C-80 -170 0 -175 30 -140 C70 -175 160 -150 165 -85 C215 -60 220 20 185 55 C190 110 130 150 70 135 C30 165 -50 165 -80 130 C-150 145 -205 100 -190 40 Z';
const BM='M-200 70 C-215 10 -175 -50 -110 -55 C-85 -95 -5 -100 25 -75 C70 -100 150 -85 165 -35 C215 -15 225 50 195 85 C200 120 175 140 150 135 L150 210 C150 235 120 235 120 210 L120 150 C80 160 40 158 20 150 L20 250 C20 278 -12 278 -12 250 L-12 150 C-50 158 -90 150 -110 145 L-110 190 C-110 214 -140 214 -140 190 L-140 135 C-185 125 -205 100 -200 70 Z';
const BC='M-360 -150 Q-360 -190 -320 -190 L320 -190 Q360 -190 360 -150 L360 140 Q360 180 320 180 L-110 180 L-210 260 L-190 180 L-320 180 Q-360 180 -360 140 Z';
const FL=window.flubber, OPT={maxSegmentLength:6};
const N2M=FL.interpolate(BN,BM,OPT), M2N=FL.interpolate(BM,BN,OPT), N2C=FL.interpolate(BN,BC,OPT);
const BR=el('g',{},G);
const bShadow=el('ellipse',{cx:0,cy:200,rx:170,ry:22,fill:'#000',opacity:.3},BR);
const bBody=el('path',{d:BN,fill:PINK,stroke:INK,'stroke-width':9,'stroke-linejoin':'round'},BR);
const GY=el('g',{fill:'none',stroke:'#C2407F','stroke-width':8,'stroke-linecap':'round'},BR);
['M0 -140 C-14 -80 14 -30 0 30','M-130 -40 q30 -30 60 0 q30 30 60 0','M40 -60 q40 -30 90 0','M-150 60 q40 -24 80 6','M50 70 q40 -20 90 10'].forEach(d=>el('path',{d},GY));
const FACE=el('g',{},BR);
const eyes=[-52,52].map(x=>{const g=el('g',{},FACE); const e=el('ellipse',{cx:x,cy:20,rx:16,ry:20,fill:INK},g); const h=el('circle',{cx:x+5,cy:12,r:5,fill:'#fff'},g); return {g,e,h,x};});
const mSmile=el('path',{d:'M-34 64 Q0 96 34 64',fill:'none',stroke:INK,'stroke-width':8,'stroke-linecap':'round'},FACE);
const mWavy=el('path',{d:'M-36 76 q9 -12 18 0 t18 0 t18 0 t18 0',fill:'none',stroke:INK,'stroke-width':7,'stroke-linecap':'round'},FACE);
const blush=[-92,92].map(x=>el('ellipse',{cx:x,cy:56,rx:22,ry:12,fill:'#FF3D8B',opacity:.5},FACE));
const DROP='M0 -26 C10 -10 18 0 18 10 A18 18 0 0 1 -18 10 C-18 0 -10 -10 0 -26 Z';
const DRIPS=[-125,4,135].map(x=>({x,e:el('path',{d:DROP,fill:PINK,stroke:INK,'stroke-width':5,opacity:0},BR)}));
const SPARK=[...Array(4)].map(()=>el('path',{d:'M0 -30 L8 -8 L30 0 L8 8 L0 30 L-8 8 L-30 0 L-8 -8 Z',fill:YEL,stroke:INK,'stroke-width':4,opacity:0},BR));
const ZZ=[...Array(3)].map((_,i)=>{const e=el('text',{'font-family':'Kanit','font-weight':900,'font-size':[70,56,44][i],fill:'#fff',stroke:INK,'stroke-width':9,'paint-order':'stroke',opacity:0},G); e.textContent='z'; return e;});
// pose tracks (positions move while hidden so the brain never flies across a cut)
const bX=track(540,[[T.oxford,190],[T.noproof+0.2,540,OUT],[T.heavy+0.2,880,OUT],[T.corr+0.2,540,OUT],[T.putdown,400],[T.sleep+0.2,540,OUT]]);
const bY=track(760,[[T.oxford,1020],[T.noproof+0.2,740,OUT],[T.heavy+0.2,440,OUT],[T.corr+0.2,840,OUT],[T.putdown,690],[T.sleep+0.2,720,OUT]]);
const bS=track(0,[[T.melt,1,BOUNCE],[T.oxford,0.36],[T.noproof,0,OUT],[T.brainok,1.1,BOUNCE],[T.heavy,0,OUT],[T.focus,0.34,BOUNCE],[T.corr,0,OUT],
  [T.trick,0.72,BOUNCE],[T.putdown,0.5],[T.sleep,0,OUT],[T.comment,1,BOUNCE],[T.loop,0,OUT]]);
const bR=track(0,[[T.putdown,-14],[T.sleep+0.2,0,OUT]]);
const meltP=t=>t<K.nao?0:(t<K.clip?clamp(S(t-K.nao,12,0.8)):1-clamp(S(t-K.clip,12,0.8)));
const comP=t=>t<K.khuenni?0:clamp(S(t-K.khuenni,12,0.85));
function brain(t){
  const s=bS(t); if(s<0.05){BR.setAttribute('opacity','0');ZZ.forEach(z=>z.setAttribute('opacity','0'));return;} BR.setAttribute('opacity','1');
  const c=comP(t), m=meltP(t), shake=(t>=T.supposed&&t<T.supposed+0.4)?6*Math.sin(t*90):0;
  const breathe=1+0.03*Math.sin(t*4.2)*(1-c);
  BR.setAttribute('transform',`translate(${f2(bX(t)+shake)} ${f2(bY(t)+8*Math.sin(t*2.2)*(1-c))}) rotate(${f2(bR(t)+2*Math.sin(t*1.6)*(1-c))}) scale(${f2(s*breathe)} ${f2(s/breathe)})`);
  let d; if(c>0) d=N2C(c); else if(t<K.clip) d=N2M(m); else d=M2N(1-m);
  bBody.setAttribute('d',d); bBody.setAttribute('fill',mix(PINK,'#FFF7FB',c));
  GY.setAttribute('opacity',f2((1-0.7*m)*(1-clamp(c*2.5))));
  GY.setAttribute('transform',`translate(0 ${f2(38*m)}) scale(1 ${f2(1-0.25*m)})`);
  const sleepy=(t>H.putdown+0.25&&t<T.sleep)?clamp((t-H.putdown-0.25)/0.15):0;
  FACE.setAttribute('opacity',f2(1-clamp(c*3))); FACE.setAttribute('transform',`translate(0 ${f2(42*m)})`);
  eyes.forEach(o=>{o.e.setAttribute('ry',f2(Math.max(2.5,20*(1-0.45*m)*(1-0.88*sleepy)))); o.h.setAttribute('opacity',f2(1-sleepy));});
  mSmile.setAttribute('opacity',f2(1-m)); mWavy.setAttribute('opacity',f2(m));
  bShadow.setAttribute('opacity',f2(0.3*(1-c))); bShadow.setAttribute('cy',f2(200+60*m));
  DRIPS.forEach((o,i)=>{const ph=((t*1.3+i*0.37)%1+1)%1, on=m>0.6; o.e.setAttribute('opacity',on?f2(clamp(ph*5)*(1-clamp((ph-0.75)/0.25))*m):'0');
    o.e.setAttribute('transform',`translate(${o.x} ${f2([225,280,225][i]+40*ph*ph)}) scale(0.8)`);});
  SPARK.forEach((p,i)=>{const a=K.clip+0.15+i*0.12, u=t-a, on=u>0&&t<T.heavy; const sc=on?S(u,16,0.5)*(1-clamp((u-0.7)/0.3)):0;
    const ang=-150+i*100; p.setAttribute('transform',`translate(${f2(250*Math.cos(ang*Math.PI/180))} ${f2(-40+220*Math.sin(ang*Math.PI/180))}) rotate(${f2(t*120)}) scale(${f2(Math.max(0,sc))})`); p.setAttribute('opacity',on?'1':'0');});
  ZZ.forEach((z,i)=>{const a=H.putdown+0.45+i*0.28, u=t-a, on=u>0&&t<T.sleep; if(!on){z.setAttribute('opacity','0');return;}
    const ph=(u%1.2)/1.2; z.setAttribute('x',f2(bX(t)+70+40*i+30*ph)); z.setAttribute('y',f2(bY(t)-90-60*i-90*ph)); z.setAttribute('opacity',f2(clamp(ph*5)*(1-clamp((ph-0.7)/0.3))*s/0.5));});
}

// ---------- the pill (one element morphing) ----------
const PST=[ // [t, text, colour, icon, centre x, centre y]
  [K.bon,'ความเชื่อ',RED,'circle-x',540,400,1.45],
  [K.oxford,'Oxford Word of the Year 2024',GRN,'circle-check',540,300,1.0],
  [K.niyam,null],
  [K.noproof,'ความจริง',YEL,'search',540,330,1.45],
  [K.clip,'ยังไม่มีหลักฐานว่าเน่าถาวร',ORG,'triangle-alert',540,330,1.12],
  [T.heavy,null],
  [K.yae+0.25,'สัมพันธ์',ORG,'triangle-alert',540,1012,1.3],
  [K.samphan,'สัมพันธ์ ≠ เป็นเหตุ',YEL,'triangle-alert',540,330,1.3],
  [T.stress,null],
];
const pill=$('pill'),pA=$('pillA'),pB=$('pillB'),pUse=$('pillUse');
function pillF(t){
  let i=-1; for(let k=0;k<PST.length;k++) if(t>=PST[k][0]) i=k;
  if(i<0){pill.style.opacity='0';return;}
  const cur=PST[i], prv=i>0?PST[i-1]:null, u=t-cur[0];
  let txt0,txt1,col0,col1,ic0,ic1,x0,x1,y0,y1,k0,k1,s0,s1,p;
  const sh=st=>st&&st[1]!=null;
  if(sh(cur)&&sh(prv)){ p=clamp(S(u,15,0.8)); [txt0,col0,ic0,x0,y0,k0]=prv.slice(1); [txt1,col1,ic1,x1,y1,k1]=cur.slice(1); s0=1;s1=1; }
  else if(sh(cur)){ p=1; [txt1,col1,ic1,x1,y1,k1]=cur.slice(1); txt0=txt1;col0=col1;ic0=ic1;x0=x1;y0=y1;k0=k1; s0=0; s1=1; }
  else if(sh(prv)){ p=1; [txt0,col0,ic0,x0,y0,k0]=prv.slice(1); txt1=txt0;col1=col0;ic1=ic0;x1=x0;y1=y0;k1=k0; s0=1; s1=0; }
  else {pill.style.opacity='0';return;}
  let sc; if(s0===0) sc=S(u,POP[0],POP[1]); else if(s1===0) sc=1-clamp(u/0.08); else sc=1+0.08*Math.sin(clamp(p)*Math.PI);
  if(sc<0.004){pill.style.opacity='0';return;}
  const w0=tw(txt0)+136, w1=tw(txt1)+136, w=lerp(w0,w1,p), x=lerp(x0,x1,p), y=lerp(y0,y1,p);
  pill.style.opacity='1'; pill.style.width=f2(w)+'px'; pill.style.background=mix(col0,col1,p);
  pill.style.transform=`translate(${f2(x-w/2)}px,${f2(y-48)}px) rotate(${f2(-2+1.2*Math.sin(t*2.3))}deg) scale(${(Math.max(0.001,sc)*lerp(k0,k1,p)).toFixed(4)})`;
  pA.textContent=txt0; pB.textContent=txt1; pA.style.opacity=f2(1-clamp(p*2.5)); pB.style.opacity=f2(clamp(p*2.5-0.3)); if(txt0===txt1){pA.style.opacity='0';pB.style.opacity='1';}
  pUse.setAttribute('href','#ic-'+(p<0.5?ic0:ic1));
}

// ---------- dictionary card ----------
const card=$('card'), CEND=T.noproof;
const numT=track(0,[[K.year,230,[5,1]]]);
function cardF(t){
  const v=win(t,T.oxford,CEND,BOUNCE); if(!show(card,Math.min(1,v*1.5)))return;
  const zoom=t>=T.supposed?S(t-T.supposed,10,0.85):0;
  card.style.transformOrigin='22% 58%';
  card.style.transform=`translateY(${f2(60*(1-clamp(v))+8*Math.sin(t*1.8))}px) rotate(${f2(-1.5*(1-clamp(v))+0.8*Math.sin(t*1.1))}deg) scale(${(Math.max(0.001,0.85+0.15*v)*(1+0.32*zoom)).toFixed(4)})`;
  $('uline').style.transform=`scaleX(${f2(clamp(S(t-K.oxford-0.1,12,0.9)))})`;
  // +230% counter (year shot) -> leaves for the definition
  const cnt=$('cnt'), cin=t>=K.year?S(t-K.year,POP[0],POP[1]):0, cout=t>=T.define?eo((t-T.define)/0.18):0;
  cnt.style.opacity=f2(clamp(cin)*(1-cout)); cnt.style.transform=`translateX(${f2(-260*cout)}px) scale(${f2(Math.max(0.001,0.7+0.3*cin))})`; cnt.style.transformOrigin='0 30%';
  const n=Math.min(230,Math.round(numT(t))); $('num').textContent='+'+(t>=K.year+1.15?230:n)+'%';
  // definition typed line by line (from "นิยาม"), Thai gloss after
  const def=$('def'), din=t>=T.define?eo((t-T.define-0.05)/0.15):0; def.style.opacity=f2(din);
  const span=[[K.niyam,K.niyam+0.55],[K.niyam+0.55,K.niyam+1.05],[K.niyam+1.05,K.sueam+0.1]];
  ['dl1','dl2','dl3'].forEach((id,i)=>{const r=clamp((t-span[i][0])/(span[i][1]-span[i][0])); $(id).style.clipPath=`inset(-10px ${f2(100-100*r)}% -10px -10px)`;});
  const g=t>=K.sueam?S(t-K.sueam,POP[0],POP[1]):0; const dim=t>=T.supposed?eo((t-T.supposed-0.05)/0.25):0; $('dgl').style.opacity=f2(clamp(g)*(1-0.8*dim)); $('dgl').style.transform=`translateY(${f2(20*(1-clamp(g)))}px)`;
  // "supposed": yellow marker sweeps on the glitch cut, other words dim
  const hl=t>=T.supposed?eo((t-T.supposed-0.05)/0.25):0; $('supbg').style.width=f2(($('sup').offsetWidth+16)*hl)+'px';
  ['dl2','dl3'].forEach(id=>{$(id).style.opacity=f2(1-0.8*hl);});
}
// glitch word "= คนคิดว่า" (registry rgb-glitch-text): steps of red/cyan offsets for 4 frames after the cut
const gw=$('gw1');
function glitchWord(t){
  const v=win(t,K.khit,CEND,POP); if(!show(gw,clamp(v*1.5)))return;
  gw.style.top='790px'; gw.style.transform=`scale(${f2(Math.max(0.001,0.6+0.4*v))}) rotate(${f2(-2+Math.sin(t*3))}deg)`;
  const fi=Math.floor((t-K.khit)*30), on=fi>=0&&fi<5, o=[[-10,10],[8,-12],[-14,6],[6,-8],[-4,4]][Math.max(0,fi)%5];
  gw.style.setProperty('--hf-glitch-red',(on?o[0]:0)+'px'); gw.style.setProperty('--hf-glitch-blue',(on?o[1]:0)+'px');
}

// ---------- bed: "02:00" chip + moon ----------
function clock2(t){const e=$('clock2'), v=win(t,K.tsong,T.melt,BOUNCE); if(!show(e,clamp(v*2)))return;
  e.style.transform=`translate(${f2(600+6*Math.sin(t*2))}px,${f2(290)}px) rotate(${f2(4*(1-clamp(v))+2*Math.sin(t*3))}deg) scale(${f2(Math.max(0.001,v))})`;}

// ---------- heavy: speed streaks (fast scroll) ----------
const STK=[...Array(8)].map((_,i)=>el('rect',{x:[90,170,880,960,250,820,130,930][i],width:10,height:220,rx:5,fill:'#E8E4FF',opacity:0},G));
function streaks(t){const on=t>=T.heavy&&t<T.focus; STK.forEach((r,i)=>{if(!on){r.setAttribute('opacity','0');return;}
  const ph=(((t-T.heavy)*2.6+i*0.27)%1+1)%1; r.setAttribute('y',f2(1500-1300*ph)); r.setAttribute('opacity',f2(0.55*Math.sin(ph*Math.PI)));});}

// ---------- focus meter + source tag ----------
const b1=track(0,[[K.test,430,MORPH]]), b2=track(0,[[K.test+0.08,430,MORPH],[K.yae,190,BOUNCE]]);
function focusF(t){const v=win(t,T.focus,T.corr,BOUNCE), p=$('panel');
  show($('src'),pinO(t,T.focus+0.1,T.corr)*0.95);
  if(!show(p,clamp(v*1.6)))return;
  p.style.transform=`translateY(${f2(70*(1-clamp(v))+6*Math.sin(t*1.9))}px) rotate(${f2(0.7*Math.sin(t*1.2))}deg) scale(${f2(Math.max(0.001,0.85+0.15*v))})`;
  $('bar1').style.width=f2(Math.max(0,b1(t)))+'px'; $('bar2').style.width=f2(Math.max(0,b2(t)))+'px';
  $('bar2').style.background=mix(ORG,RED,clamp((t-K.yae)/0.3));}

// ---------- correlation bubbles + double arrow ----------
const ARW=el('g',{opacity:0},G);
el('path',{d:'M-150 0 H150',stroke:'#fff','stroke-width':16,'stroke-linecap':'round'},ARW);
el('path',{d:'M110 -36 L156 0 L110 36',fill:'none',stroke:'#fff','stroke-width':16,'stroke-linecap':'round','stroke-linejoin':'round'},ARW);
el('path',{d:'M-110 -36 L-156 0 L-110 36',fill:'none',stroke:'#fff','stroke-width':16,'stroke-linecap':'round','stroke-linejoin':'round'},ARW);
function corrF(t){
  [['bubA',T.corr,250],['bubB',T.corr+0.1,830]].forEach(([id,a,cx],i)=>{const e=$(id), v=win(t,a,T.stress,BOUNCE);
    if(!show(e,clamp(v*2)))return; e.style.transform=`translate(${f2(cx-150+(i?1:-1)*14*Math.sin(t*5))}px,${f2(510+10*Math.sin(t*3+i))}px) scale(${f2(Math.max(0.001,v))})`;});
  const v=win(t,T.corr+0.2,T.stress,POP); ARW.setAttribute('opacity',f2(clamp(v*2)));
  ARW.setAttribute('transform',`translate(540 660) scale(${f2(Math.max(0.001,0.4*v+0.12*Math.sin(t*9)*clamp(v)))} 1)`);
}

// ---------- stress -> scroll loop chips ----------
const LOOPA=el('g',{opacity:0},G);
el('path',{d:'M-70 -40 A80 80 0 0 1 70 -40',fill:'none',stroke:YEL,'stroke-width':12,'stroke-linecap':'round'},LOOPA);
el('path',{d:'M48 -64 L74 -36 L40 -22',fill:'none',stroke:YEL,'stroke-width':12,'stroke-linecap':'round','stroke-linejoin':'round'},LOOPA);
el('path',{d:'M70 40 A80 80 0 0 1 -70 40',fill:'none',stroke:YEL,'stroke-width':12,'stroke-linecap':'round'},LOOPA);
el('path',{d:'M-48 64 L-74 36 L-40 22',fill:'none',stroke:YEL,'stroke-width':12,'stroke-linecap':'round','stroke-linejoin':'round'},LOOPA);
function loopChips(t){
  const end=T.trick;
  const vs=win(t,K.kriat,end,BOUNCE), slide=t>=T.scrollbed?S(t-T.scrollbed,14,0.8):0, e=$('chipS');
  if(show(e,clamp(vs*2))) e.style.transform=`translate(${f2(lerp(370,90,slide))}px,${f2(300+5*Math.sin(t*4))}px) rotate(${f2(-3+2*Math.sin(t*3))}deg) scale(${f2(Math.max(0.001,vs))})`;
  const vl=win(t,K.lnak,end,BOUNCE), l=$('chipL');
  if(show(l,clamp(vl*2))) l.style.transform=`translate(${f2(650)}px,${f2(300+5*Math.cos(t*4))}px) rotate(${f2(3-2*Math.sin(t*3))}deg) scale(${f2(Math.max(0.001,vl))})`;
  const va=win(t,K.lnak+0.05,end,POP); LOOPA.setAttribute('opacity',f2(clamp(va*2)));
  LOOPA.setAttribute('transform',`translate(540 355) rotate(${f2(t*260)}) scale(${f2(Math.max(0.001,0.75*va))})`);
}

// ---------- trick: title + glowing bulb above the brain ----------
const BULB=el('g',{opacity:0},G);
const bulbGlow=el('circle',{r:170,fill:YEL,opacity:.25},BULB);
el('circle',{r:96,fill:YEL,stroke:INK,'stroke-width':8},BULB);
const bulbIc=el('use',{href:'#ic-lightbulb',x:-80,y:-80,width:160,height:160,color:INK},BULB);
function trickF(t){
  const tt=$('trickT'), v=win(t,K.trick,T.putdown,BOUNCE);
  if(show(tt,clamp(v*2))) tt.style.transform=`scale(${f2(Math.max(0.001,0.5+0.5*v))}) rotate(${f2(-3*(1-clamp(v))+Math.sin(t*3))}deg)`;
  const vb=win(t,K.trick+0.08,T.putdown,BOUNCE); BULB.setAttribute('opacity',f2(clamp(vb*2)));
  BULB.setAttribute('transform',`translate(540 ${f2(600+8*Math.sin(t*3))}) scale(${f2(Math.max(0.001,vb))})`);
  bulbGlow.setAttribute('r',f2(150+30*Math.sin(t*10)));
}

// ---------- putdown: bed + phone flung onto the nightstand, face-down, landing on "เตียง" (hit) ----------
const BED=el('g',{opacity:0},G);
el('rect',{x:0,y:0,width:150,height:130,rx:14,fill:'#2B2160',stroke:INK,'stroke-width':8,transform:'translate(715 905)'},BED); // nightstand
const bedIc=el('use',{href:'#ic-bed',x:0,y:0,width:24,height:24,color:'#FFF8EE'},el('g',{transform:'translate(140 560) scale(24)'},BED));
const PH=el('g',{opacity:0},G);
el('rect',{x:-56,y:-104,width:112,height:208,rx:20,fill:'#1B1B2F',stroke:INK,'stroke-width':8},PH);
const phScr=el('rect',{x:-44,y:-88,width:88,height:170,rx:10,fill:'#7FD3FF'},PH);
const phGlow=el('circle',{r:150,fill:'#7FD3FF',opacity:.18},PH);
const MOON=el('use',{href:'#ic-moon',x:-60,y:-60,width:120,height:120,color:YEL,opacity:0},G);
function putdownF(t){
  const a=T.putdown, b=T.sleep, v=win(t,a,b,BOUNCE);
  BED.setAttribute('opacity',f2(clamp(v*2))); BED.setAttribute('transform',`translate(0 ${f2(40*(1-clamp(v)))})`);
  MOON.setAttribute('opacity',f2(clamp(win(t,a+0.1,b,POP)*2))); MOON.setAttribute('transform',`translate(${f2(840)} ${f2(330+8*Math.sin(t*2))}) rotate(${f2(-10+5*Math.sin(t*1.5))})`);
  const vp=win(t,a,b,POP); if(vp<0.003){PH.setAttribute('opacity','0');return;} PH.setAttribute('opacity','1');
  // held by the brain (glowing) until the throw, lands at hit, settles
  const t0=a+0.04, t1=H.putdown, u=clamp((t-t0)/(t1-t0)), land=t>=t1?S(t-t1,20,0.45):0;
  const x=lerp(560,790,eio(u)), y=lerp(640,880,u)-120*Math.sin(Math.PI*u)+10*(1-land)*(t>=t1?1:0);
  const rot=lerp(-18,90,eio(u)), sy=t>=t1?lerp(1,0.9,clamp(land)):1;
  PH.setAttribute('transform',`translate(${f2(x)} ${f2(y)}) rotate(${f2(rot)}) scale(${f2(Math.max(0.001,vp)*0.8)} ${f2(Math.max(0.001,vp)*0.8*sy)})`);
  const off=t>=t1?clamp((t-t1)/0.12):0; phScr.setAttribute('fill',mix('#7FD3FF','#1B1B2F',off)); phGlow.setAttribute('opacity',f2(0.18*(1-off)));
}

// ---------- sleep: small advice note ----------
function noteF(t){const e=$('note'), v=pinO(t,T.sleep+0.05,T.comment); show(e,v); e.style.transform=`translateY(${f2(10*(1-v))}px)`;}

// ---------- comment: text inside the bubble the brain became ----------
const CLK=el('g',{opacity:0},G); el('circle',{r:56,fill:YEL,stroke:INK,'stroke-width':8},CLK);
const clkIc=el('use',{href:'#ic-clock',x:-40,y:-40,width:80,height:80,color:INK},CLK);
const DOTS=el('g',{opacity:0},G); el('rect',{x:-90,y:-42,width:180,height:84,rx:42,fill:'#FFF7FB',stroke:INK,'stroke-width':7},DOTS);
const dts=[-44,0,44].map(x=>el('circle',{cx:x,cy:0,r:13,fill:INK},DOTS));
function commentF(t){
  const ct=$('ctext'), a=K.khuenni+0.18, v=win(t,a,T.loop,POP);
  if(show(ct,clamp(v*2))) ct.style.transform=`translateY(${f2(560+16*(1-clamp(v)))}px) scale(${f2(Math.max(0.001,0.8+0.2*v))})`;
  const q2=t>=K.kimong?S(t-K.kimong,POP[0],POP[1]):0; $('q2').style.transform=`scale(${f2(Math.max(0.001,q2))}) rotate(${f2(-3*Math.sin(t*4))}deg)`;
  const q3=t>=K.kimong+0.35?S(t-K.kimong-0.35,POP[0],POP[1]):0; $('q3').style.opacity=f2(clamp(q3)); $('q3').style.transform=`translateY(${f2(16*(1-clamp(q3)))}px)`;
  const vc=win(t,a+0.1,T.loop,BOUNCE); CLK.setAttribute('opacity',f2(clamp(vc*2)));
  CLK.setAttribute('transform',`translate(206 548) rotate(${f2(-10+8*Math.sin(t*5))}) scale(${f2(Math.max(0.001,vc))})`);
  clkIc.setAttribute('transform',`rotate(${f2(t*90)} 0 0)`);
  const vd=win(t,K.kimong+0.5,T.loop,POP); DOTS.setAttribute('opacity',f2(clamp(vd*2)));
  DOTS.setAttribute('transform',`translate(300 1010) scale(${f2(Math.max(0.001,vd))})`);
  dts.forEach((d,i)=>d.setAttribute('cy',f2(-10*Math.max(0,Math.sin(t*9-i*0.9)))));
}

// ---------- captions: spring in on the word; last chunk clears before the loop seam ----------
const capEls=CAPT.map((s,i)=>$('c'+i).querySelector('span'));
function captions(t){
  let i=-1; for(let k=0;k<CAPT.length;k++) if(t>=CAPT[k]) i=k;
  if(i<0) return; const tau=t-CAPT[i]; const a=S(tau,30,0.6);
  const fade=i===CAPT.length-1?1-clamp((t-(DUR-0.17))/0.1):1;
  capEls[i].style.opacity=f2(fade);
  capEls[i].style.transform=`translateY(${f2(22*(1-a))}px) scale(${(0.78+0.22*a).toFixed(4)}) rotate(${f2(0.6*Math.sin(t*3))}deg)`;
}

function render(t){ scenes(t); stars(t); fx(t); title(t); clock2(t); cardF(t); glitchWord(t); brain(t); pillF(t); streaks(t); focusF(t);
  corrF(t); loopChips(t); trickF(t); putdownF(t); noteF(t); commentF(t); captions(t); }
const proxy={_t:0}; Object.defineProperty(proxy,'t',{get(){return this._t;},set(v){this._t=v;render(v);}});
const tl=gsap.timeline({paused:true});
tl.to(proxy,{t:%%DUR%%,duration:%%DUR%%,ease:'none'},0);
render(0);
if(document.fonts&&document.fonts.ready)document.fonts.ready.then(()=>render(proxy._t));
window.__timelines=window.__timelines||{}; window.__timelines["main"]=tl;
})();
</script>
</body></html>
