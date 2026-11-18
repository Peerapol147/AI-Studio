<!doctype html>
<!-- GENERATED: edit index.html.tpl, then run `python3 build_index.py` -->
<html lang="th"><head><meta charset="UTF-8"/><meta name="viewport" content="width=1080, height=1920"/>
<link rel="stylesheet" href="fonts/fonts.css"/>
<script src="https://cdn.jsdelivr.net/npm/gsap@3.15.0/dist/gsap.min.js"></script>
<style>
*{margin:0;padding:0;box-sizing:border-box}
html,body{width:1080px;height:1920px;overflow:hidden;background:#000}
#root{position:relative;width:1080px;height:1920px;overflow:hidden;font-family:'Kanit',sans-serif;background:#0B1220}
.sc{position:absolute;left:0;top:0;width:1080px;height:1920px;overflow:hidden;opacity:0}
.fw,.kb{position:absolute;left:0;top:0;width:1080px;height:1920px}
.vl{position:absolute;left:0;top:0;width:1080px;height:1920px}
.fill{position:absolute;left:0;top:0;width:1080px;height:1920px;object-fit:cover}
.band{position:absolute;left:0;width:1080px;object-fit:cover;
  -webkit-mask-image:linear-gradient(to bottom,transparent 0,#000 150px,#000 calc(100% - 150px),transparent 100%);
  mask-image:linear-gradient(to bottom,transparent 0,#000 150px,#000 calc(100% - 150px),transparent 100%)}
.vig{position:absolute;left:0;top:0;width:1080px;height:1920px;background:radial-gradient(ellipse at 50% 45%,rgba(0,0,0,0) 55%,rgba(0,0,0,.45) 100%)}
.sweep{position:absolute;left:-600px;top:-200px;width:420px;height:2400px;mix-blend-mode:screen;opacity:.4;
  background:linear-gradient(90deg,rgba(255,255,255,0) 0,rgba(255,250,235,.5) 50%,rgba(255,255,255,0) 100%)}
.ov{position:absolute;left:0;top:0;width:1080px;height:1920px;overflow:visible}
.dbg{position:absolute;left:0;top:0;width:1080px;height:1920px;background:radial-gradient(ellipse at 50% 34%,#22375C 0%,#132038 55%,#0A111F 100%)}
.grid{position:absolute;left:-200px;top:-200px;width:1480px;height:2320px;opacity:.16;
  background-image:linear-gradient(#5D7FB5 2px,transparent 2px),linear-gradient(90deg,#5D7FB5 2px,transparent 2px);background-size:80px 80px}
.dsvg{position:absolute;left:0;top:0;width:1080px;height:1920px;
  -webkit-mask-image:linear-gradient(to bottom,#000 0,#000 1060px,transparent 1160px);mask-image:linear-gradient(to bottom,#000 0,#000 1060px,transparent 1160px)}
#tshade{position:absolute;left:0;top:0;width:1080px;height:820px;background:linear-gradient(rgba(5,5,10,.7),rgba(5,5,10,0))}
#title{position:absolute;left:0;top:0;width:1080px;height:760px}
#title .tl{position:absolute;left:0;width:1080px;text-align:center;font-weight:900;line-height:1;white-space:nowrap;
  -webkit-text-stroke:28px #10080A;paint-order:stroke fill;transform-origin:50% 60%}
.chip{position:absolute;left:0;top:0;height:96px;border-radius:48px;opacity:0;overflow:hidden;border:7px solid #10080A}
.chip span{position:absolute;left:50%;top:50%;transform:translate(-50%,-54%);font-weight:900;font-size:50px;white-space:nowrap;color:#fff}
#bars{position:absolute;left:0;top:0;width:620px;height:500px;opacity:0}
#bubble{position:absolute;left:0;top:0;width:640px;height:440px;opacity:0}
#caps{position:absolute;left:0;top:0;width:1080px;height:1920px;z-index:60;pointer-events:none}
.cap{position:absolute;left:40px;width:1000px;top:1190px;height:0;text-align:center}
.cap span{position:absolute;left:0;width:1000px;bottom:-52px;display:block;color:#fff;font-weight:700;line-height:1.18;white-space:nowrap;
  -webkit-text-stroke:17px #000;paint-order:stroke fill;transform-origin:50% 80%}
.cap em{font-style:normal;color:#FFD23F}
</style></head><body>
<div id="root" data-composition-id="main" data-start="0" data-duration="%%DUR%%" data-width="1080" data-height="1920"
 data-motion-blur="on" data-motion-blur-events="on"
 data-composition-variables='[{"id":"lang","type":"string","label":"Language (th | en)","default":"th"},{"id":"vo","type":"string","label":"Voice file","default":"assets/vo-th.mp3"}]'>

<div id="scenes" data-layout-allow-overflow data-layout-allow-overlap style="position:absolute;left:0;top:0;width:1080px;height:1920px;z-index:0;isolation:isolate">
  <div class="sc" id="sh-hook" style="background:#06070B"><div class="fw" id="fw-hook"></div>
    <div class="kb" id="kb-hook">%%V_hook%%<svg class="ov" id="hookov" viewBox="0 0 1080 1920"></svg></div><div class="vig"></div><div class="sweep" id="sw-hook"></div></div>
  <div class="sc" id="sc-brain"><div class="dbg"></div><div class="grid" id="grid-b"></div>
    <svg class="dsvg" viewBox="0 0 1080 1920" width="1080" height="1920">
      <defs>
        <radialGradient id="redg"><stop offset="0" stop-color="#FF4D4D" stop-opacity=".8"/><stop offset=".5" stop-color="#E0202E" stop-opacity=".35"/><stop offset="1" stop-color="#E0202E" stop-opacity="0"/></radialGradient>
        <radialGradient id="hotg"><stop offset="0" stop-color="#FFB15C" stop-opacity=".9"/><stop offset=".5" stop-color="#FF6A1A" stop-opacity=".4"/><stop offset="1" stop-color="#FF6A1A" stop-opacity="0"/></radialGradient>
        <radialGradient id="coolg"><stop offset="0" stop-color="#BFF0FF" stop-opacity=".9"/><stop offset=".5" stop-color="#3FB4FF" stop-opacity=".4"/><stop offset="1" stop-color="#3FB4FF" stop-opacity="0"/></radialGradient>
        <linearGradient id="headg" x1="0" x2="1" y1="0" y2="1"><stop offset="0" stop-color="#3A5A8F"/><stop offset="1" stop-color="#22385F"/></linearGradient>
        <clipPath id="tankcp"><rect x="-58" y="-200" width="116" height="400" rx="58"/></clipPath>
      </defs>
      <g id="bcam"></g>
    </svg><div class="vig"></div></div>
  <div class="sc" id="sh-mask"><div class="fw" id="fw-mask"><img class="fill" src="assets/mask-fill.jpg" alt=""/></div>
    <div class="kb" id="kb-mask"><img class="band" src="assets/mask-crop.jpg" style="top:140px;height:1364px" alt=""/>
      <svg class="ov" id="maskov" viewBox="0 0 1080 1920"></svg></div><div class="vig"></div><div class="sweep" id="sw-mask"></div></div>
  <div class="sc" id="sh-same" style="background:#06070B"><div class="fw" id="fw-same"></div>
    <div class="kb" id="kb-same">%%V_same%%</div><div class="vig"></div></div>
  <div class="sc" id="sh-warn"><div class="fw" id="fw-warn">%%F_warn%%</div>
    <div class="kb" id="kb-warn">%%V_warn%%</div><div class="vig"></div><div class="sweep" id="sw-warn"></div></div>
  <div class="sc" id="sh-doctor"><div class="fw" id="fw-doctor" style="background:#F3F5F7"></div>
    <div class="kb" id="kb-doctor"><img class="band" src="assets/doctor-crop.jpg" style="top:200px;height:1279px" alt=""/></div><div class="sweep" id="sw-doctor"></div></div>
  <div class="sc" id="sh-ask"><div class="fw" id="fw-ask">%%F_ask%%</div>
    <div class="kb" id="kb-ask">%%V_ask%%</div><div class="vig"></div><div class="sweep" id="sw-ask"></div></div>
</div>

<div id="over" data-layout-allow-overflow data-layout-allow-overlap style="position:absolute;left:0;top:0;width:1080px;height:1920px;z-index:10">
  <div class="chip" id="chipM"><span id="chipM1"></span><span id="chipM2"></span><span id="chipM3"></span></div>
  <svg id="bars" viewBox="0 0 620 500">
    <rect x="10" y="10" width="600" height="480" rx="48" fill="#fff" stroke="#10080A" stroke-width="12"/>
    <text id="barsH" x="310" y="92" text-anchor="middle" font-family="Kanit" font-weight="900" font-size="58" fill="#10080A"></text>
    <line x1="70" y1="392" x2="550" y2="392" stroke="#10080A" stroke-width="8" stroke-linecap="round"/>
    <rect id="barA" x="120" width="150" rx="18" fill="#1E9BF0" stroke="#10080A" stroke-width="8"/>
    <rect id="barB" x="350" width="150" rx="18" fill="#9AA5B5" stroke="#10080A" stroke-width="8"/>
    <g id="o2b"><rect x="-62" y="-30" width="124" height="60" rx="30" fill="#1E9BF0" stroke="#10080A" stroke-width="6"/>
      <text x="0" y="16" text-anchor="middle" font-family="Kanit" font-weight="900" font-size="40" fill="#fff">+O₂</text></g>
    <text id="labA" x="195" y="458" text-anchor="middle" font-family="Kanit" font-weight="900" font-size="50" fill="#10080A"></text>
    <text id="labB" x="425" y="458" text-anchor="middle" font-family="Kanit" font-weight="900" font-size="50" fill="#10080A"></text>
    <g id="eqm" opacity="0"><path d="M285 230 h50 M285 256 h50" stroke="#FFD23F" stroke-width="14" stroke-linecap="round"/>
      <path d="M285 230 h50 M285 256 h50" stroke="#10080A" stroke-width="4" stroke-linecap="round" fill="none" opacity=".0"/></g>
  </svg>
  <svg id="bubble" viewBox="0 0 640 440"><path d="M60 16h520a44 44 0 0 1 44 44v228a44 44 0 0 1-44 44H230l-96 84v-84H60a44 44 0 0 1-44-44V60a44 44 0 0 1 44-44Z" fill="#fff" stroke="#10080A" stroke-width="16" stroke-linejoin="round"/>
    <text id="bubT" x="320" y="200" text-anchor="middle" font-family="Kanit" font-weight="900" font-size="96" fill="#1E9BF0" stroke="#10080A" stroke-width="10" paint-order="stroke"></text>
    <g id="dots"><circle cx="260" cy="270" r="14" fill="#10080A"/><circle cx="320" cy="270" r="14" fill="#10080A"/><circle cx="380" cy="270" r="14" fill="#10080A"/></g></svg>
  <div id="tshade"></div>
  <div id="title"><div class="tl" id="tl1"></div><div class="tl" id="tl2"></div></div>
</div>

<div id="caps" data-track-kind="captions">
 <div id="caps-th">
%%CAPS_TH%%
 </div>
 <div id="caps-en">
%%CAPS_EN%%
 </div>
</div>

<audio id="vo" class="clip" data-start="0" data-duration="%%DUR%%" data-track-index="30" data-volume="1" data-var-src="vo" src="assets/vo-th.mp3"></audio>
<audio id="music" class="clip" data-start="0" data-duration="%%DUR%%" data-track-index="31" data-volume="0.1" src="assets/music-jamendo-4228fb9b.mp3"></audio>
</div>

<script>
/* Motion: closed-form springs (motion-broll engine). One head + brain diagram morphs through every graphic shot
   (myth -> o2 -> pure, idea -> cool -> debate); footage shots are timed by shots-<lang>.json (data-media-start).
   Shot times = assets/audio/shots-<lang>.json, word anchors = words*.json (both injected by build_index.py). */
(function(){
const VARS=(window.__hyperframes&&window.__hyperframes.getVariables&&window.__hyperframes.getVariables())||{};
const LANG=(VARS.lang==='en')?'en':'th', EN=LANG==='en';
const ALL=%%DATA%%, D=ALL[LANG], DUR=D.dur, CAPT=D.capt, K=D.k, SH=D.sh;
document.getElementById(EN?'caps-th':'caps-en').style.display='none';
document.querySelectorAll('.vl-'+(EN?'th':'en')).forEach(e=>e.style.display='none');
document.documentElement.lang=LANG;
const T={},H={},W={}; for(const k in SH){T[k]=SH[k].start; W[k]=SH[k].word; if(SH[k].hit!=null)H[k]=SH[k].hit;}
const TX=EN?{t:['WHY DO WE','YAWN?'],myth:'MYTH',fact:'FACT',theory:'THEORY',o2:'O₂',full:'100%',
   barsH:'YAWNING',a:'BEFORE',b:'AFTER',bub:'HOW MANY?'}
 :{t:['ทำไมเรา','ถึงหาว?'],myth:'ความเชื่อ',fact:'ความจริง',theory:'สมมติฐาน',o2:'O₂',full:'100%',
   barsH:'การหาว',a:'ก่อน',b:'หลัง',bub:'หาวไปกี่ที?'};
const NS='http://www.w3.org/2000/svg';

// ---------- spring kit ----------
const clamp=(x,a=0,b=1)=>Math.min(b,Math.max(a,x)), lerp=(a,b,u)=>a+(b-a)*u;
const eo=x=>{x=clamp(x);return 1-Math.pow(1-x,3)}, eio=x=>{x=clamp(x);return x*x*x*(x*(6*x-15)+10)}, ei=x=>{x=clamp(x);return x*x*x};
const S=(tau,w,z)=>{if(tau<=0)return 0;
  if(z<1){const wd=w*Math.sqrt(1-z*z);return 1-Math.exp(-z*w*tau)*(Math.cos(wd*tau)+z*w/wd*Math.sin(wd*tau));}
  return 1-Math.exp(-w*tau)*(1+w*tau);};
const MORPH=[15,0.84],FAST=[26,0.8],SLOW=[8,0.95],BOUNCE=[18,0.55],CAM=[7.5,1],CAMF=[13,1];
const track=(v0,keys,def=MORPH)=>{let p=v0;const ks=[];for(const k of keys){const d=k[1]-p;p=k[1];const sp=k[2]||def;if(d!==0)ks.push([k[0],d,sp[0],sp[1]]);}
  return t=>{let v=v0;for(const k of ks)v+=k[1]*S(t-k[0],k[2],k[3]);return v;};};
const hex=h=>[1,3,5].map(i=>parseInt(h.slice(i,i+2),16));
const mixA=(x,y,u)=>x.map((v,i)=>lerp(v,y[i],clamp(u)));
const rgb=a=>`rgb(${a.map(v=>Math.round(v)).join(',')})`;
const mix=(a,b,u)=>rgb(mixA(hex(a),hex(b),u));
const vis=(t,tin,tout,o={})=>{const lin=o.lin??0.2,lout=o.lout??0.14,bl=o.blur??10;
  const a=tin==null?1:eo((t-tin)/lin), b=tout==null?0:eo((t-tout)/lout);
  return {o:a*(1-b),blur:(1-a)*bl+b*bl,a,b};};
const $=id=>document.getElementById(id);
const el=(tag,attrs,parent)=>{const e=document.createElementNS(NS,tag);for(const k in attrs)e.setAttribute(k,attrs[k]);parent.appendChild(e);return e;};
const show=(e,o)=>{e.style.opacity=o<0.003?'0':o.toFixed(4);return o>=0.003;};
const blur=(e,b)=>{e.style.filter=b>0.05?`blur(${b.toFixed(2)}px)`:'none';};
const f2=v=>v.toFixed(2);

// ---------- scenes: each shot window with its entry transition (whip <=0.12 s / zoom-through / match) ----------
const SC=[
 {id:'sh-hook',a:0,b:T.myth,kb:'kb-hook',fw:'fw-hook',s0:1.0,s1:1.08,r0:0,r1:-1.2,org:'50% 55%',in:'none'},
 {id:'sc-brain',a:T.myth,b:T.mask,in:'zoom'},
 {id:'sh-mask',a:T.mask,b:T.pure,kb:'kb-mask',fw:'fw-mask',s0:1.0,s1:1.12,r0:-1,r1:1,org:'38% 40%',in:'match'},
 {id:'sc-brain',a:T.pure,b:T.same,in:'zoom'},
 {id:'sh-same',a:T.same,b:T.idea,kb:'kb-same',fw:'fw-same',s0:1.02,s1:1.1,r0:1,r1:-0.6,org:'50% 55%',in:'whip'},
 {id:'sc-brain',a:T.idea,b:T.warn,in:'zoom'},
 {id:'sh-warn',a:T.warn,b:T.doctor,kb:'kb-warn',fw:'fw-warn',s0:1.0,s1:1.1,r0:-1,r1:0.8,org:'50% 40%',in:'whip'},
 {id:'sh-doctor',a:T.doctor,b:T.ask,kb:'kb-doctor',fw:'fw-doctor',s0:1.02,s1:1.12,r0:1,r1:-0.8,org:'50% 30%',in:'match'},
 {id:'sh-ask',a:T.ask,b:DUR+1,kb:'kb-ask',fw:'fw-ask',s0:1.04,s1:1.12,r0:-1,r1:0.6,org:'50% 45%',in:'zoom'},
];
SC.forEach((s,i)=>{s.next=SC[i+1]; if(s.kb)$(s.kb).style.transformOrigin=s.org; $(s.id).style.zIndex=String(i+1);});
const WHIP=0.12, ZIN=0.22;
function sceneState(s,t){ // null (hidden) or {o,tx,sc}
  if(t<s.a)return null;
  const nx=s.next, end=nx?nx.a:DUR+1, u=t-s.a; let o=1,tx=0,sc=1;
  if(s.in==='whip'){ tx=1080*(1-eo(u/WHIP)); }
  else if(s.in==='zoom'){ o=eio(u/0.1); sc=1+0.35*(1-S(u,16,0.9)); }
  else if(s.in==='match'){ o=eio(u/0.1); sc=1+0.06*(1-eo(u/0.3)); }
  if(nx){
    if(nx.in==='whip'){ if(t>=end+WHIP)return null; if(t>=end) tx=-1080*eo((t-end)/WHIP); }
    else if(nx.in==='zoom'){ if(t>=end+0.1)return null; const z=(t-(end-ZIN))/ZIN; if(z>0) sc*=1+1.6*ei(z); }
    else { if(t>=end+0.12)return null; }
  }
  return {o,tx,sc};
}
const SCIDS=[...new Set(SC.map(s=>s.id))];
function scenes(t){
  const st={};
  SC.forEach((s,i)=>{const r=sceneState(s,t); if(r)st[s.id]={r,s,i};});
  for(const id of SCIDS) if(!st[id]) $(id).style.opacity='0';
  for(const id in st){const {r,s,i}=st[id]; const e=$(id);
    e.style.zIndex=String(i+1);
    e.style.opacity=r.o.toFixed(4); e.style.transform=`translateX(${f2(r.tx)}px) scale(${r.sc.toFixed(4)})`;
    if(s.kb){ const uu=clamp((t-s.a)/Math.max(0.3,(Math.min(s.b,DUR)-s.a)));
      let k=lerp(s.s0,s.s1,eio(0.12+0.88*uu)); const rr=lerp(s.r0,s.r1,uu);
      let dx=9*Math.sin(t*1.7+s.a), dy=7*Math.cos(t*1.3+s.a);
      // punch-in accents on the hit word (hook: mouth widest on "หาว"/"yawn"; same: "เท่าเดิม"/"much")
      const hit=id==='sh-hook'?H.hook:id==='sh-same'?H.same:id==='sh-ask'?T.ask+0.1:null;
      if(hit!=null){ const tau=t-hit; if(tau>0){ k*=1+0.07*S(tau,20,0.5); const sh=Math.exp(-8*tau); dx+=10*sh*Math.sin(tau*70); dy+=7*sh*Math.cos(tau*83);} }
      $(s.kb).style.transform=`translate(${f2(dx)}px,${f2(dy)}px) rotate(${rr.toFixed(3)}deg) scale(${k.toFixed(5)})`;
      // parallax: the blurred fill drifts the other way, slower
      $(s.fw).style.transform=`translate(${f2(-14*Math.sin(t*0.9+s.a)-30*uu)}px,${f2(-10*Math.cos(t*0.7+s.a))}px) rotate(${f2(-0.5*rr)}deg) scale(${(1.12+0.05*uu).toFixed(4)})`;
    }
  }
  // light sweeps
  [['sw-hook',0.05,1.0],['sw-mask',T.mask+0.1,1.0],['sw-warn',T.warn+0.2,1.1],['sw-doctor',T.doctor,0.7],['sw-ask',T.ask+0.4,1.2]].forEach(([id,a,d])=>{
    const u=(t-a)/d; $(id).style.transform=`translateX(${(lerp(-300,1900,clamp(u))).toFixed(1)}px) rotate(14deg)`;});
}

// ---------- hook: title from frame 0 (breathes), yawn burst on the mouth at the hit word ----------
(function(){const t=TX.t; $('tl1').textContent=t[0]; $('tl2').textContent=t[1];
  if(EN){ $('tl1').style.cssText+='top:190px;font-size:160px;color:#fff'; $('tl2').style.cssText+='top:380px;font-size:230px;color:#FFD23F'; }
  else { $('tl1').style.cssText+='top:200px;font-size:172px;color:#fff'; $('tl2').style.cssText+='top:410px;font-size:190px;color:#FFD23F'; } })();
function title(t){
  const out=eo((t-(T.myth-0.06))/0.12);
  show($('title'),1-out); show($('tshade'),1-out);
  const HT=H.hook, br=1+0.04*(0.5-0.5*Math.cos(t*2*Math.PI/0.9));
  const kick=1+0.07*(t>HT?Math.exp(-7*(t-HT))*Math.sin((t-HT)*14):0);
  ['tl1','tl2'].forEach((id,i)=>{const last=i===1;
    $(id).style.transform=`translateY(${f2(4*Math.sin(t*3+i))}px) rotate(${f2(last?-1.5*Math.sin(t*2.4):0)}deg) scale(${(br*(last?kick:1)*(1+0.3*out)).toFixed(4)})`;
    const sx=8*Math.sin(t*2.2+i), sy=12+5*Math.cos(t*1.8);
    $(id).style.textShadow=`${f2(sx)}px ${f2(sy)}px 0 rgba(0,0,0,.5)`;});
}
function burst(set,t,t0,x,y,R){set.forEach((p,i)=>{const tau=t-t0; if(tau<0||tau>0.5){p.setAttribute('opacity','0');return;}
  const a=i/set.length*Math.PI*2+0.3, r1=R+110*eo(tau/0.3), r2=R+40+160*eo(tau/0.22);
  p.setAttribute('d',`M${f2(x+Math.cos(a)*r1)} ${f2(y+Math.sin(a)*r1)} L${f2(x+Math.cos(a)*r2)} ${f2(y+Math.sin(a)*r2)}`);
  p.setAttribute('opacity',(1-eo((tau-0.15)/0.35)).toFixed(3));});}
const MOUTH=[530,1265];
const HB=[...Array(9)].map(()=>el('path',{stroke:'#FFD23F','stroke-width':12,'stroke-linecap':'round',fill:'none',opacity:0},$('hookov')));
const HR=el('circle',{cx:MOUTH[0],cy:MOUTH[1],fill:'none',stroke:'#FFD23F','stroke-width':10,opacity:0},$('hookov'));
function hookov(t){ if(t>T.myth+0.2){HB.forEach(p=>p.setAttribute('opacity','0')); HR.setAttribute('opacity','0'); return;} burst(HB,t,H.hook-0.04,MOUTH[0],MOUTH[1],80);
  const u=(t-H.hook+0.04)/0.45; HR.setAttribute('opacity',(u>0&&u<1?(1-u)*0.9:0).toFixed(3)); HR.setAttribute('r',f2(60+220*eo(u))); }

// ---------- the head + brain (one diagram, morphs: myth -> o2 -> pure -> idea -> cool -> debate) ----------
const B={}; (function(){const g=el('g',{},$('bcam')); B.g=g;
  B.halo=el('circle',{cx:-10,cy:-170,r:300,fill:'url(#redg)',opacity:0},g);
  B.hot=el('circle',{cx:-10,cy:-170,r:330,fill:'url(#hotg)',opacity:0},g);
  B.cold=el('circle',{cx:-10,cy:-170,r:330,fill:'url(#coolg)',opacity:0},g);
  B.head=el('path',{d:'M-150 430 C-160 300 -200 240 -240 170 C-305 60 -310 -190 -205 -300 C-110 -400 90 -410 180 -300 C225 -245 240 -180 243 -120 C246 -88 300 -40 306 -12 C310 10 282 22 262 30 C272 46 270 60 258 68 L258 128 C262 150 252 180 226 194 C190 214 122 218 74 228 C62 300 62 360 72 430 Z',
    fill:'url(#headg)',stroke:'#CFE3FF','stroke-width':10,'stroke-linejoin':'round'},g);
  B.mouth=el('path',{fill:'#10080A',stroke:'#CFE3FF','stroke-width':6},g);
  B.eye=el('path',{d:'M150 -140 Q178 -128 200 -142',fill:'none',stroke:'#CFE3FF','stroke-width':9,'stroke-linecap':'round'},g);
  B.brain=el('path',{stroke:'#10080A','stroke-width':9,'stroke-linejoin':'round'},g);
  B.cereb=el('ellipse',{cx:-185,cy:-40,rx:70,ry:46,stroke:'#10080A','stroke-width':8},g);
  B.gyri=el('g',{fill:'none',stroke:'#10080A','stroke-width':7,'stroke-linecap':'round',opacity:.45},g);
  ['M-180 -200 q30 -40 70 -10 q30 30 60 -10','M-60 -280 q20 40 60 30 q40 -10 50 30','M-150 -110 q40 -30 80 0 q40 30 90 -10',
   'M40 -200 q30 -30 70 0','M-30 -170 q10 30 50 20','M-220 -150 q20 20 10 50','M80 -110 q30 -20 60 10'].forEach(d=>el('path',{d},B.gyri));
  B.heat=[...Array(5)].map(()=>el('path',{fill:'none',stroke:'#FF8A3D','stroke-width':12,'stroke-linecap':'round',opacity:0},g));
  B.mol=[...Array(10)].map(()=>{const m=el('g',{opacity:0},g); el('circle',{cx:-11,r:15,fill:'#BFE7FF',stroke:'#10080A','stroke-width':4},m); el('circle',{cx:11,r:15,fill:'#BFE7FF',stroke:'#10080A','stroke-width':4},m); return m;});
  B.air=[...Array(4)].map(()=>el('path',{fill:'none',stroke:'#7FD6FF','stroke-width':14,'stroke-linecap':'round',opacity:0},g));
  B.airH=[...Array(4)].map(()=>el('path',{fill:'none',stroke:'#7FD6FF','stroke-width':14,'stroke-linecap':'round','stroke-linejoin':'round',opacity:0},g));
  // O2 tank gauge
  B.gauge=el('g',{opacity:0},g);
  el('rect',{x:-58,y:-200,width:116,height:400,rx:58,fill:'#0E1A2E'},B.gauge);
  B.level=el('rect',{x:-58,width:116,height:0,'clip-path':'url(#tankcp)'},B.gauge);
  B.shine=el('rect',{x:-40,y:-170,width:18,height:300,rx:9,fill:'#fff',opacity:.25},B.gauge);
  el('rect',{x:-58,y:-200,width:116,height:400,rx:58,fill:'none',stroke:'#fff','stroke-width':10},B.gauge);
  B.gT=el('text',{y:285,'text-anchor':'middle','font-family':'Kanit','font-weight':900,'font-size':76,fill:'#fff',stroke:'#10080A','stroke-width':12,'paint-order':'stroke'},B.gauge); B.gT.textContent=TX.o2;
  B.full=el('g',{opacity:0},B.gauge); el('rect',{x:-110,y:-330,width:220,height:96,rx:48,fill:'#1E9BF0',stroke:'#10080A','stroke-width':8},B.full);
  B.fullT=el('text',{y:-262,'text-anchor':'middle','font-family':'Kanit','font-weight':900,'font-size':60,fill:'#fff'},B.full); B.fullT.textContent=TX.o2+' '+TX.full;
  B.warn=el('path',{d:'M0 -280 L46 -200 L-46 -200 Z',fill:'#E0202E',stroke:'#10080A','stroke-width':7,'stroke-linejoin':'round',opacity:0},B.gauge);
  B.q=[0,1].map(i=>{const q=el('g',{opacity:0},g); el('text',{'text-anchor':'middle','font-family':'Kanit','font-weight':900,'font-size':220,fill:'#FFD23F',stroke:'#10080A','stroke-width':14,'paint-order':'stroke',y:70},q).textContent='?'; return q;});
})();
const brainPath=(t)=>{let d='';const N=64;for(let i=0;i<=N;i++){const a=i/N*Math.PI*2, bump=1+0.05*Math.sin(9*a+0.6)+0.02*Math.sin(t*3+a*4);
  let rx=230*bump, ry=160*bump; let x=-10+rx*Math.cos(a), y=-185+ry*Math.sin(a); if(y>-90)y=-90+(y+90)*0.35;
  d+=(i?'L':'M')+f2(x)+' '+f2(y);} return d+'Z';};
const BRAIN_OK=hex('#F4A6B9'), PALE=hex('#B7A3AE'), HOT=hex('#FF8A3D'), COOL=hex('#59C3FF');
const pale=track(0,[[K.lack,1,MORPH],[T.pure+0.12,0,MORPH]]);
const lvl=track(0,[[T.myth+0.12,0.7,MORPH],[K.lack,0.16,BOUNCE],[T.pure,1.0,MORPH]]);
const redG=track(0,[[K.lack,1,FAST],[T.pure,0,MORPH]]);
const gaugeS=track(0,[[T.myth+0.1,1,BOUNCE],[T.idea-0.2,0,[26,1]]]);
const hot=track(0,[[T.idea+0.12,1,MORPH],[T.cool-0.02,0,FAST]]);
const cool=track(0,[[T.cool-0.02,1,FAST]]);
const mouthO=track(0,[[K.yawnI,1,BOUNCE],[T.debate+0.1,0.15,MORPH]]);
const airA=track(0,[[K.yawnI+0.08,1,FAST],[T.debate+0.25,0,MORPH]]);
const bS=track(2.4,[[T.myth,1.0,CAMF],[T.o2,1.45,CAMF],[T.pure,0.98,CAMF],[T.idea,1.12,CAMF],[T.cool,1.0,CAM],[T.debate,0.92,CAM]]);
const bX=track(60,[[T.myth,110,CAMF],[T.o2,360,CAMF],[T.pure,215,CAMF],[T.idea,0,CAMF],[T.cool,90,CAM],[T.debate,10,CAM]]);
const bY=track(-60,[[T.myth,-40,CAMF],[T.o2,-110,CAMF],[T.pure,-60,CAMF],[T.idea,-90,CAMF],[T.cool,-60,CAM],[T.debate,-80,CAM]]);
const GX=480, GY=-110;
function brain(t){
  const on=(t>=T.myth-0.01&&t<T.mask+0.12)||(t>=T.pure-0.01&&t<T.same+0.15)||(t>=T.idea-0.01&&t<T.warn+0.15); if(!on)return;
  const s=bS(t)*(1+0.012*Math.sin(t*2.3)), fx=bX(t)+8*Math.sin(t*1.3), fy=bY(t)+7*Math.cos(t*1.7), rot=0.9*Math.sin(t*0.9);
  $('bcam').setAttribute('transform',`translate(540 640) rotate(${rot.toFixed(3)}) scale(${s.toFixed(5)}) translate(${f2(-fx)} ${f2(-fy)})`);
  $('grid-b').style.transform=`translate(${f2(-fx*0.3+20*Math.sin(t*0.5))}px,${f2(-fy*0.3-t*12)}px)`;
  const P=clamp(pale(t)), Hh=clamp(hot(t)), C=clamp(cool(t)), R=clamp(redG(t));
  let col=mixA(BRAIN_OK,PALE,P); col=mixA(col,HOT,Hh); col=mixA(col,COOL,C);
  B.brain.setAttribute('d',brainPath(t)); B.brain.setAttribute('fill',rgb(col)); B.cereb.setAttribute('fill',rgb(mixA(col,[0,0,0],0.12)));
  const pulse=0.75+0.25*Math.sin(t*9);
  B.halo.setAttribute('opacity',(P*0.8*pulse).toFixed(3)); B.hot.setAttribute('opacity',(Hh*(0.8+0.2*Math.sin(t*7))).toFixed(3));
  B.cold.setAttribute('opacity',(C*(0.75+0.25*Math.sin(t*5))).toFixed(3));
  B.gyri.setAttribute('transform',`translate(0 ${f2(2*Math.sin(t*3))})`);
  // heat waves rising from the hot brain
  B.heat.forEach((p,i)=>{const ph=((t*0.9+i*0.2)%1), x=-170+i*80, y0=-350-ph*160;
    p.setAttribute('d',`M${x} ${f2(y0+80)} q20 -20 0 -40 q-20 -20 0 -40`); p.setAttribute('opacity',(Hh*(1-ph)*Math.min(1,ph*4)).toFixed(3));});
  // mouth opens on "การหาว"/"yawning" -> cold air flows in
  const M=Math.max(0,mouthO(t)); B.mouth.setAttribute('d',`M252 ${f2(98-6-30*M)} Q${f2(225-25*M)} ${f2(98)} 252 ${f2(98+6+34*M)} Z`);
  const A=clamp(airA(t));
  B.air.forEach((p,i)=>{const ph=((t*1.6+i*0.25)%1), y=40+i*32, x0=700-ph*150;
    p.setAttribute('d',`M${f2(x0)} ${y} q-40 -18 -80 0 q-40 18 -80 0 q-40 -18 -80 0`); p.setAttribute('opacity',(A*Math.min(1,(1-ph)*3)*Math.min(1,ph*5)).toFixed(3));});
  B.airH.forEach((p,i)=>{const y=40+i*32, x=330+((t*160+i*40)%120)*0.2;
    p.setAttribute('d',`M${f2(x+30)} ${y-22} L${f2(x)} ${y} L${f2(x+30)} ${y+22}`); p.setAttribute('opacity',(A*0.9).toFixed(3));});
  // O2 molecules stream to the nose and up to the brain (pure)
  const mo=t>=T.pure&&t<T.same+0.15?clamp((t-T.pure)/0.2)*(1-clamp((t-T.same)/0.1)):0;
  B.mol.forEach((m,i)=>{const ph=((t*0.8+i*0.1)%1); let x,y; if(ph<0.5){const u=ph/0.5; x=lerp(GX-40,310,u); y=lerp(GY+120,-20,u);} else {const u=(ph-0.5)/0.5; x=lerp(290,40,u); y=lerp(-20,-170,u)+30*Math.sin(u*Math.PI);}
    m.setAttribute('transform',`translate(${f2(x)} ${f2(y)}) rotate(${f2(t*120+i*40)}) scale(${f2(0.9+0.2*Math.sin(t*5+i))})`);
    m.setAttribute('opacity',(mo*Math.min(1,ph*6)*Math.min(1,(1-ph)*6)).toFixed(3));});
  // gauge
  const gs=gaugeS(t); B.gauge.setAttribute('opacity',clamp(gs*3).toFixed(3));
  B.gauge.setAttribute('transform',`translate(${GX} ${GY}) scale(${Math.max(0.001,gs).toFixed(4)}) rotate(${f2(3*Math.sin(t*2))})`);
  const L=clamp(lvl(t),0,1.06), wob=5*Math.sin(t*6);
  B.level.setAttribute('y',f2(200-400*L+wob)); B.level.setAttribute('height',f2(400*L+20));
  B.level.setAttribute('fill',mix('#3FB4FF','#E0202E',R));
  B.warn.setAttribute('opacity',(R*(t<T.pure?(0.55+0.45*Math.abs(Math.sin(t*7))):0)).toFixed(3));
  const fa=t>=K.pure?S(t-K.pure,16,0.55):0; B.full.setAttribute('opacity',(fa>0.01?1:0).toString());
  B.full.setAttribute('transform',`translate(0 ${f2(4*Math.sin(t*4))}) scale(${Math.max(0.001,fa).toFixed(4)})`);
  B.gT.setAttribute('opacity',(1-clamp(fa)).toFixed(3));
  // question marks on "เถียง"/"debated"
  B.q.forEach((q,i)=>{const t0=T.debate+i*0.08, a=t>=t0?S(t-t0,15,0.5):0; q.setAttribute('opacity',(a>0.01?1:0).toString());
    const x=i?380:-380, y=-200+14*Math.sin(t*4+i*2);
    q.setAttribute('transform',`translate(${x} ${f2(y)}) rotate(${f2((i?12:-12)+6*Math.sin(t*3+i))}) scale(${Math.max(0.001,a).toFixed(4)})`);});
}

// ---------- chip under the diagram: MYTH -> FACT -> THEORY (one pill morphs width + colour) ----------
const CH=[[TX.myth,'#E0202E'],[TX.fact,'#1E9BF0'],[TX.theory,'#FF7A1A']];
['chipM1','chipM2','chipM3'].forEach((id,i)=>$(id).textContent=CH[i][0]);
const wTx=EN?[260,240,320]:[330,330,350];
const chipW=track(wTx[0],[[T.pure,wTx[1],MORPH],[T.idea,wTx[2],MORPH]]);
function chips(t){
  const c=$('chipM'); let v;
  if(t>=T.myth&&t<T.mask+0.1) v=vis(t,T.myth+0.08,T.mask,{lin:0.2,lout:0.08});
  else if(t>=T.pure&&t<T.same+0.1) v=vis(t,T.pure+0.05,T.same,{lin:0.2,lout:0.08});
  else if(t>=T.idea&&t<T.warn+0.1) v=vis(t,T.idea+0.05,T.warn,{lin:0.2,lout:0.08});
  if(!v||!show(c,v.o)){c.style.opacity='0';return;} blur(c,v.blur);
  const st=t<T.pure?0:(t<T.idea?1:2), w=chipW(t);
  const bg=st===0?CH[0][1]:(st===1?mix(CH[0][1],CH[1][1],S(t-T.pure,14,0.8)):mix(CH[1][1],CH[2][1],S(t-T.idea,14,0.8)));
  c.style.width=f2(w)+'px'; c.style.background=bg;
  c.style.transform=`translate(${f2(540-w/2)}px,${f2(1352+4*Math.sin(t*4))}px) scale(${(0.7+0.3*v.a).toFixed(3)}) rotate(${f2(st===0?2*Math.sin(t*20)*clamp(redG(t)):0)}deg)`;
  [0,1,2].forEach(i=>{const e=$('chipM'+(i+1)); e.style.opacity=(i===st?1:0).toString();});
}

// ---------- same: before / after bars morph to equal height on "เท่าเดิม"/"much" ----------
$('barsH').textContent=TX.barsH; $('labA').textContent=TX.a; $('labB').textContent=TX.b;
const BEQ=H.same-0.42; // equal height settled ~0.1 s before the word (Provine 1987: yawned just as much)
const bB=track(110,[[BEQ,240,[22,1]]]);
function bars(t){
  const b=$('bars'); const v=vis(t,T.same+0.12,T.idea,{lin:0.22,lout:0.1});
  if(t<T.same||t>T.idea+0.15){b.style.opacity='0';return;} if(!show(b,v.o))return; blur(b,v.blur);
  const a=S(t-T.same-0.12,12,0.6);
  b.style.transform=`translate(${f2(230)}px,${f2(250+60*(1-a)+4*Math.sin(t*3))}px) rotate(${f2(-2+1.2*Math.sin(t*2.4))}deg) scale(${(0.6+0.4*a).toFixed(4)})`;
  const hA=240*eo((t-T.same-0.2)/0.35)+4*Math.sin(t*5), hB=Math.max(0,bB(t))*eo((t-T.same-0.3)/0.35)+4*Math.sin(t*5+1);
  $('barA').setAttribute('y',f2(392-hA)); $('barA').setAttribute('height',f2(Math.max(0,hA)));
  $('barB').setAttribute('y',f2(392-hB)); $('barB').setAttribute('height',f2(Math.max(0,hB)));
  $('barB').setAttribute('fill',mix('#9AA5B5','#1E9BF0',t>BEQ?S(t-BEQ,22,1):0));
  $('o2b').setAttribute('transform',`translate(425 ${f2(392-hB-42)}) scale(${eo((t-T.same-0.35)/0.25).toFixed(3)})`);
  $('eqm').setAttribute('opacity',(t>BEQ?eo((t-BEQ-0.12)/0.2):0).toFixed(3));
}

// ---------- ending: cat + comment bubble ----------
function ending(t){
  const b=$('bubble'); if(t<K.ask){ b.style.opacity='0'; return; }
  const v=vis(t,K.ask,null,{lin:0.12});
  if(!show(b,v.o))return; blur(b,v.blur); $('bubT').textContent=TX.bub;
  const a=S(t-K.ask,13,0.5), c=t>K.comment?Math.sin(Math.PI*clamp((t-K.comment)/0.3)):0, hm=t>K.howmany?Math.sin(Math.PI*clamp((t-K.howmany)/0.3)):0;
  b.style.transformOrigin='30% 100%';
  b.style.transform=`translate(220px,${f2(250+12*Math.sin((t-K.ask)*6))}px) rotate(${f2(-5+4*Math.sin(t*3))}deg) scale(${(0.25+0.75*a+0.08*c+0.06*hm).toFixed(4)})`;
  [...$('dots').children].forEach((d,i)=>d.setAttribute('cy',f2(290-12*Math.max(0,Math.sin(t*9-i*0.9)))));
}

// ---------- captions: spring in on the word ----------
const capEls=CAPT.map((s,i)=>$('c'+LANG+i).querySelector('span'));
function captions(t){
  let i=-1; for(let k=0;k<CAPT.length;k++) if(t>=CAPT[k]) i=k;
  if(i<0) return; const tau=t-CAPT[i]; const a=S(tau,30,0.6);
  capEls[i].style.transform=`translateY(${f2(22*(1-a))}px) scale(${(0.78+0.22*a).toFixed(4)}) rotate(${f2(0.6*Math.sin(t*3))}deg)`;
}

function render(t){ scenes(t); title(t); hookov(t); brain(t); chips(t); bars(t); ending(t); captions(t); }
const proxy={_t:0}; Object.defineProperty(proxy,'t',{get(){return this._t;},set(v){this._t=v;render(v);}});
const tl=gsap.timeline({paused:true});
tl.to(proxy,{t:%%DUR%%,duration:%%DUR%%,ease:'none'},0);
render(0);
window.__timelines=window.__timelines||{}; window.__timelines["main"]=tl;
})();
</script>
</body></html>
