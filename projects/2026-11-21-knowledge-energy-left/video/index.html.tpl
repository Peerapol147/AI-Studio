<!doctype html>
<!-- GENERATED: edit index.html.tpl, then run `python3 build_index.py` -->
<html lang="th"><head><meta charset="UTF-8"/><meta name="viewport" content="width=1080, height=1920"/>
<link rel="stylesheet" href="fonts/fonts.css"/>
<script src="https://cdn.jsdelivr.net/npm/gsap@3.15.0/dist/gsap.min.js"></script>
<style>
*{margin:0;padding:0;box-sizing:border-box}
html,body{width:1080px;height:1920px;overflow:hidden;background:#000}
#root{position:relative;width:1080px;height:1920px;overflow:hidden;font-family:'Kanit',sans-serif;background:#0E0E10}
#stage{position:absolute;left:0;top:0;width:1080px;height:1920px;transform-origin:50% 40%}
.sc{position:absolute;left:0;top:0;width:1080px;height:1920px;overflow:hidden;opacity:0;background:#0E0E10}
.kb{position:absolute;left:0;top:0;width:1080px;height:1920px}
.bgi{position:absolute;left:0;top:0;width:1080px;height:1920px;object-fit:cover}
.vid{position:absolute;left:0;top:0;width:1080px;height:1920px;object-fit:cover}
.card{position:absolute;border-radius:34px;overflow:hidden;box-shadow:0 0 0 8px #0E0E10,0 34px 80px rgba(0,0,0,.65)}
.cin{position:absolute;left:0;top:0;width:100%;height:100%}
.cin img,.cvid{position:absolute;left:0;top:0;width:100%;height:100%;object-fit:cover}
.band{position:absolute;left:0;width:1080px;height:640px;overflow:hidden;opacity:0}
.band video{position:absolute;left:0;top:0;width:1080px;height:640px;object-fit:cover}
.vig{position:absolute;left:0;top:0;width:1080px;height:1920px;background:radial-gradient(ellipse at 50% 45%,rgba(14,14,16,0) 55%,rgba(14,14,16,.55) 100%)}
.grain{position:absolute;left:-540px;top:-960px;width:2160px;height:3840px;opacity:.16;mix-blend-mode:overlay;
  background:url("data:image/svg+xml,%3Csvg viewBox='0 0 256 256' xmlns='http://www.w3.org/2000/svg'%3E%3Cfilter id='noise'%3E%3CfeTurbulence type='fractalNoise' baseFrequency='0.65' numOctaves='3' stitchTiles='stitch'/%3E%3C/filter%3E%3Crect width='100%25' height='100%25' filter='url(%23noise)'/%3E%3C/svg%3E")}
.stars{position:absolute;left:0;top:0;width:1080px;height:1920px;overflow:visible}
.ov{position:absolute;left:0;top:0;width:1080px;height:1920px;overflow:visible}
#tshade{position:absolute;left:0;top:0;width:1080px;height:860px;background:linear-gradient(rgba(14,14,16,.8) 0%,rgba(14,14,16,.55) 60%,rgba(14,14,16,0) 100%)}
.ttl{position:absolute;left:0;top:0;width:1080px;height:760px}
.tl{position:absolute;left:0;width:1080px;text-align:center;font-weight:900;line-height:1;white-space:nowrap;color:#fff;
  -webkit-text-stroke:26px #0E0E10;paint-order:stroke fill;transform-origin:50% 60%;text-shadow:0 12px 0 rgba(0,0,0,.45)}
.pill{position:absolute;left:0;top:0;height:96px;border-radius:48px;border:7px solid #0E0E10;opacity:0;white-space:nowrap;
  box-shadow:0 10px 0 rgba(0,0,0,.35);transform-origin:50% 50%}
.pill .tx{position:absolute;top:50%;left:96px;transform:translateY(-54%);font-weight:900;font-size:50px;white-space:nowrap;color:#0E0E10}
.pill .bd{position:absolute;left:12px;top:9px;width:64px;height:64px;border-radius:32px;background:#0E0E10}
.pill .bd svg{width:44px;height:44px;color:#fff;position:absolute;left:10px;top:10px}
.ic{overflow:visible}
#meas{position:absolute;left:-3000px;top:0;font-weight:900;font-size:50px;white-space:nowrap;visibility:hidden}
/* big kinetic labels (year, formula) */
.big{position:absolute;left:0;width:1080px;text-align:center;font-weight:900;line-height:1;white-space:nowrap;color:#fff;opacity:0;
  -webkit-text-stroke:22px #0E0E10;paint-order:stroke fill;transform-origin:50% 55%;text-shadow:0 10px 0 rgba(0,0,0,.45)}
.big em{font-style:normal;color:#FF7A1A}
.chip{position:absolute;left:0;top:0;height:104px;padding:0 34px 0 28px;border-radius:30px;border:7px solid #0E0E10;background:#1B1B20;
  display:flex;align-items:center;gap:16px;color:#fff;font-weight:900;font-size:64px;white-space:nowrap;opacity:0;box-shadow:0 10px 0 rgba(0,0,0,.4);transform-origin:50% 50%}
.chip svg{width:60px;height:60px;color:#FF7A1A}
/* battery label + rows */
#bl{position:absolute;left:0;top:0;width:700px;height:0;text-align:center;opacity:0}
#bl span{position:absolute;left:0;width:700px;transform:translateY(-55%);display:flex;justify-content:center;align-items:center;gap:12px;
  font-weight:900;color:#fff;white-space:nowrap;-webkit-text-stroke:14px #0E0E10;paint-order:stroke fill;line-height:1}
#bl svg{width:1.1em;height:1.1em;color:#fff;stroke-width:3}
#bpanel{position:absolute;left:60px;top:300px;width:860px;height:515px;border-radius:36px;background:rgba(14,14,16,.78);opacity:0;
  box-shadow:0 0 0 6px rgba(255,255,255,.14),0 30px 70px rgba(0,0,0,.5)}
#bph{position:absolute;left:0;top:318px;width:980px;text-align:center;color:#fff;font-weight:900;font-size:50px;opacity:0;white-space:nowrap}
.rl{position:absolute;left:78px;top:0;height:72px;display:flex;align-items:center;gap:12px;color:#fff;font-weight:700;font-size:44px;white-space:nowrap;opacity:0}
.rl svg{width:46px;height:46px;color:#FF7A1A}
.rv{position:absolute;left:762px;top:0;height:72px;display:flex;align-items:center;color:#fff;font-weight:900;font-size:50px;white-space:nowrap;opacity:0;
  -webkit-text-stroke:10px #0E0E10;paint-order:stroke fill;transform-origin:0 50%}
#fnote{position:absolute;left:120px;top:1338px;width:780px;text-align:center;color:#fff;font-weight:700;font-size:29px;line-height:1.3;opacity:0;
  -webkit-text-stroke:8px #0E0E10;paint-order:stroke fill}
.ax{position:absolute;color:rgba(255,255,255,.9);font-weight:700;font-size:40px;opacity:0;-webkit-text-stroke:8px #0E0E10;paint-order:stroke fill}
#caps{position:absolute;left:0;top:0;width:1080px;height:1920px;z-index:60;pointer-events:none}
#gbars{position:absolute;left:0;top:0;width:1080px;height:1920px;z-index:40;pointer-events:none}
#gbars div{position:absolute;left:60px;width:840px;opacity:0;mix-blend-mode:screen}
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
</filter>
<linearGradient id="areaG" x1="0" y1="0" x2="0" y2="1"><stop offset="0" stop-color="#FF7A1A" stop-opacity=".45"/><stop offset="1" stop-color="#FF7A1A" stop-opacity="0"/></linearGradient>
</defs></svg>

<div id="stage" data-layout-allow-overflow data-layout-allow-overlap>
<div id="scenes" data-layout-allow-overflow data-layout-allow-overlap style="position:absolute;left:0;top:0;width:1080px;height:1920px;z-index:0;isolation:isolate">
  <div class="sc" id="sh-hook"><div class="kb" id="kb-hook"><img class="bgi" src="assets/hook-bg.jpg" alt=""/></div>
    <div class="card" id="cd-hook" style="left:100px;top:690px;width:820px;height:680px"><div class="cin" id="ci-hook"><img src="assets/hook-card.jpg" alt=""/></div></div><div class="vig"></div></div>
  <div class="sc" id="sh-believe"><div class="kb" id="kb-believe">%%V_BELIEVE%%</div><div class="vig"></div></div>
  <div class="sc" id="sh-hourglass"><div class="kb" id="kb-hourglass">%%V_HOURGLASS%%</div><div class="vig"></div></div>
  <div class="sc" id="sh-past"><div class="kb" id="kb-past"><img class="bgi" src="assets/past-bg.jpg" alt=""/></div>
    <div class="card" id="cd-past" style="left:100px;top:440px;width:820px;height:640px"><div class="cin" id="ci-past"><img src="assets/past-card.jpg" alt=""/></div></div>
    <div class="grain" id="gr-past"></div><div class="vig"></div></div>
  <div class="sc" id="sh-past2"><div class="kb" id="kb-past2"><img class="bgi" src="assets/past2-bg.jpg" alt=""/></div>
    <div class="card" id="cd-past2" style="left:220px;top:420px;width:640px;height:820px"><div class="cin" id="ci-past2"><img src="assets/past2-card.jpg" alt=""/></div></div>
    <div class="grain" id="gr-past2"></div><div class="vig"></div></div>
  <div class="sc gsc" id="sh-count"><div class="kb" id="kb-count"><img class="bgi" src="assets/gbg-count.jpg" alt=""/></div><svg class="stars" viewBox="0 0 1080 1920"></svg><div class="vig"></div></div>
  <div class="sc gsc" id="sh-formula"><div class="kb" id="kb-formula"><img class="bgi" src="assets/gbg-formula.jpg" alt=""/></div><svg class="stars" viewBox="0 0 1080 1920"></svg><div class="vig"></div></div>
  <div class="sc" id="sh-drill"><div class="kb" id="kb-drill"><img class="bgi" src="assets/drill-bg.jpg" alt=""/></div>
    <div class="card" id="cd-drill" style="left:220px;top:520px;width:640px;height:820px"><div class="cin" id="ci-drill"><img src="assets/drill-card.jpg" alt=""/></div></div><div class="vig"></div></div>
  <div class="sc" id="sh-newfield"><div class="kb" id="kb-newfield"><img class="bgi" src="assets/newfield-bg.jpg" alt=""/></div>
    <div class="card" id="cd-newfield" style="left:100px;top:540px;width:820px;height:640px"><div class="cin" id="ci-newfield"><img src="assets/newfield-card.jpg" alt=""/></div></div><div class="vig"></div></div>
  <div class="sc" id="sh-now"><div class="kb" id="kb-now">%%V_NOW%%</div><div class="vig"></div></div>
  <div class="sc" id="sh-oil"><div class="kb" id="kb-oil"><img class="bgi" src="assets/oil-bg.jpg" alt=""/></div>
    <div class="card" id="cd-oil" style="left:100px;top:840px;width:820px;height:600px"><div class="cin" id="ci-oil"><img src="assets/oil-card.jpg" alt=""/></div></div><div class="vig"></div></div>
  <div class="sc" id="sh-gas"><div class="kb" id="kb-gas">%%V_GAS_BG%%</div>
    <div class="card" id="cd-gas" style="left:100px;top:832px;width:820px;height:293px"><div class="cin" id="ci-gas">%%V_GAS_CARD%%</div></div><div class="vig"></div></div>
  <div class="sc" id="sh-coal"><div class="kb" id="kb-coal">%%V_COAL%%</div><div class="vig"></div></div>
  <div class="sc" id="sh-uranium"><div class="kb" id="kb-uranium">%%V_URANIUM_BG%%</div>
    <div class="card" id="cd-uranium" style="left:100px;top:830px;width:820px;height:586px"><div class="cin" id="ci-uranium">%%V_URANIUM_CARD%%
      <svg id="towers" viewBox="0 0 820 586" width="820" height="586" style="position:absolute;left:0;top:0;overflow:visible">
        <defs><linearGradient id="twG" x1="0" x2="1"><stop offset="0" stop-color="#5B6470"/><stop offset=".45" stop-color="#3A424C"/><stop offset="1" stop-color="#1E242B"/></linearGradient>
          <radialGradient id="stG"><stop offset="0" stop-color="#fff" stop-opacity=".95"/><stop offset="1" stop-color="#fff" stop-opacity="0"/></radialGradient></defs>
        <g id="tw2" transform="translate(560 478)"><ellipse id="st2" cx="0" cy="-6" rx="46" ry="22" fill="url(#stG)"/>
          <path d="M-44 0 Q-30 64 -56 108 L56 108 Q30 64 44 0 Z" fill="url(#twG)" stroke="#14181D" stroke-width="4"/><ellipse cx="0" cy="0" rx="44" ry="8" fill="#2A3038" stroke="#14181D" stroke-width="3"/></g>
        <g id="tw1" transform="translate(690 432)"><ellipse id="st1" cx="0" cy="-8" rx="64" ry="28" fill="url(#stG)"/>
          <path d="M-60 0 Q-42 92 -78 154 L78 154 Q42 92 60 0 Z" fill="url(#twG)" stroke="#14181D" stroke-width="5"/><ellipse cx="0" cy="0" rx="60" ry="10" fill="#2A3038" stroke="#14181D" stroke-width="4"/></g>
      </svg></div>
    <div class="chip" id="chU" style="left:24px;top:22px;height:84px;font-size:50px;padding:0 26px 0 20px;border-radius:24px;opacity:1"><svg class="ic" style="color:#FFC53D;width:52px;height:52px"><use href="#ic-atom"/></svg>ยูเรเนียม</div></div><div class="vig"></div></div>
  <div class="sc gsc" id="sh-sun"><div class="kb" id="kb-sun">%%V_SUN_BG%%</div><svg class="stars" viewBox="0 0 1080 1920"></svg>
    <div class="band" id="bd-a" style="top:0">%%V_SUN_A%%</div><div class="band" id="bd-b" style="top:640px">%%V_SUN_B%%</div>
    <div class="band" id="bd-c" style="top:1280px">%%V_SUN_C%%</div><div class="vig"></div></div>
  <div class="sc" id="sh-refill"><div class="kb" id="kb-refill">%%V_REFILL_BG%%</div>
    <div class="card" id="cd-refill" style="left:100px;top:790px;width:820px;height:586px"><div class="cin" id="ci-refill">%%V_REFILL_CARD%%</div></div><div class="vig"></div></div>
  <div class="sc" id="sh-finite"><div class="kb" id="kb-finite">%%V_FINITE_BG%%</div>
    <div class="card" id="cd-finite" style="left:260px;top:730px;width:560px;height:700px"><div class="cin" id="ci-finite">%%V_FINITE_CARD%%</div></div><div class="vig"></div></div>
  <div class="sc gsc" id="sh-finite2"><div class="kb" id="kb-finite2"><img class="bgi" src="assets/gbg-finite.jpg" alt=""/></div><svg class="stars" viewBox="0 0 1080 1920"></svg><div class="vig"></div></div>
  <div class="sc" id="sh-save"><div class="kb" id="kb-save">%%V_SAVE_BG%%</div>
    <div class="card" id="cd-save" style="left:100px;top:560px;width:820px;height:820px"><div class="cin" id="ci-save">%%V_SAVE_CARD%%</div></div><div class="vig"></div></div>
  <div class="sc" id="sh-ask"><div class="kb" id="kb-ask"><img class="bgi" src="assets/hook-bg.jpg" alt=""/></div>
    <div class="card" id="cd-ask" style="left:100px;top:690px;width:820px;height:680px"><div class="cin" id="ci-ask"><img src="assets/hook-card.jpg" alt=""/></div></div><div class="vig"></div></div>
</div>

<div id="over" data-layout-allow-overflow data-layout-allow-overlap style="position:absolute;left:0;top:0;width:1080px;height:1920px;z-index:10">
  <div id="bpanel"></div><div id="bph"></div>
  <div class="ax" id="ax1980">1980</div>
  <svg class="ov" id="gsvg" viewBox="0 0 1080 1920" width="1080" height="1920"><g id="glayer"></g></svg>
  <div id="bl"><span id="blt"></span></div>
  <div class="rl" id="rl0"><svg class="ic"><use href="#ic-fuel"/></svg>น้ำมัน</div>
  <div class="rl" id="rl1"><svg class="ic"><use href="#ic-flame"/></svg>ก๊าซ</div>
  <div class="rl" id="rl2"><svg class="ic"><use href="#ic-mountain"/></svg>ถ่านหิน</div>
  <div class="rl" id="rl3"><svg class="ic" style="color:#FFC53D"><use href="#ic-atom"/></svg>ยูเรเนียม</div>
  <div class="rv" id="rv0">~56 ปี</div><div class="rv" id="rv1">~48 ปี</div><div class="rv" id="rv2">~140 ปี</div><div class="rv" id="rv3">~85 ปี</div>
  <div id="fnote">ถ้าใช้เท่าปัจจุบัน · ฟอสซิล: ข้อมูลปี 2020 (Energy Institute)<br/>ยูเรเนียม: Red Book 2026</div>
  <!-- year counter label -->
  <div class="big" id="yr" style="top:262px;font-size:132px"><span id="yrA">ปี <em>1980</em></span></div>
  <div class="big" id="yr2" style="top:262px;font-size:132px">ปี <em>2020</em></div>
  <!-- formula -->
  <div class="chip" id="fnum"><svg class="ic"><use href="#ic-pickaxe"/></svg>ขุดได้คุ้ม</div>
  <div class="big" id="fdiv" style="top:452px;font-size:170px;color:#FF7A1A">÷</div>
  <div class="chip" id="fden"><svg class="ic"><use href="#ic-calendar-clock"/></svg>ใช้ต่อปี</div>
  <div class="big" id="feq" style="top:770px;font-size:120px">=</div>
  <!-- sun split chips -->
  <div class="chip" id="chA"><svg class="ic" style="color:#FFE14D"><use href="#ic-sun"/></svg>แดด</div>
  <div class="chip" id="chB"><svg class="ic" style="color:#BFE8FF"><use href="#ic-wind"/></svg>ลม</div>
  <div class="chip" id="chC"><svg class="ic" style="color:#7FD3FF"><use href="#ic-droplets"/></svg>น้ำ</div>
  <div class="pill" id="pill"><div class="bd"><svg class="ic"><use id="pillUse" href="#ic-users"/></svg></div>
    <span class="tx" id="pillA"></span><span class="tx" id="pillB"></span></div>
  <div id="tshade"></div>
  <div class="ttl" id="title"><div class="tl" id="tl1">น้ำมันจะหมด</div><div class="tl" id="tl2">โลกปีไหน?</div></div>
  <div class="ttl" id="atitle"><div class="tl" id="aq1">แล้วคิดว่า</div><div class="tl" id="aq2">อะไรจะ<span style="color:#FF7A1A">หมด</span>ก่อน?</div></div>
  <div id="meas"></div>
</div>
</div>
<div id="gbars"><div id="gb0"></div><div id="gb1"></div><div id="gb2"></div></div>

<div id="caps" data-track-kind="captions">
%%CAPS%%
</div>

<audio id="vo" class="clip" data-start="0" data-duration="%%DUR%%" data-track-index="30" data-volume="1" src="assets/vo-th.mp3"></audio>
<audio id="music" class="clip" data-start="0" data-duration="%%DUR%%" data-track-index="31" data-volume="0.1" src="assets/music-jamendo-2f1bc5f2.mp3"></audio>
</div>

<script>
/* Motion: closed-form springs (motion-broll engine, from templates/brainrot-v2). Shot times = assets/audio/shots-th.json,
   word anchors = words.json (both injected by build_index.py). ONE graphic morphs through the whole clip: the
   "energy bar" (battery). hook: red, nearly empty, blinking -> past: counter (1980: 30 years) -> count: runs 30->56 on
   the real OWID line, pops on "ห้าสิบกว่าปีซะ" (hit) -> formula result "เหลือกี่ปี?" -> now: splits into 4 bars (oil/gas/
   coal/uranium, lengths = years/150) -> sun: merges into one green "ไม่หมด ∞" bar -> finite: turns orange and drains ->
   finite2: splits again, all shrink -> save -> ask: back to the hook battery (last frame ~ frame 0). Springs only. */
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
const trackV=(v0,keys,def)=>v0.map((x,j)=>track(x,keys.map(k=>[k[0],k[1][j],k[2]]),def));
const hex=h=>[1,3,5].map(i=>parseInt(h.slice(i,i+2),16));
const mix=(a,b,u)=>{const x=hex(a),y=hex(b);u=clamp(u);return '#'+x.map((v,i)=>Math.round(lerp(v,y[i],u)).toString(16).padStart(2,'0')).join('');};
const $=id=>document.getElementById(id);
const el=(tag,attrs,parent)=>{const e=document.createElementNS(NS,tag);for(const k in attrs)e.setAttribute(k,attrs[k]);parent.appendChild(e);return e;};
const show=(e,o)=>{e.style.opacity=o<0.003?'0':o.toFixed(4);return o>=0.003;};
const f2=v=>v.toFixed(2);
const win=(t,a,b,sp=POP)=>{if(t<a||t>=b+0.1)return 0; const i=S(t-a,sp[0],sp[1]); const o=t>b?1-clamp((t-b)/0.08):1; return Math.max(0,i)*o;};
const pinO=(t,a,b)=>(t<a||t>=b+0.1)?0:clamp((t-a)/0.08)*(t>b?1-clamp((t-b)/0.08):1);
const meas=$('meas'); const wcache={};
const tw=txt=>{if(wcache[txt])return wcache[txt]; meas.textContent=txt; const w=meas.offsetWidth;
  if(document.fonts&&document.fonts.status==='loaded'&&w>0)wcache[txt]=w; return w||txt.length*28;};
const ORG='#FF7A1A',GRN='#3DDC84',RED='#FF3B30',URA='#FFC53D',GREY='#5A5A62',INK='#0E0E10',YEL='#FFE14D';
const G=$('glayer');

// ---------- scenes ----------
// entries: cut | whip (0.12 s push) | zoom (zoom punch-in, 0.1 s fade) | match (0.1 s crossfade)
// kind: full (9:16 plate) | card (sharp card over the blurred same source, parallax) | g (graphic backdrop) | bands
const SC=[
 {id:'hook',a:0,k:'card',s0:1.0,s1:1.06,in:'none',still:1},
 {id:'believe',a:T.believe,k:'full',s0:1.03,s1:1.10,r0:0.6,r1:-0.6,org:'50% 60%',in:'whip'},
 {id:'hourglass',a:T.hourglass,k:'full',s0:1.04,s1:1.12,r0:-0.6,r1:0.5,org:'50% 50%',in:'match'},
 {id:'past',a:T.past,k:'card',s0:1.0,s1:1.10,r0:-1.2,r1:0.6,in:'cut'},
 {id:'past2',a:T.past2,k:'card',s0:1.02,s1:1.12,r0:1.0,r1:-0.8,in:'whip'},
 {id:'count',a:T.count,k:'g',in:'zoom'},
 {id:'formula',a:T.formula,k:'g',in:'zoom'},
 {id:'drill',a:T.drill,k:'card',s0:1.0,s1:1.10,r0:-1.0,r1:0.8,in:'whip'},
 {id:'newfield',a:T.newfield,k:'card',s0:1.02,s1:1.12,r0:0.8,r1:-0.8,in:'match'},
 {id:'now',a:T.now,k:'full',s0:1.03,s1:1.10,r0:0.5,r1:-0.5,org:'50% 70%',in:'zoom'},
 {id:'oil',a:T.oil,k:'card',s0:1.0,s1:1.10,r0:-0.8,r1:0.6,in:'cut'},
 {id:'gas',a:T.gas,k:'card',s0:1.02,s1:1.10,r0:0.8,r1:-0.6,in:'whip'},
 {id:'coal',a:T.coal,k:'full',s0:1.03,s1:1.09,r0:-0.5,r1:0.5,org:'40% 70%',in:'whip'},
 {id:'uranium',a:T.uranium,k:'card',s0:1.0,s1:1.10,r0:0.6,r1:-0.6,in:'whip'},
 {id:'sun',a:T.sun,k:'bands',in:'zoom'},
 {id:'refill',a:T.refill,k:'card',s0:1.0,s1:1.08,r0:-0.8,r1:0.6,in:'match'},
 {id:'finite',a:T.finite,k:'card',s0:1.0,s1:1.10,r0:0.8,r1:-0.8,in:'cut'},
 {id:'finite2',a:T.finite2,k:'g',in:'zoom'},
 {id:'save',a:T.save,k:'card',s0:1.0,s1:1.08,r0:-0.6,r1:0.6,in:'whip'},
 {id:'ask',a:T.ask,k:'card',s0:1.05,s1:1.0,in:'match',still:1},
];
SC.forEach((s,i)=>{s.next=SC[i+1]; s.b=s.next?s.next.a:DUR; s.e=$('sh-'+s.id); s.e.style.zIndex=String(i+1);
  s.kb=$('kb-'+s.id); s.cd=$('cd-'+s.id); s.ci=$('ci-'+s.id); if(s.kb&&s.org)s.kb.style.transformOrigin=s.org;});
const XF=0.12, BLEAD=0.12, NLEAD=0.25; // strips / number bars start just before their word
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
  SC.forEach(s=>{const r=sceneState(s,t), e=s.e;
    if(!r){e.style.opacity='0';return;}
    e.style.opacity=r.o.toFixed(4); e.style.transform=`translateX(${f2(r.tx)}px) scale(${r.sc.toFixed(4)})`;
    const uu=clamp((t-s.a)/Math.max(0.3,(s.b-s.a)));
    if(s.k==='full'){
      const k=lerp(s.s0,s.s1,eio(0.1+0.9*uu)), rr=lerp(s.r0,s.r1,uu), dx=10*Math.sin(t*1.7+s.a), dy=8*Math.cos(t*1.3+s.a);
      s.kb.style.transform=`translate(${f2(dx)}px,${f2(dy)}px) rotate(${rr.toFixed(3)}deg) scale(${k.toFixed(5)})`;
    } else if(s.k==='card'){
      const k=lerp(s.s0,s.s1,s.still?uu:eio(0.1+0.9*uu));
      if(s.still){ s.kb.style.transform='scale(1.06)'; s.cd.style.transform='none'; s.ci.style.transform=`scale(${k.toFixed(5)})`; return; }
      // parallax: bg drifts one way slowly, card the other way + small rotation, image pushes in inside the card
      const dx=14*Math.sin(t*1.3+s.a), dy=10*Math.cos(t*1.1+s.a), rr=lerp(s.r0,s.r1,uu);
      s.kb.style.transform=`translate(${f2(-dx*0.6)}px,${f2(-dy*0.6)}px) scale(${(1.08+0.06*uu).toFixed(4)})`;
      s.cd.style.transform=`translate(${f2(dx)}px,${f2(dy+16*(1-eo(uu*3)))}px) rotate(${rr.toFixed(3)}deg)`;
      s.ci.style.transform=`scale(${k.toFixed(5)})`;
    } else if(s.k==='g'){
      s.kb.style.transform=`translate(${f2(12*Math.sin(t*0.9))}px,0) scale(${(1.06+0.08*uu).toFixed(4)})`;
    }
  });
  // sun split: bands slide in on "แดด" / "ลม" / "น้ำ"
  [['bd-a',K.daed-BLEAD,1],['bd-b',K.lom-BLEAD,-1],['bd-c',K.nam-BLEAD,1]].forEach(([id,a,dir])=>{const b=$(id), u=t-a;
    if(u<0){b.style.opacity='0';return;} const p=S(u,26,0.9); b.style.opacity='1';
    b.style.transform=`translateX(${f2(dir*1080*(1-p))}px) scale(${(1.0+0.05*clamp((t-a)/2.2)).toFixed(4)})`;});
}
// embers drifting up in the graphic backdrops (deterministic)
const STARS=[]; document.querySelectorAll('.stars').forEach((sv,j)=>{for(let i=0;i<40;i++){const x=(i*233+j*97)%1080, y=(i*421+j*151)%1920, r=2+(i%4);
  STARS.push({e:el('circle',{cx:x,cy:y,r,fill:i%5?'#FF9A4A':'#FFE14D',opacity:.5},sv),x,y,i,j});}});
function stars(t){STARS.forEach(s=>{s.e.setAttribute('cy',f2(((s.y-t*(40+s.i%5*14))%1920+1920)%1920)); s.e.setAttribute('cx',f2(s.x+14*Math.sin(t*1.3+s.i)));
  s.e.setAttribute('opacity',f2(0.2+0.4*(0.5+0.5*Math.sin(t*3+s.i))));});}
// film grain on past/past2 (registry grain-overlay texture; offset stepped per frame from t, seek-safe)
function grain(t){const fi=Math.floor(t*30); ['gr-past','gr-past2'].forEach((id,j)=>{const g=$(id);
  const x=((fi*37+j*11)%23-11)*24, y=((fi*53+j*7)%19-9)*24; g.style.transform=`translate(${x}px,${y}px)`;});}

// ---------- zoom punches (hit "ห้าสิบกว่าปีซะ", "หารด้วย", "ไม่หมด") + glitch on the "แต่" cut to the past (registry zoom-through / rgb-glitch-text, adapted) ----------
const PUNCH=[H.count2,K.han,K.maimod];
const GL=[T.past], GLD=0.134;
const GOFF=[[10,-8,-14],[-8,10,-6],[12,-6,-16],[-6,6,-8]];
function fx(t){
  let p=0; PUNCH.forEach(a=>{const u=t-a; if(u>=0&&u<0.8)p+=0.085*Math.exp(-u*7)*Math.cos(u*13);});
  let gi=-1; GL.forEach(a=>{if(t>=a&&t<a+GLD)gi=Math.floor((t-a)*30);});
  const st=$('stage');
  if(gi>=0){const o=GOFF[gi%4]; $('rgbR').setAttribute('dx',o[0]); $('rgbB').setAttribute('dx',o[1]); st.style.filter='url(#rgbx)';
    st.style.transform=`translateX(${o[2]}px) scale(${(1+p).toFixed(4)})`;}
  else { st.style.filter='none'; st.style.transform=`scale(${(1+p).toFixed(4)})`; }
  ['gb0','gb1','gb2'].forEach((id,i)=>{const b=$(id); if(gi<0){b.style.opacity='0';return;}
    const y=[(300+gi*410)%1500,(820+gi*290)%1500,(560+gi*530)%1500][i]+120, h=[26,60,14][i];
    b.style.top=y+'px'; b.style.height=h+'px'; b.style.background=['#22d3ee','#ef4444','#FFFFFF'][i]; b.style.opacity=['.55','.45','.6'][i];
    b.style.transform=`translateX(${(i%2?-1:1)*(20+gi*9)}px)`;});
}

// ---------- hook title (complete at frame 0, breathes) / closing question; hook title springs back for the loop ----------
const TL=[['tl1',284,150],['tl2',462,150],['aq1',268,96],['aq2',400,138]];
TL.forEach(([id,y,s])=>{$(id).style.top=y+'px'; $(id).style.fontSize=s+'px';});
const TBACK=DUR-0.25;
function title(t){
  let o,sc;
  if(t<TBACK){ const out=eo((t-(T.believe-0.04))/0.12); o=1-out; sc=1+0.25*out; }
  else { const a=S(t-TBACK,26,0.8); o=clamp(a*1.4); sc=1+0.12*(1-a); }
  show($('title'),o);
  const br=1+0.04*(0.5-0.5*Math.cos(t*2*Math.PI/0.9)), live=t<TBACK?1:0;
  ['tl1','tl2'].forEach((id,i)=>{$(id).style.transform=`translateY(${f2(live*3*Math.sin(t*3+i))}px) rotate(${f2(i===1?-1.2*live*Math.sin(t*2.4):0)}deg) scale(${((t<TBACK?br:1)*sc).toFixed(4)})`;});
  // closing question: springs in on the cut to "คิดว่า", clears as the hook title returns
  const qa=t<T.ask?0:S(t-T.ask,POP[0],POP[1]), qo=t<TBACK?clamp(qa*2):1-clamp((t-TBACK)/0.12);
  show($('atitle'),qo);
  $('aq1').style.transform=`translateY(${f2(20*(1-clamp(qa)))}px) scale(${f2(Math.max(0.001,0.8+0.2*qa))})`;
  const q2=t<K.arai?0.85:1+0.08*(1-S(t-K.arai,BOUNCE[0],BOUNCE[1]));
  $('aq2').style.transform=`scale(${(Math.max(0.001,qa)*q2*(1+0.03*Math.sin(t*5))).toFixed(4)}) rotate(${f2(-1.5*Math.sin(t*2.6))}deg)`;
  show($('tshade'),Math.max(o,qo));
}

// ---------- THE energy bar (4 batteries that are one while merged) ----------
const HOOKG=[510,1255,500,130], MAING=[540,1000,640,140], TOPG=[540,430,560,110], MIDG=[540,640,640,130], SAVEG=[540,440,520,110];
const ROW=i=>[555,440+105*i,350,72];
const YRS=[56,48,140,85], CAP=150;              // years left (research ✅), bar length = years / 150
const NUMW=[K.oiln,K.gasn,K.coaln,K.uran], NAMEW=[K.oil,K.gas,K.coal,K.ura];
const geo=[0,1,2,3].map(i=>trackV(HOOKG,[[T.believe+0.25,MAING,OUT],[T.drill,TOPG],[T.now+0.08+i*0.06,ROW(i)],[T.sun,MIDG],
  [T.finite2,ROW(i)],[T.save,SAVEG],[T.ask,HOOKG]]));
const sc0=track(1,[[T.believe,0,OUT],[T.past+0.1,1,BOUNCE]]);
const BARS=[0,1,2,3].map(i=>{const g=el('g',{},G);
  const halo=el('rect',{fill:'none',stroke:INK,'stroke-width':18},g);
  const cs=el('rect',{fill:'rgba(14,14,16,.82)',stroke:'#F4EFE6','stroke-width':7},g);
  const nub=el('rect',{fill:'#F4EFE6',stroke:INK,'stroke-width':4},g);
  const fl=el('rect',{},g); const sh=el('rect',{fill:'#fff',opacity:.22},g);
  return {g,halo,cs,nub,fl,sh};});
// count: 30 -> 56 eased from "สี่สิบปี" to the hit, the OWID line draws in step
const cntP=t=>eio((t-K.sisip2)/(H.count2-K.sisip2));
const cntV=t=>lerp(30,56,cntP(t));
function rowFill(i,t){const a=NUMW[i]-NLEAD; return t<a?0:YRS[i]/CAP*clamp(S(t-a,16,0.7),0,1.15);}
const sunF=track(0,[[K.daed-BLEAD,1/3],[K.lom-BLEAD,2/3],[K.nam-BLEAD,1]],[16,0.8]);
function fin2Fill(i,t){const a=T.finite2+0.25, b=K.mod2+0.25; return YRS[i]/CAP*(1-0.9*clamp((t-a)/(b-a)));}
function fillOf(i,t){
  if(t<T.believe) return 0.1;
  if(t<K.sisip2) return t<K.lue30?0:0.2*S(t-K.lue30,14,0.6);
  if(t<T.now) return cntV(t)/CAP+(t>K.khayab?0.08*Math.sin((t-K.khayab)*9)*Math.exp(-(t-K.khayab)*1.2):0);
  if(t<T.sun) return lerp(56/CAP,0,S(t-T.now,FAST[0],FAST[1]))+rowFill(i,t);
  if(t<T.finite){ return lerp(rowFill(i,T.sun),0,S(t-T.sun,FAST[0],FAST[1]))+sunF(t); }
  if(t<T.finite2) return lerp(1,0.6,eio((t-T.finite)/(T.finite2-T.finite)));
  if(t<T.save) return lerp(0.6,fin2Fill(i,t),S(t-T.finite2,MORPH[0],MORPH[1]));
  if(t<T.ask) return lerp(fin2Fill(i,T.save),0.08,S(t-T.save,MORPH[0],MORPH[1]));
  return lerp(0.08,0.1,S(t-T.ask,MORPH[0],MORPH[1]));
}
function colOf(i,t){
  if(t<T.believe) return RED;
  if(t<T.now) return ORG;
  const rc=i===3?URA:ORG;
  if(t<T.sun) return mix(ORG,rc,S(t-T.now,MORPH[0],MORPH[1]));
  if(t<T.finite) return mix(rc,GRN,S(t-T.sun,MORPH[0],MORPH[1]));
  if(t<T.finite2) return mix(GRN,ORG,S(t-K.tae2,MORPH[0],MORPH[1]));
  if(t<T.save) return t<K.mod2?mix(ORG,i===3?URA:ORG,S(t-T.finite2,MORPH[0],MORPH[1])):mix(i===3?URA:ORG,RED,S(t-K.mod2,MORPH[0],MORPH[1]));
  return RED;
}
const blinkOn=t=>(t<T.believe||t>=T.ask);
const split=t=>(t>=T.now&&t<T.sun+0.45)||(t>=T.finite2&&t<T.save+0.45);
function bars(t){
  BARS.forEach((b,i)=>{
    const vis=i===0?Math.max(0,sc0(t)):(split(t)?1:0);
    if(vis<0.003){b.g.setAttribute('opacity','0');return;} b.g.setAttribute('opacity','1');
    const [cx,cy,w,h]=geo[i].map(f=>f(t)), pad=Math.max(8,h*0.11), r=h*0.26;
    // hit pop on the counter + breathing
    const pop=(i===0&&t>=H.count2&&t<T.formula)?0.1*Math.exp(-(t-H.count2)*6)*Math.sin((t-H.count2)*16):0;
    const s=vis*(1+pop+0.012*Math.sin(t*3.1+i));
    b.g.setAttribute('transform',`translate(${f2(cx)} ${f2(cy+3*Math.sin(t*2+i))}) rotate(${f2(0.6*Math.sin(t*1.4+i))}) scale(${s.toFixed(4)})`);
    [b.halo,b.cs].forEach(e=>{e.setAttribute('x',f2(-w/2));e.setAttribute('y',f2(-h/2));e.setAttribute('width',f2(w));e.setAttribute('height',f2(h));e.setAttribute('rx',f2(r));});
    const nw=Math.max(10,h*0.13), nh=h*0.42; b.nub.setAttribute('x',f2(w/2+4)); b.nub.setAttribute('y',f2(-nh/2)); b.nub.setAttribute('width',f2(nw)); b.nub.setAttribute('height',f2(nh)); b.nub.setAttribute('rx',f2(nw/3));
    const fv=clamp(fillOf(i,t),0,1), fw=Math.max(0,(w-2*pad)*fv), col=colOf(i,t);
    const bl=blinkOn(t)?0.35+0.65*(0.5+0.5*Math.cos(t*2*Math.PI*2.2)):1;
    [b.fl,b.sh].forEach(e=>{e.setAttribute('x',f2(-w/2+pad));e.setAttribute('width',f2(fw));e.setAttribute('rx',f2(Math.min(r-pad*0.6,fw/2)));});
    b.fl.setAttribute('y',f2(-h/2+pad)); b.fl.setAttribute('height',f2(h-2*pad)); b.fl.setAttribute('fill',col); b.fl.setAttribute('opacity',f2(bl));
    b.sh.setAttribute('y',f2(-h/2+pad+4)); b.sh.setAttribute('height',f2((h-2*pad)*0.3)); b.sh.setAttribute('opacity',f2(0.22*bl));
  });
}
// label riding on the bar
const blt=$('blt');
function barLabel(t){
  let txt=null, key='';
  if(t>=K.lue30&&t<K.sisip2){txt='เหลือ 30 ปี';key='a';}
  else if(t>=K.sisip2&&t<T.formula){txt=`เหลือ ${Math.round(cntV(t))} ปี`;key='b';}
  else if(t>=T.formula&&t<T.now){txt='เหลือกี่ปี?';key='c';}
  else if(t>=K.maimod&&t<T.finite){txt='ไม่หมด <svg class="ic"><use href="#ic-infinity"/></svg>';key='d';}
  const e=$('bl'); if(!txt){e.style.opacity='0';return;}
  const st={a:K.lue30,b:K.sisip2,c:T.formula,d:K.maimod}[key], end={a:K.sisip2,b:T.formula,c:T.now,d:T.finite}[key];
  const v=key==='b'?1:win(t,st,end,POP); if(!show(e,clamp(v*2)))return;
  if(blt.dataset.k!==txt){blt.innerHTML=txt; blt.dataset.k=txt;}
  const [cx,cy,w,h]=geo[0].map(f=>f(t)), fs=h*0.46;
  const pop=(t>=H.count2&&t<T.formula)?0.35*Math.exp(-(t-H.count2)*5)*Math.cos((t-H.count2)*14):0;
  blt.style.fontSize=f2(fs)+'px'; blt.style.color=key==='b'&&t>=H.count2?YEL:'#fff';
  e.style.transform=`translate(${f2(cx-350)}px,${f2(cy+3*Math.sin(t*2))}px) scale(${f2(Math.max(0.001,(key==='b'?1:v))*(1+pop))})`;
}
// rows: names, values, panel, header, footnote
function rows(t){
  const inA=t>=T.now&&t<T.sun, inB=t>=T.finite2&&t<T.save;
  const pv=Math.max(win(t,T.now+0.05,T.sun,MORPH),win(t,T.finite2+0.05,T.save,MORPH));
  show($('bpanel'),clamp(pv*1.4)); $('bpanel').style.transform=`scale(${f2(0.92+0.08*clamp(pv))})`;
  const ph=$('bph'); const hv=pv; if(show(ph,clamp(hv*1.6))){const tx=inB?'ขุดขึ้นมาใช้ = มีวันหมด':'เหลือกี่ปี?'; if(ph.textContent!==tx)ph.textContent=tx;}
  [0,1,2,3].forEach(i=>{const y=440+105*i-36;
    const nv=inA?win(t,Math.min(NAMEW[i],T.now+0.2+0.08*i),T.sun,POP):(inB?win(t,T.finite2+0.15+0.06*i,T.save,POP):0);
    const hl=inA&&t>=NAMEW[i]&&(i===3||t<NAMEW[i+1])?1:0;
    const rl=$('rl'+i); if(show(rl,clamp(nv*2)*(inA&&t<NAMEW[i]?0.55:1))) rl.style.transform=`translate(${f2(-30*(1-clamp(nv)))}px,${y}px) scale(${f2(1+0.08*hl*Math.abs(Math.sin((t-NAMEW[i])*5)))})`;
    const vv=inA?win(t,NUMW[i]-0.1,T.sun,BOUNCE):0, rv=$('rv'+i);
    if(show(rv,clamp(vv*2))) rv.style.transform=`translate(0px,${y}px) scale(${f2(Math.max(0.001,vv))})`;
  });
  show($('fnote'),pinO(t,T.now+0.3,T.sun));
}
// count: the OWID line (World, oil, 1980-2020) draws as the number runs
const OW=D.owid, cx0=150, cx1=870, vy=v=>870-(v-25)/(60-25)*400;
const chartG=el('g',{opacity:0},G);
const area=el('path',{fill:'url(#areaG)'},chartG);
const line=el('path',{fill:'none',stroke:ORG,'stroke-width':10,'stroke-linecap':'round','stroke-linejoin':'round'},chartG);
const dot0=el('circle',{r:14,fill:'#fff',stroke:INK,'stroke-width':6},chartG);
const dotH=el('circle',{r:20,fill:YEL,stroke:INK,'stroke-width':7},chartG);
const base=el('line',{x1:cx0,x2:cx1,y1:870,y2:870,stroke:'rgba(255,255,255,.35)','stroke-width':4},chartG);
function chart(t){
  const v=win(t,K.sisip2-0.1,T.formula,MORPH); chartG.setAttribute('opacity',f2(clamp(v*1.5)));
  show($('ax1980'),clamp(v*1.5)); $('ax1980').style.transform=`translate(${cx0-40}px,880px)`;
  if(v<0.003)return;
  const p=cntP(t), n=OW.length-1, fx=p*n, k=Math.floor(fx), fr=fx-k;
  const pts=[]; for(let j=0;j<=Math.min(k,n);j++) pts.push([cx0+(cx1-cx0)*j/n, vy(OW[j][1])]);
  if(k<n){const a=OW[k][1], b=OW[k+1][1]; pts.push([cx0+(cx1-cx0)*fx/n, vy(lerp(a,b,fr))]);}
  const d='M'+pts.map(q=>f2(q[0])+' '+f2(q[1])).join(' L');
  line.setAttribute('d',d); area.setAttribute('d',d+` L${f2(pts[pts.length-1][0])} 870 L${cx0} 870 Z`);
  dot0.setAttribute('cx',cx0); dot0.setAttribute('cy',f2(vy(OW[0][1])));
  const hd=pts[pts.length-1], hp=t>=H.count2?1+0.5*Math.exp(-(t-H.count2)*6)*Math.cos((t-H.count2)*14):1;
  dotH.setAttribute('cx',f2(hd[0])); dotH.setAttribute('cy',f2(hd[1])); dotH.setAttribute('r',f2(20*hp));
  chartG.setAttribute('transform',`translate(0 ${f2(30*(1-clamp(v)))})`);
}
// year label 1980 -> 2020 (flip on "สี่สิบปี")
function year(t){
  const a=$('yr'), b=$('yr2');
  const va=win(t,K.sisip,K.sisip2,BOUNCE); if(show(a,clamp(va*2))) a.style.transform=`scale(${f2(Math.max(0.001,va))},${f2(Math.max(0.001,t>=K.sisip2?1-clamp((t-K.sisip2)/0.08):1))}) rotate(${f2(-2*Math.sin(t*2))}deg)`;
  const vb=win(t,K.sisip2,T.formula,BOUNCE); if(show(b,clamp(vb*2))) b.style.transform=`scale(${f2(Math.max(0.001,0.9+0.1*vb))},${f2(Math.max(0.001,vb))}) rotate(${f2(-2*Math.sin(t*2))}deg)`;
}
// formula: "ขุดได้คุ้ม ÷ ใช้ต่อปี = เหลือกี่ปี"
function formula(t){
  const end=T.drill;
  [['fnum',K.namman,360],['fden',K.chai,660]].forEach(([id,a,y])=>{const e=$(id), v=win(t,a,end,BOUNCE);
    if(!show(e,clamp(v*2)))return; const w=e.offsetWidth||400;
    e.style.transform=`translate(${f2(540-w/2)}px,${f2(y-52+5*Math.sin(t*3+y))}px) rotate(${f2(-2*(1-clamp(v))+Math.sin(t*2.2+y))}deg) scale(${f2(Math.max(0.001,v))})`;});
  const vd=win(t,K.han,end,POP), dv=$('fdiv'); if(show(dv,clamp(vd*2))) dv.style.transform=`scale(${f2(Math.max(0.001,vd)*(1+0.25*Math.exp(-(t-K.han)*5)))}) rotate(${f2(lerp(-90,0,clamp(vd)))}deg)`;
  const ve=win(t,T.formula+0.05,end,POP), eq=$('feq'); if(show(eq,clamp(ve*2))) eq.style.transform=`scale(${f2(Math.max(0.001,ve))})`;
}
// the pill (one element morphing): belief -> "30 years" -> better drilling -> new fields -> save energy
const PST=[ // [t, text, colour, icon, centre x, centre y, scale]
  [K.chuea,'ความเชื่อ',RED,'users',540,330,1.45],
  [K.samsip,'อีก 30 ปีหมด?',ORG,'hourglass',540,330,1.3],
  [T.past,null],
  [K.kheng,'ขุดเก่งขึ้น',ORG,'zap',540,300,1.25],
  [K.joe,'เจอแหล่งใหม่',GRN,'search',540,300,1.25],
  [T.now,null],
  [K.prayat,'ประหยัดพลังงาน',GRN,'leaf',540,300,1.2],
  [T.ask,null],
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
// small props: warning beacon (hook/ask), up/down arrows ("ขยับได้"), sun-split chips, bulb going off (save), leaf badge
const ALR=el('g',{opacity:0},G); const alrGlow=el('circle',{r:58,fill:RED,opacity:.3},ALR); el('circle',{r:40,fill:RED,stroke:INK,'stroke-width':6},ALR);
el('use',{href:'#ic-triangle-alert',x:-26,y:-28,width:52,height:52,color:'#fff'},ALR);
const ARU=el('use',{href:'#ic-arrow-up',x:-40,y:-40,width:80,height:80,color:GRN,opacity:0},G);
const ARD=el('use',{href:'#ic-arrow-down',x:-40,y:-40,width:80,height:80,color:RED,opacity:0},G);
const BULB=el('g',{opacity:0},G); const bulbGlow=el('circle',{r:110,fill:YEL,opacity:.3},BULB);
const bulbC=el('circle',{r:64,fill:YEL,stroke:INK,'stroke-width':7},BULB);
const bulbOn=el('use',{href:'#ic-lightbulb',x:-42,y:-42,width:84,height:84,color:INK},BULB);
const bulbOff=el('use',{href:'#ic-lightbulb-off',x:-42,y:-42,width:84,height:84,color:'#fff',opacity:0},BULB);
const LEAF=el('g',{opacity:0},G); el('circle',{r:46,fill:GRN,stroke:INK,'stroke-width':6},LEAF); el('use',{href:'#ic-leaf',x:-28,y:-28,width:56,height:56,color:INK},LEAF);
function props(t){
  { const u=t-T.uranium, v=u<0?0:S(u,POP[0],POP[1]); const c=$('chU'); c.style.transform=`scale(${f2(Math.max(0.001,v))}) rotate(${f2(-2+1.5*Math.sin(t*3))}deg)`; c.style.transformOrigin='0 50%';
    ['st1','st2'].forEach((id,j)=>{const e=$(id); e.setAttribute('ry',f2((j?22:28)*(1+0.18*Math.sin(t*4+j)))); e.setAttribute('cy',f2(-(j?6:8)-6*(0.5+0.5*Math.sin(t*3+j))));}); }
  const on=blinkOn(t), a=t<T.believe?1-clamp((t-(T.believe-0.08))/0.08):S(t-T.ask-0.05,POP[0],POP[1]);
  const g=geo[0].map(f=>f(t));
  ALR.setAttribute('opacity',on?f2(clamp(a)):'0');
  ALR.setAttribute('transform',`translate(${f2(g[0]+g[2]/2+80)} ${f2(g[1])}) scale(${f2(Math.max(0.001,clamp(a))*(1+0.08*Math.sin(t*2*Math.PI*2.2)))}) rotate(${f2(6*Math.sin(t*7))})`);
  alrGlow.setAttribute('r',f2(54+12*(0.5+0.5*Math.cos(t*2*Math.PI*2.2))));
  const va=win(t,K.khayab,T.now,BOUNCE);
  [[ARU,200,-1],[ARD,880,1]].forEach(([e,x,d],j)=>{e.setAttribute('opacity',f2(clamp(va*2)));
    e.setAttribute('transform',`translate(${x} ${f2(430+d*18*Math.sin((t-K.khayab)*8+j*Math.PI))}) scale(${f2(Math.max(0.001,va))})`);});
  [['chA',K.daed-0.04,425],['chB',K.lom-0.04,745],['chC',K.nam-0.04,1318]].forEach(([id,a2,y])=>{const e=$(id), v=win(t,a2+0.08,T.refill,BOUNCE);
    if(show(e,clamp(v*2))) e.style.transform=`translate(${f2(90-40*(1-clamp(v)))}px,${y}px) rotate(${f2(-3+2*Math.sin(t*3+y))}deg) scale(${f2(Math.max(0.001,v))})`;});
  const vb=win(t,T.save+0.1,T.ask,BOUNCE), off=t>=K.palang?clamp(S(t-K.palang,20,0.7)):0;
  BULB.setAttribute('opacity',f2(clamp(vb*2))); BULB.setAttribute('transform',`translate(800 ${f2(650+6*Math.sin(t*3))}) scale(${f2(Math.max(0.001,vb)*(1+0.15*Math.exp(-Math.max(0,t-K.palang)*6)*(t>=K.palang?1:0)))})`);
  bulbGlow.setAttribute('opacity',f2(0.3*(1-off))); bulbGlow.setAttribute('r',f2(100+14*Math.sin(t*9)));
  bulbC.setAttribute('fill',mix(YEL,'#3A3A42',off)); bulbOn.setAttribute('opacity',f2(1-off)); bulbOff.setAttribute('opacity',f2(off));
  const vl=win(t,K.palang+0.1,T.ask,POP); LEAF.setAttribute('opacity',f2(clamp(vl*2)));
  LEAF.setAttribute('transform',`translate(${f2(g[0]+g[2]/2+70)} ${f2(g[1])}) rotate(${f2(-10+8*Math.sin(t*4))}) scale(${f2(Math.max(0.001,vl))})`);
}

// ---------- captions: spring in on the word ----------
const capEls=CAPT.map((s,i)=>$('c'+i).querySelector('span'));
function captions(t){
  let i=-1; for(let k=0;k<CAPT.length;k++) if(t>=CAPT[k]) i=k;
  if(i<0) return; const tau=t-CAPT[i]; const a=S(tau,30,0.6);
  capEls[i].style.transform=`translateY(${f2(22*(1-a))}px) scale(${(0.78+0.22*a).toFixed(4)}) rotate(${f2(0.6*Math.sin(t*3))}deg)`;
}

function render(t){ scenes(t); stars(t); grain(t); fx(t); title(t); chart(t); year(t); formula(t); rows(t); bars(t); barLabel(t); pillF(t); props(t); captions(t); }
const proxy={_t:0}; Object.defineProperty(proxy,'t',{get(){return this._t;},set(v){this._t=v;render(v);}});
const tl=gsap.timeline({paused:true});
tl.to(proxy,{t:%%DUR%%,duration:%%DUR%%,ease:'none'},0);
render(0);
if(document.fonts&&document.fonts.ready)document.fonts.ready.then(()=>render(proxy._t));
window.__timelines=window.__timelines||{}; window.__timelines["main"]=tl;
})();
</script>
</body></html>
