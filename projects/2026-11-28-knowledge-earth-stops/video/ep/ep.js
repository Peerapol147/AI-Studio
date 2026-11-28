// ===== earth-stops: one NASA globe (Blue Marble day + Black Marble night) mapped onto a sphere. The sphere itself is
// baked per frame into assets/globe-v.mp4 by bake_globe.py from the same state.js (the render browser has no WebGL and
// a per-pixel canvas made the runtime miss its ready deadline); this page shows/zooms that plate and draws the light
// overlays (Thailand marker, shock rings, spin arrow, speed lines) from the same state.
const CSS=getComputedStyle($('root')), COL=n=>CSS.getPropertyValue(n).trim();
const C_ACC=COL('--accent')||'#FFE14D', C_ACC2=COL('--accent2')||'#FF6FAE', C_TXT=COL('--text')||'#FFFFFF';
const hexA=(h,a)=>{h=h.replace('#','');const n=parseInt(h.length===3?h.split('').map(c=>c+c).join(''):h,16);return `rgba(${n>>16&255},${n>>8&255},${n&255},${a})`;};
const rnd=(i,k)=>{const x=Math.sin(i*127.1+k*311.7)*43758.5453;return x-Math.floor(x);};
function project(g,latD,lonD){ const la=latD*RAD, dl=(lonD-g.lon)*RAD;
  const X=Math.cos(la)*Math.sin(dl), Y=Math.sin(la), Z=Math.cos(la)*Math.cos(dl);
  const y=Y*CPH-Z*SPH, z=Y*SPH+Z*CPH; return {x:g.x+X*g.r, y:g.y-y*g.r, vis:z>0.05};}
// speed lines + debris flying east (to the right) after a stop
function streaks(t,t0,g,n,a){ if(t<t0) return; const u=t-t0, fade=a*Math.min(1,u/0.06);
  for(let i=0;i<n;i++){ const sp=1500+rnd(i,1)*2200, len=90+rnd(i,2)*320, y=g.y+(rnd(i,3)*2-1)*g.r*1.15;
    const x=g.x-g.r*0.7+((u*sp+rnd(i,4)*1500)%1700); const w=2+rnd(i,5)*6;
    const lg=ctx.createLinearGradient(x-len,y,x,y); const c=i%5===0?C_ACC:C_TXT;
    lg.addColorStop(0,hexA(c,0)); lg.addColorStop(1,hexA(c,0.75*fade));
    ctx.strokeStyle=lg; ctx.lineWidth=w; ctx.lineCap='round'; ctx.beginPath(); ctx.moveTo(x-len,y); ctx.lineTo(x,y); ctx.stroke(); }
  for(let i=0;i<Math.round(n/3);i++){ const sp=700+rnd(i,6)*1100, y0=g.y+(rnd(i,7)*2-1)*g.r*0.9;
    const x=g.x+g.r*0.2+((u*sp+rnd(i,8)*900)%1300), y=y0+Math.sin(u*3+i)*14, s=5+rnd(i,9)*12;
    ctx.save(); ctx.translate(x,y); ctx.rotate(u*(4+rnd(i,10)*8)); ctx.fillStyle=hexA(i%3?'#c9c2d8':C_ACC2,0.9*fade);
    ctx.fillRect(-s/2,-s/2,s,s*0.7); ctx.restore(); } }
// curved arrow over the globe showing the spin direction (west -> east)
function spinArrow(g,t,a,spd){ if(a<=0) return; const R=g.r*1.13, a0=200*RAD, a1=335*RAD;
  ctx.save(); ctx.globalAlpha=a; ctx.lineCap='round'; ctx.strokeStyle='rgba(0,0,0,.55)'; ctx.lineWidth=22;
  ctx.beginPath(); ctx.arc(g.x,g.y,R,a0,a1); ctx.stroke(); ctx.strokeStyle=C_ACC; ctx.lineWidth=12; ctx.setLineDash([46,26]);
  ctx.lineDashOffset=-t*spd; ctx.beginPath(); ctx.arc(g.x,g.y,R,a0,a1); ctx.stroke(); ctx.setLineDash([]);
  const hx=g.x+R*Math.cos(a1), hy=g.y+R*Math.sin(a1), dir=a1+Math.PI/2;
  ctx.translate(hx,hy); ctx.rotate(dir); ctx.fillStyle=C_ACC; ctx.strokeStyle='rgba(0,0,0,.6)'; ctx.lineWidth=6;
  ctx.beginPath(); ctx.moveTo(34,0); ctx.lineTo(-18,-30); ctx.lineTo(-18,30); ctx.closePath(); ctx.stroke(); ctx.fill(); ctx.restore(); }
function rings(cx,cy,t,t0){ if(t<t0||t>t0+1.6) return; for(let k=0;k<3;k++){ const u=(t-t0-k*0.16)/1.1; if(u<=0||u>=1) continue;
  ctx.strokeStyle=hexA(k===1?C_ACC2:C_ACC,0.9*(1-u)); ctx.lineWidth=16*(1-u)+3; ctx.beginPath(); ctx.arc(cx,cy,40+620*eo(u),0,7); ctx.stroke(); } }
function win(t,a,b,fi,fo){ fi=fi||0.15; fo=fo||0.12; if(t<a||t>=b+fo) return 0; return Math.min(eio((t-a)/fi), t>b?1-(t-b)/fo:1); }
const ctx=$('glo').getContext('2d');
function globe(t){
  ctx.clearRect(0,0,1080,1920);
  const g=gstate(t), th=$('thai'), w=$('gw'); th.style.opacity='0';
  if(!g){ w.style.opacity='0'; return; }
  w.style.opacity=f2(g.alpha); w.style.transform=`scale(${g.zoom.toFixed(4)})`;
  if(t>=SHOT.speedo.a&&t<SHOT.traffic.a){ const p=project(g,14,100.5); const a=win(t,SHOT.speedo.a+0.15,SHOT.stop.b,0.2)*(p.vis?1:0);
    th.style.opacity=f2(a); const pop=1+0.25*(1-S(t-SHOT.speedo.a-0.15,16,0.5));
    th.style.transform=`translate(${f2(p.x)}px,${f2(p.y)}px) scale(${pop.toFixed(3)})`;
    rings(p.x,p.y,t,STOP2); }
  if(g.id==='speedo'||g.id==='stop') spinArrow(g,t,win(t,SHOT.speedo.a+0.2,STOP2-0.02,0.25,0.08),70);
  if(g.id==='slow') spinArrow(g,t,win(t,SHOT.slow.a+0.15,SHOT.slow.b,0.2),lerp(70,30,clamp((t-SHOT.slow.a)/1.58)));
  if(t<SHOT.jet.a) streaks(t,HIT,g,46,1);
  else if(t>=SHOT.stop.a&&t<SHOT.traffic.a+0.12) streaks(t,STOP2,g,40,1);
  else if(t>=SHOT.east.a&&t<SHOT.storm.a+0.12) streaks(t,SHOT.east.a,g,56,1);
}
// shake 4 frames on each stop
function shake(t){ let dx=0,dy=0; [HIT,STOP2].forEach(h=>{ const f=Math.floor((t-h)*30); if(f>=0&&f<4){ const A=[26,-20,13,-7][f]; dx=A; dy=-A*0.6; } });
  $('stage').style.transform=dx?`translate(${dx}px,${dy}px)`:''; }
// time capsule: one capsule, text + width morph
const TC=[[SHOT.feet.a,'ตอนนี้'],[SHOT.stop.a+0.08,'วินาทีแรก'],[SHOT.daynight.a,'ต่อมา'],[SHOT.sixmonth.a,'ทั้งปี'],[24.98,'✓ของจริง']];
const TC_OUT=SHOT.choose.a-0.25;
const CHK='<svg class="ico" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="4" stroke-linecap="round" stroke-linejoin="round"><path d="M3.5 12.5l5.5 5.5L20.5 6"/></svg>';
const tHTML=s=>s.startsWith('✓')?CHK+s.slice(1):s;
const meas=$('tmeas'); meas.innerHTML=TC.map(x=>`<div class="tt">${tHTML(x[1])}</div>`).join('');
let tcW=null;
function capsule(t){ const el=$('tcap');
  if(!tcW||tcW.some(w=>!w)) tcW=[...meas.children].map(c=>c.getBoundingClientRect().width);
  let k=-1; TC.forEach((x,i)=>{if(t>=x[0]) k=i;});
  if(k<0||t>=TC_OUT+0.4){ el.style.opacity='0'; return; }
  const a=S(t-TC[0][0],20,0.6), out=t>=TC_OUT?1-eio((t-TC_OUT)/0.3):1;
  el.style.opacity=f2(clamp(Math.min(1,(t-TC[0][0])/0.08)*out));
  el.style.transform=`scale(${(lerp(0.4,1,a)*lerp(0.6,1,out)).toFixed(4)})`;
  const u=t-TC[k][0], w0=k?tcW[k-1]:tcW[0], w=lerp(w0,tcW[k],S(u,18,0.7)); el.style.width=f2(w)+'px';
  const A=$('tA'), B=$('tB'); const m=eio(u/0.22);
  A.innerHTML=tHTML(TC[k][1]); A.style.transform=`translateY(${f2(60*(1-m))}px)`; A.style.opacity=f2(k?m:1);
  if(k){ B.innerHTML=tHTML(TC[k-1][1]); B.style.transform=`translateY(${f2(-60*m)}px)`; B.style.opacity=f2(1-m); } else B.style.opacity='0';
  if(k===TC.length-1){ const p=S(u,22,0.35); el.style.boxShadow=`0 0 0 ${f2(7+10*(1-p))}px var(--ink),0 14px 0 rgba(0,0,0,.35)`; }
}
const fmt=n=>Math.round(n).toString().replace(/\B(?=(\d{3})+(?!\d))/g,',');
function grp(id,a){ const e=$(id); e.style.opacity=f2(clamp(a)); return e; }
function overlays(t){
  grp('gp-jet',win(t,SHOT.jet.a+0.15,SHOT.jet.b,0.2,0.1));
  // speedo: count 0 -> 1,600 on "หนึ่งพันหกร้อย ... ชั่วโมง"
  const sa=win(t,7.3,SHOT.speedo.b,0.12,0.1); grp('gp-speedo',sa);
  if(sa>0){ const v=1600*eo(clamp((t-7.3)/(8.85-7.3))); const done=t>=8.85;
    $('spd').innerHTML='~'+fmt(done?1600:Math.round(v/10)*10)+'<span class="unit">กม./ชม.</span>';
    const p=done?1+0.14*(1-S(t-8.85,20,0.35)):1+0.015*Math.sin(t*40)*(t>7.3?1:0); $('spd').style.transform=`scale(${p.toFixed(4)})`; }
  // storm: 408 km/h then x4 on "สี่เท่า"
  const wa=win(t,SHOT.storm.a+0.06,SHOT.storm.b,0.15,0.1); const ws=grp('gp-storm',wa);
  if(wa>0){ const u=S(t-SHOT.storm.a,16,0.7); ws.style.transform=`translateY(${f2(80*(1-u))}px)`;
    const v=408*eo(clamp((t-15.95)/(16.9-15.95))); $('wind').innerHTML=fmt(t>=16.9?408:v)+'<span class="unit">กม./ชม.</span>';
    const x=t<17.42?0:S(t-17.42,17,0.45); $('x4').style.opacity=f2(clamp(x*3)); $('x4').style.transform=`rotate(${f2(lerp(-30,8,x))}deg) scale(${(0.2+0.8*x).toFixed(4)})`; }
  // east arrow
  const ea=win(t,SHOT.east.a,SHOT.east.b,0.06,0.1); grp('gp-east',ea);
  if(ea>0){ const u=S(t-T_EAST,15,0.62); $('arrow').style.transform=`translateX(${f2(-500*(1-u)+14*Math.sin((t-T_EAST)*9))}px) scaleX(${(0.3+0.7*clamp(u*1.2)).toFixed(4)})`; }
  // six months
  const xa=win(t,SHOT.sixmonth.a,SHOT.sixmonth.b,0.1,0.1); grp('gp-six',xa);
  if(xa>0){ const d=S(t-21.22,16,0.5), n=S(t-21.4,16,0.5);
    $('sixd').style.transform=`scale(${d.toFixed(4)}) rotate(-3deg)`; $('sixn').style.transform=`scale(${n.toFixed(4)}) rotate(3deg)`;
    $('sixd').style.opacity=f2(clamp(d*2)); $('sixn').style.opacity=f2(clamp(n*2)); }
  // slow
  const la=win(t,SHOT.slow.a+0.3,SHOT.slow.b,0.2,0.1); grp('gp-slow',la);
  if(la>0){ const u=S(t-SHOT.slow.a-0.3,14,0.6); $('slowtag').style.transform=`translateX(-50%) translateY(${f2(40*(1-u))}px)`; }
  // ms: clock + typed number (ราว 1.8 ms ~ 0.002 s per 100 years: research.md 6)
  const ma=win(t,SHOT.ms.a,SHOT.ms.b,0.1,0.12); const mg=grp('gp-ms',ma);
  if(ma>0){ const u=t-SHOT.ms.a; mg.style.transform=`scale(${(1+0.25*(1-S(u,18,0.9))).toFixed(4)})`; mg.style.transformOrigin='50% 40%';
    $('hs').setAttribute('transform',`rotate(${f2(u*140)} 250 250)`); $('hm').setAttribute('transform',`rotate(${f2(40+u*12)} 250 250)`);
    const full='ราว +0.002 วินาที', n=Math.floor(clamp((t-35.96)/(37.1-35.96))*full.length+(t>=35.96?1:0));
    $('mstxt').textContent=full.slice(0,Math.min(full.length,n)); $('mssub').textContent=t>=37.58?'/ 100 ปี':'';
    $('mssub').style.transform=`scale(${(t>=37.58?S(t-37.58,18,0.5):0).toFixed(4)})`; }
  // choose
  const ca=win(t,SHOT.choose.a+0.1,SHOT.loop.a,0.2,0.3); grp('gp-choose',ca);
  if(ca>0){ const i1=S(t-SHOT.choose.a-0.1,16,0.55), i2=S(t-SHOT.choose.a-0.25,16,0.55);
    const hd=t>=40.88&&t<41.88?S(t-40.88,20,0.4):0, hn=t>=41.88?S(t-41.88,20,0.4):0;
    $('chd').style.transform=`scale(${(i1*(1+0.16*hd)*(hn?0.92:1)).toFixed(4)}) rotate(-3deg)`;
    $('chn').style.transform=`scale(${(i2*(1+0.16*hn)*(hd?0.92:1)).toFixed(4)}) rotate(3deg)`;
    $('chd').style.opacity=f2(hn?0.55:1); $('chn').style.opacity=f2(hd?0.55:1); }
}
const TICKS=$('ticks'); if(TICKS&&!TICKS.childNodes.length){ let h=''; for(let i=0;i<12;i++){ const a=i*30*RAD; h+=`<line x1="${250+180*Math.sin(a)}" y1="${250-180*Math.cos(a)}" x2="${250+(i%3?196:204)*Math.sin(a)}" y2="${250-(i%3?196:204)*Math.cos(a)}" stroke="var(--text)" stroke-width="${i%3?6:12}" stroke-linecap="round"/>`; } TICKS.innerHTML=h; }
function episode(t){ globe(t); shake(t); capsule(t); overlays(t); }
