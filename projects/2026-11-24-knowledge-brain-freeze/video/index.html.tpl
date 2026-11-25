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
/* brain-freeze v2 redo: #eg = ONE brain that morphs across run / truth / palate / tongue (lives in #scenes, z-index follows the shot) */
#eg{position:absolute;left:0;top:0;width:1080px;height:1920px;pointer-events:none;opacity:0}
#eg svg{position:absolute;left:0;top:0}
.eg-t{color:var(--text);font-weight:700;-webkit-text-stroke:12px var(--ink);paint-order:stroke fill;text-align:center;line-height:1.35;white-space:nowrap}
#eg-lab{position:absolute;left:0;top:255px;width:1080px;font-size:96px;transform-origin:50% 60%}
#eg-lab em{font-style:normal;color:var(--accent)}
#eg-chip{position:absolute;left:340px;top:1300px;width:400px;height:110px;border-radius:60px;background:var(--accent);color:var(--ink);
  font-weight:700;font-size:60px;line-height:110px;text-align:center;box-shadow:0 0 0 8px var(--ink),0 18px 40px rgba(0,0,0,.45);transform-origin:50% 50%}
#eg-strip{position:absolute;left:40px;top:1300px;width:1000px;height:110px;display:flex;align-items:center;justify-content:center;gap:10px}
.eg-si{height:96px;padding:0 26px;border-radius:50px;background:var(--panel);color:var(--text);font-weight:700;font-size:48px;line-height:96px;
  white-space:nowrap;box-shadow:0 0 0 6px var(--ink);transform-origin:50% 50%}
.eg-si.on{background:var(--accent);color:var(--ink)}
#eg svg.eg-ar{position:static;width:46px;height:46px;color:var(--text);flex:none}
/* overlays cloned into footage pictures (follow their push / whip) */
.fx{position:absolute;left:0;top:0;width:1080px;height:1920px;overflow:visible;pointer-events:none}
.fxchip{position:absolute;height:120px;padding:0 40px;border-radius:64px;background:var(--panel);color:var(--text);font-weight:700;font-size:66px;
  line-height:120px;white-space:nowrap;box-shadow:0 0 0 8px var(--ink),0 18px 40px rgba(0,0,0,.45);opacity:0;transform-origin:50% 50%}
.fxchip em{font-style:normal;color:var(--accent)}
.fxchip.hot{background:var(--accent);color:var(--ink);display:flex;align-items:center;gap:18px}
.gx{position:absolute;left:0;top:0;width:1080px;height:1920px}
.gtx{position:absolute;color:var(--text);font-weight:700;text-align:center;white-space:nowrap;line-height:1.35;-webkit-text-stroke:12px var(--ink);paint-order:stroke fill}
.gtx em{font-style:normal;color:var(--accent)}
.gic{position:absolute;color:var(--accent);overflow:visible}
</style></head><body>
<div id="root" class="%%CAPSTYLE%% %%OPENING%%" data-composition-id="main" data-start="0" data-duration="%%DUR%%" data-width="1080" data-height="1920"
 data-motion-blur="on" data-motion-blur-events="on">
<svg width="0" height="0" style="position:absolute" aria-hidden="true"><defs>
%%ICONS%%
</defs></svg>
<div id="stage" data-layout-allow-overflow data-layout-allow-overlap>
<div id="scenes" data-layout-allow-overflow data-layout-allow-overlap style="position:absolute;left:0;top:0;width:1080px;height:1920px;z-index:0;isolation:isolate">
%%SCENES%%
<div id="eg" data-layout-allow-overflow data-layout-allow-overlap>
<svg width="1080" height="1920" viewBox="0 0 1080 1920" overflow="visible">
 <g id="eg-cam">
  <path id="eg-back" fill="var(--panel)" stroke="var(--accent)" stroke-width="10" stroke-linejoin="round"/>
  <g id="eg-face" opacity="0">
   <path d="M700,660 Q735,640 772,652" fill="none" stroke="var(--text)" stroke-width="9" stroke-linecap="round"/>
   <circle cx="738" cy="694" r="15" fill="var(--text)"/>
   <path id="eg-palglow" d="M842,930 Q730,872 612,922" fill="none" stroke-width="44" stroke-linecap="round" opacity="0"/>
   <path id="eg-pal" d="M842,930 Q730,872 612,922" fill="none" stroke-width="16" stroke-linecap="round"/>
   <path id="eg-tongue" fill="var(--accent2)" stroke="var(--ink)" stroke-width="7" stroke-linejoin="round"/>
   <path id="eg-nerve" d="M705,905 C690,830 735,770 752,712 S800,630 792,592" fill="none" stroke="var(--accent)" stroke-width="10"
     stroke-linecap="round" pathLength="1" stroke-dasharray="1 1.2" stroke-dashoffset="1.1"/>
   <circle id="eg-p0" r="20" fill="var(--text)" stroke="var(--accent)" stroke-width="6" opacity="0"/>
   <circle id="eg-p1" r="20" fill="var(--text)" stroke="var(--accent)" stroke-width="6" opacity="0"/>
   <circle id="eg-p2" r="20" fill="var(--text)" stroke="var(--accent)" stroke-width="6" opacity="0"/>
   <g id="eg-burst" transform="translate(800,588)" opacity="0">
    <circle r="62" fill="var(--accent)" opacity=".55"/>
    <g stroke="var(--accent)" stroke-width="12" stroke-linecap="round">
     <path d="M0,-80 L0,-125"/><path d="M57,-57 L88,-88"/><path d="M80,0 L125,0"/><path d="M57,57 L88,88"/>
     <path d="M-57,-57 L-88,-88"/><path d="M0,80 L0,125"/><path d="M-80,0 L-125,0"/><path d="M-57,57 L-88,88"/></g>
   </g>
   <g id="eg-mcone" opacity="0"><use href="#ic-ice-cream-cone" x="-95" y="-95" width="190" height="190" style="color:var(--text)"/></g>
  </g>
  <g id="eg-brain">
   <path id="eg-bp" stroke="var(--ink)" stroke-width="12" stroke-linejoin="round"/>
   <g id="eg-gyri" fill="none" stroke="var(--ink)" stroke-width="10" stroke-linecap="round">
    <path d="M-190,-40 C-150,-110 -70,-60 -50,-125"/><path d="M-20,-160 C10,-95 80,-145 110,-80"/>
    <path d="M150,-125 C200,-65 150,-5 215,25"/><path d="M-205,70 C-130,25 -70,95 5,50"/>
    <path d="M55,45 C105,0 150,90 220,70"/><path d="M-80,135 C-15,95 50,150 120,118"/>
    <path d="M-5,-60 C40,-20 -30,20 20,60"/></g>
   <path id="eg-fac" fill="none" stroke="var(--text)" stroke-width="7" stroke-linecap="round" opacity="0"/>
  </g>
  <g id="eg-cone" opacity="0"><circle r="92" fill="var(--panel)" stroke="var(--text)" stroke-width="8"/>
   <use href="#ic-ice-cream-cone" x="-66" y="-66" width="132" height="132" style="color:var(--text)"/></g>
  <g id="eg-chev" fill="none" stroke="var(--text)" stroke-width="16" stroke-linecap="round" stroke-linejoin="round">
   <path d="M-56,22 L0,-22 L56,22"/><path d="M-56,22 L0,-22 L56,22"/><path d="M-56,22 L0,-22 L56,22"/></g>
  <g id="eg-flakes" style="color:var(--text)">
   <use href="#ic-snowflake" x="-45" y="-45" width="90" height="90"/><use href="#ic-snowflake" x="-35" y="-35" width="70" height="70"/>
   <use href="#ic-snowflake" x="-40" y="-40" width="80" height="80"/><use href="#ic-snowflake" x="-30" y="-30" width="60" height="60"/>
   <use href="#ic-snowflake" x="-38" y="-38" width="76" height="76"/></g>
  <g id="eg-shards" fill="var(--text)" stroke="var(--ink)" stroke-width="4" stroke-linejoin="round"></g>
  <g id="eg-zap" opacity="0"><use href="#ic-zap" x="-80" y="-80" width="160" height="160" style="color:var(--accent)"/></g>
  <text id="eg-jeed" x="0" y="0" font-size="110" text-anchor="middle" fill="var(--accent)" stroke="var(--ink)" stroke-width="14" paint-order="stroke" opacity="0" style="font-family:var(--font);font-weight:700">จี๊ด!</text>
 </g>
</svg>
<div id="eg-lab" class="eg-t" style="opacity:0"></div>
<div id="eg-chip" style="opacity:0"></div>
<div id="eg-strip" style="opacity:0">
 <div class="eg-si" id="eg-s0"></div><svg class="eg-ar"><use href="#ic-arrow-right"/></svg>
 <div class="eg-si" id="eg-s1"></div><svg class="eg-ar"><use href="#ic-arrow-right"/></svg>
 <div class="eg-si" id="eg-s2"></div>
</div>
</div>
</div>
<!-- EPISODE GRAPHICS: editor adds the episode's own layers here (charts, icons, cards); fill #g-<shot id> slots -->
<svg width="0" height="0" style="position:absolute" aria-hidden="true"><defs>
 <filter id="hk-soft" x="-10%" y="-10%" width="120%" height="120%"><feGaussianBlur stdDeviation="9"/></filter>
 <radialGradient id="hk-frost" cx="50%" cy="50%" r="72%"><stop id="hk-fs0" offset=".62" stop-color="var(--text)" stop-opacity="0"/>
  <stop offset="1" stop-color="var(--text)" stop-opacity=".78"/></radialGradient>
 <radialGradient id="wm-glow" cx="50%" cy="38%" r="75%"><stop offset="0" stop-color="var(--accent2)" stop-opacity=".0"/>
  <stop offset=".55" stop-color="var(--accent2)" stop-opacity=".18"/><stop offset="1" stop-color="var(--accent)" stop-opacity=".5"/></radialGradient>
</defs></svg>
<div id="gx-store" style="display:none">
 <svg class="fx" id="hk-src" viewBox="0 0 1080 1920">
  <rect class="hk-creep" x="104" y="714" width="872" height="824" rx="50" fill="url(#hk-frost)"/>
  <rect class="hk-glow" x="102" y="712" width="876" height="828" rx="52" fill="none" stroke="var(--text)" stroke-width="30" filter="url(#hk-soft)" opacity=".55"/>
  <rect x="104" y="714" width="872" height="824" rx="50" fill="none" stroke="var(--text)" stroke-width="5" opacity=".85"/>
  <path d="M150,712L164,750L178,712M194,712L208,734L222,712M238,712L252,766L266,712M282,712L296,742L310,712M326,712L340,730L354,712M370,712L384,758L398,712M414,712L428,738L442,712M458,712L472,772L486,712M502,712L516,746L530,712M546,712L560,732L574,712M590,712L604,762L618,712M634,712L648,740L662,712M678,712L692,752L706,712M722,712L736,736L750,712M766,712L780,768L794,712M810,712L824,744L838,712M854,712L868,732L882,712M898,712L912,756L926,712Z" fill="var(--text)" opacity=".92" stroke="var(--ink)" stroke-width="3" stroke-linejoin="round"/>
  <g style="color:var(--text)">
   <use class="hk-fl" href="#ic-snowflake" x="-40" y="-40" width="80" height="80" data-x="60" data-y="820" data-r="1"/>
   <use class="hk-fl" href="#ic-snowflake" x="-34" y="-34" width="68" height="68" data-x="1020" data-y="900" data-r="-1"/>
   <use class="hk-fl" href="#ic-snowflake" x="-28" y="-28" width="56" height="56" data-x="52" data-y="1250" data-r="-2"/>
   <use class="hk-fl" href="#ic-snowflake" x="-44" y="-44" width="88" height="88" data-x="1022" data-y="1330" data-r="2"/>
   <use class="hk-fl" href="#ic-snowflake" x="-36" y="-36" width="72" height="72" data-x="170" data-y="1640" data-r="1"/>
   <use class="hk-fl" href="#ic-snowflake" x="-30" y="-30" width="60" height="60" data-x="930" data-y="1660" data-r="-1"/>
   <use class="hk-fl" href="#ic-snowflake" x="-26" y="-26" width="52" height="52" data-x="140" data-y="760" data-r="2"/>
   <use class="hk-fl" href="#ic-snowflake" x="-26" y="-26" width="52" height="52" data-x="940" data-y="762" data-r="-2"/>
  </g>
  <g class="hk-cone" transform="translate(905,1452)">
   <circle r="66" fill="var(--text)" stroke="var(--ink)" stroke-width="8"/>
   <use href="#ic-ice-cream-cone" x="-44" y="-44" width="88" height="88" style="color:var(--ink)"/>
  </g>
 </svg>
 <svg class="fx" id="fx-why" viewBox="0 0 1080 1920">
  <g style="color:var(--text)" opacity=".9">
   <use class="wy-fl" href="#ic-snowflake" x="-40" y="-40" width="80" height="80" data-x="150" data-y="520"/>
   <use class="wy-fl" href="#ic-snowflake" x="-30" y="-30" width="60" height="60" data-x="930" data-y="980"/>
   <use class="wy-fl" href="#ic-snowflake" x="-34" y="-34" width="68" height="68" data-x="200" data-y="1480"/>
  </g>
  <text class="wy-q" x="0" y="0" font-size="300" text-anchor="middle" fill="var(--accent)" stroke="var(--ink)" stroke-width="20" paint-order="stroke" opacity="0" style="font-family:var(--font);font-weight:700">?</text>
 </svg>
 <svg class="fx" id="fx-fh" viewBox="0 0 1080 1920">
  <text class="fh-q" x="0" y="0" font-size="220" text-anchor="middle" fill="var(--accent)" stroke="var(--ink)" stroke-width="16" paint-order="stroke" opacity="0" style="font-family:var(--font);font-weight:700">?</text>
  <g class="fh-burst" opacity="0">
   <circle r="95" fill="var(--accent)" opacity=".42"/>
   <g stroke="var(--accent)" stroke-width="14" stroke-linecap="round">
    <path d="M0,-115 L0,-170"/><path d="M82,-82 L122,-122"/><path d="M115,0 L170,0"/><path d="M-82,-82 L-122,-122"/><path d="M-115,0 L-170,0"/></g>
  </g>
  <text class="fh-j" x="0" y="0" font-size="120" text-anchor="middle" fill="var(--accent)" stroke="var(--ink)" stroke-width="16" paint-order="stroke" opacity="0" style="font-family:var(--font);font-weight:700">จี๊ด!</text>
 </svg>
 <svg class="fx" id="fx-warm" viewBox="0 0 1080 1920"><rect class="wm-g" x="0" y="0" width="1080" height="1920" fill="url(#wm-glow)" opacity="0"/></svg>
 <div class="fx" id="fx-doc">
  <div class="fxchip dc-a" style="left:70px;top:190px">ปวด<em>บ่อย</em></div>
  <div class="fxchip dc-b" style="left:560px;top:190px">ปวด<em>แรง</em></div>
  <div class="fxchip hot dc-c" style="left:300px;top:1330px"><svg style="width:84px;height:84px;color:var(--ink)"><use href="#ic-stethoscope"/></svg>หาหมอ</div>
 </div>
 <div class="gx" id="gx-ask">
  <div class="gtx" id="ak-t" style="left:0;top:270px;width:1080px;font-size:116px">จี๊ดนาน<em>กี่วิ</em>?</div>
  <svg class="gic" id="ak-w" style="left:290px;top:500px;width:500px;height:560px" viewBox="-250 -300 500 560">
   <rect x="-45" y="-292" width="90" height="56" rx="14" fill="var(--accent)" stroke="var(--ink)" stroke-width="8"/>
   <circle r="230" fill="var(--panel)" stroke="var(--text)" stroke-width="18"/>
   <path id="ak-arc" fill="var(--accent)" opacity=".85"/>
   <line id="ak-hand" x1="0" y1="0" x2="0" y2="-185" stroke="var(--text)" stroke-width="16" stroke-linecap="round"/>
   <circle r="22" fill="var(--text)"/>
   <text id="ak-n" x="0" y="0" font-size="150" text-anchor="middle" fill="var(--text)" stroke="var(--ink)" stroke-width="12" paint-order="stroke" style="font-family:var(--font);font-weight:700">1</text>
  </svg>
 </div>
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
const XF=0.3, XM=0.2;   // soft whip 0.3 s eased in-out, match = 0.2 s dissolve
// entry of shot s (the look's transition; fast beats always get it, hold beats get a soft 0.1 s match)
// the look's transition: inside hook/twist and wherever the beat changes; other cuts inside one beat = soft match
const kind=(s,prev)=>(s.beat==='loop')?'match':(FASTB[s.beat]||s.beat!==prev.beat)?TR:'match';
SC.forEach((s,i)=>{s.next=SC[i+1]; s.el=$('sh-'+s.id); s.kb=$('kb-'+s.id); s.el.style.zIndex=String(i+1); s.k=i?kind(s,SC[i-1]):'none';});
function sceneState(s,t){
  if(t<s.a) return null;
  const nx=s.next, end=nx?nx.a:DUR+1, u=t-s.a; let o=1,tx=0,ty=0,sc=1;
  if(s.k==='whip') tx=1080*(1-eio(u/XF)); else if(s.k==='slide') ty=1920*(1-eo(u/0.16));
  else if(s.k==='zoom'){o=eio(u/0.1); sc=1+0.3*(1-S(u,18,0.9));} else if(s.k==='match') o=eio(u/XM);
  if(nx){ if(nx.k==='flash'){ if(t>=end) return null; }
    else { if(t>=end+(nx.k==='slide'?0.16:XF)) return null;
      if(t>=end&&nx.k==='whip') tx=-1080*eio((t-end)/XF); if(t>=end&&nx.k==='slide') ty=-480*eo((t-end)/0.16); } }
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
    // this episode (user 2026-11-25 "ไม่เร็วเกิน ไหลลื่น"): every picture = slow push-in + leftward drift, the same
    // direction as the whip (new shot enters from the right) so the camera keeps moving one way across cuts; no shake
    { const k=lerp(1.03,1.09,eio(uu)), dx=lerp(26,-26,uu), dy=-10*uu;
      s.kb.style.transform=`translate(${f2(dx)}px,${f2(dy)}px) scale(${k.toFixed(5)})`; }
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
// EPISODE MOTION: brain-freeze v2 redo (user 2026-11-25: not too fast, flowing, motion that fits the meaning).
// cold = slow + soft (frost spreads, flakes float); "จี๊ด" = one short bounce on the word only; nerve = pulses flow
// upward and the camera pans with them; warm = slow cold->warm colour; chips/labels = soft spring.
// Every change lands on a word (words.json times in comments).
const SH={}; SC.forEach((s,i)=>{s.i=i; SH[s.id]=s;});
const G={run:1,truth:1,palate:1,tongue:1};
const win=(t,a,b)=>t>=a&&t<b, pop=(t,a,w=16,z=0.55)=>t<a?0:S(t-a,w,z), soft=(t,a)=>clamp(pop(t,a,10,0.8),0,1.08);
const bounce=(t,a)=>t<a?0:Math.exp(-(t-a)*9)*Math.sin((t-a)*26);      // short "จี๊ด" kick, dies in ~0.35 s
const N=96, P2=Math.PI*2;
const path=pts=>'M'+pts.map(p=>p[0].toFixed(1)+','+p[1].toFixed(1)).join('L')+'Z';
const BR=[]; for(let i=0;i<N;i++){const th=-Math.PI/2+P2*i/N, top=Math.max(0,-Math.sin(th));
  const m=1+0.06*Math.pow(top,0.6)*Math.cos(10*th)+0.025*Math.cos(3*th+0.5); let x=280*Math.cos(th)*m, y=215*Math.sin(th)*m; if(y>0)y*=0.84; BR.push([x,y]);}
const K=9, TK=[], VK=[]; for(let k=0;k<=K;k++){const kk=k%K, th=-Math.PI/2+P2*k/K+(kk?0.14*Math.sin(kk*2.3):0), r=1.06+0.08*Math.sin(kk*5.1);
  TK.push(th); VK.push([300*Math.cos(th)*r, 228*Math.sin(th)*r*(Math.sin(th)>0?0.86:1)]);}
const ICE=BR.map((_,i)=>{const th=-Math.PI/2+P2*i/N; let k=0; while(k<K-1&&th>=TK[k+1])k++; const u=(th-TK[k])/(TK[k+1]-TK[k]);
  return [lerp(VK[k][0],VK[k+1][0],u), lerp(VK[k][1],VK[k+1][1],u)];});
$('eg-fac').setAttribute('d', VK.slice(0,K).map((v,k)=>`M${(v[0]*0.9).toFixed(1)},${(v[1]*0.9).toFixed(1)}L${(v[0]*0.32+(k%2?20:-20)).toFixed(1)},${(v[1]*0.32).toFixed(1)}`).join('')
  +'M-120,-60L40,-90L130,20M-90,80L60,60');
let HD=[[470,400],[590,410],[690,450],[770,520],[810,600],[822,680],[812,735],[848,800],[886,846],[852,872],[846,902],[862,926],[842,950],
  [860,976],[836,1006],[832,1042],[792,1074],[700,1082],[642,1102],[642,1210],[430,1210],[424,1120],[330,1060],[242,960],[202,830],[206,680],[252,540],[342,440]];
for(let it=0;it<2;it++){const o=[]; HD.forEach((p,i)=>{const q=HD[(i+1)%HD.length]; o.push([.75*p[0]+.25*q[0],.75*p[1]+.25*q[1]],[.25*p[0]+.75*q[0],.25*p[1]+.75*q[1]]);}); HD=o;}
const HEAD=(()=>{const L=[0]; for(let i=1;i<=HD.length;i++){const a=HD[i-1],b=HD[i%HD.length]; L.push(L[i-1]+Math.hypot(b[0]-a[0],b[1]-a[1]));}
  const tot=L[L.length-1], out=[]; let j=0; for(let i=0;i<N;i++){const d=tot*i/N; while(L[j+1]<d)j++; const a=HD[j],b=HD[(j+1)%HD.length],u=(d-L[j])/(L[j+1]-L[j]);
  out.push([lerp(a[0],b[0],u),lerp(a[1],b[1],u)]);} return out;})();
const SHARDS=[]; for(let k=0;k<12;k++){const v=VK[k%K], a=Math.atan2(v[1],v[0])+0.25*Math.sin(k*1.7);
  const el=document.createElementNS('http://www.w3.org/2000/svg','path'); el.setAttribute('d',`M0,-${26+k%3*8}L${22+k%2*10},${18}L-${20+k%4*5},${14}Z`);
  $('eg-shards').appendChild(el); SHARDS.push({el,v,dx:Math.cos(a),dy:Math.sin(a),sp:(k%2?1:-1)*(200+40*(k%3))});}
const FL=[[-340,-140],[340,-170],[-320,170],[320,160],[0,-300]], flakes=[...$('eg-flakes').children], chev=[...$('eg-chev').children];
const mix=(p,a,b)=>`color-mix(in srgb, var(${a}) ${Math.round(clamp(p)*100)}%, var(${b}))`;
const nerve=$('eg-nerve'), NL=nerve.getTotalLength();
let lastLab=null, lastChip=null, lastStrip=null;
function curShot(t){let c=SC[0]; for(const s of SC) if(t>=s.a) c=s; return c;}
function brain(t){
  const eg=$('eg'), c=curShot(t), pv=SC[c.i-1]; let host=null, copy=false;
  if(G[c.id]){host=c; copy=!pv||!G[pv.id];} else if(pv&&G[pv.id]&&t<c.a+0.34){host=pv; copy=true;}
  if(!host){eg.style.opacity='0'; return;}
  eg.style.zIndex=String(host.i+1);
  if(copy){eg.style.opacity=host.el.style.opacity; eg.style.transform=host.el.style.transform;} else {eg.style.opacity='1'; eg.style.transform='none';}
  // frost: spreads slowly over the brain on "สมอง" 4.98 (belief: cold reaches the brain); shatters on "ความจริง" 6.12
  const f=t<6.12?eio((t-4.98)/0.8):1-eo((t-6.12)/0.3);
  // positions: belief (top, cone below) -> truth (centre) on "ความจริง" 6.12 -> side-view head at the palate shot 11.40
  const A=[540,590,0.7], B=[540,800,0.85], P3=[505,642,0.62];
  const m1=soft(t,6.12), h=t<11.40?0:eio((t-11.40)/0.6), hs=t<11.40?0:clamp(pop(t,11.40,8,0.8),0,1.04);
  const qx=lerp(A[0],B[0],m1), qy=lerp(A[1],B[1],m1), qs=lerp(A[2],B[2],m1);
  const cx=lerp(qx,P3[0],hs), cy=lerp(qy,P3[1],hs), s=lerp(qs,P3[2],hs);
  const breath=1+0.012*Math.sin(t*2.2);
  $('eg-brain').setAttribute('transform',`translate(${f2(cx)},${f2(cy)}) scale(${(s*breath).toFixed(4)})`);
  $('eg-bp').setAttribute('d',path(BR.map((p,i)=>[lerp(p[0],ICE[i][0],f),lerp(p[1],ICE[i][1],f)])));
  $('eg-bp').style.fill=mix(f,'--text','--accent2');
  $('eg-gyri').setAttribute('opacity',f2(1-0.75*f)); $('eg-fac').setAttribute('opacity',f2(f));
  const R=Math.max(200,300*qs);
  $('eg-back').setAttribute('d',path(HEAD.map((q,i)=>{const th=-Math.PI/2+P2*i/N; return [lerp(qx+R*Math.cos(th),q[0],h), lerp(qy+R*Math.sin(th),q[1],h)];})));
  // belief: cone below the brain (shot start 4.32), cold chevrons flow up from it on "วิ่ง" 4.40; all fall away on "ความจริง"
  const co=t<6.12?soft(t,4.32):1-eo((t-6.12)/0.35);
  $('eg-cone').setAttribute('opacity',f2(clamp(co))); $('eg-cone').setAttribute('transform',`translate(540,${f2(1010+60*(1-clamp(co)))}) scale(${clamp(co,0,1.08).toFixed(3)})`);
  chev.forEach((el,k)=>{ if(t<4.40||t>6.6){el.setAttribute('opacity','0');return;}
    const ph=((t-4.40)/0.9+k/3)%1, y=lerp(905,830,ph), on=clamp((t-4.40)/0.25)*Math.sin(Math.PI*ph);
    const fall=t<6.12?0:(t-6.12), dx=(k-1)*260*fall, dy=900*fall*fall;
    el.setAttribute('opacity',f2(on*(1-clamp(fall/0.45)))); el.setAttribute('transform',`translate(${f2(540+dx)},${f2(y+dy)}) rotate(${f2((k-1)*120*fall)})`);});
  // snowflakes float in slowly with the frost, melt away on the shatter
  flakes.forEach((el,k)=>{const on=t<6.12?clamp(eio((t-4.98-0.12*k)/0.7)):1-eo((t-6.12)/0.25);
    const fy=8*Math.sin(t*1.6+k); el.setAttribute('transform',`translate(${f2(cx+FL[k][0]*s)},${f2(cy+FL[k][1]*s+fy)}) rotate(${f2(14*t+k*30)}) scale(${on.toFixed(3)})`);});
  SHARDS.forEach(d=>{const u=t-6.12; if(u<0||u>1.0){d.el.setAttribute('opacity','0');return;}
    const x=cx+d.v[0]*s+d.dx*420*u, y=cy+d.v[1]*s+d.dy*320*u+700*u*u; d.el.setAttribute('opacity',f2(1-u));
    d.el.setAttribute('transform',`translate(${f2(x)},${f2(y)}) rotate(${f2(d.sp*u)})`);});
  // truth: zap (pain) springs up on "ความเจ็บ" 8.54 and goes small + dim on "เลย" 8.92 (the brain feels none)
  const zOn=win(t,8.54,10.2)?soft(t,8.54):0, zOff=eio((t-8.92)/0.4);
  $('eg-zap').setAttribute('opacity',f2(zOn?lerp(1,0.3,zOff):0));
  $('eg-zap').setAttribute('transform',`translate(${f2(cx+250*s)},${f2(cy-230*s)}) scale(${(zOn*lerp(1,0.55,zOff)).toFixed(3)})`);
  $('eg-face').setAttribute('opacity',f2(clamp((h-0.6)/0.4)));
  // palate: cold spreads on "เย็นจัด" 11.72 (slow); tongue shot: warms slowly from "เพดานปาก" 22.50 to "ไว้" 23.14
  const cold=t<20?eio((t-11.72)/0.7):1, warm=t<20?0:eio((t-22.50)/1.1);
  const palC=warm>0.01?mix(warm,'--accent2','--text'):mix(cold,'--text','--accent');
  $('eg-pal').style.stroke=palC; $('eg-palglow').style.stroke=palC;
  $('eg-palglow').setAttribute('opacity',f2(clamp(Math.max(cold*(t<20?1:1),warm))*(0.38+0.1*Math.sin(t*3))));
  // cone meets the mouth on "พอโดน" 11.48, slides out with the nerve 12.62
  const cin=t<20?eio((t-11.48)/0.4):0, cout=t<20?eio((t-12.62)/0.5):0;
  $('eg-mcone').setAttribute('opacity',f2(cin*(1-cout)));
  $('eg-mcone').setAttribute('transform',`translate(${f2(lerp(1060,935,cin)+90*cout)},935) rotate(-90)`);
  // tongue lifts on "ลิ้น" 22.08, presses on "ดัน" 22.36
  const lift=t<20?0:clamp(pop(t,22.08,9,0.8)*0.6+pop(t,22.36,9,0.8)*0.4,0,1.06), yt=lerp(968,900,lift), ytip=lerp(972,930,lift);
  $('eg-tongue').setAttribute('d',`M612,1000 C640,${f2(yt)} 760,${f2(yt-6)} 834,${f2(ytip)} C800,1012 700,1018 612,1000Z`);
  // nerve: draws on "เส้นประสาท" 12.62; pulses flow up on "ส่ง" 13.62 / "สัญญาณ" 13.78 / "ขึ้นไป" 14.12
  nerve.setAttribute('stroke-dashoffset',f2(t<20?1.1*(1-eio((t-12.62)/0.7)):1.1));
  let hit=-1; [13.62,13.78,14.12].forEach((a,k)=>{const u=(t-a)/0.6, el=$('eg-p'+k); if(u<0||u>1.2||t>20){el.setAttribute('opacity','0');return;}
    const pt=nerve.getPointAtLength(NL*eio(u)); el.setAttribute('cx',f2(pt.x)); el.setAttribute('cy',f2(pt.y)); el.setAttribute('opacity',f2(u>1?1-(u-1)/0.2:1));});
  // forehead "จี๊ด": one short bounce when the last pulse arrives (14.12 + 0.6), then a soft glow to the end of the shot
  const ha=14.72, bo=t<20&&t>=ha?Math.max(0,1-(t-ha)/0.3):0, glow=t<20&&t>=ha?0.55+0.08*Math.sin((t-ha)*6):0;
  const bs=t<20&&t>=ha?clamp(pop(t,ha,22,0.45),0,1.25):0;
  $('eg-burst').setAttribute('opacity',f2(Math.max(bo,glow))); $('eg-burst').setAttribute('transform',`translate(800,588) scale(${(0.6+0.45*bs).toFixed(3)})`);
  $('eg-jeed').setAttribute('opacity',f2(clamp(bs*3))); $('eg-jeed').setAttribute('transform',`translate(${f2(870+10*bounce(t,ha))},460) rotate(-8) scale(${bs.toFixed(3)})`);
  // camera: slow push to the mouth on "เย็นจัด" 11.72, then pans UP with the pulses from "เส้นประสาท" 12.62; tongue: gentle push
  let z=0, py=0; if(t<20){ z=0.14*eio((t-11.72)/0.8)-0.06*eio((t-12.62)/1.6); py=120*eio((t-12.62)/2.0); } else z=0.10*eio((t-21.9)/0.9);
  $('eg-cam').setAttribute('transform',`translate(0,${f2(py)}) translate(760,920) scale(${(1+z).toFixed(4)}) translate(-760,-920)`);
  // top label: truth "สมองไม่มีตัวรับความเจ็บ" on "ไม่มี" 7.86; tongue "ทริก!" on "ทริค" 20.88
  let lab='', la=0; if(win(t,7.86,10)){lab='สมอง<em>ไม่มี</em><br>ตัวรับความเจ็บ'; la=7.86;} else if(win(t,20.88,24)){lab='<em>ทริก!</em>'; la=20.88;}
  if(lab!==lastLab){$('eg-lab').innerHTML=lab; lastLab=lab;}
  const lp=lab?soft(t,la):0; $('eg-lab').style.opacity=f2(clamp(lp*2)); $('eg-lab').style.transform=`translateY(${f2(30*(1-lp))}px) scale(${(0.8+0.2*lp).toFixed(3)})`;
  // bottom chip: "ความเชื่อ" on "วิ่ง" 4.40 -> "ความจริง" 6.12
  let chip='', ca=0; if(win(t,4.40,6.12)){chip='ความเชื่อ'; ca=4.40;} else if(win(t,6.12,10)){chip='ความจริง'; ca=6.12;}
  if(chip!==lastChip){$('eg-chip').textContent=chip; lastChip=chip;}
  const cp=chip?soft(t,ca):0; $('eg-chip').style.opacity=f2(clamp(cp*2));
  $('eg-chip').style.transform=`translateY(${f2(40*(1-cp))}px) scale(${(0.8+0.2*cp).toFixed(3)})`;
  // bottom strip: where the pain travels (palate) / the fix (tongue)
  const tg=t>=20, items=tg?['ลิ้นดัน','เพดานปาก','อุ่นขึ้น']:['เพดานปาก','เส้นประสาท','หน้าผาก'];
  const on=tg?[22.08,22.50,23.14]:[11.72,12.62,14.72], sa=tg?21.90:11.50;
  if(items.join()!==lastStrip){items.forEach((x,k)=>$('eg-s'+k).textContent=x); lastStrip=items.join();}
  const stp=t>=sa?soft(t,sa):0; $('eg-strip').style.opacity=f2(clamp(stp*2*(t<11.4?0:1)));
  $('eg-strip').style.transform=`translateY(${f2(50*(1-clamp(stp)))}px)`;
  items.forEach((x,k)=>{const el=$('eg-s'+k), o=t>=on[k]; el.classList.toggle('on',o); el.style.transform=`scale(${(o?1+0.1*Math.exp(-(t-on[k])*5)*Math.cos((t-on[k])*10):0.94).toFixed(3)})`;});
}
// overlays cloned into footage pictures (follow their push / whip)
const clone=(src,id)=>{const kb=$('kb-'+id); if(!kb) return null; const c=$(src).cloneNode(true); c.removeAttribute('id'); kb.appendChild(c); return c;};
const HK=['hook','loop'].map(id=>clone('hk-src',id)).filter(Boolean), WY=clone('fx-why','why'), FH=clone('fx-fh','forehead'),
  WM=clone('fx-warm','warm'), DC=clone('fx-doc','doctor');
(()=>{const g=$('gx-ask'), slot=$('g-ask'); if(g&&slot) slot.appendChild(g);})();
// frame 0 cold cues: periodic in DUR so the last frame = frame 0; frost creeps in during the hook (peak ~1.9 s)
function hookFx(t){
  const w=P2*t/DUR, creep=0.5-0.5*Math.cos(8*w);
  $('hk-fs0').setAttribute('offset',(0.66-0.22*creep).toFixed(3));
  HK.forEach(c=>{
    c.querySelectorAll('.hk-fl').forEach((el,k)=>{const x=+el.dataset.x, y=+el.dataset.y+12*Math.sin(3*w+k*1.3), r=360*(+el.dataset.r)*t/DUR;
      el.setAttribute('transform',`translate(${f2(x)},${f2(y)}) rotate(${f2(r)})`);});
    c.querySelector('.hk-glow').setAttribute('opacity',f2(0.5+0.12*Math.sin(8*w)));
    c.querySelector('.hk-cone').setAttribute('transform',`translate(905,1452) rotate(${f2(-12+6*Math.sin(4*w))})`);
  });
}
function fx(t){
  if(WY){ WY.querySelectorAll('.wy-fl').forEach((el,k)=>el.setAttribute('transform',`translate(${f2(+el.dataset.x+6*Math.sin(t*1.3+k))},${f2(+el.dataset.y-30*(t-1.94))}) rotate(${f2(20*t+k*40)})`));
    const q=soft(t,2.02); const e=WY.querySelector('.wy-q'); e.setAttribute('opacity',f2(clamp(q*2)));
    e.setAttribute('transform',`translate(820,${f2(700+6*Math.sin(t*3))}) rotate(${f2(8-4*q)}) scale(${q.toFixed(3)})`); }
  if(FH){ // "งง" 15.52 -> ?; "หน้าผาก" 16.74 -> one short bounce at his forehead, then a soft pulse
    const q=soft(t,15.52), e=FH.querySelector('.fh-q'); e.setAttribute('opacity',f2(clamp(q*2)*(1-clamp((t-16.6)/0.2))));
    e.setAttribute('transform',`translate(840,${f2(600+8*Math.sin(t*2.5))}) rotate(${f2(-10+5*Math.sin(t*2))}) scale(${q.toFixed(3)})`);
    const b=t<16.74?0:clamp(pop(t,16.74,22,0.45),0,1.25), g=FH.querySelector('.fh-burst'), pl=t<16.74?0:0.85+0.15*Math.sin((t-16.74)*6);
    g.setAttribute('opacity',f2(clamp(b*3)*pl)); g.setAttribute('transform',`translate(${f2(540+10*bounce(t,16.74))},900) scale(${(b*pl).toFixed(3)})`);
    const j=FH.querySelector('.fh-j'); j.setAttribute('opacity',f2(clamp(b*3))); j.setAttribute('transform',`translate(820,700) rotate(-8) scale(${b.toFixed(3)})`); }
  if(WM){ WM.querySelector('.wm-g').setAttribute('opacity',f2(0.9*eio((t-24.04)/1.0))); }   // "อุ่นขึ้น" 24.04: slow warm wash
  if(DC){ [['.dc-a',25.66],['.dc-b',26.20],['.dc-c',26.96]].forEach(([q,a])=>{const v=soft(t,a), el=DC.querySelector(q);
    el.style.opacity=f2(clamp(v*2)); el.style.transform=`translateY(${f2(36*(1-v))}px) scale(${(0.8+0.2*v).toFixed(3)})`;}); }
  // ask: stopwatch springs in on "ปกติ" 28.10, counts 1..2..3 (just counting, no data), question on "กี่วิ" 28.98
  const u=Math.max(0,t-28.10), n=Math.min(3,1+Math.floor(u/0.5)), na=28.10+(n-1)*0.5;
  $('ak-n').textContent=String(n); $('ak-n').setAttribute('transform',`translate(0,160) scale(${clamp(pop(t,na,18,0.6),0.3,1.15).toFixed(3)})`);
  const ang=Math.min(u,1.5)/1.5*P2*0.75; $('ak-hand').setAttribute('transform',`rotate(${f2(ang*180/Math.PI)})`);
  const ex=Math.sin(ang)*200, ey=-Math.cos(ang)*200; $('ak-arc').setAttribute('d',`M0,0L0,-200A200,200 0 ${ang>Math.PI?1:0} 1 ${f2(ex)},${f2(ey)}Z`);
  $('ak-w').style.transform=`scale(${soft(t,28.04).toFixed(3)})`;
  const kt=soft(t,28.98); $('ak-t').style.opacity=f2(clamp(kt*2)); $('ak-t').style.transform=`translateY(${f2(30*(1-kt))}px) scale(${(0.8+0.2*kt).toFixed(3)})`;
}
function episode(t){ brain(t); hookFx(t); fx(t); }
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
