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
#title{position:absolute;left:60px;top:250px;width:960px;z-index:50;display:flex;flex-direction:column;align-items:center;gap:6px;transform-origin:50% 40%}
#title .tl{font-weight:var(--tw);line-height:1.08;white-space:nowrap;color:var(--text);text-align:center;
  -webkit-text-stroke:22px var(--ink);paint-order:stroke fill;text-shadow:0 10px 0 rgba(0,0,0,.4)}
#title em{font-style:normal;color:var(--accent)}
.op-midstory #title{top:250px}
.op-midstory #title .tl{-webkit-text-stroke:0;color:var(--ink);background:var(--accent);padding:0 26px;border-radius:18px;text-shadow:none}
.op-midstory #title em{color:var(--text);-webkit-text-stroke:10px var(--ink);paint-order:stroke fill}
.op-pov #title{align-items:flex-start}
.op-pov #title .tl{text-align:left}
.kick{font-weight:var(--tw);white-space:nowrap;line-height:1}
.kick.pov{font-size:64px;color:var(--ink);background:var(--accent);padding:10px 28px;border-radius:999px;margin-bottom:10px}
/* cover layouts (frame 0 = the thumbnail) */
.cv-card #title{background:var(--panel);border-radius:44px;box-shadow:0 0 0 9px var(--ink),0 26px 60px rgba(0,0,0,.5);padding:34px 40px 40px}
.cv-card #title .tl{-webkit-text-stroke:0;color:var(--paneltext);text-shadow:none}
.cv-card #title em{color:var(--ink);background:var(--accent);padding:0 16px;border-radius:16px}
/* midstory + card: the line already sits on an accent plate -> ink text, highlighted word inverted (accent on ink), no stroke */
.op-midstory.cv-card #title .tl{color:var(--ink)}
.op-midstory.cv-card #title em{-webkit-text-stroke:0;color:var(--accent);background:var(--ink);padding:0 16px;border-radius:16px}
.cv-tilt #title .tl:nth-of-type(odd){transform:rotate(-3deg)}
.cv-tilt #title .tl:nth-of-type(even){transform:rotate(2.5deg)}
.cv-tilt #title em{background:linear-gradient(transparent 68%,var(--accent) 68%,var(--accent) 90%,transparent 90%);color:var(--text)}
.kick.num{font-size:260px;color:var(--accent);-webkit-text-stroke:24px var(--ink);paint-order:stroke fill;text-shadow:0 14px 0 rgba(0,0,0,.4)}
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
/* stomach-growl: one overlay layer #eg above the shots; every colour is a look variable */
#eg{position:absolute;left:0;top:0;width:1080px;height:1920px;z-index:20;pointer-events:none}
#egs{position:absolute;left:0;top:0;width:1080px;height:1920px;overflow:visible}
#egs path,#egs circle,#egs ellipse,#egs rect{vector-effect:none}
.eo{position:absolute;left:0;width:1080px;text-align:center;white-space:nowrap;font-weight:var(--tw);line-height:1.05;opacity:0;transform-origin:50% 50%}
.ono{color:var(--accent);-webkit-text-stroke:16px var(--ink);paint-order:stroke fill}
#tx-krok{left:90px;width:400px;top:1262px;font-size:100px;text-align:left;transform-origin:20% 50%}
#tx-hiw{top:610px;font-size:300px;color:var(--ink)}
#tx-hiw .w{display:inline-block;transform-origin:50% 80%}
#qm{display:inline-block;color:var(--accent);-webkit-text-stroke:14px var(--ink);paint-order:stroke fill;transform-origin:50% 85%;margin-left:34px}
#tx-sure{top:922px;font-size:120px;color:var(--ink)}
#tx-sure em{font-style:normal;color:var(--accent)}
#tx-name{top:655px;font-size:170px;color:var(--ink)}
#tx-name em{font-style:normal;color:var(--accent);-webkit-text-stroke:12px var(--ink);paint-order:stroke fill}
#tx-term{top:500px;color:var(--ink)}
#tx-term .lat{font-size:130px;letter-spacing:-2px}
#tx-term .th{font-size:96px;color:var(--accent2);margin-top:4px}
#tx-term .pill{display:inline-block;margin-top:26px;font-size:62px;color:var(--ink);background:var(--accent);padding:6px 34px 12px;border-radius:999px;box-shadow:0 0 0 7px var(--ink);transform-origin:50% 50%}
#on1{left:90px;width:420px;top:450px;font-size:120px;text-align:left}
#on2{left:560px;width:440px;top:540px;font-size:120px;text-align:left}
#tx-loud{top:560px;font-size:230px;-webkit-text-stroke:24px var(--ink)}
#fq1,#fq2{width:140px;font-size:120px}
#fq1{left:770px;top:380px}#fq2{left:180px;top:420px}
#msg{position:absolute;left:640px;top:820px;width:230px;height:230px;opacity:0;transform-origin:50% 50%;color:var(--ink)}
#msg svg{width:230px;height:230px;overflow:visible}

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
<div id="eg" data-layout-allow-overflow data-layout-allow-overlap>
<svg id="egs" viewBox="0 0 1080 1920" width="1080" height="1920" fill="none" stroke-linecap="round" stroke-linejoin="round">
  <g id="hw"></g>
  <rect id="cardbg" x="0" y="0" width="10" height="10" rx="44" fill="var(--panel)" stroke="var(--ink)" stroke-width="10" opacity="0"/>
  <g id="tube" opacity="0">
    <g id="tw"></g>
    <path id="tbody" fill="var(--accent)" stroke="var(--ink)" stroke-width="14"/>
    <path id="thi" stroke="var(--panel)" stroke-width="10" opacity="0.55"/>
    <g id="food"></g><g id="bub"></g><g id="drp"></g>
  </g>
  <g id="ld" opacity="0"></g>
  <g id="em" opacity="0">
    <path id="emst" d="M-70 -170 L-62 -120 C-55 -80 -40 -70 -20 -60 C40 -30 150 -40 150 60 C150 150 40 180 -40 150 C-120 120 -160 40 -120 -10 C-100 -35 -100 -80 -105 -120 L-112 -170" fill="var(--panel)" stroke="var(--ink)" stroke-width="16"/>
    <g id="emw"></g>
    <text id="emtx" x="10" y="75" text-anchor="middle" font-size="96" font-weight="900" fill="var(--accent)" stroke="var(--ink)" stroke-width="12" paint-order="stroke fill" style="font-family:var(--font)">ว่าง</text>
  </g>
  <g id="face" opacity="0">
    <circle cx="0" cy="0" r="190" fill="var(--bg2)" stroke="var(--ink)" stroke-width="14"/>
    <path id="brl" d="M-110 -95 L-40 -110" stroke="var(--ink)" stroke-width="16"/>
    <path id="brr" d="M40 -85 L110 -80" stroke="var(--ink)" stroke-width="16"/>
    <ellipse id="eyl" cx="-70" cy="-35" rx="22" ry="30" fill="var(--ink)"/>
    <ellipse id="eyr" cx="70" cy="-35" rx="22" ry="30" fill="var(--ink)"/>
    <path id="mth" d="M-75 75 q19 -22 38 0 q19 22 38 0 q19 -22 38 0 q19 22 38 0" stroke="var(--ink)" stroke-width="14"/>
  </g>
</svg>
<div id="tx-krok" class="eo ono">โครก~</div>
<div id="tx-hiw" class="eo"><span class="w">หิว</span><span id="qm">?</span></div>
<div id="tx-sure" class="eo">หิว<em>แน่ๆ?</em></div>
<div id="tx-name" class="eo">ชื่อ<em>จริง?</em></div>
<div id="tx-term" class="eo"><div class="lat">Borborygmus</div><div class="th">บอร์บอริกมัส</div><div id="greek" class="pill">ภาษากรีก</div></div>
<div id="on1" class="eo ono">โครก</div>
<div id="on2" class="eo ono">คราก!</div>
<div id="tx-loud" class="eo ono">โครก!</div>
<div id="fq1" class="eo ono">?</div>
<div id="fq2" class="eo ono">?</div>
<div id="msg"><svg viewBox="-2 -2 28 28"><circle cx="12" cy="12" r="12.5" fill="var(--panel)" stroke="none"/><use href="#ic-message-circle" style="color:var(--ink)"/><circle cx="8" cy="12" r="1.3" fill="var(--accent)"/><circle cx="12" cy="12" r="1.3" fill="var(--accent)"/><circle cx="16" cy="12" r="1.3" fill="var(--accent)"/></svg></div>
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
/* stomach-growl episode graphics: word times from assets/audio/words.json (seconds) */
const NS='http://www.w3.org/2000/svg', SH={}; SC.forEach(s=>{SH[s.id]=s;});
const mk=(par,tag,at)=>{const e=document.createElementNS(NS,tag); for(const k in at) e.setAttribute(k,at[k]); $(par).appendChild(e); return e;};
const frac=x=>x-Math.floor(x), sa=(e,k,v)=>e.setAttribute(k,typeof v==='number'?v.toFixed(2):v);
const arc=(cx,cy,r,a0,a1)=>{const p=Math.PI/180, x0=cx+r*Math.cos(a0*p), y0=cy+r*Math.sin(a0*p), x1=cx+r*Math.cos(a1*p), y1=cy+r*Math.sin(a1*p);
  return `M${x0.toFixed(1)} ${y0.toFixed(1)} A${r.toFixed(1)} ${r.toFixed(1)} 0 0 1 ${x1.toFixed(1)} ${y1.toFixed(1)}`;};
const win=(t,a,b,fi=0.1)=>(t<a-0.01||t>=b+0.06)?0:clamp((t-a)/fi)*(1-clamp((t-(b-0.05))/0.1));
const W={squeeze:8.60, air:9.30, liquid:9.80, krok:11.96, krak:12.24, absorb:15.14, quiet:16.58, empty:17.94, loud:20.02,
  assume:21.00, hungry:21.66, greek:26.60, comment:29.46, no:5.04, always:5.30};
// frame 0 + loop: belly "growl" rings, periodic with the clip so the last frame = frame 0
const HW=[]; for(let i=0;i<3;i++) for(const sd of [1,-1]) HW.push({i,sd,u:mk('hw','path',{stroke:'var(--ink)'}),f:mk('hw','path',{stroke:'var(--accent)'})});
const P=DUR/24;
function hookWaves(t){
  const hb=SH.plate.a, la=SH.loop.a, o=t<hb?1-clamp((t-(hb-0.05))/0.1):clamp((t-la)/0.15);
  sa($('hw'),'opacity',o);
  HW.forEach(w=>{const p=frac(t/P+w.i/3), r=215+150*p, a=Math.pow(Math.sin(Math.PI*p),0.8), c=w.sd>0?0:180, d=arc(540,960,r,c-28,c+28);
    sa(w.u,'d',d); sa(w.f,'d',d); sa(w.u,'opacity',a*0.85); sa(w.f,'opacity',a); sa(w.f,'stroke-width',18-6*p); sa(w.u,'stroke-width',32-6*p);});
  const k=$('tx-krok'), ph=2*Math.PI*t/P; k.style.opacity=o.toFixed(3);
  k.style.transform=`rotate(${(-8+4*Math.sin(ph)).toFixed(2)}deg) scale(${(1+0.06*Math.sin(2*ph)).toFixed(4)})`;
}
// one gut tube: squeeze -> growl (continuous) and again in muffle; peristaltic constrictions travel left -> right
const X0=-40, X1=1120, R=78, YC=x=>760+55*Math.sin(2*Math.PI*(x-90)/900+0.4);
const cons=(u)=>[0,1,2].map(k=>-70+frac((u+k*460)/1380)*1380);
const rad=(x,cs,A)=>{let s=0; cs.forEach(c=>{s+=Math.exp(-Math.pow((x-c)/75,2));}); return R*(1-A*Math.min(1,s));};
const BUB=[],DRP=[],FOOD=[],TW=[];
for(let i=0;i<3;i++) for(const sd of [-1,1]) TW.push({i,sd,e:mk('tw','path',{stroke:'var(--accent2)'})});
for(let k=0;k<3;k++) for(let j=0;j<2;j++) BUB.push({k,j,e:mk('bub','circle',{fill:'var(--panel)',stroke:'var(--ink)','stroke-width':7})});
for(let k=0;k<3;k++) DRP.push({k,e:mk('drp','path',{fill:'var(--accent2)',stroke:'var(--ink)','stroke-width':7})});
for(let i=0;i<7;i++) FOOD.push({i,e:mk('food','ellipse',{fill:'var(--bg2)',stroke:'var(--ink)','stroke-width':8})});
function tube(t){
  const sq=SH.squeeze, gr=SH.growl, mu=SH.muffle, inMu=t>=mu.a-0.01;
  const o=inMu?win(t,mu.a,mu.b):win(t,sq.a,gr.b), enter=inMu?mu.a:sq.a;
  sa($('tube'),'opacity',o);
  [$('on1'),$('on2')].forEach(e=>{e.style.opacity='0';});
  if(o<=0) return;
  const sc=0.82+0.18*S(t-enter,16,0.6);
  sa($('tube'),'transform',`translate(540 760) scale(${sc.toFixed(4)}) translate(-540 -760)`);
  const A=inMu?0.38:lerp(0.15,0.55,S(t-W.squeeze,12,0.7)), cs=cons(t*(inMu?380:520));
  let top='', bot=[], hi='';
  for(let x=X0;x<=X1;x+=12){const y=YC(x), r=rad(x,cs,A); top+=(top?' L':'M')+x+' '+(y-r).toFixed(1); bot.push(x+' '+(y+r).toFixed(1));
    if(x%24===0) hi+=(hi?' L':'M')+x+' '+(y-r*0.5).toFixed(1);}
  sa($('tbody'),'d',top+' L'+bot.reverse().join(' L')+' Z'); sa($('thi'),'d',hi);
  const ob=inMu?0:S(t-W.air,14,0.6), od=inMu?0:S(t-W.liquid,14,0.6);
  BUB.forEach(b=>{const x=cs[b.k]+105+b.j*62, r=Math.max(0,(22-b.j*4)*ob), y=YC(x)-10+6*Math.sin(t*9+b.j);
    sa(b.e,'cx',x); sa(b.e,'cy',y); sa(b.e,'r',r); sa(b.e,'opacity',r>0.5?1:0);});
  DRP.forEach(d=>{const x=cs[d.k]+215, y=YC(x)+18, s=od, f=v=>v.toFixed(1);
    sa(d.e,'d',`M${f(x)} ${f(y-34*s)} C${f(x+22*s)} ${f(y-8*s)} ${f(x+22*s)} ${f(y+20*s)} ${f(x)} ${f(y+20*s)} C${f(x-22*s)} ${f(y+20*s)} ${f(x-22*s)} ${f(y-8*s)} ${f(x)} ${f(y-34*s)} Z`);
    sa(d.e,'opacity',s>0.02?1:0);});
  FOOD.forEach(fd=>{const s=inMu?S(t-W.absorb-fd.i*0.05,14,0.6):0, x=X0+60+fd.i*175+40*(t-mu.a), y=YC(x);
    sa(fd.e,'cx',x); sa(fd.e,'cy',y); sa(fd.e,'rx',Math.max(0,48*s)); sa(fd.e,'ry',Math.max(0,36*s)); sa(fd.e,'opacity',s>0.02?1:0);
    sa(fd.e,'transform',`rotate(${(fd.i*37+20*(t-mu.a)).toFixed(1)} ${x.toFixed(1)} ${y.toFixed(1)})`);});
  // sound waves off the tube: growl = loud pulses on "โครก"/"คราก"; muffle = smaller and fading out
  let g=0, rs=1;
  if(!inMu){ if(t>=gr.a) g=(0.55+0.45*S(t-W.krok,10,0.5))*clamp((t-gr.a)/0.15)+(t>=W.krok?0.35*Math.exp(-6*(t-W.krok)):0)+(t>=W.krak?0.3*Math.exp(-6*(t-W.krak)):0); }
  else { const u=eio((t-W.absorb)/(W.quiet-W.absorb)); g=lerp(0.8,0.1,u); rs=lerp(1,0.55,u); }
  TW.forEach(w=>{const p=frac(t/0.55+w.i/3), r=(110+(w.sd<0?330:230)*p)*rs, c=w.sd<0?270:90;
    sa(w.e,'d',arc(540,760,r,c-55,c+55)); sa(w.e,'stroke-width',4+14*g*(1-0.5*p)); sa(w.e,'opacity',Math.min(1,g)*Math.sin(Math.PI*p));});
  if(!inMu) [['on1',W.krok,-9],['on2',W.krak,7]].forEach(([id,at,rr],j)=>{const e=$(id), s=S(t-at,16,0.45);
    e.style.opacity=(t>=at?1-clamp((t-(gr.b-0.05))/0.1):0).toFixed(3);
    e.style.transform=`rotate(${(rr+3*Math.sin(t*7+j)).toFixed(2)}deg) scale(${(0.4+0.6*s).toFixed(4)})`;});
}
// one card that morphs: "หิว?" -> "หิวแน่ๆ?" -> "ชื่อจริง?" -> Borborygmus
const CARD={notalways:{cy:780,w:720,h:430},assume:{cy:992,w:820,h:180},name:{cy:760,w:880,h:290},term:{cy:676,w:990,h:430}};
const CTX=['tx-hiw','tx-sure','tx-name','tx-term'];
function card(t){
  CTX.forEach(id=>{$(id).style.opacity='0';});
  const segs=[['notalways',SH.notalways.a,SH.notalways.b],['assume',SH.assume.a,SH.assume.b],['name',SH.name.a,SH.term.b]];
  let o=0, st=null, a0=0;
  segs.forEach(([id,a,b])=>{const v=win(t,a,b); if(v>0){o=v; st=id; a0=a;}});
  sa($('cardbg'),'opacity',o); if(!st) return;
  let g=CARD[st], kt=0;
  if(st==='name'){ kt=t<SH.term.a?0:S(t-SH.term.a,14,0.75); const A=CARD.name,B=CARD.term;
    g={cy:lerp(A.cy,B.cy,kt),w:lerp(A.w,B.w,kt),h:lerp(A.h,B.h,kt)}; }
  const sc=(0.7+0.3*S(t-a0,16,0.6))*(1+0.012*Math.sin(t*4.2)), w=g.w*sc, h=g.h*sc, rot=1.2*Math.sin(t*1.7), r=$('cardbg');
  sa(r,'x',540-w/2); sa(r,'y',g.cy-h/2); sa(r,'width',w); sa(r,'height',h); sa(r,'transform',`rotate(${rot.toFixed(3)} 540 ${g.cy.toFixed(1)})`);
  const show=(id,v)=>{const e=$(id); e.style.opacity=(o*v).toFixed(3); e.style.transform=`scale(${sc.toFixed(4)}) rotate(${rot.toFixed(3)}deg)`;};
  if(st==='notalways'){ show('tx-hiw',1);
    const q=$('qm'), on=t>=W.no, tilt=on?-22*S(t-W.no,10,0.4)+(t>=W.always?14*Math.sin((t-W.always)*9)*Math.exp(-0.8*(t-W.always)):0):6*Math.sin(t*5);
    q.style.transform=`translateY(${(-18*Math.abs(Math.sin(t*6))).toFixed(1)}px) rotate(${tilt.toFixed(2)}deg) scale(${(on?1+0.3*S(t-W.no,12,0.35):1).toFixed(4)})`;
    $('tx-hiw').querySelector('.w').style.transform=`rotate(${(-3+2*Math.sin(t*3)).toFixed(2)}deg)`; }
  if(st==='assume') show('tx-sure',1);
  if(st==='name'){ show('tx-name',1-clamp((t-SH.term.a)/0.12)); show('tx-term',clamp((t-SH.term.a-0.04)/0.15));
    const pg=$('greek'), s=S(t-W.greek,16,0.5); pg.style.opacity=t>=W.greek-0.02?'1':'0'; pg.style.transform=`rotate(${(-3+2*Math.sin(t*4)).toFixed(2)}deg) scale(${s.toFixed(4)})`; }
}
// assume: a puzzled face (the stock clip looked AI-made) + "หิวแน่ๆ?"
function face(t){
  const a=SH.assume.a, b=SH.assume.b, o=win(t,a,b);
  sa($('face'),'opacity',o); ['fq1','fq2'].forEach(id=>{$(id).style.opacity='0';}); if(o<=0) return;
  const s=0.6+0.4*S(t-a,14,0.55), rot=9*Math.sin((t-a)*3.2)+(t>=W.hungry?-10*S(t-W.hungry,10,0.45):0);
  sa($('face'),'transform',`translate(540 640) rotate(${rot.toFixed(2)}) scale(${s.toFixed(4)})`);
  const lx=12*Math.sin((t-a)*2.5), ly=t<W.assume?0:14*S(t-W.assume,10,0.6), bl=Math.max(0,1-Math.abs(t-22.3)/0.08);
  [['eyl',-70],['eyr',70]].forEach(([id,x])=>{sa($(id),'cx',x+lx); sa($(id),'cy',-35+ly); sa($(id),'ry',30*(1-0.85*bl));});
  sa($('brl'),'transform',`translate(0 ${(-8-8*Math.sin(t*5)).toFixed(1)}) rotate(${(-6+4*Math.sin(t*5)).toFixed(2)} -75 -100)`);
  [['fq1',a+0.2,12],['fq2',a+0.45,-14]].forEach(([id,at,rr],j)=>{const e=$(id), k=S(t-at,14,0.45);
    e.style.opacity=(t>=at?o:0).toFixed(3); e.style.transform=`translateY(${(-16*Math.sin(t*4+j*2)).toFixed(1)}px) rotate(${(rr+8*Math.sin(t*3+j)).toFixed(2)}deg) scale(${k.toFixed(4)})`;});
}
// empty: an empty stomach icon over the near-empty fridge, echo rings
const EMW=[]; for(let i=0;i<2;i++) for(const sd of [1,-1]) EMW.push({i,sd,e:mk('emw','path',{stroke:'var(--ink)','stroke-width':12})});
function empty(t){
  const a=SH.empty.a, b=SH.empty.b, o=win(t,a,b); sa($('em'),'opacity',o); if(o<=0) return;
  const s=(0.5+0.5*S(t-W.empty,14,0.55))*(1+0.03*Math.sin(t*6))*1.15;
  sa($('em'),'transform',`translate(540 800) rotate(${(4*Math.sin(t*2.5)).toFixed(2)}) scale(${s.toFixed(4)})`);
  EMW.forEach(w=>{const p=frac(t/0.8+w.i/2), c=w.sd>0?0:180; sa(w.e,'d',arc(15,20,200+110*p,c-30,c+30)); sa(w.e,'opacity',Math.sin(Math.PI*p));});
}
// loud: the growl goes off in a silent meeting
const LD=[]; for(let i=0;i<3;i++) LD.push(mk('ld','circle',{cx:540,cy:760,stroke:'var(--accent)'}));
function loud(t){
  const a=SH.loud.a, b=SH.loud.b, o=win(t,a,b,0.06), tx=$('tx-loud');
  sa($('ld'),'opacity',o); tx.style.opacity=o.toFixed(3); if(o<=0) return;
  LD.forEach((c,i)=>{const p=frac((t-a)/0.5+i/3); sa(c,'r',120+620*p); sa(c,'stroke-width',4+26*(1-p)); sa(c,'opacity',1-p);});
  const s=0.5+0.5*S(t-W.loud,18,0.4);
  tx.style.transform=`translate(${(8*Math.sin(t*29)).toFixed(1)}px,${(6*Math.sin(t*23+1)).toFixed(1)}px) rotate(${(3*Math.sin(t*19)).toFixed(2)}deg) scale(${s.toFixed(4)})`;
}
// cta: comment bubble on "เมนต์"
function msg(t){
  const e=$('msg'), b=SH.ask.b, o=(t>=W.comment&&t<b+0.06)?1-clamp((t-(b-0.05))/0.1):0;
  e.style.opacity=o.toFixed(3); if(o<=0) return;
  e.style.transform=`rotate(${(-8+5*Math.sin(t*5)).toFixed(2)}deg) scale(${S(t-W.comment,16,0.5).toFixed(4)})`;
}
function episode(t){ hookWaves(t); tube(t); card(t); face(t); empty(t); loud(t); msg(t); }

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
