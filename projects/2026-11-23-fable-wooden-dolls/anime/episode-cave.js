// Episode v2: ตุ๊กตาไม้ในถ้ำมืด (script-th.json, Thai narration). Shot times come from the voice (timeline-th.js: beats + word cues).
// Rule of the world: light = life. 5 sticks found a day, the fire needs 3, 2 are extra. 1 doll = 2 extra sticks.
const EP = { duration: TL.duration };
const C = TL.cues, B = Object.fromEntries(TL.beats.map(b => [b.id, b]));
const { traveler, doll, log, sled, fire, fireGlow, dollPile, cam, text, seg, lerp, clamp, ease } = E;
const FX = 640, FY = 1330, TX = 390, TY = 1342, TS = 1.15, PILE = [880, 1352];
const SLOTS = (() => { const out = [[515, 1384, -0.8]]; for (let i = 1; i < 31; i++) { const f = (i * 0.618034) % 1, a = -0.62 * Math.PI + 1.24 * Math.PI * f, ring = i % 3; const rx = 205 + ring * 45, ry = 58 + ring * 20; const x = FX + Math.cos(a) * rx, y = FY + 4 + Math.sin(a) * ry; out.push([x, y, x > FX ? -0.6 : 0.6]); } return out; })();

// ---------- cave pieces ----------
function rocks(ctx, seed, y0, y1, col, n, x0 = -400, x1 = 1500, size = 1) {
  const R = E.rng(seed); ctx.fillStyle = col;
  for (let i = 0; i < n; i++) { const x = x0 + R() * (x1 - x0), y = y0 + R() * (y1 - y0), r = (40 + R() * 120) * size; ctx.beginPath(); for (let k = 0; k < 9; k++) { const a = k / 9 * Math.PI * 2, rr = r * (0.75 + R() * 0.35); k ? ctx.lineTo(x + Math.cos(a) * rr, y + Math.sin(a) * rr * 0.7) : ctx.moveTo(x + Math.cos(a) * rr, y + Math.sin(a) * rr * 0.7); } ctx.closePath(); ctx.fill(); }
}
function stalactites(ctx, seed, y, x0, x1, col, scale = 1) { const R = E.rng(seed); ctx.fillStyle = col; for (let x = x0; x < x1; x += 40 + R() * 90) { const h = (60 + R() * 300) * scale, w = (16 + R() * 34) * scale; ctx.beginPath(); ctx.moveTo(x - w, y); ctx.quadraticCurveTo(x - w * 0.3, y + h * 0.6, x, y + h); ctx.quadraticCurveTo(x + w * 0.3, y + h * 0.6, x + w, y); ctx.fill(); } }
// back wall + floor of a cave chamber; floorY = where the floor starts
function caveRoom(ctx, floorY, seed = 1, scroll = 0) {
  ctx.fillStyle = '#0a0809'; ctx.fillRect(-2000, -2000, 5200, 6000);
  ctx.save(); ctx.translate(-scroll * 0.4, 0);
  const g = ctx.createLinearGradient(0, floorY - 900, 0, floorY); g.addColorStop(0, '#120f0e'); g.addColorStop(1, '#241e19'); ctx.fillStyle = g; ctx.fillRect(-2000, floorY - 1600, 6000, 1600);
  rocks(ctx, seed, floorY - 800, floorY - 60, '#2c251f', 26, -600, 2600);
  rocks(ctx, seed + 1, floorY - 700, floorY - 100, '#1a1613', 18, -600, 2600, 0.8);
  stalactites(ctx, seed + 2, floorY - 1000, -800, 2800, '#1d1814');
  ctx.restore();
  ctx.save(); ctx.translate(-scroll, 0);
  ctx.fillStyle = '#2f2821'; ctx.beginPath(); ctx.moveTo(-2000, 4000); for (let x = -2000; x <= 4000; x += 50) ctx.lineTo(x, floorY + Math.sin(x * 0.006 + seed) * 10); ctx.lineTo(4000, 4000); ctx.fill();
  ctx.fillStyle = '#3a3129'; for (let x = -1800; x < 3800; x += 140) { ellipse(ctx, x + (x * 7 % 60), floorY + 40 + (x * 13 % 90), 30 + (x % 40), 8, '#3a3129'); }
  ctx.restore();
}
// darkness: black everywhere except around the lights. lights = [[x, y, r], ...] in world coords (current transform)
function darkness(ctx, lights, a = 0.965) {
  const m = darkness.c || (darkness.c = document.createElement('canvas')); m.width = W; m.height = H; const mc = m.getContext('2d');
  mc.setTransform(1, 0, 0, 1, 0, 0); mc.fillStyle = `rgba(1,1,3,${a})`; mc.fillRect(0, 0, W, H);
  mc.setTransform(ctx.getTransform()); mc.globalCompositeOperation = 'destination-out';
  for (const [x, y, r, k = 1] of lights) { if (r <= 0) continue; const g = mc.createRadialGradient(x, y, r * 0.08, x, y, r); g.addColorStop(0, `rgba(0,0,0,${k})`); g.addColorStop(0.5, `rgba(0,0,0,${0.78 * k})`); g.addColorStop(1, 'rgba(0,0,0,0)'); mc.fillStyle = g; mc.fillRect(x - r, y - r, r * 2, r * 2); }
  ctx.save(); ctx.setTransform(1, 0, 0, 1, 0, 0); ctx.drawImage(m, 0, 0); ctx.restore();
}
// eyes watching from the dark (screen coords); they blink and stay out of the light
const EYES = [[110, 980, 1], [960, 1120, 0.85], [190, 1660, 0.8], [990, 1560, 0.7], [860, 760, 0.6], [80, 1340, 0.75]];
function eyes(ctx, t, a = 1, near = 0) {
  if (a <= 0) return; ctx.save(); ctx.setTransform(1, 0, 0, 1, 0, 0);
  EYES.forEach(([x, y, s], i) => { const blink = ((t * 0.4 + i * 0.37) % 1) < 0.05 ? 0.15 : 1; const xx = lerp(x, 540, near * 0.25), yy = lerp(y, 1300, near * 0.2), ss = s * (1 + near * 0.6); for (const d of [-1, 1]) ellipse(ctx, xx + d * 15 * ss, yy, 7 * ss, 4 * ss * blink, `rgba(225,235,255,${0.85 * a})`); });
  ctx.restore();
}
const toScreen = (ctx, x, y) => { const m = ctx.getTransform(); return [m.a * x + m.c * y + m.e, m.b * x + m.d * y + m.f]; };
const fireR = f => 230 + 700 * f;

// rest scene: the cave "camp" (same layout every night). o: fire, dolls, pile (# sticks), trav, extra(ctx), after(ctx), eyesA, eyesNear, exitGlow
function rest(ctx, t, o) {
  const f = o.fire ?? 0.7;
  caveRoom(ctx, 1190, 3);
  if (o.exit) exitLight(ctx, o.exit[0], o.exit[1], o.exit[2] || 1, t);
  const L = 0.3 + 0.7 * Math.min(1, f * 1.4);
  const n = o.dolls || 0, back = [], front = [];
  for (let i = 0; i < Math.min(n, SLOTS.length); i++) (SLOTS[i][1] < FY ? back : front).push(SLOTS[i]);
  for (const [x, y, fc] of back) doll(ctx, { x, y, s: 1, face: fc, L });
  for (let i = 0; i < (o.pile || 0); i++) log(ctx, { x: PILE[0] + (i % 2) * 14, y: PILE[1] - 6 - i * 22, len: 100, r: 11, L, rot: i % 2 ? 0.05 : -0.04 });
  if (o.extra) o.extra(ctx, L);
  fire(ctx, FX, FY, f, t, { embers: o.embers });
  if (o.trav) traveler(ctx, Object.assign({ x: TX, y: TY, s: TS, pose: 'sit', face: 0.6, t, L: clamp(L) }, o.trav));
  for (const [x, y, fc] of front) doll(ctx, { x, y, s: 1, face: fc, L });
  if (o.after) o.after(ctx, L);
  darkness(ctx, [[FX, FY - 60, f > 0.01 ? fireR(f) * (1 + Math.sin(t * 9) * 0.02) : 0], ...(o.lights || [])], o.darkA ?? 0.965);
  fireGlow(ctx, FX, FY, f * 0.8, t, 0.8);
  eyes(ctx, t, o.eyesA ?? 0.8, o.eyesNear || 0);
}
// cold daylight at the far exit (the goal)
function exitLight(ctx, x, y, s, t) {
  ctx.save(); ctx.globalCompositeOperation = 'lighter';
  const g = ctx.createRadialGradient(x, y, 0, x, y, 190 * s); g.addColorStop(0, 'rgba(200,220,255,0.75)'); g.addColorStop(0.3, 'rgba(150,180,240,0.3)'); g.addColorStop(1, 'rgba(100,130,220,0)'); ctx.fillStyle = g; ctx.fillRect(x - 200 * s, y - 200 * s, 400 * s, 400 * s);
  ctx.restore(); ellipse(ctx, x, y, 22 * s, 30 * s, 'rgba(235,242,255,0.95)');
}
// walking scene: side view through the tunnel. o: x, scroll, dolls on sled, pace, mood, lean, flood (0..1), exit [x,y,s], items(ctx)
function walk(ctx, t, o) {
  const floor = 1560, s = 1.05, x = o.x ?? 600;
  caveRoom(ctx, floor, 7, o.scroll || 0);
  if (o.exit) exitLight(ctx, o.exit[0], o.exit[1], o.exit[2] || 0.7, t);
  if (o.items) o.items(ctx);
  const L = 0.85, ph = (o.scroll || 0) * 0.05;
  const crouch = o.crouch || 0;
  const fp = sled(ctx, { x: x - 300, y: floor + 6, s: 0.95, dir: 1, L: 0.75, cargo: o.cargo });
  const pose = crouch > 0.5 ? 'crouch' : 'walk';
  const hands = crouch > 0.5 ? { l: [-40, -70], r: o.reach || [80, -30] } : { l: [-40, -96], r: [62, -168] };
  traveler(ctx, { x, y: floor, s, pose, face: o.face ?? 0.6, phase: ph, lean: o.lean || 0, t, L, mood: o.mood || 'neutral', hands, scarf: o.scarf, over: o.held });
  ctx.strokeStyle = '#6b5a47'; ctx.lineWidth = 3; ctx.beginPath(); ctx.moveTo(fp[0], fp[1]); ctx.lineTo(x - 36 * s, floor - 96 * s); ctx.stroke();
  // torch: in the raised hand while walking, stuck in the ground while crouching
  const tp = crouch > 0.5 ? [x + 150, floor - 190] : [x + 70 * s, floor - 250 * s];
  ctx.strokeStyle = '#4a3322'; ctx.lineWidth = 9; ctx.lineCap = 'round'; ctx.beginPath();
  if (crouch > 0.5) { ctx.moveTo(x + 140, floor + 4); ctx.lineTo(tp[0], tp[1]); } else { ctx.moveTo(x + 62 * s, floor - 168 * s); ctx.lineTo(tp[0], tp[1]); }
  ctx.stroke(); ellipse(ctx, tp[0], tp[1] + 4, 16, 9, '#2a1a10');
  const tf = o.torch ?? 0.36; fire(ctx, tp[0], tp[1] + 6, tf, t, { embers: 0, torch: true });
  if (o.flood) { ctx.save(); ctx.fillStyle = `rgba(40,70,110,${0.55 * o.flood})`; ctx.fillRect(-2000, floor - 14, 5000, 600); ctx.strokeStyle = `rgba(150,190,240,${0.4 * o.flood})`; ctx.lineWidth = 3; for (let i = 0; i < 12; i++) { const yy = floor - 6 + i * 26, ox = (t * 40 + i * 70) % 160; ctx.beginPath(); for (let xx = -200 + ox; xx < 1300; xx += 160) { ctx.moveTo(xx, yy); ctx.lineTo(xx + 60, yy); } ctx.stroke(); } ctx.restore(); }
  darkness(ctx, [[tp[0], tp[1], fireR(tf) * 1.15 * (1 + Math.sin(t * 9) * 0.02)], ...(o.exit ? [[o.exit[0], o.exit[1], 260 * (o.exit[2] || 0.7), 0.9]] : [])]);
  fireGlow(ctx, tp[0], tp[1] + 40, tf, t, 0.6);
  eyes(ctx, t, 0.8);
}
const heldDoll = (hx, hy, L, face = -0.6) => c => doll(c, { x: hx + 6, y: hy + 10, s: 1.35, face, L: 1, shadow: false });
// the hook / last night moment: reach the doll to the fire, hesitate, hug it back
function hook(ctx, t, reach, back = 0, fireSize = 0.24, o = {}) {
  cam(ctx, 520, 1180, 1.9);
  const k = reach * (1 - back), hug = back > 0 ? seg(back, 0.3, 1) : 0;
  const hand = [lerp(60, 180, k), lerp(-110, -52, k)];
  const hR = [lerp(hand[0], 22, hug), lerp(hand[1], -84, hug)], hL = [lerp(-10, -24, hug), lerp(-70, -86, hug)];
  rest(ctx, t, Object.assign({ fire: fireSize + Math.sin(t * 3) * 0.02, dolls: 30, pile: 0, eyesNear: 0.5, lights: [[TX + hR[0] * TS, TY + hR[1] * TS - 30, 260, 0.9]], trav: { mood: hug > 0.6 ? 'shut' : 'worry', face: lerp(0.6, 0.15, hug), hands: { l: hL, r: hR }, shiver: 0.4, over: hug > 0.6 ? null : heldDoll(hR[0], hR[1], 0.6), front: hug > 0.6 ? c => doll(c, { x: 0, y: -64, s: 1, face: 0, L: 0.5, shadow: false }) : null } }, o));
}

// ---------- HUD: sticks saved + dolls (top of the frame) ----------
const savedAt = t => (t >= C.two && t < C.weave + 1.6) ? 2 : 0;
const dollsAt = t => t < C.weave + 1.6 ? 0 : t < B.B6.t0 ? 1 : t < B.B6.t0 + 1.5 ? 7 : t < B.B6.t0 + 3.0 ? 15 : 30;
function hud(ctx, t) {
  if (t < C.two - 0.2 || t >= B.B8.t0) return;
  const a = Math.min(1, (t - C.two + 0.2) / 0.3, (B.B8.t0 - t) / 0.3);
  ctx.save(); ctx.setTransform(1, 0, 0, 1, 0, 0); ctx.globalAlpha = a;
  const items = [['ไม้ที่เก็บไว้', savedAt(t), 'log', [C.two, C.weave + 1.6]], ['ตุ๊กตา', dollsAt(t), 'doll', [C.weave + 1.6, B.B6.t0, B.B6.t0 + 1.5, B.B6.t0 + 3.0]]];
  items.forEach(([label, n, icon, changes], i) => {
    const x = 70 + i * 490, y = 150, w = 450, h = 96;
    const pop = Math.max(0, ...changes.map(c => (t >= c && t < c + 0.4) ? 1 - (t - c) / 0.4 : 0));
    ctx.beginPath(); ctx.roundRect(x, y, w, h, 48); ctx.fillStyle = 'rgba(8,8,14,0.72)'; ctx.fill(); ctx.strokeStyle = 'rgba(255,255,255,0.18)'; ctx.lineWidth = 3; ctx.stroke();
    if (icon === 'log') log(ctx, { x: x + 62, y: y + 50, len: 64, r: 13, L: 1, rot: -0.2 }); else doll(ctx, { x: x + 62, y: y + 84, s: 1.05, L: 1, shadow: false });
    ctx.font = '700 44px Kanit'; ctx.textBaseline = 'middle'; ctx.fillStyle = '#f3efe6'; ctx.textAlign = 'left'; ctx.fillText(label, x + 112, y + h / 2 + 2);
    ctx.save(); ctx.translate(x + w - 62, y + h / 2); ctx.scale(1 + pop * 0.5, 1 + pop * 0.5);
    ctx.font = '900 60px Kanit'; ctx.textAlign = 'center'; ctx.fillStyle = icon === 'log' ? (n > 0 ? '#9be59b' : '#ff8a7a') : '#ffd36b'; ctx.fillText(String(n), 0, 4); ctx.restore();
  });
  ctx.restore();
}

// ---------- shots ----------
const S = [];
const shot = (id, t0, t1, fn) => S.push({ id, t0, t1, fn });

// B1 hook: last-night moment, doll held toward the dying fire
shot('B1', 0, B.B1.t1, (ctx, t, lt) => hook(ctx, t, 0.15 + 0.85 * (seg(lt, 1.2, 2.8) - 0.45 * seg(lt, 4.4, 5.6))));

// B2 goal: a little traveler in a very dark cave walks toward the far light of the exit
shot('B2', B.B2.t0, B.B2.t1, (ctx, t, lt) => {
  cam(ctx, 560, 1360, lerp(1.2, 1.28, lt / 9));
  walk(ctx, t, { x: 520, scroll: lt * 60, exit: [900, 1180, 0.55 + 0.25 * seg(t, C.exitfar - 0.5, C.exitfar + 0.5)] });
  if (t > C.exitfar - 0.2) { const a = seg(t, C.exitfar - 0.2, C.exitfar + 0.3); const [sx, sy] = toScreen(ctx, 900, 1180); ctx.save(); ctx.setTransform(1, 0, 0, 1, 0, 0); text(ctx, 'ทางออก', sy - 120, 60, a, sx - 20); ctx.strokeStyle = `rgba(255,255,255,${a})`; ctx.lineWidth = 6; ctx.lineCap = 'round'; ctx.beginPath(); ctx.moveTo(sx - 20, sy - 80); ctx.lineTo(sx - 4, sy - 40); ctx.moveTo(sx - 18, sy - 52); ctx.lineTo(sx - 4, sy - 40); ctx.lineTo(sx + 4, sy - 56); ctx.stroke(); ctx.restore(); }
});

// B3 the rule. a) no light = can't walk (the torch nearly dies)  b) picks up 5 sticks  c) 3 into the fire, 2 left over
const PICK0 = C.five - 2.6;
shot('B3a', B.B3.t0, PICK0, (ctx, t, lt) => {
  cam(ctx, 560, 1370, 1.3);
  const dim = seg(lt, 1.2, 2.2) * (1 - seg(lt, 3.6, 4.4));
  walk(ctx, t, { x: 540, scroll: 540 + lt * 30 * (1 - dim), torch: 0.36 - 0.33 * dim, mood: dim > 0.5 ? 'worry' : 'neutral' });
  eyes(ctx, t, dim, dim);
});
shot('B3b', PICK0, C.three - 0.3, (ctx, t, lt) => {
  cam(ctx, 600, 1400, 1.35);
  const n = Math.min(5, Math.floor((t - PICK0) / 0.52) + 1), up = Math.sin(((t - PICK0) % 0.52) / 0.52 * Math.PI);
  const sticks = [[-70, -50], [0, -50], [70, -50], [-35, -72], [35, -72]];
  walk(ctx, t, { x: 560, scroll: 700, crouch: 1, reach: [80, -20 - up * 30], held: n < 5 ? c => log(c, { x: 76, y: -16 - up * 30, len: 80, r: 10, L: 0.9, rot: -0.2 }) : null,
    cargo: c => { for (let i = 0; i < n; i++) log(c, { x: sticks[i][0], y: sticks[i][1], len: 80, r: 10, L: 0.85 }); },
    items: c => { for (let i = n; i < 5; i++) log(c, { x: 700 + i * 50, y: 1580 - (i % 2) * 12, len: 78, r: 9, L: 0.8, rot: 0.3 * (i % 2 ? 1 : -1) }); } });
});
shot('B3c', C.three - 0.3, B.B3.t1, (ctx, t, lt) => {
  cam(ctx, 650, 1200, 1.4);
  const tosses = [C.three - 0.2, C.three + 0.25, C.three + 0.7];
  let f = 0.18; tosses.forEach(s => f += 0.15 * seg(t, s + 0.35, s + 0.7));
  const flying = tosses.map(s => clamp((t - s) / 0.45)).filter(k => k > 0 && k < 1);
  const inPile = 2 + 3 - tosses.filter(s => t >= s).length;
  rest(ctx, t, { fire: f, dolls: 0, pile: inPile, trav: { mood: f > 0.55 ? 'smile' : 'neutral', face: 0.7, hands: { l: [-20, -62], r: flying.length ? [120, -70] : [62, -40] } },
    after: () => flying.forEach(k => log(ctx, { x: lerp(PILE[0], FX, k), y: lerp(PILE[1] - 60, FY - 20, k) - Math.sin(k * Math.PI) * 120, len: 100, r: 11, L: 0.9, rot: k * 2 })),
    lights: [[PILE[0], PILE[1] - 40, t > C.two ? 260 : 0, 0.8]] });
});

// B4 lonely -> weaves the 2 extra sticks into a doll (saved 2 -> 0, dolls 0 -> 1)
shot('B4a', B.B4.t0, C.weave - 0.2, (ctx, t, lt) => {
  cam(ctx, 600, 1180, lerp(1.2, 0.78, ease(seg(t, C.lonely - 0.3, C.lonely + 1.8))));
  rest(ctx, t, { fire: 0.6, pile: 2, trav: { face: 0.3, mood: 'sad', hands: { l: [-30, -50], r: [40, -48] } }, eyesA: 1 });
});
shot('B4b', C.weave - 0.2, B.B4.t1, (ctx, t, lt) => {
  const p = seg(t, C.weave, C.weave + 1.5), placed = t > C.weave + 1.9;
  cam(ctx, placed ? 560 : 500, placed ? 1220 : 1185, placed ? 1.55 : 2.1);
  rest(ctx, t, { fire: 0.6, pile: p > 0.05 ? 0 : 2, dolls: placed ? 1 : 0, trav: { face: 0.45, mood: placed || p >= 1 ? 'smile' : 'neutral', hands: placed ? { l: [-30, -50], r: [40, -48] } : { l: [44, -62 + Math.sin(t * 9) * 4], r: [102, -62 - Math.sin(t * 9) * 4] }, over: placed ? null : c => { if (p < 0.3) { log(c, { x: 74, y: -70, len: 80, r: 10, L: 1, rot: 0.6 }); log(c, { x: 74, y: -60, len: 80, r: 10, L: 1, rot: -0.5 }); } doll(c, { x: 74, y: -46, s: 1.15, p, face: -0.5, L: 1, shadow: false }); } } });
});

// B5 flood: no sticks, nothing saved -> tiny fire, nearly dies -> lucky crate -> "it's fine"
shot('B5a', B.B5.t0, C.tiny - 0.6, (ctx, t, lt) => {
  cam(ctx, 560, 1370, 1.28);
  const search = t > C.none - 1.2 && t < C.none + 1.2;
  walk(ctx, t, { x: 560, scroll: 1400 + lt * 40, flood: seg(lt, 0, 1), crouch: search ? 1 : 0, mood: 'worry', reach: [90, -10 + Math.sin(t * 6) * 10],
    cargo: c => doll(c, { x: -20, y: -38, s: 0.95, face: 0.6, L: 0.8, shadow: false }) });
});
shot('B5b', C.tiny - 0.6, C.lucky - 0.5, (ctx, t, lt) => {
  cam(ctx, 480, 1170, 1.8);
  rest(ctx, t, { fire: 0.12 + Math.sin(t * 5) * 0.02, pile: 0, dolls: 0, eyesNear: 0.9, eyesA: 1, trav: { mood: 'shut', face: 0.2, shiver: 1, hands: { l: [-24, -86], r: [24, -84] }, front: c => doll(c, { x: 0, y: -64, s: 1, face: 0, L: 0.45, shadow: false }) } });
});
shot('B5c', C.lucky - 0.5, B.B5.t1, (ctx, t, lt) => {
  cam(ctx, 620, 1390, 1.28);
  const relief = seg(t, C.lucky, C.lucky + 0.6), take = seg(t, C.crate + 1.0, C.fine - 0.3);
  walk(ctx, t, { x: 470, scroll: 2400, mood: relief > 0.5 ? 'relief' : 'worry', face: 0.6, cargo: c => { doll(c, { x: -60, y: -38, s: 0.95, face: 0.6, L: 0.8, shadow: false }); for (let i = 0; i < Math.round(take * 5); i++) log(c, { x: 10 + (i % 3) * 36, y: -50 - Math.floor(i / 3) * 22, len: 70, r: 9, L: 0.85 }); },
    items: c => { // an old broken crate found on the path
      c.save(); c.translate(780, 1560); c.fillStyle = '#8a6a48'; c.strokeStyle = '#4a3422'; c.lineWidth = 5;
      for (let i = 0; i < Math.round(5 - take * 5); i++) { c.save(); c.rotate((i - 2) * 0.12); c.fillRect(-110 + i * 10, -30 - i * 24, 200, 20); c.strokeRect(-110 + i * 10, -30 - i * 24, 200, 20); c.restore(); }
      c.restore(); } });
});

// B6 day after day: same camera, more dolls, (HUD counts) -> heavy sled, slow, exit still far
const N1 = B.B6.t0 + 1.5, N2 = B.B6.t0 + 3.0, WALK6 = C.heavy - 0.35;
const NIGHTS = [[B.B6.t0, N1, 7, 0.55], [N1, N2, 15, 0.5], [N2, WALK6, 30, 0.45]];
NIGHTS.forEach(([a, b, n, f], i) => shot('B6' + 'abc'[i], a, b, (ctx, t, lt) => { cam(ctx, 620, 1200, 1.4); rest(ctx, t, { fire: f, dolls: n, pile: 0, trav: { face: 0.6, mood: i === 2 ? 'worry' : 'neutral', hands: { l: [-20, -54], r: [44, -46] } } }); }));
shot('B6d', WALK6, B.B6.t1, (ctx, t, lt) => {
  cam(ctx, 560, 1370, 1.2);
  walk(ctx, t, { x: 640, scroll: 3000 + lt * 8, lean: 0.38, mood: 'worry', exit: [930, 1150, 0.5], cargo: c => dollPile(c, 30, 0.8, 7, 0.5) });
});

// B7 last night: wood runs out, reaches the doll to the fire, can't do it, hugs it, the fire dies, darkness (no body)
shot('B7a', B.B7.t0, C.couldnt - 0.1, (ctx, t, lt) => hook(ctx, t, 0.1 + 0.9 * seg(t, C.burn - 0.1, C.burn + 1.0), 0, 0.22));
shot('B7b', C.couldnt - 0.1, B.B7.t1, (ctx, t, lt) => {
  const f = 0.2 * (1 - seg(t, C.out - 0.3, C.out + 0.6));
  hook(ctx, t, 1, seg(t, C.couldnt, C.couldnt + 0.9), f, { embers: 0.8 * (1 - seg(t, C.out, C.out + 1.8)), eyesNear: lerp(0.5, 1, seg(t, C.out, C.out + 2)), eyesA: 1 });
});

// B8 the answer: 30 dolls = 60 sticks -> camera goes around the bend: the exit was right there
shot('B8a', B.B8.t0, C.exit - 0.4, (ctx, t, lt) => {
  ctx.fillStyle = '#020203'; ctx.fillRect(0, 0, W, H);
  const a = seg(t, C.thirty - 0.4, C.thirty), b = seg(t, C.sixty - 0.3, C.sixty + 0.5);
  // grid: 30 dolls that split into 60 sticks
  for (let i = 0; i < 30; i++) {
    const col = i % 6, row = Math.floor(i / 6), x = 240 + col * 120, y = 820 + row * 150;
    if (b < 1) { ctx.globalAlpha = a * (1 - b); doll(ctx, { x, y, s: 1.3, L: 0.9, face: 0 }); ctx.globalAlpha = 1; }
    if (b > 0) { ctx.globalAlpha = b; log(ctx, { x: x - 24, y: y - 34 - (1 - b) * 20, len: 70, r: 11, L: 0.9, rot: -0.3 }); log(ctx, { x: x + 24, y: y - 34 + (1 - b) * 20, len: 70, r: 11, L: 0.9, rot: 0.3 }); ctx.globalAlpha = 1; }
  }
  text(ctx, 'ตุ๊กตา 30 ตัว', 430, 92, a);
  text(ctx, '= ไม้ 60 ท่อน', 560, 92, seg(t, C.sixty - 0.2, C.sixty + 0.2));
});
shot('B8b', C.exit - 0.4, B.B8.t1, (ctx, t, lt) => {
  // the camp at dawn-less dark (ash + dolls), camera pans right around the rock: daylight pours in from the exit
  const k = seg(t, C.exit - 0.2, C.bend + 0.8);
  cam(ctx, lerp(560, 1200, k), lerp(1240, 1160, k), lerp(1.3, 0.72, k));
  caveRoom(ctx, 1190, 3);
  // exit opening, just past the corner
  const ex = 1720, ey = 1000;
  ctx.save(); const g = ctx.createRadialGradient(ex, ey, 0, ex, ey, 520); g.addColorStop(0, 'rgba(235,242,255,1)'); g.addColorStop(0.35, 'rgba(170,200,250,0.6)'); g.addColorStop(1, 'rgba(90,120,200,0)'); ctx.fillStyle = g; ctx.fillRect(ex - 600, ey - 600, 1200, 1200);
  ctx.beginPath(); ctx.ellipse(ex, ey + 40, 170, 260, 0, 0, Math.PI * 2); ctx.fillStyle = '#eef4ff'; ctx.fill(); ctx.restore();
  rocks(ctx, 44, 700, 1300, '#0f0c0b', 6, 1080, 1300, 1.6); // the corner rock that hid it
  for (let i = 0; i < 30; i++) { const [x, y, fc] = SLOTS[i]; doll(ctx, { x, y, s: 1, face: fc, L: 0.6 }); }
  fire(ctx, FX, FY, 0, t, { embers: 0 });
  doll(ctx, { x: TX + 40, y: TY + 10, s: 1, face: 0.5, L: 0.6, tilt: -1.3 });
  sled(ctx, { x: 220, y: 1420, s: 0.95, dir: 1, L: 0.6 });
  darkness(ctx, [[ex, ey, 1500 * k + 300, 1], [FX, FY - 60, 520 * (0.4 + k), 0.8]], 0.97);
  ctx.save(); ctx.setTransform(1, 0, 0, 1, 0, 0); ctx.fillStyle = `rgba(0,0,0,${1 - seg(lt, 0, 0.6)})`; ctx.fillRect(0, 0, W, H); ctx.restore();
  if (t > C.bend) text(ctx, 'ทางออกอยู่แค่นี้เอง', 420, 76, seg(t, C.bend, C.bend + 0.4));
});

// B9 moral + loop: a new traveler (green scarf) arrives from the exit side, picks up a doll and likes it
shot('B9', B.B9.t0, EP.duration, (ctx, t, lt) => {
  cam(ctx, 700, 1210, 1.25);
  const pick = 7, [dx, dy] = SLOTS[pick];
  const walkIn = seg(lt, 0.2, 2.6), crouch = lt > 2.8 && lt < 5.2, lift = seg(lt, 3.0, 3.8), place = seg(lt, 5.4, 6.4);
  const x = lerp(1120, dx + 95, walkIn), floor = 1460;
  caveRoom(ctx, 1190, 3);
  exitLight(ctx, 1150, 1050, 1.6, t);
  for (let i = 0; i < 30; i++) { if (i === pick && lift > 0) continue; const [sx, sy, fc] = SLOTS[i]; doll(ctx, { x: sx, y: sy, s: 1, face: fc, L: 0.75 }); }
  fire(ctx, FX, FY, 0, t, { embers: 0 });
  sled(ctx, { x: x + 160, y: floor, s: 0.95, dir: -1, L: 0.8, cargo: place >= 1 ? c => doll(c, { x: 0, y: -38, s: 0.95, face: -0.5, L: 0.8, shadow: false }) : null });
  const held = lift > 0 && place < 1;
  const hand = crouch ? [lerp(-70, -40, lift), lerp(-10, -110, lift)] : held ? [lerp(-40, 120, place), lerp(-110, -70, place)] : [-56, -66];
  traveler(ctx, { x, y: floor, s: 1, pose: crouch ? 'crouch' : 'walk', face: crouch ? -0.6 : (held ? lerp(-0.4, 0.6, place) : -0.8), phase: lt * 6 * (1 - walkIn), t, L: 0.85, scarf: E.P.scarf2, mood: lift > 0.5 ? 'smile' : 'neutral', hands: { l: [hand[0] - 30, hand[1] + 4], r: hand }, over: held ? c => doll(c, { x: hand[0] - 14, y: hand[1] + 8, s: 0.95, face: 0.6, L: 0.85, shadow: false }) : null });
  darkness(ctx, [[1150, 1050, 1500, 1]], 0.9);
  eyes(ctx, t, 0.5);
});

// ---------- on-screen text (Thai, Kanit 700) ----------
const TEXT = [
  [0, B.B1.t1, 'เผาเพื่อให้มีแสง..\nหรือเก็บไว้?', 430, 92, true],
  [C.five - 0.1, B.B3.t1, 'เก็บได้ 5 ท่อน', 400, 80],
  [C.three - 0.1, B.B3.t1, 'ใช้ 3 ท่อน', 500, 80],
  [C.two - 0.1, B.B3.t1, 'เหลือ 2 ท่อน', 600, 80],
  [C.weave + 0.6, B.B4.t1, 'ไม้ 2 ท่อน = ตุ๊กตา 1 ตัว', 400, 76],
  [C.none - 0.1, C.tiny - 0.6, 'ไม่มีไม้สำรองเลย', 400, 80],
  [C.fine - 0.1, B.B5.t1, '"ไม่เป็นไรหรอก"', 400, 80],
  [B.B6.t0 + 0.1, B.B6.t0 + 1.5, 'คืนที่ 7', 400, 80], [B.B6.t0 + 1.5, B.B6.t0 + 3.0, 'คืนที่ 15', 400, 80], [B.B6.t0 + 3.0, C.heavy - 0.35, 'คืนที่ 30', 400, 80],
  [C.save - 0.1, EP.duration, 'เก็บก่อน\nแล้วค่อยสนุก', 430, 96],
];
EP.shots = S; EP.text = TEXT;
EP.draw = (ctx, t) => {
  const s = S.find(s => t >= s.t0 && t < s.t1) || S[S.length - 1];
  ctx.save(); s.fn(ctx, t, t - s.t0); ctx.restore();
  ctx.setTransform(1, 0, 0, 1, 0, 0);
  hud(ctx, t);
  // Thai subtitles of the narration (timed from the transcript), lower third
  for (const [a, b, str] of SUBS) if (t >= a && t < b) { E.text(ctx, str, 1480, 58, 1); break; }
  for (const [a, b, str, y, size, instant] of TEXT) if (t >= a && t < b) text(ctx, str, y, size, instant ? 1 : Math.min(1, (t - a) / 0.25, (b - t) / 0.2));
  return s.id;
};
window.EP = EP;
