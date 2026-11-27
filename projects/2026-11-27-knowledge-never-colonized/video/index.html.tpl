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
/* never-colonized: every colour is a palette variable; neighbours stay neutral (no blame red), Thailand = accent */
#root{--landbg:color-mix(in srgb,var(--bg2) 42%,var(--bg));--landcol:color-mix(in srgb,var(--bg2) 72%,var(--ink) 28%);
  --uk:color-mix(in srgb,var(--accent2) 45%,var(--bg2));--fr:color-mix(in srgb,var(--bg2) 62%,var(--ink) 38%)}
.card{position:absolute;border-radius:30px;overflow:hidden;box-shadow:0 0 0 8px var(--ink),0 30px 70px rgba(0,0,0,.6);transform-origin:50% 50%}
.card img{width:100%;height:100%;object-fit:cover;display:block}
.gfill{position:absolute;left:0;top:0;width:1080px;height:1920px;overflow:hidden}
.mapbg{background:var(--bg)}
.mgrid{position:absolute;left:-60px;top:-60px;width:1200px;height:2040px;opacity:.55;
  background-image:linear-gradient(color-mix(in srgb,var(--bg2) 60%,transparent) 2px,transparent 2px),linear-gradient(90deg,color-mix(in srgb,var(--bg2) 60%,transparent) 2px,transparent 2px);background-size:120px 120px}
.mapw{position:absolute;left:0;top:0;width:1080px;height:1150px;transform-origin:0 0}
.wmap{height:700px}
.msvg{position:absolute;left:0;top:0;overflow:visible}
.msvg .lb{fill:var(--landbg);stroke:var(--bg);stroke-width:2.5}
.msvg .lc{fill:var(--landcol);stroke:var(--bg);stroke-width:2.5}
.msvg .lw{fill:var(--accent2);stroke:var(--ink);stroke-width:2.5}
.msvg .luk{fill:var(--uk);stroke:var(--bg);stroke-width:2.5}
.msvg .lfr{fill:var(--fr);stroke:var(--bg);stroke-width:2.5}
.msvg .th{fill:var(--accent);stroke:var(--ink);stroke-width:4;stroke-linejoin:round}
.msvg .thg{fill:var(--accent);opacity:.75}
.msvg .crack{fill:none;stroke:var(--ink);stroke-width:7;stroke-linecap:round;stroke-linejoin:round;stroke-dasharray:1 1;stroke-dashoffset:1}
.msvg .ahd{fill:var(--ink);transform-box:fill-box;transform-origin:50% 50%}
.msvg .ash{fill:none;stroke:var(--ink);stroke-width:16;stroke-linecap:round;stroke-dasharray:1 1;stroke-dashoffset:1}
.piece{transform-box:fill-box;transform-origin:50% 50%}
.mlbl{position:absolute;white-space:nowrap;transform-origin:50% 100%}
.mlbl span{display:block;font-weight:700;font-size:40px;line-height:1.3;padding:2px 20px 6px;border-radius:999px;box-shadow:0 0 0 4px var(--ink),0 6px 0 rgba(0,0,0,.25)}
.mlbl.uk span{background:var(--uk);color:var(--ink)}
.mlbl.fr span{background:var(--fr);color:var(--text)}
.mlbl.nm span{background:var(--panel);color:var(--paneltext);font-size:38px}
.pin{position:absolute;width:72px;height:84px;transform-origin:50% 100%}
.pin svg{width:72px;height:72px;overflow:visible}
.pin .pb{fill:var(--accent2);stroke:var(--ink);stroke-width:1.6}
.pin .pc{fill:var(--panel)}
.pin.pth .pb{fill:var(--accent)}
.qpin,.qb{position:absolute;width:92px;height:92px;border-radius:50%;background:var(--panel);box-shadow:0 0 0 6px var(--ink),0 8px 0 rgba(0,0,0,.25);
  display:flex;align-items:center;justify-content:center;font-weight:900;font-size:66px;color:var(--accent2)}
.qpin span,.qb span{display:block;line-height:1;transform:translateY(-3px)}
.qrow{position:absolute;left:0;top:1330px;width:1080px;height:120px;display:flex;justify-content:center;gap:54px}
.qb{position:relative;width:110px;height:110px;font-size:80px}
.dim{position:absolute;left:0;top:0;width:1080px;height:1920px;background:color-mix(in srgb,var(--ink) 45%,transparent)}
.defcard{position:absolute;left:90px;top:560px;width:900px;padding:34px 30px 44px;border-radius:40px;background:var(--panel);
  box-shadow:0 0 0 8px var(--ink),0 26px 60px rgba(0,0,0,.45);text-align:center;color:var(--paneltext);font-weight:700;opacity:0}
.defcard .d1{font-size:52px;line-height:1.4;color:var(--accent2)}
.defcard .d2{font-size:84px;line-height:1.45;font-weight:900}
.defcard .d3{font-size:84px;line-height:1.5;font-weight:900}
.defcard em{font-style:normal;display:inline-block;padding:.1em 20px .14em;border-radius:18px;background-image:linear-gradient(var(--accent),var(--accent));background-repeat:no-repeat;background-size:0% 100%}
.ctaq{position:absolute;left:0;top:300px;width:1080px;text-align:center;opacity:0}
.ctaq span{display:inline-block;font-weight:900;font-size:104px;line-height:1.4;color:var(--ink);background:var(--accent);padding:.08em 40px .04em;border-radius:28px;box-shadow:0 0 0 8px var(--ink),0 12px 0 rgba(0,0,0,.3)}
.approx{position:absolute;left:0;top:1420px;width:1080px;text-align:center;opacity:0}
.approx span{display:inline-block;font-weight:700;font-size:38px;color:var(--paneltext);background:var(--panel);padding:4px 24px 8px;border-radius:999px;box-shadow:0 0 0 4px var(--ink)}
#ep{position:absolute;left:0;top:0;width:1080px;height:1920px;z-index:30;pointer-events:none}
#ep .g{position:absolute;opacity:0}
#zmap{left:0;top:0;width:1080px;height:1920px;background:var(--bg);overflow:hidden}
.out{-webkit-text-stroke:.14em var(--ink);paint-order:stroke fill;white-space:nowrap}
#rshade{left:0;top:0;width:1080px;height:760px;background:linear-gradient(color-mix(in srgb,var(--ink) 72%,transparent),color-mix(in srgb,var(--ink) 40%,transparent) 60%,transparent)}
#rank{left:60px;top:236px;width:960px;height:170px;display:flex;align-items:center;justify-content:center;gap:30px;transform-origin:50% 50%}
#rk-num{flex:none;width:156px;height:156px;border-radius:50%;background:var(--accent);color:var(--ink);font-weight:900;font-size:118px;line-height:1;
  display:flex;align-items:center;justify-content:center;box-shadow:0 0 0 9px var(--ink),0 12px 0 rgba(0,0,0,.35)}
#rk-num span{display:block;transform:translateY(-5px)}
#rk-name{font-weight:900;font-size:110px;line-height:1.4;color:var(--text)}
.chip{left:0;width:1080px;display:flex;justify-content:center}
.chip span{display:inline-block;text-align:center;font-weight:700;font-size:50px;line-height:1.38;padding:10px 36px 14px;border-radius:30px;
  color:var(--paneltext);background:var(--panel);box-shadow:0 0 0 6px var(--ink),0 10px 0 rgba(0,0,0,.3);white-space:nowrap}
.chip span b{font-weight:900;color:var(--accent2)}
#stamp{left:0;top:1310px;width:1080px;display:flex;justify-content:center;align-items:center;gap:0}
#stamp{color:var(--text)}
#stamp svg{width:84px;height:84px;flex:none;background:var(--accent2);border-radius:50%;padding:10px;box-shadow:0 0 0 6px var(--ink);margin-right:-14px;position:relative;z-index:1}
#stamp span{display:inline-block;font-weight:900;font-size:72px;line-height:1.4;padding:4px 36px 10px 40px;border-radius:24px;background:var(--accent2);color:var(--text);box-shadow:0 0 0 7px var(--ink),0 10px 0 rgba(0,0,0,.3)}
#bigtop{left:0;top:270px;width:1080px;text-align:center}
#bigtop span{display:inline-block;font-weight:900;font-size:108px;line-height:1.4;color:var(--ink);background:var(--accent);padding:.06em 44px .02em;border-radius:28px;box-shadow:0 0 0 8px var(--ink),0 12px 0 rgba(0,0,0,.3)}
#bigq{left:390px;top:640px;width:300px;height:400px;text-align:center;font-weight:900;font-size:380px;line-height:1;color:var(--accent);-webkit-text-stroke:.06em var(--ink);paint-order:stroke fill}
#tai{left:0;top:470px;width:1080px;height:560px;display:flex;flex-direction:column;align-items:center}
#tai1{font-weight:900;font-size:250px;line-height:1.3;color:var(--text)}
#tai2{font-weight:900;font-size:110px;line-height:.9;color:var(--text)}
#tai3{font-weight:900;font-size:190px;line-height:1.4;color:var(--accent)}
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
<!--EPISODE_GFX-->
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
// EPISODE MOTION (never-colonized). Word times from words.json, shot times from shots-th.json; every change lands on a word.
['hook','loop','guess','guess_def','cta','tw_malay'].forEach(id=>{const g=$('g-'+id), x=$('gx-'+id); if(g&&x) g.appendChild(x);});
const win=(t,a,b,fi=0.12,fo=0.12)=>clamp(Math.min((t-a)/fi,(b-t)/fo));
const show=(el,o,tr)=>{el.style.opacity=f2(clamp(o)); if(tr!==undefined) el.style.transform=tr;};
const pop=(t,a,w=20,z=0.55)=>t<a?0:S(t-a,w,z);
const setH=(el,s)=>{if(el.innerHTML!==s) el.innerHTML=s;};
const mapT=(el,s,px,py,X,Y)=>{el.style.transform=`translate(${f2(X-s*px)}px,${f2(Y-s*py)}px) scale(${s.toFixed(4)})`;};
const shotAt=id=>SC.find(s=>s.id===id);
// still cards: parallax layer over the blurred backdrop
const CARDS=SC.map(s=>({s,el:$('cd-'+s.id)})).filter(c=>c.el);
function cards(t){
  CARDS.forEach(({s,el})=>{ if(t<s.a-0.05||t>s.b+0.2) return;
    const u=clamp((t-s.a)/Math.max(0.3,s.b-s.a));
    el.style.transform=`translateY(${f2(-30*u)}px) rotate(${((u-0.5)*1.4).toFixed(3)}deg) scale(${(1+0.07*u).toFixed(4)})`; });
}
// ---- SEA map (hook, and the loop shot plays it backwards so the last frame = frame 0) ----
const TH=[313.7,414], HX=540, HY=1000, HS=1.3;
function seaState(sid,tau){
  const z=eio((tau-0.86)/0.42), s=HS*(1+1.2*z);
  mapT($(sid+'-w'),s,TH[0],TH[1]+40*z,HX,HY+40*z);
  $(sid+'-glow').style.opacity=f2(0.5+0.4*Math.cos(2*Math.PI*tau/1.6));
  for(let i=0;i<5;i++){ const l=$(sid+'-l'+i); l.style.transform=`translateY(${f2(-5*Math.sin(2*Math.PI*tau/1.4+i*1.3)+5*Math.sin(i*1.3))}px)`; l.style.opacity=f2(1-z); }
}
function seaGfx(t){
  if(t<1.5) seaState('hook',t);
  const L=shotAt('loop'); if(t>=L.a-0.2) seaState('loop',Math.max(0,1.28*(DUR-t)/(DUR-L.a)));
}
// ---- WORLD map: guess (Thailand pinned, 4 floating ?), definition card, cta (5 pins + ?6) ----
const WY=520;
function worldState(sid,t,a,px=608){
  const u=t-a; mapT($(sid+'-w'),1+0.012*u,px,470,540+12*Math.sin(u*0.9),WY+470+6*Math.sin(u*1.1));
}
function guessGfx(t){
  if(t>=3.0&&t<=6.9){
    worldState('guess',t,3.1); worldState('guess_def',t,3.1);
    ['guess','guess_def'].forEach(sid=>{
      const p=$(sid+'-pth'); p.style.transform=`translateY(${f2(-8*Math.abs(Math.sin((t-3.1)*3.2)))}px)`;
      for(let i=0;i<4;i++){ const ta=4.36+i*0.14, el=$(sid+'-q'+i), a=sid==='guess'?pop(t,ta):1;
        el.style.opacity=f2(sid==='guess'?clamp((t-ta)/0.06):1);
        el.style.transform=`translateY(${f2(-60*(1-clamp(a,0,1.2))+8*Math.sin((t-ta)*4+i))}px) rotate(${f2(8*Math.sin((t-ta)*3+i*2))}deg) scale(${(0.5+0.5*clamp(a,0,1.2)).toFixed(3)})`; } });
    const d=$('g-guess_def').querySelector('.dim'); d.style.opacity=f2(clamp((t-5.6)/0.12));
    const c=pop(t,5.68); show($('defcard'),clamp((t-5.68)/0.06),`translateY(${f2(30*(1-c)+(t>5.9?-6*Math.sin((t-5.9)*2.4):0))}px) scale(${(0.8+0.2*clamp(c,0,1.1)).toFixed(4)})`);
    $('def-hl').style.backgroundSize=`${(100*eo((t-6.2)/0.25)).toFixed(1)}% 100%`;
  }
  // guess_q: one big ? over the NASA globe
  const qa=6.84, q=pop(t,qa,16,0.45);
  show($('bigq'),win(t,qa,8.0,0.06,0.1),`rotate(${f2(10*Math.sin((t-qa)*5))}deg) scale(${((0.4+0.6*clamp(q,0,1.2))*(1+0.04*Math.sin((t-qa)*8))).toFixed(4)})`);
}
function ctaGfx(t){
  const C=shotAt('cta'); if(t<C.a-0.2||t>C.b+0.2) return;
  worldState('cta',t,C.a,566);
  ['th','bt','np','ir','jp'].forEach((k,i)=>{ const ta=C.a+0.02+i*0.06, a=pop(t,ta,22,0.5), p=$('cta-p'+k), n=$('cta-n'+k);
    p.style.opacity=f2(clamp((t-ta)/0.05)); p.style.transform=`translateY(${f2(-70*(1-clamp(a,0,1.2))-6*Math.abs(Math.sin((t-ta)*3+i)))}px)`;
    n.style.opacity=f2(clamp((t-ta-0.08)/0.08)); });
  const qa=46.0, q=pop(t,qa,18,0.4);
  show($('cta-q6'),clamp((t-qa)/0.05),`translateY(${f2(-10*Math.sin((t-qa)*4))}px) rotate(${f2(14*Math.sin((t-qa)*5))}deg) scale(${(0.3+0.7*clamp(q,0,1.25)).toFixed(3)})`);
  const ca=45.54, c=pop(t,ca);
  show($('ctaq'),clamp((t-ca)/0.06),`translateY(${f2(-4*Math.sin((t-ca)*3))}px) scale(${(0.6+0.4*clamp(c,0,1.15)).toFixed(4)})`);
}
// ---- rank badge: ONE piece, the number flips 5 -> 1 on "อันดับ...", the name lands on the spoken name; #1 biggest ----
const R=[{n:5,name:'ภูฏาน',a:8.08,na:9.0},{n:4,name:'เนปาล',a:14.38,na:15.30},{n:3,name:'อิหร่าน',a:19.56,na:20.42},
         {n:2,name:'ญี่ปุ่น',a:24.92,na:25.74},{n:1,name:'ไทย',a:30.70,na:31.48}];
function rankGfx(t){
  const on=win(t,8.0,35.36,0.1,0.12); show($('rshade'),on*0.9);
  let k=0; R.forEach((r,i)=>{if(t>=r.a) k=i;}); const r=R[k];
  if(on<=0){ show($('rank'),0); return; }
  const one=r.n===1, fl=one?pop(t,r.a,13,0.32):pop(t,r.a,20,0.5);
  $('rk-n').textContent=String(r.n);
  const big=one?lerp(1,1.45,clamp(fl,0,1.3)):1, br=1+0.015*Math.sin((t-r.a)*4);
  show($('rank'),on,`scale(${(big*br).toFixed(4)})`);
  $('rk-num').style.transform=`scale(${(0.5+0.5*fl).toFixed(4)}) rotate(${f2(-120*(1-clamp(fl,0,1)))}deg)`;
  const nm=pop(t,r.na); $('rk-name').textContent=r.name;
  $('rk-name').style.opacity=f2(clamp((t-r.na)/0.08)); $('rk-name').style.transform=`translateX(${f2(70*(1-nm))}px)`;
}
// ---- year chips (พ.ศ. only, text from the brief) + one check stamp ----
const CA=[[11.94,14.30,'<b>พ.ศ. 2453</b> สนธิสัญญาปุนาคา<br>ฟังอังกฤษเรื่องต่างประเทศ',470],
  [16.46,17.80,'<b>พ.ศ. 2357-2359</b><br>แพ้สงครามอังกฤษ เสียดินแดน',470],
  [21.98,24.84,'<b>พ.ศ. 2450</b> ถูกแบ่งเขตอิทธิพล',470],
  [27.38,30.62,'<b>พ.ศ. 2488-2495</b><br>ถูกยึดครอง ~7 ปี',470],
  [33.96,35.36,'<b>สมัยรัชกาลที่ 5</b><br>(พ.ศ. 2411-2453)',470],
  [40.34,41.24,'<b>พ.ศ. 2436</b><br>ฝั่งซ้ายโขง → ฝรั่งเศส',290],
  [41.32,42.84,'<b>พ.ศ. 2452</b><br>หัวเมืองมลายู → อังกฤษ',290]];
const CB=[[22.40,24.84,'<b>พ.ศ. 2484-2489</b> ถูกยึดครอง',590]];
const ST=[[17.88,19.48,'ยังเป็นเอกราช'],[23.02,24.84,'ไม่เคยเป็นอาณานิคม'],[29.02,30.62,'ไม่ใช่อาณานิคม']];
function chip(id,L,t){
  const el=$(id); let c=null; L.forEach(x=>{if(t>=x[0]-0.01&&t<x[1]+0.13) c=x;});
  if(!c){ show(el,0); return; }
  setH($(id+'-t'),c[2]); el.style.top=c[3]+'px';
  const a=pop(t,c[0]); show(el,win(t,c[0],c[1],0.06,0.12),`translateY(${f2(-3*Math.sin((t-c[0])*2.5))}px) scale(${(0.6+0.4*clamp(a,0,1.15)).toFixed(4)})`);
}
function stamp(t){
  let c=null; ST.forEach(x=>{if(t>=x[0]-0.01&&t<x[1]+0.13) c=x;});
  if(!c){ show($('stamp'),0); return; }
  $('stamp-t').textContent=c[2]; const a=pop(t,c[0],18,0.45);
  show($('stamp'),win(t,c[0],c[1],0.05,0.12),`rotate(${f2(-3-6*(1-clamp(a,0,1)))}deg) scale(${((1.5-0.5*clamp(a,0,1.15))*(1+0.012*Math.sin((t-c[0])*5))).toFixed(4)})`);
}
// ---- r1c + tw: ONE zoom map in the #ep layer (no cut between them): Britain / France push, Thailand holds; then it cracks ----
const ZC=[492,500];
function zoomGfx(t){
  const a=35.36, e=40.26; const el=$('zmap');
  if(t<a-0.01||t>e+0.13){ el.style.opacity='0'; $('bigtop').style.opacity='0'; return; }
  const out=t>=e?eo((t-e)/0.12):0;
  el.style.opacity=f2(clamp((t-a)/0.1)); el.style.transform=`translateX(${f2(-1080*out)}px)`;
  const u=clamp((t-a)/(e-a)), s=0.92+0.06*eio(u);
  mapT($('zm-w'),s,ZC[0],ZC[1],540,450+0.92*(ZC[1]-153));
  // arrows: Britain (west + south) on "อังกฤษ", France (east) on "ฝรั่งเศส"; tips stop at the border, then press (balance)
  [['aw',36.46,1,0],['as',36.50,0,-1],['ae',36.82,-1,0]].forEach(([k,ta,dx,dy],i)=>{
    const g=$('zm-'+k), d=eo((t-ta)/0.3), sh=g.querySelector('.ash'), hd=$('zm-'+k+'h');
    sh.style.strokeDashoffset=(1-d).toFixed(4);
    const press=t>ta+0.3?5*Math.sin((t-ta-0.3)*7+i):0, fade=t>=37.98?1-0.6*clamp((t-37.98)/0.3):1;
    g.style.transform=`translate(${f2(dx*press)}px,${f2(dy*press)}px)`; g.style.opacity=f2((t>=ta?1:0)*fade);
    hd.style.transform=`scale(${clamp((t-ta-0.22)/0.1).toFixed(3)})`; });
  ['zm-luk1','zm-luk2'].forEach(id=>{const p=pop(t,36.46); $(id).style.transform=`scale(${(1/s*(0.85+0.15*clamp(p,0,1.2))).toFixed(4)})`;});
  $('zm-lfr').style.transform=`scale(${(1/s*(0.85+0.15*clamp(pop(t,36.82),0,1.2))).toFixed(4)})`;
  // twist: Thailand shakes, a crack runs down it, the left bank (la) and the Malay north drift away on "ยอมเสียดินแดน"
  const tw=37.98, sk=t>=tw?14*Math.exp(-(t-tw)*2.6)*Math.sin((t-tw)*48):0;
  $('zm-th').style.transform=`translate(${f2(sk)}px,${f2(sk*0.3)}px)`;
  $('zm-glow').style.opacity=f2(t<tw?0.55+0.3*Math.sin((t-a)*4):0.25+0.15*Math.sin((t-tw)*9));
  $('zm-crack').style.strokeDashoffset=(1-eio((t-38.22)/0.4)).toFixed(4);
  const lost=pop(t,39.42,12,0.7), lost2=pop(t,39.76,12,0.7);
  $('zm-la').style.transform=`translate(${f2(34*lost)}px,${f2(-12*lost)}px)`;
  $('zm-mn').style.transform=`translate(${f2(8*lost2)}px,${f2(30*lost2)}px)`;
  ['zm-laf','zm-mnf'].forEach((id,i)=>{const on=t>=(i?39.76:39.42); $(id).style.fill=on?'var(--accent)':''; $(id).style.fillOpacity=on?'0.6':'';
    $(id).style.stroke=on?'var(--ink)':''; $(id).style.strokeDasharray=on?'10 8':''; $(id).style.strokeWidth=on?'4':'';});
  // one top pill morphs: "คานอำนาจ" -> "ไม่ได้รอดฟรี" (flip on the word)
  const b=$('bigtop'), on=win(t,36.0,e,0.06,0.1);
  const fa=t<tw?pop(t,36.0):pop(t,tw,18,0.45), flip=t>=tw-0.08&&t<tw?1-(tw-t)/0.08:0;
  $('bigtop-t').textContent=t<tw?'คานอำนาจ':'ไม่ได้รอดฟรี';
  show(b,on*(1-out),`scale(${((0.6+0.4*clamp(fa,0,1.2))*(1-flip)).toFixed(4)},${(0.6+0.4*clamp(fa,0,1.2)).toFixed(4)}) rotate(${f2(t>=tw?-2*Math.exp(-(t-tw)*3)*Math.sin((t-tw)*30):0)}deg)`);
}
// tw_malay: same zoom map (slot copy), closer on the south; the Malay north piece slides away on "มลายู"
function malayGfx(t){
  const M=shotAt('tw_malay'); if(t<M.a-0.2||t>M.b+0.2) return;
  const u=clamp((t-M.a)/(M.b-M.a)), s=1.85+0.15*eio(u);
  mapT($('tm-w'),s,504,880,540,860);
  $('tm-la').style.transform='translate(34px,-12px)';
  ['tm-laf','tm-mnf'].forEach(id=>{const x=$(id).style; x.fill='var(--accent)'; x.fillOpacity='0.6'; x.stroke='var(--ink)'; x.strokeDasharray='10 8'; x.strokeWidth='3';});
  const m=pop(t,41.68,12,0.6); $('tm-mn').style.transform=`translate(${f2(8+10*m)}px,${f2(30+36*m)}px)`;
  $('tm-mnf').style.fillOpacity=f2(0.6+0.3*Math.sin((t-M.a)*7));
  $('tm-th').style.transform=`translate(${f2(2*Math.sin(t*31))}px,0)`;
  ['tm-luk1','tm-luk2','tm-lfr'].forEach(id=>$(id).style.transform=`scale(${(1/s).toFixed(4)})`);
  $('tm-glow').style.opacity='0.3';
  show($('approx'),clamp((t-41.32)/0.1));
}
// share: "ไท = อิสระ" word by word
function shareGfx(t){
  const a=42.84, e=45.46; const on=win(t,43.2,e,0.06,0.12); $('tai').style.opacity=f2(on);
  if(on<=0) return;
  [['tai1',43.20],['tai2',43.70],['tai3',44.14]].forEach(([id,ta],i)=>{const p=pop(t,ta,18,0.5);
    show($(id),clamp((t-ta)/0.06),`translateY(${f2(40*(1-clamp(p,0,1.2))-4*Math.sin((t-ta)*2.6))}px) scale(${(0.5+0.5*clamp(p,0,1.15)).toFixed(4)})`);});
}
function episode(t){ cards(t); seaGfx(t); guessGfx(t); rankGfx(t); chip('chipA',CA,t); chip('chipB',CB,t); stamp(t); zoomGfx(t); malayGfx(t); shareGfx(t); ctaGfx(t); }
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
