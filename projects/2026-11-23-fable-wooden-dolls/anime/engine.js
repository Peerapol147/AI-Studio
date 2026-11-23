// Wooden dolls fable: flat 2D Canvas engine. Every character/prop is ONE function, so it looks identical in every shot.
// Coordinates: world px at zoom 1 (1080x1920 frame). All animation is a pure function of time t (deterministic frames).
const W = 1080, H = 1920;
const E = {};
E.rng = seed => () => { seed |= 0; seed = seed + 0x6D2B79F5 | 0; let x = Math.imul(seed ^ seed >>> 15, 1 | seed); x = x + Math.imul(x ^ x >>> 7, 61 | x) ^ x; return ((x ^ x >>> 14) >>> 0) / 4294967296; };
E.clamp = (v, a = 0, b = 1) => Math.max(a, Math.min(b, v));
E.lerp = (a, b, k) => a + (b - a) * k;
E.ease = k => { k = E.clamp(k); return k * k * (3 - 2 * k); };
E.seg = (t, a, b) => E.ease((t - a) / (b - a));
const hex = h => [1, 3, 5].map(i => parseInt(h.slice(i, i + 2), 16));
E.mix = (a, b, k) => { const A = hex(a), B = hex(b); return '#' + A.map((v, i) => Math.round(v + (B[i] - v) * E.clamp(k)).toString(16).padStart(2, '0')).join(''); };
E.rgba = (h, a) => { const [r, g, b] = hex(h); return `rgba(${r},${g},${b},${a})`; };

// palette (story.md: night blue-black, the campfire orange is the only warm colour)
E.P = {
  night: '#121a33', cloak: '#6b4a2f', cloakD: '#4a321f', hoodIn: '#2e1f14', skin: '#f0cfae', blush: '#e88d7a', eye: '#17131a',
  mitten: '#8c6440', boot: '#3a2a1f', scarf: '#c8282e', scarf2: '#2f8f6a',
  gold: '#c7922c', goldL: '#f6d36d', goldD: '#8a5f1a', log: '#655b53', logD: '#463f3a', logEnd: '#8a7d70',
  sled: '#7a5a3c', sledD: '#4d3826', snow: '#dfe8f5',
};
// L = light on the subject 0..1 (0 = cold night shadow, 1 = full firelight); colours sink toward night blue
E.lit = (c, L) => E.mix(c, E.P.night, (1 - E.clamp(L)) * 0.62);

function blob(ctx, pts) { ctx.beginPath(); ctx.moveTo(pts[0][0], pts[0][1]); for (let i = 1; i < pts.length; i++) ctx.lineTo(pts[i][0], pts[i][1]); ctx.closePath(); }
function circle(ctx, x, y, r, fill) { ctx.beginPath(); ctx.arc(x, y, r, 0, Math.PI * 2); ctx.fillStyle = fill; ctx.fill(); }
function ellipse(ctx, x, y, rx, ry, fill, rot = 0) { ctx.beginPath(); ctx.ellipse(x, y, rx, ry, rot, 0, Math.PI * 2); ctx.fillStyle = fill; ctx.fill(); }
E.circle = circle; E.ellipse = ellipse;

// ---------- the traveler ----------
// o: x,y (ground point under the body), s scale, pose 'stand'|'walk'|'pull'|'sit'|'crouch', face -1..1 (where the face turns),
// mood 'neutral'|'smile'|'sad'|'relief'|'worry'|'shut', phase (walk cycle), lean (rad), L light, scarf colour, wind 0..1,
// hands {l:[x,y], r:[x,y]} in local px (body frame), front(ctx) = drawn between body and arms (things held), shiver 0..1, t
E.traveler = (ctx, o) => {
  const P = E.P, L = o.L ?? 1, s = o.s || 1, face = o.face ?? 0, pose = o.pose || 'stand', t = o.t || 0;
  const sit = pose === 'sit', crouch = pose === 'crouch', moving = pose === 'walk' || pose === 'pull';
  const ph = o.phase || 0;
  ctx.save();
  ctx.translate(o.x + (o.shiver ? Math.sin(t * 71) * 2.2 * o.shiver : 0), o.y);
  ctx.scale(s, s);
  // contact shadow
  ellipse(ctx, 0, 2, sit ? 105 : 70, 12, 'rgba(5,8,20,0.45)');
  ctx.rotate(o.lean || 0);
  const bob = moving ? -Math.abs(Math.sin(ph)) * 6 : (crouch ? 0 : 0);
  ctx.translate(0, bob);
  const hemY = sit ? -4 : crouch ? -14 : -24, shY = sit ? -112 : crouch ? -116 : -150, headY = sit ? -170 : crouch ? -172 : -208;
  const hemW = sit ? 104 : crouch ? 88 : 72, shW = 36;
  const cloak = E.lit(P.cloak, L), cloakD = E.lit(P.cloakD, L);
  // boots
  const boot = (x, y) => ellipse(ctx, x, y - 8, 20, 11, E.lit(P.boot, L));
  if (sit) { boot(-60 + face * 30, -2); boot(48 + face * 30, -2); }
  else if (crouch) { boot(-34, 0); boot(34, 0); }
  else { const a = moving ? Math.sin(ph) * 16 : 0; boot(-20 + a, 0); boot(20 - a, 0); }
  // cloak (bell)
  const sway = (o.wind || 0) * Math.sin(t * 5.3) * 4;
  ctx.beginPath(); ctx.moveTo(-shW, shY);
  ctx.bezierCurveTo(-shW - 14, shY + 50, -hemW - 4, hemY - 40, -hemW + sway, hemY);
  ctx.quadraticCurveTo(0, hemY + 10, hemW + sway, hemY);
  ctx.bezierCurveTo(hemW + 4, hemY - 40, shW + 14, shY + 50, shW, shY); ctx.closePath();
  ctx.fillStyle = cloak; ctx.fill();
  // cloak fold + hem shade
  ctx.strokeStyle = cloakD; ctx.lineWidth = 5; ctx.lineCap = 'round';
  ctx.beginPath(); ctx.moveTo(-6 + face * 8, shY + 30); ctx.quadraticCurveTo(-10 + face * 10, (shY + hemY) / 2, -14 + face * 12, hemY - 8); ctx.stroke();
  // head: hood with a soft point at the back
  const fx = face * 15, fy = headY + 8;
  const tipDir = face >= 0 ? -1 : 1;
  ctx.beginPath(); ctx.moveTo(-34 * tipDir * -1, headY - 30);
  ctx.fillStyle = cloak;
  ctx.beginPath(); ctx.moveTo(tipDir * 10, headY - 64); ctx.quadraticCurveTo(tipDir * 70, headY - 70, tipDir * (92 + 6 * Math.sin(t * 2.1) * (o.wind || 0)), headY - 18); ctx.quadraticCurveTo(tipDir * 70, headY - 30, tipDir * 50, headY + 10); ctx.closePath(); ctx.fill();
  circle(ctx, 0, headY, 66, cloak);
  circle(ctx, fx * 0.85, fy, 49, E.lit(P.hoodIn, L));
  circle(ctx, fx, fy + 2, 42, E.lit(P.skin, L));
  // face features
  const mood = o.mood || 'neutral', ex = 14, ey = fy - 2;
  ctx.fillStyle = E.lit(P.eye, 1); ctx.strokeStyle = E.lit(P.eye, 1); ctx.lineWidth = 4; ctx.lineCap = 'round';
  const squeeze = 1 - Math.abs(face) * 0.25;
  if (mood === 'smile' || mood === 'relief' || mood === 'shut') {
    for (const sx of [-1, 1]) { ctx.beginPath(); const cx = fx + sx * ex * squeeze; if (mood === 'shut') { ctx.moveTo(cx - 6, ey + 1); ctx.lineTo(cx + 6, ey + 1); } else ctx.arc(cx, ey + 3, 6, Math.PI * 1.15, Math.PI * 1.85); ctx.stroke(); }
  } else { for (const sx of [-1, 1]) circle(ctx, fx + sx * ex * squeeze + face * 2, ey, 4.8, E.lit(P.eye, 1)); }
  if (mood === 'sad' || mood === 'worry') { ctx.lineWidth = 3; for (const sx of [-1, 1]) { ctx.beginPath(); const cx = fx + sx * ex * squeeze; ctx.moveTo(cx - sx * 7, ey - 12); ctx.lineTo(cx + sx * 4, ey - 9 + (mood === 'worry' ? -3 : 0)); ctx.stroke(); } }
  ctx.globalAlpha = 0.35 * (0.4 + 0.6 * L); circle(ctx, fx - 24 * squeeze, fy + 12, 7, P.blush); circle(ctx, fx + 24 * squeeze, fy + 12, 7, P.blush); ctx.globalAlpha = 1;
  ctx.lineWidth = 3.5; ctx.beginPath();
  const my = fy + 18, mx = fx + face * 3;
  if (mood === 'smile' || mood === 'relief') ctx.arc(mx, my - 5, 7, Math.PI * 0.2, Math.PI * 0.8);
  else if (mood === 'sad') ctx.arc(mx, my + 5, 6, Math.PI * 1.2, Math.PI * 1.8);
  else if (mood === 'worry') { ctx.moveTo(mx - 5, my + 1); ctx.quadraticCurveTo(mx, my - 3, mx + 5, my + 1); }
  else { ctx.moveTo(mx - 4, my); ctx.lineTo(mx + 4, my); }
  ctx.stroke();
  // scarf (the red accent): wrap + one tail that blows with the wind
  const scarf = E.lit(o.scarf || P.scarf, Math.max(L, 0.55));
  ctx.fillStyle = scarf;
  ctx.beginPath(); ctx.ellipse(0, shY - 6, 46, 16, 0, 0, Math.PI * 2); ctx.fill();
  const tailSide = face >= 0 ? -1 : 1, wa = (o.wind || 0) * (0.9 + Math.sin(t * 9) * 0.25);
  ctx.save(); ctx.translate(tailSide * 22, shY - 2); ctx.rotate(tailSide * (0.15 + wa * 1.1));
  ctx.beginPath(); ctx.moveTo(-9, 0); ctx.lineTo(9, 0); ctx.lineTo(11, 56); ctx.lineTo(-7, 52); ctx.closePath(); ctx.fill();
  ctx.fillStyle = E.mix(scarf, '#000000', 0.25); ctx.fillRect(-8, 44, 18, 4); ctx.restore();
  // things held (doll, log) sit in front of the body, behind the mittens
  if (o.front) { ctx.save(); o.front(ctx); ctx.restore(); }
  // arms: sleeve + mitten
  const shL = [-shW + 4, shY + 16], shR = [shW - 4, shY + 16];
  const hands = Object.assign({ l: [-56, shY + 82], r: [56, shY + 82] }, o.hands || {});
  for (const [sh, hd] of [[shL, hands.l], [shR, hands.r]]) {
    ctx.strokeStyle = cloakD; ctx.lineWidth = 26; ctx.lineCap = 'round';
    ctx.beginPath(); ctx.moveTo(sh[0], sh[1]); ctx.quadraticCurveTo((sh[0] + hd[0]) / 2 + (hd[0] > sh[0] ? -6 : 6), (sh[1] + hd[1]) / 2 + 10, hd[0], hd[1]); ctx.stroke();
    circle(ctx, hd[0], hd[1], 14, E.lit(P.mitten, L));
  }
  if (o.over) { ctx.save(); o.over(ctx); ctx.restore(); }
  ctx.restore();
};
// mouth position in world space, for breath puffs
E.mouthAt = o => { const s = o.s || 1, pose = o.pose || 'stand'; const headY = pose === 'sit' ? -170 : pose === 'crouch' ? -172 : -208; return [o.x + (o.face ?? 0) * 18 * s, o.y + (headY + 26) * s]; };

// ---------- the wooden doll (palm-sized, woven twigs, golden swirl grain) ----------
// o: x,y = feet, s scale (1 = 64 px tall), face -1..1, L light, p = build progress 0..1 (for the weaving shot), tilt
E.doll = (ctx, o) => {
  const P = E.P, s = o.s || 1, L = o.L ?? 1, p = o.p ?? 1, face = o.face ?? 0;
  ctx.save(); ctx.translate(o.x, o.y); ctx.rotate(o.tilt || 0); ctx.scale(s, s);
  if (o.shadow !== false) ellipse(ctx, 0, 1, 18, 4, 'rgba(5,8,20,0.4)');
  const g = E.lit(P.gold, L), gl = E.lit(P.goldL, Math.max(L, 0.5)), gd = E.lit(P.goldD, L);
  ctx.lineCap = 'round';
  const twig = (x1, y1, x2, y2, w, k) => { if (p < k) return; const q = E.clamp((p - k) / 0.18); ctx.strokeStyle = g; ctx.lineWidth = w; ctx.beginPath(); ctx.moveTo(x1, y1); ctx.lineTo(x1 + (x2 - x1) * q, y1 + (y2 - y1) * q); ctx.stroke(); };
  twig(-6, -18, -10, 0, 6, 0.55); twig(6, -18, 10, 0, 6, 0.6);              // legs
  twig(-10, -36, -24, -24, 5, 0.7); twig(10, -36, 24, -24, 5, 0.75);         // arms
  if (p >= 0.25) {                                                            // body: woven bundle
    const q = E.clamp((p - 0.25) / 0.25);
    ctx.save(); ctx.beginPath(); ctx.rect(-20, -42 + 30 * (1 - q), 40, 30 * q); ctx.clip();
    ctx.beginPath(); ctx.roundRect(-12, -42, 24, 28, 9); ctx.fillStyle = g; ctx.fill();
    ctx.strokeStyle = gd; ctx.lineWidth = 2;
    for (let i = 0; i < 3; i++) { ctx.beginPath(); ctx.moveTo(-12, -37 + i * 8); ctx.quadraticCurveTo(0, -33 + i * 8, 12, -37 + i * 8); ctx.stroke(); }
    ctx.restore();
  }
  if (p >= 0) {                                                               // head with the swirl (same grain as the golden log)
    const q = E.clamp(p / 0.25);
    ctx.globalAlpha = q;
    circle(ctx, 0, -52, 13, g);
    ctx.strokeStyle = gl; ctx.lineWidth = 2.2; ctx.beginPath();
    for (let a = 0; a < Math.PI * 3.2; a += 0.2) { const r = 1.5 + a * 1.05; const x = -3 + Math.cos(a) * r, y = -54 + Math.sin(a) * r * 0.85; a === 0 ? ctx.moveTo(x, y) : ctx.lineTo(x, y); }
    ctx.stroke();
    if (p > 0.85) { const fx = face * 4; circle(ctx, fx - 4.5, -51, 2.2, E.P.eye); circle(ctx, fx + 4.5, -51, 2.2, E.P.eye); }
    ctx.globalAlpha = 1;
  }
  ctx.restore();
};

// ---------- logs ----------
// golden = the beautiful log with the gold swirl; plain = grey-brown, no pattern. x,y centre, len, r radius, rot
E.log = (ctx, o) => {
  const P = E.P, L = o.L ?? 1, len = o.len || 120, r = o.r || 16;
  ctx.save(); ctx.translate(o.x, o.y); ctx.rotate(o.rot || 0);
  const body = o.golden ? E.lit(P.gold, L) : E.lit(P.log, L), dark = o.golden ? E.lit(P.goldD, L) : E.lit(P.logD, L);
  ctx.beginPath(); ctx.roundRect(-len / 2, -r, len, r * 2, r * 0.5); ctx.fillStyle = body; ctx.fill();
  ctx.fillStyle = dark; ctx.fillRect(-len / 2 + r * 0.5, r * 0.45, len - r, r * 0.5);
  if (o.golden) {
    ctx.strokeStyle = E.lit(P.goldL, Math.max(L, 0.5)); ctx.lineWidth = 2.6; ctx.lineCap = 'round';
    for (let k = -1; k <= 1; k++) { ctx.beginPath(); for (let x = -len / 2 + 10; x <= len / 2 - 14; x += 4) { const y = Math.sin(x * 0.09 + k * 2) * r * 0.35 + k * r * 0.4; x === -len / 2 + 10 ? ctx.moveTo(x, y) : ctx.lineTo(x, y); } ctx.stroke(); }
    ctx.beginPath(); for (let a = 0; a < Math.PI * 3; a += 0.2) { const rr = 1 + a * 1.1; const x = len * 0.12 + Math.cos(a) * rr, y = Math.sin(a) * rr * 0.8; a === 0 ? ctx.moveTo(x, y) : ctx.lineTo(x, y); } ctx.stroke();
  }
  ellipse(ctx, len / 2 - 2, 0, r * 0.45, r, o.golden ? E.lit(P.goldL, L * 0.9) : E.lit(P.logEnd, L));
  ellipse(ctx, len / 2 - 2, 0, r * 0.2, r * 0.45, dark);
  if (o.glint) { ctx.globalCompositeOperation = 'lighter'; const g = ctx.createRadialGradient(len * 0.1, -r * 0.3, 0, len * 0.1, -r * 0.3, r * 2.5); g.addColorStop(0, `rgba(255,220,120,${0.6 * o.glint})`); g.addColorStop(1, 'rgba(255,200,80,0)'); ctx.fillStyle = g; ctx.fillRect(-len, -r * 3, len * 2, r * 6); ctx.globalCompositeOperation = 'source-over'; }
  ctx.restore();
};

// ---------- sled (runners curl up at the front; dir = +1 front faces right) ----------
// o: x,y ground centre, s, dir, L, cargo(ctx) draws on the deck (deck top is y = -34 local), returns front rope point (world)
E.sled = (ctx, o) => {
  const P = E.P, L = o.L ?? 1, s = o.s || 1, d = o.dir || 1;
  ctx.save(); ctx.translate(o.x, o.y); ctx.scale(s * d, s);
  ellipse(ctx, 0, 2, 120, 10, 'rgba(5,8,20,0.4)');
  ctx.strokeStyle = E.lit(P.sledD, L); ctx.lineWidth = 7; ctx.lineCap = 'round';
  for (const yy of [0]) { ctx.beginPath(); ctx.moveTo(-110, yy - 4); ctx.lineTo(90, yy - 4); ctx.quadraticCurveTo(128, yy - 4, 124, -34); ctx.stroke(); }
  for (const x of [-80, -20, 40]) { ctx.beginPath(); ctx.moveTo(x, -4); ctx.lineTo(x, -26); ctx.stroke(); }
  ctx.beginPath(); ctx.roundRect(-118, -38, 220, 14, 5); ctx.fillStyle = E.lit(P.sled, L); ctx.fill();
  ctx.strokeStyle = E.lit(P.sledD, L); ctx.lineWidth = 2; for (const x of [-60, 0, 60]) { ctx.beginPath(); ctx.moveTo(x, -38); ctx.lineTo(x, -24); ctx.stroke(); }
  if (o.cargo) { ctx.save(); if (d < 0) ctx.scale(-1, 1); o.cargo(ctx); ctx.restore(); }
  ctx.restore();
  return [o.x + 124 * s * d, o.y - 34 * s];
};
// a pile of n dolls on a sled deck (local coords, deck top y=-38). Deterministic layout; grows upward like a heap.
E.dollPile = (ctx, n, L, seed = 7, face = 0) => {
  const R = E.rng(seed); const spots = [];
  const rows = [[-95, 95, 9], [-80, 80, 8], [-62, 62, 6], [-44, 44, 4], [-26, 26, 3]];
  let y = -38;
  for (const [a, b, k] of rows) { for (let i = 0; i < k; i++) spots.push([a + (b - a) * (k === 1 ? 0.5 : i / (k - 1)) + (R() - 0.5) * 8, y + (R() - 0.5) * 4, (R() - 0.5) * 0.5]); y -= 26; }
  for (let i = Math.min(n, spots.length) - 1; i >= 0; i--) { const [x, yy, tl] = spots[i]; E.doll(ctx, { x, y: yy, s: 0.72, tilt: tl, L, face, shadow: false }); }
};

// ---------- fire ----------
// size 0..1 (0 = out), t time; ash = draw the charred pit under it. Flames are layered tongues driven by sines (deterministic).
E.fireGlow = (ctx, x, y, size, t, reach = 1) => {
  if (size <= 0.01) return;
  const fl = 1 + Math.sin(t * 13) * 0.04 + Math.sin(t * 7.3) * 0.05;
  const R = (260 + 520 * size) * fl * reach;
  ctx.save(); ctx.globalCompositeOperation = 'lighter';
  const g = ctx.createRadialGradient(x, y - 40, 0, x, y - 40, R);
  g.addColorStop(0, `rgba(255,150,60,${0.42 * Math.min(1, size * 1.4)})`); g.addColorStop(0.35, `rgba(240,110,40,${0.16 * size + 0.04})`); g.addColorStop(1, 'rgba(200,80,20,0)');
  ctx.fillStyle = g; ctx.fillRect(x - R, y - 40 - R, R * 2, R * 2);
  ctx.restore();
};
E.fire = (ctx, x, y, size, t, o = {}) => {
  ctx.save(); ctx.translate(x, y);
  // pit: stones + charred sticks (skipped for a hand torch)
  const R = E.rng(3);
  const emb = o.embers ?? Math.min(1, size * 3);
  if (!o.torch) {
  for (let i = 0; i < 9; i++) { const a = Math.PI * (0.05 + i / 8 * 0.9); ellipse(ctx, Math.cos(a) * 88, -Math.sin(a) * 10 + 8, 18, 11, E.lit('#545a6b', 0.3 + size * 0.7)); }
  ellipse(ctx, 0, 4, 76, 16, '#17110e');
  ctx.strokeStyle = '#2a1d16'; ctx.lineWidth = 14; ctx.lineCap = 'round';
  ctx.beginPath(); ctx.moveTo(-50, 6); ctx.lineTo(34, -14); ctx.moveTo(50, 6); ctx.lineTo(-30, -12); ctx.stroke();
  // embers glowing in the ash
  }
  if (emb > 0 && !o.torch) for (let i = 0; i < 14; i++) { const ex = (R() - 0.5) * 110, ey = R() * 12 - 4, fl = 0.5 + 0.5 * Math.sin(t * (3 + R() * 4) + i); circle(ctx, ex, ey, 3 + R() * 3, `rgba(255,${90 + fl * 80 | 0},30,${emb * (0.35 + 0.6 * fl)})`); }
  if (size > 0.02) {
    const tongues = [[-34, 0.62, 1.7], [-14, 0.9, 2.3], [6, 1.0, 1.9], [26, 0.78, 2.7], [42, 0.5, 2.1]];
    const layers = [['#c8400c', 1.0, 1.0], ['#ff7a1a', 0.78, 0.82], ['#ffb347', 0.55, 0.62], ['#fff1c2', 0.3, 0.38]];
    ctx.globalCompositeOperation = 'source-over';
    for (const [col, hk, wk] of layers) {
      ctx.fillStyle = col;
      for (const [bx, hh, f] of tongues) {
        const h = 170 * size * hh * hk * (0.85 + 0.15 * Math.sin(t * f * 4 + bx));
        const w = 30 * (0.5 + size * 0.6) * wk; const sway = Math.sin(t * f * 3 + bx * 0.1) * 10 * size;
        const cx = bx * (0.55 + size * 0.5);
        ctx.beginPath(); ctx.moveTo(cx - w, -2); ctx.quadraticCurveTo(cx - w * 1.1, -h * 0.45, cx + sway, -h); ctx.quadraticCurveTo(cx + w * 1.1, -h * 0.45, cx + w, -2); ctx.closePath(); ctx.fill();
      }
    }
    // sparks
    for (let i = 0; i < 8; i++) { const life = (t * 0.7 + i * 0.137) % 1; const sx = Math.sin(i * 12.9 + life * 5) * 30 * size + (i - 4) * 6, sy = -40 - life * 260 * size; circle(ctx, sx, sy, 2.4 * (1 - life), `rgba(255,190,90,${(1 - life) * size})`); }
  }
  ctx.restore();
};
// smoke wisp rising from a dead fire
E.smoke = (ctx, x, y, t, a) => { ctx.save(); for (let i = 0; i < 6; i++) { const k = ((t * 0.25 + i / 6) % 1); ellipse(ctx, x + Math.sin(k * 6 + i) * 20 * k, y - k * 260, 14 + k * 30, 10 + k * 22, `rgba(150,160,185,${a * 0.22 * (1 - k)})`); } ctx.restore(); };

// ---------- environment ----------
E.sky = (ctx, top, bot, y0 = 0, y1 = H) => { const g = ctx.createLinearGradient(0, y0, 0, y1); g.addColorStop(0, top); g.addColorStop(1, bot); ctx.fillStyle = g; ctx.fillRect(-2000, y0 - 3000, W + 4000, y1 - y0 + 6000); };
E.stars = (ctx, n, y1, a = 0.7, t = 0) => { const R = E.rng(11); for (let i = 0; i < n; i++) { const x = R() * W * 1.6 - W * 0.3, y = R() * y1; circle(ctx, x, y, R() * 1.8 + 0.6, `rgba(220,230,255,${a * (0.5 + 0.5 * Math.sin(t * 2 + i))})`); } };
// pine silhouette
E.pine = (ctx, x, y, h, col, snowCol) => {
  const w = h * 0.36; ctx.fillStyle = col;
  ctx.fillRect(x - h * 0.03, y - h * 0.12, h * 0.06, h * 0.14);
  for (let i = 0; i < 4; i++) { const yy = y - h * 0.1 - i * h * 0.22, ww = w * (1 - i * 0.2); blob(ctx, [[x - ww, yy], [x, yy - h * 0.34], [x + ww, yy]]); ctx.fill(); if (snowCol) { ctx.fillStyle = snowCol; blob(ctx, [[x - ww * 0.55, yy - h * 0.15], [x, yy - h * 0.34], [x + ww * 0.55, yy - h * 0.15], [x, yy - h * 0.22]]); ctx.fill(); ctx.fillStyle = col; } }
};
// a row of pines along a horizon; seed fixes the layout
E.treeline = (ctx, y, hMin, hMax, col, seed, gap = 60, snowCol = null, x0 = -600, x1 = W + 600) => { const R = E.rng(seed); for (let x = x0; x < x1; x += gap * (0.6 + R() * 0.8)) E.pine(ctx, x, y + R() * 16, hMin + R() * (hMax - hMin), col, snowCol); };
// snowy ground with gentle rolls
E.ground = (ctx, y, col, amp = 14, seed = 1, hi = null) => {
  ctx.beginPath(); ctx.moveTo(-2000, H + 3000); for (let x = -2000; x <= W + 2000; x += 40) ctx.lineTo(x, y + Math.sin(x * 0.004 + seed) * amp + Math.sin(x * 0.011 + seed * 3) * amp * 0.4);
  ctx.lineTo(W + 2000, H + 3000); ctx.closePath(); ctx.fillStyle = col; ctx.fill();
  if (hi) { ctx.save(); ctx.clip(); const g = ctx.createLinearGradient(0, y - 20, 0, y + 120); g.addColorStop(0, hi); g.addColorStop(1, E.rgba(col, 0)); ctx.fillStyle = g; ctx.fillRect(-2000, y - 40, W + 4000, 200); ctx.restore(); }
};
// far village lights: a cluster of warm dots with soft glow (and tiny roofs when near)
E.village = (ctx, x, y, s, t, near = 0, roofCol = '#0a1022') => {
  const R = E.rng(21);
  if (near > 0) { ctx.fillStyle = roofCol; for (let i = 0; i < 7; i++) { const hx = x + (i - 3) * 46 * s + (R() - 0.5) * 14 * s, hw = (22 + R() * 14) * s, hh = (18 + R() * 12) * s; ctx.fillRect(hx - hw, y - hh, hw * 2, hh + 6 * s); blob(ctx, [[hx - hw - 6 * s, y - hh], [hx, y - hh - hw * 0.8], [hx + hw + 6 * s, y - hh]]); ctx.fill(); } }
  const R2 = E.rng(22);
  ctx.save(); ctx.globalCompositeOperation = 'lighter';
  for (let i = 0; i < 9; i++) {
    const lx = x + (R2() - 0.5) * 300 * s, ly = y - R2() * 26 * s, fl = 0.85 + 0.15 * Math.sin(t * 3 + i * 2);
    const g = ctx.createRadialGradient(lx, ly, 0, lx, ly, 26 * s); g.addColorStop(0, `rgba(255,190,100,${0.9 * fl})`); g.addColorStop(0.25, `rgba(255,150,60,${0.35 * fl})`); g.addColorStop(1, 'rgba(255,120,40,0)');
    ctx.fillStyle = g; ctx.fillRect(lx - 26 * s, ly - 26 * s, 52 * s, 52 * s);
    circle(ctx, lx, ly, Math.max(1.6, 3.2 * s), `rgba(255,225,160,${fl})`);
  }
  ctx.restore();
};
// falling snow in screen space; wind = horizontal drift, n flakes, heavy = blizzard streaks
E.snow = (ctx, t, o = {}) => {
  const n = o.n || 120, wind = o.wind ?? 0.15, sp = o.speed || 90, R = E.rng(o.seed || 5), a = o.a ?? 0.85;
  ctx.save(); ctx.setTransform(1, 0, 0, 1, 0, 0);
  for (let i = 0; i < n; i++) {
    const z = 0.4 + R() * 1.2, x0 = R() * (W + 400), y0 = R() * (H + 200), ph = R() * 6.28;
    const y = (y0 + t * sp * z) % (H + 200) - 100, x = ((x0 + t * sp * z * wind * 3 + Math.sin(t * 1.3 + ph) * 18) % (W + 400) + W + 400) % (W + 400) - 200;
    if (o.heavy) { ctx.strokeStyle = `rgba(230,238,255,${a * 0.55 * z / 1.6})`; ctx.lineWidth = 2.2 * z; ctx.beginPath(); ctx.moveTo(x, y); ctx.lineTo(x - wind * 40 * z, y - 18 * z); ctx.stroke(); }
    else circle(ctx, x, y, 2.4 * z, `rgba(235,242,255,${a * (0.35 + z * 0.35)})`);
  }
  ctx.restore();
};
E.vignette = (ctx, k = 0.6, cx = W / 2, cy = H / 2, r0 = 300, r1 = 1200, col = '3,5,14') => { ctx.save(); ctx.setTransform(1, 0, 0, 1, 0, 0); const g = ctx.createRadialGradient(cx, cy, r0, cx, cy, r1); g.addColorStop(0, `rgba(${col},0)`); g.addColorStop(1, `rgba(${col},${k})`); ctx.fillStyle = g; ctx.fillRect(0, 0, W, H); ctx.restore(); };
E.breath = (ctx, x, y, t, dir = 1, a = 1) => { for (let i = 0; i < 3; i++) { const k = ((t * 0.55 + i * 0.33) % 1); if (k > 0.75) continue; ellipse(ctx, x + dir * (8 + k * 70), y - k * 30, 8 + k * 26, 6 + k * 16, `rgba(225,235,255,${a * 0.38 * (1 - k / 0.75)})`); } };
E.cam = (ctx, cx, cy, z) => ctx.setTransform(z, 0, 0, z, W / 2 - cx * z, H / 2 - cy * z);
// on-screen Thai text (Kanit 700 from assets/fonts), white with a dark outline
E.text = (ctx, str, y, size = 78, a = 1, x = W / 2) => {
  if (a <= 0) return; ctx.save(); ctx.setTransform(1, 0, 0, 1, 0, 0); ctx.globalAlpha = a;
  ctx.font = `700 ${size}px Kanit`; ctx.textAlign = 'center'; ctx.textBaseline = 'middle'; ctx.lineJoin = 'round';
  const lines = str.split('\n');
  lines.forEach((ln, i) => { const yy = y + (i - (lines.length - 1) / 2) * size * 1.3; ctx.lineWidth = size * 0.2; ctx.strokeStyle = 'rgba(8,10,24,0.95)'; ctx.strokeText(ln, x, yy); ctx.fillStyle = '#fffaf0'; ctx.fillText(ln, x, yy); });
  ctx.restore();
};
window.E = E; window.W = W; window.H = H;
