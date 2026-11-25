/* Palmaris test ("ลองทำตาม #1") v3 edit: episode graphics for the brainrot-v3 template, 21 shots.
   Everything is a pure function of t (seek-safe). Colours come only from the look's CSS variables.
   Every shot is footage (3D hands keyed onto the palette's warm gradient, x-ray, surgery, mug, baseball photos);
   each gets an overlay layer inside its own push layer (#kb-<id>). A shot "camera" (fr) moves the <video>/<img>
   and its overlay together, so overlay coordinates are plate pixels (1080x1920) and stay on the picture.
   Word times: assets/audio/words.json; shot starts/ends: assets/audio/shots-th.json. */
(function(){
const NS='http://www.w3.org/2000/svg';
const $=id=>document.getElementById(id);
const clamp=(x,a=0,b=1)=>Math.min(b,Math.max(a,x)), lerp=(a,b,u)=>a+(b-a)*u;
const eo=x=>{x=clamp(x);return 1-Math.pow(1-x,3)}, eio=x=>{x=clamp(x);return x*x*x*(x*(6*x-15)+10)};
const S=(tau,w,z)=>{if(tau<=0)return 0; if(z<1){const wd=w*Math.sqrt(1-z*z);
  return 1-Math.exp(-z*w*tau)*(Math.cos(wd*tau)+z*w/wd*Math.sin(wd*tau));} return 1-Math.exp(-w*tau)*(1+w*tau);};
const sp=(t,at,w=16,z=0.62)=>S(t-at,w,z);          // spring 0 -> 1 starting at word time `at`
const bump=(t,at,k=6)=>t>=at?Math.exp(-(t-at)*k):0;  // 1 at the word, decays
const P=(x,y)=>({x,y}), lp=(a,b,u)=>P(lerp(a.x,b.x,u),lerp(a.y,b.y,u));
const f1=v=>v.toFixed(1), f3=v=>v.toFixed(3);
function el(parent,tag,attrs,style){const e=document.createElementNS(NS,tag);for(const k in attrs)e.setAttribute(k,attrs[k]);
  if(style)e.setAttribute('style',style); parent.appendChild(e); return e;}
function div(parent,cls,html,style){const e=document.createElement('div'); e.className=cls; e.innerHTML=html; if(style)e.setAttribute('style',style); parent.appendChild(e); return e;}
const INK='stroke:var(--ink);fill:none;stroke-linecap:round;stroke-linejoin:round';
const ACC='stroke:var(--accent);fill:none;stroke-linecap:round;stroke-linejoin:round';

/* shot frame: overlay layer + camera. cam(fx,fy,X,Y,s,r): plate point (fx,fy) lands on screen (X,Y), scale s, rotate r deg */
function fr(id){const kb=$('kb-'+id); if(!kb) return null; const media=kb.querySelector('video,img');
  const s=div(kb,'ov','',''); if(UPIDS[id]) div(s,'topfade','',''); const svg=el(s,'svg',{class:'gsvg',viewBox:'0 0 1080 1920',width:1080,height:1920});
  if(media) media.style.transformOrigin='0 0'; s.style.transformOrigin='0 0';
  return {s,svg,media,cam(fx,fy,X,Y,sc,r=0){const tf=`translate(${f1(X)}px,${f1(Y)}px) rotate(${(r||0).toFixed(2)}deg) scale(${f3(sc)}) translate(${f1(-fx)}px,${f1(-fy)}px)`;
    if(media) media.style.transform=tf; s.style.transform=tf;}};}
function label(parent,txt,cls,x,y,size){return div(parent,'lab '+cls,txt,`left:${x}px;top:${y}px;font-size:${size||52}px`);}
// label springs in at `at` (scale counter-acts the shot camera scale `k` so text keeps its size)
const popIn=(e,t,at,k=1,out=99,rot=0)=>{const a=sp(t,at,20,0.55), o=1-clamp((t-out)/0.15); e.style.opacity=f3(clamp(a*3)*o);
  e.style.transform=`translate(-50%,-50%) rotate(${rot}deg) scale(${f3((0.6+0.4*a)/k)})`;};
function ringEl(svg,r,w=13){const g=el(svg,'g',{}); const a=el(g,'circle',{r,pathLength:1},INK+`;stroke-width:${w*2};stroke-dasharray:1 1`), b=el(g,'circle',{r,pathLength:1},ACC+`;stroke-width:${w};stroke-dasharray:1 1`);
  return {g,set(x,y,u,s=1){g.setAttribute('transform',`translate(${f1(x)} ${f1(y)}) scale(${f3(s)})`); g.style.opacity=u>0.001?'1':'0'; [a,b].forEach(c=>c.style.strokeDashoffset=f3(1-clamp(u)));}};}
function ovalEl(svg,rx,ry,w=13){const g=el(svg,'g',{}); const d=`M0,${-ry} A${rx},${ry} 0 1 1 0,${ry} A${rx},${ry} 0 1 1 0,${-ry}`;
  const a=el(g,'path',{d,pathLength:1},INK+`;stroke-width:${w*2};stroke-dasharray:1 1`), b=el(g,'path',{d,pathLength:1},ACC+`;stroke-width:${w};stroke-dasharray:1 1`);
  return {g,set(x,y,u,s=1){g.setAttribute('transform',`translate(${f1(x)} ${f1(y)}) scale(${f3(s)})`); g.style.opacity=u>0.001?'1':'0'; [a,b].forEach(c=>c.style.strokeDashoffset=f3(1-clamp(u)));}};}
function lineEl(svg,d,w=18,col='var(--accent)'){const g=el(svg,'g',{}); const i=el(g,'path',{d,pathLength:1},INK+`;stroke-width:${w+16};stroke-dasharray:1 1`), a=el(g,'path',{d,pathLength:1},`stroke:${col};fill:none;stroke-linecap:round;stroke-linejoin:round;stroke-width:${w};stroke-dasharray:1 1`);
  return {g,i,a,set(u,o=1){[i,a].forEach(e=>e.style.strokeDashoffset=f3(1-clamp(u))); g.style.opacity=f3(u>0.001?o:0);},d(dd){i.setAttribute('d',dd);a.setAttribute('d',dd);}};}
// glowing tendon: soft wide glow + ink border + accent core, drawn from one end (u) and shimmering (sh)
function tendon(svg,d,w=20){const glow=el(svg,'path',{d},ACC+`;stroke-width:${w*3.6};opacity:0`); const L=lineEl(svg,d,w);
  const shine=el(svg,'path',{d,pathLength:1},`stroke:#fff;fill:none;stroke-linecap:round;stroke-width:${w*0.45};stroke-dasharray:.12 1;opacity:0`);
  return {set(u,t,glo=1){L.set(u); glow.style.opacity=f3(0.28*clamp(u*3)*glo); shine.style.opacity=f3(u>=1?0.85:0); shine.style.strokeDashoffset=f3(1.1-((t*0.9)%1.25));},L};}
// "อะไหล่" spare-part tag: card with a punched hole, hangs from a string tied at (ax, ay)
function tagEl(parent,svg,txt,size){const str=el(svg,'path',{},INK+';stroke-width:8;opacity:0'); const str2=el(svg,'path',{},'stroke:var(--accent2);fill:none;stroke-width:3.5;opacity:0');
  const tg=div(parent,'tag',`<i></i><span>${txt}</span>`,`font-size:${size||84}px`);
  return {set(ax,ay,len,ang,u,k=1){const r=ang*Math.PI/180, hx=ax+Math.sin(r)*len, hy=ay+Math.cos(r)*len;
      tg.style.opacity=f3(clamp(u*4)); tg.style.left=f1(hx)+'px'; tg.style.top=f1(hy)+'px';
      tg.style.transform=`translate(-50%,-12%) rotate(${(-ang).toFixed(2)}deg) scale(${f3((0.5+0.5*clamp(u))/k)})`;
      const d=`M${f1(ax)},${f1(ay)} L${f1(hx)},${f1(hy)}`; [str,str2].forEach(e=>{e.setAttribute('d',d); e.style.opacity=f3(clamp(u*4));});}};}

const UP=[];
/* ---------- coordinates on the plates (1080x1920 px, measured on the plate frames) ---------- */
// palm-v.mp4 (32187 upright, thumb on the left): wrist below the palm heel, fades out at Y ~1460
const PALM={thumb:P(108,486),pinky:P(918,702),wrist:P(500,1340),tTop:P(496,1160),tBot:P(506,1470)};
const TEND=`M${PALM.tTop.x},${PALM.tTop.y} C${PALM.tTop.x+4},${PALM.tTop.y+110} ${PALM.tBot.x-4},${PALM.tBot.y-110} ${PALM.tBot.x},${PALM.tBot.y}`;
// up-v.mp4 (32185 upright, thumb on the right)
const UPH={wrist:P(540,1340),tTop:P(540,1150),tBot:P(545,1470)};
// 32185 fingertips key badly (ragged): shots on up-v fade the plate top (Y < ~420) into the backdrop
const UPIDS={ask:1,none:1};
const UTEND=`M${UPH.tTop.x},${UPH.tTop.y} C${UPH.tTop.x+2},${UPH.tTop.y+110} ${UPH.tBot.x-2},${UPH.tBot.y-110} ${UPH.tBot.x},${UPH.tBot.y}`;



/* ---------- pinch / tip / flex / count / count2 / count1 (1.78-8.86): one jointed hand rig (episode/hand.js) ----------
   The pose is ONE function of global t shared by the six shots, so a cut never changes the hand, only the camera.
   "ประกบ" 2.80 thumb sweeps across the palm + pinky curls in; pads meet at 3.92 ("นิ้วก้อย" 3.84-4.10) with a spring
   press + accent pulse; "แล้วงอ" 4.32 wrist flexes toward the body, "นิดนึง" 4.96 a little more; the palmaris ridge
   rises in steps (4.45 / 4.96 / สาม 5.92 / สอง 6.96 / หนึ่ง 7.92); the held pose breathes + trembles. */
const TOUCH=3.92;
function handPose(t){
  const o=eio((t-2.80)/(TOUCH-2.80)), op=eio((t-2.90)/(TOUCH-2.90));
  const dt=t-TOUCH, press=dt>0?9*Math.exp(-dt*6)*Math.sin(dt*19):0;
  const env=clamp((t-1.9)/0.2)*(1-clamp((t-2.7)/0.2)), wig=[0,1,2,3].map(i=>3.2*env*Math.sin(t*10+i*1.4));
  const br=t>5.4?Math.sin((t-5.4)*Math.PI*2/1.5):0, trem=t>4.9?0.35*Math.sin(t*23.1)+0.25*Math.sin(t*31.7+1):0;
  const flex=34*eio((t-4.32)/0.6)+7*sp(t,4.96,12,0.5)+1.6*br+trem;
  const tendon=0.45*eo((t-4.45)/0.5)+0.16*sp(t,4.96,12,0.6)+0.13*sp(t,5.92,14,0.5)+0.13*sp(t,6.96,14,0.5)+0.13*sp(t,7.92,14,0.5);
  return {o,op,press,wig,spread:0.25*env,flex,tendon,pulse:dt>0?Math.exp(-dt*3.2):0,ring:dt>0?S(dt,13,0.42):0,br,trem};}
// camera per shot: wrist lands on screen (X,Y), scale S, view yaw / pitch / roll (deg)
const CAMS={
  pinch:t=>{const u=sp(t,1.80,9,0.78); return {X:540,Y:lerp(2050,1290,u),S:1.06,yaw:lerp(-14,4,u),pitch:0,roll:lerp(-8,0,u)};},
  tip:t=>{const u=eio((t-2.72)/1.5); return {X:lerp(540,470,u),Y:lerp(1290,1420,u),S:lerp(1.06,1.34,u),yaw:lerp(4,-6,u),pitch:lerp(0,-6,u),roll:0};},
  flex:t=>{const u=eio((t-4.3)/1.3); return {X:lerp(470,530,u),Y:lerp(1420,900,u),S:lerp(1.34,1.08,u),yaw:lerp(-6,-12,u),pitch:lerp(-6,8,u),roll:lerp(0,-3,u)};},
  count:t=>{const u=eio((t-5.84)/1.04); return {X:450,Y:lerp(800,770,u),S:lerp(0.98,1.04,u),yaw:lerp(10,4,u),pitch:6,roll:lerp(4,2,u)};},
  count2:t=>{const u=eio((t-6.88)/0.96); return {X:lerp(600,620,u),Y:720,S:lerp(1.32,1.42,u),yaw:lerp(-20,-16,u),pitch:4,roll:lerp(9,7,u)};},
  count1:t=>{const u=eio((t-7.84)/1.02); return {X:560,Y:lerp(470,440,u),S:lerp(2.0,2.15,u),yaw:lerp(-14,-10,u),pitch:12,roll:2};},
};
const RIGIDS=Object.keys(CAMS);
RIGIDS.forEach(id=>{const k=fr(id); if(!k||k.media) return; const kb=$('kb-'+id);
  kb.insertBefore(div(kb,'rigbg','',''),kb.firstChild);
  const R=window.HandRig(k.svg), labs={};
  if(id==='pinch') labs.go=label(k.s,'ลองเลย!','acc',540,470,78);
  if(id==='tip'){labs.th=label(k.s,'นิ้วโป้ง','acc',0,0,56); labs.pk=label(k.s,'นิ้วก้อย','acc',0,0,56);}
  if(id==='flex') labs.fl=label(k.s,'งอเข้าหาตัว','acc',540,470,64);
  UP.push(t=>{kb.style.transform='none';                      // the rig owns the camera (no template push = no jump at cuts)
    const P=handPose(t), C=CAMS[id](t); C.Y+=6*P.br+1.5*P.trem; const r=R.draw({...P,...C});
    if(labs.go){popIn(labs.go,t,1.86,1,99,-4); if(t>2.1) labs.go.style.transform+=` translateY(${f1(8*Math.sin((t-2.1)*9))}px)`;}
    if(labs.th){labs.th.style.left=f1(r.thumbTip.x-150)+'px'; labs.th.style.top=f1(r.thumbTip.y+120)+'px'; popIn(labs.th,t,3.30);
      labs.pk.style.left=f1(Math.min(880,r.pinkyTip.x+170))+'px'; labs.pk.style.top=f1(r.pinkyTip.y-130)+'px'; popIn(labs.pk,t,3.70);}
    if(labs.fl){popIn(labs.fl,t,4.46,1,99,-3);}});});

/* ---------- hook 0-1.78 + loop 27.42-28.3: the same jointed hand rig (episode/hand.js) in the finished test pose
   (thumb pad on pinky pad, wrist flexed, palmaris ridge raised) big in frame, ring on the tendon = frame 0 / cover.
   loop runs the same function on tt = t - DUR (<= 0) so the last frame = frame 0; all motion is periodic with zero
   slope at tt = 0 (1 - cos), the one-off ring kick is hook only (tt > 0). Defined after handPose/HandRig below. */
/* cover v2 (cover = card, after the channel's best covers): the hand sits UPRIGHT (no roll) palm-side in its own light
   card under the title card, whole hand inside the card, wrist + raised palmaris ridge above the caption band; accent
   ring on the ridge + "อะไหล่" tag with an arrow (like the knee-crack cover). Captions of the hook/loop move below the card. */
const HCARD={x:70,y:560,w:940,h:840};
const HOOKCAM={X:440,Y:1226,S:0.62,yaw:-4,pitch:2,roll:0};
function hookRig(id,phase){const k=fr(id); if(!k||k.media) return; const kb=$('kb-'+id);
  kb.insertBefore(div(kb,'rigbg','',''),kb.firstChild);
  const card=div(k.s,'hcard','',`left:${HCARD.x}px;top:${HCARD.y}px;width:${HCARD.w}px;height:${HCARD.h}px`); k.s.insertBefore(card,k.svg);
  k.svg.style.clipPath=`inset(${HCARD.y}px ${1080-HCARD.x-HCARD.w}px ${1920-HCARD.y-HCARD.h}px ${HCARD.x}px round 40px)`;
  const R=window.HandRig(k.svg);
  // raised palmaris ridge, stronger than the rig's own (cover reads at thumbnail size): soft shadow + bright crest
  const fd=el(k.svg,'defs',{}), fb=el(fd,'filter',{id:'hkb'+id,x:'-100%',y:'-20%',width:'300%',height:'140%'}); el(fb,'feGaussianBlur',{stdDeviation:5});
  const rSh=el(k.svg,'path',{},`fill:none;stroke:var(--ink);stroke-linecap:round;stroke-width:20;opacity:.32;filter:url(#hkb${id})`),
    rHi=el(k.svg,'path',{},`fill:none;stroke:#fff6ea;stroke-linecap:round;stroke-width:14;opacity:.9;filter:url(#hkb${id})`);
  const O=ovalEl(k.svg,62,96,15);
  const AR=lineEl(k.svg,'M0,0',20), head=lineEl(k.svg,'M0,0',20);
  const L=label(k.s,'อะไหล่','acc hk',0,0,124);
  UP.push(t=>{kb.style.transform='none';
    const tt=phase(t), c1=1-Math.cos(tt*Math.PI*2/1.6), c2=1-Math.cos(tt*Math.PI*2/3.2);   // 0 at tt = 0
    const hit=tt>0?bump(tt,0.78,4):0;                       // "อะไหล่สำรอง" 0.74: ring + tag kick once (hook only)
    const P={o:1,op:1,press:0,wig:[0,0,0,0],spread:0,flex:40+1.5*c1,tendon:1,pulse:0,ring:0};
    const C={...HOOKCAM,Y:HOOKCAM.Y-3*c1,S:HOOKCAM.S*(1+0.01*c2),roll:0.8*Math.sin(tt*Math.PI*2/3.2)*Math.sin(tt*Math.PI*2/3.2)};
    const r=R.draw({...P,...C}); const w=r.wrist, d=r.tendon;
    const ox=lerp(w.x,d.x,0.62), oy=lerp(w.y,d.y,0.62), rx=(u,dx)=>`${f1(lerp(w.x,d.x,u)+dx)},${f1(lerp(w.y,d.y,u))}`;
    rSh.setAttribute('d',`M${rx(0.05,9)} Q${rx(0.6,13)} ${rx(1.6,9)}`); rHi.setAttribute('d',`M${rx(0.05,-2)} Q${rx(0.6,1)} ${rx(1.6,-2)}`);
    O.set(ox,oy,1,1); O.g.setAttribute('transform',`translate(${f1(ox)} ${f1(oy)}) scale(${f3(1+0.04*c1+0.16*hit)})`);
    // tag top right of the hand, arrow curves down-left onto the ring's right edge
    const lx=790, ly=930+4*c1-10*hit; L.style.opacity='1'; L.style.left=lx+'px'; L.style.top=ly+'px';
    L.style.transform=`translate(-50%,-50%) rotate(-5deg) scale(${f3(1+0.08*hit)})`;
    const ax=lx-50, ay=ly+88, ex=ox+74, ey=oy-6;
    AR.d(`M${f1(ax)},${f1(ay)} C${f1(ax-10)},${f1(ay+90)} ${f1(ex+110)},${f1(ey-10)} ${f1(ex)},${f1(ey)}`); AR.set(1);
    head.d(`M${f1(ex+38)},${f1(ey-30)} L${f1(ex)},${f1(ey)} L${f1(ex+40)},${f1(ey+26)}`); head.set(1);});}
hookRig('hook',t=>t);
hookRig('loop',t=>t-window.__DUR);

/* see 8.86-10.48: push into the wrist, "เส้นนูน" 9.12 the tendon draws, "ข้อมือ" 9.70 the ring draws, label */
(function(){const k=fr('see'); if(!k) return; const T=tendon(k.svg,TEND,20), R=ovalEl(k.svg,100,220,11);
  const L=label(k.s,'เส้นนี้!','acc',PALM.wrist.x+170,PALM.wrist.y-250,64);
  UP.push(t=>{const u=eio((t-8.86)/1.62); k.cam(PALM.wrist.x,PALM.wrist.y-80,540,lerp(1000,900,u),lerp(1.15,1.6,u),lerp(-2,1,u));
    T.set(eio((t-9.12)/0.4),t); R.set(PALM.wrist.x,PALM.wrist.y-30,eo((t-9.7)/0.35),1+0.04*Math.sin(t*7));
    popIn(L,t,9.2,lerp(1.15,1.6,u)); if(t>9.4) L.style.transform+=` translateY(${f1(10*Math.sin(t*7))}px)`;});})();

/* spare 10.48-11.48: extreme close-up on the wrist, tendon lit; "นี่แหละ" 10.56 the "อะไหล่" tag drops on a string
   tied to the tendon and swings (damped); "อะไหล่" 10.86 it pops + sparkles */
(function(){const k=fr('spare'); if(!k) return; const T=tendon(k.svg,TEND,20); const G=tagEl(k.s,k.svg,'อะไหล่',92);
  const sparks=[0,1,2,3,4,5].map(()=>el(k.svg,'path',{d:'M0,-26 L0,26 M-26,0 L26,0'},ACC+';stroke-width:9;opacity:0'));
  UP.push(t=>{const u=eio((t-10.48)/1.0), K=lerp(1.9,2.1,u); k.cam(PALM.wrist.x,PALM.wrist.y-60,560,560,K,lerp(4,6,u));
    T.set(1,t,1);
    const drop=sp(t,10.56,11,0.5), ang=t<10.56?0:28*Math.exp(-(t-10.56)*3.2)*Math.cos((t-10.56)*9);
    G.set(PALM.wrist.x+6,PALM.wrist.y-40,lerp(40,150,clamp(drop)),ang,drop,K/(1+0.12*bump(t,10.86,5)));
    sparks.forEach((s,i)=>{const a=i*1.047+0.4, q=clamp((t-10.86)/0.5), r=60+160*eo(q);
      s.setAttribute('transform',`translate(${f1(PALM.wrist.x+6+Math.cos(a)*r/K*1.4)} ${f1(PALM.wrist.y+60+Math.sin(a)*r/K*1.4)}) scale(${f3((1-q)/K*1.6)}) rotate(${f1(q*90)})`);
      s.style.opacity=f3(q>0&&q<1?1:0);});});})();

/* muscle 11.48-12.22 (x-ray, upright): scan line sweeps; "เส้นเอ็น" 11.82 the tendon draws from the wrist down the forearm */
const XR={top:P(624,990),bot:P(606,1300),mus:P(602,1400)};
const XTEND=`M${XR.top.x},${XR.top.y} C${XR.top.x-4},${XR.top.y+100} ${XR.bot.x+4},${XR.bot.y-100} ${XR.bot.x},${XR.bot.y}`;
const MUSD=`M${XR.bot.x},${XR.bot.y-20} C${XR.bot.x+52},${XR.bot.y+40} ${XR.bot.x+58},${XR.bot.y+150} ${XR.bot.x-4},${XR.bot.y+235} C${XR.bot.x-64},${XR.bot.y+150} ${XR.bot.x-52},${XR.bot.y+40} ${XR.bot.x},${XR.bot.y-20}Z`;
function xfade(k){div(k.s,'xfade','','');}
(function(){const k=fr('muscle'); if(!k) return; xfade(k); const scan=div(k.s,'scan','',''); const T=tendon(k.svg,XTEND,16);
  const L=label(k.s,'เส้นเอ็น','acc',XR.top.x+190,XR.top.y-170,72);
  UP.push(t=>{const u=eio((t-11.48)/0.74); k.cam(560,1000,540,960,lerp(1.0,1.06,u));
    const sc=clamp((t-11.48)/0.5); scan.style.transform=`translateY(${f1(lerp(-120,1500,sc))}px)`; scan.style.opacity=f3(sc>0&&sc<1?1:0);
    T.set(eio((t-11.82)/0.3),t); popIn(L,t,11.86);});})();
/* weak 12.22-13.66 (same x-ray, later, punched in on the forearm): muscle belly fills on "ที่ร่างกาย" 12.3, "แทบไม่ต้องพึ่ง"
   12.78 the use meter drains and the muscle greys out */
(function(){const k=fr('weak'); if(!k) return; xfade(k); const T=tendon(k.svg,XTEND,16);
  const mus=el(k.svg,'path',{d:MUSD},'fill:var(--accent);stroke:var(--ink);stroke-width:10;opacity:0');
  const card=div(k.s,'meter','<div class="mt">ใช้งานน้อยมาก</div><div class="bar"><i></i></div>','');
  UP.push(t=>{const u=eio((t-12.22)/1.44), K=lerp(1.45,1.6,u); k.cam(XR.bot.x,XR.bot.y-40,520,900,K,lerp(-3,-1,u));
    T.set(1,t,1-0.6*eio((t-12.9)/0.5)); const m=clamp(sp(t,12.3,13,0.6)), dim=eio((t-12.95)/0.5);
    mus.style.opacity=f3(m*(1-0.65*dim)); mus.setAttribute('transform',`translate(${XR.bot.x} ${XR.bot.y+110}) scale(${f3(0.5+0.5*m-0.12*dim)}) translate(${-XR.bot.x} ${-XR.bot.y-110})`);
    const a=sp(t,12.78,16,0.6); card.style.opacity=f3(clamp(a*3)); card.style.transform=`translate(-50%,-50%) scale(${f3((0.7+0.3*a)/K)})`;
    card.style.left=f1(XR.bot.x)+'px'; card.style.top=f1(XR.bot.y-300)+'px';
    card.querySelector('i').style.transform=`scaleX(${f3(lerp(1,0.1,eio((t-12.95)/0.6)))})`;});})();

/* graft 13.66-14.42 (surgical team): "เอาไปใช้" 14.04 a lit spare tendon with its tag floats up into the frame */
(function(){const k=fr('graft'); if(!k) return; const sd=lineEl(k.svg,'M0,0 L1,1',24); const G=tagEl(k.s,k.svg,'อะไหล่',64);
  UP.push(t=>{const u=eio((t-13.66)/0.76); k.cam(540,960,540,960,lerp(1.0,1.08,u),lerp(1,-1,u));
    const q=clamp(sp(t,13.74,9,0.75)), y=lerp(2000,880,q), bob=10*Math.sin(t*6);
    sd.d(`M${f1(330)},${f1(y+60+bob)} C470,${f1(y-30+bob)} 610,${f1(y+90+bob)} 750,${f1(y+bob)}`); sd.set(1,q>0.01?1:0);
    G.set(600,y+bob,90,8*Math.sin(t*5),q);});})();

/* fix 14.42-15.9 (surgeon + repair panel): torn tendon; "ซ่อม" 14.5 the spare drops into the gap, stitches, a pulse runs
   the joined line, "ได้" 15.24 "ต่อแล้ว ✓" */
(function(){const k=fr('fix'); if(!k) return; const v=k.svg;
  el(v,'rect',{x:70,y:720,width:940,height:380,rx:44},'fill:var(--panel);stroke:var(--ink);stroke-width:10;opacity:.95');
  const rope=(x1,x2)=>{const g=el(v,'g',{}); el(g,'line',{x1,y1:900,x2,y2:900},'stroke:var(--ink);stroke-width:74;stroke-linecap:round');
    el(g,'line',{x1,y1:900,x2,y2:900},'stroke:var(--accent2);stroke-width:56;stroke-linecap:round');
    [-14,0,14].forEach(dy=>el(g,'line',{x1,y1:900+dy,x2,y2:900+dy},'stroke:var(--bg2);stroke-width:5;stroke-dasharray:26 14')); return g;};
  rope(160,440); rope(640,920);
  const fray=el(v,'path',{d:'M452,880 l22,-14 M452,900 l26,0 M452,920 l22,14 M628,880 l-22,-14 M628,900 l-26,0 M628,920 l-22,14'},'stroke:var(--accent2);stroke-width:7;fill:none;stroke-linecap:round');
  const Lb=label(k.s,'เอ็นขาด','neu',540,780,50);
  const sd=lineEl(v,'M0,0 L1,1',40);
  const st=el(v,'path',{d:'M440,866 l14,68 M470,866 l14,68 M596,866 l14,68 M626,866 l14,68'},'stroke:var(--ink);stroke-width:9;fill:none;stroke-linecap:round;opacity:0');
  const pulse=el(v,'path',{d:'M160,900 L920,900',pathLength:1},'stroke:var(--text);stroke-width:22;fill:none;stroke-linecap:round;stroke-dasharray:.12 1;opacity:0');
  const Lk=label(k.s,'ต่อแล้ว ✓','acc',540,1040,60);
  UP.push(t=>{const u0=eio((t-14.42)/1.48); k.cam(540,700,540,700,lerp(1.0,1.05,u0));
    const u=clamp(sp(t,14.52,9,0.7)); const a=lp(P(330,560),P(410,900),u), b=lp(P(750,600),P(670,900),u);
    sd.d(`M${f1(a.x)},${f1(a.y)} L${f1(b.x)},${f1(b.y)}`); sd.set(1,1);
    fray.style.opacity=f3(1-clamp((u-0.85)*6)); Lb.style.opacity=f3(1-clamp((t-14.6)/0.15)); Lb.style.transform='translate(-50%,-50%)';
    st.style.opacity=f3(clamp((t-14.85)/0.1));
    const pu=((t-15.0)/0.5); pulse.style.opacity=pu>0&&pu<1.6?'1':'0'; pulse.style.strokeDashoffset=f3(1.1-1.2*(pu%1));
    popIn(Lk,t,15.26);});})();

/* none 15.9-17.32 (two hands): left wrist tendon draws + "มี"; "ไม่มี" 16.32 right wrist empty dotted line + "ไม่มี" */
(function(){const k=fr('none'); if(!k) return;
  const La=label(k.s,'มี ✓','acc',300,580,64), Lb=label(k.s,'ไม่มี','neu',780,580,64);
  const ten=lineEl(k.svg,'M262,900 C258,960 254,1020 250,1080',15);
  const emp=el(k.svg,'path',{d:'M818,900 C822,960 826,1020 830,1080'},'stroke:var(--accent2);stroke-width:9;fill:none;stroke-linecap:round;stroke-dasharray:3 22;opacity:0');
  const x=lineEl(k.svg,'M770,940 L870,1040 M870,940 L770,1040',14,'var(--accent2)');
  const r1=ringEl(k.svg,96,12);
  UP.push(t=>{const u=eio((t-15.9)/1.42); k.cam(540,900,540,900,lerp(1.04,1.12,u),lerp(-1,1,u));
    ten.set(eio((t-16.0)/0.3)); r1.set(262,990,eo((t-16.05)/0.3),1+0.05*Math.sin(t*7));
    emp.style.opacity=f3(clamp((t-16.34)/0.2)); x.set(eo((t-16.4)/0.25)); popIn(La,t,16.0); popIn(Lb,t,16.34);});})();

/* one 17.32-18.84 (the same person's two palms): top "มี ✓" line draws 17.7, bottom "ไม่มี" 18.0, "ข้างเดียว" pill */
(function(){const k=fr('one'); if(!k) return;
  const Lt=label(k.s,'ข้างเดียว!','acc',540,1000,66), La=label(k.s,'ข้างนี้มี','acc',780,300,56), Lb=label(k.s,'ข้างนี้ไม่มี','neu',300,1460,56);
  const ten=lineEl(k.svg,'M800,640 C880,628 980,612 1090,600',15);
  const emp=el(k.svg,'path',{d:'M280,1760 C200,1748 100,1732 -10,1720'},'stroke:var(--accent2);stroke-width:9;fill:none;stroke-linecap:round;stroke-dasharray:3 22;opacity:0');
  UP.push(t=>{const u=eio((t-17.32)/1.52); k.cam(540,960,540,960,lerp(1.0,1.07,u),lerp(1,-1,u));
    ten.set(eio((t-17.7)/0.3)); emp.style.opacity=f3(clamp((t-18.0)/0.15));
    popIn(La,t,17.72); popIn(Lb,t,18.02); popIn(Lt,t,18.1,1,99,-3);});})();

/* grip 18.84-19.76 (hand takes the mug): ring on the hand on "จับ" 19.18 */
const GRIPP=P(300,640);
(function(){const k=fr('grip'); if(!k) return; const R=ringEl(k.svg,150,12);
  UP.push(t=>{const u=eio((t-18.84)/0.92); k.cam(GRIPP.x,GRIPP.y,540,lerp(700,680,u),lerp(1.0,1.1,u)); R.set(GRIPP.x,GRIPP.y,eo((t-19.18)/0.3),1+0.06*Math.sin(t*8));});})();

/* squeeze 19.76-21.24 (hands round a warm mug): squeeze pulses on "บีบ" 19.84, "ปกติ" 20.26 pill */
const SQ=P(600,1000);
(function(){const k=fr('squeeze'); if(!k) return; const rs=[0,1,2].map(()=>ringEl(k.svg,120,10)); const ok=label(k.s,'ปกติ ✓','acc',700,660,72);
  UP.push(t=>{const u=eio((t-19.76)/1.48); k.cam(SQ.x,SQ.y,560,lerp(860,820,u),lerp(1.0,1.12,u),lerp(-1,1,u));
    rs.forEach((r,i)=>{const q=((t-19.84-i*0.22)/0.7); const on=q>0&&t<21.2; const qq=q%1; r.set(SQ.x,SQ.y,on?1:0,0.7+0.9*qq); r.g.style.opacity=f3(on?(1-qq):0);});
    popIn(ok,t,20.28,lerp(1.0,1.12,u),99,-5);});})();

/* ball 21.24-22.38 (pitcher photo card): push in; "นักเบสบอล" 21.32 the ball leaves the hand on a dashed arc */
const BHAND=P(30,370);
(function(){const k=fr('ball'); if(!k) return;
  const arc=el(k.svg,'path',{d:`M${BHAND.x+20},${BHAND.y+10} C200,170 620,120 1060,330`,pathLength:1},ACC+';stroke-width:12;stroke-dasharray:.05 .035;opacity:0');
  const ball=el(k.svg,'circle',{r:26},'fill:var(--text);stroke:var(--ink);stroke-width:8;opacity:0');
  UP.push(t=>{const u=eio((t-21.24)/1.14); k.cam(400,600,540,800,lerp(1.05,1.18,u),lerp(-1,1,u));
    const au=clamp((t-21.34)/0.7); arc.style.opacity=au>0?'1':'0'; arc.style.strokeDashoffset=f3(1-au);
    const pt=au>0?arc.getPointAtLength(arc.getTotalLength()*eo(au)):null; ball.style.opacity=pt?'1':'0';
    if(pt){ball.setAttribute('cx',f1(pt.x));ball.setAttribute('cy',f1(pt.y));}});})();

/* elbow 22.38-24.66 (other pitcher, full frame): punch to the throwing elbow; "ข้อศอก" 22.46 ring + label; "เจ็บ" flash;
   "หมอก็เอาเส้นนี้" 22.96 the lit spare flies in; "ซ่อม" 23.84 it wraps the elbow (figure-8), "ซ่อมแล้ว ✓" */
const ELB=P(305,738);
(function(){const k=fr('elbow'); if(!k) return; const v=k.svg;
  const R=ringEl(v,110,11); const L=label(k.s,'ข้อศอก','acc',ELB.x+250,ELB.y-190,64);
  const sd=lineEl(v,'M0,0 L1,1',18); const wrap=lineEl(v,`M${ELB.x-120},${ELB.y+50} Q${ELB.x},${ELB.y-40} ${ELB.x+120},${ELB.y+30}`,18);
  const stit=el(v,'path',{d:`M${ELB.x-70},${ELB.y-14} l10,34 M${ELB.x},${ELB.y-30} l0,36 M${ELB.x+70},${ELB.y-12} l-10,34`},'stroke:var(--ink);stroke-width:8;fill:none;stroke-linecap:round;opacity:0');
  const ok=label(k.s,'ซ่อม ✓','acc',ELB.x+250,ELB.y+200,60);
  UP.push(t=>{const z=eio((t-22.38)/0.5), z2=eio((t-22.9)/1.76), K=lerp(1.25,1.75,z)+0.15*z2;
    k.cam(ELB.x,ELB.y,lerp(460,420,z),lerp(820,760,z),K,lerp(0,-3,z2));
    R.set(ELB.x,ELB.y,eo((t-22.46)/0.3)*(1-clamp((t-23.8)/0.15)),(1+0.08*Math.sin(t*9))/K*1.5); popIn(L,t,22.5,K,23.0);
    const q=clamp(sp(t,23.0,7,0.75)); const a=lp(P(1200,ELB.y-500),P(ELB.x-90,ELB.y-60),q), b=lp(P(1500,ELB.y-380),P(ELB.x+90,ELB.y+90),q);
    sd.d(`M${f1(a.x)},${f1(a.y)} L${f1(b.x)},${f1(b.y)}`); sd.set(t>=22.98&&t<23.86?1:0);
    wrap.set(eo((t-23.84)/0.3)); stit.style.opacity=f3(clamp((t-24.1)/0.1)); popIn(ok,t,24.1,K);});})();

/* ask 24.66-27.42 (hand dimmed behind): 0 / 1 / 2 cards bob, each pops on its word */
(function(){const k=fr('ask'); if(!k) return; div(k.s,'dimall','','');
  const cards=['0','1','2'].map((n,i)=>div(k.s,'numcard',n,`left:${190+i*240}px`));
  UP.push(t=>{const u=eio((t-24.66)/2.76); k.cam(560,900,540,960,lerp(1.0,1.1,u),lerp(-1,1,u));
    [25.76,26.3,26.92].forEach((at,i)=>{const c=cards[i], a=sp(t,at-0.04,18,0.55), q=clamp((t-24.74-i*0.1)/0.25), K=lerp(1.0,1.1,u);
      c.style.opacity=f3(Math.max(q*0.9,clamp(a*3))); const nxt=[26.3,26.92,99][i]-0.04; c.classList.toggle('on',t>=at-0.04&&(t<nxt||i===2));
      c.style.transform=`translateY(${f1(t<at-0.04?16*Math.sin(t*5+i*1.3):-10*Math.exp(-(t-at)*4))}px) scale(${f3((t>=at-0.04?0.85+0.15*a+0.06*Math.exp(-(t-at)*5):0.85+0.1*eo(q))/K)})`;});});})();

/* ---------- overlay layer (#epi) ---------- */
const epi=$('epi');
const bed=div(epi,'capbed','','');                                         // dark bed under the captions (white text never on white)
const cnt=div(epi,'','<div class="disc"></div>','');cnt.id='cnt';
cnt.setAttribute('data-motion-blur','off');   // the disc jumps place at each count cut: render blur smeared it across both places (ghost)
const cs=el(cnt,'svg',{viewBox:'0 0 400 400'});
const cr=el(cs,'circle',{cx:200,cy:200,r:178,pathLength:1,transform:'rotate(-90 200 200)'},ACC+';stroke-width:16;stroke-dasharray:1 1');
const nums=['3','2','1'].map(n=>div(cnt,'n',n));
const badge=$('badge');
const HARD=[['count',5.84],['count2',6.88],['count1',7.84]];
const CNT=[5.92,6.96,7.92], CNTPOS=[[660,190],[30,620],[640,300]];   // the disc changes place with each framing
window.EPI=function(t,h){ if(h) window.__DUR=h.DUR; const DD=window.__DUR||99;
  bed.style.opacity=f3(clamp((t-0.08)/0.06)*(1-clamp((t-(DD-0.2))/0.1)));   // frame 0 / last frame = clean cover
  bed.style.top=(t<1.86||t>=26.7)?'1356px':'';                              // hook / loop captions sit below the hand card
  const bp=DD/Math.max(1,Math.round(DD/1.6));                              // whole cycles in the clip: last frame = frame 0
  badge.style.transform=`scale(${f3(1+0.015*(1-Math.cos(t*Math.PI*2/bp)))})`;
  const ci=clamp((t-5.84)/0.12)*(1-clamp((t-8.8)/0.06));
  const j=t<6.88?0:t<7.84?1:2; cnt.style.left=CNTPOS[j][0]+'px'; cnt.style.top=CNTPOS[j][1]+'px';
  cnt.style.opacity=f3(ci); cnt.style.transform=`scale(${f3(0.8+0.2*eo((t-5.84)/0.2))}) rotate(${f1(4*Math.sin(t*3))}deg)`;
  cr.style.strokeDashoffset=f3(clamp((t-5.92)/2.9));
  CNT.forEach((at,i)=>{const nx=[6.96,7.92,8.86][i], on=t>=at-0.03&&t<nx-0.03, a=sp(t,at-0.03,22,0.45);
    nums[i].style.opacity=on?f3(clamp(a*4)):'0'; nums[i].style.transform=`translateY(${f1(-14*Math.abs(Math.sin((t-at)*5))*Math.exp(-(t-at)*1.5))}px) scale(${f3(0.5+0.5*a)})`;});
  for(const u of UP) u(t);
  // count / count2 / count1: hard cut (the template's 0.1 s match fade between two rig drawings read as a ghost hand)
  HARD.forEach(([id,a])=>{const e=$('sh-'+id); if(e&&t>=a&&t<a+0.12) e.style.opacity='1';});
  // loop seam: the title's breathing runs on t - DUR after it springs back, so the last frame = frame 0 exactly
  if(t>=DD-0.3){const ti=$('title'), m=/scale\(([\d.]+)\)/.exec(ti.style.transform||''), br=1+0.02*(1-Math.cos(t*Math.PI*2/1.6)), br2=1+0.02*(1-Math.cos((t-DD)*Math.PI*2/1.6));
    if(m) ti.style.transform=`scale(${(parseFloat(m[1])/br*br2).toFixed(4)})`;}
};
})();
