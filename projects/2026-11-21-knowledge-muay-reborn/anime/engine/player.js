// Generic deterministic player: renders EP.shots at time T. Hard cuts between shots.
// Shot = { id, t0, t1, cam0:{zoom,cx,cy}, bg:()=>{}, bgKey?, cam?:(lt,t)=>({p,dx,dy,rot}), draw?:(lt,t,fr)=>{} }
// bg is painted once per bgKey into a framebuffer 16% larger than the frame (camera headroom: the camera never leaves the scene).
/* global A, EP, DATA, brush */
const FBM = 1.16; const fbCache = {}; let T = 0;
// Static layer: helpers wrapped with STATIC() (desks, background extras) are painted ONCE into the cached background
// (they cost ~15 s/frame on CPU when redrawn every frame). LAYER: 'fg' normal | 'sig' collect args | 'bg' paint statics only.
function staticPass(shot, mode) { if (!shot.draw) return; const m = A.mute; LAYER = mode; A.mute = true; try { shot.draw(0, shot.t0, 0); } finally { A.mute = m; LAYER = 'fg'; } }
function getBg(shot) {
  if (shot._sig === undefined) { window.SIG = []; staticPass(shot, 'sig'); shot._sig = window.SIG.join('|'); }
  const key = (shot.bgKey || shot.id) + (shot._sig ? '#' + shot._sig : ''); if (fbCache[key]) return fbCache[key];
  const fw = Math.round(A.W * FBM), fh = Math.round(A.H * FBM);
  const fb = createFramebuffer({ width: fw, height: fh, density: 1 });
  fb.draw(() => {
    background('#000'); push(); translate(-fw / 2, -fh / 2); brush.load(fb); randomSeed(shot.seed || 7);
    A.reset(); A.translate(fw / 2, fh / 2); A.scale(shot.cam0.zoom); A.translate(-shot.cam0.cx, -shot.cam0.cy);
    shot.bg(); if (shot._sig) staticPass(shot, 'bg'); pop();
    // cinematic depth of field: close-up backgrounds are blurred once here (cached, no per-frame cost)
    const crisp = new URLSearchParams(location.search).get('crisp'); const dof = shot.dof !== undefined ? shot.dof : (shot.cam0.zoom >= 1.8 ? (crisp ? 2 : 5) : shot.cam0.zoom >= 1.35 && !crisp ? 2 : 0);
    if (dof) filter(BLUR, dof);
  });
  brush.load(); fbCache[key] = fb; return fb;
}
function shotAt(t) { return EP.shots.find(s => t >= s.t0 && t < s.t1) || EP.shots[EP.shots.length - 1]; }
function setup() { createCanvas(A.W, A.H, WEBGL); pixelDensity(1); noLoop(); brush.scaleBrushes(1.6); }
function draw() {
  const t = T, fr = Math.round(t * DATA.fps), shot = shotAt(t), lt = t - shot.t0;
  // shots without their own camera get a slow push + gentle drift (never a dead-still frame)
  const c = Object.assign({ p: 1, dx: 0, dy: 0, rot: 0 }, shot.cam ? shot.cam(lt, t, shot) : { p: 1.01 + 0.012 * lt, dx: 6 * Math.sin(lt * 0.55), dy: 3 * Math.sin(lt * 0.41) });
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
