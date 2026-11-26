/* Blind spot ("ลองทำตาม #2"): episode graphics for the brainrot-v3 template.
   Everything is a pure function of t (seek-safe); colours only from the look's CSS variables.
   Shot starts come from the template (SC = shots-th.json); word times below are from assets/audio/words.json.
   TEST SCREEN (shots test..thatsit): ONE fixed layer #ts above the scenes: solid black, white "+" centre (130,690)
   14x90 px, yellow dot centre (950,750) d 120 px (research.md "หน้าจอทดลองบนมือถือ"). No camera, no transition,
   no grain, no flicker inside it: only the labels outside the Y 450-1000 band change (top Y ~336-414, bottom
   Y ~1250-1400); the faint dashed ring round the dot appears only in the second half of thatsit. */
(function(){
const NS='http://www.w3.org/2000/svg';
const $=id=>document.getElementById(id);
const clamp=(x,a=0,b=1)=>Math.min(b,Math.max(a,x)), lerp=(a,b,u)=>a+(b-a)*u;
const eo=x=>{x=clamp(x);return 1-Math.pow(1-x,3)}, eio=x=>{x=clamp(x);return x*x*x*(x*(6*x-15)+10)};
const S=(tau,w,z)=>{if(tau<=0)return 0; if(z<1){const wd=w*Math.sqrt(1-z*z);
  return 1-Math.exp(-z*w*tau)*(Math.cos(wd*tau)+z*w/wd*Math.sin(wd*tau));} return 1-Math.exp(-w*tau)*(1+w*tau);};
const sp=(t,at,w=16,z=0.62)=>S(t-at,w,z);
const f1=v=>v.toFixed(1), f3=v=>v.toFixed(3);
function el(parent,tag,attrs,style){const e=document.createElementNS(NS,tag);for(const k in attrs)e.setAttribute(k,attrs[k]);
  if(style)e.setAttribute('style',style); parent.appendChild(e); return e;}
function div(parent,cls,html,style){const e=document.createElement('div'); e.className=cls; e.innerHTML=html||''; if(style)e.setAttribute('style',style); parent.appendChild(e); return e;}
const INK='stroke:var(--ink);fill:none;stroke-linecap:round;stroke-linejoin:round';
const ACC='stroke:var(--accent);fill:none;stroke-linecap:round;stroke-linejoin:round';
// ring drawn round from the top (u 0..1), ink border under an accent (or white) core
function ringEl(svg,r,w=12,col='var(--accent)'){const g=el(svg,'g',{});
  const a=el(g,'circle',{r,pathLength:1,transform:'rotate(-90)'},INK+`;stroke-width:${w*2};stroke-dasharray:1 1`),
        b=el(g,'circle',{r,pathLength:1,transform:'rotate(-90)'},`stroke:${col};fill:none;stroke-linecap:round;stroke-width:${w};stroke-dasharray:1 1`);
  return {g,set(x,y,u,s=1,o=1){g.setAttribute('transform',`translate(${f1(x)} ${f1(y)}) scale(${f3(s)})`); g.style.opacity=u>0.001?f3(o):'0';
    [a,b].forEach(c=>c.style.strokeDashoffset=f3(1-clamp(u)));}};}
function lineEl(svg,d,w=14,col='var(--accent)'){const g=el(svg,'g',{});
  const i=el(g,'path',{d,pathLength:1},INK+`;stroke-width:${w+14};stroke-dasharray:1 1`), a=el(g,'path',{d,pathLength:1},`stroke:${col};fill:none;stroke-linecap:round;stroke-linejoin:round;stroke-width:${w};stroke-dasharray:1 1`);
  return {g,set(u,o=1){[i,a].forEach(e=>e.style.strokeDashoffset=f3(1-clamp(u))); g.style.opacity=f3(u>0.001?o:0);}};}
// label springs in at `at` (centre anchored), optional exit
const popIn=(e,t,at,out=99,k=1)=>{const a=sp(t,at,20,0.55), o=t<at?0:1-clamp((t-out)/0.12); e.style.opacity=f3(clamp(a*3)*o);
  e.style.transform=`translate(-50%,-50%) scale(${f3((0.7+0.3*a)/k)})`;};

let B=null, T=null;
function build(SC){
  T={}; SC.forEach(s=>T[s.id]={a:s.a,b:s.b});
  const epi=$('epi');
  B={};
  /* ---------- test screen ---------- */
  const ts=div(epi,'','','');
  ts.id='ts';
  div(ts,'plus-h'); div(ts,'plus-v'); div(ts,'dot');
  const tsv=el(ts,'svg',{viewBox:'0 0 1080 1920',width:1080,height:1920});
  // faint dashed ring round the dot (second half of thatsit only)
  B.tring=el(tsv,'circle',{cx:950,cy:750,r:104},'fill:none;stroke:var(--accent2);stroke-width:6;stroke-dasharray:20 16;opacity:0');
  // bottom "move" icon (Y 1250-1400): face (left) and phone sliding toward it
  const mv=el(tsv,'g',{}); B.mv=mv;
  // front face: head, two eyes (left one closed = covered), mouth
  el(mv,'circle',{cx:390,cy:1335,r:60},'fill:none;stroke:#fff;stroke-width:9');
  el(mv,'path',{d:'M356,1322 h20'},'fill:none;stroke:#fff;stroke-width:8;stroke-linecap:round');
  el(mv,'circle',{cx:414,cy:1322,r:9},'fill:#fff');
  el(mv,'path',{d:'M368,1356 q22,16 44,0'},'fill:none;stroke:#fff;stroke-width:8;stroke-linecap:round');
  B.arrow=el(mv,'path',{d:'M545,1335 L472,1335 M497,1312 L470,1335 L497,1358'},'fill:none;stroke:var(--accent);stroke-width:10;stroke-linecap:round;stroke-linejoin:round');
  B.phone=el(mv,'g',{});
  el(B.phone,'rect',{x:-38,y:-68,width:76,height:136,rx:14},'fill:#000;stroke:#fff;stroke-width:8');
  el(B.phone,'rect',{x:-12,y:-56,width:24,height:6,rx:3},'fill:#fff');
  // labels (top) and the countdown numbers (bottom)
  B.lab={test:div(ts,'tlab','ปิดตาซ้าย · ตาขวาจ้อง <em>+</em>'), dont:div(ts,'tlab','อย่ามองจุดนะ'),
         gone:div(ts,'tlab','หายไหม?'), thatsit:div(ts,'tlab acc','นี่แหละ รูในตาเรา')};
  B.num={c3:div(ts,'tnum','3'), c2:div(ts,'tnum','2'), c1:div(ts,'tnum','1')};
  B.ts=ts;

  /* ---------- hole (hook): dark hole grows beside the pupil ---------- */
  const kh=$('kb-hole');
  if(kh){const o=div(kh,'ov'); B.hole=div(o,'hole','','left:0;top:0;width:200px;height:200px');
    const sv=el(o,'svg',{class:'gsvg',viewBox:'0 0 1080 1920',width:1080,height:1920}); B.holeR=ringEl(sv,70,7);}
  /* ---------- cover: ring on the covered eye, then the open (right) eye ---------- */
  const kc=$('kb-cover');
  if(kc){const sv=el(div(kc,'ov'),'svg',{class:'gsvg',viewBox:'0 0 1080 1920',width:1080,height:1920});
    B.covR=ringEl(sv,125,13); B.eyeR=ringEl(sv,82,10,'var(--accent2)');}
  /* ---------- nerve: ring where the optic nerve leaves (plate 915,1025) + arrow out along the nerve ---------- */
  const kn=$('kb-nerve');
  if(kn){const sv=el(div(kn,'ov'),'svg',{class:'gsvg',viewBox:'0 0 1080 1920',width:1080,height:1920});
    B.nerR=ringEl(sv,88,12); B.nerA=lineEl(sv,'M1000,1030 L1060,1046',12);
    B.nerH=lineEl(sv,'M1030,1010 L1062,1046 L1022,1072',12);}

  /* ---------- exit + nocell (19.02-22.22): one drawn eye, the camera zooms into the optic disc ---------- */
  const ex=div(epi,'ov','','opacity:0'); B.ex=ex;
  const exs=el(ex,'svg',{class:'gsvg',viewBox:'0 0 1080 1920',width:1080,height:1920});
  const G=el(exs,'g',{}); B.G=G;
  const C={x:540,y:800,R:320}; B.C=C; const DISC={x:C.x+C.R,y:C.y};
  el(G,'circle',{cx:C.x,cy:C.y,r:C.R},'fill:var(--panel);stroke:var(--accent2);stroke-width:12');
  el(G,'circle',{cx:C.x,cy:C.y,r:C.R-24},'fill:color-mix(in srgb,var(--panel) 70%,var(--bg2));stroke:none');
  // retina (accent) round the back wall, opening at the disc
  const arc=(r,a0,a1)=>{const p=a=>[C.x+r*Math.cos(a*Math.PI/180),C.y+r*Math.sin(a*Math.PI/180)];const [x0,y0]=p(a0),[x1,y1]=p(a1);
    return `M${f1(x0)},${f1(y0)} A${r},${r} 0 0 1 ${f1(x1)},${f1(y1)}`;};
  el(G,'path',{d:arc(C.R-34,-82,-7)},ACC+';stroke-width:16');
  el(G,'path',{d:arc(C.R-34,7,82)},ACC+';stroke-width:16');
  // lens + cornea at the front
  el(G,'ellipse',{cx:C.x-C.R+78,cy:C.y,rx:46,ry:150},'fill:color-mix(in srgb,var(--accent2) 18%,var(--panel));stroke:var(--accent2);stroke-width:8');
  el(G,'path',{d:`M${C.x-C.R+20},${C.y-190} Q${C.x-C.R-70},${C.y} ${C.x-C.R+20},${C.y+190}`},'fill:none;stroke:var(--accent2);stroke-width:8');
  // nerve fibres across the retina to the disc
  B.fib=[-70,-52,-36,-22,22,36,52,70].map(a=>{const r=C.R-48, x=C.x+r*Math.cos(a*Math.PI/180), y=C.y+r*Math.sin(a*Math.PI/180);
    return el(G,'path',{d:`M${f1(x)},${f1(y)} Q${f1(C.x+C.R-70)},${f1(C.y+(y-C.y)*0.35)} ${DISC.x-14},${C.y}`,pathLength:1},'stroke:var(--accent2);fill:none;stroke-width:5;stroke-linecap:round;stroke-dasharray:1 1;opacity:.85');});
  // optic nerve: tube out of the back of the eye, signals run outward
  const ND=`M${DISC.x-20},${C.y} C${DISC.x+80},${C.y} ${DISC.x+120},${C.y+60} ${DISC.x+300},${C.y+110}`;
  B.nTube=el(G,'path',{d:ND,pathLength:1},'stroke:var(--accent2);fill:none;stroke-width:78;stroke-linecap:round;stroke-dasharray:1 1');
  B.nCore=el(G,'path',{d:ND,pathLength:1},'stroke:var(--bg2);fill:none;stroke-width:58;stroke-linecap:round;stroke-dasharray:1 1');
  B.nSig=el(G,'path',{d:ND,pathLength:1},'stroke:var(--accent);fill:none;stroke-width:16;stroke-linecap:round;stroke-dasharray:.05 .13;opacity:0');
  // photoreceptor cells along the retina, none on the disc (|angle| < 9 deg)
  B.rods=[]; for(let a=-42;a<=42;a+=3){ if(Math.abs(a)<9) continue; const r=C.R-62, x=C.x+r*Math.cos(a*Math.PI/180), y=C.y+r*Math.sin(a*Math.PI/180);
    const g=el(G,'g',{transform:`translate(${f1(x)} ${f1(y)}) rotate(${a})`});
    const rr=el(g,'rect',{x:-15,y:-4,width:30,height:8,rx:4},'fill:var(--accent2);stroke:var(--ink);stroke-width:1.5');
    B.rods.push({g,rr,a,x,y}); }
  B.gapR=el(G,'circle',{cx:DISC.x-40,cy:C.y,r:30,pathLength:1,transform:`rotate(-90 ${DISC.x-40} ${C.y})`},'fill:none;stroke:var(--accent);stroke-width:4;stroke-dasharray:.06 .04;opacity:0');
  B.exLab=div(ex,'lab acc','เส้นประสาทตา','left:830px;top:420px');
  B.zeroLab=div(ex,'lab acc','0 เซลล์','left:800px;top:500px;font-size:64px');
  B.DISC=DISC;

  /* ---------- brain glow ---------- */
  const kbB=$('kb-brain'); if(kbB) B.glow=div(div(kbB,'ov'),'glow');
  /* ---------- fill: black hole in the field, filled in smoothly ---------- */
  const kf=$('kb-fill');
  if(kf){const o=div(kf,'ov'); B.fh=div(o,'fhole','','left:0;top:0;width:300px;height:300px');
    const sv=el(o,'svg',{class:'gsvg',viewBox:'0 0 1080 1920',width:1080,height:1920}); B.fR=ringEl(sv,170,8);}
  /* ---------- sci card / years / ask ---------- */
  B.sci=div(epi,'card','<div class="c1">นักวิทยาศาสตร์ฝรั่งเศส</div><div class="c2">ศตวรรษที่ 17</div>');
  B.dimS=div(epi,'dimall','','opacity:0;z-index:-1');
  B.yrs=div(epi,'yrs','<div class="n">0</div><div class="u">ปี</div>');
  B.yN=B.yrs.querySelector('.n');
  B.mini=div(epi,'mini','<div class="mp1"></div><div class="mp2"></div><div class="md"></div>');
  B.nc=[['1',220],['2',540],['3+',860]].map(([n,x])=>div(epi,'ncard',n,`left:${x}px;margin-left:-120px`));
}

const TW={hole:1.46, cover:3.84, rightEye:5.12, test:5.48, dont:7.06, move:8.38, c3:10.70, c2:11.80, c1:12.78,
  gone:13.86, thatsit:15.68, nerveDot:18.10, nerveOut:18.32, exit:19.10, nocell:19.84, mai:20.48, cell:20.72,
  brain:24.14, fill:25.38, sci:28.26, fr:28.90, n350:30.16, pi:30.94, ask:[32.12,32.32,32.50,32.68]};

window.EPI=function(t,o){
  if(!B) build(o.SC);
  const DUR=o.DUR;
  /* badge: from the end of the hook title to just before the loop seam (frame 0 / last frame show the kicker) */
  const bIn=T.cover.a, bOut=DUR-0.3, bd=$('badge');
  const bu=t<bIn?0:(t<bOut?sp(t,bIn,18,0.6):1-clamp((t-bOut)/0.12));
  bd.style.opacity=f3(clamp(bu*2)); bd.style.transform=`scale(${f3(0.8+0.2*clamp(bu))})`;

  /* ---------- test screen: on (no fade) from test.a to nerve.a ---------- */
  const on=t>=T.test.a && t<T.nerve.a;
  B.ts.style.opacity=on?'1':'0';
  if(on){
    // dont label stays through move / c3 / c2 / c1 (the dot is still there to ignore)
    const show=(t>=T.gone.a)?(t>=T.thatsit.a?'thatsit':'gone'):(t>=T.dont.a?'dont':'test');
    for(const k in B.lab){ if(k===show) popIn(B.lab[k],t,T[k].a); else B.lab[k].style.opacity='0'; }
    // move icon: phone slides toward the face (move shot only)
    const mvOn=t>=T.move.a&&t<T.c3.a; B.mv.style.opacity=mvOn?'1':'0';
    if(mvOn){const u=(t-T.move.a)/(T.c3.a-T.move.a); const x=lerp(800,600,eio(clamp(u*1.15)));
      B.phone.setAttribute('transform',`translate(${f1(x)} 1335)`); B.arrow.style.opacity=f3(0.5+0.5*Math.sin(t*7)); }
    for(const k of ['c3','c2','c1']){ const e=B.num[k]; if(t>=T[k].a&&t<T[k].b) popIn(e,t,T[k].a); else e.style.opacity='0'; }
    // dashed ring: second half of thatsit only
    const half=(T.thatsit.a+T.nerve.a)/2;
    B.tring.style.opacity=f3(0.55*clamp((t-half)/0.35));
  }

  /* ---------- hole ---------- */
  if(B.hole){const u=sp(t,TW.hole,9,0.7), r=8+46*u+3*Math.sin((t-TW.hole)*5)*clamp(u), x=355, y=975;
    B.hole.style.opacity=t>=TW.hole-0.05?f3(clamp(u*2)):'0';
    B.hole.style.transform=`translate(${f1(x-100)}px,${f1(y-100)}px) scale(${f3(r/56)})`;
    B.holeR.set(x,y,eo((t-TW.hole-0.15)/0.5),(r+16)/70,0.9);}
  /* ---------- cover rings ---------- */
  if(B.covR){B.covR.set(320,930,eo((t-TW.cover)/0.45),1+0.04*Math.sin((t-TW.cover)*6)*clamp(t-TW.cover));
    B.eyeR.set(565,968,eo((t-TW.rightEye)/0.35),1);}
  /* ---------- nerve ---------- */
  if(B.nerR){B.nerR.set(915,1025,eo((t-TW.nerveDot)/0.4),1+0.06*Math.sin((t-TW.nerveDot)*7)*clamp(t-TW.nerveDot));
    const v=eo((t-TW.nerveOut)/0.3); B.nerA.set(v); B.nerH.set(eo((t-TW.nerveOut-0.2)/0.2));}

  /* ---------- exit + nocell ---------- */
  const xOn=t>=T.exit.a && t<T.never.a; B.ex.style.opacity=xOn?'1':'0';
  if(xOn){
    const a0=T.exit.a, zu=eio((t-T.nocell.a)/0.75), k=lerp(1,2.3,zu)*(1+0.012*(t-a0));
    const ent=sp(t,a0,14,0.7), s0=0.86+0.14*ent;
    const X=lerp(B.DISC.x,560,zu), Y=B.DISC.y+lerp(0,40,zu);
    B.G.setAttribute('transform',`translate(${f1(X)} ${f1(Y)}) scale(${f3(k*s0)}) translate(${-B.DISC.x} ${-B.DISC.y})`);
    B.fib.forEach((p,i)=>p.style.strokeDashoffset=f3(1-eo((t-a0-0.02*i)/0.4)));
    const nt=eo((t-TW.exit)/0.45); B.nTube.style.strokeDashoffset=f3(1-nt); B.nCore.style.strokeDashoffset=f3(1-nt);
    B.nSig.style.opacity=f3(clamp((t-TW.exit-0.4)/0.2)); B.nSig.style.strokeDashoffset=f3(-(t*0.9));
    popIn(B.exLab,t,TW.exit+0.05,T.nocell.a);
    // cells pop in from the gap outward, then shimmer as they catch light; the gap stays empty
    B.rods.forEach(r=>{const at=TW.nocell+Math.abs(r.a)/42*0.35, u=sp(t,at,18,0.55);
      r.g.style.opacity=t<at?'0':'1'; r.g.setAttribute('transform',`translate(${f1(r.x)} ${f1(r.y)}) rotate(${r.a}) scale(${f3(Math.max(0.01,u))})`);
      r.rr.style.fill=(Math.sin(t*6-Math.abs(r.a)*0.25)>0.55&&t>TW.cell)?'var(--accent)':'var(--accent2)';});
    const g=eo((t-TW.mai)/0.4); B.gapR.style.opacity=f3(g); B.gapR.style.strokeDashoffset=f3(-(t*0.3));
    B.gapR.setAttribute('r',f1(30+4*Math.sin(t*5)*g));
    popIn(B.zeroLab,t,TW.cell);
  }

  /* ---------- brain glow pulses on "สมอง" ---------- */
  if(B.glow){const u=t>=TW.brain?Math.exp(-(t-TW.brain)*1.4):0, p=t>=TW.brain?0.5+0.5*Math.sin((t-TW.brain)*8):0;
    B.glow.style.opacity=f3(clamp(0.25+0.55*u*p+0.25*u)*(t>=TW.brain-0.2?1:0));}
  /* ---------- fill: hole closes from the edge on "เนียน" ---------- */
  if(B.fh){const x=560, y=975, u=eio((t-TW.fill)/0.8), r=150*(1-u)+0.01;
    const wob=1+0.03*Math.sin(t*9)*(1-u);
    B.fh.style.opacity=u<0.999?'1':'0';
    B.fh.style.transform=`translate(${f1(x-150)}px,${f1(y-150)}px) scale(${f3(r/150*wob)})`;
    const rv=clamp((t-T.fill.a)/0.3); B.fR.set(x,y,rv,(r+18)/170, 1-clamp((t-TW.fill-0.9)/0.3));}

  /* ---------- sci: card ---------- */
  const sOn=t>=T.sci.a&&t<T.years.a;
  B.dimS.style.opacity=(t>=T.sci.a&&t<T.ask.a)?'1':'0';
  if(sOn){popIn(B.sci,t,TW.sci); const c2=B.sci.querySelector('.c2'); const a=sp(t,TW.fr,18,0.5);
    c2.style.transform=`scale(${f3(t<TW.fr?0.001:0.6+0.4*a)}) rotate(${f3(-3*a)}deg)`; c2.style.opacity=t<TW.fr?'0':'1';}
  else B.sci.style.opacity='0';
  /* ---------- years: count up to 350 on "350", "+" lands, "ปี" pops ---------- */
  const yOn=t>=T.years.a&&t<T.ask.a;
  if(yOn){const cu=eo((t-TW.n350)/0.7), n=Math.round(350*cu);
    B.yN.textContent=t<TW.n350?'0':(cu>=0.999?'350+':String(n));
    const a=sp(t,TW.n350,14,0.5);
    B.yrs.style.opacity=f3(clamp((t-T.years.a)/0.15));
    B.yrs.style.transform=`translate(-50%,-50%) scale(${f3((0.75+0.25*a)*(1+0.08*Math.exp(-Math.max(0,t-TW.n350-0.72)*6)*(t>TW.n350+0.72?1:0)))})`;
    const u=B.yrs.querySelector('.u'); const pu=sp(t,TW.pi,20,0.5); u.style.opacity=t<TW.pi?'0':'1'; u.style.transform=`scale(${f3(0.6+0.4*pu)})`;
    }
  else B.yrs.style.opacity='0';
  /* ---------- ask: mini test screen + 1 / 2 / 3+ ---------- */
  const aOn=t>=T.ask.a&&t<T.loop.a;
  if(aOn){popIn(B.mini,t,T.ask.a+0.02); B.mini.style.transform+=` translateY(${f1(-6*Math.sin((t-T.ask.a)*3))}px)`;
    B.nc.forEach((e,i)=>{const at=TW.ask[i+1], a=sp(t,at,20,0.5); e.style.opacity=t<at?'0':'1';
      const bob=t>at?Math.sin((t-at)*5+i)*6:0;
      e.style.transform=`translateY(${f1(40*(1-a)+bob)}px) scale(${f3(0.5+0.5*a)}) rotate(${f3((i-1)*4*a)}deg)`;
      e.classList.toggle('on', t>=TW.ask[3]+0.25 && i===((Math.floor((t-TW.ask[3])*3))%3));});}
  else {B.mini.style.opacity='0'; B.nc.forEach(e=>e.style.opacity='0');}
};
})();
