/* Palmaris test ("ลองทำตาม #1") v2: episode graphics for the brainrot-v3 template.
   Everything is a pure function of t (seek-safe). Colours come only from the look's CSS variables.
   - Drawn hand (Hand rig) for the user slots hook / pinch / flex / count / see / loop and for graft / ask. Slot shots
     (#g-<id>) are built only while episode.json plates[id] == "graphic": when a slot becomes user footage the drawing
     for that shot is not built; the overlay layer (#epi: 3-2-1 count, "ปกติ" pill, caption bed, badge) stays.
   - Footage shots (muscle, rare, none, grip, one, fix, ball) get an overlay layer inside the shot's own push layer
     (#kb-<id>) so lines and rings stay on the picture while the template pushes in.
   Word times below are from assets/audio/words.json (shot starts/ends: assets/audio/shots-th.json). */
(function(){
const NS='http://www.w3.org/2000/svg';
const $=id=>document.getElementById(id);
const clamp=(x,a=0,b=1)=>Math.min(b,Math.max(a,x)), lerp=(a,b,u)=>a+(b-a)*u;
const eo=x=>{x=clamp(x);return 1-Math.pow(1-x,3)}, eio=x=>{x=clamp(x);return x*x*x*(x*(6*x-15)+10)};
const S=(tau,w,z)=>{if(tau<=0)return 0; if(z<1){const wd=w*Math.sqrt(1-z*z);
  return 1-Math.exp(-z*w*tau)*(Math.cos(wd*tau)+z*w/wd*Math.sin(wd*tau));} return 1-Math.exp(-w*tau)*(1+w*tau);};
const sp=(t,at,w=16,z=0.62)=>S(t-at,w,z);          // spring 0 -> 1 starting at word time `at`
const bump=(t,at,k=6)=>t>=at?Math.exp(-(t-at)*k):0;  // 1 at the word, decays
const P=(x,y)=>({x,y}), sub=(a,b)=>P(a.x-b.x,a.y-b.y), hyp=a=>Math.hypot(a.x,a.y), lp=(a,b,u)=>P(lerp(a.x,b.x,u),lerp(a.y,b.y,u));
const f1=v=>v.toFixed(1), f3=v=>v.toFixed(3), rad=d=>d*Math.PI/180;
function el(parent,tag,attrs,style){const e=document.createElementNS(NS,tag);for(const k in attrs)e.setAttribute(k,attrs[k]);
  if(style)e.setAttribute('style',style); parent.appendChild(e); return e;}
function div(parent,cls,html,style){const e=document.createElement('div'); e.className=cls; e.innerHTML=html; if(style)e.setAttribute('style',style); parent.appendChild(e); return e;}
const INK='stroke:var(--ink);fill:none;stroke-linecap:round;stroke-linejoin:round';
const ACC='stroke:var(--accent);fill:none;stroke-linecap:round;stroke-linejoin:round';
const CRS='stroke:var(--crease);fill:none;stroke-linecap:round';
const cam=(g,fx,fy,X,Y,s,r=0,sx=1)=>g.setAttribute('transform',`translate(${f1(X)} ${f1(Y)}) rotate(${r.toFixed(2)}) scale(${(s*sx).toFixed(4)} ${s.toFixed(4)}) translate(${f1(-fx)} ${f1(-fy)})`);
// closed smooth path through points (Catmull-Rom -> cubic Bezier)
function smooth(pts){const n=pts.length; let d=`M${f1(pts[0].x)},${f1(pts[0].y)}`;
  for(let i=0;i<n;i++){const p0=pts[(i-1+n)%n],p1=pts[i],p2=pts[(i+1)%n],p3=pts[(i+2)%n];
    d+=` C${f1(p1.x+(p2.x-p0.x)/6)},${f1(p1.y+(p2.y-p0.y)/6)} ${f1(p2.x-(p3.x-p1.x)/6)},${f1(p2.y-(p3.y-p1.y)/6)} ${f1(p2.x)},${f1(p2.y)}`;}
  return d+'Z';}

/* ---------- Hand rig v2 ----------
   Left hand seen from the PALM side, fingers up: thumb on the viewer's left, little finger on the right.
   Test pose (pinch=1): thumb tip crosses the palm and touches the little-finger tip, index/middle/ring stay straight.
   Fingers are tapered limbs (circles at the joints + tangent quads), outline pass then fill pass, crease at each joint. */
const WR=P(540,1085);                                        // wrist centre (hand-local)
const PALM=[P(402,1085),P(370,1010),P(350,930),P(352,850),P(372,772),P(398,714),P(470,686),P(555,680),P(640,692),
            P(700,720),P(722,782),P(726,862),P(714,960),P(690,1040),P(678,1085)];
const FINGERS=[ // base, direction (deg from up, + = clockwise), segment lengths, radii (base -> tip)
  {b:P(420,722),d:-9,L:[110,68,56],r:[39,35,32,30]},
  {b:P(512,704),d:-2,L:[122,76,60],r:[41,37,33,31]},
  {b:P(602,712),d:6,L:[114,70,56],r:[38,34,31,29]}];
const PINKY={b:P(682,748),d:16,L:[88,54,46],r:[33,30,27,25]};
const THUMB={b:P(432,1000),Lm:112,L:[92,76],r:[44,38,34,31],rest:P(246,756)};
const C=P(598,792);                                          // thumb tip meets little-finger tip here
const TEND='M540,1092 C540,1180 538,1290 535,1430';           // palmaris longus tendon, wrist -> forearm
const RING=P(540,1172);
const FORE='M404,1080 C392,1300 372,1650 350,2150 L752,2150 C724,1650 694,1300 680,1080 Z';
let uid=0;
function Limb(gO,gF,gT,n){const mk=g=>({c:[...Array(n+1)].map(()=>el(g,'circle',{})),q:[...Array(n)].map(()=>el(g,'polygon',{}))});
  const o=mk(gO),f=mk(gF),t=gT?mk(gT):null;
  const set=(m,p,r,w)=>{p.forEach((q,i)=>{m.c[i].setAttribute('cx',f1(q.x));m.c[i].setAttribute('cy',f1(q.y));m.c[i].setAttribute('r',f1(r[i]+w));});
    for(let i=0;i<n;i++){const a=p[i],b=p[i+1],d=sub(b,a),L=hyp(d)||1,nx=-d.y/L,ny=d.x/L,ra=r[i]+w,rb=r[i+1]+w;
      m.q[i].setAttribute('points',[P(a.x+nx*ra,a.y+ny*ra),P(b.x+nx*rb,b.y+ny*rb),P(b.x-nx*rb,b.y-ny*rb),P(a.x-nx*ra,a.y-ny*ra)].map(q=>f1(q.x)+','+f1(q.y)).join(' '));}};
  return {update(p,r){set(o,p,r,10);set(f,p,r,0);if(t)set(t,p,r,0);}};}
function chainA(B,angs,L){const out=[B];let p=B;angs.forEach((a,i)=>{p=P(p.x+L[i]*Math.sin(rad(a)),p.y-L[i]*Math.cos(rad(a)));out.push(p);});return out;}
function ik(A,T,l1,l2,sgn){const d0=sub(T,A); const d=Math.max(Math.abs(l1-l2)+1,Math.min(hyp(d0),l1+l2-0.5));
  const ang=Math.atan2(d0.y,d0.x), c=clamp((l1*l1+d*d-l2*l2)/(2*l1*d),-1,1), a1=ang+sgn*Math.acos(c);
  const J=P(A.x+l1*Math.cos(a1),A.y+l1*Math.sin(a1)); return [J,P(A.x+d*Math.cos(ang),A.y+d*Math.sin(ang))];}
function creases(g,n){return [...Array(n)].map(()=>el(g,'path',{},CRS+';stroke-width:5'));}
function setCrease(e,a,b,r,k=0.62){const d=sub(b,a),L=hyp(d)||1,nx=-d.y/L,ny=d.x/L,w=r*k,bx=-d.x/L*6,by=-d.y/L*6;
  e.setAttribute('d',`M${f1(a.x+nx*w)},${f1(a.y+ny*w)} Q${f1(a.x+bx)},${f1(a.y+by)} ${f1(a.x-nx*w)},${f1(a.y-ny*w)}`);}

function Hand(svg){
  const id='h'+(uid++), defs=el(svg,'defs',{});
  const gr=el(defs,'linearGradient',{id:id+'g',x1:0,y1:0,x2:1,y2:0});
  [[0,'--skin2'],[0.3,'--skin'],[0.7,'--skin'],[1,'--skin2']].forEach(([o,v])=>el(gr,'stop',{offset:o},`stop-color:var(${v})`));
  const g=el(svg,'g',{});
  el(g,'path',{d:FORE},`fill:url(#${id}g);stroke:var(--ink);stroke-width:12;stroke-linejoin:round`);
  const hand=el(g,'g',{});
  // fingers (index, middle, ring) behind the palm: outlines of all three, then fills, then joint creases
  const fO=el(hand,'g',{},'fill:var(--ink)'), fF=el(hand,'g',{},'fill:var(--skin)');
  const fingers=FINGERS.map(()=>Limb(fO,fF,null,3)); const fC=FINGERS.map(()=>creases(hand,2));
  el(hand,'path',{d:smooth(PALM)},'fill:var(--skin);stroke:var(--ink);stroke-width:12;stroke-linejoin:round');
  const palmShade=el(hand,'path',{d:smooth(PALM)},'fill:var(--bg2);opacity:0');
  el(hand,'path',{d:'M455,700 C470,740 470,760 452,790'},CRS+';stroke-width:5;opacity:.0');
  el(hand,'path',{d:'M722,790 C660,792 600,770 520,728'},CRS+';stroke-width:6');       // heart line
  el(hand,'path',{d:'M372,800 C450,812 520,842 590,900'},CRS+';stroke-width:6');       // head line
  const lifeL=el(hand,'path',{d:'M392,780 C470,840 480,960 470,1060'},CRS+';stroke-width:6'); // life line (thenar)
  // little finger (in front of the palm once it folds)
  const pO=el(hand,'g',{},'fill:var(--ink)'), pF=el(hand,'g',{},'fill:var(--skin)'), pT=el(hand,'g',{},'fill:var(--accent);opacity:0');
  hand.insertBefore(el(hand,'circle',{cx:PINKY.b.x,cy:PINKY.b.y+8,r:28},'fill:var(--skin)'),pT);
  const pinky=Limb(pO,pF,pT,3); const pC=creases(hand,2);
  // thumb (crosses in front of everything)
  const tO=el(hand,'g',{},'fill:var(--ink)'), tF=el(hand,'g',{},'fill:var(--skin)'), tT=el(hand,'g',{},'fill:var(--accent);opacity:0');
  const thumb=Limb(tO,tF,tT,3); const tC=creases(hand,1);
  const nail=el(hand,'ellipse',{rx:20,ry:15},'fill:var(--skin);stroke:var(--crease);stroke-width:5;opacity:0');
  const spark=el(hand,'circle',{cx:C.x,cy:C.y,r:70},ACC+';stroke-width:12;opacity:0');
  const sparkI=el(hand,'circle',{cx:C.x,cy:C.y,r:70},INK+';stroke-width:24;opacity:0'); hand.insertBefore(sparkI,spark);
  const tips=[0,1].map(()=>{const gg=el(hand,'g',{},'opacity:0'); el(gg,'circle',{r:58},INK+';stroke-width:24'); el(gg,'circle',{r:58},ACC+';stroke-width:12'); return gg;});
  // wrist creases (deepen when the wrist bends)
  const wc=[el(g,'path',{d:'M410,1100 Q540,1122 672,1100'},CRS+';stroke-width:7'),el(g,'path',{d:'M408,1128 Q540,1150 674,1128'},CRS+';stroke-width:6')];
  // tendon: relief (shadow + light), ghost (after it is lifted out), highlight with ink border, glow
  const tShade=el(g,'path',{d:TEND,transform:'translate(10 0)'},'stroke:var(--skin2);stroke-width:30;fill:none;stroke-linecap:round;opacity:0');
  const tLite=el(g,'path',{d:TEND,transform:'translate(-7 0)'},'stroke:var(--skin);stroke-width:16;fill:none;stroke-linecap:round;opacity:0');
  const ghost=el(g,'path',{d:TEND},'stroke:var(--crease);stroke-width:8;fill:none;stroke-linecap:round;stroke-dasharray:4 24;opacity:0');
  const tGlow=el(g,'path',{d:TEND},ACC+';stroke-width:76;opacity:0');
  const tInk=el(g,'path',{d:TEND,pathLength:1},INK+';stroke-width:34;opacity:0;stroke-dasharray:1 1');
  const tAcc=el(g,'path',{d:TEND,pathLength:1},ACC+';stroke-width:18;opacity:0;stroke-dasharray:1 1');
  const ringI=el(g,'circle',{cx:RING.x,cy:RING.y,r:104,pathLength:1},INK+';stroke-width:28;opacity:0;stroke-dasharray:1 1');
  const ring=el(g,'circle',{cx:RING.x,cy:RING.y,r:104,pathLength:1},ACC+';stroke-width:15;opacity:0;stroke-dasharray:1 1');
  return {g, hand, update(o){
    const p=clamp(o.pinch||0,0,1.08), f=o.flex||0, pop=o.pop||0, hl=o.hl||0, draw=o.draw==null?1:o.draw, sp_=o.spread||[0,0,0,0];
    hand.setAttribute('transform',`translate(${WR.x} ${WR.y}) scale(${f3(1+0.04*f)} ${f3(1-0.24*f)}) translate(${-WR.x} ${-WR.y})`);
    palmShade.style.opacity=f3(0.22*f);
    FINGERS.forEach((F,i)=>{const a=F.d+sp_[i]; const pts=chainA(F.b,[a,a+2+3*p,a+4+4*p],F.L); fingers[i].update(pts,F.r);
      setCrease(fC[i][0],pts[1],pts[2],F.r[1]); setCrease(fC[i][1],pts[2],pts[3],F.r[2]);});
    // little finger: folds toward the thumb (segments swing left and shorten as they come toward the viewer)
    const pa=PINKY.d+sp_[3], q=clamp(p);
    const pp=chainA(PINKY.b,[lerp(pa,-32,q),lerp(pa,-118,q),lerp(pa,-162,q)],PINKY.L.map((L,i)=>L*lerp(1,[0.8,0.9,0.92][i],q)));
    pinky.update(pp,PINKY.r); setCrease(pC[0],pp[1],pp[2],PINKY.r[1]); setCrease(pC[1],pp[2],pp[3],PINKY.r[2]);
    // thumb: metacarpal swings across the thenar, the two phalanges reach (IK) for the little-finger tip
    const aM=lerp(-42,30,p), M1=P(THUMB.b.x+THUMB.Lm*Math.sin(rad(aM)),THUMB.b.y-THUMB.Lm*Math.cos(rad(aM)));
    const tw=sub(M1,pp[3]), twl=hyp(tw)||1, T=lp(THUMB.rest,P(pp[3].x+tw.x/twl*50,pp[3].y+tw.y/twl*50),q);   /* pad to pad, tips touch */ const [J,tip]=ik(M1,T,THUMB.L[0],THUMB.L[1],-1);
    thumb.update([THUMB.b,M1,J,tip],THUMB.r); setCrease(tC[0],J,tip,THUMB.r[2]);
    const dd=sub(tip,J),L=hyp(dd)||1; nail.setAttribute('cx',f1(tip.x-dd.x/L*8)); nail.setAttribute('cy',f1(tip.y-dd.y/L*8));
    nail.setAttribute('transform',`rotate(${f1(Math.atan2(dd.y,dd.x)*180/Math.PI)} ${f1(tip.x-dd.x/L*8)} ${f1(tip.y-dd.y/L*8)})`); nail.style.opacity=f3(clamp(q*1.4-0.3));
    pT.style.opacity=tT.style.opacity=f3(0.85*(o.tint||0));
    lifeL.style.opacity=f3(1-0.6*q);
    const sk=o.spark||0; spark.style.opacity=sparkI.style.opacity=f3(clamp(sk*2)*(sk>0?1:0)); [spark,sparkI].forEach(e=>{e.setAttribute('r',f1(46+50*sk));e.setAttribute('cx',f1(tip.x));e.setAttribute('cy',f1(tip.y));});
    tips[0].setAttribute('transform',`translate(${f1(tip.x)} ${f1(tip.y)}) scale(${f3(0.6+0.4*(o.tipT||0))})`); tips[0].style.opacity=f3(clamp((o.tipT||0)*3));
    tips[1].setAttribute('transform',`translate(${f1(pp[3].x)} ${f1(pp[3].y)}) scale(${f3(0.6+0.4*(o.tipP||0))})`); tips[1].style.opacity=f3(clamp((o.tipP||0)*3));
    wc[0].style.strokeWidth=f1(7+5*f); wc[1].style.strokeWidth=f1(6+4*f);
    tShade.style.opacity=f3(0.9*pop); tShade.style.strokeWidth=f1(14+24*pop); tLite.style.opacity=f3(0.9*pop);
    ghost.style.opacity=f3(o.ghost||0);
    tInk.style.opacity=tAcc.style.opacity=f3(hl); tInk.style.strokeDashoffset=tAcc.style.strokeDashoffset=f3(1-draw);
    tGlow.style.opacity=f3(0.3*hl*(o.glow==null?1:o.glow));
    const rr=104+12*(o.ringPulse||0);
    [ringI,ring].forEach(e=>{e.style.opacity=(o.ring||0)>0?'1':'0'; e.style.strokeDashoffset=f3(1-(o.ring||0)); e.setAttribute('r',f1(rr));});
  }};
}
function slot(id){const s=$('g-'+id); if(!s) return null; const svg=el(s,'svg',{class:'gsvg',viewBox:'0 0 1080 1920',width:1080,height:1920}); return {s,svg};}
// overlay on a footage shot: a layer inside the shot's push (#kb-<id>) so it moves with the picture
function over(id){const kb=$('kb-'+id); if(!kb||$('g-'+id)) return null; const s=div(kb,'ov','',''); const svg=el(s,'svg',{class:'gsvg',viewBox:'0 0 1080 1920',width:1080,height:1920}); return {s,svg};}
function label(parent,txt,cls,x,y,size){return div(parent,'lab '+cls,txt,`left:${x}px;top:${y}px;font-size:${size||52}px`);}
const popIn=(e,t,at,sx=1,out=99)=>{const a=sp(t,at,20,0.55), o=1-clamp((t-out)/0.15); e.style.opacity=f3(clamp(a*3)*o); e.style.transform=`translate(-50%,-50%) scale(${f3(sx*(0.6+0.4*a))})`;};
function ringEl(svg,r){const g=el(svg,'g',{}); el(g,'circle',{r,pathLength:1},INK+';stroke-width:26;stroke-dasharray:1 1'); el(g,'circle',{r,pathLength:1},ACC+';stroke-width:13;stroke-dasharray:1 1');
  return {g,set(x,y,u,s=1){g.setAttribute('transform',`translate(${f1(x)} ${f1(y)}) scale(${f3(s)})`); g.style.opacity=u>0.001?'1':'0'; g.querySelectorAll('circle').forEach(c=>c.style.strokeDashoffset=f3(1-clamp(u)));}};}
function lineEl(svg,d,w=18){const g=el(svg,'g',{}); const i=el(g,'path',{d,pathLength:1},INK+`;stroke-width:${w+16};stroke-dasharray:1 1`), a=el(g,'path',{d,pathLength:1},ACC+`;stroke-width:${w};stroke-dasharray:1 1`);
  return {g,set(u,o=1){[i,a].forEach(e=>e.style.strokeDashoffset=f3(1-clamp(u))); g.style.opacity=f3(u>0.001?o:0);},d(dd){i.setAttribute('d',dd);a.setAttribute('d',dd);}};}

/* ---------- per-shot builders: each pushes an update(t) ---------- */
const UP=[];
// hook + loop share one look: test pose, tendon raised + accent, ring. Frame 0 = cover. Motion: thumb taps the little
// finger (period 0.8 s), ring + glow breathe (1.6 s); the loop uses t-DUR so its last frame = frame 0.
const HOOKCAM=[540,RING.y,540,1040,0.86];
function hookLike(id,phase){const k=slot(id); if(!k) return; const A=Hand(k.svg);
  UP.push(t=>{const tt=phase(t), b=0.5+0.5*Math.cos(tt*Math.PI*2/1.6), tap=0.5-0.5*Math.cos(tt*Math.PI*2/0.8);
    cam(A.g,...HOOKCAM, 1.2*Math.sin(tt*Math.PI*2/1.6));
    A.update({pinch:1-0.16*tap,flex:0.55,pop:1,hl:1,ring:1,tint:1,glow:0.55+0.45*b,ringPulse:b});});}
hookLike('hook',t=>t);
hookLike('loop',t=>t-window.__DUR);

// pinch 1.52-4.26: "ลองเลย" hand springs in and wiggles open; "ประกบ" 2.48 thumb + little finger travel together
// (one spring, settles on "นิ้วก้อย" 3.5-3.9); tips ringed as they are named; contact spark; tint marks the pair
(function(){const k=slot('pinch'); if(!k) return; const A=Hand(k.svg);
  const Lt=label(k.s,'นิ้วโป้ง','acc',230,560,54), Lp=label(k.s,'นิ้วก้อย','acc',870,470,54);
  UP.push(t=>{const ent=sp(t,1.52,9,0.7), p=sp(t,2.55,5.2,0.72), wig=Math.sin((t-1.52)*11)*(1-clamp((t-2.4)/0.3))*clamp((t-1.6)/0.2);
    const z=eio((t-3.6)/0.66);
    cam(A.g,560,800,540,lerp(1000,640,ent)+lerp(0,-20,z),lerp(1.22,1.3,z),lerp(-10,0,ent)+0.8*Math.sin(t*3));
    A.update({pinch:p,flex:0,pop:0.2,spread:[-5*wig,-2*wig,2*wig,6*wig],tint:clamp((p-0.5)*2),
      spark:t>=3.62?clamp((t-3.62)/0.3)*(1-clamp((t-3.92)/0.18)):0});
    popIn(Lt,t,3.0,1,4.1); popIn(Lp,t,3.5,1,4.1);});})();
// flex 4.26-5.9: "งอ" 4.34 the wrist bends toward the viewer (hand foreshortens), arrow shows the bend, the tendon
// rises at the wrist; "นิดนึง" 4.9 a small extra nudge; camera follows down to the wrist
(function(){const k=slot('flex'); if(!k) return; const A=Hand(k.svg);
  const arr=el(k.svg,'g',{}); const aPath='M820,560 C930,640 950,800 880,920';
  const aI=el(arr,'path',{d:aPath,pathLength:1},INK+';stroke-width:34;stroke-dasharray:1 1'), aA=el(arr,'path',{d:aPath,pathLength:1},ACC+';stroke-width:18;stroke-dasharray:1 1');
  const head=el(arr,'path',{d:'M836,900 L884,930 L900,872'},ACC+';stroke-width:18'); const headI=el(arr,'path',{d:'M836,900 L884,930 L900,872'},INK+';stroke-width:34'); arr.insertBefore(headI,head);
  const L=label(k.s,'งอเข้าหาตัว','acc',640,1010,52);
  UP.push(t=>{const f=sp(t,4.36,8,0.72)+0.12*Math.sin(clamp((t-4.9)/0.45)*Math.PI), z=eio((t-4.3)/1.2);
    cam(A.g,lerp(560,545,z),lerp(800,1000,z),540,lerp(620,780,z),lerp(1.3,1.0,z),0.6*Math.sin(t*3.2));
    A.update({pinch:1,flex:f,pop:clamp((t-4.5)/0.9),tint:1,hl:0});
    const u=eo((t-4.36)/0.45); [aI,aA].forEach(e=>e.style.strokeDashoffset=f3(1-u)); arr.style.opacity=f3((u>0?1:0)*(1-clamp((t-5.6)/0.25)));
    head.style.opacity=headI.style.opacity=f3(clamp((u-0.85)*7)); popIn(L,t,4.5,1,5.65);});})();
// count 5.9-8.26: hold the pose but alive: hand trembles a little (holding it is effort), every number gives a pulse,
// the tendon relief throbs with the beats
(function(){const k=slot('count'); if(!k) return; const A=Hand(k.svg);
  UP.push(t=>{const beat=[5.98,6.84,7.62].reduce((m,a)=>Math.max(m,bump(t,a,5)),0), u=eio((t-5.9)/2.36);
    const tr=1.1*Math.sin(t*17)+0.6*Math.sin(t*23.3), br=Math.sin(t*2.6);
    cam(A.g,545,1060,540+3*Math.sin(t*13),lerp(1000,1030,u)+5*br,lerp(0.92,1.0,u)+0.035*beat,tr*0.5+1.5*br);
    A.update({pinch:1-0.03*Math.abs(Math.sin(t*9)),flex:1+0.05*beat,pop:0.85+0.15*beat,tint:1,hl:0});});})();
// see 8.26-10.34: push into the wrist, the raised line lights up on "นูน" 8.8, ring draws on "ข้อมือ" 9.24
(function(){const k=slot('see'); if(!k) return; const A=Hand(k.svg);
  const L=label(k.s,'เส้นนี้!','acc',800,700,64);
  UP.push(t=>{const z=eio((t-8.26)/1.0); cam(A.g,540,lerp(1060,1180,z),540,lerp(1030,860,z),lerp(1.0,1.85,z),0.8*Math.sin(t*2.5));
    const h=clamp(sp(t,8.8,14,0.7)); A.update({pinch:1,flex:1,pop:1,hl:h,draw:h,tint:0.6,glow:0.6+0.4*Math.sin(t*6),ring:eo((t-9.24)/0.35),ringPulse:0.5+0.5*Math.sin(t*6)});
    popIn(L,t,8.86);});})();

// muscle 10.34-12.44 (x-ray footage): scan line sweeps the x-ray; "เส้นเอ็น" 10.66 the tendon draws from the wrist down
// the forearm; "กล้ามเนื้อ" 11.24 the small muscle belly fills in; "เล็กๆ" 11.56 squeezes
const XR={top:P(624,990),bot:P(606,1270),mus:P(600,1370)};   // wrist centre / tendon end / muscle belly in plate px
const MUSD=`M${XR.bot.x},${XR.bot.y-20} C${XR.bot.x+52},${XR.bot.y+40} ${XR.bot.x+58},${XR.bot.y+150} ${XR.bot.x-4},${XR.bot.y+235} C${XR.bot.x-64},${XR.bot.y+150} ${XR.bot.x-52},${XR.bot.y+40} ${XR.bot.x},${XR.bot.y-20}Z`;
function xrayBase(k){const sv=k.svg;
  div(k.s,'xfade','','');                                         // fades the plate's cut-off bottom + hides the x-ray stand
  const mus=el(sv,'path',{d:MUSD},'fill:var(--accent);stroke:var(--ink);stroke-width:10;opacity:0');
  const ml=el(sv,'path',{d:`M${XR.bot.x-14},${XR.bot.y+30} C${XR.bot.x-26},${XR.bot.y+100} ${XR.bot.x-22},${XR.bot.y+160} ${XR.bot.x-6},${XR.bot.y+210} M${XR.bot.x+14},${XR.bot.y+30} C${XR.bot.x+24},${XR.bot.y+100} ${XR.bot.x+20},${XR.bot.y+160} ${XR.bot.x+4},${XR.bot.y+210}`},'stroke:var(--ink);stroke-width:5;fill:none;opacity:0');
  const ten=lineEl(sv,`M${XR.top.x},${XR.top.y} C${XR.top.x-4},${XR.top.y+100} ${XR.bot.x+4},${XR.bot.y-100} ${XR.bot.x},${XR.bot.y}`,16);
  const fan=lineEl(sv,`M${XR.top.x},${XR.top.y} L${XR.top.x-70},${XR.top.y-140} M${XR.top.x},${XR.top.y} L${XR.top.x+6},${XR.top.y-170} M${XR.top.x},${XR.top.y} L${XR.top.x+80},${XR.top.y-140}`,9);
  return {mus,ml,ten,fan,setMus(m,dim,pulse){const o=f3(m*(1-0.7*dim)); mus.style.opacity=o; ml.style.opacity=o;
    mus.setAttribute('transform',`translate(${XR.bot.x} ${XR.bot.y+110}) scale(${f3(0.5+0.5*m+0.1*pulse)} ${f3(0.5+0.5*m-0.08*pulse)}) translate(${-XR.bot.x} ${-XR.bot.y-110})`);
    ml.setAttribute('transform',mus.getAttribute('transform'));}};}
(function(){const k=over('muscle'); if(!k) return; const B=xrayBase(k);
  const scan=div(k.s,'scan','',''); const L1=label(k.s,'เส้นเอ็น','acc',630,860,58), L2=label(k.s,'กล้ามเนื้อเล็กๆ','acc',350,1320,54);
  UP.push(t=>{const sc=clamp((t-10.34)/0.55); scan.style.transform=`translateY(${f1(lerp(-120,1500,sc))}px)`; scan.style.opacity=f3(sc>0&&sc<1?1:0);
    B.ten.set(eio((t-10.66)/0.45)); B.fan.set(eo((t-10.95)/0.35),0.9);
    B.setMus(clamp(sp(t,11.24,13,0.6)),0,bump(t,11.56,5)*Math.sin((t-11.56)*16));
    popIn(L1,t,10.7); popIn(L2,t,11.3);});})();
// rare 12.44-14.32 (same x-ray, later): "ร่างกาย" all on; "แทบไม่ต้องพึ่ง" 13.04 the muscle greys out and a use-meter drains
(function(){const k=over('rare'); if(!k) return; const B=xrayBase(k);
  const L2=label(k.s,'กล้ามเนื้อเล็กๆ','acc',350,1320,54);
  const card=div(k.s,'meter','<div class="mt">หน้าที่น้อยมาก</div><div class="bar"><i></i></div>','');
  UP.push(t=>{B.ten.set(1,1-0.3*eio((t-13.04)/0.5)); B.fan.set(1,0.9);
    const dm=eio((t-13.04)/0.5); B.setMus(1,dm,0); L2.style.opacity=f3(1-0.5*dm); L2.style.transform='translate(-50%,-50%)';
    const a=sp(t,12.95,16,0.6); card.style.opacity=f3(clamp(a*3)); card.style.transform=`translate(-50%,-50%) scale(${f3(0.7+0.3*a)})`;
    card.querySelector('i').style.transform=`scaleX(${f3(lerp(1,0.12,eio((t-13.2)/0.6)))})`;});})();
// none 14.32-16.08 (two 3D hands): "บางคน" labels; left wrist gets the tendon line, right wrist an empty dotted outline
(function(){const k=over('none'); if(!k) return;
  const La=label(k.s,'มีเส้น','acc',270,480,58), Lb=label(k.s,'ไม่มีเส้น','neu',740,480,58);
  const ten=lineEl(k.svg,'M262,880 C258,940 254,1000 250,1066',15);
  const emp=el(k.svg,'path',{d:'M818,880 C822,940 826,1000 830,1066'},'stroke:var(--accent2);stroke-width:8;fill:none;stroke-linecap:round;stroke-dasharray:3 22;opacity:0');
  const r1=ringEl(k.svg,86), r2=ringEl(k.svg,86);
  UP.push(t=>{ten.set(eio((t-14.45)/0.35)); r1.set(262,1000,eo((t-14.5)/0.3),1+0.05*Math.sin(t*7));
    emp.style.opacity=f3(clamp((t-14.8)/0.2)); r2.set(818,1000,0); popIn(La,t,14.45); popIn(Lb,t,14.8);});})();
// one 18.42-20.58 (twist: the same person's two palms): top palm "มี" line draws, bottom "ไม่มี", then "ข้างเดียว"
(function(){const k=over('one'); if(!k) return;
  const Lt=label(k.s,'คนเดียวกัน','acc',540,1010,58), La=label(k.s,'มี','acc',800,440,60), Lb=label(k.s,'ไม่มี','neu',150,1460,60);
  const ten=lineEl(k.svg,'M800,640 C880,628 980,612 1090,600',15);
  const emp=el(k.svg,'path',{d:'M280,1780 C200,1768 100,1752 -10,1740'},'stroke:var(--accent2);stroke-width:8;fill:none;stroke-linecap:round;stroke-dasharray:3 22;opacity:0');
  UP.push(t=>{ten.set(eio((t-18.5)/0.3)); emp.style.opacity=f3(clamp((t-19.0)/0.15));
    popIn(La,t,18.6); popIn(Lb,t,19.06); popIn(Lt,t,19.34);});})();
// graft 20.58-23.12 (surgery footage + drawn arm): "เส้นนี้" 21.06 tendon glows; "หมอ" 21.56 it lifts out of the arm
// (dotted ghost stays, no wound) and floats up as a spare; "เอ็นสำรอง" 22.18 label
const SPARE={y:560,x0:330,x1:750};
(function(){const k=over('graft'); if(!k) return; div(k.s,'dim','',''); const A=Hand(k.svg);
  const sd=lineEl(k.svg,'M0,0 L1,1',22); const L=label(k.s,'เอ็นสำรอง','acc',540,450,66);
  UP.push(t=>{const z=eio((t-20.58)/2.5), s=lerp(0.78,0.74,z), X=540, Y=lerp(1180,1200,z), fx=540, fy=1180;
    cam(A.g,fx,fy,X,Y,s,0.6*Math.sin(t*2));
    const u=clamp(sp(t,21.6,6.5,0.75)), lifted=t>=21.6;
    A.update({pinch:0.0,flex:0,pop:lifted?1-clamp(u*2):1,hl:lifted?0:clamp((t-20.7)/0.3),glow:0.6+0.4*bump(t,21.06,4),ghost:clamp(u*2)});
    // tendon ends on screen (local 1092..1430 through the same camera)
    const a0=P(X+(540-fx)*s,Y+(1092-fy)*s), b0=P(X+(535-fx)*s,Y+(1430-fy)*s), lift=Math.sin(Math.PI*u)*140;
    const a=P(lerp(a0.x,SPARE.x1,u)+lift*0.4,lerp(a0.y,SPARE.y,u)-lift), b=P(lerp(b0.x,SPARE.x0,u)-lift*0.4,lerp(b0.y,SPARE.y,u)-lift);
    const bob=lifted?8*Math.sin((t-21.6)*5):0;
    sd.d(`M${f1(a.x)},${f1(a.y+bob)} L${f1(b.x)},${f1(b.y+bob)}`); sd.set(1,lifted?1:0);
    popIn(L,t,22.2);});})();
// fix 23.12-24.82 (surgeon footage + diagram): a torn ligament; "ซ่อม" 23.2 the spare drops into the gap, stitches,
// one pulse runs along the joined line, "ต่อแล้ว ✓"
(function(){const k=over('fix'); if(!k) return; const v=k.svg;
  const pan=el(v,'rect',{x:70,y:330,width:940,height:700,rx:44},'fill:var(--panel);stroke:var(--ink);stroke-width:10;opacity:.94');
  const rope=(x1,x2)=>{const g=el(v,'g',{}); el(g,'line',{x1,y1:760,x2,y2:760},'stroke:var(--ink);stroke-width:74;stroke-linecap:round');
    el(g,'line',{x1,y1:760,x2,y2:760},'stroke:var(--accent2);stroke-width:56;stroke-linecap:round');
    [-14,0,14].forEach(dy=>el(g,'line',{x1,y1:760+dy,x2,y2:760+dy},'stroke:var(--crease);stroke-width:5;stroke-dasharray:26 14'));
    return g;};
  rope(160,440); rope(640,920);
  const fray=el(v,'path',{d:'M452,740 l22,-14 M452,760 l26,0 M452,780 l22,14 M628,740 l-22,-14 M628,760 l-26,0 M628,780 l-22,14'},'stroke:var(--accent2);stroke-width:7;fill:none;stroke-linecap:round');
  const Lb=label(k.s,'เอ็นขาด','neu',540,560,54);
  const sd=lineEl(v,'M0,0 L1,1',40);
  const st=el(v,'path',{d:'M440,726 l14,68 M470,726 l14,68 M596,726 l14,68 M626,726 l14,68'},'stroke:var(--ink);stroke-width:9;fill:none;stroke-linecap:round;opacity:0');
  const pulse=el(v,'path',{d:'M160,760 L920,760',pathLength:1},'stroke:var(--accent);stroke-width:24;fill:none;stroke-linecap:round;stroke-dasharray:.12 1;opacity:0');
  const Lk=label(k.s,'ต่อแล้ว ✓','acc',540,920,62);
  UP.push(t=>{const u=clamp(sp(t,23.2,9,0.7));
    const a=lp(P(SPARE.x0,SPARE.y-200),P(410,760),u), b=lp(P(SPARE.x1,SPARE.y-200),P(670,760),u);
    sd.d(`M${f1(a.x)},${f1(a.y)} L${f1(b.x)},${f1(b.y)}`); sd.set(1,clamp((t-23.14)/0.08));
    fray.style.opacity=f3(1-clamp((u-0.85)*6)); Lb.style.opacity=f3(1-clamp((t-23.55)/0.15)); Lb.style.transform='translate(-50%,-50%)';
    st.style.opacity=f3(clamp((t-23.62)/0.1));
    const pu=clamp((t-23.9)/0.55); pulse.style.opacity=pu>0&&pu<1?'1':'0'; pulse.style.strokeDashoffset=f3(1.1-1.2*pu);
    popIn(Lk,t,24.0);});})();
// ball 24.82-27.46 (photo card): push toward the elbow, ring pops on "ข้อศอก" 25.22, throw arc on "นักเบสบอล" 25.74
const ELB=P(266,616), BALLP=P(176,648);
(function(){const k=over('ball'); if(!k) return; const img=$('kb-ball').querySelector('img');
  const r=ringEl(k.svg,70); const L=label(k.s,'ข้อศอก','acc',470,500,64);
  const lead=lineEl(k.svg,`M${ELB.x+60},${ELB.y-40} L400,520`,8);
  const arc=el(k.svg,'path',{d:`M${BALLP.x},${BALLP.y} C120,380 420,180 900,260`,pathLength:1},ACC+';stroke-width:12;stroke-dasharray:.06 .04;opacity:0');
  const ball=el(k.svg,'circle',{r:26},'fill:var(--accent2);stroke:var(--ink);stroke-width:8;opacity:0');
  UP.push(t=>{const z=eio((t-25.1)/0.6)*0.22+0.04*eio((t-24.82)/2.6);
    const tf=`translate(${f1(ELB.x)}px,${f1(ELB.y)}px) scale(${f3(1+z)}) translate(${f1(-ELB.x)}px,${f1(-ELB.y)}px)`;
    img.style.transformOrigin='0 0'; img.style.transform=tf; k.s.style.transformOrigin='0 0'; k.s.style.transform=tf;
    const ro=clamp(sp(t,25.2,16,0.55)); r.set(ELB.x,ELB.y,ro,0.7+0.3*ro+0.06*Math.sin(t*8));
    lead.set(eo((t-25.3)/0.2)); popIn(L,t,25.3);
    const au=clamp((t-25.74)/0.55); arc.style.opacity=f3(au>0?1-clamp((t-26.9)/0.3):0); arc.style.strokeDashoffset=f3(1-au);
    const pt=au>0?arc.getPointAtLength(arc.getTotalLength()*eo(au)):null;
    ball.style.opacity=pt&&t<26.9?'1':'0'; if(pt){ball.setAttribute('cx',f1(pt.x));ball.setAttribute('cy',f1(pt.y));}});})();
// ask 27.46-30.3: 0 / 1 / 2 cards pop on the words, both hands (test pose) faint behind, swaying
(function(){const k=slot('ask'); if(!k) return; const A=Hand(k.svg), B=Hand(k.svg);
  const cards=['0','1','2'].map((n,i)=>div(k.s,'numcard',n,`left:${190+i*240}px`));
  UP.push(t=>{cam(A.g,540,1060,290,1180+10*Math.sin(t*2.2),0.55,-6+3*Math.sin(t*1.7)); cam(B.g,540,1060,790,1180+10*Math.sin(t*2.2+1),0.55,6-3*Math.sin(t*1.7+1),-1);
    A.update({pinch:1,flex:0.5,pop:1,tint:0.5}); B.update({pinch:1,flex:0.5,pop:1,tint:0.5});
    k.svg.style.opacity='.5';
    [28.56,29.16,29.82].forEach((at,i)=>{const c=cards[i], a=sp(t,at-0.04,18,0.55), q=clamp((t-27.6-i*0.08)/0.25);
      c.style.opacity=f3(Math.max(q*0.9,clamp(a*3))); const nxt=[29.16,29.82,99][i]-0.04; c.classList.toggle('on',t>=at-0.04&&(t<nxt||i===2));
      c.style.transform=`translateY(${f1(t<at-0.04?8*Math.sin(t*4+i):0)}px) scale(${f3(t>=at-0.04?0.85+0.15*a+0.06*Math.exp(-(t-at)*5):0.85+0.1*eo(q))})`;});});})();

/* ---------- overlay layer (stays when slots become user footage) ---------- */
const epi=$('epi');
div(epi,'capbed','','');                                         // dark bed under the captions (white text never on white)
const cnt=div(epi,'','<div class="disc"></div>','');cnt.id='cnt';
const cs=el(cnt,'svg',{viewBox:'0 0 400 400'});
const cr=el(cs,'circle',{cx:200,cy:200,r:178,pathLength:1,transform:'rotate(-90 200 200)'},ACC+';stroke-width:16;stroke-dasharray:1 1');
const nums=['3','2','1'].map(n=>div(cnt,'n',n));
const ok=label(epi,'ปกติ ✓','acc',0,0,64); ok.id='okpill'; ok.style.left='800px'; ok.style.top='330px';
const badge=$('badge');
/* user footage (editor-notes "เปลี่ยนเป็นคลิปผู้ใช้"): when hook/loop slots are footage there is no drawn ring,
   so an overlay ring marks the tendon instead. Set x/y/r to where the wrist tendon is in the user's clip (1080x1920). */
const USER_RING={x:540,y:980,r:130};
const ur=el(el(epi,'svg',{class:'gsvg',viewBox:'0 0 1080 1920'}),'g',{});
el(ur,'circle',{cx:USER_RING.x,cy:USER_RING.y,r:USER_RING.r},INK+';stroke-width:28');
el(ur,'circle',{cx:USER_RING.x,cy:USER_RING.y,r:USER_RING.r},ACC+';stroke-width:15');
const userHook=!$('g-hook'), userLoop=!$('g-loop');
window.EPI=function(t,h){ if(h) window.__DUR=h.DUR;
  badge.style.transform=`scale(${f3(1+0.015*(1-Math.cos(t*Math.PI*2/1.6)))})`;
  // count 5.9 - 8.26: disc in, numbers on the spoken words (bounce), ring empties over the try-it window
  const ci=clamp((t-5.9)/0.15)*(1-clamp((t-8.18)/0.08));
  cnt.style.opacity=f3(ci); cnt.style.transform=`scale(${f3(0.8+0.2*eo((t-5.9)/0.2))}) rotate(${f1(4*Math.sin(t*3))}deg)`;
  cr.style.strokeDashoffset=f3(clamp((t-5.98)/2.2));
  [5.98,6.84,7.62].forEach((at,i)=>{const nx=[6.84,7.62,8.3][i], on=t>=at-0.03&&t<nx-0.03, a=sp(t,at-0.03,22,0.45);
    nums[i].style.opacity=on?f3(clamp(a*4)):'0'; nums[i].style.transform=`translateY(${f1(-14*Math.abs(Math.sin((t-at)*5))*Math.exp(-(t-at)*1.5))}px) scale(${f3(0.5+0.5*a)})`;});
  // grip footage: "ปกติ" pill on the word
  const og=t>=16.08&&t<18.42?1:0; ok.style.opacity=f3(og*clamp(sp(t,17.42,20,0.55)*3));
  ok.style.transform=`translate(-50%,-50%) scale(${f3(0.6+0.4*sp(t,17.42,20,0.55))}) rotate(-4deg)`;
  const inHook=t<1.52, inLoop=t>=30.3;   // shot edges = shots-th.json hook end / loop start
  ur.style.opacity=((inHook&&userHook)||(inLoop&&userLoop))?'1':'0';
  for(const u of UP) u(t);
};
})();
