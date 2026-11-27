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
/* caffeine-ranking: every colour is a palette variable or a color-mix of them (look can change without editing).
   Real objects (amber glass, coffee) are mixes of accent2/accent with ink. Gauge = accent (no warning red, no scare). */
#root{--amber-d:color-mix(in srgb,var(--ink) 82%,var(--accent2));--amber-m:color-mix(in srgb,var(--accent2) 52%,var(--ink));
  --amber-l:color-mix(in srgb,color-mix(in srgb,var(--accent) 45%,var(--accent2)) 78%,var(--ink));
  --coffee:color-mix(in srgb,var(--ink) 78%,var(--accent2));--crema:color-mix(in srgb,var(--accent) 55%,var(--accent2))}
.card{position:absolute;border-radius:30px;overflow:hidden;box-shadow:0 0 0 8px var(--ink),0 30px 70px rgba(0,0,0,.6);transform-origin:50% 50%}
.card img{width:100%;height:100%;object-fit:cover;display:block}
.cut{position:absolute;transform-origin:50% 70%;filter:drop-shadow(0 40px 40px rgba(0,0,0,.55))}
.cut img{width:100%;height:100%;display:block}
#ep{position:absolute;left:0;top:0;width:1080px;height:1920px;z-index:30;pointer-events:none}
#ep .g{position:absolute;opacity:0}
/* gauge: one tube that morphs (slim over footage / wide on graphic shots) */
#gauge{left:0;top:0;width:1080px;height:1920px;transform-origin:0 0}
#g-tube{position:absolute;border-radius:46px;background:color-mix(in srgb,var(--panel) 78%,transparent);
  box-shadow:0 0 0 7px var(--ink),inset 0 0 0 3px color-mix(in srgb,var(--text) 18%,transparent),0 24px 50px rgba(0,0,0,.45);overflow:hidden}
#g-fill{position:absolute;left:0;bottom:0;width:100%;overflow:hidden;
  background:linear-gradient(90deg,color-mix(in srgb,var(--accent) 78%,var(--accent2)) 0%,var(--accent) 45%,color-mix(in srgb,var(--accent) 70%,var(--text)) 60%,color-mix(in srgb,var(--accent) 80%,var(--accent2)) 100%)}
#g-surf{position:absolute;left:0;top:0;width:100%;height:10px;background:color-mix(in srgb,var(--text) 70%,var(--accent))}
.bub{position:absolute;border-radius:50%;background:color-mix(in srgb,var(--text) 55%,transparent);width:14px;height:14px}
.gline{position:absolute;left:-14px;height:0;border-top:7px dashed var(--text);opacity:0}
#g-l50{border-top-color:var(--accent2)}
.tk{position:absolute;width:96px;text-align:right;font-weight:700;font-size:34px;line-height:1;color:var(--text);
  -webkit-text-stroke:7px var(--ink);paint-order:stroke fill}
.tk i{position:absolute;right:-24px;top:16px;width:16px;height:4px;background:var(--text);border-radius:2px}
#g-unit{position:absolute;font-weight:700;font-size:34px;color:var(--text);-webkit-text-stroke:7px var(--ink);paint-order:stroke fill}
.mk{position:absolute;width:52px;height:52px;border-radius:50%;background:var(--ink);color:var(--accent);font-weight:900;font-size:36px;
  line-height:52px;text-align:center;box-shadow:0 0 0 4px var(--accent);opacity:0}
#g-half{position:absolute;width:26px;border:6px solid var(--text);border-left:0;border-radius:0 14px 14px 0;opacity:0}
/* value chip, rides the fill level */
#g-chip{left:0;top:0;transform-origin:0 50%}
#g-chip .in{display:flex;flex-direction:column;align-items:flex-start;padding:10px 30px 14px;border-radius:30px;background:var(--panel);
  box-shadow:0 0 0 6px var(--ink),0 12px 0 rgba(0,0,0,.3);white-space:nowrap}
#gc-big{font-weight:900;font-size:66px;line-height:1.35;color:var(--accent)}
#gc-small{font-style:normal;font-weight:700;font-size:34px;line-height:1.3;color:var(--paneltext)}
#g-chip .in::before{content:'';position:absolute;left:-22px;top:50%;margin-top:-16px;border:16px solid transparent;border-right:20px solid var(--ink);border-left:0}
#l400{left:0;top:0;transform-origin:0 50%}
#l400 .in{display:flex;flex-direction:column;align-items:flex-start;padding:8px 28px 12px;border-radius:26px;background:var(--text);
  box-shadow:0 0 0 6px var(--ink),0 10px 0 rgba(0,0,0,.3);white-space:nowrap}
#l400 b{font-weight:900;font-size:58px;line-height:1.35;color:var(--ink)}
#l400 i{font-style:normal;font-weight:700;font-size:34px;line-height:1.3;color:var(--ink)}
/* top label: setup "4 -> 1" -> rank 4..1 -> FDA -> cta question (one pill that morphs) */
#rank{left:0;top:0;transform-origin:50% 50%}
#rank .in{display:flex;align-items:center;gap:22px;padding:10px 40px 10px 14px;border-radius:999px;background:var(--panel);
  box-shadow:0 0 0 8px var(--ink),0 14px 0 rgba(0,0,0,.35);white-space:nowrap}
#rk-num{flex:none;width:132px;height:132px;border-radius:50%;background:var(--accent);color:var(--ink);font-weight:900;font-size:100px;line-height:1;
  display:flex;align-items:center;justify-content:center;box-shadow:0 0 0 6px var(--ink)}
#rk-num span{display:block;transform:translateY(-4px)}
#rk-name{font-weight:900;line-height:1.4;color:var(--paneltext)}
#rk-name em{font-style:normal;color:var(--accent)}
#rk-sub{left:0;top:0;width:1080px;text-align:center}
#rk-sub span{display:inline-block;font-weight:900;font-size:64px;color:var(--text);-webkit-text-stroke:8px var(--ink);paint-order:stroke fill}
/* amber bottle (no label, no logo) + bolts */
#bottle{left:0;top:0;width:320px;height:440px;transform-origin:160px 400px}
#bottle svg{width:320px;height:440px;overflow:visible}
.bolt{fill:var(--accent);stroke:var(--ink);stroke-width:4;stroke-linejoin:round}
.ring{fill:none;stroke:var(--accent);stroke-width:6}
#bx path{fill:none;stroke:var(--text);stroke-width:16;stroke-linecap:round;filter:drop-shadow(0 0 0 var(--ink))}
#bx .sh{stroke:var(--ink);stroke-width:28}
/* r1_shots: 3 espresso shots poured into one big iced cup */
#cup3{left:370px;top:380px;width:560px;height:760px;transform-origin:280px 740px}
#cup3 svg{width:560px;height:760px;overflow:visible}
.ice{fill:color-mix(in srgb,var(--text) 28%,transparent);stroke:color-mix(in srgb,var(--text) 70%,transparent);stroke-width:3}
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
<div id="ep" data-layout-allow-overflow data-layout-allow-overlap>
 <div id="gauge" class="g">
  <div class="tk" id="tk0"><span>0</span><i></i></div><div class="tk" id="tk1"><span>50</span><i></i></div><div class="tk" id="tk2"><span>100</span><i></i></div>
  <div class="tk" id="tk3"><span>150</span><i></i></div><div class="tk" id="tk4"><span>200</span><i></i></div><div class="tk" id="tk5"><span>250</span><i></i></div>
  <div class="tk" id="tk6"><span>300</span><i></i></div><div class="tk" id="tk7"><span>350</span><i></i></div><div class="tk" id="tk8"><span>400</span><i></i></div>
  <div id="g-unit">มก.</div>
  <div id="g-tube">
   <div id="g-fill"><div id="g-surf"></div>
    <div class="bub" id="bb0"></div><div class="bub" id="bb1"></div><div class="bub" id="bb2"></div><div class="bub" id="bb3"></div><div class="bub" id="bb4"></div><div class="bub" id="bb5"></div>
   </div>
   <div class="mk" id="mk4">4</div><div class="mk" id="mk3">3</div><div class="mk" id="mk2">2</div>
  </div>
  <div class="gline" id="g-l50"></div><div class="gline" id="g-l400"></div>
  <div id="g-half"></div>
 </div>
 <div id="g-chip" class="g"><div class="in"><b id="gc-big"></b><i id="gc-small"></i></div></div>
 <div id="l400" class="g"><div class="in"><b>~400 มก./วัน</b><i>FDA: ผู้ใหญ่ทั่วไป</i></div></div>
 <div id="bottle" class="g"><svg viewBox="-60 -40 320 440" aria-hidden="true">
  <defs>
   <linearGradient id="bgl" x1="0" x2="1" y1="0" y2="0">
    <stop offset="0" style="stop-color:var(--amber-d)"/><stop offset=".2" style="stop-color:var(--amber-m)"/>
    <stop offset=".42" style="stop-color:var(--amber-l)"/><stop offset=".6" style="stop-color:var(--amber-m)"/>
    <stop offset=".86" style="stop-color:var(--amber-d)"/><stop offset="1" style="stop-color:var(--ink)"/></linearGradient>
   <linearGradient id="bcap" x1="0" x2="1" y1="0" y2="0">
    <stop offset="0" style="stop-color:color-mix(in srgb,var(--accent) 30%,var(--ink))"/><stop offset=".35" style="stop-color:color-mix(in srgb,var(--accent) 55%,var(--text))"/>
    <stop offset=".7" style="stop-color:color-mix(in srgb,var(--accent) 45%,var(--ink))"/><stop offset="1" style="stop-color:var(--ink)"/></linearGradient>
   <linearGradient id="bliq" x1="0" x2="0" y1="0" y2="1">
    <stop offset="0" style="stop-color:var(--ink);stop-opacity:.05"/><stop offset="1" style="stop-color:var(--ink);stop-opacity:.45"/></linearGradient>
   <clipPath id="bclip"><path d="M72,44 L128,44 L128,74 C128,98 176,108 178,146 L178,330 Q178,360 148,360 L52,360 Q22,360 22,330 L22,146 C24,108 72,98 72,74 Z"/></clipPath>
   <filter id="bsh" x="-50%" y="-200%" width="200%" height="500%"><feGaussianBlur stdDeviation="8"/></filter>
   <filter id="bglow" x="-60%" y="-60%" width="220%" height="220%"><feGaussianBlur stdDeviation="7" result="b"/><feMerge><feMergeNode in="b"/><feMergeNode in="SourceGraphic"/></feMerge></filter>
  </defs>
  <g id="brings"><ellipse class="ring" id="rg0" cx="100" cy="200" rx="120" ry="190"/><ellipse class="ring" id="rg1" cx="100" cy="200" rx="120" ry="190"/></g>
  <ellipse cx="100" cy="362" rx="96" ry="14" fill="rgba(0,0,0,.55)" filter="url(#bsh)"/>
  <path d="M72,44 L128,44 L128,74 C128,98 176,108 178,146 L178,330 Q178,360 148,360 L52,360 Q22,360 22,330 L22,146 C24,108 72,98 72,74 Z" fill="url(#bgl)"/>
  <g clip-path="url(#bclip)">
   <rect x="0" y="132" width="200" height="240" fill="url(#bliq)"/>
   <ellipse cx="100" cy="132" rx="80" ry="7" style="fill:var(--amber-l)" opacity=".7"/>
   <path d="M46,150 C40,205 40,280 48,334" fill="none" style="stroke:var(--text)" stroke-opacity=".55" stroke-width="11" stroke-linecap="round"/>
   <path d="M62,160 C58,210 58,270 62,320" fill="none" style="stroke:var(--text)" stroke-opacity=".18" stroke-width="5" stroke-linecap="round"/>
   <path d="M80,98 C66,106 50,118 44,140" fill="none" style="stroke:var(--text)" stroke-opacity=".45" stroke-width="7" stroke-linecap="round"/>
   <path d="M166,154 L168,328" fill="none" style="stroke:var(--accent)" stroke-opacity=".35" stroke-width="6" stroke-linecap="round"/>
   <rect x="20" y="342" width="160" height="20" style="fill:var(--ink)" opacity=".35"/>
  </g>
  <path d="M72,44 L128,44 L128,74 C128,98 176,108 178,146 L178,330 Q178,360 148,360 L52,360 Q22,360 22,330 L22,146 C24,108 72,98 72,74 Z" fill="none" style="stroke:var(--ink)" stroke-width="4"/>
  <rect x="64" y="2" width="72" height="46" rx="8" fill="url(#bcap)" style="stroke:var(--ink)" stroke-width="4"/>
  <path d="M76,8 V44 M88,8 V44 M100,8 V44 M112,8 V44 M124,8 V44" style="stroke:var(--ink)" stroke-opacity=".35" stroke-width="3"/>
  <rect x="64" y="40" width="72" height="8" style="fill:var(--ink)" opacity=".5"/>
  <g id="bolts" filter="url(#bglow)">
   <path class="bolt" id="bo0" d="M6,-46 L-18,4 L0,4 L-8,46 L20,-8 L2,-8 Z"/>
   <path class="bolt" id="bo1" d="M6,-46 L-18,4 L0,4 L-8,46 L20,-8 L2,-8 Z"/>
   <path class="bolt" id="bo2" d="M6,-46 L-18,4 L0,4 L-8,46 L20,-8 L2,-8 Z"/>
   <path class="bolt" id="bo3" d="M6,-46 L-18,4 L0,4 L-8,46 L20,-8 L2,-8 Z"/>
  </g>
  <g id="bx">
   <path class="sh" id="bxs0" pathLength="1" stroke-dasharray="1 1" d="M30,150 Q96,236 172,332"/>
   <path class="sh" id="bxs1" pathLength="1" stroke-dasharray="1 1" d="M172,152 Q96,240 28,334"/>
   <path id="bx0" pathLength="1" stroke-dasharray="1 1" d="M30,150 Q96,236 172,332"/>
   <path id="bx1" pathLength="1" stroke-dasharray="1 1" d="M172,152 Q96,240 28,334"/>
  </g>
 </svg></div>
 <div id="cup3" class="g"><svg viewBox="0 0 560 760" aria-hidden="true">
  <defs><clipPath id="cupc"><path d="M112,300 L448,300 L410,740 L150,740 Z"/></clipPath></defs>
  <ellipse cx="280" cy="748" rx="150" ry="16" fill="rgba(0,0,0,.5)"/>
  <path d="M112,300 L448,300 L410,740 L150,740 Z" style="fill:var(--text)" fill-opacity=".08"/>
  <g clip-path="url(#cupc)">
   <rect id="cw" x="90" y="430" width="380" height="330" style="fill:color-mix(in srgb,var(--accent2) 45%,var(--ink))" fill-opacity=".45"/>
   <rect id="cc" x="90" y="430" width="380" height="330" style="fill:var(--coffee)" fill-opacity="0"/>
   <rect id="csurf" x="90" y="430" width="380" height="8" style="fill:var(--crema)" fill-opacity=".8"/>
   <rect class="ice" id="ic0" x="150" y="420" width="96" height="90" rx="16" transform="rotate(-12 198 465)"/>
   <rect class="ice" id="ic1" x="270" y="410" width="104" height="96" rx="16" transform="rotate(9 322 458)"/>
   <rect class="ice" id="ic2" x="200" y="520" width="92" height="86" rx="16" transform="rotate(20 246 563)"/>
   <rect class="ice" id="ic3" x="310" y="540" width="80" height="78" rx="14" transform="rotate(-6 350 579)"/>
   <path d="M150,320 L176,730" style="stroke:var(--text)" stroke-opacity=".35" stroke-width="12" stroke-linecap="round"/>
  </g>
  <path d="M112,300 L448,300 L410,740 L150,740 Z" fill="none" style="stroke:var(--text)" stroke-opacity=".8" stroke-width="6" stroke-linejoin="round"/>
  <rect x="98" y="290" width="364" height="18" rx="9" style="fill:var(--text)" fill-opacity=".85"/>
  <line class="st" id="st0" x1="0" y1="0" x2="0" y2="0" style="stroke:var(--coffee)" stroke-width="12" stroke-linecap="round"/>
  <line class="st" id="st1" x1="0" y1="0" x2="0" y2="0" style="stroke:var(--coffee)" stroke-width="12" stroke-linecap="round"/>
  <line class="st" id="st2" x1="0" y1="0" x2="0" y2="0" style="stroke:var(--coffee)" stroke-width="12" stroke-linecap="round"/>
  <g id="sg0"><rect x="-36" y="-96" width="72" height="96" rx="10" style="fill:var(--text)" fill-opacity=".2"/><rect id="sq0" x="-30" y="-62" width="60" height="56" rx="6" style="fill:var(--coffee)"/><rect id="sk0" x="-30" y="-66" width="60" height="10" rx="4" style="fill:var(--crema)"/><rect x="-36" y="-96" width="72" height="96" rx="10" fill="none" style="stroke:var(--text)" stroke-opacity=".85" stroke-width="5"/></g>
  <g id="sg1"><rect x="-36" y="-96" width="72" height="96" rx="10" style="fill:var(--text)" fill-opacity=".2"/><rect id="sq1" x="-30" y="-62" width="60" height="56" rx="6" style="fill:var(--coffee)"/><rect id="sk1" x="-30" y="-66" width="60" height="10" rx="4" style="fill:var(--crema)"/><rect x="-36" y="-96" width="72" height="96" rx="10" fill="none" style="stroke:var(--text)" stroke-opacity=".85" stroke-width="5"/></g>
  <g id="sg2"><rect x="-36" y="-96" width="72" height="96" rx="10" style="fill:var(--text)" fill-opacity=".2"/><rect id="sq2" x="-30" y="-62" width="60" height="56" rx="6" style="fill:var(--coffee)"/><rect id="sk2" x="-30" y="-66" width="60" height="10" rx="4" style="fill:var(--crema)"/><rect x="-36" y="-96" width="72" height="96" rx="10" fill="none" style="stroke:var(--text)" stroke-opacity=".85" stroke-width="5"/></g>
 </svg></div>
 <div id="rk-sub" class="g"><span>น้อย → มาก</span></div>
 <div id="rank" class="g"><div class="in"><div id="rk-num"><span id="rk-n">4</span></div><div id="rk-name"></div></div></div>
<img id="r1ghost" src="assets/r1.png" alt="" style="position:absolute;left:420px;top:560px;width:600px;opacity:.3"/>
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
// EPISODE MOTION (caffeine-ranking). Shot times = shots-th.json, word times = words.json (const W); every change lands
// on a word. One gauge, one bottle, one top label: each morphs with springs, nothing pops in or out on a cut.
const W=%%WORDS%%;
const sh=id=>SC.find(s=>s.id===id);
const steps=(t,arr,w=14,z=0.72)=>{let v=arr[0][1]; for(let i=1;i<arr.length;i++) v+=(arr[i][1]-arr[i-1][1])*S(t-arr[i][0],w,z); return v;};
const wins=(t,ws,fi=0.1,fo=0.12)=>{let o=0; ws.forEach(([a,b])=>{o=Math.max(o,clamp(Math.min((t-a)/fi,(b-t)/fo)));}); return o;};
const setT=(el,s)=>{if(el.textContent!==s) el.textContent=s;};
const setH=(el,s)=>{if(el.innerHTML!==s) el.innerHTML=s;};
const pop=(t,a,w=20,z=0.55)=>t<a?0:S(t-a,w,z);
const L=sh('loop'), CTA=sh('cta');
// r1_200: the real big cup sits faded behind the gauge
(()=>{const g=$('g-r1_200'), im=$('r1ghost'); if(g&&im) g.appendChild(im);})();
// ---- still cards: parallax over the blurred backdrop; the loop copy runs backwards so the last frame = frame 0 ----
const CARDS=SC.map(s=>({s,el:$('cd-'+s.id)})).filter(c=>c.el);
function cards(t){
  CARDS.forEach(({s,el})=>{ if(t<s.a-0.05||t>s.b+0.2) return;
    let u=clamp((t-s.a)/Math.max(0.3,s.b-s.a)); if(s.beat==='loop') u=1-u;
    if(s.id==='r1'){ const p=pop(t,W.r1,15,0.5);   // reveal: the cup lands on "อันดับหนึ่ง"
      el.style.transform=`translateY(${f2(-24*u+40*(1-clamp(p,0,1.2)))}px) scale(${(0.86+0.14*p+0.05*u).toFixed(4)})`; return; }
    el.style.transform=`translateY(${f2(-30*u)}px) rotate(${((u-0.5)*1.4).toFixed(3)}deg) scale(${(1+0.07*u).toFixed(4)})`; });
}
// ---- gauge ----
const BIG={setup:1,r3:1,r3_belief:1,r3_rule:1,r3_punch:1,r2_num:1,r2_pass:1,r1_shots:1,r1_200:1,fda:1,share:1,share_half:1};
const KARR=[[0,1]]; SC.forEach(s=>{const k=BIG[s.id]?1:0; if(k!==KARR[KARR.length-1][1]) KARR.push([s.a,k]);});
const GB={x:190,y:470,w:160,h:620}, GS={x:190,y:560,w:100,h:500};
const VARR=[[0,0],[W.n34,34],[W.rule,50],[W.n60,60],[W.n200,200]];
const MARR=[[0,100],[W.n200,250],[W.usa,450]];
const GA=sh('setup').a+0.04;
const tks=[0,1,2,3,4,5,6,7,8].map(i=>$('tk'+i)), bubs=[0,1,2,3,4,5].map(i=>$('bb'+i));
let G={x:0,y:0,w:0,h:0,v:0,m:100};
function gauge(t){
  const k=clamp(steps(t,KARR,15,0.8),-0.1,1.1), x=lerp(GS.x,GB.x,k), y=lerp(GS.y,GB.y,k), w=lerp(GS.w,GB.w,k), h=lerp(GS.h,GB.h,k);
  const v=Math.max(0,steps(t,VARR,9,0.85)), m=steps(t,MARR,7,0.9);
  G={x,y,w,h,v,m};
  const gin=t<GA?0:S(t-GA,15,0.62), gout=eio((t-CTA.a)/0.26), on=clamp(gin*1.4)*(1-gout);
  const g=$('gauge'); g.style.opacity=f2(clamp((t-GA)/0.08)*(1-gout));
  g.style.transformOrigin=`${f2(x+w/2)}px ${f2(y+h)}px`; g.style.transform=`scaleY(${(clamp(gin,0,1.2)*(1-gout)).toFixed(4)})`;
  const tb=$('g-tube'); tb.style.left=f2(x)+'px'; tb.style.top=f2(y)+'px'; tb.style.width=f2(w)+'px'; tb.style.height=f2(h)+'px';
  const fh=h*clamp(v/m,0,1); $('g-fill').style.height=f2(fh)+'px';
  tks.forEach((el,i)=>{const val=i*50, yy=y+h-h*val/m; el.style.left=f2(x-124)+'px'; el.style.top=f2(yy-17)+'px';
    el.style.opacity=f2(clamp(1-(val-m)/(0.08*m)));});
  const u=$('g-unit'); u.style.left=f2(x+w/2-34)+'px'; u.style.top=f2(y-58)+'px';
  bubs.forEach((b,i)=>{const sp=70+i*17, rise=(t*sp+i*131)%(Math.max(40,fh)+30), sz=9+(i%3)*5;
    b.style.width=b.style.height=sz+'px'; b.style.left=f2(12+((i*41)%Math.max(20,w-40))+7*Math.sin(t*3+i))+'px';
    b.style.bottom=f2(rise-20)+'px'; b.style.opacity=f2(fh>40?0.8:0);});
  // earlier ranks stay as notches on the tube (gone once the scale stretches for the big cup)
  [['mk4',34,sh('r3').a],['mk3',50,sh('r2').a],['mk2',60,sh('r1').a]].forEach(([id,val,a])=>{const el=$(id), p=pop(t,a,18,0.55);
    el.style.opacity=f2(clamp((t-a)/0.1)*clamp(1-(m-110)/40)); el.style.left='10px'; el.style.top=f2(h-h*val/m-26)+'px';
    el.style.transform=`scale(${(0.4+0.6*clamp(p,0,1.2)).toFixed(3)})`;});
  // ceiling 50 (the bottle's rule), reaches across to the bottle; flashes when the espresso passes it
  const l5=$('g-l50'), y50=y+h-h*50/m, ext=lerp(0,390,eio((t-W.rule)/0.3));
  l5.style.left=f2(x-14)+'px'; l5.style.top=f2(y50-3)+'px'; l5.style.width=f2(w+28+ext)+'px';
  l5.style.opacity=f2(clamp((t-W.rule+0.05)/0.12)*(1-clamp((t-R1)/0.15))*(t>W.pass&&t<W.pass+0.6?0.55+0.45*Math.cos((t-W.pass)*30):1));
  const l4=$('g-l400'), y400=y+h-h*400/m; l4.style.left=f2(x-14)+'px'; l4.style.top=f2(y400-3)+'px'; l4.style.width=f2(w+28)+'px';
  l4.style.opacity=f2(clamp((t-W.adult)/0.15)*(0.75+0.25*Math.sin(t*5)));
  const hb=$('g-half'), y200=y+h-h*200/m; hb.style.left=f2(x+w+10)+'px'; hb.style.top=f2(y200)+'px'; hb.style.height=f2(y+h-y200)+'px';
  hb.style.opacity=f2(clamp((t-W.half)/0.15)); hb.style.transform=`scaleY(${eo((t-W.half)/0.3).toFixed(3)})`; hb.style.transformOrigin='0 100%';
  // 400 label rides the 400 line
  const lb=$('l400'), lp=pop(t,W.adult,18,0.55);
  lb.style.opacity=f2(clamp((t-W.adult)/0.08)*(1-gout));
  lb.style.transform=`translate(${f2(x+w+40)}px,${f2(y400-lb.offsetHeight/2)}px) scale(${(0.5+0.5*clamp(lp,0,1.2)).toFixed(4)})`;
}
// ---- value chip: one pill that rides the fill level; the running number stops on the spoken number ----
const R4=sh('r3').a, R2=sh('r2').a, R1=sh('r1').a;
function chip(t){
  const {x,y,w,h,v,m}=G; let big='', small='', tc=0, on=wins(t,[[W.n34,R4],[W.rule,R2],[W.n60,R1],[W.n200,CTA.a]]);
  const run=(a,from,to,lab)=>t<a+0.62?`ราว ${Math.max(from,Math.min(to,Math.round(v/5)*5))}`:lab;
  if(t>=W.n200){ tc=W.n200; big=run(W.n200,60,200,'ราว 200 มก.'); small='บางร้าน 3 ช็อต';
    if(t>=W.half){ tc=W.half; big='แก้วเดียว<br>≈ เกือบครึ่ง'; small='ของ ~400 มก./วัน'; } }
  else if(t>=W.n60){ tc=W.n60; big=run(W.n60,50,60,'ราว 60 มก.'); small='เอสเพรสโซ่ 1 ช็อต';
    if(t>=W.pass){ tc=W.pass; small='แซงเกณฑ์ขวด (≤ 50)'; } }
  else if(t>=W.rule){ tc=W.rule; big='≤ 50 มก./ขวด'; small='เกณฑ์ อย. · คำสั่ง 185/2534'; }
  else { tc=W.n34; big=t<W.n34+0.62?`ราว ${Math.min(30,Math.round(v/5)*5)}`:'ราว 30+ มก.'; small='โคล่า 1 กระป๋อง'; }
  setH($('gc-big'),big); setT($('gc-small'),small);
  const el=$('g-chip'), ch=el.offsetHeight||130, fy=y+h-h*clamp(v/m,0,1);
  const top=(tc===W.rule)?fy-ch-12:clamp(fy-ch/2,y-50,y+h-ch+40), p=pop(t,tc,20,0.55);
  el.style.opacity=f2(on);
  el.style.filter=`blur(${f2(8*(1-clamp((t-tc)/0.15)))}px)`;
  el.style.transform=`translate(${f2(x+w+34)}px,${f2(top)}px) scale(${(0.6+0.4*clamp(p,0,1.15)).toFixed(4)})`;
}
// ---- top label: setup "4 -> 1" -> rank 4..1 -> FDA -> cta question ----
const RK=[[W.set,'',`4 → 1`,140],[W.r4,'4','โคล่า',96],[W.r3,'3','ชูกำลังขวดเล็ก',84],[W.r2,'2','เอสเพรสโซ่ 1 ช็อต',80],
  [W.r1,'1','อเมริกาโน่เย็นแก้วใหญ่',66],[W.usa,'','อย. สหรัฐฯ (FDA)',76],[W.cta,'','วันนี้<em>กี่แก้ว</em>แล้ว?',96]];
const RX=[[0,640],[W.r4,540]], RY=[[0,780],[W.r4,322],[W.cta,330]];
function rank(t){
  let cur=null; RK.forEach(r=>{if(t>=r[0]) cur=r;}); const el=$('rank');
  if(!cur){ el.style.opacity='0'; $('rk-sub').style.opacity='0'; return; }
  const [tc,n,name,size]=cur; setT($('rk-n'),n||'1'); setH($('rk-name'),name);
  $('rk-num').style.display=n?'flex':'none'; $('rk-name').style.fontSize=size+'px';
  $('rank').querySelector('.in').style.paddingLeft=n?'14px':'44px';
  const p=pop(t,tc,20,0.5), big=(tc===W.r1)?1+0.22*Math.exp(-3*(t-tc))*(1-clamp((t-tc)/1.2)):1;
  const x=steps(t,RX,14,0.75), y=steps(t,RY,14,0.75), br=1+0.012*Math.sin((t-tc)*4);
  el.style.opacity=f2(clamp((t-W.set)/0.08)*(1-clamp((t-L.a)/0.15)));
  el.style.filter=`blur(${f2(9*(1-clamp((t-tc)/0.14)))}px)`;
  el.style.transform=`translate(${f2(x)}px,${f2(y)}px) translate(-50%,-50%) scale(${((0.7+0.3*clamp(p,0,1.15))*big*br).toFixed(4)})`;
  $('rk-num').style.transform=`rotate(${f2(-100*(1-clamp(p,0,1)))}deg)`;
  const sb=$('rk-sub'), sp=pop(t,W.many,18,0.55);
  sb.style.opacity=f2(clamp((t-W.many)/0.08)*(1-clamp((t-W.r4)/0.12)));
  sb.style.transform=`translate(100px,${f2(900+30*(1-clamp(sp,0,1.1)))}px)`;
}
// ---- amber bottle (no label): hook -> gone -> rank 3 (belief bolts) -> beside the gauge, shrinks on "ชื่อดูแรง" ----
const R3=sh('r3'), RR=sh('r3_rule'), R2N=sh('r2_num'), R2P=sh('r2_punch'), R2S=sh('r2_pass');
const BX=[[0,245],[1.4,540],[R3.a,720],[RR.a,800],[W.name,790],[L.a,245]];
const BY=[[0,1095],[1.4,1090],[R3.a,1050],[RR.a,1100],[W.name,1100],[L.a,1095]];
const BS=[[0,1.0],[1.4,1.2],[3.16,0.6],[R3.a,0.4],[W.r3,1.45],[RR.a,0.9],[W.name,0.66],[L.a-0.02,0.6],[L.a,1.0]];
const BOLT=[[-40,150,-18],[238,104,16],[12,-10,-34],[236,272,12]];
function bottle(t){
  const el=$('bottle');
  const o=wins(t,[[W.r3,R2],[R2N.a,R2P.a],[R2S.a,R1],[L.a,99]],0.1,0.12);
  const o0=t<3.16?1:clamp(1-(t-3.16)/0.18);
  const op=Math.max(t<3.4?o0:0,o);
  const x=steps(t,BX,14,0.7), y=steps(t,BY,14,0.7), s=steps(t,BS,15,0.6), bob=(t<1.4?0:6*Math.sin(t*2.3));
  el.style.opacity=f2(op);
  el.style.transform=`translate(${f2(x-160)}px,${f2(y-400+bob)}px) scale(${Math.max(0.01,s).toFixed(4)}) rotate(${f2(1.5*Math.sin(t*1.7))}deg)`;
  // bolts: crackle in hook_bottle and die on "ชูกำลัง"; belief bolts at rank 3; shrink away on "ชื่อดูแรง"
  let bi=0;
  if(t>=1.4&&t<3.2) bi=clamp((t-1.4)/0.1)*(1-clamp((t-W.xb)/0.3));
  if(t>=W.bel-0.1&&t<23) bi=lerp(0,1,eo((t-W.bel)/0.2))+0.35*eo((t-W.bel2)/0.2)-0.45*eio((t-RR.a)/0.3)-0.9*eio((t-W.name)/0.35);
  bi=clamp(bi,0,1.4);
  BOLT.forEach(([bx,by,r],i)=>{const e=$('bo'+i), fl=Math.sin(t*41+i*2.3)>-0.35?1:0.25, sc=bi*(0.9+0.15*Math.sin(t*30+i*1.7));
    e.setAttribute('transform',`translate(${bx} ${by}) rotate(${r+6*Math.sin(t*9+i)}) scale(${Math.max(0.001,sc).toFixed(3)})`);
    e.style.opacity=f2(clamp(bi)*fl);});
  [0,1].forEach(i=>{const e=$('rg'+i), p=((t*1.3)+i*0.5)%1;
    e.setAttribute('transform',`translate(100 200) scale(${(0.75+0.55*p).toFixed(3)}) translate(-100 -200)`);
    e.style.opacity=f2((1-p)*0.6*clamp(bi));});
  // hand-drawn X: drawn at frame 0, redrawn on "ชูกำลัง", gone at rank 3, redrawn in the loop (last frame = frame 0)
  let d; if(t<1.4) d=1; else if(t<W.xb) d=0; else if(t<R3.a) d=eio((t-W.xb)/0.3); else if(t<L.a) d=0; else d=eio((t-L.a-0.1)/0.3);
  const d0=clamp(d*2), d1=clamp(d*2-1);
  [['bx0',d0],['bxs0',d0],['bx1',d1],['bxs1',d1]].forEach(([id,dd])=>{$(id).style.strokeDashoffset=(1-dd).toFixed(4);
    $(id).style.opacity=dd>0.001?'1':'0';});
}
// ---- r1_shots: three espresso shots poured one by one on "สามช็อต" ----
const RS=sh('r1_shots'), R12=sh('r1_200');
const P=[0,1,2].map(i=>W.s3+i*0.17);
function cup3(t){
  const el=$('cup3'); if(t<RS.a-0.1||t>R12.a+0.3){ el.style.opacity='0'; return; }
  const p=pop(t,RS.a,16,0.6);
  el.style.opacity=f2(clamp((t-RS.a)/0.08)*(1-clamp((t-R12.a)/0.12)));
  el.style.transform=`translateY(${f2(60*(1-clamp(p,0,1.1))+5*Math.sin(t*2))}px) scale(${(0.8+0.2*clamp(p,0,1.1)).toFixed(4)})`;
  const lvl=steps(t,[[0,440],[P[0]+0.08,408],[P[1]+0.08,378],[P[2]+0.08,350]],16,0.8);
  const dk=steps(t,[[0,0],[P[0]+0.08,0.4],[P[1]+0.08,0.65],[P[2]+0.08,0.85]],16,0.9);
  ['cw','cc','csurf'].forEach(id=>$(id).setAttribute('y',f2(lvl)));
  $('cc').setAttribute('fill-opacity',f2(clamp(dk)));
  [0,1,2].forEach(i=>{
    const a0=RS.a+0.06+i*0.09, ap=pop(t,a0,18,0.55), pi=P[i];
    const hx=150+i*130, hy=215, px=190+i*55, py=236;
    const mv=eio((t-(pi-0.28))/0.2), tilt=118*eio((t-(pi-0.12))/0.14), gone=eio((t-(pi+0.26))/0.18);
    const gx=lerp(hx,px,mv), gy=lerp(hy,py,mv)-60*gone;
    const g=$('sg'+i);
    g.setAttribute('transform',`translate(${f2(gx)} ${f2(gy+40*(1-clamp(ap,0,1.1)))}) scale(1.4) rotate(${f2(tilt)} 0 -48)`);
    g.style.opacity=f2(clamp((t-a0)/0.06)*(1-gone));
    const left=1-clamp((t-pi)/0.22); $('sq'+i).setAttribute('height',f2(56*left)); $('sq'+i).setAttribute('y',f2(-6-56*left));
    $('sk'+i).style.opacity=f2(left>0.05?1:0); $('sk'+i).setAttribute('y',f2(-10-56*left));
    const st=$('st'+i), son=t>=pi-0.02&&t<pi+0.24;
    const lx=gx+36, ly=gy+9;
    st.setAttribute('x1',f2(lx)); st.setAttribute('y1',f2(ly)); st.setAttribute('x2',f2(lx+4)); st.setAttribute('y2',f2(lvl));
    st.style.opacity=son?'1':'0';
  });
}
function episode(t){ cards(t); gauge(t); chip(t); rank(t); bottle(t); cup3(t); }
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
