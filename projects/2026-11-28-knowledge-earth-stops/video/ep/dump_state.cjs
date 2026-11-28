// node ep/dump_state.js index.html > states.json : per-frame globe state from the SAME state.js the page runs
const fs=require('fs');
const html=fs.readFileSync(process.argv[2],'utf8');
const D=JSON.parse(html.match(/const D=(\{.*?\}), DUR=D\.dur/s)[1]);
const DUR=D.dur, SC=D.sc;
const clamp=(x,a=0,b=1)=>Math.min(b,Math.max(a,x)), lerp=(a,b,u)=>a+(b-a)*u;
const eo=x=>{x=clamp(x);return 1-Math.pow(1-x,3)}, eio=x=>{x=clamp(x);return x*x*x*(x*(6*x-15)+10)};
const S=(tau,w,z)=>{if(tau<=0)return 0; if(z<1){const wd=w*Math.sqrt(1-z*z);
  return 1-Math.exp(-z*w*tau)*(Math.cos(wd*tau)+z*w/wd*Math.sin(wd*tau));} return 1-Math.exp(-w*tau)*(1+w*tau);};
eval(fs.readFileSync(__dirname+'/state.js','utf8')+';globalThis.__gs=gstate;globalThis.__si=sunInfo;');
const N=Math.ceil(DUR*30)+1, out=[];
for(let n=0;n<N;n++){ const t=n/30; const g=__gs(t); out.push(g?{t,x:g.x,y:g.y,r:g.r,lon:g.lon,L:g.L,soft:g.soft,flat:g.flat,night:g.night,id:g.id,sun:__si(t)}:{t,id:null}); }
process.stdout.write(JSON.stringify(out));
