// Generic deterministic player: renders EP.shots at time T. Hard cuts between shots.
// Shot = { id, t0, t1, cam0:{zoom,cx,cy}, bg:()=>{}, bgKey?, cam?:(lt,t)=>({p,dx,dy,rot}), draw?:(lt,t,fr)=>{} }
// bg is painted once per bgKey into a framebuffer 16% larger than the frame (camera headroom: the camera never leaves the scene).
/* global A, EP, DATA, brush */
const FBM = 1.16; const fbCache = {}; let T = 0;
function getBg(shot) {
  const key = shot.bgKey || shot.id; if (fbCache[key]) return fbCache[key];
  const fw = Math.round(A.W * FBM), fh = Math.round(A.H * FBM);
  const fb = createFramebuffer({ width: fw, height: fh, density: 1 });
  fb.draw(() => {
    background('#000'); push(); translate(-fw / 2, -fh / 2); brush.load(fb); randomSeed(shot.seed || 7);
    A.reset(); A.translate(fw / 2, fh / 2); A.scale(shot.cam0.zoom); A.translate(-shot.cam0.cx, -shot.cam0.cy);
    shot.bg(); pop();
  });
  brush.load(); fbCache[key] = fb; return fb;
}
function shotAt(t) { return EP.shots.find(s => t >= s.t0 && t < s.t1) || EP.shots[EP.shots.length - 1]; }
function setup() { createCanvas(A.W, A.H, WEBGL); pixelDensity(1); noLoop(); brush.scaleBrushes(1.6); }
function draw() {
  const t = T, fr = Math.round(t * DATA.fps), shot = shotAt(t), lt = t - shot.t0;
  const c = Object.assign({ p: 1, dx: 0, dy: 0, rot: 0 }, shot.cam ? shot.cam(lt, t, shot) : {});
  background('#000');
  const fb = getBg(shot);
  push(); translate(c.dx, c.dy); rotate(c.rot); scale(c.p); image(fb, -fb.width / 2, -fb.height / 2, fb.width, fb.height); pop();
  push(); translate(-A.W / 2, -A.H / 2); randomSeed(1000 + Math.floor(fr / 2)); // ink "boils" on twos
  A.camera({ zoom: shot.cam0.zoom * c.p, cx: shot.cam0.cx, cy: shot.cam0.cy, dx: c.dx, dy: c.dy, rot: c.rot });
  if (shot.draw) shot.draw(lt, t, fr);
  pop();
}
window.renderFrame = async (t) => { T = t; await redraw(); if (window.overlay) window.overlay(t); return shotAt(t).id; };
window.preload_all = async () => { for (const s of EP.shots) { T = s.t0; await redraw(); } return Object.keys(fbCache).length; };
