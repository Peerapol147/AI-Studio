// "ไอ้ขี้แพ้เป็นมวย" ตอนที่ 1 — shot list (long 16:9). Every cut is tied to a voice line or a named silent beat
// from episode-data.json (timeline.json -> build_timeline.py), never typed seconds.
/* global A, FT, SCH, STAGE, DATA, CH */
const L = id => DATA.lines[id]; const M = n => DATA.marks[n];
const at = (id, lead = 0.12) => +((DATA.lines[id] || DATA.marks[id]).start - lead).toFixed(3);
const end = (id) => (DATA.lines[id] || DATA.marks[id]).end;
const clamp01 = v => Math.max(0, Math.min(1, v));
const tq = t => Math.floor(t * 12) / 12; // character motion on twos
const ease = A.ease, lerp = A.lerp, spr = A.spring;
function mouth(v, t) { const e = DATA.mouth[v]; if (!e) return 0; const f = Math.floor(t * DATA.fps / 2) * 2; return clamp01(((Math.max(e[f] || 0, e[f + 1] || 0)) - 0.1) * 1.5); }
const blink = (t, s) => (((t * 0.29 + s) % 1) < 0.045 ? 1 : 0);
const shake = (t, amp, f = 23) => ({ dx: amp * Math.sin(t * f) + amp * 0.5 * Math.sin(t * f * 1.7), dy: amp * Math.cos(t * f * 1.3) });
const G = STAGE.G, H = STAGE.HT, DK = STAGE.DESK, BACK = STAGE.WB + 70;
// ---- poses (world angles, see fighter.js)
const PO = {
  stand: {}, meek: { lean: 0.1, head: 0.28, armF: [0.06, 0.1], armB: [-0.04, 0.12] },
  guard: { legF: [0.3, -0.14], legB: [-0.3, -0.06], armF: [1.0, 2.0], armB: [0.72, 2.3], lean: -0.04, head: 0.06 },
  wai: { legF: [0.06, -0.04], legB: [-0.06, -0.02], armF: [0.75, 2.35], armB: [0.7, 2.4], handF: 'wai', handB: 'wai', head: 0.2, lean: 0.1 },
  sit: { legF: [1.45, -1.45], legB: [1.38, -1.4], armF: [1.25, 0.7], armB: [1.15, 0.8], lean: 0.04 },
  sleep: { legF: [1.45, -1.45], legB: [1.38, -1.4], armF: [1.75, 1.1], armB: [1.7, 1.2], lean: 1.05, head: 0.35 },
  point: { armF: [1.55, 0.05], handF: 'open', lean: 0.04 },
  slam: { armF: [1.2, 0.5], handF: 'open', lean: 0.22, legF: [0.35, -0.2], legB: [-0.25, -0.05] },
  flick: { armF: [1.45, -0.25], lean: 0.12 },
  laugh: { lean: -0.12, head: -0.25, armF: [0.6, 1.8], armB: [0.2, 0.4] },
  shove: { armF: [1.55, 0.0], armB: [1.45, 0.1], handF: 'open', handB: 'open', lean: 0.3, legF: [0.45, -0.25], legB: [-0.35, -0.05] },
  raise: { armF: [2.6, 0.2], handF: 'open', lean: -0.05 },
  jab: { armF: [1.58, 0.0], armB: [0.72, 2.3], lean: 0.12, legF: [0.4, -0.2], legB: [-0.32, -0.04] },
  pant: { lean: 0.38, head: -0.3, armF: [0.35, 0.45], armB: [0.25, 0.5], legF: [0.18, -0.3], legB: [-0.16, -0.25] },
  walkA: { legF: [0.35, -0.2], legB: [-0.32, -0.05], armF: [-0.25, 0.3], armB: [0.3, 0.3] },
  walkB: { legF: [-0.3, -0.05], legB: [0.32, -0.25], armF: [0.3, 0.3], armB: [-0.25, 0.3] },
  run: { legF: [0.9, -1.1], legB: [-0.6, -1.0], armF: [-0.6, 1.6], armB: [0.9, 1.4], lean: 0.25 },
  punchWind: { armF: [0.4, 2.3], armB: [0.6, 2.2], lean: -0.05, legF: [0.3, -0.2], legB: [-0.3, -0.05] },
  punch: { armF: [1.6, -0.02], armB: [0.5, 2.1], lean: 0.28, legF: [0.62, -0.42], legB: [-0.42, -0.02] },
  hitBack: { lean: -0.6, head: -0.5, armF: [2.4, 0.6], armB: [2.0, 0.5], handF: 'open', handB: 'open', legF: [0.7, -0.3], legB: [0.3, -0.6] },
  down: { lie: 1, armF: [2.9, 0.3], armB: [2.6, 0.5], legF: [0.3, -0.4], legB: [-0.1, -0.2], head: -0.2 },
  pushUp: { lie: 1, lieDir: -1, armF: [0.05, 0.0], armB: [0.1, 0.0], legF: [0.05, 0], legB: [0, 0] },
  pushDown: { lie: 1, lieDir: -1, armF: [0.9, -1.6], armB: [0.95, -1.6], legF: [0.05, 0], legB: [0, 0], air: -6 },
  // Muay Thai (see research.md): teep = มอญยันหลัก, catch+twist = นาคาบิดหาง, spinning back heel = จระเข้ฟาดหาง
  teepChamber: { legF: [1.8, -2.0], legB: [-0.12, -0.08], armF: [1.0, 2.0], armB: [0.72, 2.3], lean: -0.12, groundF: false },
  teep: { legF: [1.52, -0.04], legB: [-0.1, -0.05], ftF: 0, armF: [1.0, 2.0], armB: [-0.3, 0.6], lean: -0.34, groundF: false },
  kickHigh: { legF: [1.58, 0.02], ftF: 1, legB: [-0.12, -0.06], armF: [0.6, 2.2], armB: [-0.9, 0.3], lean: -0.42, groundF: false },
  catch: { armF: [1.55, 0.35], armB: [1.4, 0.55], handF: 'open', handB: 'open', lean: 0.06, legF: [0.36, -0.2], legB: [-0.32, -0.06] },
  twist: { armF: [1.95, 0.6], armB: [1.1, 0.2], handF: 'open', handB: 'open', lean: -0.2, legF: [0.4, -0.2], legB: [-0.42, -0.06] },
  spinTurn: { legF: [0.1, -0.1], legB: [-0.2, -0.1], armF: [1.0, 2.0], armB: [0.72, 2.3], lean: 0.25, head: 0.6 },
  spinKick: { legB: [-1.58, 0.02], ftB: 0, legF: [0.12, -0.08], armF: [1.3, 1.6], armB: [0.9, 1.9], lean: 0.75, head: 1.0, groundB: false },
  airSpin: { air: 40, lean: 0.2, legF: [1.4, -0.2], legB: [-0.4, -0.3], armF: [2.7, 0.5], armB: [-1.2, 0.4], handF: 'open', handB: 'open', head: -0.4 },
};
const mix = (a, b, k) => { const pa = FT.P(a), pb = FT.P(b), o = {}; for (const key in pa) { const x = pa[key], y = pb[key]; o[key] = Array.isArray(x) ? x.map((v, i) => v + (y[i] - v) * k) : typeof x === 'number' ? x + (y - x) * k : (k < 0.5 ? x : y); } return o; };
const walk = (t, sp = 7) => mix(PO.walkA, PO.walkB, 0.5 + 0.5 * Math.sin(tq(t) * sp));
const P = (look, x, f, pose, face = {}, extra = {}) => FT.body(Object.assign({ look, x, y: G, s: H, f, pose, face }, extra));
const Pb = (look, x, f, pose, face = {}) => FT.body({ look, x, y: BACK, s: H * 0.6, f, pose, face, noShadow: false }); // back-row extras
const FACE = (who, x, y, s, o = {}) => FT.face(Object.assign({ who, x, y, s }, o));
// Kla (Saengchai inside) face params
const KF = (t, o = {}) => Object.assign({ mouth: mouth('S', t), blink: blink(t, 0.2) }, o);
// ---- camera helpers: aim the camera at world (X,Y) with scale p (clamped to framebuffer headroom)
function aim(shot, X, Y, p, extra = {}) { const z = shot.cam0.zoom, W = A.W, Hh = A.H;
  let dx = -p * z * (X - shot.cam0.cx), dy = -p * z * (Y - shot.cam0.cy); const mx = (1.16 * p - 1) * W / 2, my = (1.16 * p - 1) * Hh / 2;
  dx = Math.max(-mx, Math.min(mx, dx)); dy = Math.max(-my, Math.min(my, dy)); return Object.assign({ p, dx, dy }, extra); }
// ---- props
function bookProp(x, y, s, rot = 0, open = false) { A.push(); A.translate(x, y); A.rotate(rot); A.scale(s / 100); if (open) SCH.sketchbook(0, 0, 100, 0); else { A.rect(-40, -30, 80, 60, { fill: '#3c5a8a', w: 1.1 }); A.rect(-34, -24, 68, 48, { fill: '#5a7ab0', w: 0.5 }); } A.pop(); }
function glassesProp(x, y, s, rot = 0) { A.push(); A.translate(x, y); A.rotate(rot); A.scale(s / 10); A.ell(-6, 0, 4.4, 3.6, { ink: '#2a2428', w: 1 }); A.ell(6, 0, 4.4, 3.6, { ink: '#2a2428', w: 1 }); A.stroke([[-1.6, 0], [1.6, 0]], { w: 0.8 }); A.pop(); }
function frontDesks(xs) { for (const x of xs) SCH.desk(x, G, DK); }
function backCrowd(t, mood = 'calm', xs = [260, 520, 1380, 1640]) { const looks = ['mewS', 'nutS', 'fernS', 'extra'];
  xs.forEach((x, i) => Pb(looks[i % 4], x, x < 960 ? 1 : -1, mood === 'wow' ? PO.raise : mood === 'laugh' ? PO.laugh : PO.stand, { eyes: mood === 'wow' ? 'wide' : 'normal', mouth: mood === 'wow' ? 0.7 : mood === 'laugh' ? 0.5 * Math.abs(Math.sin(t * 9 + i)) : 0, blink: blink(t, i * 0.3) })); }
function seated(t) { // students sitting in class (side), facing the board (-x)
  [[420, 'mewS'], [1000, 'nutS'], [1560, 'fernS']].forEach(([x, k], i) => { SCH.desk(x - 150, G, DK); P(k, x, -1, PO.sit, { blink: blink(t, i * 0.4) }); }); }
function zzz(x, y, t) { for (let i = 0; i < 3; i++) { const k = (t * 0.5 + i / 3) % 1; A.push(); A.translate(x + k * 80, y - k * 160); A.scale(0.5 + k); A.stroke([[-12, -12], [12, -12], [-12, 12], [12, 12]], { ink: '#f2f0ff', w: 2.4, curv: 0 }); A.pop(); } }
function sweatDrops(x, y, t) { for (let i = 0; i < 3; i++) { const k = (t * 1.6 + i / 3) % 1; A.poly([[x + i * 30, y + k * 60], [x + i * 30 + 8, y + 16 + k * 60], [x + i * 30, y + 26 + k * 60], [x + i * 30 - 8, y + 16 + k * 60]], { fill: '#bfe6ff', w: 0.8, curv: 0.6 }); } }
function glitch(t, n = 14) { A.push(); A.reset(); A.seed(Math.floor(t * 24)); for (let i = 0; i < n; i++) { const y = A.R(0, A.H), h = A.R(4, 26); A.rect(0, y, A.W, h, { fill: i % 3 ? '#ffffff' : '#ff4d6d', alpha: A.R(60, 160), w: 0 }); } A.pop(); }
function speed(t, cx, cy, n = 30, col = '#fff6dc') { A.push(); A.reset(); for (let i = 0; i < n; i++) { const a = i / n * Math.PI * 2 + Math.floor(t * 12) * 0.37, r0 = 520 + 120 * Math.sin(i * 7.1); A.stroke([[cx + Math.cos(a) * r0, cy + Math.sin(a) * r0], [cx + Math.cos(a) * (r0 + 600), cy + Math.sin(a) * (r0 + 600)]], { ink: col, w: 1.8, curv: 0 }); } A.pop(); }
function vignette() {} // DOM #vig (shot.vig) does this smoothly
// close-up framings (bg painted at that zoom so it stays sharp)
const WIDE = { zoom: 1, cx: 960, cy: 540 };
const CU = (cx, cy, zoom = 2.2) => ({ zoom, cx, cy });
// ---- hook composition (also used at the end of part 7 and the final shot): Kla in guard, gang around, class watching
function hookScene(t, phase = 'hook') {
  backCrowd(t, phase === 'end' ? 'wow' : 'calm');
  frontDesks([60, 1700]);
  if (phase === 'end') { P('jo', 1240, -1, PO.down, { eyes: 'dazed' }); P('te', 1480, 1, PO.down, { eyes: 'dazed' }); P('boss', 1360, -1, Object.assign({}, PO.down, { air: -18 }), { eyes: 'dazed' }); FT.stars(1300, 780, 70, t); FT.stars(1560, 800, 60, t + 1); }
  else { P('jo', 560, 1, PO.punchWind, { anger: 0.8, blink: blink(t, 0.5) }); P('te', 1300, -1, PO.stand, { anger: 0.6, mood: 'smirk' }); P('boss', 1130, -1, phase === 'shout' ? PO.point : PO.slam, { anger: 1, mouth: phase === 'shout' ? mouth('B', t) : 0.1 }); }
  P('kla', phase === 'end' ? 900 : 860, 1, PO.guard, { eyes: 'fierce', anger: 0.3 }, { lookOver: { bangsUp: true } });
}
// ============================================================ shots
const S = [];
const add = (t0, o) => S.push(Object.assign({ t0 }, o));
// ---------------- PART 1: cold open
add(0, { id: 'p1_hook', cam0: WIDE, bg: () => STAGE.classroomTense(), bgKey: 'cls_tense', hook: 'ทุกคนคิดว่ามันขี้แพ้...', noSub: true, vig: 0.5,
  cam: (lt) => aim({ cam0: WIDE }, 900, 640, 1.05 + 0.06 * ease(lt / 2), { rot: -0.03 }), draw: (lt, t) => { hookScene(t); vignette(90); } });
add(at('B01'), { id: 'p1_bossShout', cam0: CU(1130, 520, 2.4), bg: () => STAGE.classroomTense(), bgKey: 'cls_tense_cu_boss',
  cam: (lt, t) => Object.assign({ p: 1 + 0.04 * lt, rot: 0.04 }, shake(t, 5 * Math.max(0, 1 - lt / 0.5))),
  draw: (lt, t) => { speed(t, 980, 520, 24, '#ffe9d6'); FACE('boss', 1130, 470, 150, { anger: 1, mouth: Math.max(0.3, mouth('B', t)), eyes: 'normal' }); } });
add(at('freeze', 0), { id: 'p1_freeze', cam0: WIDE, bg: () => STAGE.classroomTense(), bgKey: 'cls_tense', flash: 0.25,
  cam: () => aim({ cam0: WIDE }, 1000, 600, 1.35), draw: (lt, t) => { hookScene(0.4, 'shout'); vignette(140); } });
add(at('rewind', 0), { id: 'p1_rewind', cam0: WIDE, bg: () => STAGE.classroomTense(), bgKey: 'cls_tense',
  cam: (lt) => aim({ cam0: WIDE }, 1000, 600, 1.35 - 0.3 * ease(lt / 0.8)), draw: (lt, t) => { hookScene(-lt * 6); glitch(t, 18); } });
add(at('N02', 0.05), { id: 'p1_eyes', cam0: CU(960, 470, 2.6), bg: () => STAGE.burst('#3a1a24', '#120a10'), bgKey: 'burst_dark',
  cam: (lt) => ({ p: 1 + 0.05 * lt }), draw: (lt, t) => { FACE('kla', 960, 520, 300, { eyes: 'fierce', bangsUp: false, blink: 0 }); } });
add(at('title', 0), { id: 'p1_title', cam0: WIDE, bg: () => STAGE.burst('#b3121f', '#3a0a10'), bgKey: 'burst_red', title: true, noSub: true,
  cam: (lt) => ({ p: 1 + 0.03 * lt }), draw: () => {} });
// ---------------- PART 2: the forgotten champion (gym)
add(at('N03', 0.1), { id: 'p2_gymWide', cam0: WIDE, bg: () => STAGE.gym(), bgKey: 'gym', tag: { text: '7 วันก่อน', col: '#ffffff' },
  cam: (lt) => aim({ cam0: WIDE }, 960, 560, 1.12 - 0.08 * ease(lt / 4)),
  draw: (lt, t) => { const k = Math.sin(tq(lt) * 5); A.push(); A.translate(1080, 150); A.rotate(0.03 * k); A.translate(-1080, -150); A.pop(); P('saeng', 1240, -1, k > 0.6 ? PO.jab : PO.guard, { blink: blink(t, 0.1), mood: 'calm' }); } });
add(at('N04', 0.1), { id: 'p2_saengIntro', cam0: CU(1150, 620, 1.6), bg: () => STAGE.gym(), bgKey: 'gym_160', tag: { text: 'แสงชัย', sub: 'อดีตแชมป์มวยไทย 3 สมัย • 52 ปี', at: 0.3 },
  cam: (lt) => ({ p: 1 + 0.03 * lt }), draw: (lt, t) => { const k = Math.sin(tq(lt) * 4); P('saeng', 1240, -1, mix(PO.guard, PO.jab, clamp01(k)), { blink: blink(t, 0.3) }); } });
add(at('N05', 0.1), { id: 'p2_empty', cam0: CU(400, 640, 1.5), bg: () => STAGE.gym(), bgKey: 'gym_ring',
  cam: (lt) => ({ p: 1 + 0.02 * lt, dx: -30 * lt }), draw: () => {} ,
  fxs: [{ d: 0.4, text: 'ค่าเรียน <s>500</s> <s>300</s> <b>200</b> บาท', x: 620, y: 230, size: 64, rot: -4, html: true, len: 4 }] });
add(at('belt', 0), { id: 'p2_belt', cam0: CU(900, 420, 2.0), bg: () => STAGE.gym(), bgKey: 'gym_belt',
  cam: (lt) => ({ p: 1 + 0.05 * ease(lt / 2) }), draw: (lt, t) => { P('saeng', 1150, -1, Object.assign({}, PO.stand, { head: 0.2 }), { mood: 'sad', blink: blink(t, 0.5) }); } });
add(at('S01'), { id: 'p2_sigh', cam0: CU(960, 470, 2.4), bg: () => STAGE.gym(), bgKey: 'gym_cu',
  cam: (lt) => ({ p: 1 + 0.03 * lt }), draw: (lt, t) => { FACE('legend', 960, 520, 300, { mood: 'sad', mouth: mouth('S', t), blink: blink(t, 0.1), look: -1 }); } });
add(at('N06', 0.1), { id: 'p2_door', cam0: CU(1700, 480, 1.5), bg: () => STAGE.gym(), bgKey: 'gym_door',
  cam: (lt) => ({ p: 1 + 0.08 * ease(lt / 3) }), draw: () => {} });
add(at('kidgate', 0), { id: 'p2_kidDoor', cam0: CU(1500, 620, 1.4), bg: () => STAGE.gym(), bgKey: 'gym_kid', sepia: true,
  cam: (lt) => ({ p: 1 + 0.02 * lt }), draw: (lt, t) => { P('kidK', 1620, -1, PO.meek, { blink: blink(t, 0.7) }); P('saeng', 1300, 1, PO.stand, { blink: blink(t, 0.2) }); } });
add(at('K01'), { id: 'p2_kidCU', cam0: CU(960, 470, 2.4), bg: () => STAGE.gym(), bgKey: 'gym_cu2', sepia: true,
  cam: (lt) => ({ p: 1 + 0.03 * lt }), draw: (lt, t) => { FACE('kidK', 960, 520, 280, { mood: 'sad', mouth: mouth('K', t), blink: blink(t, 0.6), look: 1 }); } });
add(at('S02'), { id: 'p2_headpat', cam0: CU(1460, 620, 1.5), bg: () => STAGE.gym(), bgKey: 'gym_kid2', sepia: true,
  cam: (lt) => ({ p: 1 + 0.03 * lt }), draw: (lt, t) => { P('kidK', 1580, -1, Object.assign({}, PO.meek, { head: 0.1 }), { blink: blink(t, 0.7) });
    P('saeng', 1380, 1, { armF: [2.1 + 0.06 * Math.sin(tq(lt) * 6), 0.4], handF: 'open', lean: 0.12, legF: [0.3, -0.5], legB: [-0.5, -0.9] }, { mood: 'happy', mouth: mouth('S', t) }); } });
add(at('N07', 0.1), { id: 'p2_kidLeaves', cam0: CU(1560, 620, 1.4), bg: () => STAGE.gym(), bgKey: 'gym_kid', sepia: true,
  draw: (lt, t) => { P('saeng', 1300, 1, PO.stand, { blink: blink(t, 0.2) }); P('kidK', 1620 + lt * 120, 1, walk(lt), {}); } });
add(at('S03', 0.3), { id: 'p2_alone', cam0: CU(960, 470, 2.2), bg: () => STAGE.gymNight(), bgKey: 'gym_night_cu',
  cam: (lt) => ({ p: 1 + 0.04 * lt }), draw: (lt, t) => { FACE('legend', 960, 520, 280, { mood: 'sad', mouth: mouth('S', t), eyes: lt > 1.6 ? 'shut' : 'normal', look: -1 }); } });
// ---------------- PART 3: wake up as someone else
add(at('N08', 0.2), { id: 'p3_bed', cam0: CU(900, 560, 1.45), bg: () => STAGE.bedroom(), bgKey: 'bed', vig: 0.6,
  cam: (lt) => ({ p: 1 + 0.05 * lt }), draw: (lt, t) => { // lying on his back, head on the pillow (left), blanket over the body
    FT.body({ look: 'saeng', x: 760, y: 652, s: H * 1.05, f: -1, pose: { lie: 1, lieDir: -1, armF: [0.2, 0.3], armB: [0.1, 0.2], legF: [0.02, 0], legB: [-0.02, 0] }, face: { eyes: 'shut', mouth: 0.12 * (1 + Math.sin(t * 2)) }, noShadow: true });
    A.poly([[590, 600], [1640, 596], [1660, 700], [1630, 760], [600, 770], [570, 690]], { fill: '#5a6a9a', w: 1.3, curv: 0.3 }); A.stroke([[700, 640], [1500, 650]], { ink: '#46557e', w: 0.8 }); zzz(420, 430, t); } });
add(at('bell', 0), { id: 'p3_black', cam0: WIDE, bg: () => STAGE.flat('#0a0a0e', '#000000'), bgKey: 'black',
  draw: () => {}, fxs: [{ d: 0.15, text: 'กริ๊งงงง!', x: 960, y: 520, size: 150, len: 0.8 }] });
add(at('C01'), { id: 'p3_class', cam0: WIDE, bg: () => STAGE.classroom(), bgKey: 'cls',
  cam: (lt) => aim({ cam0: WIDE }, 900, 600, 1.08), draw: (lt, t) => { P('teacher', 300, 1, lt > 0.2 ? PO.point : PO.stand, { anger: 0.6, mouth: mouth('C', t) });
    seated(t); SCH.desk(640, G, DK); P('kla', 790 - 150 + 150, -1, PO.sleep, { eyes: 'shut' }); } });
add(at('jolt', 0), { id: 'p3_jolt', cam0: CU(960, 470, 2.4), bg: () => STAGE.classroom(), bgKey: 'cls_cu',
  cam: (lt, t) => Object.assign({ p: 1.02 }, shake(t, 8 * Math.max(0, 1 - lt / 0.3))), draw: (lt, t) => { FACE('kla', 960, 540 - 40 * spr(lt, 20), 300, KF(t, { eyes: 'wide', sweat: 1 })); },
  fxs: [{ d: 0, text: '!?', x: 1260, y: 260, size: 160, len: 0.8 }] });
add(at('S05', 0.1), { id: 'p3_hands', cam0: CU(960, 540, 1.8), bg: () => STAGE.classroom(), bgKey: 'cls_hands',
  draw: (lt, t) => { A.push(); A.reset(); const j = 4 * Math.sin(t * 40); for (const sx of [-1, 1]) { A.limb(960 + sx * 520, 1200, 960 + sx * 200 + j, 640, 34, 26, { fill: '#f1c9a5', w: 1.6 }); A.ell(960 + sx * 190 + j, 600, 60, 74, { fill: '#f1c9a5', w: 1.6 }); for (let f = 0; f < 4; f++) A.limb(960 + sx * (160 + f * 22) + j, 560, 960 + sx * (150 + f * 26) + j, 470 - (f === 1 || f === 2 ? 20 : 0), 12, 10, { fill: '#f1c9a5', w: 1.2 }); A.limb(960 + sx * 250 + j, 620, 960 + sx * 300 + j, 540, 13, 11, { fill: '#f1c9a5', w: 1.2 }); A.limb(960 + sx * 520, 1200, 960 + sx * 360, 960, 52, 44, { fill: '#fbfaf5', w: 1.6 }); } A.pop(); } });
add(at('N09', 0.1), { id: 'p3_run', cam0: WIDE, bg: () => STAGE.corridor(), bgKey: 'corr',
  draw: (lt, t) => { const k = lt / (end('run') - at('N09', 0.1)); P('kla', lerp(-100, 2000, k), 1, mix(PO.run, Object.assign({}, PO.run, { legF: [-0.6, -1.0], legB: [0.9, -1.1], armF: [0.9, 1.4], armB: [-0.6, 1.6] }), 0.5 + 0.5 * Math.sin(tq(lt) * 16)), { eyes: 'wide', sweat: 1 }); } });
add(at('mirror', 0), { id: 'p3_mirror', cam0: WIDE, bg: () => STAGE.bathroom(), bgKey: 'bath',
  cam: (lt) => aim({ cam0: WIDE }, 960, 420, 1.0 + 0.25 * ease(lt / 2.2)), draw: (lt, t) => { FACE('kla', 960, 380, 260, KF(t, { eyes: 'wide', sweat: 1, mouth: lt > 0.8 ? Math.max(0.3, mouth('S', t)) : 0 })); } });
add(at('shadowbox', 0), { id: 'p3_shadow', cam0: CU(900, 620, 1.3), bg: () => STAGE.bathroom(), bgKey: 'bath_130',
  draw: (lt, t) => { const k = lt < 0.9 ? (Math.sin(tq(lt) * 14) > 0 ? 1 : 0) : 0; P('kla', 860, 1, lt < 1.0 ? mix(PO.guard, PO.jab, k) : PO.pant, KF(t, { sweat: lt > 1, mouth: lt > 1 ? Math.max(0.3, mouth('S', t)) : 0 })); if (lt > 1) sweatDrops(900, 380, t); } });
add(at('pondbehind', 0), { id: 'p3_pond', cam0: CU(800, 620, 1.3), bg: () => STAGE.bathroom(), bgKey: 'bath_130b',
  draw: (lt, t) => { P('kla', 960, 1, PO.pant, KF(t, { sweat: 1 })); P('pond', 560, 1, PO.stand, { mouth: mouth('P', t), blink: blink(t, 0.3) }); if (lt > end('P01') - at('pondbehind', 0)) {} } });
// ---------------- PART 4: Kla's life (classroom, break)
add(at('P02'), { id: 'p4_twoShot', cam0: CU(900, 620, 1.35), bg: () => STAGE.classroom(), bgKey: 'cls_135',
  draw: (lt, t) => { SCH.desk(560, G, DK); SCH.desk(1080, G, DK); P('pond', 760, -1, PO.sit, { mouth: mouth('P', t), blink: blink(t, 0.3) }); P('kla', 1040, 1, PO.sit, KF(t, { look: -1 })); } });
add(at('S08'), { id: 'p4_who', cam0: CU(960, 470, 2.4), bg: () => STAGE.classroom(), bgKey: 'cls_cu', draw: (lt, t) => FACE('kla', 960, 520, 290, KF(t, { look: -1 })) });
add(at('P03'), { id: 'p4_whisper', cam0: CU(960, 470, 2.4), bg: () => STAGE.classroom(), bgKey: 'cls_cu2', draw: (lt, t) => FACE('pond', 960, 520, 290, { mouth: mouth('P', t), sweat: 1, look: Math.sin(tq(lt) * 3) > 0 ? 1 : -1 }) });
add(at('N10', 0.1), { id: 'p4_bag', cam0: WIDE, bg: () => STAGE.flat('#c98d52', '#a8703e'), bgKey: 'desk_top',
  draw: (lt, t) => { const k = ease(lt / 1.6); A.rect(380, 260, 700, 520, { fill: '#2a3a5e', w: 1.6 }); A.rect(400, 280, 660, 120, { fill: '#33476e', w: 1 }); bookProp(lerp(730, 1260, k), lerp(520, 560, k), 340, lerp(0.2, -0.05, k)); } });
add(at('openbook', 0), { id: 'p4_page1', cam0: WIDE, bg: () => STAGE.flat('#c98d52', '#a8703e'), bgKey: 'desk_top',
  cam: (lt) => ({ p: 1 + 0.06 * lt }), draw: () => { SCH.sketchbook(960, 560, 640, 0); },
  fxs: [{ d: 1.0, text: 'สักวันจะเก่ง<br>แบบพี่แสงชัย!', x: 1320, y: 520, size: 70, rot: -3, html: true, len: 9, cls: 'hand' }] });
add(at('S09'), { id: 'p4_surprised', cam0: CU(960, 470, 2.4), bg: () => STAGE.classroom(), bgKey: 'cls_cu', draw: (lt, t) => FACE('kla', 960, 520, 290, KF(t, { eyes: 'wide' })) });
add(at('lastpage', 0.4), { id: 'p4_lastpage', cam0: WIDE, bg: () => STAGE.flat('#c98d52', '#a8703e'), bgKey: 'desk_top',
  cam: (lt) => ({ p: 1.05 + 0.08 * ease(lt / 3) }), draw: () => { A.poly([[400, 180], [1520, 190], [1530, 930], [390, 920]], { fill: '#fbf7ec', w: 1.6, curv: 0.05 }); for (let i = 0; i < 9; i++) A.stroke([[460, 260 + i * 75], [1460, 262 + i * 75]], { ink: '#d8d2c2', w: 0.5, curv: 0 }); },
  fxs: [{ d: 0.6, text: 'มวยมีไว้<br>ปกป้องคน', x: 960, y: 540, size: 150, rot: -2, html: true, len: 9, cls: 'hand' }] });
add(at('overlay', 0), { id: 'p4_memory', cam0: CU(960, 470, 2.4), bg: () => STAGE.gym(), bgKey: 'gym_cu2', sepia: true,
  draw: (lt, t) => FACE('kidK', 960, 520, 280, { mood: 'sad', look: 1, blink: blink(t, 0.6) }) });
add(at('S10'), { id: 'p4_realize', cam0: CU(960, 470, 2.4), bg: () => STAGE.classroom(), bgKey: 'cls_cu', draw: (lt, t) => FACE('kla', 960, 520, 290, KF(t, { mood: 'sad', tear: 1 })) });
add(at('doorbang', 0), { id: 'p4_bang', cam0: WIDE, bg: () => STAGE.classroom(), bgKey: 'cls',
  cam: (lt, t) => Object.assign(aim({ cam0: WIDE }, 1200, 600, 1.1), shake(t, 10 * Math.max(0, 1 - lt / 0.4))), draw: (lt, t) => { seated(t); },
  fxs: [{ d: 0, text: 'ปัง!!', x: 1500, y: 300, size: 170, len: 0.8 }] });
// ---------------- PART 5: bully #1 (classroom)
const klaDesk = (t, face = {}, pose = PO.sit) => { SCH.desk(800, G, DK); P('kla', 1000 - 60, -1, pose, KF(t, face)); };
add(at('B02', 0.05), { id: 'p5_slam', cam0: CU(1000, 600, 1.2), bg: () => STAGE.classroom(), bgKey: 'cls_120',
  cam: (lt, t) => Object.assign({ p: 1 }, shake(t, 9 * Math.max(0, 1 - lt / 0.35))),
  draw: (lt, t) => { P('jo', 1500, -1, PO.stand, { mood: 'smirk' }); P('te', 1660, -1, PO.stand, { mood: 'smirk' }); klaDesk(t, { look: 1 }); P('boss', 1180, -1, PO.slam, { anger: 1, mouth: mouth('B', t) }); },
  fxs: [{ d: 0, text: 'ปึง!', x: 1000, y: 380, size: 130, len: 0.6 }] });
add(at('N14', 0.1), { id: 'p5_gang', cam0: CU(1300, 560, 1.4), bg: () => STAGE.classroom(), bgKey: 'cls_gang',
  cam: (lt) => ({ p: 1 + 0.03 * lt, rot: 0.02 }), tag: { text: 'บอส', sub: 'หัวโจก ม.5', col: '#ff8a80', at: 0.2 },
  draw: (lt, t) => { P('jo', 1460, -1, PO.stand, { mood: 'smirk', blink: blink(t, 0.4) }); P('te', 1640, -1, Object.assign({}, PO.stand, { head: -0.1 }), { mood: 'smirk', blink: blink(t, 0.8) }); P('boss', 1200, -1, PO.stand, { anger: 0.7, blink: blink(t, 0.1) }); } });
add(at('S11'), { id: 'p5_calm', cam0: CU(960, 470, 2.4), bg: () => STAGE.classroom(), bgKey: 'cls_cu', draw: (lt, t) => FACE('kla', 960, 520, 290, KF(t, { eyes: 'shut', mood: 'calm' })) });
add(at('S12'), { id: 'p5_no', cam0: CU(1000, 600, 1.2), bg: () => STAGE.classroom(), bgKey: 'cls_120',
  draw: (lt, t) => { klaDesk(t, { look: 1 }); P('boss', 1180, -1, PO.slam, { anger: 0.5, eyes: 'wide' }); } });
add(at('B03'), { id: 'p5_bossLaugh', cam0: CU(960, 470, 2.4), bg: () => STAGE.classroom(), bgKey: 'cls_cu2', draw: (lt, t) => FACE('boss', 960, 520, 290, { mood: 'smirk', mouth: mouth('B', t), anger: 0.4 }) });
add(at('flick', 0), { id: 'p5_flick', cam0: CU(1080, 520, 1.7), bg: () => STAGE.classroom(), bgKey: 'cls_170',
  cam: (lt, t) => Object.assign({ p: 1 }, shake(t, 6 * Math.max(0, 1 - Math.abs(lt - 0.35) / 0.2))),
  draw: (lt, t) => { klaDesk(t, { eyes: lt > 0.35 && lt < 0.5 ? 'shut' : 'normal' }, Object.assign({}, PO.sit, { head: lt > 0.35 && lt < 0.6 ? -0.25 : 0 })); P('boss', 1180, -1, mix(PO.stand, PO.flick, ease(lt / 0.3)), { mood: 'smirk' }); },
  fxs: [{ d: 0.35, text: 'เป๊าะ!', x: 940, y: 300, size: 120, len: 0.6 }] });
add(at('J01'), { id: 'p5_joLaugh', cam0: WIDE, bg: () => STAGE.classroom(), bgKey: 'cls',
  cam: () => aim({ cam0: WIDE }, 1200, 600, 1.15), draw: (lt, t) => { backCrowd(t, 'laugh', [260, 520, 1500, 1760]); klaDesk(t); P('boss', 1180, -1, PO.laugh, { mood: 'happy', eyes: 'shut', mouth: 0.4 }); P('jo', 1420, -1, PO.laugh, { mood: 'happy', mouth: mouth('J', t) }); P('te', 1620, -1, PO.laugh, { mood: 'happy', eyes: 'shut', mouth: 0.5 }); } });
add(at('S13'), { id: 'p5_smile', cam0: CU(960, 470, 2.4), bg: () => STAGE.classroom(), bgKey: 'cls_cu', draw: (lt, t) => FACE('kla', 960, 520, 290, KF(t, { mood: 'happy' })) });
add(at('B04'), { id: 'p5_threat', cam0: CU(1080, 430, 1.9), bg: () => STAGE.classroomTense(), bgKey: 'cls_tense_190',
  cam: (lt) => ({ p: 1 + 0.06 * lt, rot: -0.04 }), draw: (lt, t) => { klaDesk(t, { look: 1 }); P('boss', 1130, -1, Object.assign({}, PO.slam, { lean: 0.4, head: 0.2 }), { anger: 1, mouth: mouth('B', t) }); vignette(130); } });
// ---------------- PART 6: bully #2 + night training
add(at('N15', 0.1), { id: 'p6_back', cam0: WIDE, bg: () => STAGE.backyard(), bgKey: 'back',
  draw: (lt, t) => { P('kla', 900, 1, PO.meek, {}); P('boss', 1200, -1, PO.stand, { mood: 'smirk' }); P('te', 1420, -1, PO.laugh, { mood: 'happy' }); } });
add(at('dump', 0), { id: 'p6_dump', cam0: CU(1000, 600, 1.3), bg: () => STAGE.backyard(), bgKey: 'back_130',
  draw: (lt, t) => { P('kla', 900, 1, PO.meek, { eyes: 'shut' }); P('jo', 1120, -1, { armF: [2.8, 0.3], armB: [2.7, 0.4], handF: 'open', handB: 'open' }, { mood: 'happy', mouth: 0.4 });
    A.rect(960, 360, 120, 90, { fill: '#2a3a5e', w: 1.2 }); for (let i = 0; i < 5; i++) { const k = clamp01(lt * 1.5 - i * 0.15); A.rect(980 + i * 22 - k * 60 * (i % 2 ? 1 : -1), 460 + k * 420, 60, 44, { fill: ['#e8d8b8', '#8ecae6', '#f4a3a8', '#b8e0a8', '#3c5a8a'][i], w: 1 }); } },
  fxs: [{ d: 0.3, text: 'ตุบ ตับ!', x: 760, y: 360, size: 110, len: 0.8 }] });
add(at('T01'), { id: 'p6_teMock', cam0: CU(960, 470, 2.4), bg: () => STAGE.backyard(), bgKey: 'back_cu', draw: (lt, t) => FACE('te', 960, 520, 290, { mood: 'happy', mouth: mouth('T', t), eyes: Math.sin(tq(lt) * 6) > 0 ? 'shut' : 'normal' }) });
add(at('N16', 0.1), { id: 'p6_pickup', cam0: CU(900, 640, 1.3), bg: () => STAGE.backyard(), bgKey: 'back_130',
  draw: (lt, t) => { const k = clamp01((lt - 1.6) / 2); if (k <= 0) P('kla', 900, 1, { lean: 0.9, armF: [0.8, 0.2], legF: [0.5, -1.2], legB: [-0.4, -1.0], head: 0.3 }, {}); else P('kla', 900 + k * 700, 1, walk(lt), {}); } });
add(at('N17', 0.1), { id: 'p6_night', cam0: WIDE, bg: () => STAGE.kidroom(), bgKey: 'kid',
  cam: (lt) => aim({ cam0: WIDE }, 1200, 560, 1.05 + 0.05 * lt), draw: (lt, t) => { P('kla', 1100, 1, PO.guard, { blink: blink(t, 0.1) }); } });
add(at('pushups', 0), { id: 'p6_push', cam0: CU(900, 760, 1.5), bg: () => STAGE.kidroom(), bgKey: 'kid_150',
  draw: (lt, t) => { const k = Math.sin(tq(lt) * 6); const fall = lt > end('S14') - at('pushups', 0) - 0.4; P('kla', 900, 1, fall ? Object.assign({}, PO.down, { lieDir: -1, armF: [2.9, 0.4] }) : mix(PO.pushUp, PO.pushDown, 0.5 + 0.5 * k), KF(t, { sweat: 1, eyes: fall ? 'shut' : 'normal' })); if (!fall) sweatDrops(980, 600, t); },
  fxs: [{ d: 0.2, text: '1...', x: 600, y: 300, size: 90, len: 0.5 }, { d: 0.7, text: '2...', x: 700, y: 280, size: 90, len: 0.5 }] });
add(at('mirrortrain', 0), { id: 'p6_train', cam0: CU(1200, 560, 1.25), bg: () => STAGE.kidroom(), bgKey: 'kid_125',
  draw: (lt, t) => { const beat = Math.floor(lt / 0.6) % 3; const pose = [PO.guard, PO.jab, PO.teepChamber][beat]; P('kla', 1100, 1, pose, KF(t, { eyes: 'fierce', sweat: 1 })); } });
add(at('N18', 0.1), { id: 'p6_cal', cam0: WIDE, bg: () => STAGE.flat('#2f3554', '#3c4266'), bgKey: 'flat_night',
  cam: (lt) => ({ p: 1 + 0.06 * lt }), draw: () => { A.rect(560, 160, 800, 760, { fill: '#fbf7ec', w: 1.6 }); A.rect(560, 160, 800, 150, { fill: '#c8343a', w: 1.2 }); for (let i = 0; i < 7; i++) { const x = 620 + (i % 4) * 180, y = 360 + Math.floor(i / 4) * 240; A.rect(x, y, 140, 190, { fill: '#ffffff', w: 0.8 }); if (i < 6) { A.stroke([[x + 10, y + 10], [x + 130, y + 180]], { ink: '#c8343a', w: 2.4 }); A.stroke([[x + 130, y + 10], [x + 10, y + 180]], { ink: '#c8343a', w: 2.4 }); } } },
  fxs: [{ d: 0.5, text: 'วันที่ 7', x: 1150, y: 720, size: 110, len: 9 }] });
// ---------------- PART 7: the line is crossed (classroom, tense)
add(at('grab', 0), { id: 'p7_grab', cam0: CU(1000, 600, 1.2), bg: () => STAGE.classroomTense(), bgKey: 'cls_tense_120',
  draw: (lt, t) => { SCH.desk(500, G, DK); P('pond', 700, 1, PO.sit, { look: 1 }); klaDesk(t, { look: 1 }); const k = ease(lt / 0.5); P('boss', 1180, -1, mix(PO.slam, PO.raise, k), { mood: 'smirk', mouth: mouth('B', t) }); if (k > 0.6) bookProp(1210, 400, 130, 0.2, true); else bookProp(820, G - 200, 90, 0); } });
add(at('P04'), { id: 'p7_pondUp', cam0: CU(860, 600, 1.3), bg: () => STAGE.classroomTense(), bgKey: 'cls_tense_130',
  draw: (lt, t) => { SCH.desk(500, G, DK); const k = ease(lt / 0.3); P('pond', 700, 1, mix(PO.sit, Object.assign({}, PO.point, { lean: 0.1 }), k), { anger: 0.9, mouth: mouth('P', t) }); P('boss', 1180, -1, PO.raise, { eyes: 'wide' }); bookProp(1210, 400, 130, 0.2, true); } });
add(at('B06'), { id: 'p7_shove', cam0: CU(900, 600, 1.25), bg: () => STAGE.classroomTense(), bgKey: 'cls_tense_125',
  cam: (lt, t) => Object.assign({ p: 1 }, shake(t, 10 * clamp01(1 - Math.abs(lt - 0.5) / 0.3))),
  draw: (lt, t) => { const k = ease((lt - 0.3) / 0.25), f = ease((lt - 0.45) / 0.6); P('boss', lerp(1040, 960, k), -1, mix(PO.raise, PO.shove, k), { anger: 1, mouth: mouth('B', t) });
    P('pond', lerp(780, 560, f), 1, f < 0.5 ? PO.hitBack : PO.down, { eyes: f > 0.5 ? 'dazed' : 'wide' }); if (f > 0.2) glassesProp(lerp(800, 320, f), lerp(560, G - 10, f), 30, f * 8); bookProp(1010, 420, 120, 0.2, true); },
  fxs: [{ d: 0.9, text: 'ตุบ!', x: 520, y: 560, size: 130, len: 0.6 }] });
add(at('N19', 0.1), { id: 'p7_pondDown', cam0: CU(560, 760, 2.0), bg: () => STAGE.classroomTense(), bgKey: 'cls_tense_floor',
  draw: (lt, t) => { P('pond', 560, 1, PO.down, { eyes: 'dazed' }); glassesProp(300, G - 10, 30, 0.3); FT.stars(500, 700, 40, t, 3); } });
add(at('stomp', 0), { id: 'p7_stomp', cam0: CU(960, 840, 2.2), bg: () => STAGE.classroomTense(), bgKey: 'cls_tense_floor2',
  cam: (lt, t) => Object.assign({ p: 1 }, shake(t, 12 * clamp01(1 - Math.abs(lt - 0.45) / 0.2))),
  draw: (lt, t) => { const dn = ease((lt - 0.2) / 0.25); A.push(); A.translate(960, G - 8); A.scale(1, 0.32); SCH.sketchbook(0, 0, 220, 0, false, dn > 0.9); A.pop();
    P('boss', 1020, -1, { legF: [lerp(0.9, 0.35, dn), lerp(-1.1, -0.1, dn)], legB: [-0.2, -0.1], groundF: false, lean: 0.1 }, { anger: 1 }); },
  fxs: [{ d: 0.45, text: 'แกร๊บ!', x: 760, y: 620, size: 120, len: 0.7 }] });
add(at('B07'), { id: 'p7_sneer', cam0: CU(960, 470, 2.4), bg: () => STAGE.classroomTense(), bgKey: 'cls_tense_cu', draw: (lt, t) => FACE('boss', 960, 520, 290, { mood: 'smirk', anger: 0.8, mouth: mouth('B', t) }) });
add(at('flashback', 0), { id: 'p7_flash', cam0: CU(960, 470, 2.4), bg: () => STAGE.gym(), bgKey: 'gym_cu', sepia: true, flash: 0.2,
  draw: (lt, t) => FACE('legend', 960, 520, 280, { mood: 'happy', blink: 0 }),
  fxs: [{ d: 0.1, text: '"มวยมีไว้ปกป้องคน"', x: 960, y: 900, size: 90, len: 9, rot: 0 }] });
add(at('bangs', 0), { id: 'p7_bangs', cam0: CU(960, 470, 2.6), bg: () => STAGE.burst('#5a0a14', '#14060a'), bgKey: 'burst_blood',
  cam: (lt) => ({ p: 1 + 0.06 * lt }), draw: (lt, t) => { const up = lt > 0.45; FACE('kla', 960, 520, 300, KF(t, { eyes: up ? 'fierce' : 'normal', bangsUp: up, blink: 0 }));
    if (!up) { const k = ease(lt / 0.45); A.limb(1300, 1100, lerp(1100, 980, k), lerp(380, 300, k), 30, 24, { fill: '#f1c9a5', w: 1.6 }); } } });
add(at('N20', 0.1), { id: 'p7_rise', cam0: CU(940, 620, 1.3), bg: () => STAGE.classroomTense(), bgKey: 'cls_tense_130',
  cam: (lt) => ({ p: 1 + 0.05 * lt }), draw: (lt, t) => { const k = ease(lt / 1.2); SCH.desk(800 - 150, G, DK); P('kla', 960, 1, mix(PO.sit, PO.stand, k), { eyes: 'fierce' }, { lookOver: { bangsUp: true } }); P('boss', 1260, -1, PO.stand, { eyes: 'wide', sweat: 1 }); } });
add(at('wai', 0), { id: 'p7_wai', cam0: CU(960, 560, 1.6), bg: () => STAGE.classroomTense(), bgKey: 'cls_tense_160', tag: { text: 'ไหว้ครู', sub: 'ก่อนออกอาวุธ', col: '#ffd23f', at: 0.2 },
  draw: (lt, t) => { P('kla', 960, 1, PO.wai, { eyes: 'shut' }, { lookOver: { bangsUp: true } }); } });
add(at('stance', 0), { id: 'p7_stance', cam0: WIDE, bg: () => STAGE.classroomTense(), bgKey: 'cls_tense', hook: '...จนกระทั่งวันนี้', vig: 0.5,
  cam: (lt) => aim({ cam0: WIDE }, 900, 640, 1.05 + 0.06 * ease(lt / 2), { rot: -0.03 }), draw: (lt, t) => { hookScene(t, lt > 1.0 ? 'shout' : 'hook'); vignette(90); } });
// ---------------- PART 8: the fight — ONE continuous moving camera in the classroom; cutaways only for reactions
const F0 = at('J02', 0.05);
const tm = n => (DATA.lines[n] || DATA.marks[n]).start - F0, te_ = n => (DATA.lines[n] || DATA.marks[n]).end - F0;
const FX = { kla: 820 };
function fightState(lt) { // returns positions/poses for everyone at fight-local time lt
  const st = { kla: { x: 820, f: 1, pose: PO.guard }, jo: { x: 1250, f: -1, pose: PO.stand, air: 0 }, te: { x: 1480, f: -1, pose: PO.stand }, boss: { x: 1680, f: -1, pose: PO.stand }, impact: null };
  const T1 = tm('teep'), T2 = te_('teep'); // teep beat
  // Jo: walks in, winds, punches; Kla: chamber -> teep (impact at T1+0.62) ; Jo flies back into the far desks
  const jHit = T1 + 0.62;
  if (lt < T1) { const k = ease(lt / T1); st.jo.x = lerp(1250, 1080, k); st.jo.pose = mix(walk(lt, 9), PO.punchWind, k); }
  else if (lt < jHit) { const k = ease((lt - T1) / 0.62); st.jo.x = lerp(1080, 1010, k); st.jo.pose = mix(PO.punchWind, PO.punch, k); st.kla.pose = k < 0.45 ? mix(PO.guard, PO.teepChamber, k / 0.45) : mix(PO.teepChamber, PO.teep, (k - 0.45) / 0.55); }
  else { const k = clamp01((lt - jHit) / 0.75); st.jo.x = lerp(1010, 1560, ease(k)); st.jo.air = 120 * Math.sin(Math.PI * Math.min(1, k)); st.jo.pose = k < 1 ? Object.assign({}, PO.hitBack, { air: st.jo.air }) : PO.down; st.jo.face = { eyes: k < 1 ? 'wide' : 'dazed' };
    st.kla.pose = lt < jHit + 0.35 ? PO.teep : mix(PO.teep, PO.guard, ease((lt - jHit - 0.35) / 0.4)); if (lt < jHit + 0.25) st.impact = { x: 1000, y: 690, t: lt - jHit }; }
  // Te: steps in (te mark), roundhouse (naka beat start), caught at +0.35, twisted and spun, lands at +1.25
  const N1 = tm('naka'), cK = N1 + 0.32, land = N1 + 1.3;
  if (lt >= tm('te') && lt < N1) { const k = ease((lt - tm('te')) / (N1 - tm('te'))); st.te.x = lerp(1480, 1090, k); st.te.pose = walk(lt, 10); }
  else if (lt >= N1 && lt < cK) { st.te.x = 1090; st.te.pose = mix(PO.guard, PO.kickHigh, ease((lt - N1) / 0.32)); st.kla.pose = mix(PO.guard, PO.catch, ease((lt - N1) / 0.32)); }
  else if (lt >= cK && lt < land) { const k = (lt - cK) / (land - cK); st.te.x = lerp(1090, 1180, k); st.te.pose = Object.assign({}, PO.kickHigh, { spin: -k * 3.6, air: 30 + 60 * Math.sin(Math.PI * k) }); st.kla.pose = mix(PO.catch, PO.twist, ease(k * 1.6)); st.te.face = { eyes: 'wide', mouth: 0.6 };
    if (k < 0.15) st.impact = { x: 930, y: 640, t: lt - cK, small: true }; }
  else if (lt >= land) { st.te.x = 1220; st.te.pose = Object.assign({}, PO.down, { lieDir: -1 }); st.te.face = { eyes: 'dazed' }; st.kla.pose = lt < land + 0.5 ? mix(PO.twist, PO.guard, ease((lt - land) / 0.5)) : st.kla.pose; }
  // Boss: roars (B08), charges, punch; Kla spins (spin mark) and lands the back heel (spinhit) — slow motion on contact
  const B0 = tm('B08'), SP = tm('spin'), HIT = tm('spinhit'), HIT1 = te_('spinhit');
  if (lt >= B0 && lt < HIT) { const k = clamp01((lt - B0) / (HIT - B0)); st.boss.x = lerp(1680, 1080, ease(k)); st.boss.pose = k < 0.75 ? mix(PO.run, Object.assign({}, PO.run, { legF: [-0.6, -1.0], legB: [0.9, -1.1] }), 0.5 + 0.5 * Math.sin(tq(lt) * 18)) : mix(PO.punchWind, PO.punch, (k - 0.75) / 0.25); st.boss.face = { anger: 1, mouth: 0.8 }; }
  if (lt >= SP && lt < HIT) { const k = (lt - SP) / (HIT - SP); st.kla.f = k < 0.45 ? 1 : -1; st.kla.pose = k < 0.45 ? mix(PO.guard, PO.spinTurn, k / 0.45) : mix(PO.spinTurn, PO.spinKick, ease((k - 0.45) / 0.55)); }
  if (lt >= HIT) { const k = clamp01((lt - HIT) / (HIT1 - HIT)); // slow-mo contact
    st.kla.f = -1; st.kla.pose = PO.spinKick; st.boss.x = 1080 + 40 * k; st.boss.pose = mix(PO.punch, PO.hitBack, ease(k)); st.boss.face = { eyes: 'wide', mouth: 0.9 }; st.impact = { x: 990, y: 640, t: (lt - HIT) * 0.25, big: true };
    if (lt > HIT1) { const c = clamp01((lt - HIT1) / 0.9); st.boss.x = lerp(1120, 1470, ease(c)); st.boss.pose = c < 1 ? Object.assign({}, PO.hitBack, { air: 150 * Math.sin(Math.PI * c), spin: -c * 0.8 }) : PO.down; st.impact = null;
      st.kla.pose = mix(PO.spinKick, PO.guard, ease(c)); st.kla.f = c < 0.5 ? -1 : 1; } }
  if (lt > tm('crash') + 0.3) { st.boss.x = 1470; st.boss.pose = Object.assign({}, PO.down, { air: -10 }); st.boss.face = { eyes: 'dazed' }; }
  return st;
}
function fightDraw(lt, t) {
  const s = fightState(lt);
  backCrowd(t, lt > tm('teepland') ? 'wow' : 'calm', [180, 420, 1500, 1780]); frontDesks([20, 1760]);
  P('jo', s.jo.x, -1, s.jo.pose, Object.assign({ anger: 0.8 }, s.jo.face || {}));
  P('te', s.te.x, -1, s.te.pose, Object.assign({ anger: 0.9 }, s.te.face || {}));
  P('boss', s.boss.x, -1, s.boss.pose, Object.assign({ anger: 0.9 }, s.boss.face || {}));
  P('kla', s.kla.x, s.kla.f, s.kla.pose, { eyes: 'fierce', anger: 0.3 }, { lookOver: { bangsUp: true } });
  if (s.impact) { const k = clamp01(s.impact.t / 0.25); FT.burst(s.impact.x, s.impact.y, (s.impact.big ? 150 : s.impact.small ? 70 : 110) * (0.6 + 0.6 * k), t * 3, '#fff6d8', 9); }
  if (lt > tm('spin') && lt < tm('spinhit')) FT.arc(820, 620, 150, -0.4, 3.6, 34, '#ffffff', 150);
  if (lt > tm('teep') + 0.4 && lt < tm('teep') + 0.7) FT.arc(900, 700, 90, -1.2, 0.4, 22, '#ffffff', 170);
  if (s.jo.pose === PO.down) FT.stars(1560, 790, 60, t); if (lt > tm('naka') + 1.4) FT.stars(1230, 800, 55, t + 1);
  if (lt > tm('crash') + 0.3) FT.stars(1470, 780, 70, t + 2);
}
function fightCam(lt, t) { // continuous camera: medium -> push on the teep -> follow Jo -> reframe on Te -> low push on the catch -> pan with Boss -> slow push on the spin
  const keys = [[0, 1000, 620, 1.25], [tm('teep') + 0.5, 960, 640, 1.55], [tm('teep') + 0.9, 1180, 640, 1.3], [te_('teepland'), 1150, 640, 1.2], [tm('naka'), 1000, 640, 1.45], [tm('naka') + 0.6, 1020, 680, 1.65], [te_('nakaland'), 1100, 640, 1.25],
    [tm('B08'), 1300, 600, 1.2], [tm('spin'), 1000, 620, 1.45], [tm('spinhit') + 0.1, 960, 600, 1.85], [te_('spinhit'), 980, 600, 1.9], [tm('crash'), 1250, 640, 1.2], [99, 1250, 640, 1.18]];
  let i = 0; while (i < keys.length - 2 && lt > keys[i + 1][0]) i++; const [a0, x0, y0, p0] = keys[i], [a1, x1, y1, p1] = keys[i + 1], k = ease(clamp01((lt - a0) / (a1 - a0)));
  const s = fightState(lt); let sh = { dx: 0, dy: 0 }; if (s.impact) sh = shake(t, (s.impact.big ? 22 : 14) * (1 - clamp01(s.impact.t / 0.3)), 31);
  const c = aim({ cam0: WIDE }, lerp(x0, x1, k), lerp(y0, y1, k), lerp(p0, p1, k), { rot: 0.025 * Math.sin(lt * 0.7) }); c.dx += sh.dx; c.dy += sh.dy; return c;
}
const fightShot = (id, t0) => ({ id, cam0: WIDE, bg: () => STAGE.classroomTense(), bgKey: 'cls_tense', cam: (lt, t) => fightCam(t - F0, t), draw: (lt, t) => fightDraw(t - F0, t), noSub: false });
add(F0, fightShot('p8_fightA'));
add(at('G01', 0.05), { id: 'p8_mew', cam0: CU(960, 470, 2.4), bg: () => STAGE.classroomTense(), bgKey: 'cls_tense_cu', draw: (lt, t) => FACE('mew', 960, 520, 290, { eyes: 'wide', mouthO: 0.4 + 0.3 * spr(lt, 18), blink: 0 }) });
add(at('te', 0.05), fightShot('p8_fightB'));
add(at('F01', 0.05), { id: 'p8_fern', cam0: CU(860, 470, 2.2), bg: () => STAGE.classroomTense(), bgKey: 'cls_tense_cu2', draw: (lt, t) => { FACE('nut', 640, 540, 250, { eyes: 'wide', mouthO: 0.5 }); FACE('fern', 1080, 520, 280, { eyes: 'wide', mouthO: 0.3 + 0.4 * spr(lt, 16) }); } });
add(at('boss', 0.05), fightShot('p8_fightC'));
// ---------------- PART 9: why?
add(at('pile', 0), { id: 'p9_pile', cam0: WIDE, bg: () => STAGE.classroomTense(), bgKey: 'cls_tense',
  cam: (lt) => aim({ cam0: WIDE }, 1150, 640, 1.25 - 0.1 * ease(lt / 1.4)), draw: (lt, t) => { backCrowd(t, 'wow', [180, 420, 1500, 1780]); frontDesks([20, 1760]); P('jo', 1560, -1, PO.down, { eyes: 'dazed' }); P('te', 1220, 1, Object.assign({}, PO.down, { lieDir: -1 }), { eyes: 'dazed' }); P('boss', 1470, -1, Object.assign({}, PO.down, { air: -10 }), { eyes: 'dazed' }); FT.stars(1560, 790, 60, t); FT.stars(1230, 800, 55, t + 1); FT.stars(1470, 780, 70, t + 2);
    P('kla', 820, 1, PO.guard, { eyes: 'fierce' }, { lookOver: { bangsUp: true } }); },
  fxs: [{ d: 0.1, text: 'ตุ้บ!', x: 1400, y: 560, size: 130, len: 0.7 }] });
add(at('X01'), { id: 'p9_class', cam0: CU(960, 470, 1.9), bg: () => STAGE.classroomTense(), bgKey: 'cls_tense_190',
  cam: (lt) => ({ p: 1 + 0.03 * lt }), draw: (lt, t) => { FACE('mew', 560, 560, 230, { eyes: 'wide', mouthO: 0.6 }); FACE('nut', 960, 540, 250, { eyes: 'wide', mouth: Math.max(0.3, mouth('X', t)) }); FACE('fern', 1360, 560, 230, { eyes: 'wide', mouthO: 0.7 }); } });
add(at('S17'), { id: 'p9_tired', cam0: CU(860, 620, 1.4), bg: () => STAGE.classroomTense(), bgKey: 'cls_tense_140',
  draw: (lt, t) => { const wob = 0.06 * Math.sin(tq(lt) * 20); P('kla', 860, 1, Object.assign({}, PO.pant, { legF: [0.2 + wob, -0.4], legB: [-0.18 - wob, -0.35] }), KF(t, { sweat: 1 }), { lookOver: { bangsUp: true } }); sweatDrops(900, 440, t); } });
add(at('S18'), { id: 'p9_hand', cam0: CU(760, 680, 1.4), bg: () => STAGE.classroomTense(), bgKey: 'cls_tense_hand',
  draw: (lt, t) => { P('pond', 560, 1, PO.down, { eyes: 'normal', look: 1 }); glassesProp(380, G - 10, 30, 0.3); P('kla', 820, -1, { lean: 0.5, head: 0.2, armF: [1.2, 0.3], handF: 'open', legF: [0.4, -0.5], legB: [-0.3, -0.3] }, KF(t, { mood: 'happy' }), { lookOver: { bangsUp: true } }); } });
add(at('P05'), { id: 'p9_pondAsk', cam0: CU(960, 470, 2.4), bg: () => STAGE.classroomTense(), bgKey: 'cls_tense_cu', draw: (lt, t) => FACE('pond', 960, 520, 290, { eyes: 'wide', mouth: mouth('P', t), look: 1 }) });
add(at('S19'), { id: 'p9_book', cam0: CU(960, 470, 2.2), bg: () => STAGE.classroom(), bgKey: 'cls_cu3',
  draw: (lt, t) => { FACE('kla', 960, 500, 270, KF(t, { mood: 'happy', bangsUp: true, eyes: 'normal' })); bookProp(1000, 880, 220, -0.1, false); } });
add(at('N24', 0.1), { id: 'p9_corridor', cam0: WIDE, bg: () => STAGE.corridor(), bgKey: 'corr',
  cam: (lt) => aim({ cam0: WIDE }, 1250, 480, 1.0 + 0.25 * ease(lt / 3.5)), draw: (lt, t) => { P('shadow', 1300, -1, PO.stand, { eyes: 'normal' }); vignette(150); } });
add(at('window', 0), { id: 'p9_mystery', cam0: CU(960, 470, 2.4), bg: () => STAGE.flat('#1a1622', '#0c0a10'), bgKey: 'dark',
  draw: (lt, t) => { FACE('shadow', 960, 520, 300, { mood: 'smirk', eyes: 'fierce', mouth: mouth('M', t) }); } });
add(at('N25', 0.1), { id: 'p9_next', cam0: WIDE, bg: () => STAGE.burst('#1a1a2e', '#06060c'), bgKey: 'burst_night', endq: ['ตอนต่อไป', 'แล้ว<b>กล้าตัวจริง</b><br>หายไปไหน?'], noSub: true, draw: () => {} });
add(at('N26', 0.1), { id: 'p9_question', cam0: WIDE, bg: () => STAGE.classroomTense(), bgKey: 'cls_tense', endq: ['เมนต์บอกหน่อย', 'สู้ตั้งแต่ครั้งแรก<br>หรือ <b>ทนแบบแสงชัย?</b>'], noSub: true,
  cam: (lt) => aim({ cam0: WIDE }, 1000, 600, 1.05), draw: (lt, t) => { hookScene(t, 'end'); vignette(170); } });
// ---- finalize: t1 = next t0; bubbles/fx from shot.fxs; move cards
S.sort((a, b) => a.t0 - b.t0); S.forEach((s, i) => { s.t1 = i + 1 < S.length ? S[i + 1].t0 : DATA.duration + 1; });
const FXS = []; S.forEach(s => (s.fxs || []).forEach(f => FXS.push({ t0: s.t0 + f.d, t1: Math.min(s.t1, s.t0 + f.d + (f.len || 0.7)), text: f.text, x: f.x, y: f.y, size: f.size, rot: f.rot, html: f.html, cls: f.cls })));
const EP = { shots: S, fx: FXS, bubbles: [],
  moves: [{ name: 'มอญยันหลัก', t0: DATA.marks.teep.start + 0.55, t1: DATA.marks.teepland.end }, { name: 'นาคาบิดหาง', t0: DATA.marks.naka.start + 0.4, t1: DATA.marks.nakaland.end }, { name: 'จระเข้ฟาดหาง', t0: DATA.marks.spinhit.start, t1: DATA.marks.crash.end }],
  NAMES: { S: 'แสงชัย (ในร่างกล้า)', B: 'บอส', P: 'ปอนด์', J: 'โจ้', T: 'เต้', G: 'หมิว', F: 'เฟิร์น', X: 'นัท', C: 'ครู', M: '???', K: 'เด็กคนนั้น' },
  COL: { N: '#ffffff', S: '#ffd23f', B: '#ff8a80', P: '#9fe3ff', J: '#ffb36b', T: '#ffb36b', G: '#f7b2d9', F: '#f7b2d9', X: '#c8f7a8', C: '#e0c8ff', M: '#b0a8c8', K: '#ffe7a0' } };
// before the switch into Kla's body, Saengchai's lines are his own (no "in Kla's body" label)
EP.NAMES_AT = (v, t) => (v === 'S' && t < DATA.lines.S04.start - 0.2 ? 'แสงชัย' : EP.NAMES[v]);
