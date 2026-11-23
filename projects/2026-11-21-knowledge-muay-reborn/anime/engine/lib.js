// anime engine helpers (p5 2.x + p5.brush 3, WEBGL) — reusable across episodes.
// All drawing goes through A.* with our own 2D affine stack, so brush weights stay in screen pixels
// and layer order = call order (fills via brush.wash, ink via brush.set).
/* global brush */
const A = (() => {
  const W = (window.FMT || {}).W || 1080, H = (window.FMT || {}).H || 1920;
  let M = [1, 0, 0, 1, 0, 0]; const stack = [];
  let INK = '#2a1e22', INKW = 1.5, INKBRUSH = window.INKNAME || 'pen'; const CRISP = !!window.CRISP; // global ink color, ink weight multiplier, boil seed
  let rnd = mulberry(1);
  function mulberry(a) { return () => { a |= 0; a = a + 0x6D2B79F5 | 0; let t = Math.imul(a ^ a >>> 15, 1 | a); t = t + Math.imul(t ^ t >>> 7, 61 | t) ^ t; return ((t ^ t >>> 14) >>> 0) / 4294967296; }; }
  const seed = s => { rnd = mulberry(s); };
  const R = (a = 1, b) => b === undefined ? rnd() * a : a + rnd() * (b - a);
  // ---- affine stack
  const push = () => stack.push(M.slice());
  const pop = () => { M = stack.pop(); };
  const mul = (n) => { const [a, b, c, d, e, f] = M; M = [a * n[0] + c * n[1], b * n[0] + d * n[1], a * n[2] + c * n[3], b * n[2] + d * n[3], a * n[4] + c * n[5] + e, b * n[4] + d * n[5] + f]; };
  const translate = (x, y) => mul([1, 0, 0, 1, x, y]);
  const scale = (sx, sy = sx) => mul([sx, 0, 0, sy, 0, 0]);
  const rotate = (r) => { const c = Math.cos(r), s = Math.sin(r); mul([c, s, -s, c, 0, 0]); };
  const pt = (x, y) => [M[0] * x + M[2] * y + M[4], M[1] * x + M[3] * y + M[5]];
  const k = () => Math.sqrt(Math.abs(M[0] * M[3] - M[1] * M[2]));
  const reset = () => { M = [1, 0, 0, 1, 0, 0]; };
  // ---- primitives (local coords)
  let GH = null; // afterimage mode: every shape becomes a flat translucent silhouette (no ink)
  function style(o) {
    if (GH) { brush.wash(GH.col, GH.a); brush.noFill(); brush.noStroke(); return; }
    if (o.fill) brush.wash(o.fill, o.alpha === undefined ? 255 : o.alpha); else brush.noWash();
    brush.noFill(); brush.noHatch && brush.noHatch();
    if (o.ink === false || o.w === 0) brush.noStroke(); else brush.set(o.brush || INKBRUSH, o.ink || INK, lineW(o.w || 1));
  }
  // line weight. Old look: grows linearly with zoom (close-ups got lines 2-3x heavier than wide shots).
  // Crisp look: ONE weight scale for every shot — only a gentle growth with size (k^0.3), close-up faces no longer get their own multiplier.
  const LW = { base: 3.0, pow: 0.3 };
  const lineW = w => CRISP ? Math.max(0.5, w * LW.base * Math.pow(k(), LW.pow)) : Math.max(0.15, w * INKW * k() / 2.2);
  let mute = false; // static/background passes silence dynamic drawing
  function poly(pts, o = {}) { // closed shape
    if (mute || pts.length < 2 || (GH && (!o.fill || o.alpha < 200))) return; style(o);
    brush.beginShape(o.curv === undefined ? 0.35 : o.curv);
    for (const p of pts) { const q = pt(p[0], p[1]); brush.vertex(q[0], q[1]); }
    brush.endShape(o.open ? false : true);
  }
  function stroke(pts, o = {}) { poly(pts, { ...o, fill: null, open: true }); }
  function ellPts(cx, cy, rx, ry, rot = 0, n = 18) { const out = []; for (let i = 0; i < n; i++) { const a = i / n * Math.PI * 2; const x = rx * Math.cos(a), y = ry * Math.sin(a); out.push([cx + x * Math.cos(rot) - y * Math.sin(rot), cy + x * Math.sin(rot) + y * Math.cos(rot)]); } return out; }
  const ell = (cx, cy, rx, ry, o = {}, rot = 0) => poly(ellPts(cx, cy, rx, ry, rot, o.n || 18), { curv: 0.5, ...o });
  function capsule(x1, y1, x2, y2, r1, r2 = r1) { // limb outline points
    const a = Math.atan2(y2 - y1, x2 - x1), n = a + Math.PI / 2, pts = [];
    for (let i = 0; i <= 6; i++) { const t = n + i / 6 * Math.PI; pts.push([x2 + Math.cos(t - Math.PI) * r2, y2 + Math.sin(t - Math.PI) * r2]); }
    for (let i = 0; i <= 6; i++) { const t = n + i / 6 * Math.PI; pts.push([x1 + Math.cos(t) * r1, y1 + Math.sin(t) * r1]); }
    return pts;
  }
  const limb = (x1, y1, x2, y2, r1, r2, o) => poly(capsule(x1, y1, x2, y2, r1, r2), { curv: 0.2, ...o });
  const rect = (x, y, w, h, o = {}) => poly([[x, y], [x + w, y], [x + w, y + h], [x, y + h]], { curv: 0, ...o });
  // watercolor fill (texture) — for backgrounds; no ink
  function wc(pts, color, alpha = 110, bleed = 0.15, tex = 0.4) {
    if (mute) return;
    brush.noWash(); brush.noStroke(); brush.fill(color, alpha); brush.fillBleed(bleed); brush.fillTexture(tex, 0.25);
    brush.beginShape(0); for (const p of pts) { const q = pt(p[0], p[1]); brush.vertex(q[0], q[1]); } brush.endShape(true); brush.noFill();
  }
  // vertical gradient band with native p5 (fast, flat) — drawn in screen space of current transform
  function grad(p, x, y, w, h, stops) { // stops: [[t,'#hex'],...]
    for (let i = 0; i < stops.length - 1; i++) {
      const [t0, c0] = stops[i], [t1, c1] = stops[i + 1];
      const a = pt(x, y + h * t0), b = pt(x + w, y + h * t0), c = pt(x + w, y + h * t1), d = pt(x, y + h * t1);
      p.noStroke(); p.beginShape(); p.fill(c0); p.vertex(a[0], a[1]); p.vertex(b[0], b[1]); p.fill(c1); p.vertex(c[0], c[1]); p.vertex(d[0], d[1]); p.endShape();
    }
  }
  // ---- camera: maps world -> screen. zoom about (cx,cy) world point placed at screen center (+shake/rot)
  function camera(c) { reset(); translate(W / 2 + (c.dx || 0), H / 2 + (c.dy || 0)); rotate(c.rot || 0); scale(c.zoom || 1); translate(-(c.cx ?? W / 2), -(c.cy ?? H / 2)); }
  const ease = t => t < 0 ? 0 : t > 1 ? 1 : t * t * (3 - 2 * t);
  const lerp = (a, b, t) => a + (b - a) * t;
  const clamp = (v, a, b) => Math.max(a, Math.min(b, v));
  // spring 0->1 with overshoot
  const spring = (t, w = 14, z = 0.45) => t <= 0 ? 0 : 1 - Math.exp(-z * w * t) * Math.cos(w * Math.sqrt(1 - z * z) * t);
  return { W, H, seed, R, push, pop, translate, scale, rotate, pt, k, reset, poly, stroke, ell, ellPts, capsule, limb, rect, wc, grad, camera, ease, lerp, clamp, spring,
    setInk: (c, w) => { INK = c; INKW = w; }, setBrush: b => { INKBRUSH = b; }, ghost: (g, fn) => { const p = GH; GH = g; try { fn(); } finally { GH = p; } }, LW, get INK() { return INK; }, get mute() { return mute; }, set mute(v) { mute = v; } };
})();

// static-layer helpers (used by episode.js, consumed by player.js)
window.LAYER = 'fg'; window.SIG = null;
window.STATIC = (fn) => (...args) => { if (LAYER === 'sig') { window.SIG.push(JSON.stringify(args.map(a => typeof a === 'number' ? +a.toFixed(1) : a))); return; } if (LAYER !== 'bg') return; const m = A.mute; A.mute = false; fn(...args); A.mute = m; };
