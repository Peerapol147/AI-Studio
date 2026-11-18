<!doctype html>
<!-- GENERATED: edit index.html.tpl, then run `python3 build_index.py` -->
<html lang="th"><head><meta charset="UTF-8"/><meta name="viewport" content="width=1080, height=1920"/>
<link rel="stylesheet" href="fonts/fonts.css"/>
<script src="https://cdn.jsdelivr.net/npm/gsap@3.15.0/dist/gsap.min.js"></script>
<style>
@font-face{font-family:'CatEmoji';src:url('fonts/NotoColorEmoji.ttf') format('truetype');font-display:block}
*{margin:0;padding:0;box-sizing:border-box}
html,body{width:1080px;height:1920px;overflow:hidden;background:#000}
#root{position:relative;width:1080px;height:1920px;overflow:hidden;font-family:'Kanit',sans-serif;background:#0B1220}
.sc{position:absolute;left:0;top:0;width:1080px;height:1920px;overflow:hidden;opacity:0}
.fw,.kb{position:absolute;left:0;top:0;width:1080px;height:1920px}
.fill{position:absolute;left:0;top:0;width:1080px;height:1920px}
.vid{position:absolute;left:0;top:0;width:1080px;height:1920px;object-fit:cover}
/* stills: a rounded "photo card" (native-res crop shown ~900 px wide) over its own blurred fill */
.card{position:absolute;left:90px;width:900px;border-radius:44px;overflow:hidden;background:#111;
  box-shadow:0 0 0 8px #FFF8EC,0 0 0 14px #10080A,0 40px 80px rgba(0,0,0,.55)}
.card img{position:absolute;left:0;top:0;width:100%;height:100%;object-fit:cover}
.vig{position:absolute;left:0;top:0;width:1080px;height:1920px;background:radial-gradient(ellipse at 50% 45%,rgba(0,0,0,0) 55%,rgba(0,0,0,.45) 100%)}
.ov{position:absolute;left:0;top:0;width:1080px;height:1920px;overflow:visible}
.dbg{position:absolute;left:0;top:0;width:1080px;height:1920px;background:radial-gradient(ellipse at 50% 34%,#22375C 0%,#132038 55%,#0A111F 100%)}
.grid{position:absolute;left:-200px;top:-200px;width:1480px;height:2320px;opacity:.16;
  background-image:linear-gradient(#5D7FB5 2px,transparent 2px),linear-gradient(90deg,#5D7FB5 2px,transparent 2px);background-size:80px 80px}
#tshade{position:absolute;left:0;top:0;width:1080px;height:820px;background:linear-gradient(rgba(5,5,10,.72),rgba(5,5,10,0))}
#title{position:absolute;left:0;top:0;width:1080px;height:760px}
#title .tl{position:absolute;left:0;width:1080px;text-align:center;font-weight:900;line-height:1;white-space:nowrap;
  -webkit-text-stroke:28px #10080A;paint-order:stroke fill;transform-origin:50% 60%}
.pill{position:absolute;left:0;top:0;height:100px;border-radius:50px;border:8px solid #10080A;opacity:0;white-space:nowrap;
  box-shadow:0 12px 0 rgba(0,0,0,.35);transform-origin:50% 50%}
.pill span{position:absolute;top:50%;transform:translateY(-54%);font-weight:900;font-size:54px;white-space:nowrap}
#pillI{position:absolute;top:10px;width:64px;height:64px;overflow:visible}
.btn{position:absolute;top:0;left:0;height:100px;width:360px;border-radius:50px;border:8px solid #10080A;opacity:0;
  box-shadow:0 12px 0 rgba(0,0,0,.4);display:flex;align-items:center;justify-content:center;gap:10px;
  color:#fff;font-weight:900;font-size:50px;white-space:nowrap;transform-origin:50% 50%}
.btn .em{font-family:'CatEmoji';font-size:46px;line-height:1}
#meas{position:absolute;left:-3000px;top:0;font-weight:900;white-space:nowrap;visibility:hidden}
#gsvg{position:absolute;left:0;top:0;width:1080px;height:1920px;overflow:visible}
#caps{position:absolute;left:0;top:0;width:1080px;height:1920px;z-index:60;pointer-events:none}
/* captions: centred on X 510 (safe band X 120-900), text box ~Y 1130-1245 */
.cap{position:absolute;left:10px;width:1000px;top:1190px;height:0;text-align:center}
.cap span{position:absolute;left:0;width:1000px;bottom:-52px;display:block;color:#fff;font-weight:700;line-height:1.18;white-space:nowrap;
  -webkit-text-stroke:17px #000;paint-order:stroke fill;transform-origin:50% 80%}
.cap em{font-style:normal;color:#FFD23F}
</style></head><body>
<div id="root" data-composition-id="main" data-start="0" data-duration="%%DUR%%" data-width="1080" data-height="1920"
 data-motion-blur="on" data-motion-blur-events="on">

<div id="scenes" data-layout-allow-overflow data-layout-allow-overlap style="position:absolute;left:0;top:0;width:1080px;height:1920px;z-index:0;isolation:isolate">
  <div class="sc" id="sh-hook"><div class="kb" id="kb-hook">
    <video id="v-hook" class="clip vid" %%VHOOK%% data-media-start="0" data-track-index="1" muted playsinline src="assets/hook-v.mp4"></video></div></div>
  <div class="sc" id="sh-belief"><div class="kb" id="kb-belief">
    <video id="v-belief" class="clip vid" %%VBELIEF%% data-media-start="0" data-track-index="2" muted playsinline src="assets/belief-v.mp4"></video></div><div class="vig"></div></div>
  <div class="sc" id="sh-fishing"><div class="fw" id="fw-fishing"><img class="fill" src="assets/fishing-fill.jpg" alt=""/></div>
    <div class="card" id="kb-fishing" style="top:400px;height:900px"><img id="im-fishing" src="assets/fishing-card.jpg" alt=""/></div></div>
  <div class="sc" id="sh-fishing2"><div class="fw" id="fw-fishing2"><img class="fill" src="assets/fishing2-fill.jpg" alt=""/></div>
    <div class="card" id="kb-fishing2" style="top:369px;height:822px"><img id="im-fishing2" src="assets/fishing2-card.jpg" alt=""/></div></div>
  <div class="sc" id="sh-van"><div class="fw" id="fw-van"><img class="fill" src="assets/van-fill.jpg" alt=""/></div>
    <div class="card" id="kb-van" style="top:391px;height:919px"><img id="im-van" src="assets/van-card.jpg" alt=""/></div></div>
  <div class="sc" id="sh-van2"><div class="fw" id="fw-van2"><img class="fill" src="assets/van2-fill.jpg" alt=""/></div>
    <div class="card" id="kb-van2" style="top:450px;height:800px"><img id="im-van2" src="assets/van2-card.jpg" alt=""/></div></div>
  <div class="sc" id="sh-vet"><div class="fw" id="fw-vet"><img class="fill" src="assets/vet-fill.jpg" alt=""/></div>
    <div class="card" id="kb-vet" style="top:404px;height:893px"><img id="im-vet" src="assets/vet-card.jpg" alt=""/></div></div>
  <div class="sc" id="sc-fur"><div class="dbg"></div><div class="grid" id="grid-f"></div>
    <svg class="ov" viewBox="0 0 1080 1920" width="1080" height="1920"><g id="fcam"></g></svg></div>
  <div class="sc" id="sh-ancestor"><div class="fw" id="fw-ancestor"><img class="fill" src="assets/ancestor-fill.jpg" alt=""/></div>
    <div class="card" id="kb-ancestor" style="top:389px;height:923px"><img id="im-ancestor" src="assets/ancestor-card.jpg" alt=""/></div></div>
  <div class="sc" id="sh-dry"><div class="kb" id="kb-dry">
    <img class="vid" src="assets/dry-bg.jpg" alt=""/></div><div class="vig"></div></div>
  <div class="sc" id="sh-guess"><div class="fw" id="fw-guess"><img class="fill" src="assets/guess-fill.jpg" alt=""/></div>
    <div class="card" id="kb-guess" style="top:404px;height:893px"><img id="im-guess" src="assets/guess-card.jpg" alt=""/></div></div>
  <div class="sc" id="sh-swim"><div class="fw" id="fw-swim"><img class="fill" src="assets/swim-fill.jpg" alt=""/></div>
    <div class="card" id="kb-swim" style="top:400px;height:900px"><img id="im-swim" src="assets/swim-card.jpg" alt=""/></div></div>
  <div class="sc" id="sh-ask"><div class="kb" id="kb-ask">
    <video id="v-ask" class="clip vid" %%VASK%% data-media-start="0" data-track-index="4" muted playsinline src="assets/ask-v.mp4"></video></div></div>
</div>

<div id="over" data-layout-allow-overflow data-layout-allow-overlap style="position:absolute;left:0;top:0;width:1080px;height:1920px;z-index:10">
  <svg id="gsvg" viewBox="0 0 1080 1920" width="1080" height="1920"><g id="glayer"></g></svg>
  <div class="pill" id="pill"><span id="pillA"></span><span id="pillB"></span><svg id="pillI" viewBox="-32 -32 64 64"></svg></div>
  <div class="pill" id="ntag"><span id="ntagA"></span><span id="ntagB"></span></div>
  <div class="btn" id="btn1" style="background:#1E9BF0"><span>ทีมเล่นน้ำ</span><span class="em">💦</span></div>
  <div class="btn" id="btn2" style="background:#FF6B2C"><span>ทีมข่วน</span><span class="em">😾</span></div>
  <div id="tshade"></div>
  <div id="title"><div class="tl" id="tl1">ทำไมแมว</div><div class="tl" id="tl2">กลัวน้ำ?</div></div>
  <div id="meas"></div>
</div>

<div id="caps" data-track-kind="captions">
%%CAPS%%
</div>

<audio id="vo" class="clip" data-start="0" data-duration="%%DUR%%" data-track-index="30" data-volume="1" src="assets/vo-th.mp3"></audio>
<audio id="music" class="clip" data-start="0" data-duration="%%DUR%%" data-track-index="31" data-volume="0.1" src="assets/music-jamendo-b6fb4ded.mp3"></audio>
</div>

<script>
/* Motion: closed-form springs (motion-broll engine). Shot times = assets/audio/shots-th.json, word anchors = words.json
   (both injected by build_index.py). One pill morphs belief -> truth -> vet -> hypothesis; one name tag morphs
   fishing cat -> Turkish Van -> ancestor -> "arid land"; one map lens morphs Thailand -> Near East; the fur diagram is
   one cat + one dial (weight gauge -> clock). Everything is a function of t. */
(function(){
const ALL=%%DATA%%, D=ALL, DUR=D.dur, CAPT=D.capt, K=D.k, SH=D.sh;
const T={},H={},W={}; for(const k in SH){T[k]=SH[k].start; W[k]=SH[k].word; if(SH[k].hit!=null)H[k]=SH[k].hit;}
const NS='http://www.w3.org/2000/svg';

// ---------- spring kit ----------
const clamp=(x,a=0,b=1)=>Math.min(b,Math.max(a,x)), lerp=(a,b,u)=>a+(b-a)*u;
const eo=x=>{x=clamp(x);return 1-Math.pow(1-x,3)}, eio=x=>{x=clamp(x);return x*x*x*(x*(6*x-15)+10)}, ei=x=>{x=clamp(x);return x*x*x};
const S=(tau,w,z)=>{if(tau<=0)return 0;
  if(z<1){const wd=w*Math.sqrt(1-z*z);return 1-Math.exp(-z*w*tau)*(Math.cos(wd*tau)+z*w/wd*Math.sin(wd*tau));}
  return 1-Math.exp(-w*tau)*(1+w*tau);};
const MORPH=[15,0.84],FAST=[26,0.8],SLOW=[8,0.95],BOUNCE=[18,0.55],CAM=[7.5,1],CAMF=[13,1],OUT=[24,1];
const track=(v0,keys,def=MORPH)=>{let p=v0;const ks=[];for(const k of keys){const d=k[1]-p;p=k[1];const sp=k[2]||def;if(d!==0)ks.push([k[0],d,sp[0],sp[1]]);}
  return t=>{let v=v0;for(const k of ks)v+=k[1]*S(t-k[0],k[2],k[3]);return v;};};
const hex=h=>[1,3,5].map(i=>parseInt(h.slice(i,i+2),16));
const mix=(a,b,u)=>{const x=hex(a),y=hex(b);return `rgb(${x.map((v,i)=>Math.round(lerp(v,y[i],clamp(u)))).join(',')})`;};
const $=id=>document.getElementById(id);
const el=(tag,attrs,parent)=>{const e=document.createElementNS(NS,tag);for(const k in attrs)e.setAttribute(k,attrs[k]);parent.appendChild(e);return e;};
const show=(e,o)=>{e.style.opacity=o<0.003?'0':o.toFixed(4);return o>=0.003;};
const blur=(e,b)=>{e.style.filter=b>0.05?`blur(${b.toFixed(2)}px)`:'none';};
const f2=v=>v.toFixed(2);
const DROP='M0 -26 C10 -10 18 0 18 10 A18 18 0 0 1 -18 10 C-18 0 -10 -10 0 -26 Z';
const meas=$('meas'); const wcache={};
const tw=(txt,size)=>{const k=txt+'|'+size; if(wcache[k])return wcache[k]; meas.style.fontSize=size+'px'; meas.textContent=txt;
  const w=meas.offsetWidth; if(document.fonts&&document.fonts.status==='loaded'&&w>0)wcache[k]=w; return w||txt.length*size*0.55;};

// ---------- scenes: each shot window with its entry transition (whip / zoom-through / match) ----------
// cards: card drifts/rotates (layer 1) + photo pushes in 8-15% inside it (layer 2) + blurred fill parallax (layer 3)
const SC=[
 {id:'sh-hook',a:0,kb:'kb-hook',v:1,s0:1.0,s1:1.08,r0:0,r1:-0.8,org:'50% 52%',in:'none'},
 {id:'sh-belief',a:T.belief,kb:'kb-belief',v:1,s0:1.02,s1:1.12,r0:0.8,r1:-0.6,org:'30% 40%',in:'whip'},
 {id:'sh-fishing',a:T.fishing,kb:'kb-fishing',im:'im-fishing',fw:'fw-fishing',s0:1.0,s1:1.12,org:'75% 45%',in:'zoom'},
 {id:'sh-fishing2',a:T.fishing2,kb:'kb-fishing2',im:'im-fishing2',fw:'fw-fishing2',s0:1.02,s1:1.13,org:'28% 40%',in:'match'},
 {id:'sh-van',a:T.van,kb:'kb-van',im:'im-van',fw:'fw-van',s0:1.0,s1:1.12,org:'55% 30%',in:'whip'},
 {id:'sh-van2',a:T.van2,kb:'kb-van2',im:'im-van2',fw:'fw-van2',s0:1.02,s1:1.1,org:'45% 55%',in:'match'},
 {id:'sh-vet',a:T.vet,kb:'kb-vet',im:'im-vet',fw:'fw-vet',s0:1.0,s1:1.12,org:'55% 35%',in:'whip'},
 {id:'sc-fur',a:T.fur,in:'zoom'},
 {id:'sh-ancestor',a:T.ancestor,kb:'kb-ancestor',im:'im-ancestor',fw:'fw-ancestor',s0:1.0,s1:1.13,org:'38% 30%',in:'whip'},
 {id:'sh-dry',a:T.dry,kb:'kb-dry',v:1,s0:1.04,s1:1.14,r0:-0.8,r1:0.8,org:'50% 40%',in:'match'},
 {id:'sh-guess',a:T.guess,kb:'kb-guess',im:'im-guess',fw:'fw-guess',s0:1.0,s1:1.12,org:'45% 35%',in:'zoom'},
 {id:'sh-swim',a:T.swim,kb:'kb-swim',im:'im-swim',fw:'fw-swim',s0:1.0,s1:1.08,org:'27% 40%',in:'whip'},
 {id:'sh-ask',a:T.ask,kb:'kb-ask',v:1,s0:1.02,s1:1.1,r0:-0.6,r1:0.6,org:'45% 35%',in:'zoom'},
];
SC.forEach((s,i)=>{s.next=SC[i+1]; s.b=s.next?s.next.a:DUR; $(s.id).style.zIndex=String(i+1);
  if(s.im)$(s.im).style.transformOrigin=s.org; else if(s.kb)$(s.kb).style.transformOrigin=s.org;});
const WHIP=0.16, ZIN=0.22;
function sceneState(s,t){
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
function scenes(t){
  SC.forEach((s,i)=>{const r=sceneState(s,t), e=$(s.id);
    if(!r){e.style.opacity='0';return;}
    e.style.opacity=r.o.toFixed(4); e.style.transform=`translateX(${f2(r.tx)}px) scale(${r.sc.toFixed(4)})`;
    if(!s.kb)return;
    const uu=clamp((t-s.a)/Math.max(0.3,(s.b-s.a)));
    let k=lerp(s.s0,s.s1,eio(0.1+0.9*uu));
    if(s.v){ const rr=lerp(s.r0,s.r1,uu), dx=8*Math.sin(t*1.7+s.a), dy=6*Math.cos(t*1.3+s.a);
      $(s.kb).style.transform=`translate(${f2(dx)}px,${f2(dy)}px) rotate(${rr.toFixed(3)}deg) scale(${k.toFixed(5)})`; return; }
    // card scene
    let px=0,py=0;
    if(s.id==='sh-fishing2'){ const p=t>K.dive?S(t-K.dive,20,0.5):0; k*=1+0.05*p-0.05*p*clamp((t-K.dive-0.3)/0.6); }
    if(s.id==='sh-swim'){ const z=t>K.just?S(t-K.just,11,0.8):0; k*=1+0.2*z; }
    const ca=S(t-s.a,13,0.75), rot=(i%2?1:-1)*(1.4*(1-ca)+0.9*Math.sin(t*0.9+i)), cy=26*(1-ca)+6*Math.sin(t*1.4+i), cx=7*Math.cos(t*1.1+i);
    $(s.kb).style.transform=`translate(${f2(cx)}px,${f2(cy)}px) rotate(${f2(rot)}deg) scale(${(0.985+0.03*uu).toFixed(4)})`;
    $(s.im).style.transform=`translate(${f2(px)}px,${f2(py)}px) scale(${k.toFixed(5)})`;
    $(s.fw).style.transform=`translate(${f2(-16*Math.sin(t*0.9+s.a)-34*uu)}px,${f2(-12*Math.cos(t*0.7+s.a))}px) rotate(${f2(-0.4*rot)}deg) scale(${(1.12+0.06*uu).toFixed(4)})`;
  });
}

// ---------- hook title: full from frame 0 (no fade-in), breathes 1.0<->1.04 ----------
$('tl1').style.cssText+='top:262px;font-size:172px;color:#fff';
$('tl2').style.cssText+='top:470px;font-size:196px;color:#FFD23F';
function title(t){
  const out=eo((t-(T.belief-0.06))/0.14);
  show($('title'),1-out); show($('tshade'),1-out);
  const br=1+0.04*(0.5-0.5*Math.cos(t*2*Math.PI/0.9));
  ['tl1','tl2'].forEach((id,i)=>{const e=$(id);
    e.style.transform=`translateY(${f2(t>0?3*Math.sin(t*3+i):0)}px) rotate(${f2(i?-1.4*Math.sin(t*2.4):0)}deg) scale(${(br*(1+0.3*out)).toFixed(4)})`;
    e.style.textShadow=`${f2(t>0?6*Math.sin(t*2.2+i):0)}px ${f2(12+(t>0?4*Math.cos(t*1.8)-4:0))}px 0 rgba(0,0,0,.5)`;});
}

// ---------- overlay SVG layer ----------
const G=$('glayer');
const defs=el('defs',{},G);
defs.innerHTML=`<radialGradient id="glowy"><stop offset="0" stop-color="#FFF6B0" stop-opacity=".9"/><stop offset=".45" stop-color="#FFD23F" stop-opacity=".4"/><stop offset="1" stop-color="#FFD23F" stop-opacity="0"/></radialGradient>
 <radialGradient id="heat"><stop offset="0" stop-color="#FF8A2A" stop-opacity=".95"/><stop offset=".55" stop-color="#E8641B" stop-opacity=".5"/><stop offset="1" stop-color="#E8641B" stop-opacity="0"/></radialGradient>
 <linearGradient id="wav" x1="0" x2="0" y1="0" y2="1"><stop offset="0" stop-color="#5CC8FF"/><stop offset="1" stop-color="#1F6FB5"/></linearGradient>
 <clipPath id="mapclip"><circle r="112"/></clipPath>
 <clipPath id="v2clip"><rect x="90" y="450" width="900" height="800" rx="44"/></clipPath>
 <clipPath id="f2clip"><rect x="90" y="369" width="900" height="822" rx="44"/></clipPath>`;

// generic splash: droplets fly out + ring, from (x,y) at t0
function mkSplash(n,col){const g=el('g',{},G); const ring=el('ellipse',{fill:'none',stroke:'#fff','stroke-width':8,opacity:0},g);
  const ds=[...Array(n)].map(()=>el('path',{d:DROP,fill:col||'#7FD3FF',stroke:'#10080A','stroke-width':4,opacity:0},g)); return {g,ring,ds};}
function splash(sp,t,t0,x,y,R=1,flat=0.45){const tau=t-t0;
  if(tau<0||tau>0.9){sp.ring.setAttribute('opacity','0');sp.ds.forEach(d=>d.setAttribute('opacity','0'));return;}
  const u=eo(tau/0.5); sp.ring.setAttribute('cx',x); sp.ring.setAttribute('cy',y); sp.ring.setAttribute('rx',f2(R*(30+150*u))); sp.ring.setAttribute('ry',f2(R*(30+150*u)*flat));
  sp.ring.setAttribute('opacity',(0.9*(1-eo(tau/0.7))).toFixed(3));
  sp.ds.forEach((d,i)=>{const a=-Math.PI*(0.15+0.7*i/(sp.ds.length-1)), v=R*(260+60*(i%3)), dx=Math.cos(a)*v*tau, dy=Math.sin(a)*v*tau+R*900*tau*tau;
    const ang=Math.atan2(Math.sin(a)*v+R*1800*tau,Math.cos(a)*v)*180/Math.PI+90;
    d.setAttribute('transform',`translate(${f2(x+dx)} ${f2(y+dy)}) rotate(${f2(ang)}) scale(${f2(R*(0.75+0.25*(i%2)))})`);
    d.setAttribute('opacity',(1-eo((tau-0.45)/0.4)).toFixed(3));});}
// ripple rings (continuous), at (x,y)
function mkRipple(n){const g=el('g',{},G); return {g,rs:[...Array(n)].map(()=>el('ellipse',{fill:'none',stroke:'#E8F7FF','stroke-width':6,opacity:0},g))};}
function ripple(rp,t,a,b,x,y,R,per=0.9){rp.rs.forEach((r,i)=>{if(t<a||t>b){r.setAttribute('opacity','0');return;}
  const u=(((t-a)/per+i/rp.rs.length)%1+1)%1, fade=clamp((t-a)/0.2)*(1-clamp((t-b+0.12)/0.12));
  r.setAttribute('cx',x); r.setAttribute('cy',y); r.setAttribute('rx',f2(R*(0.15+0.85*u))); r.setAttribute('ry',f2(R*(0.15+0.85*u)*0.38));
  r.setAttribute('opacity',(fade*0.85*(1-u)).toFixed(3));});}

// hook: droplets pop at the glass rim < 1 s (first motion besides the live footage)
const SP_HOOK=mkSplash(7);
// fishing2: water surface along the bottom of the card + a flat fish that leaps on "ดำน้ำ"
const WAT=el('g',{'clip-path':'url(#f2clip)',opacity:0},G);
const wBack=el('path',{fill:'#2E86D1',opacity:.75},WAT), wFront=el('path',{fill:'url(#wav)',stroke:'#E8F7FF','stroke-width':6},WAT);
const FISH=el('g',{},G);
el('path',{d:'M-46 0 C-20 -26 26 -26 46 0 C26 26 -20 26 -46 0 Z',fill:'#FFB13B',stroke:'#10080A','stroke-width':6},FISH);
el('path',{d:'M-44 0 L-74 -22 L-68 0 L-74 22 Z',fill:'#FF8A1F',stroke:'#10080A','stroke-width':6,'stroke-linejoin':'round'},FISH);
el('circle',{cx:24,cy:-6,r:6,fill:'#10080A'},FISH);
const SP_DIVE=mkSplash(8);
// van2 / swim / vet water details
const WAT2=el('g',{'clip-path':'url(#v2clip)',opacity:0},G);
const w2Back=el('path',{fill:'#2E86D1',opacity:.75},WAT2), w2Front=el('path',{fill:'url(#wav)',stroke:'#E8F7FF','stroke-width':6},WAT2);
const RP_VAN2=mkRipple(3), SP_VAN2=mkSplash(8);
const RP_SWIM=mkRipple(3), SP_SWIM=mkSplash(7);
const VDRIP=[...Array(4)].map(()=>el('path',{d:DROP,fill:'#7FD3FF',stroke:'#10080A','stroke-width':4,opacity:0},G));
const VBADGE=el('g',{opacity:0},G); el('circle',{r:46,fill:'#1E9BF0',stroke:'#10080A','stroke-width':7},VBADGE);
el('path',{d:DROP,fill:'#fff',transform:'translate(0 4) scale(1.15)'},VBADGE);
// guess: floating question marks
const QM=[...Array(3)].map((_,i)=>{const e=el('text',{'text-anchor':'middle','font-family':'Kanit','font-weight':900,'font-size':[96,72,60][i],fill:'#FFD23F',stroke:'#10080A','stroke-width':10,'paint-order':'stroke',opacity:0},G); e.textContent='?'; return e;});
// ancestor / dry: heat shimmer lines + sun
const HEAT=[...Array(5)].map(()=>el('path',{fill:'none',stroke:'#FFE2B0','stroke-width':5,'stroke-linecap':'round',opacity:0},G));
const SUN=el('g',{opacity:0},G); const SUNR=el('g',{},SUN);
for(let i=0;i<10;i++)el('path',{d:'M0 -78 L0 -104',stroke:'#FFD23F','stroke-width':12,'stroke-linecap':'round',transform:`rotate(${i*36})`},SUNR);
el('circle',{r:60,fill:'#FFD23F',stroke:'#10080A','stroke-width':8},SUN); el('circle',{r:60,fill:'url(#heat)',opacity:.5},SUN);

// ---------- map lens (one circle): Thailand (fishing cat range) -> Near East (wild ancestor origin) ----------
const MAP=el('g',{opacity:0},G);
const mapShadow=el('circle',{r:124,fill:'#10080A',cy:8},MAP);
const mapIn=el('g',{'clip-path':'url(#mapclip)'},MAP);
el('circle',{r:112,fill:'#2C6FB0'},mapIn);
const mapThai=el('g',{},mapIn), mapNE=el('g',{},mapIn);
const proj=(pts,cx,cy,k)=>'M'+pts.map(([lo,la])=>`${f2((lo-cx)*k)} ${f2((cy-la)*k)}`).join(' L')+' Z';
const THAI=[[99.9,20.45],[98.9,19.8],[97.9,19.6],[97.4,18.5],[97.7,17.6],[98.6,16.4],[98.3,15.4],[98.9,14.6],[99.2,13.3],[99.4,12.2],[99.0,10.9],[98.5,9.8],[98.3,8.9],[98.3,7.9],[99.0,7.4],[99.8,6.6],[100.2,6.4],[101.0,6.0],[101.8,5.8],[102.1,6.2],[101.3,6.9],[100.5,7.3],[100.3,8.4],[99.9,9.2],[99.2,9.6],[99.2,10.6],[99.6,11.8],[99.95,12.6],[100.0,13.3],[100.5,13.5],[100.9,13.1],[100.9,12.6],[101.4,12.7],[102.2,12.2],[102.8,11.7],[102.6,12.6],[102.4,13.6],[103.2,14.3],[104.5,14.4],[105.5,14.3],[105.6,15.6],[105.0,16.2],[104.8,17.0],[104.4,17.7],[103.6,18.4],[102.6,17.9],[101.9,17.9],[101.2,17.6],[101.1,18.5],[101.3,19.5],[100.5,20.2]];
el('path',{d:proj(THAI,101.6,13.1,12.4),fill:'#F4E3C1',stroke:'#10080A','stroke-width':4,'stroke-linejoin':'round'},mapThai);
const thaiDot=el('circle',{r:10,fill:'#E0202E',stroke:'#fff','stroke-width':4,cx:f2((99.9-101.6)*12.4),cy:f2((13.1-12.2)*12.4)},mapThai);
const thaiPing=el('circle',{r:10,fill:'none',stroke:'#E0202E','stroke-width':5,cx:thaiDot.getAttribute('cx'),cy:thaiDot.getAttribute('cy')},mapThai);
const AFR=[[-17,21],[-16,12],[-12,8],[-8,5],[-2,5],[5,6],[9,4],[9,-1],[13,-6],[12,-17],[18,-34],[26,-34],[33,-26],[35,-20],[40,-15],[40,-5],[44,1],[51,11],[43,12],[39,17],[36,22],[34,28],[32,31],[25,32],[20,31],[10,37],[-6,36],[-10,30]];
const ARAB=[[34.5,28],[36,30],[35,33],[36,36],[30,36.5],[27,37],[26,40],[29,41],[36,42],[41,41],[45,40],[48,38],[52,37],[56,38],[61,36],[62,30],[58,25],[57,19],[52,16],[45,13],[43,13],[40,17],[39,21]];
const EUR=[[-10,37],[-9,43],[-2,44],[3,43],[8,44],[12,42],[16,38],[18,40],[13,46],[20,42],[24,38],[26,40],[24,45],[30,46],[40,47],[45,43],[50,48],[60,52],[60,62],[-10,62]];
const nek=3.1, NEC=[38,27];
el('path',{d:proj(AFR,NEC[0],NEC[1],nek),fill:'#E9C98F',stroke:'#10080A','stroke-width':3.5,'stroke-linejoin':'round'},mapNE);
el('path',{d:proj(ARAB,NEC[0],NEC[1],nek),fill:'#E9C98F',stroke:'#10080A','stroke-width':3.5,'stroke-linejoin':'round'},mapNE);
el('path',{d:proj(EUR,NEC[0],NEC[1],nek),fill:'#B9C79A',stroke:'#10080A','stroke-width':3.5,'stroke-linejoin':'round'},mapNE);
const neHeat=el('ellipse',{fill:'url(#heat)',cx:f2((40-NEC[0])*nek),cy:f2((NEC[1]-31)*nek),rx:44,ry:30},mapNE);
const neDot=el('circle',{r:9,fill:'#E0202E',stroke:'#fff','stroke-width':4,cx:f2((40-NEC[0])*nek),cy:f2((NEC[1]-33)*nek)},mapNE);
el('circle',{r:112,fill:'none',stroke:'#fff','stroke-width':12},MAP); el('circle',{r:120,fill:'none',stroke:'#10080A','stroke-width':6},MAP);
const mS=track(0,[[K.thai,1,BOUNCE],[T.fishing2,0.82,MORPH],[T.van,0,OUT],[K.from,1,BOUNCE],[T.dry,2.0,MORPH],[T.guess,0,OUT]]);
const mX=track(225,[[T.fishing2,860,MORPH],[T.van,860],[K.from-0.01,225,[400,1]],[T.dry,540,MORPH]]);
const mY=track(960,[[T.fishing2,560,MORPH],[T.van,560],[K.from-0.01,960,[400,1]],[T.dry,700,MORPH]]);
const mZ=track(1,[[T.dry,1.9,SLOW]]);
function maplens(t){
  const s=mS(t); if(s<0.01||t<K.thai){MAP.setAttribute('opacity','0');return;}
  MAP.setAttribute('opacity','1');
  MAP.setAttribute('transform',`translate(${f2(mX(t))} ${f2(mY(t)+4*Math.sin(t*2.6))}) rotate(${f2(3*Math.sin(t*1.7))}) scale(${Math.max(0.001,s).toFixed(4)})`);
  const ne=t>=K.from-0.02; mapThai.setAttribute('opacity',ne?'0':'1'); mapNE.setAttribute('opacity',ne?'1':'0');
  const ph=((t*1.4)%1); [thaiPing].forEach(p=>{p.setAttribute('r',f2(10+26*ph)); p.setAttribute('opacity',f2(1-ph));});
  thaiDot.setAttribute('r',f2(9+2*Math.sin(t*8)));
  // near east: zoom toward the dry heart of the region, heat blob throbs
  const z=mZ(t), fx=(40-NEC[0])*nek, fy=(NEC[1]-31)*nek;
  mapNE.setAttribute('transform',`scale(${z.toFixed(4)}) translate(${f2(-fx*(z-1)/z)} ${f2(-fy*(z-1)/z)})`);
  neHeat.setAttribute('rx',f2(44+8*Math.sin(t*5))); neHeat.setAttribute('ry',f2(30+6*Math.sin(t*5)));
  neHeat.setAttribute('opacity',f2(t>T.dry?0.85+0.15*Math.sin(t*7):0.55));
  neDot.setAttribute('r',f2(8+2*Math.sin(t*8)));
}

// ---------- the pill (one shape): ความเชื่อ (red ?) -> ความจริง ✅ (green) -> สัตวแพทย์ (blue +) -> สมมติฐาน (amber ?) ----------
const PI=$('pillI');
const icQ=el('g',{},PI); el('circle',{r:30,fill:'#fff',stroke:'#10080A','stroke-width':5},icQ);
const icQt=el('text',{y:15,'text-anchor':'middle','font-family':'Kanit','font-weight':900,'font-size':44,fill:'#E0202E'},icQ); icQt.textContent='?';
const icC=el('g',{},PI); el('rect',{x:-30,y:-30,width:60,height:60,rx:14,fill:'#3CCB5A',stroke:'#10080A','stroke-width':5},icC);
el('path',{d:'M-16 1 L-5 13 L17 -12',fill:'none',stroke:'#fff','stroke-width':9,'stroke-linecap':'round','stroke-linejoin':'round'},icC);
const icX=el('g',{},PI); el('circle',{r:30,fill:'#fff',stroke:'#10080A','stroke-width':5},icX);
el('path',{d:'M-7 -18h14v11h11v14h-11v11h-14v-11h-11v-14h11z',fill:'#E0202E'},icX);
const PST=[{t:K.belief,txt:'ความเชื่อ',bg:'#E0202E',fg:'#fff',ic:icQ,qc:'#E0202E'},{t:K.truth,txt:'ความจริง',bg:'#1FA34A',fg:'#fff',ic:icC},
  {t:K.vet,txt:'สัตวแพทย์',bg:'#1E9BF0',fg:'#fff',ic:icX},{t:K.guess,txt:'สมมติฐาน',bg:'#F5A623',fg:'#10080A',ic:icQ,qc:'#C77800'}];
const pS=track(0,[[K.belief,1,BOUNCE],[T.van,0,OUT],[K.vet,1,BOUNCE],[T.fur,0,OUT],[K.guess,1,BOUNCE],[T.swim,0,OUT]]);
const PW=st=>tw(st.txt,54)+64+36+44;
function pill(t){
  const p=$('pill'), s=pS(t); if(t<K.belief||s<0.01){p.style.opacity='0';return;}
  let i=0; PST.forEach((st,j)=>{if(t>=st.t)i=j;}); const cur=PST[i], prev=PST[i-1];
  const sw=S(t-cur.t,14,0.7), morph=prev&&cur.t===K.truth; // belief -> truth is a live morph (same shape, spring)
  const w=morph?lerp(PW(prev),PW(cur),clamp(sw,0,1.15)):PW(cur);
  p.style.opacity='1'; p.style.width=f2(w)+'px'; p.style.background=morph?mix(prev.bg,cur.bg,sw):cur.bg;
  const pop=morph?1+0.12*Math.sin(Math.PI*clamp((t-cur.t)/0.35)):1;
  p.style.transform=`translate(${f2(540-w/2)}px,${f2(252+3*Math.sin(t*3.2))}px) rotate(${f2(-2+1.2*Math.sin(t*2.1))}deg) scale(${(Math.max(0.001,s)*pop).toFixed(4)})`;
  const A=$('pillA'),B=$('pillB'); const tx=36;
  if(morph&&t<cur.t+0.25){ A.textContent=prev.txt; A.style.left=tx+'px'; A.style.color=prev.fg; const a=1-eo((t-cur.t)/0.1); A.style.opacity=f2(a); blur(A,(1-a)*10); }
  else A.style.opacity='0';
  const bo=morph?eo((t-cur.t-0.04)/0.18):1; B.textContent=cur.txt; B.style.left=tx+'px'; B.style.color=cur.fg; B.style.opacity=f2(bo); blur(B,(1-bo)*10);
  PI.style.left=f2(w-64-8-26)+'px';
  [icQ,icC,icX].forEach(g=>g.setAttribute('opacity',g===cur.ic?'1':'0'));
  if(cur.qc)icQt.setAttribute('fill',cur.qc);
  const ia=S(t-cur.t-0.05,16,0.5); cur.ic.setAttribute('transform',`rotate(${f2(-30*(1-ia))}) scale(${Math.max(0.001,ia).toFixed(4)})`);
}

// ---------- the name tag (one shape): เสือปลา -> เตอร์กิชแวน (slide-in) -> บรรพบุรุษแมวบ้าน -> ถิ่นแห้งแล้ง (moves to centre) ----------
const NST=[{t:K.fcat,txt:'เสือปลา',bg:'#FFD23F',fg:'#10080A'},{t:K.van,txt:'เตอร์กิชแวน',bg:'#FFFFFF',fg:'#10080A'},
  {t:K.anc,txt:'บรรพบุรุษแมวบ้าน',bg:'#C8742E',fg:'#fff'},{t:K.arid,txt:'ถิ่นแห้งแล้ง',bg:'#E8641B',fg:'#fff',c:1}];
const nX=track(-560,[[K.fcat,130,MORPH],[T.van,-560,FAST],[K.van,130,MORPH],[T.vet,-560,FAST],[K.anc,130,MORPH]]);
const nS=track(0,[[K.fcat,1,BOUNCE],[K.van,1],[K.arid,1.3,BOUNCE],[T.guess,0,OUT]]);
const nY=track(420,[[K.arid,965,FAST]]);
const nC=track(0,[[K.arid,1,FAST]]);
function ntag(t){
  const p=$('ntag'); if(t<K.fcat||t>T.guess+0.5){p.style.opacity='0';return;}
  let i=0; NST.forEach((st,j)=>{if(t>=st.t)i=j;}); const cur=NST[i], prev=NST[i-1];
  const w=tw(cur.txt,54)+72, s=nS(t); if(s<0.01){p.style.opacity='0';return;}
  const morph=prev&&cur.c, sw=morph?S(t-cur.t,14,0.7):1;
  const wp=morph?lerp(tw(prev.txt,54)+72,w,clamp(sw,0,1.1)):w;
  const c=clamp(nC(t),0,1.05), x=lerp(nX(t),540-wp*s/2,c);
  p.style.opacity='1'; p.style.width=f2(wp)+'px'; p.style.background=morph?mix(prev.bg,cur.bg,sw):cur.bg;
  p.style.transformOrigin='0 50%';
  p.style.transform=`translate(${f2(x)}px,${f2(nY(t)+3*Math.sin(t*3.5))}px) rotate(${f2(-3+1.5*Math.sin(t*2.3)+(1-clamp(S(t-cur.t,12,0.6)))*-8)}deg) scale(${Math.max(0.001,s).toFixed(4)})`;
  const A=$('ntagA'),B=$('ntagB');
  if(morph&&t<cur.t+0.25){A.textContent=prev.txt; A.style.left='36px'; A.style.color=prev.fg; const a=1-eo((t-cur.t)/0.1); A.style.opacity=f2(a); blur(A,(1-a)*10);} else A.style.opacity='0';
  const bo=morph?eo((t-cur.t-0.04)/0.18):1; B.textContent=cur.txt; B.style.left='36px'; B.style.color=cur.fg; B.style.opacity=f2(bo); blur(B,(1-bo)*10);
}

// ---------- per-shot water/heat details ----------
function details(t){
  // hook: droplets at the glass rim
  splash(SP_HOOK,t,0.42,330,1270,1.1,0.4);
  // fishing2: water rises along the card bottom, fish swims, leaps + splash on "ดำน้ำ"
  const wv=t>=T.fishing2-0.05&&t<T.van+0.2; WAT.setAttribute('opacity',wv?'1':'0');
  if(wv){ const rise=S(t-T.fishing2,12,0.75), top=lerp(1191,1000,rise)+6*Math.sin(t*3);
    const wave=(ph,amp,y0)=>{let d=`M60 ${f2(y0)}`; for(let x=60;x<=1020;x+=40)d+=` L${x} ${f2(y0+amp*Math.sin(x/70+t*ph))}`; return d+' L1020 1200 L60 1200 Z';};
    wBack.setAttribute('d',wave(-3.2,12,top-14)); wFront.setAttribute('d',wave(4.1,10,top+10));
    const fx=lerp(160,900,clamp((t-T.fishing2)/1.6)), jt=t-K.dive, jump=jt>0&&jt<0.7?Math.sin(Math.PI*jt/0.7):0;
    const fy=top+60-210*jump+4*Math.sin(t*9), ang=jt>0&&jt<0.7?-50*Math.cos(Math.PI*jt/0.7):6*Math.sin(t*9);
    FISH.setAttribute('opacity',f2(clamp((t-T.fishing2-0.1)/0.15)*(1-clamp((t-T.van)/0.12))));
    FISH.setAttribute('transform',`translate(${f2(fx)} ${f2(fy)}) rotate(${f2(ang)}) scale(${f2(0.9+0.15*jump)})`);
  } else FISH.setAttribute('opacity','0');
  splash(SP_DIVE,t,K.dive,420,1010,1,0.35);
  // van: water-drop badge bounces next to the name tag on "ขึ้นชื่อ"
  const vb=t>K.famous&&t<T.vet+0.15; VBADGE.setAttribute('opacity',vb?'1':'0');
  if(vb){const a=S(t-K.famous,16,0.5), x=130+tw('เตอร์กิชแวน',54)+72+64; VBADGE.setAttribute('transform',`translate(${f2(x)} ${f2(468-14*Math.abs(Math.sin((t-K.famous)*6)))}) rotate(${f2(8*Math.sin(t*5))}) scale(${Math.max(0.001,a).toFixed(4)})`);}
  // van2: ripples + splash at the faucet stream / paw on "เล่นน้ำ"
  const w2=t>=T.van2-0.05&&t<T.vet+0.2; WAT2.setAttribute('opacity',w2?'1':'0');
  if(w2){ const rise=S(t-T.van2,12,0.75), bob=t>K.play?-26*Math.sin(Math.PI*clamp((t-K.play)/0.35))*Math.exp(-2*(t-K.play)):0, top=lerp(1250,1010,rise)+bob+5*Math.sin(t*3);
    const wave=(ph,amp,y0)=>{let d=`M60 ${f2(y0)}`; for(let x=60;x<=1020;x+=40)d+=` L${x} ${f2(y0+amp*Math.sin(x/70+t*ph))}`; return d+' L1020 1260 L60 1260 Z';};
    w2Back.setAttribute('d',wave(-3.4,12,top-14)); w2Front.setAttribute('d',wave(4.3,10,top+10)); }
  ripple(RP_VAN2,t,T.van2+0.15,T.vet,540,1035,240,0.7); splash(SP_VAN2,t,K.play,540,1020,1.2,0.35);
  // vet: water drips off the damp fur
  VDRIP.forEach((d,i)=>{ if(t<T.vet||t>T.fur+0.1){d.setAttribute('opacity','0');return;}
    const per=0.75, ph=(((t-T.vet)/per+i*0.27)%1+1)%1, x=[430,560,700,800][i], y0=[930,960,900,940][i];
    d.setAttribute('transform',`translate(${x} ${f2(y0+150*ph*ph)}) scale(${f2(0.7+0.4*clamp(ph*4))})`); d.setAttribute('opacity',f2(clamp(ph*5)*(1-clamp((ph-0.75)/0.25))));});
  // guess: question marks float up beside the kitten
  QM.forEach((q,i)=>{ if(t<K.guess||t>T.swim+0.1){q.setAttribute('opacity','0');return;}
    const tau=t-K.guess-i*0.35, a=S(tau,14,0.55), ph=tau*0.8;
    q.setAttribute('x',f2([700,800,620][i]+10*Math.sin(t*2+i))); q.setAttribute('y',f2([640,560,520][i]-40*ph));
    q.setAttribute('transform',`rotate(${f2(10*Math.sin(t*2.5+i))} ${[700,800,620][i]} ${[620,540,500][i]})`);
    q.setAttribute('opacity',f2(tau>0?clamp(a)*(1-clamp((t-T.swim+0.15)/0.15)):0));});
  // swim: ripples round the paw, splash on "ว่ายน้ำได้"
  ripple(RP_SWIM,t,T.swim,T.ask,690,975,190,0.9); splash(SP_SWIM,t,K.swim,690,960,0.9,0.4);
  // ancestor + dry: heat shimmer rising, sun
  HEAT.forEach((h,i)=>{ const on=t>=T.ancestor&&t<T.guess+0.1; if(!on){h.setAttribute('opacity','0');return;}
    const dry=t>=T.dry, x0=dry?240+150*i:200+170*i, yb=dry?1080:1080, ph=((t*0.9+i*0.23)%1);
    let d=`M${x0} ${yb-ph*160}`; for(let k=1;k<=6;k++)d+=` Q${f2(x0+(k%2?16:-16)*Math.sin(t*4+i))} ${f2(yb-ph*160-k*20+10)} ${x0} ${f2(yb-ph*160-k*20)}`;
    h.setAttribute('d',d); h.setAttribute('opacity',f2((dry?0.18:0.3)*Math.sin(Math.PI*ph)));});
  const sv=t>=K.arid-0.05&&t<T.guess+0.15; SUN.setAttribute('opacity',sv?'1':'0');
  if(sv){const a=S(t-K.arid,14,0.55); SUN.setAttribute('transform',`translate(${f2(800+6*Math.sin(t*2))} ${f2(470)}) scale(${Math.max(0.001,a*(1+0.04*Math.sin(t*6))).toFixed(4)})`);
    SUNR.setAttribute('transform',`rotate(${f2(t*40)})`);}
}

// ---------- fur diagram: one cat silhouette fills with drops -> sinks on "หนัก" (gauge) -> dial becomes a clock on "แห้งช้า" ----------
const FC=$('fcam'), F={};
(function(){
  const CAT='M170 600 C120 600 100 540 110 470 C120 380 150 300 190 240 C170 210 160 170 165 130 L160 40 L215 75 C240 68 270 68 295 75 L345 35 L340 125 C345 175 320 215 285 230 C300 300 320 380 320 460 C322 530 310 580 300 600 Z';
  const TAIL='M175 596 C90 606 30 570 42 506 C48 476 80 474 84 494 C76 536 112 562 172 560 Z';
  const cd=el('defs',{},FC); const cp=el('clipPath',{id:'catclip'},cd); el('path',{d:CAT},cp); el('path',{d:TAIL},cp);
  F.plat=el('g',{},FC);
  el('rect',{x:300,y:1018,width:440,height:34,rx:17,fill:'#D9E4F2',stroke:'#10080A','stroke-width':8},F.plat);
  el('rect',{x:360,y:1050,width:320,height:26,rx:10,fill:'#8DA2BF',stroke:'#10080A','stroke-width':8},F.plat);
  F.puddle=el('ellipse',{cx:520,cy:1018,rx:0,ry:0,fill:'#5CC8FF',opacity:.85},FC);
  F.cat=el('g',{},FC);
  F.body=el('g',{},F.cat);
  F.catFill=[el('path',{d:TAIL,fill:'#F4EBDD'},F.body),el('path',{d:CAT,fill:'#F4EBDD'},F.body)];
  F.water=el('g',{'clip-path':'url(#catclip)'},F.body); F.wpath=el('path',{fill:'url(#wav)',opacity:.88},F.water);
  F.out=[el('path',{d:TAIL,fill:'none',stroke:'#10080A','stroke-width':9,'stroke-linejoin':'round'},F.body),el('path',{d:CAT,fill:'none',stroke:'#10080A','stroke-width':9,'stroke-linejoin':'round'},F.body)];
  el('ellipse',{cx:300,cy:150,rx:9,ry:13,fill:'#10080A'},F.body);
  F.fur=[...Array(7)].map((_,i)=>el('path',{fill:'none',stroke:'#10080A','stroke-width':5,'stroke-linecap':'round',opacity:.35},F.body));
  F.shiv=[...Array(4)].map(()=>el('path',{fill:'none',stroke:'#9FDcff','stroke-width':8,'stroke-linecap':'round',opacity:0},FC));
  F.drops=[...Array(8)].map(()=>el('path',{d:DROP,fill:'#7FD3FF',stroke:'#10080A','stroke-width':4,opacity:0},FC));
  F.drips=[...Array(2)].map(()=>el('path',{d:DROP,fill:'#7FD3FF',stroke:'#10080A','stroke-width':4,opacity:0},FC));
  // one dial: weight gauge (coloured arcs + needle) -> clock (ticks + two hands)
  F.dial=el('g',{},FC); el('circle',{r:112,fill:'#10080A',cy:8},F.dial); el('circle',{r:104,fill:'#fff',stroke:'#10080A','stroke-width':9},F.dial);
  const arc=(a0,a1,c)=>{const p=a=>[76*Math.sin(a*Math.PI/180),-76*Math.cos(a*Math.PI/180)];const [x0,y0]=p(a0),[x1,y1]=p(a1);
    return el('path',{d:`M${f2(x0)} ${f2(y0)} A76 76 0 0 1 ${f2(x1)} ${f2(y1)}`,stroke:c,'stroke-width':20,fill:'none'},F.dial);};
  F.arcs=[arc(-115,-40,'#3FA9F5'),arc(-40,40,'#FFD23F'),arc(40,115,'#E0202E')];
  F.ticks=[...Array(12)].map((_,i)=>el('path',{d:'M0 -88 L0 -70',stroke:'#10080A','stroke-width':i%3?5:9,'stroke-linecap':'round',transform:`rotate(${i*30})`,opacity:0},F.dial));
  F.kettle=el('g',{transform:'translate(0 40)'},F.dial); el('path',{d:'M-22 -10 Q-22 -26 0 -26 Q22 -26 22 -10',fill:'none',stroke:'#10080A','stroke-width':7},F.kettle);
  el('path',{d:'M-30 -12 H30 L36 22 H-36 Z',fill:'#10080A'},F.kettle);
  F.needle=el('path',{d:'M-9 0 L0 -80 L9 0 Z',fill:'#E0202E',stroke:'#10080A','stroke-width':3},F.dial);
  F.minute=el('path',{d:'M-6 0 L0 -84 L6 0 Z',fill:'#10080A',opacity:0},F.dial);
  el('circle',{r:13,fill:'#fff',stroke:'#10080A','stroke-width':5},F.dial);
})();
const fill=track(1030,[[K.fur,700,[6,0.95]],[K.dryslow,700,[6,1]]]);
const sink=track(0,[[K.heavy,1,BOUNCE]]);
const needle=track(-105,[[K.wet,-60,MORPH],[K.heavy,85,BOUNCE],[K.dryslow,60,MORPH]]);
const clock=track(0,[[K.dryslow,1,MORPH]]);
const dX=track(830,[[K.dryslow,845,MORPH]]), dY=track(560,[[K.dryslow,470,MORPH]]), dS=track(0,[[T.fur+0.1,0.85,BOUNCE],[K.heavy,1.0,BOUNCE],[K.dryslow,1.12,MORPH]]);
const fcS=track(1.25,[[T.fur,1.0,CAMF],[K.heavy,1.04,CAMF],[K.dryslow,0.98,CAM]]);
function fur(t){
  if(t<T.fur-0.01||t>T.ancestor+0.2)return;
  const cs=fcS(t)*(1+0.01*Math.sin(t*2.1));
  FC.setAttribute('transform',`translate(540 760) rotate(${f2(0.7*Math.sin(t*0.9))}) scale(${cs.toFixed(4)}) translate(-540 -760)`);
  $('grid-f').style.transform=`translate(${f2(10*Math.sin(t*0.5))}px,${f2(-t*14)}px)`;
  const sk=sink(t), shiv=t>K.uncomf?4*Math.sin(t*55)*clamp((t-K.uncomf)/0.2):0;
  F.cat.setAttribute('transform',`translate(${f2(330+shiv)} ${f2(420+34*sk)}) translate(210 600) scale(${f2(1+0.03*sk)} ${f2(1-0.05*sk)}) translate(-210 -600)`);
  F.plat.setAttribute('transform',`translate(0 ${f2(14*sk)})`);
  // water level inside the silhouette (local y), drains very slowly after "แห้งช้า"
  let lv=fill(t)-420; if(t>K.dryslow) lv+=26*(t-K.dryslow);
  let d=`M-20 ${f2(lv)}`; for(let x=-20;x<=420;x+=30)d+=` L${x} ${f2(lv+8*Math.sin(x/40+t*5))}`; F.wpath.setAttribute('d',d+' L420 640 L-20 640 Z');
  const wet=clamp((t-K.fur)/0.8); F.catFill.forEach(p=>p.setAttribute('fill',mix('#F4EBDD','#C9D6E2',wet)));
  F.fur.forEach((p,i)=>{const x=150+i*24, y=330+(i%3)*60, droop=14*wet; p.setAttribute('d',`M${x} ${y} q8 ${f2(10+droop)} ${f2(2-2*wet)} ${f2(22+droop)}`);});
  // falling drops into the cat (until "แห้งช้า")
  F.drops.forEach((p,i)=>{const per=0.42, ph=(((t-T.fur)/per+i/F.drops.length)%1+1)%1, on=t>T.fur+0.05&&t<K.dryslow+0.2;
    const x=380+((i*67)%260), y=270+300*ph*ph; p.setAttribute('transform',`translate(${x} ${f2(y)}) scale(0.9)`);
    p.setAttribute('opacity',on?f2(clamp(ph*6)*(1-clamp((ph-0.85)/0.15))):'0');});
  // slow drips off the cat after "แห้งช้า" + puddle
  F.drips.forEach((p,i)=>{const per=0.9, ph=(((t-K.dryslow)/per+i*0.5)%1+1)%1, on=t>K.dryslow+0.1;
    p.setAttribute('transform',`translate(${[470,610][i]} ${f2(990+30*ph*ph+34*sk)}) scale(${f2(0.4+0.5*clamp(ph*3))})`);
    p.setAttribute('opacity',on?f2(clamp(ph*4)*(1-clamp((ph-0.8)/0.2))):'0');});
  const pu=clamp((t-K.dryslow)/2); F.puddle.setAttribute('rx',f2(40+150*pu)); F.puddle.setAttribute('ry',f2(5+9*pu)); F.puddle.setAttribute('cy',f2(1016+14*sk)); F.puddle.setAttribute('opacity',f2(0.85*clamp((t-K.dryslow)/0.3)));
  // shiver lines ("ไม่สบายตัว")
  F.shiv.forEach((p,i)=>{const on=t>K.uncomf; const x=i<2?300-i*30:720+(i-2)*30, y=560+(i%2)*90;
    p.setAttribute('d',`M${x} ${y} q${i<2?-14:14} 15 0 30 q${i<2?14:-14} 15 0 30`); p.setAttribute('opacity',on?f2(0.9*clamp((t-K.uncomf)/0.2)*(0.6+0.4*Math.sin(t*14+i))):'0');});
  // dial
  const c=clamp(clock(t),0,1);
  F.dial.setAttribute('transform',`translate(${f2(dX(t))} ${f2(dY(t)+4*Math.sin(t*2.6))}) rotate(${f2(3*Math.sin(t*1.9))}) scale(${Math.max(0.001,dS(t)).toFixed(4)})`);
  F.arcs.forEach(a=>a.setAttribute('opacity',f2(1-c))); F.ticks.forEach(k=>k.setAttribute('opacity',f2(c))); F.kettle.setAttribute('opacity',f2(1-c));
  const jit=t<K.heavy?3*Math.sin(t*23):0;
  F.needle.setAttribute('transform',`rotate(${f2(needle(t)+jit)}) scale(1 ${f2(1-0.4*c)})`); F.needle.setAttribute('fill',mix('#E0202E','#10080A',c));
  F.minute.setAttribute('opacity',f2(c)); F.minute.setAttribute('transform',`rotate(${f2(t>K.dryslow?(t-K.dryslow)*55:0)})`);
}

// ---------- ask: two buttons pop on their words, then bounce alternately until the end ----------
function buttons(t){
  [['btn1',K.b1,130,0],['btn2',K.b2,530,1]].forEach(([id,t0,x,i])=>{const b=$(id); if(t<t0-0.01){b.style.opacity='0';return;}
    const a=S(t-t0,15,0.5), alt=t>K.b2+0.4?Math.max(0,Math.sin((t-K.b2)*Math.PI/0.6+i*Math.PI)):0;
    b.style.opacity='1'; b.style.transform=`translate(${x}px,${f2(1318-18*alt+40*(1-clamp(a)))}px) rotate(${f2((i?3:-3)*(1-clamp(a))+1.5*Math.sin(t*3+i))}deg) scale(${(Math.max(0.001,a)*(1+0.06*alt)).toFixed(4)})`;});
}

// ---------- captions: spring in on the word ----------
const capEls=CAPT.map((s,i)=>$('c'+i).querySelector('span'));
function captions(t){
  let i=-1; for(let k=0;k<CAPT.length;k++) if(t>=CAPT[k]) i=k;
  if(i<0) return; const tau=t-CAPT[i]; const a=S(tau,30,0.6);
  capEls[i].style.transform=`translateY(${f2(22*(1-a))}px) scale(${(0.78+0.22*a).toFixed(4)}) rotate(${f2(0.6*Math.sin(t*3))}deg)`;
}

function render(t){ scenes(t); title(t); details(t); maplens(t); pill(t); ntag(t); fur(t); buttons(t); captions(t); }
const proxy={_t:0}; Object.defineProperty(proxy,'t',{get(){return this._t;},set(v){this._t=v;render(v);}});
const tl=gsap.timeline({paused:true});
tl.to(proxy,{t:%%DUR%%,duration:%%DUR%%,ease:'none'},0);
render(0);
if(document.fonts&&document.fonts.ready)document.fonts.ready.then(()=>render(proxy._t));
window.__timelines=window.__timelines||{}; window.__timelines["main"]=tl;
})();
</script>
</body></html>
