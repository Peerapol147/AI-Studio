// Episode: ตุ๊กตาไม้ (story.md S01-S15). Each shot = one function of local time. Hard cuts only.
const EP = { duration: 55 };
const { traveler, doll, log, sled, fire, fireGlow, dollPile, village, snow, vignette, breath, cam, text, sky, stars, treeline, ground, pine, smoke, seg, lerp, clamp, ease } = E;

// ---- shared camp layout (same camera angle every night: S01, S04-S06, S08, S10, S12-S15) ----
const FX = 640, FY = 1330, TX = 390, TY = 1342, TS = 1.15, PILE = [880, 1352];
// doll slots around the fire: slot 0 = the first doll (between him and the fire, facing him)
const SLOTS = (() => { const out = [[515, 1384, -0.8]]; for (let i = 1; i < 31; i++) { const f = (i * 0.618034) % 1, a = -0.62 * Math.PI + 1.24 * Math.PI * f, ring = i % 3; const rx = 205 + ring * 45, ry = 58 + ring * 20; const x = FX + Math.cos(a) * rx, y = FY + 4 + Math.sin(a) * ry; out.push([x, y, x > FX ? -0.6 : 0.6]); } return out; })();

function nightSky(ctx, t, dark = 0) {
  sky(ctx, E.mix('#04071a', '#000000', dark), E.mix('#18254d', '#05070f', dark), 0, 1200);
  stars(ctx, 90, 1050, 0.6 * (1 - dark), t);
}
function dawnSky(ctx) { sky(ctx, '#2a3a6c', '#a9bcdc', -600, 1200); }
// the camp scene. o: fire, dolls, reserve (# plain logs left in pile), golden (golden log still in pile), trav (traveler opts or null),
// dawn (morning look), hill (S14 crane: 0..1), dollsOn (extra draw), snowA
function camp(ctx, t, o) {
  const f = o.fire ?? 0.8, dawn = !!o.dawn;
  if (dawn) dawnSky(ctx); else nightSky(ctx, t, o.dark || 0);
  if (o.village) { village(ctx, 560, 1010, 1.0, t, 1, '#22304f'); }
  // far hill with pines (in S14 it slides down as the camera cranes up, revealing the village behind it)
  const hy = 1120 + (o.hill || 0) * 150;
  const hillCol = dawn ? '#5b6f99' : '#0b1430', treeCol = dawn ? '#3e4f78' : '#070c22';
  ctx.beginPath(); ctx.moveTo(-1500, 3000); for (let x = -1500; x <= 2600; x += 40) ctx.lineTo(x, hy - 40 * Math.exp(-(((x - 560) / 700) ** 2)) + Math.sin(x * 0.01) * 6); ctx.lineTo(2600, 3000); ctx.closePath(); ctx.fillStyle = hillCol; ctx.fill();
  treeline(ctx, hy + 30, 170, 300, treeCol, 4, 70, dawn ? '#8fa3c9' : '#1a2547', -1500, 2600);
  ground(ctx, 1190, dawn ? '#8ea2c8' : '#17213f', 10, 2, dawn ? '#b8c8e4' : '#22305a');
  // side pines framing the camp
  for (const [x, h] of [[-60, 980], [1140, 1050], [80, 640], [1010, 700]]) pine(ctx, x, 1250, h, dawn ? '#2f3d63' : '#03060f', dawn ? '#c9d6ec' : '#162043');
  fireGlow(ctx, FX, FY, f, t, 1.1);
  const L = dawn ? 0.75 : 0.22 + 0.78 * Math.min(1, f * 1.25);
  const dl = (x, y) => dawn ? 0.75 : clamp(L * (1.15 - Math.hypot(x - FX, (y - FY) * 2.5) / 420), 0.08, 1);
  const n = o.dolls || 0, back = [], front = [];
  for (let i = 0; i < Math.min(n, SLOTS.length); i++) (SLOTS[i][1] < FY ? back : front).push(SLOTS[i]);
  for (const [x, y, fc] of back) doll(ctx, { x, y, s: 1, face: fc, L: dl(x, y) });
  // woodpile (reserve)
  const pile = [];
  for (let i = 0; i < (o.reserve || 0); i++) pile.push({ golden: false });
  if (o.golden) pile.splice(1, 0, { golden: true });
  pile.forEach((p, i) => log(ctx, { x: PILE[0] + (i % 2) * 14, y: PILE[1] - 6 - i * 25, len: 116, r: 13, golden: p.golden, L: dl(PILE[0], PILE[1]), glint: p.golden ? o.glint || 0 : 0, rot: (i % 2 ? 0.04 : -0.03) }));
  if (o.extra) o.extra(ctx, L);
  fire(ctx, FX, FY, f, t, { embers: o.embers });
  if (o.smoke) smoke(ctx, FX, FY - 20, t, o.smoke);
  if (o.trav) traveler(ctx, Object.assign({ x: TX, y: TY, s: TS, pose: 'sit', face: 0.6, t, L: dawn ? 0.75 : clamp(L * 0.95 + 0.05) }, o.trav));
  for (const [x, y, fc] of front) doll(ctx, { x, y, s: 1, face: fc, L: dl(x, y) });
  if (o.after) o.after(ctx, L);
  if (o.trav && o.breath !== false && !dawn) { const m = E.mouthAt(Object.assign({ x: TX, y: TY, s: TS, pose: 'sit', face: 0.6 }, o.trav)); breath(ctx, m[0], m[1], t + 0.3, 1, o.breathA ?? 0.8); }
}
// the doll held in the right mitten (local traveler coords)
const heldDoll = (hx, hy, L, face = -0.6, tilt = 0) => c => doll(c, { x: hx + 4, y: hy + 6, s: 0.95, face, L: Math.max(0.35, L), shadow: false, tilt });

// ---- shots ----
const S = [];
const shot = (id, t0, t1, fn) => S.push({ id, t0, t1, fn });

// S01 hook: fire almost out, breath, mitten holds a doll toward the flame, hesitates (this is the S12 moment)
const hook = (ctx, t, lt, reach, back = 0) => {
  cam(ctx, 520, 1180, 1.9);
  const f = 0.24 + Math.sin(t * 3) * 0.02;
  const k = reach * (1 - back);
  const hand = [lerp(64, 138, k), lerp(-92, -66, k)];
  const hug = back > 0 ? seg(back, 0.3, 1) : 0;
  const handR = [lerp(hand[0], 22, hug), lerp(hand[1], -84, hug)], handL = [lerp(-10, -24, hug), lerp(-70, -86, hug)];
  camp(ctx, t, { fire: f, dolls: 30, reserve: 0, trav: { mood: hug > 0.6 ? 'shut' : 'worry', face: lerp(0.6, 0.15, hug), hands: { l: handL, r: handR }, shiver: 0.6, over: hug > 0.6 ? null : heldDoll(handR[0], handR[1], 0.6), front: hug > 0.6 ? c => doll(c, { x: 0, y: -64, s: 1, face: 0, L: 0.5, shadow: false }) : null } });
  snow(ctx, t, { n: 50, a: 0.5, speed: 60 });
  vignette(ctx, 0.75, 540, 1000, 250, 1100);
};
shot('S01', 0, 3, (ctx, t, lt) => { const r = seg(lt, 0.0, 1.3) - 0.25 * seg(lt, 1.7, 2.6); hook(ctx, t, lt, 0.35 + 0.65 * r); });

// trek scene (S02 empty sled at night, S11 full sled at dusk): same composition so the village lights are "as far as ever"
function trek(ctx, t, lt, full) {
  cam(ctx, 540, 1040, 1 + lt * 0.012);
  if (full) sky(ctx, '#121b3c', '#3d5185', 0, 1260); else nightSky(ctx, t);
  treeline(ctx, 1176, 80, 140, full ? '#1b2650' : '#0e1734', 8, 40, null);
  village(ctx, 800, 1160, 0.45, t);
  ground(ctx, 1186, full ? '#33446f' : '#1d2a50', 5, 1, full ? '#4b5f91' : '#2a3a68');
  treeline(ctx, 1250, 200, 320, full ? '#121b3e' : '#0a1028', 9, 130, full ? '#3a4c7e' : '#1d2a55', -600, 300);
  treeline(ctx, 1250, 200, 320, full ? '#121b3e' : '#0a1028', 19, 130, full ? '#3a4c7e' : '#1d2a55', 1000, 1700);
  ground(ctx, 1300, full ? '#3c4e7c' : '#25335e', 10, 3, full ? '#5a6fa3' : '#34467a');
  const y = 1520, x = full ? 640 + lt * 10 : 520 + lt * 40, ph = full ? lt * 2.2 : lt * 6, s = 0.85, L = full ? 0.6 : 0.45;
  for (let i = 0; i < 10; i++) E.ellipse(ctx, x - 50 - i * 64, y + 2, 13, 5, 'rgba(12,18,42,0.45)');
  const fp = sled(ctx, { x: x - 270 * s / 0.95, y, s, dir: 1, L, cargo: full ? c => dollPile(c, 30, L, 7, 0.5) : null });
  traveler(ctx, { x, y, s, pose: 'pull', face: 0.85, lean: full ? 0.38 : 0.12, phase: ph, t, L, wind: 0.6, mood: full ? 'worry' : 'neutral', hands: full ? { l: [-40, -110], r: [-20, -104] } : { l: [-46, -96], r: [-30, -90] } });
  ctx.strokeStyle = '#8a7a66'; ctx.lineWidth = 3; ctx.beginPath(); ctx.moveTo(fp[0], fp[1]); ctx.lineTo(x - (full ? 40 : 30) * s, y - (full ? 100 : 92) * s); ctx.stroke();
  breath(ctx, ...E.mouthAt({ x, y, s, pose: 'pull', face: 0.85 }), t, 1, 0.8);
  snow(ctx, t, { n: 110, a: 0.75, wind: 0.3 });
  vignette(ctx, 0.55);
}
shot('S02', 3, 6, (ctx, t, lt) => trek(ctx, t, lt, false));

// S03 dusk: gathers firewood, 5 logs land on the sled one by one ("คืนที่ 1")
shot('S03', 6, 9, (ctx, t, lt) => {
  cam(ctx, 540, 1080, 1.25);
  sky(ctx, '#121c3d', '#3b4f80', 0, 1200);
  treeline(ctx, 1150, 200, 330, '#0e1633', 12, 60, '#2a3a66');
  ground(ctx, 1180, '#4b5d88', 8, 4, '#6d80aa');
  const n = Math.min(5, 1 + Math.floor(lt / 0.55));
  const order = [false, false, false, true, false];
  sled(ctx, { x: 680, y: 1460, s: 0.95, dir: 1, L: 0.55, cargo: c => { for (let i = 0; i < n; i++) { const drop = i === n - 1 ? (1 - seg(lt - i * 0.55, 0, 0.25)) * 60 : 0; const pos = [[-60, -52], [10, -52], [80, -52], [-25, -78], [45, -78]][i]; log(c, { x: pos[0], y: pos[1] - drop, len: 96, r: 13, golden: order[i], L: 0.55 }); } } });
  const lift = Math.sin(lt * 5.7) * 0.5 + 0.5;
  traveler(ctx, { x: 420, y: 1462, s: 1, pose: lt > 2.6 ? 'stand' : 'crouch', face: 0.7, t, L: 0.55, hands: lt > 2.6 ? { l: [-40, -60], r: [50, -64] } : { l: [40, -20 - lift * 30], r: [86, -26 - lift * 30] }, mood: lt > 2.6 ? 'smile' : 'neutral', over: lt <= 2.6 && n < 5 ? c => log(c, { x: 64, y: -24 - lift * 30, len: 96, r: 12, L: 0.55, rot: -0.1 }) : null });
  breath(ctx, ...E.mouthAt({ x: 420, y: 1462, s: 1, pose: lt > 2.6 ? 'stand' : 'crouch', face: 0.7 }), t, 1, 0.6);
  snow(ctx, t, { n: 70, a: 0.6 });
  vignette(ctx, 0.55);
});

// S04 night 1: three logs into the fire, it grows warm; two logs left, one with the golden swirl
shot('S04', 9, 12, (ctx, t, lt) => {
  cam(ctx, 660, 1170, 1.4);
  const tosses = [0.25, 0.95, 1.65];
  let f = 0.18; tosses.forEach(s => f += 0.24 * seg(lt, s + 0.35, s + 0.8));
  const flying = tosses.map(s => clamp((lt - s) / 0.45)).filter(k => k > 0 && k < 1);
  const inPile = 3 - tosses.filter(s => lt >= s).length;
  const reaching = flying.length ? 1 : 0;
  camp(ctx, t, { fire: f, dolls: 0, reserve: 1 + inPile, golden: true, glint: seg(lt, 2.2, 2.6) * (0.6 + 0.4 * Math.sin(t * 6)),
    trav: { mood: f > 0.7 ? 'smile' : 'neutral', face: 0.7, hands: { l: [-20, -62], r: reaching ? [120, -70] : [62, -40] } },
    after: () => flying.forEach(k => { const x = lerp(PILE[0], FX, k), y = lerp(PILE[1] - 70, FY - 20, k) - Math.sin(k * Math.PI) * 120; log(ctx, { x, y, len: 116, r: 13, L: 0.9, rot: k * 2 }); }) });
  snow(ctx, t, { n: 50, a: 0.5, speed: 60 });
  vignette(ctx, 0.6);
});

// S05 close: turns the golden log in his mittens, then weaves the first doll by the fire
shot('S05', 12, 16, (ctx, t, lt) => {
  if (lt < 1.8) {
    cam(ctx, 500, 1170, 2.5);
    const rot = Math.sin(lt * 2.2) * 0.35;
    camp(ctx, t, { fire: 0.85, reserve: 1, trav: { face: 0.45, mood: 'smile', hands: { l: [36, -64], r: [108, -70] }, over: c => log(c, { x: 72, y: -76, len: 110, r: 14, golden: true, L: 1, rot, glint: 0.5 + 0.5 * Math.sin(lt * 5) }) }, breath: false });
  } else {
    cam(ctx, 500, 1185, 2.1);
    const p = seg(lt, 1.9, 3.6);
    camp(ctx, t, { fire: 0.85, reserve: 1, trav: { face: 0.45, mood: p >= 1 ? 'smile' : 'neutral', hands: { l: [44, -62 + Math.sin(t * 9) * 4], r: [102, -62 - Math.sin(t * 9) * 4] }, over: c => { doll(c, { x: 74, y: -46, s: 1.15, p, face: -0.5, L: 1, shadow: false }); } }, breath: false,
      after: () => { const R = E.rng(9); for (let i = 0; i < 9; i++) { ctx.strokeStyle = '#7a5a2a'; ctx.lineWidth = 3; const x = 440 + R() * 160, y = 1360 + R() * 20; ctx.beginPath(); ctx.moveTo(x, y); ctx.lineTo(x + 14, y - 4); ctx.stroke(); } } });
  }
  snow(ctx, t, { n: 30, a: 0.4, speed: 50 });
  vignette(ctx, 0.55);
});

// S06 the doll sits by the fire facing him like a friend; he smiles; everything around is dark and silent
shot('S06', 16, 19, (ctx, t, lt) => {
  cam(ctx, 600, 1180, lerp(1.05, 0.88, ease(lt / 3)));
  camp(ctx, t, { fire: 0.8, dolls: 1, reserve: 1, trav: { mood: 'smile', face: 0.5, hands: { l: [-30, -50], r: [40, -48] } } });
  snow(ctx, t, { n: 40, a: 0.45, speed: 50 });
  vignette(ctx, 0.92, 560, 1160, 180, 820);
});

// S07 blizzard all day: can't gather any wood; the sled carries only the doll (no reserve)
shot('S07', 19, 23, (ctx, t, lt) => {
  const scroll = lt * 70;
  cam(ctx, 540, 1100, 1.15);
  sky(ctx, '#35466b', '#7d8fb3', 0, 1250);
  ctx.save(); ctx.translate(-scroll * 0.3, 0); treeline(ctx, 1180, 220, 360, '#46587e', 14, 80, '#8a9cc0', -600, 2400); ctx.restore();
  ground(ctx, 1220, '#93a5c6', 10, 5, '#b4c3dd');
  ctx.save(); ctx.translate(-scroll, 0);
  for (let i = 0; i < 8; i++) ellipse2(ctx, 200 + i * 130, 1478, 16, 6, 'rgba(60,72,104,0.35)');
  ctx.restore();
  const ph = lt * 4.5;
  sled(ctx, { x: 330, y: 1480, s: 0.9, dir: 1, L: 0.6, cargo: c => doll(c, { x: -20, y: -38, s: 0.95, face: 0.6, L: 0.6, shadow: false }) });
  traveler(ctx, { x: 620, y: 1480, s: 1, pose: 'walk', face: 0.75, lean: 0.2, phase: ph, t, L: 0.6, wind: 1, mood: 'worry', hands: { l: [-6, -118], r: [22, -112] } });
  ctx.strokeStyle = '#5a5560'; ctx.lineWidth = 3; ctx.beginPath(); ctx.moveTo(330 + 112, 1480 - 31); ctx.quadraticCurveTo(520, 1440, 590, 1400); ctx.stroke();
  ctx.save(); ctx.setTransform(1, 0, 0, 1, 0, 0); ctx.fillStyle = `rgba(215,225,242,${0.22 + 0.1 * Math.sin(t * 2.3)})`; ctx.fillRect(0, 0, W, H); ctx.restore();
  snow(ctx, t, { n: 420, a: 0.9, wind: 1.3, speed: 520, heavy: true, seed: 8 });
  snow(ctx, t, { n: 120, a: 0.8, wind: 1.1, speed: 300, seed: 3 });
});
function ellipse2(ctx, x, y, rx, ry, c) { E.ellipse(ctx, x, y, rx, ry, c); }

// S08 that night: a tiny fire, he sits shivering, hugging the doll
shot('S08', 23, 26, (ctx, t, lt) => {
  cam(ctx, 480, 1170, 1.8);
  camp(ctx, t, { fire: 0.2 + Math.sin(t * 5) * 0.02, dolls: 0, reserve: 0, trav: { mood: 'shut', face: 0.2, shiver: 1, hands: { l: [-24, -86], r: [24, -84] }, front: c => doll(c, { x: 0, y: -64, s: 1, face: 0, L: 0.45, shadow: false }) }, breathA: 1 });
  snow(ctx, t, { n: 90, a: 0.7, wind: 0.5, speed: 140 });
  vignette(ctx, 0.85, 500, 1000, 200, 950);
});

// S09 morning: finds a big fallen tree; relieved (lucky, not planned)
shot('S09', 26, 29, (ctx, t, lt) => {
  cam(ctx, 540, 1140, lerp(1.1, 1.2, ease(lt / 3)));
  dawnSky(ctx);
  treeline(ctx, 1120, 220, 380, '#4a5c87', 15, 70, '#c3d1ea');
  ground(ctx, 1170, '#9fb2d3', 8, 6, '#c6d4ec');
  // fallen tree: big plain trunk with stubs, snow on top
  ctx.save(); ctx.translate(640, 1330); ctx.rotate(-0.05);
  log(ctx, { x: 0, y: 0, len: 620, r: 52, L: 0.8 });
  ctx.fillStyle = '#e4ecf7'; ctx.beginPath(); ctx.roundRect(-300, -58, 580, 18, 9); ctx.fill();
  ctx.strokeStyle = E.lit(E.P.log, 0.8); ctx.lineWidth = 16; ctx.lineCap = 'round'; for (const x of [-180, 40, 200]) { ctx.beginPath(); ctx.moveTo(x, -40); ctx.lineTo(x + 30, -110); ctx.stroke(); }
  ctx.restore();
  sled(ctx, { x: 160, y: 1470, s: 0.8, dir: 1, L: 0.75, cargo: c => doll(c, { x: -20, y: -38, s: 0.95, face: 0.6, L: 0.75, shadow: false }) });
  const k = seg(lt, 0.3, 1.0);
  traveler(ctx, { x: 420, y: 1470, s: 1, pose: 'stand', face: lerp(0.7, 0.3, k), t, L: 0.8, mood: k > 0.5 ? 'relief' : 'neutral', hands: k > 0.5 ? { l: [-20, -112], r: [16, -110] } : { l: [-56, -70], r: [56, -70] } });
  if (lt > 1.2) breath(ctx, ...E.mouthAt({ x: 420, y: 1470, s: 1, pose: 'stand', face: 0.3 }), lt - 1.2, 1, 0.8);
  snow(ctx, t, { n: 40, a: 0.6, speed: 40 });
  vignette(ctx, 0.35);
});

// S10 montage, same camera every night: dolls ring the fire, the fire gets smaller ("คืนที่ 7/15/30")
const MONT = [[29, 31.33, 7, 0.72], [31.33, 33.67, 15, 0.52], [33.67, 36, 30, 0.34]];
MONT.forEach(([a, b, n, f], i) => shot('S10' + 'abc'[i], a, b, (ctx, t, lt) => {
  cam(ctx, 620, 1200, 1.4);
  camp(ctx, t, { fire: f + Math.sin(t * 4) * 0.02, dolls: n, reserve: 0, trav: { face: 0.6, mood: i === 2 ? 'worry' : 'neutral', shiver: i === 2 ? 0.5 : 0, hands: { l: [-20, -54], r: [44, -46] } } });
  snow(ctx, t, { n: 50 + i * 25, a: 0.55, speed: 70 });
  vignette(ctx, 0.62 + i * 0.08);
}));

// S11 daytime: the sled is full of dolls, he can barely pull it; the village lights are as far as ever
shot('S11', 36, 39, (ctx, t, lt) => trek(ctx, t, lt, true));

// S12 back to the hook: no wood left, holds the doll to the fire, looks at its face, pulls it back and hugs it
shot('S12a', 39, 40.6, (ctx, t, lt) => hook(ctx, t, lt, 0.3 + 0.7 * seg(lt, 0, 1.2)));
shot('S12b', 40.6, 42.2, (ctx, t, lt) => {
  cam(ctx, 470, 1100, lerp(3.4, 3.6, lt / 1.6));
  const hand = [138, -66];
  camp(ctx, t, { fire: 0.22, dolls: 30, reserve: 0, breath: false, trav: { mood: lt > 0.8 ? 'sad' : 'worry', face: 0.75, hands: { l: [-10, -70], r: hand }, shiver: 0.3, over: heldDoll(hand[0], hand[1], 0.75, -0.9) } });
  vignette(ctx, 0.7, 540, 960, 200, 1000);
});
shot('S12c', 42.2, 44, (ctx, t, lt) => hook(ctx, t, lt, 1, seg(lt, 0, 0.9)));

// S13 the fire goes out; the picture slowly goes dark (no body shown)
shot('S13', 44, 47, (ctx, t, lt) => {
  cam(ctx, 500, 1225, lerp(1.5, 1.35, lt / 3));
  const f = 0.16 * (1 - seg(lt, 0.1, 1.6));
  camp(ctx, t, { fire: f, embers: 0.8 * (1 - seg(lt, 0.6, 2.4)), smoke: seg(lt, 1.2, 1.8), dolls: 30, reserve: 0, dark: seg(lt, 0.5, 2.5), breathA: 0.6 * (1 - seg(lt, 0.8, 2.2)), trav: { mood: 'shut', face: 0.15, hands: { l: [-24, -86], r: [24, -84] }, front: c => doll(c, { x: 0, y: -64, s: 1, face: 0, L: 0.4, shadow: false }) } });
  snow(ctx, t, { n: 60, a: 0.5, speed: 60 });
  ctx.save(); ctx.setTransform(1, 0, 0, 1, 0, 0); ctx.fillStyle = `rgba(0,0,0,${seg(lt, 0.4, 2.85)})`; ctx.fillRect(0, 0, W, H); ctx.restore();
});

// S14 dawn: dolls all around the ash; camera cranes up: the village is just behind the next hill
shot('S14', 47, 52, (ctx, t, lt) => {
  const k = seg(lt, 0.6, 4.4);
  cam(ctx, lerp(640, 600, k), lerp(1300, 1000, k), lerp(1.55, 0.8, k));
  camp(ctx, t, { dawn: true, fire: 0, embers: 0, smoke: 0.5, dolls: 30, reserve: 0, village: true, hill: k,
    extra: () => { sled(ctx, { x: 240, y: 1420, s: 0.95, dir: 1, L: 0.75 }); doll(ctx, { x: TX + 40, y: TY + 10, s: 1, face: 0.5, L: 0.75, tilt: -1.3 }); } });
  snow(ctx, t, { n: 50, a: 0.6, speed: 40 });
  ctx.save(); ctx.setTransform(1, 0, 0, 1, 0, 0); ctx.fillStyle = `rgba(0,0,0,${1 - seg(lt, 0, 0.7)})`; ctx.fillRect(0, 0, W, H); ctx.restore();
  vignette(ctx, 0.35);
});

// S15 a new traveler (green scarf) with an empty sled picks up a doll, likes it, puts it on his own sled -> loops to S01
shot('S15', 52, 55, (ctx, t, lt) => {
  cam(ctx, 700, 1210, 1.25);
  const pick = 7; // the doll he takes (a front slot on the right)
  const [dx, dy] = SLOTS[pick];
  const walk = seg(lt, 0, 1.0), crouch = lt > 1.0 && lt < 2.2, lift = seg(lt, 1.15, 1.6), place = seg(lt, 2.3, 2.8);
  const x = lerp(1060, dx + 95, walk);
  // hide the picked doll from the ring once lifted
  const n = 30;
  camp(ctx, t, { dawn: true, fire: 0, embers: 0, smoke: 0.3, dolls: 0, reserve: 0,
    extra: () => { for (let i = 0; i < n; i++) { if (i === pick && lift > 0) continue; const [sx, sy, fc] = SLOTS[i]; if (sy < FY) doll(ctx, { x: sx, y: sy, s: 1, face: fc, L: 0.75 }); } },
    after: () => {
      for (let i = 0; i < n; i++) { if (i === pick && lift > 0) continue; const [sx, sy, fc] = SLOTS[i]; if (sy >= FY) doll(ctx, { x: sx, y: sy, s: 1, face: fc, L: 0.75 }); }
      const sx = x + 160;
      sled(ctx, { x: sx, y: 1460, s: 0.95, dir: -1, L: 0.75, cargo: place >= 1 ? c => doll(c, { x: 0, y: -38, s: 0.95, face: -0.5, L: 0.75, shadow: false }) : null });
      const pose = crouch ? 'crouch' : 'walk';
      const held = lift > 0 && place < 1;
      const hand = crouch ? [lerp(-70, -40, lift), lerp(-10, -110, lift)] : held ? [lerp(-40, 120, place), lerp(-110, -70, place)] : [-56, -66];
      traveler(ctx, { x, y: 1460, s: 1, pose, face: crouch ? -0.6 : (held ? lerp(-0.4, 0.6, place) : -0.8), phase: lt * 6 * (1 - walk), t, L: 0.8, scarf: E.P.scarf2, mood: lift > 0.5 ? 'smile' : 'neutral', hands: { l: [hand[0] - 30, hand[1] + 4], r: hand }, over: held ? c => doll(c, { x: hand[0] - 14, y: hand[1] + 8, s: 0.95, face: 0.6, L: 0.8, shadow: false }) : null });
    } });
  snow(ctx, t, { n: 40, a: 0.6, speed: 40 });
  vignette(ctx, 0.35);
});

// ---- on-screen text (Thai, Kanit 700 from assets/fonts) ----
const TEXT = [
  [0, 3, 'เผาเพื่อรอด..\nหรือเก็บไว้?', 400, 92, true],
  [6.15, 9, 'คืนที่ 1', 380, 84],
  [29.1, 31.33, 'คืนที่ 7', 380, 84],
  [31.4, 33.67, 'คืนที่ 15', 380, 84],
  [33.75, 36, 'คืนที่ 30', 380, 84],
  [48.2, 52, 'ไม้ที่พาเขาไปถึงได้..\nอยู่ข้างตัวเขามาตลอด', 420, 76],
];
// English version (?lang=en): same shots, English on-screen text (narration is in the audio mix)
const TEXT_EN = [
  [0, 3, 'Burn it to survive..\nor keep it?', 400, 88, true],
  [6.15, 9, 'Night 1', 380, 84],
  [29.1, 31.33, 'Night 7', 380, 84],
  [31.4, 33.67, 'Night 15', 380, 84],
  [33.75, 36, 'Night 30', 380, 84],
  [48.2, 52, 'The wood that could have\ncarried him there..\nwas beside him all along', 440, 68],
];
EP.lang = new URLSearchParams(location.search).get('lang') === 'en' ? 'en' : 'th';
if (EP.lang === 'en') { TEXT.length = 0; TEXT.push(...TEXT_EN); }
EP.shots = S;
EP.text = TEXT;
EP.draw = (ctx, t) => {
  const s = S.find(s => t >= s.t0 && t < s.t1) || S[S.length - 1];
  ctx.save(); s.fn(ctx, t, t - s.t0); ctx.restore();
  ctx.setTransform(1, 0, 0, 1, 0, 0);
  for (const [a, b, str, y, size, instant] of TEXT) if (t >= a && t < b) text(ctx, str, y, size, instant ? 1 : Math.min(1, (t - a) / 0.25, (b - t) / 0.2));
  return s.id;
};
window.EP = EP;
