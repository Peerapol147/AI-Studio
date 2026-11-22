<!doctype html>
<!-- GENERATED: edit index.html.tpl, then run `python3 build_index.py` -->
<html lang="th"><head><meta charset="UTF-8"/><meta name="viewport" content="width=1080, height=1920"/>
<link rel="stylesheet" href="fonts/fonts.css"/>
<script src="https://cdn.jsdelivr.net/npm/gsap@3.15.0/dist/gsap.min.js"></script>
<style>
*{margin:0;padding:0;box-sizing:border-box}
html,body{width:1080px;height:1920px;overflow:hidden;background:#000}
#root{position:relative;width:1080px;height:1920px;overflow:hidden;font-family:'Kanit',sans-serif;background:#070b1c}
#stage{position:absolute;left:0;top:0;width:1080px;height:1920px;transform-origin:50% 40%}
.sc{position:absolute;left:0;top:0;width:1080px;height:1920px;overflow:hidden;opacity:0}
.kb{position:absolute;left:0;top:0;width:1080px;height:1920px}
.vid{position:absolute;left:0;top:0;width:1080px;height:1920px;object-fit:cover}
.vig{position:absolute;left:0;top:0;width:1080px;height:1920px;background:radial-gradient(ellipse at 50% 45%,rgba(7,11,28,0) 50%,rgba(3,5,14,.62) 100%)}
.dbg{position:absolute;left:0;top:0;width:1080px;height:1920px;background:radial-gradient(ellipse at 50% 38%,#16224a 0%,#0c1430 50%,#05070f 100%)}
.dbg.lit{background:radial-gradient(ellipse at 50% 36%,#5466c4 0%,#2c3a86 42%,#121a46 100%)}
.dbg.room{background:radial-gradient(ellipse at 50% 42%,#26306a 0%,#141b44 50%,#070a1c 100%)}
.stars{position:absolute;left:0;top:0;width:1080px;height:1920px;overflow:visible}
.ov{position:absolute;left:0;top:0;width:1080px;height:1920px;overflow:visible}
#moondim{position:absolute;left:0;top:0;width:1080px;height:1920px;background:radial-gradient(circle at 632px 270px,rgba(4,7,20,.62) 0px,rgba(4,7,20,.45) 260px,rgba(4,7,20,0) 520px)}
#tshade{position:absolute;left:0;top:0;width:1080px;height:900px;background:linear-gradient(rgba(4,6,18,.80) 0%,rgba(4,6,18,.55) 58%,rgba(4,6,18,0) 100%)}
#title{position:absolute;left:0;top:0;width:1080px;height:760px}
#title .tl{position:absolute;left:0;width:1080px;text-align:center;font-weight:900;line-height:1;white-space:nowrap;color:#fff;
  -webkit-text-stroke:26px #10080A;paint-order:stroke fill;transform-origin:50% 60%;text-shadow:0 12px 0 rgba(0,0,0,.45)}
#title #tl2{color:#FFE14D}
.pill{position:absolute;left:0;top:0;height:96px;border-radius:48px;border:7px solid #10080A;opacity:0;white-space:nowrap;
  box-shadow:0 10px 0 rgba(0,0,0,.35);transform-origin:50% 50%}
.pill .tx{position:absolute;top:50%;left:96px;transform:translateY(-54%);font-weight:900;font-size:50px;white-space:nowrap;color:#10080A}
.pill .bd{position:absolute;left:12px;top:9px;width:64px;height:64px;border-radius:32px;background:#10080A}
.pill .bd svg{width:44px;height:44px;color:#fff;position:absolute;left:10px;top:10px}
.ic{overflow:visible}
#meas{position:absolute;left:-3000px;top:0;font-weight:900;font-size:50px;white-space:nowrap;visibility:hidden}
.tag{position:absolute;left:0;top:0;padding:0 26px;height:64px;line-height:60px;border-radius:32px;background:#FFE14D;border:6px solid #10080A;
  color:#10080A;font-weight:900;font-size:38px;white-space:nowrap;opacity:0;box-shadow:0 8px 0 rgba(0,0,0,.35)}
/* t1 big "?" */
#qmark{position:absolute;left:0;top:520px;width:1080px;text-align:center;font-weight:900;font-size:520px;line-height:1;opacity:0;color:#FFE14D;
  -webkit-text-stroke:34px #10080A;paint-order:stroke fill;transform-origin:50% 55%}
/* t2 hypothesis card */
#hcard{position:absolute;left:150px;top:400px;width:780px;height:560px;border-radius:40px;background:#FFF8EE;opacity:0;
  box-shadow:0 0 0 8px #10080A,0 30px 70px rgba(0,0,0,.55);transform-origin:50% 50%}
#hcard .icb{position:absolute;left:60px;top:60px;width:150px;height:150px;border-radius:75px;background:#16224a;border:7px solid #10080A}
#hcard .icb svg{position:absolute;left:29px;top:29px;width:78px;height:78px;color:#FFD0DC}
#hcard .h1{position:absolute;left:240px;top:84px;font-weight:900;font-size:64px;color:#5B3A9A;white-space:nowrap}
#hcard .h2{position:absolute;left:0;top:250px;width:780px;text-align:center;font-weight:900;font-size:220px;line-height:1;color:#10080A;white-space:nowrap}
#hcard .uline{position:absolute;left:240px;top:178px;width:470px;height:14px;border-radius:7px;background:#FF4F7A;transform-origin:0 50%}
/* t5 TV static */
#tvstatic{position:absolute;left:0;top:0;width:520px;height:400px;image-rendering:pixelated;opacity:0;border-radius:44px}
/* t7b glitch word (registry: rgb-glitch-text, adapted) */
.hf-catalog-rgb-glitch-text{position:absolute;left:0;top:0;width:1080px;text-align:center;font-weight:900;font-size:190px;line-height:1.2;opacity:0}
.hf-catalog-rgb-glitch-text span,.hf-catalog-rgb-glitch-text strong{position:absolute;left:0;top:0;width:1080px;text-align:center}
.hf-catalog-rgb-glitch-text span:first-child{color:#ef4444;transform:translateX(var(--hf-glitch-red,0px))}
.hf-catalog-rgb-glitch-text span:nth-child(2){color:#22d3ee;transform:translateX(var(--hf-glitch-blue,0px))}
.hf-catalog-rgb-glitch-text strong{color:#FF3B4E;-webkit-text-stroke:26px #10080A;paint-order:stroke fill}
.hf-catalog-rgb-glitch-text span{-webkit-text-stroke:26px currentColor;paint-order:stroke fill;opacity:.85}
/* t8/t9 cards */
.ncard{position:absolute;left:0;top:0;width:270px;height:340px;border-radius:30px;background:#FFF8EE;opacity:0;
  box-shadow:0 0 0 7px #10080A,0 24px 50px rgba(0,0,0,.5);transform-origin:50% 50%}
.ncard svg{position:absolute;left:25px;top:24px;width:220px;height:200px}
.ncard .lb{position:absolute;left:0;top:236px;width:270px;text-align:center;font-weight:900;font-size:56px;color:#10080A;white-space:nowrap}
.ncard .ck{position:absolute;right:-22px;top:-22px;width:70px;height:70px;border-radius:35px;border:7px solid #10080A;background:#fff;opacity:0}
#qbub{position:absolute;left:430px;top:290px;width:220px;height:220px;border-radius:110px;background:#FFE14D;border:9px solid #10080A;opacity:0;
  text-align:center;font-weight:900;font-size:170px;line-height:200px;color:#10080A;box-shadow:0 12px 0 rgba(0,0,0,.4)}
#none{position:absolute;left:0;top:905px;width:1080px;text-align:center;opacity:0}
#none div{font-weight:900;font-size:84px;line-height:1.12;color:#fff;-webkit-text-stroke:14px #10080A;paint-order:stroke fill;white-space:nowrap}
#none div b{color:#FFE14D}
/* close */
#ctext{position:absolute;left:0;top:262px;width:1080px;text-align:center;opacity:0}
#ctext .q1{font-weight:900;font-size:150px;line-height:1.1;color:#fff;white-space:nowrap;-webkit-text-stroke:24px #10080A;paint-order:stroke fill}
#ctext .q1 small{font-size:110px}
#ctext .q2{display:inline-block;font-weight:900;font-size:170px;line-height:1.1;color:#FFE14D;white-space:nowrap;-webkit-text-stroke:26px #10080A;paint-order:stroke fill;transform-origin:50% 60%}
#cmt{position:absolute;left:0;top:0;width:150px;height:150px;border-radius:75px;background:#FFE14D;border:8px solid #10080A;opacity:0;box-shadow:0 10px 0 rgba(0,0,0,.4)}
#cmt svg{position:absolute;left:27px;top:27px;width:80px;height:80px;color:#10080A}
#flash{position:absolute;left:0;top:0;width:1080px;height:1920px;background:#fff;opacity:0;z-index:45;pointer-events:none}
#redflash{position:absolute;left:0;top:0;width:1080px;height:1920px;background:radial-gradient(ellipse at 50% 40%,rgba(255,40,60,0) 30%,rgba(255,30,50,.45) 100%);opacity:0;z-index:44;pointer-events:none}
/* grain (registry grain-overlay, made seekable: tile offset is a function of the frame) */
#grain{position:absolute;left:-512px;top:-512px;width:2104px;height:2944px;background:url(assets/grain.png) repeat;opacity:.11;mix-blend-mode:overlay;z-index:50;pointer-events:none}
#gbars{position:absolute;left:0;top:0;width:1080px;height:1920px;z-index:40;pointer-events:none}
#gbars div{position:absolute;left:60px;width:840px;opacity:0;mix-blend-mode:screen}
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
<radialGradient id="gHalo"><stop offset="0" stop-color="#ff4f7a" stop-opacity=".75"/><stop offset=".45" stop-color="#ff4f7a" stop-opacity=".28"/><stop offset="1" stop-color="#ff4f7a" stop-opacity="0"/></radialGradient>
<radialGradient id="gBody"><stop offset="0" stop-color="#ffe4ea"/><stop offset=".38" stop-color="#ff8aa6"/><stop offset=".72" stop-color="#ff4f7a" stop-opacity=".85"/><stop offset="1" stop-color="#ff4f7a" stop-opacity="0"/></radialGradient>
<radialGradient id="gCore"><stop offset="0" stop-color="#ffffff"/><stop offset=".55" stop-color="#ffd0dc"/><stop offset="1" stop-color="#ffd0dc" stop-opacity="0"/></radialGradient>
<linearGradient id="gRefl" x1="0" y1="0" x2="0" y2="1"><stop offset="0" stop-color="#ff6f92" stop-opacity=".42"/><stop offset="1" stop-color="#ff4f7a" stop-opacity="0"/></linearGradient>
<radialGradient id="gMote"><stop offset="0" stop-color="#fff" stop-opacity=".95"/><stop offset="1" stop-color="#fff" stop-opacity="0"/></radialGradient>
<radialGradient id="gMist"><stop offset="0" stop-color="#9fb2e8" stop-opacity=".22"/><stop offset="1" stop-color="#9fb2e8" stop-opacity="0"/></radialGradient>
<radialGradient id="gMistW"><stop offset="0" stop-color="#f2b25c" stop-opacity=".22"/><stop offset="1" stop-color="#f2b25c" stop-opacity="0"/></radialGradient>
<linearGradient id="gDeep" x1="0" y1="0" x2="0" y2="1"><stop offset="0" stop-color="#14306a"/><stop offset=".35" stop-color="#0a1a40"/><stop offset="1" stop-color="#02040c"/></linearGradient>
<linearGradient id="gNight" x1="0" y1="0" x2="0" y2="1"><stop offset="0" stop-color="#02030a"/><stop offset="1" stop-color="#0c1638"/></linearGradient>
<linearGradient id="gBeam" x1="0" y1="0" x2="0" y2="1"><stop offset="0" stop-color="#8fb0ff" stop-opacity=".28"/><stop offset="1" stop-color="#8fb0ff" stop-opacity="0"/></linearGradient>
<linearGradient id="gSky2" x1="0" y1="0" x2="0" y2="1"><stop offset="0" stop-color="#0b1238"/><stop offset="1" stop-color="#2a3678"/></linearGradient>
<radialGradient id="gBub" cx=".35" cy=".35"><stop offset="0" stop-color="#e8f1ff" stop-opacity=".75"/><stop offset=".5" stop-color="#9fc0ff" stop-opacity=".18"/><stop offset="1" stop-color="#9fc0ff" stop-opacity=".05"/></radialGradient>
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
  <div class="sc" id="sh-hook"><div class="kb" id="kb-hook">%%V_HOOK%%<div id="moondim"></div><svg class="ov" id="g-hook" viewBox="0 0 1080 1920"></svg></div><div class="vig"></div></div>
  <div class="sc" id="sh-moon"><div class="kb" id="kb-moon">%%V_MOON%%<svg class="ov" id="g-moon" viewBox="0 0 1080 1920"></svg></div><div class="vig"></div></div>
  <div class="sc" id="sh-mekong"><div class="kb" id="kb-mekong">%%V_MEKONG%%<svg class="ov" id="g-mekong" viewBox="0 0 1080 1920"></svg></div><div class="vig"></div></div>
  <div class="sc" id="sh-map"><div class="dbg"></div><svg class="stars" viewBox="0 0 1080 1920"></svg><svg class="ov" id="g-map" viewBox="0 0 1080 1920"></svg></div>
  <div class="sc" id="sh-dusk"><div class="kb" id="kb-dusk">%%V_DUSK%%<svg class="ov" id="g-dusk" viewBox="0 0 1080 1920"></svg></div><div class="vig"></div></div>
  <div class="sc" id="sh-orb"><div class="kb" id="kb-orb">%%V_ORB%%<svg class="ov" id="g-orb" viewBox="0 0 1080 1920"></svg></div><div class="vig"></div></div>
  <div class="sc" id="sh-count"><div class="kb" id="kb-count">%%V_COUNT%%<svg class="ov" id="g-count" viewBox="0 0 1080 1920"></svg></div><div class="vig"></div></div>
  <div class="sc" id="sh-silent"><div class="kb" id="kb-silent">%%V_SILENT%%<svg class="ov" id="g-silent" viewBox="0 0 1080 1920"></svg></div><div class="vig"></div></div>
  <div class="sc" id="sh-vanish"><div class="kb" id="kb-vanish">%%V_VANISH%%<svg class="ov" id="g-vanish" viewBox="0 0 1080 1920"></svg></div><div class="vig"></div></div>
  <div class="sc" id="sh-candles"><div class="kb" id="kb-candles">%%V_CANDLES%%<svg class="ov" id="g-candles" viewBox="0 0 1080 1920"></svg></div><div class="vig"></div></div>
  <div class="sc" id="sh-naga"><svg class="ov" id="g-naga" viewBox="0 0 1080 1920"></svg><div class="vig"></div></div>
  <div class="sc" id="sh-buddha"><div class="kb" id="kb-buddha">%%V_BUDDHA%%<svg class="ov" id="g-buddha" viewBox="0 0 1080 1920"></svg></div><div class="vig"></div></div>
  <div class="sc" id="sh-heaven"><div class="kb" id="kb-heaven">%%V_HEAVEN%%<svg class="ov" id="g-heaven" viewBox="0 0 1080 1920"></svg></div><div class="vig"></div></div>
  <div class="sc" id="sh-candle"><div class="kb" id="kb-candle">%%V_CANDLE%%<svg class="ov" id="g-candle" viewBox="0 0 1080 1920"></svg></div><div class="vig"></div></div>
  <div class="sc" id="sh-flip"><div class="dbg lit"></div><svg class="stars" viewBox="0 0 1080 1920"></svg><svg class="ov" id="g-flip" viewBox="0 0 1080 1920"></svg></div>
  <div class="sc" id="sh-gas"><div class="kb" id="kb-gas">%%V_GAS%%<svg class="ov" id="g-gas" viewBox="0 0 1080 1920"></svg></div><div class="vig"></div></div>
  <div class="sc" id="sh-tv"><div class="dbg room"></div><svg class="stars" viewBox="0 0 1080 1920"></svg><svg class="ov" id="g-tv" viewBox="0 0 1080 1920"></svg><canvas id="tvstatic" width="130" height="100"></canvas></div>
  <div class="sc" id="sh-diag"><svg class="ov" id="g-diag" viewBox="0 0 1080 1920"></svg></div>
  <div class="sc" id="sh-crowd"><svg class="ov" id="g-crowd" viewBox="0 0 1080 1920"></svg><div class="vig"></div></div>
  <div class="sc" id="sh-cards"><div class="dbg lit"></div><svg class="stars" viewBox="0 0 1080 1920"></svg></div>
  <div class="sc" id="sh-loop"><div class="kb" id="kb-loop">%%V_LOOP%%<div id="moondim2" style="position:absolute;left:0;top:0;width:1080px;height:1920px;background:radial-gradient(circle at 632px 270px,rgba(4,7,20,.62) 0px,rgba(4,7,20,.45) 260px,rgba(4,7,20,0) 520px)"></div><svg class="ov" id="g-loop" viewBox="0 0 1080 1920"></svg></div><div class="vig"></div></div>
</div>

<div id="over" data-layout-allow-overflow data-layout-allow-overlap style="position:absolute;left:0;top:0;width:1080px;height:1920px;z-index:10">
  <div id="qmark">?</div>
  <div id="hcard"><div class="icb"><svg class="ic"><use href="#ic-stethoscope"/></svg></div><div class="h1">สมมติฐาน 1</div><div class="uline" id="huline"></div><div class="h2">ก๊าซ</div></div>
  <div class="tag" id="tagA">มีคนเสนอ</div>
  <div class="hf-catalog-rgb-glitch-text" id="gwSue"><span>ขู่ฟ้อง!</span><span>ขู่ฟ้อง!</span><strong>ขู่ฟ้อง!</strong></div>
  <div class="ncard" id="cdA"><svg viewBox="0 0 220 200" id="cdAsv"></svg><div class="lb">พญานาค</div><div class="ck"></div></div>
  <div class="ncard" id="cdB"><svg viewBox="0 0 220 200" id="cdBsv"></svg><div class="lb">ก๊าซ</div><div class="ck"></div></div>
  <div class="ncard" id="cdC"><svg viewBox="0 0 220 200" id="cdCsv"></svg><div class="lb">กระสุน</div><div class="ck"></div></div>
  <div id="qbub">?</div>
  <div id="none"><div>ยังไม่มี<b>คำตอบ</b></div><div>ที่ทุกฝ่ายยอมรับ</div></div>
  <div id="ctext"><div class="q1">พญานาค <small>หรือ</small></div><div class="q2" id="q2">มีคนทำ?</div></div>
  <div id="cmt"><svg class="ic"><use href="#ic-message-circle-more"/></svg></div>
  <div class="pill" id="pill"><div class="bd" id="pillBd"><svg class="ic" id="pillIc"><use id="pillUse" href="#ic-calendar"/></svg></div>
    <span class="tx" id="pillA"></span><span class="tx" id="pillB"></span></div>
  <div id="tshade"></div>
  <div id="title"><div class="tl" id="tl1">ลูกไฟนี้</div><div class="tl" id="tl2">ใครจุด?</div></div>
  <div id="meas"></div>
</div>
</div>
<div id="redflash"></div>
<div id="flash"></div>
<div id="grain"></div>
<div id="gbars"><div id="gb0"></div><div id="gb1"></div><div id="gb2"></div></div>

<div id="caps" data-track-kind="captions">
%%CAPS%%
</div>

<audio id="vo" class="clip" data-start="0" data-duration="%%DUR%%" data-track-index="30" data-volume="1" src="assets/vo-th.mp3"></audio>
<audio id="music" class="clip" data-start="0" data-duration="%%DUR%%" data-track-index="31" data-volume="0.1" src="assets/music-jamendo-d3803fc4.mp3"></audio>
</div>

<script>
/* Motion engine from templates/brainrot-v2 (closed-form springs, everything a function of t). Shot times = assets/audio/shots-th.json,
   word anchors = words.json (both injected by build_index.py). ONE hero: the red-pink fireball (#ff4f7a, core #ffd0dc), the same
   object in every scene (hook, s5, s6, s7, s8, s11, t4, t6b tracer head, c1); it rises with a fast ease-out and dies in 2 frames on "ดับ".
   One pill morphs: 600 balls -> no sound -> no smoke -> hypothesis 1 -> 2545 -> hypothesis 2. */
(function(){
const D=%%DATA%%, DUR=D.dur, CAPT=D.capt, K=D.k, SH=D.sh;
const T={},H={}; for(const k in SH){const n=k.split('_')[0]; T[n]=SH[k].start; if(SH[k].hit!=null)H[n]=SH[k].hit;}
const NS='http://www.w3.org/2000/svg';

// ---------- spring kit ----------
const clamp=(x,a=0,b=1)=>Math.min(b,Math.max(a,x)), lerp=(a,b,u)=>a+(b-a)*u;
const eo=x=>{x=clamp(x);return 1-Math.pow(1-x,3)}, eio=x=>{x=clamp(x);return x*x*x*(x*(6*x-15)+10)}, ei=x=>{x=clamp(x);return x*x*x};
const S=(tau,w,z)=>{if(tau<=0)return 0;
  if(z<1){const wd=w*Math.sqrt(1-z*z);return 1-Math.exp(-z*w*tau)*(Math.cos(wd*tau)+z*w/wd*Math.sin(wd*tau));}
  return 1-Math.exp(-w*tau)*(1+w*tau);};
const MORPH=[15,0.84],FAST=[26,0.8],SLOW=[8,0.95],BOUNCE=[18,0.55],POP=[22,0.5],OUT=[30,1];
const hex=h=>[1,3,5].map(i=>parseInt(h.slice(i,i+2),16));
const mix=(a,b,u)=>{const x=hex(a),y=hex(b);return `rgb(${x.map((v,i)=>Math.round(lerp(v,y[i],clamp(u)))).join(',')})`;};
const $=id=>document.getElementById(id);
const el=(tag,attrs,parent)=>{const e=document.createElementNS(NS,tag);for(const k in attrs)e.setAttribute(k,attrs[k]);parent.appendChild(e);return e;};
const show=(e,o)=>{e.style.opacity=o<0.003?'0':o.toFixed(4);return o>=0.003;};
const sa=(e,o)=>{e.setAttribute('opacity',o<0.003?'0':o.toFixed(3));return o>=0.003;};
const f2=v=>v.toFixed(2);
const hash=i=>{const x=Math.sin(i*127.1+311.7)*43758.5453;return x-Math.floor(x);};
const win=(t,a,b,sp=POP)=>{if(t<a||t>=b+0.1)return 0; const i=S(t-a,sp[0],sp[1]); const o=t>b?1-clamp((t-b)/0.08):1; return Math.max(0,i)*o;};
const pinO=(t,a,b)=>(t<a||t>=b+0.1)?0:clamp((t-a)/0.06)*(t>b?1-clamp((t-b)/0.08):1);
const meas=$('meas'); const wcache={};
const tw=txt=>{if(wcache[txt])return wcache[txt]; meas.textContent=txt; const w=meas.offsetWidth;
  if(document.fonts&&document.fonts.status==='loaded'&&w>0)wcache[txt]=w; return w||txt.length*28;};
const PINK='#FF4F7A',CORE='#FFD0DC',YEL='#FFE14D',ORG='#FFA53D',RED='#FF3B4E',INK='#10080A',CREAM='#FFF8EE';
const G=id=>$('g-'+id);

// ---------- the fireball (one object, many instances) ----------
function Orb(parent){
  const g=el('g',{opacity:0,style:'mix-blend-mode:screen'},parent);
  const h3=el('circle',{r:230,fill:'url(#gHalo)',opacity:.5},g), h2=el('circle',{r:118,fill:'url(#gHalo)',opacity:.9},g);
  const body=el('circle',{r:60,fill:'url(#gBody)'},g), core=el('circle',{r:25,fill:'url(#gCore)'},g);
  const sp=[...Array(7)].map((_,i)=>el('circle',{r:2+hash(i)*3.5,fill:CORE},g));
  return {g,set(x,y,s,o,t,seed=0,sq=1){ if(!sa(g,o))return;
    const fl=1+0.07*Math.sin(t*23+seed)+0.05*Math.sin(t*37+seed*2);
    g.setAttribute('transform',`translate(${f2(x)} ${f2(y)}) scale(${(s*fl).toFixed(4)} ${(s*fl*sq).toFixed(4)})`);
    h3.setAttribute('opacity',f2(0.42+0.12*Math.sin(t*9+seed)));
    sp.forEach((c,i)=>{const a=t*(2+i*0.37)+i*2.1+seed, r=48+28*hash(i+3)+10*Math.sin(t*5+i);
      c.setAttribute('cx',f2(r*Math.cos(a))); c.setAttribute('cy',f2(r*Math.sin(a)*0.9)); c.setAttribute('opacity',f2(Math.pow(0.5+0.5*Math.sin(t*17+i*1.7+seed),3)));});
  }};
}
function Refl(parent){ // reflection streak on the water under an orb
  const g=el('g',{opacity:0,style:'mix-blend-mode:screen'},parent);
  const col=el('ellipse',{cx:0,cy:0,rx:40,ry:200,fill:'url(#gRefl)'},g);
  const bars=[...Array(6)].map((_,i)=>el('ellipse',{cx:0,cy:0,rx:30,ry:3.5,fill:'#ff8aa6'},g));
  return {set(x,wy,s,k,t){ if(!sa(g,k))return; g.setAttribute('transform',`translate(${f2(x)} ${f2(wy)}) scale(${f2(s)} 1)`);
    col.setAttribute('cy',f2(200)); col.setAttribute('rx',f2(26+5*Math.sin(t*7)));
    bars.forEach((b,i)=>{b.setAttribute('cy',f2(14+i*44+4*Math.sin(t*3+i))); b.setAttribute('cx',f2(12*Math.sin(t*4.3+i*1.9)));
      b.setAttribute('rx',f2((60-i*6)*(0.7+0.3*Math.sin(t*6+i)))); b.setAttribute('opacity',f2(0.35+0.4*(0.5+0.5*Math.sin(t*8+i*2))));});}};
}
function Ripple(parent,n=3){
  const rs=[...Array(n)].map(()=>el('ellipse',{cx:0,cy:0,rx:10,ry:2,fill:'none',stroke:CORE,'stroke-width':4,opacity:0},parent));
  return {set(x,wy,age,s=1){ rs.forEach((r,i)=>{const u=(age-i*0.22)/1.7; if(age<0||u<0||u>1){r.setAttribute('opacity','0');return;}
    const rx=(26+260*eo(u))*s; r.setAttribute('cx',f2(x)); r.setAttribute('cy',f2(wy)); r.setAttribute('rx',f2(rx)); r.setAttribute('ry',f2(rx*0.16));
    r.setAttribute('stroke-width',f2(4*s*(1-0.5*u))); r.setAttribute('opacity',f2(0.85*(1-u)));});}};
}
function Drops(parent,n=8){
  const ds=[...Array(n)].map((_,i)=>({e:el('circle',{r:4+hash(i+9)*4,fill:CORE,opacity:0},parent),vx:(hash(i+1)-0.5)*420,vy:420+hash(i+5)*520}));
  return {set(x,wy,age,s=1){ ds.forEach(d=>{const y=wy-(d.vy*age-1500*age*age)*s; if(age<0||age>0.75||y>wy){d.e.setAttribute('opacity','0');return;}
    d.e.setAttribute('cx',f2(x+d.vx*age*s)); d.e.setAttribute('cy',f2(y)); d.e.setAttribute('opacity',f2(0.9*(1-age/0.75)));});}};
}
function Motes(parent,n,col,y0=300,y1=1500,sp=40){
  const ms=[...Array(n)].map((_,i)=>({e:el('circle',{r:2+hash(i+40)*4,fill:col,opacity:0},parent),x:60+hash(i+11)*960,y:y0+hash(i+21)*(y1-y0),v:sp*(0.5+hash(i+31)),i}));
  return {set(t,o=1){ms.forEach(m=>{const y=y0+(((m.y-y0-m.v*t)%(y1-y0))+(y1-y0))%(y1-y0);
    m.e.setAttribute('cx',f2(m.x+14*Math.sin(t*0.9+m.i))); m.e.setAttribute('cy',f2(y)); m.e.setAttribute('opacity',f2(o*(0.25+0.6*Math.pow(0.5+0.5*Math.sin(t*2.6+m.i*1.3),2))));});}};
}
function Mist(parent,n,grad,y0,y1){
  const ms=[...Array(n)].map((_,i)=>({e:el('ellipse',{rx:420+hash(i+50)*260,ry:120+hash(i+60)*80,fill:`url(#${grad})`},parent),x:hash(i+70)*1080,y:y0+hash(i+80)*(y1-y0),v:(hash(i+90)-0.5)*90}));
  return {set(t){ms.forEach(m=>{m.e.setAttribute('cx',f2(((m.x+m.v*t)%1500+1500)%1500-210)); m.e.setAttribute('cy',f2(m.y+10*Math.sin(t*0.7+m.x)));});}};
}
// rise curve shared by hook and loop (frame 0 = U0 s after the ball left the water; the loop ends on the same instant)
const U0=0.9, HX=520, HW=1400;
const riseY=u=>HW-300*(1-Math.exp(-2.4*u))-60*u;

// ---------- scenes ----------
const SC=[
 {id:'sh-hook',a:0,kb:'kb-hook',in:'none',custom:1},
 {id:'sh-moon',a:T.s1,kb:'kb-moon',s0:1.0,s1:1.12,r0:0.6,r1:-0.6,org:'40% 30%',in:'zoom'},
 {id:'sh-mekong',a:T.s2,kb:'kb-mekong',s0:1.12,s1:1.02,r0:-0.4,r1:0.4,org:'60% 60%',in:'match'},
 {id:'sh-map',a:T.s3,in:'zoom'},
 {id:'sh-dusk',a:T.s4,kb:'kb-dusk',s0:1.0,s1:1.1,r0:0.5,r1:-0.5,org:'50% 70%',in:'whip'},
 {id:'sh-orb',a:T.s5,kb:'kb-orb',custom:1,in:'cut'},
 {id:'sh-count',a:T.s6,kb:'kb-count',s0:1.12,s1:1.0,r0:-0.4,r1:0.4,org:'50% 60%',in:'whip'},
 {id:'sh-silent',a:T.s7,kb:'kb-silent',s0:1.0,s1:1.1,r0:0,r1:0,org:'50% 45%',in:'match'},
 {id:'sh-vanish',a:T.s8,kb:'kb-vanish',custom:1,in:'cut'},
 {id:'sh-candles',a:T.s9,kb:'kb-candles',s0:1.0,s1:1.12,r0:0.6,r1:-0.6,org:'40% 70%',in:'zoom'},
 {id:'sh-naga',a:T.s10,in:'match'},
 {id:'sh-buddha',a:T.s12,kb:'kb-buddha',s0:1.0,s1:1.1,r0:0,r1:0,org:'50% 42%',in:'match'},
 {id:'sh-heaven',a:T.s13,kb:'kb-heaven',s0:1.0,s1:1.12,r0:-0.5,r1:0.5,org:'50% 30%',in:'match'},
 {id:'sh-candle',a:T.s14,kb:'kb-candle',s0:1.0,s1:1.1,r0:0.4,r1:-0.4,org:'55% 45%',in:'match'},
 {id:'sh-flip',a:T.t1,in:'cut'},
 {id:'sh-gas',a:T.t3,kb:'kb-gas',s0:1.0,s1:1.08,r0:0,r1:0,org:'50% 50%',in:'zoom'},
 {id:'sh-tv',a:T.t5,in:'whip'},
 {id:'sh-diag',a:T.t6,in:'zoom'},
 {id:'sh-crowd',a:T.t7,in:'whip'},
 {id:'sh-cards',a:T.t8,in:'zoom'},
 {id:'sh-loop',a:T.c1,kb:'kb-loop',custom:1,in:'match'},
];
SC.forEach((s,i)=>{s.next=SC[i+1]; s.b=s.next?s.next.a:DUR; $(s.id).style.zIndex=String(i+1); if(s.kb&&s.org)$(s.kb).style.transformOrigin=s.org;});
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
const KBF={};  // custom camera per scene
function scenes(t){
  SC.forEach(s=>{const r=sceneState(s,t), e=$(s.id);
    if(!r){e.style.opacity='0';return;}
    e.style.opacity=r.o.toFixed(4); e.style.transform=`translateX(${f2(r.tx)}px) scale(${r.sc.toFixed(4)})`;
    if(!s.kb)return;
    if(s.custom){ $(s.kb).style.transform=KBF[s.id](t); return; }
    const uu=clamp((t-s.a)/Math.max(0.3,(s.b-s.a)));
    const k=lerp(s.s0,s.s1,eio(0.1+0.9*uu));
    const rr=lerp(s.r0,s.r1,uu), dx=10*Math.sin(t*1.7+s.a), dy=8*Math.cos(t*1.3+s.a);
    $(s.kb).style.transform=`translate(${f2(dx)}px,${f2(dy)}px) rotate(${rr.toFixed(3)}deg) scale(${k.toFixed(5)})`;
  });
}
const STARS=[]; document.querySelectorAll('.stars').forEach((sv,j)=>{for(let i=0;i<40;i++){const x=(i*233+j*97)%1080, y=(i*421+j*151)%1920, r=1.5+(i%4)*0.8;
  STARS.push({e:el('circle',{cx:x,cy:y,r,fill:i%7?'#C9D4FF':'#FFD0DC',opacity:.5},sv),x,y,i,j});}});
function stars(t){STARS.forEach(s=>{s.e.setAttribute('cy',f2(((s.y-t*(14+s.i%5*8))%1920+1920)%1920)); s.e.setAttribute('opacity',f2(0.2+0.5*(0.5+0.5*Math.sin(t*3+s.i))));});}

// ---------- punches (hits) + glitch (ขู่ฟ้อง) + camera shake: registry zoom-through / rgb-glitch-text / camera-shake, adapted ----------
const PUNCH=[H.s5,H.t4,K.khu];
const GL=[K.khu], GLD=0.167;
const GOFF=[[12,-10,-16],[-10,12,-8],[14,-8,-18],[-8,8,-10],[10,-12,12]];
function fx(t){
  let p=0; PUNCH.forEach(a=>{const u=t-a; if(u>=0&&u<0.8)p+=0.07*Math.exp(-u*7)*Math.cos(u*13);});
  let gi=-1; GL.forEach(a=>{if(t>=a&&t<a+GLD)gi=Math.floor((t-a)*30);});
  const shk=(t>=K.khu&&t<T.t8)?Math.exp(-(t-K.khu)*2.2):0;
  const sx=shk*14*Math.sin(t*61)+shk*6*Math.sin(t*97), sy=shk*10*Math.cos(t*53), sr=shk*0.8*Math.sin(t*41);
  const st=$('stage');
  if(gi>=0){const o=GOFF[gi%5]; $('rgbR').setAttribute('dx',o[0]); $('rgbB').setAttribute('dx',o[1]); st.style.filter='url(#rgbx)';
    st.style.transform=`translate(${f2(o[2]+sx)}px,${f2(sy)}px) rotate(${f2(sr)}deg) scale(${(1+p).toFixed(4)})`;}
  else { st.style.filter='none'; st.style.transform=`translate(${f2(sx)}px,${f2(sy)}px) rotate(${f2(sr)}deg) scale(${(1+p).toFixed(4)})`; }
  ['gb0','gb1','gb2'].forEach((id,i)=>{const b=$(id); if(gi<0){b.style.opacity='0';return;}
    const y=[(300+gi*410)%1500,(820+gi*290)%1500,(560+gi*530)%1500][i]+120, h=[26,60,14][i];
    b.style.top=y+'px'; b.style.height=h+'px'; b.style.background=['#22d3ee','#ef4444','#FFFFFF'][i]; b.style.opacity=['.55','.45','.6'][i];
    b.style.transform=`translateX(${(i%2?-1:1)*(20+gi*9)}px)`;});
  // t1 "lights on" flash: 2 frames white, gone by 0.2 s
  const fu=t-T.t1; show($('flash'),fu<0||fu>0.2?0:(fu<0.067?1:1-eo((fu-0.067)/0.133)));
  show($('redflash'),(t>=K.khu&&t<T.t8)?0.9*Math.exp(-(t-K.khu)*4):0);
  // grain: tile offset steps every 2 frames
  const fr=Math.floor(t*15); $('grain').style.transform=`translate(${(fr*137)%512}px,${(fr*263)%512}px)`;
}

// ---------- hook title: complete at frame 0, breathes 1.0<->1.04; "ลูกไฟนี้" leaves on h2, "ใครจุด?" punches, back for the loop ----------
const TL=[['tl1',250,190],['tl2',462,212]];
TL.forEach(([id,y,s])=>{$(id).style.top=y+'px'; $(id).style.fontSize=s+'px';});
const TBACK=DUR-0.3;
function title(t){
  const br=1+0.04*(0.5-0.5*Math.cos(t*2*Math.PI/0.9));
  let o1,o2,s1=1,s2=1,y1=0;
  if(t<TBACK){
    const out1=t>=T.h2?eo((t-T.h2)/0.16):0; o1=1-out1; y1=-60*out1;
    const pu=t>=T.h2?S(t-T.h2,BOUNCE[0],BOUNCE[1]):0, pk=t>=K.khon?0.06*Math.exp(-(t-K.khon)*6)*Math.sin((t-K.khon)*20):0;
    s2=1+0.16*pu+pk; const out2=eo((t-(T.s1-0.04))/0.12); o2=1-out2; s2*=1+0.3*out2; o1*=1-out2;
  } else { const a=S(t-TBACK,26,0.8); o1=o2=clamp(a*1.4); s1=s2=1+0.12*(1-a); }
  show($('title'),Math.max(o1,o2)); $('tl1').style.opacity=f2(o1); $('tl2').style.opacity=f2(o2);
  const sh=t<TBACK?Math.max(o1,o2):Math.max(clamp((t-T.c1)/0.3)*(t<DUR?1:0),o1); show($('tshade'),t<T.c1?Math.max(o1,o2):sh);
  const live=t<TBACK?1:0, b=t<TBACK?br:1;
  $('tl1').style.transform=`translateY(${f2(y1+live*3*Math.sin(t*3))}px) scale(${(b*s1).toFixed(4)})`;
  $('tl2').style.transform=`translateY(${f2(live*3*Math.sin(t*3+1))}px) rotate(${f2(-1.2*live*Math.sin(t*2.4))}deg) scale(${(b*s2).toFixed(4)})`;
}

// ---------- hook (h1/h2) + loop (c1/c2): same river, same ball ----------
function riverRig(id){const g=G(id); const refl=Refl(g), rip=Ripple(g,3), drp=Drops(g,9), sub=el('ellipse',{rx:170,ry:46,fill:'url(#gHalo)',opacity:0,style:'mix-blend-mode:screen'},g), orb=Orb(g);
  const mist=Mist(g,3,'gMist',1250,1650); return {refl,rip,drp,sub,orb,mist};}
const RH=riverRig('hook'), RL=riverRig('loop');
function riverBall(R,u,t,pre){ // u = s since the ball left the water (negative = still under, glowing)
  if(u<0){ const k=clamp(pre); sa(R.sub,0.9*k); R.sub.setAttribute('cx',f2(HX+6*Math.sin(t*3))); R.sub.setAttribute('cy',f2(HW+34));
    R.sub.setAttribute('rx',f2(150+20*Math.sin(t*6))); R.orb.set(HX,HW+70,0.6,0.75*k,t,1,0.45); R.refl.set(HX,HW,0.9,0,t); R.rip.set(HX,HW,-1); R.drp.set(HX,HW,-1); return; }
  const y=riseY(u); sa(R.sub,0.9*Math.exp(-u*3));
  R.orb.set(HX+4*Math.sin(t*1.3),y,0.9,1,t,1); R.refl.set(HX,HW+10,1,clamp(1-(HW-y)/900)*0.95,t); R.rip.set(HX,HW+6,u); R.drp.set(HX,HW,u);
}
KBF['sh-hook']=t=>{ // still push to h2, then zoom-through into the ball
  const z=t>=T.h2?S(t-T.h2,12,0.85):0, k=lerp(1.0,1.04,clamp(t/T.h2))*(1+0.62*z);
  return `scale(${k.toFixed(5)})`;};
$('kb-hook').style.transformOrigin=`${HX}px ${riseY(U0+0.6)}px`;
KBF['sh-loop']=t=>{const uu=clamp((t-T.c1)/(DUR-T.c1)); return `scale(${lerp(1.05,1.0,uu).toFixed(5)})`;};
$('kb-loop').style.transformOrigin=`${HX}px ${riseY(U0)}px`;
function hookF(t){ if(t<T.s1+0.2){ riverBall(RH,t+U0,t,1); RH.mist.set(t); } }
function loopF(t){ if(t<T.c1-0.1)return; const E=DUR-U0; riverBall(RL,t-E,t,(t-T.c1)/1.2); RL.mist.set(t); }

// ---------- s1 moon / s2 river / s4 dusk / s9 candles / s12-14 footage: mist + motes layer ----------
const LAY={moon:[Mist(G('moon'),3,'gMist',1100,1700),Motes(G('moon'),14,'#C9D4FF',300,1500,26)],
  mekong:[Mist(G('mekong'),3,'gMist',1150,1600),Motes(G('mekong'),12,'#C9D4FF',900,1500,18)],
  dusk:[Motes(G('dusk'),26,'#E4E9FF',150,1300,6)],
  candles:[Mist(G('candles'),2,'gMistW',900,1300),Motes(G('candles'),18,'#FFD9A0',400,1500,34)],
  buddha:[Mist(G('buddha'),3,'gMistW',1200,1700),Motes(G('buddha'),24,'#FFD27A',200,1600,40)],
  heaven:[Mist(G('heaven'),2,'gMistW',800,1400),Motes(G('heaven'),22,'#FFE3A8',200,1700,52)],
  candle:[Mist(G('candle'),2,'gMistW',300,800),Motes(G('candle'),18,'#FFD27A',150,1200,46)]};
function layers(t){for(const k in LAY){const s=SC.find(x=>x.id==='sh-'+k); if(t<s.a-0.1||t>s.b+0.2)continue; LAY[k].forEach(l=>l.set(t));}}

// ---------- s3 map: Mekong as a glowing line, Nong Khai blinking (no logos) ----------
const MAPG=el('g',{},G('map'));
const RIVD='M250 160 C330 300 220 420 300 540 C370 640 330 720 420 790 C520 860 640 800 760 830 C880 860 980 800 1140 830';
const rv=[[46,'#3d7bff',.18],[18,'#6fa8ff',.5],[6,'#e2ecff',.95]].map(([w,c,o])=>el('path',{d:RIVD,fill:'none',stroke:c,'stroke-width':w,'stroke-linecap':'round',opacity:o},MAPG));
const RLEN=1700; rv.forEach(p=>{p.setAttribute('stroke-dasharray',RLEN); p.setAttribute('stroke-dashoffset',RLEN);});
const mtx=(txt,x,y,sz,col)=>{const e=el('text',{x,y,'text-anchor':'middle','font-family':'Kanit','font-weight':900,'font-size':sz,fill:col,stroke:INK,'stroke-width':14,'paint-order':'stroke',opacity:0},MAPG); e.textContent=txt; return e;};
const mLao=mtx('ลาว',740,560,120,'#C9D4FF'), mThai=mtx('ไทย',300,1050,120,'#C9D4FF');
const NK={x:600,y:866};
const nkRings=[0,1,2].map(()=>el('circle',{cx:NK.x,cy:NK.y,r:20,fill:'none',stroke:PINK,'stroke-width':6,opacity:0},MAPG));
const nkOrb=Orb(MAPG); const mNK=mtx('หนองคาย',NK.x,NK.y+118,84,'#FFFFFF');
function mapF(t){ const a=T.s3, b=T.s4; if(t<a-0.05||t>b+0.2)return;
  const u=t-a, dr=eo(u/0.55); rv.forEach(p=>p.setAttribute('stroke-dashoffset',f2(RLEN*(1-dr))));
  sa(mLao,clamp((u-0.15)/0.15)); sa(mThai,clamp((u-0.2)/0.15));
  const blink=0.6+0.4*(0.5+0.5*Math.cos(u*2*Math.PI/0.4)); const pin=u>=0.05?S(u-0.05,POP[0],POP[1]):0;
  nkOrb.set(NK.x,NK.y,0.42*Math.max(0,pin)*blink,clamp(pin),t,3);
  nkRings.forEach((r,i)=>{const v=((u-0.1)/0.6-i*0.33); const ph=v-Math.floor(v); if(u<0.1){sa(r,0);return;} r.setAttribute('r',f2(20+90*ph)); sa(r,0.8*(1-ph));});
  const nl=u>=0.12?S(u-0.12,POP[0],POP[1]):0; sa(mNK,clamp(nl*1.5)); mNK.setAttribute('transform',`translate(${NK.x} ${NK.y+90}) scale(${f2(Math.max(0.01,nl))}) translate(${-NK.x} ${-NK.y-90})`);
  const cz=1+0.28*eio(u/1.1); MAPG.setAttribute('transform',`translate(${NK.x} ${NK.y}) scale(${cz.toFixed(4)}) translate(${-NK.x} ${f2(-NK.y-40*eio(u/1.1))})`);
}

// ---------- s5: the ball glows under the water, breaks the surface on "ผุด" (hit) ----------
const R5=riverRig('orb');
KBF['sh-orb']=t=>{const u=clamp((t-T.s5)/(T.s6-T.s5)); const pk=t>=H.s5?0.05*S(t-H.s5,14,0.6):0; return `scale(${(1.0+0.05*u+pk).toFixed(5)})`;};
$('kb-orb').style.transformOrigin=`${HX}px 1250px`;
function orbF(t){ if(t<T.s5-0.05||t>T.s6+0.2)return; const u=t-H.s5; riverBall(R5,u<0?u:u*1.35,t,clamp((t-T.s5)/(H.s5-T.s5))*1.0); R5.mist.set(t); }

// ---------- s6: many balls along the river + "ปี 2564 นับได้กว่า 600 ลูก" ----------
const CG=G('count'); const CNT=[...Array(11)].map((_,i)=>{const far=i%3===0; const x=far?720+hash(i+100)*300:130+hash(i+110)*760, wy=far?1110:1330+hash(i+120)*230;
  return {x,wy,s:far?0.22:0.32+0.22*(wy-1330)/230,e:T.s6-0.9+i*0.2+hash(i+130)*0.15,refl:Refl(CG),rip:Ripple(CG,2),orb:Orb(CG),i};});
function countF(t){ if(t<T.s6-0.05||t>T.s7+0.2)return;
  CNT.forEach(c=>{const u=t-c.e; if(u<0){c.orb.set(0,0,0,0,t);c.refl.set(0,0,1,0,t);c.rip.set(0,0,-1);return;}
    const y=c.wy-(380*(1-Math.exp(-2.6*u))+40*u)*c.s/0.4; c.orb.set(c.x,y,c.s,clamp(u/0.08),t,c.i); c.refl.set(c.x,c.wy,c.s*1.4,0.7*clamp(1-(c.wy-y)/700),t); c.rip.set(c.x,c.wy,u,c.s*1.6);});
}
// ---------- s7: one ball hangs in silence ----------
const R7={orb:Orb(G('silent')),refl:Refl(G('silent')),mist:Mist(G('silent'),3,'gMist',1200,1700)};
function silentF(t){ if(t<T.s7-0.05||t>T.s8+0.2)return; const u=t-T.s7;
  const y=820+16*Math.sin(u*1.6), x=540+10*Math.sin(u*1.1); R7.orb.set(x,y,0.95,1,t,7); R7.refl.set(x,1420,1.1,0.55,t); R7.mist.set(t);}
// ---------- s8: shoots up (camera tilts with it) and dies in 2 frames on "ดับ" (hit) ----------
const R8={orb:Orb(G('vanish')),refl:Refl(G('vanish')),rip:Ripple(G('vanish'),3),pop:el('circle',{r:60,fill:'none',stroke:CORE,'stroke-width':5,opacity:0},G('vanish'))};
const V0=T.s8, VH=H.s8;
const vy=t=>{const u=clamp((t-V0)/(VH-V0)); return lerp(1420,470,1-Math.pow(1-u,2.4));};
KBF['sh-vanish']=t=>{const u=clamp((t-V0)/(VH-V0+0.5)); return `translateY(${f2(250*eio(u))}px) scale(1.25)`;};
function vanishF(t){ if(t<V0-0.05||t>T.s9+0.2)return; const u=t-VH;
  const alive=t<VH+0.067, o=t<VH?1:(alive?0.6:0), s=t<VH?0.85:1.15;
  R8.orb.set(540,vy(Math.min(t,VH)),s,o,t,8); R8.refl.set(540,1420,1,t<VH?clamp(1-(1420-vy(t))/900)*0.9:0,t); R8.rip.set(540,1426,t-V0);
  // nothing lingers: one thin ring for 4 frames, no smoke, no trail
  if(u>=0&&u<0.14){R8.pop.setAttribute('cx',540); R8.pop.setAttribute('cy',f2(vy(VH))); R8.pop.setAttribute('r',f2(60+260*eo(u/0.14))); sa(R8.pop,0.7*(1-u/0.14));} else sa(R8.pop,0);
}

// ---------- s10/s11: the naga's shadow under dark water (procedural silhouette), lifts its head and the ball leaves the surface ----------
const NG=G('naga');
const nSky=el('rect',{x:0,y:-200,width:1080,height:600,fill:'url(#gNight)'},NG);
const nWater=el('rect',{x:0,y:400,width:1080,height:1700,fill:'url(#gDeep)'},NG);
const nBeams=[...Array(6)].map((_,i)=>el('polygon',{fill:'url(#gBeam)',opacity:.6},NG));
const nSpecks=Motes(NG,40,'#9fb8ff',400,1900,-14);
const NB=el('g',{},NG);
const nGlow=el('path',{fill:'none',stroke:'#6f8fe0','stroke-width':26,'stroke-opacity':.12,'stroke-linejoin':'round'},NB);
const nBody=el('path',{fill:'#020309',stroke:'#6f8fe0','stroke-width':4,'stroke-opacity':.45,opacity:.94},NB);
const nScales=[...Array(30)].map(()=>el('ellipse',{rx:10,ry:5,fill:'#a8c0ff',opacity:0},NB));
const nHead=el('g',{},NB);
el('path',{d:'M-30 -50 L-6 -118 L14 -58 L40 -132 L58 -56 L84 -112 L96 -48 Z',fill:'#020309',stroke:'#4d6fc4','stroke-width':3,'stroke-opacity':.35},nHead);
el('path',{d:'M-110 -44 C-40 -60 40 -66 120 -46 C150 -36 172 -20 178 -6 C182 4 176 12 168 16 C120 46 30 62 -110 44 Z',fill:'#020309',stroke:'#4d6fc4','stroke-width':3,'stroke-opacity':.35},nHead);
el('path',{d:'M150 20 C170 40 150 70 120 80',fill:'none',stroke:'#4d6fc4','stroke-width':4,'stroke-opacity':.4,'stroke-linecap':'round'},nHead);
const nEye=el('ellipse',{cx:108,cy:-10,rx:9,ry:5,fill:'#f2c46a',opacity:.55},nHead);
const nMurk=el('rect',{x:0,y:400,width:1080,height:1600,fill:'#0d2152',opacity:.22},NG);
const nSurf=el('path',{fill:'none',stroke:'#b7c9ff','stroke-width':4,opacity:.55},NG);
const nGlints=[...Array(10)].map((_,i)=>el('ellipse',{rx:30,ry:3,fill:'#dbe6ff',opacity:0},NG));
const nRip=Ripple(NG,3), nOrb=Orb(NG), nSub=el('ellipse',{rx:140,ry:40,fill:'url(#gHalo)',opacity:0,style:'mix-blend-mode:screen'},NG);
function spine(hx,hy,a0,A,kk,w,t,L,n){const pts=[[hx,hy]]; let x=hx,y=hy; const ds=L/n;
  for(let i=1;i<=n;i++){const s=i*ds, th=a0+A*Math.sin(kk*s-w*t)-A*Math.sin(-w*t)*Math.exp(-s/120); x+=Math.cos(th)*ds; y+=Math.sin(th)*ds; pts.push([x,y]);} return pts;}
function nagaF(t){ if(t<T.s10-0.05||t>T.s12+0.2)return;
  const s11=t>=T.s11, u=t-(s11?T.s11:T.s10);
  const surf=s11?780:420;
  nSky.setAttribute('height',f2(surf+200)); nWater.setAttribute('y',f2(surf)); nMurk.setAttribute('y',f2(surf));
  let d=`M0 ${surf}`; for(let x=0;x<=1080;x+=40)d+=` L${x} ${f2(surf+5*Math.sin(x*0.02+t*3)+3*Math.sin(x*0.051-t*2))}`; nSurf.setAttribute('d',d);
  nGlints.forEach((g,i)=>{g.setAttribute('cx',f2((hash(i+300)*1080+t*30*(i%2?1:-1)+1080)%1080)); g.setAttribute('cy',f2(surf+4+i%3*3)); sa(g,0.6*Math.pow(0.5+0.5*Math.sin(t*5+i*2),3));});
  nBeams.forEach((b,i)=>{const x0=80+i*180+30*Math.sin(t*0.8+i), sk=140+40*Math.sin(t*0.5+i); b.setAttribute('points',`${f2(x0)},${surf} ${f2(x0+70)},${surf} ${f2(x0+sk+160)},1920 ${f2(x0+sk)},1920`); sa(b,0.35+0.25*Math.sin(t*1.7+i*2));});
  nSpecks.set(t,0.7);
  let pts, hx, hy;
  if(!s11){ hx=980-480*eo(u/1.8)-40*u; hy=1060+40*Math.sin(u*2.2); pts=spine(hx,hy,0.05,0.55,0.0045,3.0,t,2100,70); }
  else { const r=eo(u/0.7); hx=560-20*r; hy=lerp(1330,surf+150,r); pts=spine(hx,hy,Math.PI/2+0.1,0.4,0.006,3.4,t,1700,64); }
  const n=pts.length-1, L=[],R=[];
  for(let i=0;i<=n;i++){const p=pts[i], q=pts[Math.min(n,i+1)], o=pts[Math.max(0,i-1)]; let dx=q[0]-o[0], dy=q[1]-o[1]; const m=Math.hypot(dx,dy)||1; dx/=m; dy/=m;
    const uu=i/n, wd=uu<0.06?52+420*uu:(95*Math.pow(1-uu,0.8)+4)*(1+0.06*Math.sin(i*0.9)); L.push([p[0]-dy*wd,p[1]+dx*wd]); R.push([p[0]+dy*wd,p[1]-dx*wd]);}
  const bd='M'+L.map(p=>f2(p[0])+' '+f2(p[1])).join(' L')+' L'+R.reverse().map(p=>f2(p[0])+' '+f2(p[1])).join(' L')+' Z'; nBody.setAttribute('d',bd); nGlow.setAttribute('d',bd);
  nScales.forEach((sc,i)=>{const k=3+i*2; if(k>=n){sa(sc,0);return;} const p=pts[k]; sc.setAttribute('cx',f2(p[0])); sc.setAttribute('cy',f2(p[1]-10*Math.sin(i))); sa(sc,0.08+0.7*Math.pow(Math.max(0,Math.sin(t*4-i*0.55)),8));});
  const hd=Math.atan2(pts[0][1]-pts[2][1],pts[0][0]-pts[2][0])*180/Math.PI;
  nHead.setAttribute('transform',`translate(${f2(pts[0][0])} ${f2(pts[0][1])}) rotate(${f2(hd)}) scale(1.35 ${Math.cos(hd*Math.PI/180)<0?-1.35:1.35})`); sa(nEye,0.35+0.3*Math.sin(t*2));
  NB.setAttribute('transform',`translate(0 ${f2(6*Math.sin(t*1.4))})`);
  // s11: the ball rises from the surface above the head ("จุดลูกไฟ")
  if(s11){ const e=K.chut+0.12, uu=t-e; sa(nSub,uu<0?0.8*clamp((t-T.s11)/0.3):0.8*Math.exp(-uu*3)); nSub.setAttribute('cx',540); nSub.setAttribute('cy',f2(surf+30));
    if(uu>=0){nOrb.set(540+3*Math.sin(t*2),surf-330*(1-Math.exp(-3*uu))-40*uu,0.8,1,t,11); nRip.set(540,surf,uu,1);} else {nOrb.set(0,0,0,0,t); nRip.set(0,0,-1);} }
  else { sa(nSub,0); nOrb.set(0,0,0,0,t); nRip.set(0,0,-1); }
  NG.setAttribute('transform',`translate(540 960) scale(${f2(1+0.04*u)}) translate(-540 -960)`);
}

// ---------- the pill (one element morphing) ----------
const PST=[ // [t, text, colour, icon, centre x, centre y, scale]
  [T.s6+0.12,'ปี 2564 นับได้กว่า 600 ลูก',CORE,'calendar',540,320,1.0],
  [K.siang,'ไม่มีเสียง','#C9D4FF','volume-x',540,430,1.5],
  [K.khwan,'ไม่มีควัน','#C9D4FF','cloud-off',540,430,1.5],
  [T.s8,null],
  [T.t3,'สมมติฐาน 1: ก๊าซ',YEL,'circle-help',540,300,1.1],
  [T.t5,'พ.ศ. 2545',CORE,'calendar',540,300,1.35],
  [T.t6,'สมมติฐาน 2: กระสุน',ORG,'circle-help',540,300,1.1],
  [T.t7,null],
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
// "มีคนเสนอ" tag: on the t2 card, then under the hypothesis pill (t3-t4, t6-t6b)
function tagF(t){const e=$('tagA');
  let v=0,x=0,y=0,r=0;
  if(t>=T.t2&&t<T.t3){v=win(t,T.t2+0.25,T.t3,BOUNCE); x=700; y=372; r=6;}
  else if(t>=T.t3&&t<T.t5){v=win(t,T.t3+0.1,T.t5,POP); x=540; y=390; r=-3;}
  else if(t>=T.t6&&t<T.t7){v=win(t,T.t6+0.1,T.t7,POP); x=540; y=390; r=-3;}
  if(!show(e,clamp(v*2)))return; const w=e.offsetWidth||220;
  e.style.transform=`translate(${f2(x-w/2)}px,${f2(y-32)}px) rotate(${f2(r+1.5*Math.sin(t*3))}deg) scale(${f2(Math.max(0.001,v))})`;}

// ---------- t1: "?" after the lights-on flash ; t2: hypothesis card ----------
const FLG=G('flip'); const FR=[...Array(10)].map((_,i)=>el('polygon',{points:'0,0 0,0 0,0',fill:'#c9d4ff',opacity:.07},FLG));
function flipF(t){ if(t<T.t1-0.05||t>T.t3+0.2){show($('qmark'),0);show($('hcard'),0);return;}
  FR.forEach((p,i)=>{const a=(i/10)*Math.PI*2+t*0.25, b=a+0.16; p.setAttribute('points',`540,700 ${f2(540+1600*Math.cos(a))},${f2(700+1600*Math.sin(a))} ${f2(540+1600*Math.cos(b))},${f2(700+1600*Math.sin(b))}`);});
  const q=$('qmark'), v=win(t,T.t1+0.04,T.t2,BOUNCE);
  if(show(q,clamp(v*2))) q.style.transform=`scale(${f2(Math.max(0.001,0.4+0.6*v))}) rotate(${f2(-8*(1-clamp(v))+4*Math.sin(t*3.2))}deg) translateY(${f2(10*Math.sin(t*4))}px)`;
  const c=$('hcard'), vc=win(t,T.t2,T.t3,BOUNCE);
  if(show(c,clamp(vc*1.6))){ c.style.transform=`translateY(${f2(80*(1-clamp(vc))+8*Math.sin(t*1.8))}px) rotate(${f2(-2*(1-clamp(vc))+0.8*Math.sin(t*1.2))}deg) scale(${f2(Math.max(0.001,0.8+0.2*vc))})`;
    $('huline').style.transform=`scaleX(${f2(clamp(S(t-T.t2-0.15,12,0.9)))})`; }
}

// ---------- t3/t4: gas bubbles rise from the mud (MG on the dark river plate) -> one pops at the surface and catches fire ("ติดไฟ" hit) ----------
const GG=G('gas');
const gSky=el('rect',{x:0,y:-400,width:1080,height:400,fill:'url(#gNight)'},GG);
const gSurf=el('path',{fill:'none',stroke:'#b7c9ff','stroke-width':4,opacity:.6},GG);
const gMud=el('path',{fill:'#0d0a08',opacity:.95},GG);
const VENT=[260,540,800];
const BUB=[...Array(34)].map((_,i)=>({e:el('circle',{r:1,fill:'url(#gBub)',stroke:'#cfe0ff','stroke-width':3,'stroke-opacity':.65,opacity:0},GG),
  v:VENT[i%3]+(hash(i+200)-0.5)*110,r:12+hash(i+210)*30,sp:260+hash(i+220)*260,ph:hash(i+230)*3,per:1.3+hash(i+240)*0.9,i}));
const hero={e:el('circle',{r:50,fill:'url(#gBub)',stroke:'#e2ecff','stroke-width':6,opacity:0},GG)};
const gRip=Ripple(GG,3), gOrb=Orb(GG), gRefl=Refl(GG), gFlash=el('circle',{r:80,fill:'url(#gCore)',opacity:0},GG);
const gMotes=Motes(GG,24,'#7f98d0',300,1900,-20);
function gasF(t){ if(t<T.t3-0.05||t>T.t5+0.2)return;
  const t4=t>=T.t4, surf=t4?760:-60, mudY=t4?1640:1480;
  gSky.setAttribute('y',f2(surf-1000)); gSky.setAttribute('height',1000);
  let d=`M0 ${surf}`; for(let x=0;x<=1080;x+=40)d+=` L${x} ${f2(surf+5*Math.sin(x*0.02+t*3))}`; gSurf.setAttribute('d',d); sa(gSurf,t4?0.6:0);
  let m=`M0 1920 L0 ${mudY}`; for(let x=0;x<=1080;x+=60)m+=` L${x} ${f2(mudY+30*Math.sin(x*0.013+1)+18*Math.sin(x*0.041))}`; gMud.setAttribute('d',m+' L1080 1920 Z');
  gMotes.set(t,0.6);
  BUB.forEach(b=>{const age=((t+b.ph)%b.per)/b.per*(b.per), y=mudY-10-b.sp*age, wob=10*Math.sin(age*7+b.i);
    if(y<surf+b.r){sa(b.e,0);return;} b.e.setAttribute('cx',f2(b.v+wob)); b.e.setAttribute('cy',f2(y)); b.e.setAttribute('r',f2(b.r*(0.6+0.4*clamp(age*3)))); sa(b.e,clamp(age*6)*0.9);});
  if(!t4){sa(hero.e,0); gOrb.set(0,0,0,0,t); gRefl.set(0,0,1,0,t); gRip.set(0,0,-1); sa(gFlash,0); return;}
  const hit=H.t4, u=clamp((t-T.t4)/(hit-T.t4));
  if(t<hit){ sa(hero.e,1); hero.e.setAttribute('cx',f2(540+12*Math.sin(t*6))); hero.e.setAttribute('cy',f2(lerp(1560,surf+30,eio(u)))); hero.e.setAttribute('r',f2(44+14*u)); }
  else sa(hero.e,0);
  const a=t-hit; gRip.set(540,surf,a,1.1);
  if(a>=0){ const ig=S(a,16,0.6); gOrb.set(540,surf-20-300*(1-Math.exp(-2.2*a)),0.85*Math.max(0.001,ig),clamp(a/0.05),t,4); gRefl.set(540,surf+8,1,0.7*clamp(a/0.2),t);
    gFlash.setAttribute('cx',540); gFlash.setAttribute('cy',f2(surf)); gFlash.setAttribute('r',f2(80+300*eo(a/0.25))); sa(gFlash,0.9*(1-clamp(a/0.25))); }
  else { gOrb.set(0,0,0,0,t); gRefl.set(0,0,1,0,t); sa(gFlash,0); }
}

// ---------- t5: old TV, empty frame, static only (no logo, no programme image) ----------
const TVG=el('g',{},G('tv'));
el('line',{x1:540,y1:560,x2:410,y2:400,stroke:'#c9d4ff','stroke-width':8,'stroke-linecap':'round'},TVG);
el('line',{x1:540,y1:560,x2:690,y2:420,stroke:'#c9d4ff','stroke-width':8,'stroke-linecap':'round'},TVG);
el('circle',{cx:410,cy:400,r:12,fill:'#c9d4ff'},TVG); el('circle',{cx:690,cy:420,r:12,fill:'#c9d4ff'},TVG);
el('rect',{x:170,y:560,width:740,height:560,rx:56,fill:'#6b4a33',stroke:INK,'stroke-width':10},TVG);
el('rect',{x:220,y:610,width:540,height:440,rx:48,fill:'#1a1d24',stroke:INK,'stroke-width':8},TVG);
el('circle',{cx:835,cy:690,r:32,fill:'#d9c7a5',stroke:INK,'stroke-width':7},TVG); el('circle',{cx:835,cy:790,r:32,fill:'#d9c7a5',stroke:INK,'stroke-width':7},TVG);
[0,1,2,3,4].forEach(i=>el('line',{x1:808,y1:880+i*30,x2:862,y2:880+i*30,stroke:INK,'stroke-width':6,'stroke-linecap':'round'},TVG));
el('rect',{x:250,y:1120,width:60,height:40,rx:8,fill:'#3d2a1d',stroke:INK,'stroke-width':6},TVG); el('rect',{x:770,y:1120,width:60,height:40,rx:8,fill:'#3d2a1d',stroke:INK,'stroke-width':6},TVG);
const roll=el('rect',{x:230,y:620,width:520,height:60,fill:'#ffffff',opacity:.12},TVG);
const cv=$('tvstatic'), cx2=cv.getContext('2d'), img=cx2.createImageData(130,100);
function tvF(t){ if(t<T.t5-0.05||t>T.t6+0.2){show(cv,0);return;}
  const u=t-T.t5, v=S(u,BOUNCE[0],BOUNCE[1]), rot=1.4*Math.sin(t*2.1), dy=8*Math.sin(t*2.6);
  const tr=`translate(540 ${f2(840+dy)}) rotate(${f2(rot)}) scale(${f2(Math.max(0.001,0.85+0.15*v))}) translate(-540 -840)`; TVG.setAttribute('transform',tr);
  const fr=Math.floor(t*30); let sd=fr*9301+49297;
  for(let i=0;i<130*100;i++){sd=(sd*1103515245+12345)&0x7fffffff; const g=(sd>>16)&255, b=g*0.85+30; img.data[i*4]=g*0.9; img.data[i*4+1]=g*0.92; img.data[i*4+2]=Math.min(255,b); img.data[i*4+3]=255;}
  cx2.putImageData(img,0,0); show(cv,1);
  const k=Math.max(0.001,0.85+0.15*v);
  cv.style.transform=`translate(540px,${f2(840+dy)}px) rotate(${f2(rot)}deg) scale(${f2(k)}) translate(-540px,-840px) translate(230px,620px)`; cv.style.transformOrigin='0 0';
  roll.setAttribute('y',f2(620+((u*260)%380)));
}
cv.style.width='520px'; cv.style.height='420px';

// ---------- t6/t6b: two banks (ไทย | ลาว), tracer rounds from the Lao bank up into the sky ("ขึ้นฟ้า" hit) ----------
const DG=G('diag');
el('rect',{x:0,y:0,width:1080,height:1920,fill:'url(#gSky2)'},DG);
const dStars=Motes(DG,30,'#C9D4FF',120,760,4);
el('path',{d:'M-20 800 C200 780 420 792 600 784 C800 776 960 790 1100 782 L1100 850 L-20 850 Z',fill:'#060916'},DG);   // Lao bank (far)
el('rect',{x:-20,y:846,width:1120,height:190,fill:'#1b3170'},DG);                                                    // the Mekong
const dWave=[...Array(7)].map((_,i)=>el('line',{x1:0,y1:0,x2:0,y2:0,stroke:'#8fa8ea','stroke-width':3,opacity:.5},DG));
el('path',{d:'M-20 1030 C240 1010 560 1040 800 1020 C930 1010 1020 1022 1100 1016 L1100 1940 L-20 1940 Z',fill:'#04060f'},DG);    // Thai bank (near)
const dtx=(txt,x,y,sz)=>{const e=el('text',{x,y,'text-anchor':'middle','font-family':'Kanit','font-weight':900,'font-size':sz,fill:'#fff',stroke:INK,'stroke-width':16,'paint-order':'stroke'},DG); e.textContent=txt; return e;};
const dLao=dtx('ลาว',760,750,100), dThai=dtx('ไทย',300,1100,100);
const LAOP=[[690,790],[760,786],[830,790]];
const dDots=LAOP.map(p=>el('circle',{cx:p[0],cy:p[1],r:6,fill:'#ffb3c4'},DG));
const TRC=[{o:0,peak:[470,470],end:[260,640],t0:T.t6b,t1:H.t6b},{o:1,peak:[560,560],end:[380,720],t0:T.t6b+0.3,t1:H.t6b+0.32},{o:2,peak:[640,520],end:[470,700],t0:T.t6b+0.55,t1:H.t6b+0.55}]
  .map(c=>({...c,trailG:el('path',{fill:'none',stroke:'#ff4f7a','stroke-width':16,'stroke-linecap':'round',opacity:0,style:'mix-blend-mode:screen'},DG),
   trail:el('path',{fill:'none',stroke:'#ffd0dc','stroke-width':5,'stroke-linecap':'round',opacity:0},DG),orb:Orb(DG)}));
const trP=(c,u)=>{const p0=LAOP[c.o], p1=c.peak, p2=c.end; if(u<=1){const s=1-Math.pow(1-u,1.6); return [lerp(p0[0],p1[0],s), p0[1]+(p1[1]-p0[1])*(1-Math.pow(1-s,2))];}
  const v=u-1; return [lerp(p1[0],p2[0],v), p1[1]+(p2[1]-p1[1])*v*v];};
function diagF(t){ if(t<T.t6-0.05||t>T.t7+0.2)return;
  dStars.set(t,0.8); dWave.forEach((l,i)=>{const y=870+i*24, x=((t*50*(i%2?1:-1)+i*170)%1080+1080)%1080; l.setAttribute('x1',f2(x)); l.setAttribute('x2',f2(x+50)); l.setAttribute('y1',y); l.setAttribute('y2',y);});
  dDots.forEach((d,i)=>sa(d,0.5+0.5*Math.sin(t*6+i)));
  TRC.forEach(c=>{const u=(t-c.t0)/(c.t1-c.t0); if(u<0||u>1.8){c.orb.set(0,0,0,0,t);sa(c.trail,0);sa(c.trailG,0);return;}
    const h=trP(c,u), fade=u>1.3?1-(u-1.3)/0.5:1; c.orb.set(h[0],h[1],0.3,fade,t,20+c.o);
    let d=''; for(let k=0;k<=24;k++){const uu=Math.max(0,u-0.55*(1-k/24)); const p=trP(c,uu); d+=(k?' L':'M')+f2(p[0])+' '+f2(p[1]);}
    c.trail.setAttribute('d',d); c.trailG.setAttribute('d',d); sa(c.trail,0.85*fade); sa(c.trailG,0.35*fade);});
  const z=t>=T.t6b?eio((t-T.t6b)/1.6):0; DG.setAttribute('transform',`translate(540 760) scale(${f2(1+0.1*z)}) translate(-540 ${f2(-760+40*z)})`);
}

// ---------- t7/t7b: silhouettes of people on the bank, shaking heads, fists on "ขู่ฟ้อง" ----------
const CRG=G('crowd');
el('rect',{x:0,y:0,width:1080,height:1920,fill:'url(#gSky2)'},CRG);
el('rect',{x:0,y:880,width:1080,height:90,fill:'#203a7a'},CRG);
const crMotes=Motes(CRG,24,'#C9D4FF',100,860,5);
const PPL=[[150,0.95,0],[300,1.15,1],[455,0.9,0],[600,1.2,1],[750,0.98,0],[880,1.1,1],[1010,0.92,0]].map(([x,s,front],i)=>{
  const g=el('g',{},CRG); const col=front?'#03050c':'#0a1026';
  const arm=el('path',{d:'M40 -150 C90 -170 110 -230 100 -300',fill:'none',stroke:col,'stroke-width':34,'stroke-linecap':'round',opacity:0},g);
  const fist=el('circle',{cx:100,cy:-312,r:26,fill:col,opacity:0},g);
  el('path',{d:'M-118 400 L-118 -40 C-118 -125 -80 -150 -34 -160 L-26 -182 L26 -182 L34 -160 C80 -150 118 -125 118 -40 L118 400 Z',fill:col,stroke:'#3a4a8a','stroke-width':3},g);
  const hd=el('g',{},g); el('ellipse',{cx:0,cy:-240,rx:50,ry:60,fill:col,stroke:'#3a4a8a','stroke-width':3},hd);
  const ang=el('g',{opacity:0},g); [0,1,2,3].forEach(k=>el('path',{d:'M8 0 Q0 -8 -8 0',fill:'none',stroke:'#ff3b4e','stroke-width':7,'stroke-linecap':'round',transform:`rotate(${k*90}) translate(0 -14)`},ang));
  return {g,hd,arm,fist,ang,x,s,i,front};});
function crowdF(t){ if(t<T.t7-0.05||t>T.t8+0.2){show($('gwSue'),0);return;} crMotes.set(t,0.7);
  PPL.forEach(p=>{const y=p.front?1260:1150; p.g.setAttribute('transform',`translate(${p.x} ${f2(y+4*Math.sin(t*2+p.i))}) scale(${p.s})`);
    const shake=(t>=K.maipor-0.1)?7*Math.sin(t*14+p.i*1.3):2*Math.sin(t*2+p.i); p.hd.setAttribute('transform',`rotate(${f2(shake)} 0 -180)`);
    const ra=p.i%2===1?(t>=K.khu?S(t-K.khu-p.i*0.03,POP[0],POP[1]):(t>=K.maipor+0.3+p.i*0.05?0.6*S(t-K.maipor-0.3-p.i*0.05,14,0.7):0)):0;
    const pump=t>=K.khu?0.12*Math.sin((t-K.khu)*18):0;
    sa(p.arm,clamp(ra*3)); sa(p.fist,clamp(ra*3)); p.arm.setAttribute('transform',`rotate(${f2(-60*(1-ra)+pump*40)} 40 -150)`); p.fist.setAttribute('transform',`rotate(${f2(-60*(1-ra)+pump*40)} 40 -150)`);
    const av=p.i%3===0?win(t,K.maipor+0.15+p.i*0.04,T.t8,POP):0; sa(p.ang,av); p.ang.setAttribute('transform',`translate(70 -330) scale(${f2(Math.max(0.001,av*1.6))}) rotate(${f2(t*40)})`);});
  CRG.setAttribute('transform',`translate(540 1000) scale(${f2(1+0.03*(t-T.t7))}) translate(-540 -1000)`);
  const gw=$('gwSue'), v=win(t,K.khu,T.t8,BOUNCE); if(!show(gw,clamp(v*1.6)))return;
  gw.style.top='380px'; gw.style.transform=`scale(${f2(Math.max(0.001,0.5+0.5*v))}) rotate(${f2(-3+2*Math.sin(t*9))}deg) translate(${f2(6*Math.sin(t*47))}px,${f2(4*Math.cos(t*39))}px)`;
  const fi=Math.floor((t-K.khu)*30), on=fi>=0&&fi<6, o=[[-12,12],[10,-14],[-16,8],[8,-10],[-6,6],[4,-4]][Math.max(0,fi)%6];
  gw.style.setProperty('--hf-glitch-red',(on?o[0]:0)+'px'); gw.style.setProperty('--hf-glitch-blue',(on?o[1]:0)+'px');
}

// ---------- t8/t9: three cards (พญานาค | ก๊าซ | กระสุน) around one "?"; nobody gets a tick ----------
const icA=$('cdAsv'), icB=$('cdBsv'), icC=$('cdCsv');
el('rect',{x:0,y:0,width:220,height:200,rx:20,fill:'#0c1638'},icA);
el('path',{d:'M20 150 C60 110 80 170 120 130 C150 100 160 70 190 60',fill:'none',stroke:'#3a4a8a','stroke-width':22,'stroke-linecap':'round'},icA);
el('path',{d:'M20 150 C60 110 80 170 120 130 C150 100 160 70 190 60',fill:'none',stroke:'#020309','stroke-width':16,'stroke-linecap':'round'},icA);
el('path',{d:'M176 52 L184 30 L192 50 L202 32 L204 58',fill:'#020309',stroke:'#3a4a8a','stroke-width':2},icA);
el('rect',{x:0,y:0,width:220,height:200,rx:20,fill:'#0c1638'},icB);
[[70,150,18],[120,110,26],[90,70,14],[150,60,12],[160,150,10]].forEach(([x,y,r])=>el('circle',{cx:x,cy:y,r,fill:'url(#gBub)',stroke:'#cfe0ff','stroke-width':4},icB));
el('rect',{x:0,y:0,width:220,height:200,rx:20,fill:'#0c1638'},icC);
el('path',{d:'M190 180 Q120 10 40 90',fill:'none',stroke:'#ff4f7a','stroke-width':8,'stroke-linecap':'round',opacity:.9},icC);
el('circle',{cx:40,cy:90,r:14,fill:'#ffd0dc'},icC);
const CARDS=[['cdA',230,700,-8,-600,-300],['cdB',540,680,0,0,700],['cdC',850,700,8,700,-300]];
function cardsF(t){ const a=T.t8, b=DUR; if(t<a-0.05||t>T.c1+0.2){CARDS.forEach(c=>show($(c[0]),0)); show($('qbub'),0); show($('none'),0); return;}
  CARDS.forEach(([id,x,y,r,ox,oy],i)=>{const e=$(id), v=win(t,a+0.05+i*0.12,T.c1,MORPH); if(!show(e,clamp(v*3)))return;
    const fx=lerp(ox,0,clamp(v)), fy=lerp(oy,0,clamp(v)), bob=10*Math.sin(t*1.8+i*2), rot=r*(t>=T.t9?0.6+0.4*Math.cos((t-T.t9)*0.9):1)+1.5*Math.sin(t*1.1+i);
    e.style.transform=`translate(${f2(x-135+fx)}px,${f2(y-170+fy+bob)}px) rotate(${f2(rot)}deg) scale(${f2(Math.max(0.001,0.7+0.3*v))})`;
    const ck=e.querySelector('.ck'), cv2=win(t,K.thukfai+i*0.1,T.c1,BOUNCE); ck.style.opacity=f2(clamp(cv2*2)); ck.style.transform=`scale(${f2(Math.max(0.001,cv2*(1+0.06*Math.sin(t*6+i))))})`;});
  const q=$('qbub'), vq=win(t,a+0.35,T.c1,BOUNCE); if(show(q,clamp(vq*2))) q.style.transform=`scale(${f2(Math.max(0.001,vq*(1+0.05*Math.sin(t*5))))}) rotate(${f2(6*Math.sin(t*2.2))}deg)`;
  const n=$('none'), vn=win(t,K.thukfai+0.05,T.c1,POP); if(show(n,clamp(vn*2))) n.style.transform=`translateY(${f2(20*(1-clamp(vn)))}px) scale(${f2(Math.max(0.001,0.85+0.15*vn))})`;
}

// ---------- close: "พญานาค หรือ มีคนทำ?" over the frame-0 river, comment bubble, then the hook title returns (loop) ----------
function closeF(t){
  const ct=$('ctext'), v=win(t,T.c1+0.04,TBACK,BOUNCE), out=t>=TBACK?1-clamp((t-TBACK)/0.07):1;
  if(show(ct,clamp(v*2)*out)) ct.style.transform=`translateY(${f2(20*(1-clamp(v)))}px) scale(${f2(Math.max(0.001,0.85+0.15*v))})`;
  const q2=t>=K.mikhon?S(t-K.mikhon,POP[0],POP[1]):0; $('q2').style.transform=`scale(${f2(Math.max(0.001,q2))}) rotate(${f2(-3*Math.sin(t*4))}deg)`;
  const cm=$('cmt'), vc=win(t,T.c2,TBACK,POP)*out; if(show(cm,clamp(vc*2))) cm.style.transform=`translate(${f2(780)}px,${f2(700+6*Math.sin(t*6))}px) rotate(${f2(-8+6*Math.sin(t*5))}deg) scale(${f2(Math.max(0.001,vc))})`;
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

function render(t){ scenes(t); stars(t); fx(t); title(t); hookF(t); layers(t); mapF(t); orbF(t); countF(t); silentF(t); vanishF(t); nagaF(t);
  flipF(t); gasF(t); tvF(t); diagF(t); crowdF(t); cardsF(t); loopF(t); closeF(t); pillF(t); tagF(t); captions(t); }
const proxy={_t:0}; Object.defineProperty(proxy,'t',{get(){return this._t;},set(v){this._t=v;render(v);}});
const tl=gsap.timeline({paused:true});
tl.to(proxy,{t:%%DUR%%,duration:%%DUR%%,ease:'none'},0);
render(0);
if(document.fonts&&document.fonts.ready)document.fonts.ready.then(()=>render(proxy._t));
window.__timelines=window.__timelines||{}; window.__timelines["main"]=tl;
})();
</script>
</body></html>
