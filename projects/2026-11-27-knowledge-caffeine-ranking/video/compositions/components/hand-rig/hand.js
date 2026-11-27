/* HandRig: a jointed palm-side hand drawn in SVG from a small 3D skeleton (seek-safe: draw(state) is a pure function).
   Right hand, palm toward the viewer, fingers up, thumb on the viewer's left, wrist + forearm running off the bottom.
   Local space: px, origin = wrist centre, x right, y down (fingers at -y), z toward the viewer.
   Every finger = 3 phalanges rotating at real joints (MCP / PIP / DIP: flexion bends the finger toward the viewer);
   thumb = metacarpal (CMC) + 2 phalanges, the 2 phalanges solved by 2-bone IK so the thumb pad lands on the pinky pad.
   Wrist flexion rotates the whole hand about the wrist axis (x), forearm stays; perspective projection, so the
   bending hand foreshortens. Drawing: union outline + flat skin + cylinder shading per phalanx + palm modelling
   (thenar / hypothenar / hollow, creases), soft shadows, a palmaris-longus ridge on the forearm (highlight + shadow).
   Colours: skin is mixed from the look's --accent2 (episode.css --sk*), shading from --ink. */
(function(){
const NS='http://www.w3.org/2000/svg';
const D2R=Math.PI/180, clamp=(x,a=0,b=1)=>Math.min(b,Math.max(a,x)), lerp=(a,b,u)=>a+(b-a)*u;
const V=(x,y,z)=>({x,y,z:z||0}), add=(a,b)=>V(a.x+b.x,a.y+b.y,a.z+b.z), sub=(a,b)=>V(a.x-b.x,a.y-b.y,a.z-b.z),
  mul=(a,s)=>V(a.x*s,a.y*s,a.z*s), dot=(a,b)=>a.x*b.x+a.y*b.y+a.z*b.z, len=a=>Math.sqrt(dot(a,a)), nrm=a=>mul(a,1/(len(a)||1)),
  vl=(a,b,u)=>V(lerp(a.x,b.x,u),lerp(a.y,b.y,u),lerp(a.z,b.z,u)),
  cross=(a,b)=>V(a.y*b.z-a.z*b.y,a.z*b.x-a.x*b.z,a.x*b.y-a.y*b.x);
const f1=v=>v.toFixed(1);

/* ---------- skeleton ---------- */
// fingers: MCP joint, abduction angle (deg, + = toward the pinky side), phalanx lengths, radii at joints
const FING={
  index:{m:V(-124,-428),a:-7, L:[150,90,72], r:[41,38,35,31]},
  middle:{m:V(-41,-450),a:-1, L:[164,100,80], r:[43,40,36,32]},
  ring:{m:V(44,-440),a:6,   L:[156,95,76], r:[41,38,34,30]},
  pinky:{m:V(124,-404),a:14,L:[124,72,62],  r:[36,33,30,27]},
};
const TH={c:V(-92,-62,14), L:[178,136,112], r:[62,47,44,40,35]};
const THREST=[nrm(V(-0.60,-0.76,0.24)),nrm(V(-0.46,-0.86,0.20)),nrm(V(-0.32,-0.93,0.16))];
const PALM=[V(-116,60),V(-128,8),V(-150,-120),V(-166,-300),V(-168,-418),V(-128,-470),V(-44,-490),V(44,-480),V(118,-452),
  V(162,-412),V(180,-300),V(180,-160),V(156,-46),V(130,8),V(118,60)];
const ARM=[V(-108,-60),V(-128,8),V(-142,260),V(-168,620),V(-196,1100),V(196,1100),V(170,620),V(146,260),V(130,8),V(110,-60)];

function fingerChain(f,a,phi){ // phi = [MCP, PIP, DIP] flexion deg
  const d=V(Math.sin(a*D2R),-Math.cos(a*D2R),0), n=V(0,0,1); let c=0; const J=[f.m];
  for(let i=0;i<3;i++){c+=phi[i]*D2R; const dir=add(mul(d,Math.cos(c)),mul(n,Math.sin(c))); J.push(add(J[i],mul(dir,f.L[i])));}
  return J;}
// 2-bone IK: from B reach T with lengths a,b, bend toward pole
function ik(B,T,a,b,pole){let dv=sub(T,B), d=len(dv); const u=nrm(dv); d=Math.min(d,a+b-0.5);
  const ca=clamp((a*a+d*d-b*b)/(2*a*d),-1,1), sa=Math.sqrt(1-ca*ca);
  let p=sub(pole,mul(u,dot(pole,u))); p=nrm(p); const J=add(B,add(mul(u,a*ca),mul(p,a*sa)));
  return [J,add(J,mul(nrm(sub(add(B,mul(u,d)),J)),b))];}

/* pose(st): st.o thumb opposition 0..1, st.op pinky opposition 0..1, st.press, st.spread, st.flex (wrist deg) */
function solve(st){
  const o=st.o||0, op=st.op||0, sp=st.spread||0, w=st.wig||[0,0,0,0];
  const fingers={};
  for(const k in FING){const f=FING[k]; let a=f.a+sp*(f.a*0.8)+(w[['index','middle','ring','pinky'].indexOf(k)]||0), tf=clamp((st.flex||0)/40)*10, phi=[4+tf,6+1.6*tf,3+tf], m=f.m;
    if(k==='pinky'){a=lerp(a,-30,op); phi=[lerp(4,52,op),lerp(6,46,op),lerp(3,16,op)]; m=add(m,V(-22*op,6*op,26*op));}
    if(k==='ring'){phi=[4+6*op,6+6*op,3]; m=add(m,V(-6*op,0,8*op));}
    fingers[k]=fingerChain({...f,m},a,phi);}
  const Pt=fingers.pinky[3];
  // thumb metacarpal swings across the palm toward the viewer; phalanges by IK onto the pinky pad
  const meta=nrm(vl(THREST[0],nrm(V(0.40,-0.80,0.45)),o));
  const C=add(TH.c,V(10*o,-6*o,10*o)), M=add(C,mul(meta,TH.L[0]));
  const restTip=add(add(M,mul(THREST[1],TH.L[1])),mul(THREST[2],TH.L[2]));
  const toP=nrm(sub(M,Pt)), touch=add(Pt,mul(toP,(TH.r[4]+FING.pinky.r[3])*0.80));
  const press=st.press||0;                                   // >0 pushes the thumb pad into the pinky pad
  const tgt=add(vl(restTip,add(touch,mul(toP,-press)),o),V(0,0,70*Math.sin(Math.PI*o)));
  const [I,T]=ik(M,tgt,TH.L[1],TH.L[2],nrm(V(-0.2,-0.3,1)));
  return {fingers,thumb:[C,M,I,T],touch:vl(Pt,T,0.5)};}

/* ---------- projection ---------- */
const F=1500;
function camera(st){const fl=(st.flex||0)*D2R, cf=Math.cos(fl), sf=Math.sin(fl), yw=(st.yaw||0)*D2R, cy=Math.cos(yw), sy=Math.sin(yw),
  pt=(st.pitch||0)*D2R, cp=Math.cos(pt), spp=Math.sin(pt), rl=(st.roll||0)*D2R, cr=Math.cos(rl), sr=Math.sin(rl), S=st.S||1, X=st.X||540, Y=st.Y||1300;
  const tr=(p,hand)=>{let {x,y,z}=p; if(hand){const y2=y*cf+z*sf, z2=-y*sf+z*cf; y=y2; z=z2;}
    const x3=x*cy+z*sy, z3=-x*sy+z*cy; const y4=y*cp-z3*spp, z4=y*spp+z3*cp; return V(x3,y4,z4);};
  const pr=(p,hand)=>{const q=tr(p,hand), k=F/(F-q.z), sx=q.x*k*S, sy2=q.y*k*S; return {x:X+sx*cr-sy2*sr,y:Y+sx*sr+sy2*cr,k:k*S,z:q.z};};
  return pr;}

/* ---------- drawing helpers ---------- */
function el(p,tag,at,style){const e=document.createElementNS(NS,tag); for(const k in at)e.setAttribute(k,at[k]); if(style)e.setAttribute('style',style); p.appendChild(e); return e;}
function capsule(A,ra,B,rb){const dx=B.x-A.x, dy=B.y-A.y, L=Math.hypot(dx,dy);
  if(L<Math.abs(ra-rb)+0.5){const r=Math.max(ra,rb), C=ra>rb?A:B; return `M${f1(C.x-r)},${f1(C.y)} a${f1(r)},${f1(r)} 0 1 0 ${f1(2*r)},0 a${f1(r)},${f1(r)} 0 1 0 ${f1(-2*r)},0Z`;}
  const ux=dx/L, uy=dy/L, nx=-uy, ny=ux, e=(ra-rb)/L, c=Math.sqrt(1-e*e);
  const s1x=e*ux+c*nx, s1y=e*uy+c*ny, s2x=e*ux-c*nx, s2y=e*uy-c*ny;
  return `M${f1(A.x+ra*s1x)},${f1(A.y+ra*s1y)} L${f1(B.x+rb*s1x)},${f1(B.y+rb*s1y)} A${f1(rb)},${f1(rb)} 0 ${e<0?1:0} 0 ${f1(B.x+rb*s2x)},${f1(B.y+rb*s2y)} `+
    `L${f1(A.x+ra*s2x)},${f1(A.y+ra*s2y)} A${f1(ra)},${f1(ra)} 0 ${e>0?1:0} 0 ${f1(A.x+ra*s1x)},${f1(A.y+ra*s1y)}Z`;}
function smooth(P,closed=true){const n=P.length; let d=`M${f1(P[0].x)},${f1(P[0].y)}`;
  for(let i=0;i<(closed?n:n-1);i++){const p0=P[(i-1+n)%n], p1=P[i], p2=P[(i+1)%n], p3=P[(i+2)%n];
    const a=closed||i>0?p0:p1, b=closed||i<n-2?p3:p2;
    d+=` C${f1(p1.x+(p2.x-a.x)/6)},${f1(p1.y+(p2.y-a.y)/6)} ${f1(p2.x-(b.x-p1.x)/6)},${f1(p2.y-(b.y-p1.y)/6)} ${f1(p2.x)},${f1(p2.y)}`;}
  return d+(closed?'Z':'');}
// affine of the projection around local point c (for ellipses / patches lying on the palm)
function aff(pr,c,hand){const o=pr(c,hand), ex=pr(add(c,V(1,0,0)),hand), ey=pr(add(c,V(0,1,0)),hand);
  return `matrix(${(ex.x-o.x).toFixed(4)} ${(ex.y-o.y).toFixed(4)} ${(ey.x-o.x).toFixed(4)} ${(ey.y-o.y).toFixed(4)} ${f1(o.x)} ${f1(o.y)})`;}

let UID=0;
function HandRig(svg){
  const id='hr'+(++UID), defs=el(svg,'defs',{});
  const filt=(n,sd,dx,dy,a)=>{const f=el(defs,'filter',{id:id+n,x:'-30%',y:'-30%',width:'160%',height:'160%',  'color-interpolation-filters':'sRGB'});
    el(f,'feGaussianBlur',{in:'SourceAlpha',stdDeviation:sd,result:'b'}); el(f,'feOffset',{in:'b',dx,dy,result:'o'});
    el(f,'feFlood',{'flood-color':'#140604','flood-opacity':a,result:'c'}); el(f,'feComposite',{in:'c',in2:'o',operator:'in'}); return `url(#${id+n})`;};
  const DS=filt('ds',22,26,34,0.42), SS=filt('ss',9,10,16,0.34);
  const bl=el(defs,'filter',{id:id+'bl',x:'-50%',y:'-20%',width:'200%',height:'140%'}); el(bl,'feGaussianBlur',{stdDeviation:7});
  const bl2=el(defs,'filter',{id:id+'bl2',x:'-50%',y:'-20%',width:'200%',height:'140%'}); el(bl2,'feGaussianBlur',{stdDeviation:13});
  const radial=(n,stops)=>{const g=el(defs,'radialGradient',{id:id+n}); stops.forEach(([o,c,a])=>el(g,'stop',{offset:o},`stop-color:${c};stop-opacity:${a}`)); return `url(#${id+n})`;};
  const HI=radial('hi',[[0,'#fff6ea',0.42],[0.55,'#fff6ea',0.14],[1,'#fff6ea',0]]);
  const HOL=radial('hol',[[0,'var(--ink)',0.26],[0.6,'var(--ink)',0.10],[1,'var(--ink)',0]]);
  const ARMG=el(defs,'linearGradient',{id:id+'arm',gradientUnits:'userSpaceOnUse'});
  [[0,0.34],[0.22,0.06],[0.55,0],[0.85,0.10],[1,0.30]].forEach(([o,a])=>el(ARMG,'stop',{offset:o},`stop-color:var(--ink);stop-opacity:${a}`));
  const AHI=el(defs,'linearGradient',{id:id+'ahi',gradientUnits:'userSpaceOnUse'});
  [[0,0],[0.32,0.22],[0.45,0],[1,0]].forEach(([o,a])=>el(AHI,'stop',{offset:o},`stop-color:#fff6ea;stop-opacity:${a}`));

  const root=el(svg,'g',{});
  const shadowBase=el(root,'use',{href:'#'+id+'base',filter:DS});
  const outline=el(root,'g',{},'fill:none;stroke:var(--skd);stroke-width:7;stroke-linejoin:round');
  const base=el(root,'g',{id:id+'base'},'fill:var(--sk)');
  const shadowOver=el(root,'use',{href:'#'+id+'over',filter:SS});
  const overOut=el(root,'g',{},'fill:none;stroke:var(--skd);stroke-width:5');
  const over=el(root,'g',{id:id+'over'},'fill:var(--sk)');
  const fx=el(root,'g',{});

  const part=(fillG,outG)=>({o:outG?el(outG,'path',{}):null,f:el(fillG,'path',{}),set(d){this.f.setAttribute('d',d); if(this.o)this.o.setAttribute('d',d);}});
  // per-phalanx cylinder shading (gradient across the width, light from upper left)
  let gi=0; const cyl=(g)=>{const gr=el(defs,'linearGradient',{id:id+'c'+(++gi),gradientUnits:'userSpaceOnUse'});
    [[0,'var(--ink)',0.30],[0.2,'var(--ink)',0.08],[0.45,'var(--ink)',0],[0.68,'#fff6ea',0.16],[0.88,'#fff6ea',0.04],[1,'var(--ink)',0.10]]
      .forEach(([o,c,a])=>el(gr,'stop',{offset:o},`stop-color:${c};stop-opacity:${a}`));
    const p=el(g,'path',{fill:`url(#${id}c${gi})`});
    return {set(d,A,B,r){p.setAttribute('d',d); const dx=B.x-A.x, dy=B.y-A.y, L=Math.hypot(dx,dy)||1; let nx=-dy/L, ny=dx/L;
      if(nx*-0.75+ny*-0.66<0){nx=-nx;ny=-ny;} const mx=(A.x+B.x)/2, my=(A.y+B.y)/2;
      gr.setAttribute('x1',f1(mx-nx*r)); gr.setAttribute('y1',f1(my-ny*r)); gr.setAttribute('x2',f1(mx+nx*r)); gr.setAttribute('y2',f1(my+ny*r));}};};
  const crease='stroke:var(--skc);stroke-width:3.5;opacity:.5;fill:none;stroke-linecap:round', creaseL='stroke:var(--skc);stroke-width:4;opacity:.42;fill:none;stroke-linecap:round';
  // segment = fill + shading + joint creases, drawn together so a part in front never carries another part's shading
  const seg=(g,og)=>{const p=part(g,og), c=cyl(g), cr=[el(g,'path',{},crease),el(g,'path',{},crease)]; return {p,c,cr};};

  const arm=part(base,outline);
  const armSh=el(base,'path',{fill:`url(#${id}arm)`}), armHi=el(base,'path',{fill:`url(#${id}ahi)`});
  const thMeta=part(base,outline), thMetaSh=cyl(base);
  const FN=['index','middle','ring'], segs={}, pads=[], padsO=[];
  FN.forEach(k=>{segs[k]=[0,1,2].map(()=>seg(base,outline)); pads.push(el(base,'ellipse',{fill:HI}));});
  // palm on top of the finger roots and the thenar (its top edge = the crease at the finger bases)
  const palm=part(base,outline);
  const palmClip=el(defs,'clipPath',{id:id+'pc'}); const palmClipP=el(palmClip,'path',{});
  const palmShade=el(base,'g',{'clip-path':`url(#${id}pc)`});
  const hollow=el(palmShade,'ellipse',{rx:120,ry:150,fill:HOL}), thenar=el(palmShade,'ellipse',{rx:70,ry:120,fill:HI}),
    hypo=el(palmShade,'ellipse',{rx:58,ry:130,fill:HI}), mounds=[0,1,2,3].map(()=>el(palmShade,'ellipse',{rx:46,ry:34,fill:HI})),
    flexDark=el(palmShade,'rect',{x:-400,y:-700,width:800,height:760},'fill:var(--ink);opacity:0'),
    palmRim=el(palmShade,'path',{},'fill:none;stroke:var(--ink);stroke-width:34;opacity:.16;filter:url(#'+id+'bl)');
  // wrist blend: the forearm's side shading continues onto the heel of the palm and fades out upward (no ledge at the wrist)
  const wm=el(defs,'linearGradient',{id:id+'wm',gradientUnits:'userSpaceOnUse'}); [[0,'#fff'],[0.35,'#fff'],[1,'#000']].forEach(([o,c])=>el(wm,'stop',{offset:o},`stop-color:${c}`));
  const mk=el(defs,'mask',{id:id+'mk',maskUnits:'userSpaceOnUse',x:-3000,y:-3000,width:8000,height:8000}); const mkr=el(mk,'path',{fill:`url(#${id}wm)`});
  // the forearm's top again over the heel of the palm, faded upward by a mask: one continuous surface across the wrist
  const wtop=el(base,'g',{mask:`url(#${id}mk)`}); const wf=el(wtop,'path',{}), wsh=el(wtop,'path',{fill:`url(#${id}arm)`}), whi=el(wtop,'path',{fill:`url(#${id}ahi)`});
  const detail=el(base,'g',{}), tend=el(base,'g',{});
  segs.pinky=[0,1,2].map(()=>seg(over,overOut)); padsO.push(el(over,'ellipse',{fill:HI}));
  const thumbSegs=[0,1].map(()=>seg(over,overOut)); padsO.push(el(over,'ellipse',{fill:HI}));
  const lines=['heart','head','life','wrist1','wrist2'].reduce((o,k)=>(o[k]=el(detail,'path',{},creaseL),o),{});
  const lg=(n,c)=>{const g=el(defs,'linearGradient',{id:id+n,gradientUnits:'userSpaceOnUse'}); [[0,0],[0.18,1],[0.62,0.8],[1,0]].forEach(([o,a])=>el(g,'stop',{offset:o},`stop-color:${c};stop-opacity:${a}`)); return g;};
  const TG=[lg('tg1','var(--ink)'),lg('tg2','#fff6ea')];
  const bl3=el(defs,'filter',{id:id+'bl3',x:'-80%',y:'-20%',width:'260%',height:'140%'}); el(bl3,'feGaussianBlur',{stdDeviation:10});
  const tSh=el(tend,'path',{},`fill:none;stroke:url(#${id}tg1);stroke-linecap:round;filter:url(#${id}bl3)`), tHi=el(tend,'path',{},`fill:none;stroke:url(#${id}tg2);stroke-linecap:round;filter:url(#${id}bl3)`),
    tSh2=el(tend,'path',{},`fill:none;stroke:var(--ink);stroke-linecap:round;filter:url(#${id}bl2)`), tCore=el(tend,'path',{},`fill:none;stroke:#fff6ea;stroke-linecap:round`),
    fSh=el(tend,'path',{},`fill:none;stroke:url(#${id}tg1);stroke-linecap:round;filter:url(#${id}bl3)`), fHi=el(tend,'path',{},`fill:none;stroke:url(#${id}tg2);stroke-linecap:round;filter:url(#${id}bl3)`);
  // contact pulse (accent): soft glow + spring ring
  const glow=el(fx,'circle',{r:60},`fill:var(--accent);opacity:0;filter:url(#${id}bl2)`);
  const ringI=el(fx,'circle',{r:60},'fill:none;stroke:var(--ink);stroke-width:20;opacity:0'), ring=el(fx,'circle',{r:60},'fill:none;stroke:var(--accent);stroke-width:10;opacity:0');

  const crossAt=(pr,A,B,r,u,w=0.62)=>{const p=vl(A,B,u); const a=pr(A,true), b=pr(B,true), dx=b.x-a.x, dy=b.y-a.y, L=Math.hypot(dx,dy)||1, q=pr(p,true);
    const nx=-dy/L*r*q.k*w, ny=dx/L*r*q.k*w, bow=Math.min(8,L*0.05); return `M${f1(q.x-nx)},${f1(q.y-ny)} Q${f1(q.x+dx/L*bow)},${f1(q.y+dy/L*bow)} ${f1(q.x+nx)},${f1(q.y+ny)}`;};
  const ell=(e,pr,c,rx,ry,rot,hand=true)=>{e.setAttribute('transform',aff(pr,c,hand)+` rotate(${rot})`); e.setAttribute('rx',rx); e.setAttribute('ry',ry);};
  const lineP=(pr,pts,hand=true)=>{const P=pts.map(p=>pr(p,hand)); return smooth(P,false);};

  function draw(st){
    const pr=camera(st), sk=solve(st), H=p=>pr(p,true);
    // heel of the palm blends from forearm space (y >= 40) to hand space (y <= -60) so the wrist bends as one surface
    const HB=p=>{const w=clamp((40-p.y)/100); if(w>=1) return H(p); const a=pr(p,false), b=H(p); return {x:lerp(a.x,b.x,w),y:lerp(a.y,b.y,w),k:lerp(a.k,b.k,w),z:b.z};};
    // forearm (not rotated by the wrist), palm (rotated)
    const armP=ARM.map(HB); arm.set(smooth(armP)); armSh.setAttribute('d',arm.f.getAttribute('d')); armHi.setAttribute('d',arm.f.getAttribute('d'));
    const a0=pr(V(-150,300),false), a1=pr(V(150,300),false); [ARMG,AHI].forEach(g=>{g.setAttribute('x1',f1(a0.x));g.setAttribute('y1',f1(a0.y));g.setAttribute('x2',f1(a1.x));g.setAttribute('y2',f1(a1.y));});
    const op=st.op||0, cup=V(0,0,0);
    const palmP=PALM.map((p,i)=>HB(add(p,i>=7&&i<=10?V(-14*op,0,18*op):cup))); const pd=smooth(palmP); palm.set(pd); palmClipP.setAttribute('d',pd);
    // thumb
    const [C,M,I,T]=sk.thumb, cC=H(C), cM=H(M), cI=H(I), cT=H(T);
    const dMeta=capsule(cC,TH.r[0]*cC.k,cM,TH.r[1]*cM.k); thMeta.set(dMeta); thMetaSh.set(dMeta,cC,cM,TH.r[0]*cC.k*0.9);
    const tj=[[cM,cI,TH.r[2],TH.r[3]],[cI,cT,TH.r[3],TH.r[4]]];
    tj.forEach(([A,B,ra,rb],i)=>{const d=capsule(A,ra*A.k,B,rb*B.k); thumbSegs[i].p.set(d); thumbSegs[i].c.set(d,A,B,(ra*A.k+rb*B.k)/2);});
    // palm modelling
    ell(hollow,pr,V(20,-260),118,150,0); ell(thenar,pr,V(-92,-150),66,118,-24); ell(hypo,pr,add(V(128,-200),V(-10*op,0,12*op)),56,128,8);
    ['index','middle','ring','pinky'].forEach((k,i)=>ell(mounds[i],pr,add(FING[k].m,V(0,-6)),46,30,0));
    flexDark.setAttribute('transform',aff(pr,V(0,0),true)); flexDark.style.opacity=(0.14*Math.sin(clamp((st.flex||0)/60)*Math.PI/2)).toFixed(3);
    palmRim.setAttribute('d',smooth(palmP.slice(2,-2),false));
    { const ad=arm.f.getAttribute('d'); [wf,wsh,whi].forEach(e=>e.setAttribute('d',ad)); mkr.setAttribute('d',ad); const w0=pr(V(0,90),false), w1=HB(V(0,-50)); wm.setAttribute('x1',f1(w0.x)); wm.setAttribute('y1',f1(w0.y)); wm.setAttribute('x2',f1(w1.x)); wm.setAttribute('y2',f1(w1.y)); }
    // fingers
    let pi=0;
    for(const k of ['index','middle','ring','pinky']){const J=sk.fingers[k].map(H), r=FING[k].r;
      for(let i=0;i<3;i++){const d=capsule(J[i],r[i]*J[i].k,J[i+1],r[i+1]*J[i+1].k); segs[k][i].p.set(d); segs[k][i].c.set(d,J[i],J[i+1],(r[i]*J[i].k+r[i+1]*J[i+1].k)/2);}
      const L=sk.fingers[k];
      segs[k][1].cr[0].setAttribute('d',crossAt(pr,L[1],L[2],r[1],0.03,0.5)); segs[k][1].cr[1].setAttribute('d',crossAt(pr,L[1],L[2],r[1],0.11,0.45));
      segs[k][2].cr[0].setAttribute('d',crossAt(pr,L[2],L[3],r[2],0.05,0.45));
      const pad=k==='pinky'?padsO[0]:pads[pi++]; const pc=vl(L[2],L[3],0.62), q=H(pc), a=H(L[2]), b=H(L[3]);
      pad.setAttribute('transform',`translate(${f1(q.x)} ${f1(q.y)}) rotate(${f1(Math.atan2(b.y-a.y,b.x-a.x)/D2R)})`);
      pad.setAttribute('rx',f1(Math.max(6,Math.hypot(b.x-a.x,b.y-a.y)*0.32))); pad.setAttribute('ry',f1(r[3]*q.k*0.7));}
    { const pc=vl(I,T,0.6), q=H(pc); padsO[1].setAttribute('transform',`translate(${f1(q.x)} ${f1(q.y)}) rotate(${f1(Math.atan2(cT.y-cI.y,cT.x-cI.x)/D2R)})`);
      padsO[1].setAttribute('rx',f1(Math.max(6,Math.hypot(cT.x-cI.x,cT.y-cI.y)*0.3))); padsO[1].setAttribute('ry',f1(TH.r[4]*q.k*0.7));
      thumbSegs[1].cr[0].setAttribute('d',crossAt(pr,I,T,TH.r[3],0.05,0.5)); thumbSegs[0].cr[0].setAttribute('d',crossAt(pr,M,I,TH.r[2],0.10,0.5)); }
    // palm creases (follow the cupping)
    lines.heart.setAttribute('d',lineP(pr,[V(172,-338),V(70,-352),V(-20,-372),V(-108,-420)].map((p,i)=>add(p,V(-10*op*(i<2),0,10*op*(i<2))))));
    lines.head.setAttribute('d',lineP(pr,[V(-150,-338),V(-60,-300),V(40,-270),V(130,-236)]));
    lines.life.setAttribute('d',lineP(pr,[V(-152,-326),V(-96,-262),V(-70,-160),V(-62,-40)]));
    const fl=clamp((st.flex||0)/35);
    lines.wrist1.setAttribute('d',smooth([V(-112,-6),V(0,4),V(114,-6)].map(HB),false)); lines.wrist2.setAttribute('d',smooth([V(-110,24),V(0,32),V(112,24)].map(HB),false)); lines.wrist2.style.opacity='.25';
    lines.wrist1.style.opacity=(0.35+0.35*fl).toFixed(2); lines.wrist1.style.strokeWidth=(3.5+3*fl).toFixed(1);
    // palmaris longus ridge (forearm, centre of the wrist) + flexor carpi radialis beside it
    const tn=clamp(st.tendon||0), tp=(x0,y0,x1,y1,dx)=>lineP(pr,[V(x0+dx,y0),V((x0+x1)/2+dx+2,(y0+y1)/2),V(x1+dx,y1)],false), S=pr(V(0,100),false).k;
    const g0=pr(V(0,-10),false), g1=pr(V(0,360),false); TG.forEach(g=>{g.setAttribute('x1',f1(g0.x));g.setAttribute('y1',f1(g0.y));g.setAttribute('x2',f1(g1.x));g.setAttribute('y2',f1(g1.y));});
    tSh.setAttribute('d',tp(6,-10,-2,360,18)); tSh.style.strokeWidth=f1(30*S); tSh.style.opacity=(0.55*tn).toFixed(3);
    tSh2.setAttribute('d',tp(6,-4,-2,330,22)); tSh2.style.strokeWidth=f1(30*S); tSh2.style.opacity=(0*tn).toFixed(3);
    tHi.setAttribute('d',tp(6,-10,-2,360,-5)); tHi.style.strokeWidth=f1(24*S); tHi.style.opacity=(0.95*tn).toFixed(3);
    tCore.setAttribute('d',tp(6,6,-1,250,-4)); tCore.style.strokeWidth=f1(5*S); tCore.style.opacity=(0*clamp(tn*1.6-0.6)).toFixed(3);
    const tf=clamp(tn*1.4-0.4);
    fSh.setAttribute('d',tp(-62,-2,-74,300,12)); fSh.style.strokeWidth=f1(22*S); fSh.style.opacity=(0.22*tf).toFixed(3);
    fHi.setAttribute('d',tp(-62,-2,-74,300,-6)); fHi.style.strokeWidth=f1(18*S); fHi.style.opacity=(0.3*tf).toFixed(3);
    // contact pulse
    const c=H(sk.touch), pu=st.pulse||0, pr2=st.ring||0;
    glow.setAttribute('cx',f1(c.x)); glow.setAttribute('cy',f1(c.y)); glow.setAttribute('r',f1(42*c.k)); glow.style.opacity=(0.4*pu).toFixed(3);
    [ring,ringI].forEach(e=>{e.setAttribute('cx',f1(c.x)); e.setAttribute('cy',f1(c.y)); e.setAttribute('r',f1(Math.max(1,(40+70*pr2)*c.k))); e.style.opacity=(clamp(pu*1.4)).toFixed(3);});
    return {touch:c, thumbTip:cT, pinkyTip:H(sk.fingers.pinky[3]), wrist:pr(V(0,0),false), tendon:pr(V(0,150),false), sk};
  }
  return {draw,solve};
}
window.HandRig=HandRig; window.HandRig.solve=solve;
})();
