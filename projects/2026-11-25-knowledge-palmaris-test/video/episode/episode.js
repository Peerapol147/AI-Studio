/* Palmaris test ("ลองทำตาม #1"): episode graphics for the brainrot-v3 template.
   Everything is a pure function of t (seek-safe). Colours come only from the look's CSS variables.
   Shot slots #g-<id> exist only while episode.json plates[id] == "graphic": when a slot becomes user footage the
   hand drawing for that shot simply is not built; the overlay (#epi: 3-2-1 count, "ปกติ" pill) and the badge stay.
   Shot times below are the word times from assets/audio/words.json (shots-th.json starts/ends are read from the DOM). */
(function(){
const NS='http://www.w3.org/2000/svg';
const $=id=>document.getElementById(id);
const clamp=(x,a=0,b=1)=>Math.min(b,Math.max(a,x)), lerp=(a,b,u)=>a+(b-a)*u;
const eo=x=>{x=clamp(x);return 1-Math.pow(1-x,3)}, eio=x=>{x=clamp(x);return x*x*x*(x*(6*x-15)+10)};
const S=(tau,w,z)=>{if(tau<=0)return 0; if(z<1){const wd=w*Math.sqrt(1-z*z);
  return 1-Math.exp(-z*w*tau)*(Math.cos(wd*tau)+z*w/wd*Math.sin(wd*tau));} return 1-Math.exp(-w*tau)*(1+w*tau);};
const sp=(t,at,w=16,z=0.62)=>S(t-at,w,z);          // spring 0 -> 1 starting at word time `at`
const P=(x,y)=>({x,y}), sub=(a,b)=>P(a.x-b.x,a.y-b.y), hyp=a=>Math.hypot(a.x,a.y), lp=(a,b,u)=>P(lerp(a.x,b.x,u),lerp(a.y,b.y,u));
const f1=v=>v.toFixed(1), pts=a=>a.map(p=>f1(p.x)+','+f1(p.y)).join(' ');
function el(parent,tag,attrs,style){const e=document.createElementNS(NS,tag);for(const k in attrs)e.setAttribute(k,attrs[k]);
  if(style)e.setAttribute('style',style); parent.appendChild(e); return e;}
function div(parent,cls,html,style){const e=document.createElement('div'); e.className=cls; e.innerHTML=html; if(style)e.setAttribute('style',style); parent.appendChild(e); return e;}
const INK='stroke:var(--ink);fill:none;stroke-linecap:round;stroke-linejoin:round';
const SKIN='stroke:var(--skin);fill:none;stroke-linecap:round;stroke-linejoin:round';
const ACC='stroke:var(--accent);fill:none;stroke-linecap:round;stroke-linejoin:round';
const cam=(g,fx,fy,X,Y,s,r=0,sx=1)=>g.setAttribute('transform',`translate(${f1(X)} ${f1(Y)}) rotate(${r.toFixed(2)}) scale(${(s*sx).toFixed(4)} ${s.toFixed(4)}) translate(${f1(-fx)} ${f1(-fy)})`);

/* ---------- the arm rig (hand-local space: wrist centre 540,1005, fingers up, palm facing the viewer) ---------- */
const FING=[{b:P(402,668),d:-9,L:[118,84,66],w:78},{b:P(497,650),d:-2,L:[130,94,72],w:84},{b:P(592,656),d:5,L:[122,88,68],w:80}];
const PINKY={b:P(678,690),L:[118,112],w:70,rest:P(736,460)};
const THUMB={b:P(444,872),L:[170,150],w:92,rest:P(240,640)};
const C=P(612,770);                                       // where thumb tip meets pinky tip
const TEND='M540,1000 C540,1090 540,1190 540,1310';         // palmaris longus tendon, wrist -> forearm
const TEND_X='M540,1000 C541,1150 540,1360 538,1590 L536,1640';
const FORE='M392,1012 C378,1300 356,1700 330,2140 L750,2140 C724,1700 702,1300 688,1012 Z';
const PALM='M394,1016 C356,962 334,884 338,800 C342,736 346,694 362,652 Q540,612 726,652 C744,716 744,820 722,902 C708,954 694,988 688,1016 Z';
const MUSC='M539,1560 C590,1660 598,1880 546,2100 C492,1880 492,1660 539,1560 Z';
let uid=0;
function chain(B,dirDeg,L,curl){let a=dirDeg*Math.PI/180,p=B; const out=[B];
  for(let i=0;i<L.length;i++){const k=Math.cos(curl*(0.55+0.3*i)); a+=curl*0.06; p=P(p.x+L[i]*k*Math.sin(a),p.y-L[i]*k*Math.cos(a)); out.push(p);} return out;}
function ik(A,T,l1,l2,sgn){const d0=sub(T,A); const d=Math.max(Math.abs(l1-l2)+1,Math.min(hyp(d0),l1+l2-0.5));
  const ang=Math.atan2(d0.y,d0.x), c=clamp((l1*l1+d*d-l2*l2)/(2*l1*d),-1,1), a1=ang+sgn*Math.acos(c);
  return [A,P(A.x+l1*Math.cos(a1),A.y+l1*Math.sin(a1)),P(A.x+d*Math.cos(ang),A.y+d*Math.sin(ang))];}

function Arm(svg){
  const id='a'+(uid++), defs=el(svg,'defs',{});
  const gr=el(defs,'linearGradient',{id:id+'g',x1:0,y1:0,x2:1,y2:0});
  [[0,'--skin2'],[0.3,'--skin'],[0.7,'--skin'],[1,'--skin2']].forEach(([o,v])=>el(gr,'stop',{offset:o},`stop-color:var(${v})`));
  const g=el(svg,'g',{});
  const fore=el(g,'path',{d:FORE},`fill:url(#${id}g);stroke:var(--ink);stroke-width:12;stroke-linejoin:round`);
  const xray=el(g,'path',{d:FORE},'fill:var(--bg);opacity:0');
  const hand=el(g,'g',{});
  // pass 1: one outline for palm + index/middle/ring (they read as one silhouette), pass 2: fills
  const fo=FING.map(f=>el(hand,'polyline',{},INK+`;stroke-width:${f.w+20}`));
  el(hand,'path',{d:PALM},'fill:var(--ink);stroke:var(--ink);stroke-width:20;stroke-linejoin:round');
  const ff=FING.map(f=>el(hand,'polyline',{},SKIN+`;stroke-width:${f.w}`));
  el(hand,'path',{d:PALM},'fill:var(--skin)');
  const palmShade=el(hand,'path',{d:PALM},'fill:var(--bg2);opacity:0');
  el(hand,'path',{d:'M462,990 C430,905 436,800 520,708'},'stroke:var(--crease);stroke-width:7;fill:none;stroke-linecap:round');
  el(hand,'path',{d:'M730,770 C672,772 612,752 548,712'},'stroke:var(--crease);stroke-width:7;fill:none;stroke-linecap:round');
  const pk=[el(hand,'polyline',{},INK+`;stroke-width:${PINKY.w+18}`),el(hand,'polyline',{},SKIN+`;stroke-width:${PINKY.w}`)];
  const pkPatch=el(hand,'circle',{cx:PINKY.b.x,cy:PINKY.b.y,r:PINKY.w/2+11},'fill:var(--skin)');
  const th=[el(hand,'polyline',{},INK+`;stroke-width:${THUMB.w+18}`),el(hand,'polyline',{},SKIN+`;stroke-width:${THUMB.w}`)];
  const thPatch=el(hand,'circle',{cx:THUMB.b.x,cy:THUMB.b.y,r:THUMB.w/2+11},'fill:var(--skin)');
  const spark=el(hand,'circle',{cx:C.x,cy:C.y,r:60},ACC+';stroke-width:10;opacity:0');
  const tips=[el(hand,'circle',{r:62},ACC+';stroke-width:10;opacity:0'),el(hand,'circle',{r:54},ACC+';stroke-width:10;opacity:0')];
  el(g,'path',{d:'M404,1004 Q540,1026 676,1004'},'stroke:var(--crease);stroke-width:7;fill:none;stroke-linecap:round');
  el(g,'path',{d:'M400,1034 Q540,1056 680,1034'},'stroke:var(--crease);stroke-width:6;fill:none;stroke-linecap:round');
  // tendon: relief (shadow + light), then the accent highlight with an ink border, then the glow
  const tShade=el(g,'path',{d:TEND,transform:'translate(9 0)'},'stroke:var(--skin2);stroke-width:30;fill:none;stroke-linecap:round;opacity:0');
  const tLite=el(g,'path',{d:TEND,transform:'translate(-6 0)'},'stroke:var(--skin);stroke-width:16;fill:none;stroke-linecap:round;opacity:0');
  const ghost=el(g,'path',{d:TEND},'stroke:var(--crease);stroke-width:8;fill:none;stroke-linecap:round;stroke-dasharray:4 26;opacity:0');
  const tGlow=el(g,'path',{d:TEND},ACC+';stroke-width:70;opacity:0');
  const tInk=el(g,'path',{d:TEND,pathLength:1},INK+';stroke-width:32;opacity:0;stroke-dasharray:1 1');
  const tAcc=el(g,'path',{d:TEND,pathLength:1},ACC+';stroke-width:17;opacity:0;stroke-dasharray:1 1');
  const fan=el(g,'path',{d:'M540,1004 L470,872 M540,1004 L540,850 M540,1004 L612,872',pathLength:1},ACC+';stroke-width:9;opacity:0;stroke-dasharray:1 1');
  const mus=el(g,'path',{d:MUSC},'fill:var(--accent);stroke:var(--ink);stroke-width:10;opacity:0');
  const musLines=el(g,'path',{d:'M528,1640 C516,1760 516,1900 534,2040 M552,1640 C566,1760 566,1900 548,2040'},'stroke:var(--ink);stroke-width:5;fill:none;opacity:0');
  const ringI=el(g,'circle',{cx:540,cy:1092,r:112,pathLength:1},INK+';stroke-width:28;opacity:0;stroke-dasharray:1 1');
  const ring=el(g,'circle',{cx:540,cy:1092,r:112,pathLength:1},ACC+';stroke-width:15;opacity:0;stroke-dasharray:1 1');
  return {g, update(o){
    const p=o.pinch||0, f=o.flex||0, pop=o.pop||0, hl=o.hl||0, draw=o.draw==null?1:o.draw;
    hand.setAttribute('transform',`translate(540 1008) scale(${(1+0.05*f).toFixed(4)} ${(1-0.2*f).toFixed(4)}) translate(-540 -1008)`);
    palmShade.style.opacity=(0.18*f).toFixed(3);
    FING.forEach((F,i)=>{const c=chain(F.b,F.d,F.L,(i===2?0.22:0.12)*p+0.06); fo[i].setAttribute('points',pts(c)); ff[i].setAttribute('points',pts(c));});
    const pT=ik(PINKY.b,lp(PINKY.rest,C,p),PINKY.L[0]*(1-0.25*p),PINKY.L[1]*(1-0.25*p),1);
    const tT=ik(THUMB.b,lp(THUMB.rest,P(C.x-18,C.y+14),p),THUMB.L[0],THUMB.L[1],-1);
    pk.forEach(e=>e.setAttribute('points',pts(pT))); th.forEach(e=>e.setAttribute('points',pts(tT)));
    spark.style.opacity=(o.spark||0).toFixed(3); spark.setAttribute('r',f1(60+30*(o.spark||0)));
    tips[0].setAttribute('cx',f1(tT[2].x)); tips[0].setAttribute('cy',f1(tT[2].y)); tips[0].style.opacity=(o.tipT||0).toFixed(3);
    tips[1].setAttribute('cx',f1(pT[2].x)); tips[1].setAttribute('cy',f1(pT[2].y)); tips[1].style.opacity=(o.tipP||0).toFixed(3);
    tShade.style.opacity=(0.9*pop).toFixed(3); tShade.style.strokeWidth=f1(14+22*pop); tLite.style.opacity=(0.9*pop).toFixed(3);
    ghost.style.opacity=(o.ghost||0).toFixed(3);
    const dd=o.full?TEND_X:TEND; if(tInk.getAttribute('d')!==dd){tInk.setAttribute('d',dd);tAcc.setAttribute('d',dd);tGlow.setAttribute('d',dd);}
    tInk.style.opacity=hl.toFixed(3); tAcc.style.opacity=hl.toFixed(3);
    tInk.style.strokeDashoffset=tAcc.style.strokeDashoffset=(1-draw).toFixed(4);
    tGlow.style.opacity=(0.28*hl*(o.glow==null?1:o.glow)).toFixed(3);
    xray.style.opacity=(0.62*(o.xray||0)).toFixed(3);
    fan.style.opacity=(o.fan||0)>0?'1':'0'; fan.style.strokeDashoffset=(1-(o.fan||0)).toFixed(4);
    const m=o.mus||0; mus.style.opacity=(m*(1-0.72*(o.dim||0))).toFixed(3); musLines.style.opacity=(m*(1-0.72*(o.dim||0))).toFixed(3);
    mus.setAttribute('transform',`translate(540 1830) scale(${(0.6+0.4*m+0.08*(o.musPulse||0)).toFixed(4)}) translate(-540 -1830)`);
    ringI.style.opacity=ring.style.opacity=(o.ring||0)>0?'1':'0';
    ringI.style.strokeDashoffset=ring.style.strokeDashoffset=(1-(o.ring||0)).toFixed(4);
    ring.setAttribute('r',f1(112+10*(o.ringPulse||0))); ringI.setAttribute('r',f1(112+10*(o.ringPulse||0)));
  }};
}
function slot(id){const s=$('g-'+id); if(!s) return null; const svg=el(s,'svg',{class:'gsvg',viewBox:'0 0 1080 1920',width:1080,height:1920}); return {s,svg};}
function label(parent,txt,cls,x,y,size){return div(parent,'lab '+cls,txt,`left:${x}px;top:${y}px;font-size:${size||52}px`);}
const popIn=(e,t,at,sx=1)=>{const a=sp(t,at,20,0.55); e.style.opacity=clamp(a*3).toFixed(3); e.style.transform=`translate(-50%,-50%) scale(${(sx*(0.6+0.4*a)).toFixed(4)})`;};
const shotStart=id=>{const v=$('sh-'+id); return v?v:null;};

/* ---------- per-shot builders: each returns an update(t) ---------- */
const UP=[];
// hook + loop share one look: test pose (pinched, wrist bent), tendon raised + accent, ring. Frame 0 = cover.
const HOOK={pinch:1,flex:0.6,pop:1,hl:1,ring:1};
const HOOKCAM=[540,1092,540,975,1.15];
function hookLike(id,phase){const k=slot(id); if(!k) return; const A=Arm(k.svg); cam(A.g,...HOOKCAM);
  UP.push(t=>{const tt=phase(t), b=0.5+0.5*Math.cos(tt*Math.PI*2/1.6); A.update({...HOOK,glow:0.55+0.45*b,ringPulse:b});});}
hookLike('hook',t=>t);
hookLike('loop',t=>t-window.__DUR);          // last frame ~ frame 0 (template plays the loop push back to scale 1.0)

// pinch: whole hand opens, thumb and little finger meet (spring), tips marked as they are named
(function(){const k=slot('pinch'); if(!k) return; const A=Arm(k.svg);
  UP.push(t=>{const p=sp(t,2.62,7.5,0.78); const z=eio((t-1.52)/2.7);
    cam(A.g,540,760,540,lerp(690,710,z),lerp(0.92,0.98,z));
    A.update({pinch:p,flex:0,pop:0.15,tipT:clamp((t-3.0)/0.15)*(1-0.6*clamp((t-3.9)/0.3)),tipP:clamp((t-3.5)/0.15)*(1-0.6*clamp((t-3.9)/0.3)),spark:clamp((p-0.92)/0.08)*(1-clamp((t-4.0)/0.4))});});})();
// flex: wrist bends a little toward the viewer, the camera follows the wrist, the tendon rises
(function(){const k=slot('flex'); if(!k) return; const A=Arm(k.svg);
  UP.push(t=>{const f=sp(t,4.4,9,0.7), z=eio((t-4.3)/1.0);
    cam(A.g,lerp(540,540,z),lerp(760,1092,z),540,lerp(710,930,z),lerp(0.98,1.3,z));
    A.update({pinch:1,flex:0.6*f,pop:clamp(f*1.1),hl:0});});})();
// count: hold the test pose (overlay draws the 3-2-1), tendon raised but not yet highlighted
(function(){const k=slot('count'); if(!k) return; const A=Arm(k.svg); cam(A.g,...HOOKCAM);
  UP.push(t=>{const beat=[5.98,6.84,7.62].reduce((m,a)=>t>=a?Math.max(m,Math.exp(-(t-a)*6)):m,0);
    cam(A.g,540,1092,540,930,1.3+0.03*beat); A.update({pinch:1,flex:0.6+0.04*beat,pop:1,hl:0});});})();
// see: push into the wrist, the raised line lights up on "นูน", ring draws on "ข้อมือ"
(function(){const k=slot('see'); if(!k) return; const A=Arm(k.svg);
  UP.push(t=>{const z=eio((t-8.26)/1.1); cam(A.g,540,lerp(1092,1150,z),540,lerp(930,820,z),lerp(1.3,2.05,z));
    const h=clamp(sp(t,8.8,14,0.7)); A.update({pinch:1,flex:0.6,pop:1,hl:h,draw:h,glow:0.6+0.4*Math.sin(t*5),ring:eo((t-9.24)/0.35),ringPulse:0.5+0.5*Math.sin(t*6)});});})();
// muscle + rare: the arm turns sideways (x-ray): small muscle near the elbow -> long tendon down to the wrist
function sideArm(k){const A=Arm(k.svg); cam(A.g,540,1250,540,780,0.57,90); return A;}
(function(){const k=slot('muscle'); if(!k) return; const A=sideArm(k);
  const L1=label(k.s,'เส้นเอ็น','acc',650,620,56), L2=label(k.s,'กล้ามเนื้อเล็กๆ','acc',275,620,56);
  UP.push(t=>{const u=eio((t-10.34)/2.1); cam(A.g,540,1250,540,780,lerp(0.54,0.57,u),90);
    const d=clamp((t-10.66)/0.5);
    A.update({full:1,pinch:0,flex:0,pop:0.6,hl:d>0?1:0,draw:eo(d),glow:0.5,xray:eo((t-10.42)/0.3),fan:eo((t-10.9)/0.4),
      mus:clamp(sp(t,11.24,14,0.6)),musPulse:Math.exp(-Math.max(0,t-11.56)*5)*(t>=11.56?1:0)});
    popIn(L1,t,10.7); popIn(L2,t,11.3);});})();
(function(){const k=slot('rare'); if(!k) return; const A=sideArm(k);
  const L2=label(k.s,'กล้ามเนื้อเล็กๆ','acc',275,620,56), L3=label(k.s,'หน้าที่น้อยมาก','neu',540,990,66);
  UP.push(t=>{const u=eio((t-12.44)/1.9); cam(A.g,540,lerp(1250,1830,u),540,780,lerp(0.57,0.95,u),90);
    const dm=eio((t-13.04)/0.5);
    A.update({full:1,pinch:0,flex:0,pop:0.6,hl:1-0.35*dm,draw:1,glow:0.4,xray:1,fan:1,mus:1,dim:dm});
    L2.style.opacity=(1-0.5*dm).toFixed(3); L2.style.left=f1(lerp(275,540,u))+'px'; L2.style.top=f1(lerp(620,560,u))+'px'; L2.style.transform='translate(-50%,-50%)';
    popIn(L3,t,13.04);});})();
// none: two different people side by side, one with the line, one without (neutral labels, no warning colours)
function pairArms(k,mirror){const A=Arm(k.svg), B=Arm(k.svg); return [A,B];}
(function(){const k=slot('none'); if(!k) return; const [A,B]=pairArms(k);
  const La=label(k.s,'มีเส้น','neu',310,420,56), Lb=label(k.s,'ไม่มีเส้น','neu',760,420,56);
  UP.push(t=>{const u=eio((t-14.32)/1.7); const s=lerp(0.6,0.63,u);
    cam(A.g,540,1000,310,lerp(820,800,u),s); cam(B.g,540,1000,760,lerp(820,800,u),s);
    const gone=clamp(sp(t,14.76,12,0.8));
    A.update({pinch:1,flex:0.6,pop:1,hl:1,glow:0.5}); B.update({pinch:1,flex:0.6,pop:1-gone,hl:1-gone,glow:0.5});
    popIn(La,t,14.45); popIn(Lb,t,14.8);});})();
// one (twist, fast): the same person's two hands; quick hops left -> right -> both
(function(){const k=slot('one'); if(!k) return; const [A,B]=pairArms(k);
  const Lt=label(k.s,'คนเดียวกัน','acc',540,430,60), La=label(k.s,'มี','neu',300,1010,56), Lb=label(k.s,'ไม่มี','neu',770,1010,56);
  const V=k.s.querySelector('svg'); const grp=el(V,'g',{}); grp.appendChild(A.g); grp.appendChild(B.g);
  UP.push(t=>{cam(A.g,540,1000,300,760,0.58); cam(B.g,540,1000,780,760,0.58,0,-1);
    // camera hops: 18.42 left wrist, 18.9 right wrist, 19.34 both (on "ข้างเดียว")
    const h1=eio((t-18.86)/0.14), h2=eio((t-19.3)/0.16);
    const cx=lerp(lerp(300,780,h1),540,h2), cy=lerp(800,760,h2), s=lerp(1.55,1.0,h2);
    grp.setAttribute('transform',`translate(540 760) scale(${s.toFixed(4)}) translate(${f1(-cx)} ${f1(-cy)})`);
    A.update({pinch:1,flex:0.6,pop:1,hl:1,glow:0.6,ring:h2>0?eo((t-19.34)/0.3):0,ringPulse:0.5+0.5*Math.sin(t*7)});
    B.update({pinch:1,flex:0.6,pop:0,hl:0});
    popIn(Lt,t,18.5); popIn(La,t,19.4); popIn(Lb,t,19.5);});})();
// graft: the tendon lifts out of the arm as a spare (ghost line stays, no wound) and lies across the top
const STR={y:400,x0:290,x1:790};
function strand(svg){const g=el(svg,'g',{}); return {g,i:el(g,'line',{},INK+';stroke-width:40'),a:el(g,'line',{},ACC+';stroke-width:24'),
  set(a,b,o=1){[this.i,this.a].forEach(e=>{e.setAttribute('x1',f1(a.x));e.setAttribute('y1',f1(a.y));e.setAttribute('x2',f1(b.x));e.setAttribute('y2',f1(b.y));}); this.g.style.opacity=o.toFixed(3);}};}
(function(){const k=slot('graft'); if(!k) return; const A=Arm(k.svg); const sd=strand(k.svg);
  const L=label(k.s,'เอ็นสำรอง','acc',540,500,64);
  UP.push(t=>{const z=eio((t-20.58)/2.5); cam(A.g,540,1150,540,lerp(1140,1170,z),lerp(0.8,0.76,z));
    const u=clamp(sp(t,21.6,7,0.75));
    // tendon on screen: local 1000..1590 -> map with the same cam
    const s=lerp(0.8,0.76,z), Y=lerp(1140,1170,z), a0=P(540,Y+(1000-1150)*s), b0=P(540,Y+(1590-1150)*s);
    const lift=Math.sin(Math.PI*clamp(u))*120;
    const a=P(lerp(a0.x,STR.x1,u)+lift*0.3,lerp(a0.y,STR.y,u)-lift), b=P(lerp(b0.x,STR.x0,u)-lift*0.3,lerp(b0.y,STR.y,u)-lift);
    A.update({full:1,pinch:1,flex:0.6,pop:1-clamp(u*2),hl:t<21.56?clamp((t-20.7)/0.3):0,ghost:clamp(u*2),glow:0.5});
    sd.set(a,b,t<21.56?0:1);
    popIn(L,t,22.2);});})();
// fix: an elbow ligament with a gap; the spare drops into the gap, stitches, one pulse along the line
(function(){const k=slot('fix'); if(!k) return; const v=k.svg;
  const arm=el(v,'g',{});
  el(arm,'polyline',{points:'150,560 540,900 930,560'},'stroke:var(--accent2);stroke-width:210;fill:none;stroke-linecap:round;stroke-linejoin:round;opacity:.95');
  el(arm,'polyline',{points:'150,560 540,900 930,560'},'stroke:var(--bg2);stroke-width:190;fill:none;stroke-linecap:round;stroke-linejoin:round');
  const lig=[el(arm,'path',{d:'M330,716 Q420,790 488,814'},'stroke:var(--accent2);stroke-width:34;fill:none;stroke-linecap:round'),
             el(arm,'path',{d:'M592,814 Q660,790 750,716'},'stroke:var(--accent2);stroke-width:34;fill:none;stroke-linecap:round')];
  const sd=strand(v);
  const st=el(v,'path',{d:'M470,800 l14,26 M486,796 l14,26 M580,796 l14,26 M596,800 l14,26'},'stroke:var(--ink);stroke-width:8;fill:none;stroke-linecap:round;opacity:0');
  const pulse=el(v,'path',{d:'M330,716 Q540,880 750,716',pathLength:1},'stroke:var(--accent2);stroke-width:14;fill:none;stroke-linecap:round;stroke-dasharray:.12 1;opacity:0');
  const L=label(k.s,'เอ็นสำรอง','acc',540,500,64), Lk=label(k.s,'ต่อแล้ว ✓','acc',540,1000,60);
  UP.push(t=>{const u=clamp(sp(t,23.2,10,0.7));
    const a=lp(P(STR.x0,STR.y),P(460,812),u), b=lp(P(STR.x1,STR.y),P(620,812),u);
    sd.set(a,b,1);
    arm.style.opacity=clamp((t-23.12)/0.12).toFixed(3);
    st.style.opacity=clamp((t-23.62)/0.1).toFixed(3);
    const pu=clamp((t-23.95)/0.6); pulse.style.opacity=pu>0&&pu<1?'1':'0'; pulse.style.strokeDashoffset=(1.1-1.2*pu).toFixed(3);
    L.style.opacity=(1-clamp((t-23.75)/0.2)).toFixed(3); L.style.transform='translate(-50%,-50%)';
    popIn(Lk,t,24.0);});})();
// ball: pitcher silhouette (capsules), the throwing arm whips over, elbow ring on "ข้อศอก"
(function(){const k=slot('ball'); if(!k) return; const v=k.svg; const g=el(v,'g',{});
  const segs=[], cap=(w)=>{const o=el(g,'polyline',{},INK+`;stroke-width:${w+18}`), f=el(g,'polyline',{},SKIN+`;stroke-width:${w}`); segs.push([o,f]); return [o,f];};
  const leg1=cap(70), leg2=cap(70), torso=cap(120), glove=cap(52), thr=cap(52);
  const headI=el(g,'circle',{r:64},'fill:var(--ink)'), head=el(g,'circle',{r:55},'fill:var(--skin)');
  const ball=el(g,'circle',{r:30},'fill:var(--skin);stroke:var(--ink);stroke-width:9');
  const rI=el(g,'circle',{r:62},INK+';stroke-width:26'), r=el(g,'circle',{r:62},ACC+';stroke-width:14');
  const L=label(k.s,'ข้อศอก','acc',770,470,62);
  const set=(c,a)=>c.forEach(e=>e.setAttribute('points',pts(a)));
  const ang=(o,deg,l)=>P(o.x+l*Math.cos(deg*Math.PI/180),o.y+l*Math.sin(deg*Math.PI/180));
  UP.push(t=>{const u=eio((t-25.3)/0.75);            // 0 cocked -> 1 follow-through
    const lean=lerp(-6,10,u), hip=P(lerp(520,560,u),720), sh=ang(hip,-90+lean,230), shT=P(sh.x-34,sh.y+16);
    set(leg1,[hip,P(lerp(430,450,u),880),P(lerp(360,380,u),1040)]); set(leg2,[hip,P(lerp(650,680,u),850),P(lerp(720,740,u),1040)]);
    set(torso,[hip,sh]); const hd=ang(sh,-90+lean,95); [headI,head].forEach(e=>{e.setAttribute('cx',f1(hd.x));e.setAttribute('cy',f1(hd.y));});
    set(glove,[sh,ang(sh,lerp(10,60,u),130),ang(ang(sh,lerp(10,60,u),130),lerp(-20,80,u),110)]);
    const ua=u<0.5?lerp(195,300,u/0.5):lerp(300,400,(u-0.5)/0.5), fa=u<0.5?lerp(265,300,u/0.5):lerp(300,440,(u-0.5)/0.5);
    const E=ang(shT,ua,135), H=ang(E,fa,125); set(thr,[shT,E,H]);
    const rel=clamp((t-25.75)/0.6); const bp=rel>0?P(lerp(H.x,1300,eo(rel)),lerp(H.y,320,eo(rel))):H;
    ball.setAttribute('cx',f1(rel>0?bp.x:H.x)); ball.setAttribute('cy',f1(rel>0?bp.y:H.y));
    const ro=clamp(sp(t,25.22,16,0.6)); [rI,r].forEach(e=>{e.setAttribute('cx',f1(E.x));e.setAttribute('cy',f1(E.y));e.setAttribute('r',f1(40+30*ro));e.style.opacity=ro>0.01?'1':'0';});
    popIn(L,t,25.25);
    g.setAttribute('transform',`translate(${f1(lerp(-30,10,eio((t-24.82)/2.6)))} 110) translate(540 700) scale(1.18) translate(-540 -700)`);});})();
// ask: 0 / 1 / 2 cards pop on the words, both hands faint behind
(function(){const k=slot('ask'); if(!k) return; const [A,B]=pairArms(k);
  const cards=['0','1','2'].map((n,i)=>div(k.s,'numcard',n,`left:${190+i*240}px`));
  UP.push(t=>{cam(A.g,540,1000,300,1010,0.5); cam(B.g,540,1000,780,1010,0.5,0,-1);
    A.update({pinch:0,flex:0,pop:0.4}); B.update({pinch:0,flex:0,pop:0.4});
    k.svg.style.opacity='.45';
    [28.56,29.16,29.82].forEach((at,i)=>{const c=cards[i], a=sp(t,at-0.04,18,0.55), q=clamp((t-27.6-i*0.08)/0.25);
      c.style.opacity=Math.max(q*0.9,clamp(a*3)).toFixed(3); const nxt=[29.16,29.82,99][i]-0.04; c.classList.toggle('on',t>=at-0.04&&(t<nxt||i===2));
      c.style.transform=`scale(${(t>=at-0.04?0.85+0.15*a+0.06*Math.exp(-(t-at)*5):0.85+0.1*eo(q)).toFixed(4)})`;});});})();

/* ---------- overlay layer (stays when slots become user footage) ---------- */
const epi=$('epi');
const cnt=div(epi,'','<div class="disc"></div>','');cnt.id='cnt';
const cs=el(cnt,'svg',{viewBox:'0 0 400 400'});
const cr=el(cs,'circle',{cx:200,cy:200,r:178,pathLength:1,transform:'rotate(-90 200 200)'},ACC+';stroke-width:16;stroke-dasharray:1 1');
const nums=['3','2','1'].map(n=>div(cnt,'n',n));
const ok=label(epi,'ปกติ ✓','acc',0,0,64); ok.id='okpill'; ok.style.left='800px'; ok.style.top='330px';
const badge=$('badge');
/* user footage (editor-notes "เปลี่ยนเป็นคลิปผู้ใช้"): when hook/loop/see slots are footage there is no drawn ring,
   so an overlay ring marks the tendon instead. Set x/y/r to where the wrist tendon is in the user's clip (1080x1920). */
const USER_RING={x:540,y:980,r:130};
const ur=el(el(epi,'svg',{class:'gsvg',viewBox:'0 0 1080 1920'}),'g',{});
const urI=el(ur,'circle',{cx:USER_RING.x,cy:USER_RING.y,r:USER_RING.r},INK+';stroke-width:28');
const urA=el(ur,'circle',{cx:USER_RING.x,cy:USER_RING.y,r:USER_RING.r},ACC+';stroke-width:15');
const userHook=!$('g-hook'), userLoop=!$('g-loop');
const shotA=id=>{const e=$('sh-'+id); return e;};
window.EPI=function(t,h){ if(h) window.__DUR=h.DUR;
  // badge: on from frame 0, a small nudge on each new beat section is not needed - it just breathes with the title
  badge.style.transform=`scale(${(1+0.015*(1-Math.cos(t*Math.PI*2/1.6))).toFixed(4)})`;
  // count 5.9 - 8.26: disc in, numbers on the spoken words, ring empties over the try-it window
  const ci=clamp((t-5.9)/0.15)*(1-clamp((t-8.18)/0.08));
  cnt.style.opacity=ci.toFixed(3); cnt.style.transform=`scale(${(0.8+0.2*eo((t-5.9)/0.2)).toFixed(4)})`;
  cr.style.strokeDashoffset=clamp((t-5.98)/2.2).toFixed(4);
  [5.98,6.84,7.62].forEach((at,i)=>{const nx=[6.84,7.62,8.3][i], on=t>=at-0.03&&t<nx-0.03, a=sp(t,at-0.03,22,0.5);
    nums[i].style.opacity=on?clamp(a*4).toFixed(3):'0'; nums[i].style.transform=`scale(${(0.5+0.5*a).toFixed(4)})`;});
  // grip footage: "ปกติ" pill on the word
  const og=t<18.42?1:0; ok.style.opacity=(og*clamp(sp(t,17.42,20,0.55)*3)).toFixed(3);
  ok.style.transform=`translate(-50%,-50%) scale(${(0.6+0.4*sp(t,17.42,20,0.55)).toFixed(4)}) rotate(-4deg)`;
  const D=window.__DUR||31.167, inHook=t<1.52, inLoop=t>=30.3;   // shot edges = shots-th.json hook end / loop start
  ur.style.opacity=((inHook&&userHook)||(inLoop&&userLoop))?'1':'0';
  for(const u of UP) u(t);
};
})();
