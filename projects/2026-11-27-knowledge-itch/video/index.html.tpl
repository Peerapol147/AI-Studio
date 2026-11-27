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
#root{--pain:color-mix(in oklab,#FF3B1F 78%,var(--accent2));--skin:color-mix(in oklab,var(--accent2) 42%,var(--bg2));
  --skinhi:color-mix(in oklab,var(--accent2) 70%,#fff);--skinlo:color-mix(in oklab,var(--accent2) 22%,var(--bg))}
/* itch: frame-0 title big + centred (director 2026-11-27: template sized it 65 px, unreadable in the feed) */
.op-pov #title{top:210px;align-items:center;gap:16px}
.op-pov #title .tl{font-size:116px !important;line-height:1.22;text-align:center;-webkit-text-stroke:.17em var(--ink);text-shadow:0 12px 0 rgba(0,0,0,.45),0 0 40px rgba(0,0,0,.55)}
.op-pov #title .tl em{color:var(--accent);padding:0 0 2px;border-bottom:14px solid var(--accent)}
.kick.pov{font-size:76px;padding:8px 34px 14px;transform:rotate(-2deg)}
#tshade{height:1000px}
/* hook captions duplicate the on-screen title: hidden while the title shows */
#c0 span,#c1 span,#c2 span{visibility:hidden}
#gfx,#gfx-in,#follow,#fx{position:absolute;left:0;top:0;width:1080px;height:1920px;pointer-events:none}
#gfx{z-index:20;opacity:0}
#follow{z-index:21;opacity:0}
#fx{z-index:22}
.ilab{position:absolute;left:0;top:0;white-space:nowrap;font-weight:700;color:#fff;line-height:1.25;padding:.06em .5em .16em;
  border-radius:.4em;background:rgba(8,6,28,.72);border:5px solid var(--lc);box-shadow:0 0 26px var(--lc),inset 0 0 18px rgba(255,255,255,.08);
  opacity:0;will-change:auto}
#gfx-timer{position:absolute;left:0;top:0;width:120px;height:120px;opacity:0}
#mouse-chip{position:absolute;left:0;top:0;z-index:23;font-weight:700;font-size:118px;line-height:1.2;color:var(--ink);background:var(--accent);
  padding:.02em .5em .14em;border-radius:.42em;box-shadow:0 0 0 9px var(--ink),0 18px 50px rgba(0,0,0,.55);opacity:0;white-space:nowrap}
.fp{position:absolute;left:40px;width:1000px;height:540px;border-radius:34px;overflow:hidden;box-shadow:0 0 0 6px var(--ink),0 0 0 11px var(--accent),0 24px 60px rgba(0,0,0,.6);opacity:0}
.fp img,.fp video{position:absolute;left:0;top:0;width:1000px;height:540px;object-fit:cover}
#fp-1{top:130px}#fp-2{top:690px}#fp-3{top:1250px}
.zap{position:absolute;left:0;top:0;width:1080px;height:1920px}
#ctaq{position:absolute;left:540px;top:300px;z-index:24;font-weight:700;font-size:104px;line-height:1.25;color:var(--ink);background:var(--accent);
  padding:.02em .5em .16em;border-radius:.42em;box-shadow:0 0 0 9px var(--ink),0 18px 50px rgba(0,0,0,.5);opacity:0;white-space:nowrap}
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
<div id="gfx" data-layout-allow-overflow data-layout-allow-overlap><div id="gfx-in"><div id="gfx-lab"></div>
 <div id="gfx-timer"><svg width="120" height="120" viewBox="0 0 120 120"><circle cx="60" cy="60" r="54" fill="rgba(8,6,28,.75)" stroke="#fff" stroke-width="5"/>
 <circle class="sweep" cx="60" cy="60" r="54" fill="none" stroke="var(--accent)" stroke-width="9" stroke-dasharray="339.3" stroke-dashoffset="0" transform="rotate(-90 60 60)"/>
 <line x1="60" y1="60" x2="60" y2="20" stroke="#fff" stroke-width="7" stroke-linecap="round"/></svg></div>
</div></div>
<div id="follow" data-layout-allow-overflow data-layout-allow-overlap>
 <div class="fp" id="fp-1"><img id="fp1i" src="assets/fp1.jpg" alt=""/></div>
 <div class="fp" id="fp-2"><video id="v-fp2" class="clip" data-start="32.579" data-duration="2.221" data-media-start="10.42" data-track-index="5" muted playsinline src="assets/fp2.mp4"></video></div>
 <div class="fp" id="fp-3"><video id="v-fp3" class="clip" data-start="32.579" data-duration="2.221" data-media-start="0.2" data-track-index="6" muted playsinline src="assets/fp3.mp4"></video></div>
 <svg class="zap" viewBox="0 0 1080 1920"><path id="zap1" d="M860 420 L700 560 L780 600 L560 760 L640 790 L330 980" fill="none" stroke="var(--accent)" stroke-width="12" stroke-linecap="round" opacity="0" filter="url(#glow)"/>
 <path id="zap2" d="M330 980 L520 1130 L440 1160 L680 1320 L600 1350 L840 1520" fill="none" stroke="var(--accent)" stroke-width="12" stroke-linecap="round" opacity="0" filter="url(#glow)"/></svg>
</div>
<div id="fx" data-layout-allow-overflow data-layout-allow-overlap><svg class="zap" viewBox="0 0 1080 1920"><g id="spark" opacity="0">
 <circle r="70" fill="var(--pain)" opacity=".45" filter="url(#blur16)"/><circle r="22" fill="#fff" filter="url(#blur3)"/>
 <g id="spark-rays" stroke="var(--pain)" stroke-width="7" stroke-linecap="round" filter="url(#glow)">
 <line x1="0" y1="-30" x2="0" y2="-80"/><line x1="26" y1="-15" x2="70" y2="-40"/><line x1="26" y1="15" x2="70" y2="40"/><line x1="0" y1="30" x2="0" y2="80"/><line x1="-26" y1="15" x2="-70" y2="40"/><line x1="-26" y1="-15" x2="-70" y2="-40"/></g></g></svg></div>
<div id="ctaq">คันตรงไหน?</div>
<div id="mouse-chip">ในหนู</div>
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

<script src="itch.js"></script>
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
function episode(t){ ITCH.render(t,SC); ITCH.extras(t,SC);
  // hook title: hard cut at the end of the hook (no fade ghost over the slide into mosquito)
  if(t>=D.hookEnd&&t<DUR-0.3){ $('title').style.opacity='0'; $('tshade').style.opacity='0'; }
  // contagious -> watch: hard cut instead of the 0.1 s match fade (face-over-face ghost)
  SC.forEach(s=>{ if(s.id==='watch'){ s.el.style.opacity = t>=s.a ? (s.next&&t>=s.next.a+0.12?'0':'1') : '0'; } if(s.id==='contagious'&&t>=SC.find(x=>x.id==='watch').a) s.el.style.opacity='0'; });
}
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
