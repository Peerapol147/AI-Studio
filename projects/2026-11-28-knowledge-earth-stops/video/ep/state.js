// globe state: pure functions of t (shared by the page and tools/bake_globe via node)
const RAD=Math.PI/180, PHI=12*RAD, CPH=Math.cos(PHI), SPH=Math.sin(PHI);
const SHOT={}; SC.forEach((s,i)=>{SHOT[s.id]=s; s.i=i;});
const HIT=0.38, STOP2=10.04;               // "หยุด" (hook hit) / "หยุดปุ๊บ" (words.json)
const T_EAST=SHOT.east.a+0.08;             // "ตะวันออก"
const nrm=v=>{const l=Math.hypot(v[0],v[1],v[2])||1;return [v[0]/l,v[1]/l,v[2]/l];};
const FRONT=nrm([-0.5,0.38,0.78]);
// longitude at the centre of the disc (deg). Surface moves to the RIGHT (east) while it spins.
function lonC(t){
  if(t<SHOT.jet.a) return 100-40*Math.min(t,HIT);            // spins, dead stop on "หยุด"
  if(t<SHOT.traffic.a) return 128-14*(Math.min(t,STOP2)-SHOT.speedo.a);   // spins with Thailand, stops on "หยุดปุ๊บ"
  if(t<SHOT.storm.a) return 128-14*(STOP2-SHOT.speedo.a);     // east: stopped
  if(t<SHOT.slow.a) return 108;                               // daynight / six months / orbit: not spinning
  if(t<SHOT.choose.a){const u=t-SHOT.slow.a; return 128-(16*u-2.5*u*u);}  // real: spins, a little slower
  if(t<SHOT.loop.a) return 100+12*(t-SHOT.choose.a);              // choose: night half over East Asia's city lights
  return 100+40*(DUR-t);                                      // loop: ends on the frame-0 globe
}
// per-shot target state of the globe
const st=(x,y,r,L,soft,flat,night)=>({x,y,r,L,soft,flat,night});
const GT={
  hook:()=>st(540,1080,400,FRONT,0.22,0,0.5),
  speedo:()=>st(540,820,330,FRONT,0.22,0,0.5),
  stop:()=>st(540,820,330,FRONT,0.22,0,0.5),
  east:()=>st(330,820,290,FRONT,0.22,0,0.5),
  daynight:t=>{const u=clamp((t-SHOT.daynight.a)/(SHOT.daynight.b-SHOT.daynight.a));
    return st(540,840,370+40*u,nrm([-0.9,0.12,0.55-1.0*u]),0.1,0,1);},   // slow push + the terminator sweeps across
  sixmonth:t=>{const u=clamp((t-SHOT.sixmonth.a)/(SHOT.sixmonth.b-SHOT.sixmonth.a)); return st(540,820,350+20*u,nrm([-1,0.1,-0.12]),0.06,0,1);},
  orbit:t=>{const th=Math.PI*eio((t-SHOT.orbit.a)/(SHOT.orbit.b-SHOT.orbit.a)); const sn=Math.sin(th), cs=Math.cos(th);
    return st(540+330*cs,780+150*sn,100*(1+0.25*sn),nrm([-cs,0.06,-sn]),0.08,0,1);},
  slow:()=>st(540,830,370,FRONT,0.22,0,0.5),
  choose:()=>st(540,830,380,[-1,0,0],0.012,0.85,1),
  loop:()=>GT.hook(),
};
const GL=Object.keys(GT);
const isG=s=>!!(s&&GT[s.id]);
function curShot(t){let k=0; for(let i=0;i<SC.length;i++) if(t>=SC[i].a) k=i; return SC[k];}
function prevG(s){for(let i=s.i-1;i>=0;i--) if(isG(SC[i])) return SC[i]; return null;}
const mixS=(A,B,k)=>({x:lerp(A.x,B.x,k),y:lerp(A.y,B.y,k),r:lerp(A.r,B.r,k),L:nrm([lerp(A.L[0],B.L[0],k),lerp(A.L[1],B.L[1],k),lerp(A.L[2],B.L[2],k)]),
  soft:lerp(A.soft,B.soft,k),flat:lerp(A.flat,B.flat,k),night:lerp(A.night,B.night,k)});
function gstate(t){
  const s=curShot(t); let alpha=1, zoom=1, g;
  if(isG(s)){
    const p=prevG(s), tgt=GT[s.id](t), u=t-s.a;
    if(!p) g=tgt;
    else { const pe=GT[p.id](p.b-0.001); const k=s.beat==='loop'?eio(u/0.62):S(u,13,0.8); g=mixS(pe,tgt,k); }
    const pv=SC[s.i-1];
    if(pv&&!isG(pv)){ alpha=eio(u/0.1); zoom=1+0.3*(1-S(u,18,0.9)); }     // enters with the look's zoom
  } else {
    const pv=SC[s.i-1]; if(!isG(pv)||t-s.a>=0.12) return null;
    g=GT[pv.id](t); alpha=1-(t-s.a)/0.12;
  }
  g.alpha=alpha; g.zoom=zoom; g.lon=lonC(t); g.id=s.id; return g;
}
// sun + orbit path (orbit shot) and the low sun glow on the left (day/night shots), baked into the globe plate
function sunInfo(t){ const sa=SHOT.orbit.a, ob=SHOT.orbit.b;
  const so=t<sa?0:eio((t-sa)/0.3)*(t>ob?Math.max(0,1-(t-ob)/0.12):1);
  const th=Math.PI*eio((t-sa)/(ob-sa));
  const on=t>=SHOT.daynight.a&&t<SHOT.calmearth.a+0.12;
  return {so:on?so:0, behind:t>=sa&&t<ob+0.12&&Math.sin(th)<0, left:on&&t<sa+0.3?0.32*(1-so):0};
}

