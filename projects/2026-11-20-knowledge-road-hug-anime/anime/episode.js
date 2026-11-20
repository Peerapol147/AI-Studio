// EP "นึกว่าจะต่อยกัน" — shot list. Times come from episode-data.json (line starts / caption chunks), not by hand.
/* global A, CH, SC, DATA */
const L = id => DATA.lines[id];
const CAP = (txt) => DATA.captions.find(c => c.text === txt).t0;
const cut = (txt, lead = 0.08) => +(CAP(txt) - lead).toFixed(3);
const clamp01 = v => Math.max(0, Math.min(1, v));
function mouth(v, t) { const e = DATA.mouth[v]; const f = Math.floor(t * DATA.fps / 2) * 2; const x = Math.max(e[f] || 0, e[f + 1] || 0); return clamp01((x - 0.1) * 1.5); }
function blink(t, s) { return ((t * 0.31 + s) % 1) < 0.04 ? 1 : 0; }
const tq = t => Math.floor(t * 12) / 12; // character motion on twos
const ease = A.ease, lerp = A.lerp;
const GROUND = 1330, VG = 1268;
const shake = (t, amp, f = 23) => ({ dx: amp * Math.sin(t * f) + amp * 0.5 * Math.sin(t * f * 1.7), dy: amp * Math.cos(t * f * 1.3) });
// ---- standard side scene (vehicles always on the ground behind the people)
function vehicles(t, carX = 650) { CH.motoSide(40, VG, 340, 1, t); CH.carSide(carX, VG, 540, 1, '#b9364a', t, true); }
function duo(t, R, D) {
  CH.person(Object.assign({ who: 'R', x: 440, y: GROUND, s: 600, f: 1 }, R));
  CH.person(Object.assign({ who: 'D', x: 680, y: GROUND, s: 590, f: -1 }, D));
}
const ANGRY_R = (t) => ({ anger: 1, mouth: Math.max(0.12, mouth('R', t)), blink: blink(t, 0.1) });
const ANGRY_D = (t) => ({ anger: 0.8, mouth: Math.max(0.1, mouth('D', t)), blink: blink(t, 0.6) });
// ---- POV extras
function povFigures(t, phase) { // phase: 'arrive' | 'argue' | 'hug'
  CH.motoSide(360, 1012, 70, 1, t); CH.carRear(395, 1080, 210, '#b9364a', t, true);
  const s = 92, y = 1052;
  if (phase === 'arrive') {
    const k = ease((tq(t) - 0.5) / 1.6);
    CH.person({ who: 'R', x: lerp(340, 330, k), y, s, f: 1, stride: k > 0 && k < 1 ? 0.5 : 0, phase: t * 9 });
    if (k > 0.05) CH.person({ who: 'D', x: lerp(500, 400, k), y: y + 6, s, f: -1, stride: k < 1 ? 0.5 : 0, phase: t * 9 });
  } else if (phase === 'argue') {
    const j = Math.sin(tq(t) * 30) * 2;
    CH.person({ who: 'R', x: 335 + j, y, s, f: 1, lean: 0.12, armFront: [1.4, 0.1], hand: 'point', anger: 1, mouth: 0.6 });
    CH.person({ who: 'D', x: 398 - j, y: y + 6, s, f: -1, lean: 0.1, armFront: [1.2, 0.6], armBack: [1.0, 0.8], hand: 'open', handBack: 'open', anger: 1, mouth: 0.6 });
  } else {
    CH.person({ who: 'R', x: 352, y, s, f: 1, lean: 0.08, armFront: [1.3, 0.9], eyesClosed: true, mood: 'happy' });
    CH.person({ who: 'D', x: 382, y: y + 6, s, f: -1, lean: 0.08, armFront: [1.3, 0.9], eyesClosed: true, mood: 'happy' });
  }
}
function phoneInHand(t, x = 760, y = 1640, shakeAmp = 2) {
  const j = shakeAmp * Math.sin(t * 31);
  A.push(); A.reset(); A.translate(x + j, y); A.rotate(-0.1);
  A.poly([[-150, 120], [-120, -40], [-60, -90], [40, -60], [150, 80], [170, 400], [-160, 400]], { fill: '#e6b48f', w: 1.6, curv: 0.4 }); // hand
  A.poly([[-110, -210], [110, -210], [110, 210], [-110, 210]], { fill: '#1d1b22', w: 1.6, curv: 0.12 });
  A.poly([[-96, -192], [96, -192], [96, 192], [-96, 192]], { fill: '#3a4a66', w: 0.6, curv: 0.08 });
  A.ell(-70, -166, 9, 9, { fill: Math.floor(t * 2) % 2 ? '#ff4b4b' : '#a83232', w: 0 }); // REC dot
  for (const [sx, sy] of [[-1, -1], [1, -1], [-1, 1], [1, 1]]) A.stroke([[sx * 80, sy * 150], [sx * 80, sy * 176], [sx * 54, sy * 176]], { ink: '#ffffff', w: 1.2, curv: 0 });
  for (const fy of [-40, 30, 100]) A.limb(-170, fy + 40, -100, fy, 26, 22, { fill: '#e6b48f', w: 1.4 }); // fingers over the left edge
  A.limb(160, 120, 104, 40, 26, 22, { fill: '#e6b48f', w: 1.4 }); // thumb
  A.pop();
}
function speedLines(t, n = 26, col = '#fff2dc') { A.push(); A.reset(); for (let i = 0; i < n; i++) { const a = (i / n) * Math.PI * 2 + Math.floor(t * 12) * 0.37, r0 = 700 + 120 * Math.sin(i * 7.1); A.stroke([[540 + Math.cos(a) * r0, 900 + Math.sin(a) * r0], [540 + Math.cos(a) * (r0 + 500), 900 + Math.sin(a) * (r0 + 500)]], { ink: col, w: 1.8, curv: 0 }); } A.pop(); }
function passingCar(lt, at, y = 1880) { // foreground car whoosh (rests on the near lane, moves fast)
  const k = (lt - at) / 0.45; if (k < 0 || k > 1) return;
  const x = lerp(-900, 1500, k); CH.carSide(x, y, 900, 1, '#5b6c8f', 0, false);
  for (let i = 0; i < 9; i++) A.stroke([[x - 200 - i * 60, y - 120 - i * 28], [x - 700 - i * 60, y - 120 - i * 28]], { ink: '#fff1d8', w: 1.4, curv: 0 });
}
// ---------- shots ----------
const SIDE = { zoom: 1.0, cx: 560, cy: 1000 };
const HOOK = { zoom: 1.9, cx: 556, cy: 840 };
const CLOSE = { zoom: 1.0, cx: 540, cy: 960 };
const t_hook_end = L('N2').start;
const hookDraw = (lt, t) => { // the face-off (used for the hook, the escalation and the loop ending)
  vehicles(t);
  const k = ease(tq(lt) / 0.9), jab = 0.06 * Math.sin(tq(lt) * 9);
  duo(t, { x: 440 + k * 6, lean: 0.1 + k * 0.04 + jab * 0.3, armFront: [1.35, 0.15], hand: 'point', armBack: [0.25, 0.5], ...ANGRY_R(t) },
    { x: 680 - k * 4, lean: 0.1, armFront: [0.35, 1.0], armBack: [0.3, 0.9], ...ANGRY_D(t), sweat: true });
  CH.angerMark(410, 690, 30, t); CH.angerMark(722, 700, 26, t + 0.3);
  CH.shoutLines(560, 790, 70, 8, tq(t));
};
const EP = { shots: [
  { id: 'S01_hook', t0: 0, t1: t_hook_end, cam0: HOOK, bg: () => SC.side('tense'), bgKey: 'hook_tense', cam: lt => ({ p: 1 + 0.05 * ease(lt / 1.8), ...shake(lt, 3) }), draw: hookDraw },
  { id: 'S02_wide', t0: t_hook_end, t1: cut('รถเก๋งคันหน้า'), cam0: { zoom: 1.0, cx: 760, cy: 980 }, bg: () => SC.wide('dusk'),
    cam: lt => ({ p: 1.02, dx: lerp(70, -70, lt / 1.4) }),
    draw: (lt, t) => { for (let i = 0; i < 4; i++) { const x = ((lt * 260 + i * 470) % 2200) - 300; A.poly([[x, 960], [x + 70, 960], [x + 64, 938], [x + 10, 936]], { fill: i === 1 ? '#b9364a' : '#4d4a62', w: 0.8, curv: 0.3 }); A.ell(x + 72, 952, 6, 4, { fill: '#fff3c8', w: 0 }); } } },
  { id: 'S03_pov', t0: cut('รถเก๋งคันหน้า'), t1: cut('แล้วลงมาเถียงกัน'), cam0: CLOSE, bg: () => SC.pov('dusk'), bgKey: 'pov',
    cam: lt => ({ p: 1 + 0.04 * ease(lt / 3), ...shake(lt, 2, 7) }),
    draw: (lt, t) => { povFigures(lt, 'arrive'); SC.interior(); phoneInHand(t); } },
  { id: 'S04_walk', t0: cut('แล้วลงมาเถียงกัน'), t1: L('R1').start - 0.05, cam0: { zoom: 1.08, cx: 560, cy: 1000 }, bg: () => SC.side('dusk'), bgKey: 'side_dusk_108',
    cam: lt => ({ p: 1 + 0.03 * lt }),
    draw: (lt, t) => { vehicles(t); const k = ease(tq(lt) / 1.2), w = k < 1;
      duo(t, { x: lerp(300, 430, k), stride: w ? 0.6 : 0, phase: lt * 10, armFront: [w ? 0.4 * Math.sin(lt * 10) : 0.2, 0.3], anger: 0.8 },
        { x: lerp(840, 690, k), stride: w ? 0.6 : 0, phase: lt * 10 + 1, armFront: [w ? 0.4 * Math.sin(lt * 10 + 1) : 0.2, 0.3], anger: 0.6 }); } },
  { id: 'S05_riderCU', t0: L('R1').start - 0.05, t1: cut('มึงต้องเปิดก่อน!'), cam0: CLOSE, bg: () => SC.close('tense'), bgKey: 'close_tense', label: { text: 'ไรเดอร์', who: 'R' },
    cam: (lt, t) => ({ p: 1 + 0.06 * ease(lt / 2), ...shake(t, 4 * mouth('R', t)) }),
    draw: (lt, t) => { speedLines(t); CH.face({ who: 'R', x: 540, y: 800, s: 480, anger: 1, mouth: mouth('R', t), blink: blink(t, 0.2) }); CH.angerMark(760, 520, 46, t); } },
  { id: 'S06_blinker', t0: cut('มึงต้องเปิดก่อน!'), t1: L('D1').start - 0.03, cam0: { zoom: 1.45, cx: 560, cy: 900 }, bg: () => SC.side('tense'), bgKey: 'side_tense_145',
    cam: lt => ({ p: 1 + 0.03 * lt }),
    draw: (lt, t) => { vehicles(t); const blinkHand = Math.floor(tq(lt) * 5) % 2 === 0;
      duo(t, { lean: 0.08, armFront: [2.1, 0.5], hand: blinkHand ? 'open' : 'fist', armBack: [0.3, 0.4], ...ANGRY_R(t) }, { ...ANGRY_D(t), armFront: [0.2, 0.3], sweat: true });
      CH.shoutLines(470, 640, 50, 6, tq(t), '#ffd23f'); } },
  { id: 'S07_driverCU', t0: L('D1').start - 0.03, t1: L('R2').start - 0.03, cam0: CLOSE, bg: () => SC.close('dusk'), bgKey: 'close_dusk', label: { text: 'คนขับเก๋ง', who: 'D' },
    cam: (lt, t) => ({ p: 1.04 - 0.04 * ease(lt / 1.5), ...shake(t, 3 * mouth('D', t)) }),
    draw: (lt, t) => { CH.face({ who: 'D', x: 540, y: 800, s: 470, anger: 0.5, mouth: mouth('D', t), blink: blink(t, 0.5), sweat: true, shrug: -10 });
      for (const sx of [-1, 1]) { const hx = 540 + sx * 300, hy = 1140 - 40 * ease(lt / 0.3); A.ell(hx, hy, 70, 92, { fill: '#f3c7a1', w: 1.5 }); for (let f = -1.5; f <= 1.5; f++) A.limb(hx + f * 30, hy - 60, hx + f * 36, hy - 130, 15, 13, { fill: '#f3c7a1', w: 1.3 }); } } },
  { id: 'S08_rightLane', t0: L('R2').start - 0.03, t1: L('N3').start - 0.05, cam0: SIDE, bg: () => SC.side('tense'), bgKey: 'side_tense_100',
    cam: lt => ({ p: 1.02 + 0.03 * lt }),
    draw: (lt, t) => { vehicles(t); duo(t, { lean: -0.05, armFront: [2.4, 0.1], hand: 'point', ...ANGRY_R(t) }, { ...ANGRY_D(t), tilt: -0.15 });
      passingCar(lt, 0.55); } },
  { id: 'S09_povArgue', t0: L('N3').start - 0.05, t1: cut('ฉันนี่กำโทรศัพท์'), cam0: { zoom: 1.55, cx: 400, cy: 1000 }, bg: () => SC.pov('tense'), bgKey: 'pov_tense_155',
    cam: (lt, t) => ({ p: 1 + 0.05 * ease(lt / 1.7), ...shake(t, 4, 9) }),
    draw: (lt, t) => { povFigures(lt, 'argue'); CH.shoutLines(366, 960, 40, 8, tq(t)); SC.interior(); phoneInHand(t, 760, 1640, 6); } },
  { id: 'S10_grip', t0: cut('ฉันนี่กำโทรศัพท์'), t1: L('D2').start - 0.03, cam0: CLOSE, bg: () => { SC.close('tense'); SC.interior(); }, bgKey: 'grip',
    cam: (lt, t) => ({ p: 1 + 0.08 * ease(lt / 1.8), ...shake(t, 5, 37) }),
    draw: (lt, t) => { phoneInHand(t, 540, 980, 8);
      for (let i = 0; i < 3; i++) { const k = ((lt * 1.4 + i * 0.33) % 1); A.push(); A.reset(); A.poly([[300 + i * 220, 620 + k * 200], [312 + i * 220, 650 + k * 200], [300 + i * 220, 664 + k * 200], [288 + i * 220, 650 + k * 200]], { fill: '#bfe6ff', w: 1, curv: 0.6 }); A.pop(); } } },
  { id: 'S11_closer', t0: L('D2').start - 0.03, t1: L('R3').start - 0.03, cam0: { zoom: 1.5, cx: 560, cy: 900 }, bg: () => SC.side('tense'), bgKey: 'side_tense_150',
    cam: (lt, t) => ({ p: 1 + 0.04 * lt, ...shake(t, 3 * mouth('D', t)) }),
    draw: (lt, t) => { vehicles(t); const k = ease(tq(lt) / 0.5);
      duo(t, { lean: -0.04 * k, ...ANGRY_R(t) }, { x: 690 - 20 * k, lean: 0.14 * k, armFront: [1.45, -0.4], armBack: [1.3, -0.3], hand: 'open', handBack: 'open', ...ANGRY_D(t) });
      CH.angerMark(735, 690, 26, t); } },
  { id: 'S12_faceoff', t0: L('R3').start - 0.03, t1: cut('ขับรถไม่ปลอดภัยอ่ะ!'), cam0: HOOK, bg: () => SC.side('tense'), bgKey: 'hook_tense',
    cam: (lt, t) => ({ p: 1.04 + 0.04 * lt, ...shake(t, 5 * mouth('R', t)) }), draw: hookDraw },
  { id: 'S13_riderXCU', t0: cut('ขับรถไม่ปลอดภัยอ่ะ!'), t1: L('R3').end, cam0: CLOSE, bg: () => SC.close('tense'), bgKey: 'close_tense',
    cam: (lt, t) => ({ p: 1.1 + 0.06 * ease(lt / 1.5), ...shake(t, 6 * mouth('R', t)) }),
    draw: (lt, t) => { speedLines(t, 34, '#ffe9c8'); CH.face({ who: 'R', x: 540, y: 820, s: 540, anger: 1, mouth: mouth('R', t), blink: 0 }); CH.angerMark(780, 510, 54, t); CH.angerMark(300, 560, 38, t + 0.2); } },
  { id: 'S14_silence', t0: L('R3').end, t1: L('D3').start - 0.03, cam0: { zoom: 1.12, cx: 560, cy: 1000 }, bg: () => SC.side('tense'), bgKey: 'side_tense_112',
    cam: lt => ({ p: 1 + 0.03 * lt }),
    draw: (lt, t) => { vehicles(t); duo(t, { lean: 0.06, anger: 1, mouth: 0, blink: 0 }, { lean: 0.06, anger: 0.9, mouth: 0, blink: 0, sweat: true }); passingCar(lt, 0.3); } },
  { id: 'S15_driverSoft', t0: L('D3').start - 0.03, t1: cut('รู้แล้ว...', 0.08) > cut('ปลอดภัยใช่ไหม') ? 0 : DATA.captions.filter(c => c.text === 'รู้แล้ว...')[1].t0 - 0.08, cam0: CLOSE, bg: () => SC.close('dusk'), bgKey: 'close_dusk',
    cam: lt => ({ p: 1.02 + 0.05 * ease(lt / 3.3) }),
    draw: (lt, t) => { const k = ease(lt / 2.5); const sigh = lt < 0.9;
      CH.face({ who: 'D', x: 540, y: 800 + 10 * k, s: 470, anger: 0.5 * (1 - k), mood: k > 0.5 ? 'sad' : 'calm', mouth: mouth('D', t), eyesClosed: sigh, blink: blink(t, 0.3), shrug: 14 * k }); } },
  { id: 'S16_sorry', t0: 0, t1: L('R4').start - 0.03, cam0: { zoom: 1.35, cx: 560, cy: 960 }, bg: () => SC.side('warm'), bgKey: 'side_warm_135',
    cam: lt => ({ p: 1 + 0.025 * lt }),
    draw: (lt, t) => { vehicles(t); const bow = ease((t - (CAP('กูขอโทษ') - 0.05)) / 0.4);
      duo(t, { lean: 0.02, anger: lerp(1, 0.3, ease(lt / 3)), mouth: 0, blink: blink(t, 0.2) },
        { lean: 0.05 + 0.2 * bow, tilt: 0.25 * bow, mood: 'sad', mouth: mouth('D', t), armFront: [0.5 + 0.3 * bow, 1.1], armBack: [0.5, 1.1], blink: blink(t, 0.7) });
      if (bow > 0.5) CH.sparkle(600, 640, 18, t); } },
  { id: 'S17_riderSoft', t0: L('R4').start - 0.03, t1: L('R4').end - 0.1, cam0: CLOSE, bg: () => SC.close('warm'), bgKey: 'close_warm',
    cam: lt => ({ p: 1.05 - 0.04 * ease(lt / 1.8) }),
    draw: (lt, t) => { const k = ease(lt / 1.4);
      for (let i = 0; i < 6; i++) CH.sparkle(160 + i * 160, 360 + 90 * Math.sin(i * 2.3 + t), 16, t + i);
      CH.face({ who: 'R', x: 540, y: 800, s: 480, anger: 0.4 * (1 - k), mood: k > 0.6 ? 'happy' : 'calm', mouth: mouth('R', t), blink: blink(t, 0.4), blush: k }); } },
  { id: 'S18_hug', t0: L('R4').end - 0.1, t1: cut('กอดกันซะงั้น'), cam0: { zoom: 1.35, cx: 560, cy: 960 }, bg: () => SC.side('warm'), bgKey: 'side_warm_135',
    cam: lt => ({ p: 1 + 0.04 * lt }),
    draw: (lt, t) => { vehicles(t); const k = ease(tq(lt) / 0.35);
      duo(t, { x: lerp(440, 512, k), lean: 0.08 * k, armFront: [lerp(0.2, 1.35, k), lerp(0.3, 1.0, k)], armBack: [lerp(0.2, 1.2, k), 0.9], eyesClosed: k > 0.8, mood: 'happy', blush: 0.6 },
        { x: lerp(680, 600, k), lean: 0.08 * k, armFront: [lerp(0.2, 1.35, k), lerp(0.3, 1.0, k)], armBack: [lerp(0.2, 1.2, k), 0.9], eyesClosed: k > 0.8, mood: 'happy', blush: 0.6 });
      CH.sparkle(470, 620, 20, t); CH.sparkle(690, 600, 16, t + 1); } },
  { id: 'S19_povHug', t0: cut('กอดกันซะงั้น'), t1: L('N5').start - 0.03, cam0: { zoom: 1.5, cx: 400, cy: 1000 }, bg: () => SC.pov('warm'), bgKey: 'pov_warm_150',
    cam: lt => ({ p: 1 + 0.04 * lt }),
    draw: (lt, t) => { povFigures(lt, 'hug'); CH.sparkle(330, 940, 12, t); CH.sparkle(410, 930, 10, t + 1); SC.interior(); phoneInHand(t, 760, 1640, 1); } },
  { id: 'S20_warmWide', t0: L('N5').start - 0.03, t1: L('N6').start - 0.03, cam0: { zoom: 1.0, cx: 560, cy: 1000 }, bg: () => SC.side('warm'), bgKey: 'side_warm_100',
    cam: lt => ({ p: 1.12 - 0.1 * ease(lt / 2.6) }),
    draw: (lt, t) => { vehicles(t); const pat = 0.15 * Math.sin(tq(lt) * 8);
      duo(t, { x: 512, lean: 0.08, armFront: [1.35, 1.0 + pat], armBack: [1.2, 0.9], eyesClosed: true, mood: 'happy', blush: 0.6 },
        { x: 600, lean: 0.08, armFront: [1.35, 1.0 - pat], armBack: [1.2, 0.9], eyesClosed: true, mood: 'happy', blush: 0.6 });
      for (let i = 0; i < 5; i++) CH.sparkle(300 + i * 120, 560 + 60 * Math.sin(i + t * 2), 14, t + i); } },
  { id: 'S21_question', t0: L('N6').start - 0.03, t1: L('N6').end + 0.15, cam0: { zoom: 1.25, cx: 560, cy: 1000 }, bg: () => SC.side('warm'), bgKey: 'side_warm_125',
    cam: lt => ({ p: 1 + 0.03 * lt }),
    draw: (lt, t) => { vehicles(t); const laugh = Math.abs(Math.sin(tq(lt) * 7)) * 0.5;
      duo(t, { x: 470, lean: -0.05, armFront: [0.6, 1.2], eyesClosed: true, mood: 'happy', mouth: laugh, blush: 0.4 },
        { x: 650, lean: -0.05, armFront: [2.0, 0.9], hand: 'open', eyesClosed: true, mood: 'happy', mouth: laugh * 0.8, blush: 0.4 }); } },
  { id: 'S22_loop', t0: L('N6').end + 0.15, t1: DATA.duration + 1, cam0: HOOK, bg: () => SC.side('tense'), bgKey: 'hook_tense',
    cam: (lt) => ({ p: 1 + 0.05 * ease(-0.01), ...shake(lt, 3) }), draw: (lt, t) => hookDraw(0, t) },
] };
// fix the D3 split: S15 = "รู้แล้ว... ปลอดภัยใช่ไหม", S16 = second "รู้แล้ว... กูขอโทษ"
(() => { const s15 = EP.shots.find(s => s.id === 'S15_driverSoft'), s16 = EP.shots.find(s => s.id === 'S16_sorry');
  const second = DATA.captions.filter(c => c.text === 'รู้แล้ว...')[1].t0 - 0.08; s15.t1 = second; s16.t0 = second; })();
// ---- DOM overlay: hook title, captions (color = speaker), name tags, comments, final question
const COLORS = { N: '#ffffff', R: '#ffd23f', D: '#9fe3ff' };
const COMMENTS = [[0.6, 'นึกว่าจะต่อยกัน 555'], [1.1, 'รอดูมวยแท้ๆ'], [1.6, 'จบแบบนี้ใจฟูเลย']];
window.overlay = (t) => {
  const shot = EP.shots.find(s => t >= s.t0 && t < s.t1) || EP.shots[EP.shots.length - 1], lt = t - shot.t0;
  const bp = document.getElementById('beep'), bl = (DATA.bleeps || []).find(b => t >= b[0] - 0.02 && t < b[1] + 0.12);
  bp.style.display = bl ? 'block' : 'none'; if (bl) bp.style.transform = `rotate(-8deg) scale(${0.6 + 0.5 * A.spring(t - bl[0] + 0.02, 26, 0.4)})`;
  const title = document.getElementById('title'), cap = document.getElementById('cap'), tag = document.getElementById('tag'), q = document.getElementById('q'), cm = document.getElementById('comments');
  const hook = shot.id === 'S01_hook' || shot.id === 'S22_loop';
  title.style.display = hook ? 'block' : 'none';
  if (hook) title.style.transform = `translateX(-50%) scale(${1 + 0.035 * Math.sin(t * 5.2)})`;
  const c = DATA.captions.find(c => t >= c.t0 && t < c.t1);
  if (c && !hook) { cap.style.display = 'block'; cap.textContent = c.text; cap.style.color = COLORS[c.v]; const k = A.spring(t - c.t0, 22, 0.5); cap.style.transform = `translateX(-50%) scale(${0.7 + 0.3 * k})`; }
  else cap.style.display = 'none';
  if (shot.label) { tag.style.display = 'block'; tag.textContent = shot.label.text; tag.style.background = COLORS[shot.label.who]; tag.style.transform = `scale(${0.6 + 0.4 * A.spring(lt, 18, 0.5)})`; }
  else tag.style.display = 'none';
  const qs = shot.id === 'S21_question';
  q.style.display = qs ? 'block' : 'none'; if (qs) q.style.transform = `translateX(-50%) scale(${0.8 + 0.2 * A.spring(lt, 16, 0.5)})`;
  cm.innerHTML = '';
  if (shot.id === 'S20_warmWide') COMMENTS.forEach(([at, txt], i) => { if (lt < at) return; const d = document.createElement('div'); d.className = 'cm'; d.style.top = (330 + i * 120) + 'px'; d.style.left = (90 + i * 60) + 'px';
    d.style.transform = `scale(${0.6 + 0.4 * A.spring(lt - at, 20, 0.5)})`; d.innerHTML = `<i style="background:${['#f4a261', '#8ecae6', '#cdb4db'][i]}"></i>${txt}`; cm.appendChild(d); });
};
