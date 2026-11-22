/* Naga silhouette (Thai/Lao style), shared by the main composition (s10/s11) and the thumbnail.
   One long body driven by a spine (array of [x,y] points, head first). The head is drawn in local space
   (facing +x, origin = neck = spine point 0): long head, upturned curled snout, flame crest (หงอน) sweeping back
   in กนก tongues, small flame beard. Body + head are one silhouette: every piece is stroked first (rim layer),
   then every piece is filled on top, so only the outer edge of the union shows a rim. No joins, no spikes. */
(function(){
const NS='http://www.w3.org/2000/svg';
const mk=(tag,a,p)=>{const e=document.createElementNS(NS,tag);for(const k in a)e.setAttribute(k,a[k]);p.appendChild(e);return e;};
const f=v=>v.toFixed(1);
// cubic bezier sampled
const bez=(P,n)=>[...Array(n+1)].map((_,i)=>{const u=i/n,v=1-u;return [0,1].map(k=>v*v*v*P[0][k]+3*v*v*u*P[1][k]+3*v*u*u*P[2][k]+u*u*u*P[3][k]);});
// one flame leaf (กนก): grows from base (bx,by) along a heading that starts at th0 (deg, screen coords) and turns by
// `turn` deg (accelerating), so the tip curls; width swells near the base and tapers to a fine curled point.
function leaf(bx,by,th0,turn,L,W,n=48){ const C=[[bx,by]], H=[]; let x=bx,y=by;
  for(let i=0;i<=n;i++){const u=i/n, th=(th0+turn*Math.pow(u,2.6))*Math.PI/180; H.push(th); if(i<n){x+=Math.cos(th)*L/n; y+=Math.sin(th)*L/n; C.push([x,y]);}}
  const A=[],B=[]; for(let i=0;i<=n;i++){const u=i/n, w=W*Math.sin(Math.PI/2*Math.min(1,u/0.2))*Math.pow(1-u,0.75)+0.6, nx=-Math.sin(H[i]), ny=Math.cos(H[i]);
    A.push([C[i][0]+nx*w,C[i][1]+ny*w]); B.push([C[i][0]-nx*w,C[i][1]-ny*w]);}
  const P=A.concat(B.reverse()); return 'M'+P.map(q=>f(q[0])+' '+f(q[1])).join(' L')+' Z'; }
// skull: long head, raised brow, snout tapering to a modest upturned curl (จมูกงอน), closed mouth line
const SKULL='M-70 -36 C-30 -44 10 -62 62 -64 C100 -65 128 -52 152 -40 C178 -30 204 -26 224 -30 C236 -33 242 -44 238 -58 '+
  'C254 -50 258 -28 242 -14 C228 -2 206 4 182 6 C156 18 120 32 84 38 C40 44 -10 44 -70 36 Z';
// crest (หงอน): a fan of flame leaves rising from the brow and crown, each curling back at the tip, longest in the middle
const CREST=[ [146,-30,-66,-102,129,16], [112,-44,-80,-102,184,20], [74,-50,-94,-98,204,21], [36,-46,-110,-88,179,19], [0,-38,-126,-74,142,16], [-36,-30,-144,-61,110,13],
  [128,-38,-74,-95,94,15], [92,-48,-88,-95,109,16], [54,-49,-102,-88,104,15], [18,-42,-118,-74,92,14] ]
  .map(a=>leaf(...a));
// beard: two small flame leaves under the jaw, curling back
const BEARD=[ [160,14,96,110,72,11], [118,30,108,100,62,10] ].map(a=>leaf(...a));
const HEAD=[...CREST,SKULL,...BEARD]; window.NAGA_HEAD=HEAD;
// Catmull-Rom through points -> smooth closed outline
function smooth(P){ let d=`M${f(P[0][0])} ${f(P[0][1])}`; const n=P.length;
  for(let i=0;i<n-1;i++){const p0=P[Math.max(0,i-1)],p1=P[i],p2=P[i+1],p3=P[Math.min(n-1,i+2)];
    d+=` C${f(p1[0]+(p2[0]-p0[0])/6)} ${f(p1[1]+(p2[1]-p0[1])/6)} ${f(p2[0]-(p3[0]-p1[0])/6)} ${f(p2[1]-(p3[1]-p1[1])/6)} ${f(p2[0])} ${f(p2[1])}`;}
  return d+' Z'; }
window.NagaRig=function(parent,opt={}){
  const g=mk('g',{},parent);
  const glow=mk('g',{opacity:.55},g), rim=mk('g',{},g), fill=mk('g',{},g), sc=mk('g',{},g);
  const W='stroke-linejoin';
  const gB=mk('path',{fill:'none',stroke:'#b89cff','stroke-width':46,'stroke-opacity':.10,[W]:'round'},glow);
  const gH=HEAD.map(d=>mk('path',{d,fill:'none',stroke:'#b89cff','stroke-width':40,'stroke-opacity':.10,[W]:'round'},glow));
  const rB=mk('path',{fill:'none',stroke:'#ffb8cc','stroke-width':7,[W]:'round'},rim);
  const rH=HEAD.map(d=>mk('path',{d,fill:'none',stroke:'#ffb8cc','stroke-width':5,[W]:'round'},rim));
  const BODY='#03040b';
  const fB=mk('path',{fill:BODY},fill), fH=HEAD.map(d=>mk('path',{d,fill:BODY},fill));
  const eye=mk('path',{d:'M128 -26 C140 -36 158 -36 168 -26 C156 -20 140 -19 128 -26 Z',fill:'#ffd9a0',opacity:.6},fill);
  const brow=mk('path',{d:'M112 -44 C136 -56 166 -52 188 -38',fill:'none',stroke:'#ffb8cc','stroke-width':3,'stroke-opacity':.35,'stroke-linecap':'round'},fill);
  const N=opt.scales||44;
  const scales=[...Array(N)].map((_,i)=>mk('path',{d:'M-11 -4 Q0 7 11 -4',fill:'none',stroke:i%3?'#c8d4ff':'#ffc6d6','stroke-width':3,'stroke-linecap':'round',opacity:0},sc));
  return {g,
    // pts: spine head-first; hs: head scale; rimO: rim strength 0..1; t: time (shimmer)
    set(pts,hs,rimO,t){
      const n=pts.length-1, L=[],R=[];
      for(let i=0;i<=n;i++){const p=pts[i],q=pts[Math.min(n,i+1)],o=pts[Math.max(0,i-1)]; let dx=q[0]-o[0],dy=q[1]-o[1]; const m=Math.hypot(dx,dy)||1; dx/=m; dy/=m;
        const u=i/n, wd=hs*(30+12*Math.sin(Math.min(1,u/0.16)*Math.PI/2))*Math.pow(1-u,0.8)+2.5;
        L.push([p[0]-dy*wd,p[1]+dx*wd]); R.push([p[0]+dy*wd,p[1]-dx*wd]);}
      // round the tail tip, close outline
      const d=smooth(L.concat(R.reverse()));
      gB.setAttribute('d',d); rB.setAttribute('d',d); fB.setAttribute('d',d);
      const hd=Math.atan2(pts[0][1]-pts[2][1],pts[0][0]-pts[2][0]), fl=Math.cos(hd)<0?-1:1;
      const tr=`translate(${f(pts[0][0])} ${f(pts[0][1])}) rotate(${f(hd*180/Math.PI)}) scale(${hs.toFixed(3)} ${(hs*fl).toFixed(3)})`;
      [...gH,...rH,...fH,eye,brow].forEach(e=>e.setAttribute('transform',tr));
      rim.setAttribute('opacity',(0.25+0.6*rimO).toFixed(3)); glow.setAttribute('opacity',(0.35+0.5*rimO).toFixed(3));
      eye.setAttribute('opacity',(0.45+0.15*Math.sin(t*1.7)).toFixed(3));
      // scales: soft crescents along the back, a slow glint travelling head -> tail
      scales.forEach((s,i)=>{const k=4+Math.floor(i*(n-10)/N); if(k>=n){s.setAttribute('opacity','0');return;}
        const p=pts[k],q=pts[k+1]; const a=Math.atan2(q[1]-p[1],q[0]-p[0]); const u=k/n, wd=hs*(30+12*Math.sin(Math.min(1,u/0.16)*Math.PI/2))*Math.pow(1-u,0.8);
        const side=(i%2?0.38:-0.12)*wd*fl, x=p[0]-Math.sin(a)*side, y=p[1]+Math.cos(a)*side;
        const sh=Math.pow(Math.max(0,Math.sin(t*2.6-k*0.22)),6);
        s.setAttribute('transform',`translate(${f(x)} ${f(y)}) rotate(${f(a*180/Math.PI+90)}) scale(${(0.5+0.7*(1-u)).toFixed(2)})`);
        s.setAttribute('opacity',(0.06+0.5*sh).toFixed(3));});
    }};
};
})();
