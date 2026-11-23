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
  const fb = createFramebuffer({ width: fw, height: fh, density: window.PD || 1 });
  fb.draw(() => {
    background('#000'); push(); translate(-fw / 2, -fh / 2); brush.load(fb); randomSeed(shot.seed || 7);
    A.reset(); A.translate(fw / 2, fh / 2); A.scale(shot.cam0.zoom); A.translate(-shot.cam0.cx, -shot.cam0.cy);
    shot.bg(); if (shot._sig) staticPass(shot, 'bg'); pop();
    // cinematic depth of field: close-up backgrounds are blurred once here (cached, no per-frame cost)
    const dof = shot.dof !== undefined ? shot.dof : (window.CRISP ? (shot.cam0.zoom >= 1.8 ? 2.5 : 0) : shot.cam0.zoom >= 1.8 ? 5 : shot.cam0.zoom >= 1.35 ? 2 : 0);
    if (dof) filter(BLUR, dof);
  });
  brush.load(); fbCache[key] = fb; return fb;
}
function shotAt(t) { return EP.shots.find(s => t >= s.t0 && t < s.t1) || EP.shots[EP.shots.length - 1]; }
function setup() { createCanvas(A.W, A.H, WEBGL); pixelDensity(window.PD || 1); noLoop();
  // 'ink': clean technical-pen line for the crisp look (solid, almost no scatter, slight pressure taper)
  brush.add('ink', { weight: 0.3, scatter: 0.03, sharpness: 0.95, grain: 1, opacity: 245, spacing: 0.08, pressure: { curve: [0.3, 0.2], min_max: [1.25, 0.95] } });
  brush.scaleBrushes(1.6); }
let ARMED = false; // p5 calls draw() once on load: skip it (it painted the first scene's background for nothing, minutes on CPU)
function draw() {
  if (!ARMED) return;
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
window.renderFrame = async (t) => { ARMED = true; T = t; await redraw(); if (window.overlay) window.overlay(t); return shotAt(t).id; };
window.preload_all = async () => { ARMED = true; for (const s of EP.shots) { T = s.t0; await redraw(); } return Object.keys(fbCache).length; };
