// Character & prop sheet (shown to the user before any shot is produced). Every drawing below is the same function the shots use.
const SHEET = { W: 1600, H: 2000 };
SHEET.draw = (ctx) => {
  const { traveler, doll, log, sled, fire, fireGlow, dollPile, village, text } = E;
  ctx.fillStyle = '#0d1328'; ctx.fillRect(0, 0, SHEET.W, SHEET.H);
  const label = (s, x, y, size = 30) => { ctx.save(); ctx.font = `700 ${size}px Kanit`; ctx.fillStyle = '#e9eefc'; ctx.textAlign = 'center'; ctx.fillText(s, x, y); ctx.restore(); };
  const panel = (x, y, w, h) => { ctx.save(); ctx.beginPath(); ctx.roundRect(x, y, w, h, 18); ctx.fillStyle = '#16203f'; ctx.fill(); ctx.strokeStyle = '#2b3a66'; ctx.lineWidth = 2; ctx.stroke(); ctx.restore(); };
  label('ตุ๊กตาไม้ · character sheet (วาดด้วยโค้ด ฟังก์ชันเดียวทุกช็อต)', 800, 62, 40);

  // row 1: the traveler, turnaround + expressions
  panel(30, 90, 1540, 520); label('นักเดินทาง: ฮู้ดน้ำตาลปลายแหลม · ผ้าพันคอแดง (จุดจำ) · หน้ากลม ตาเป็นจุด', 800, 132);
  const T = 2.2, gy = 520;
  const row1 = [['หน้าตรง', { face: 0 }], ['หันขวา', { face: 0.8 }], ['หันซ้าย', { face: -0.8 }], ['ยิ้ม', { face: 0.3, mood: 'smile' }], ['เศร้า', { face: 0.3, mood: 'sad' }], ['กังวล', { face: 0.3, mood: 'worry' }], ['โล่งใจ', { face: 0.2, mood: 'relief' }]];
  row1.forEach(([n, o], i) => { const x = 140 + i * 220; traveler(ctx, Object.assign({ x, y: gy, s: 1, t: T, L: 0.95 }, o)); label(n, x, 580, 26); });

  // row 2: poses
  panel(30, 630, 1540, 520); label('ท่าทาง', 800, 672);
  const gy2 = 1060;
  traveler(ctx, { x: 150, y: gy2, s: 1, pose: 'walk', face: 0.7, phase: 1.1, t: T, L: 0.8, wind: 0.6 }); label('เดิน', 150, 1120, 26);
  // pull sled
  const ropeFrom = [470, gy2 - 112];
  traveler(ctx, { x: 470, y: gy2, s: 1, pose: 'pull', face: 0.85, lean: 0.22, phase: 0.6, t: T, L: 0.8, wind: 0.6, hands: { l: [-60, -90], r: [-48, -78] } });
  ctx.save(); ctx.translate(-10, 0); const fp = sled(ctx, { x: 290, y: gy2 + 6, s: 0.62, dir: 1, L: 0.8 }); ctx.restore();
  ctx.strokeStyle = '#a58a62'; ctx.lineWidth = 3; ctx.beginPath(); ctx.moveTo(fp[0] - 10, fp[1]); ctx.quadraticCurveTo(410, gy2 - 60, 418, gy2 - 104); ctx.stroke();
  label('ลากเลื่อน', 400, 1120, 26);
  // sit by fire holding the doll
  fireGlow(ctx, 790, gy2, 0.5, T, 0.5);
  traveler(ctx, { x: 700, y: gy2, s: 1, pose: 'sit', face: 0.6, mood: 'neutral', t: T, L: 1, hands: { l: [-10, -70], r: [62, -96] }, over: c => doll(c, { x: 74, y: -84, s: 0.85, face: -0.6, L: 1, shadow: false }) });
  fire(ctx, 860, gy2, 0.5, T); label('นั่งข้างไฟ ถือตุ๊กตา', 760, 1120, 26);
  // hug + shiver
  traveler(ctx, { x: 1080, y: gy2, s: 1, pose: 'sit', face: 0.1, mood: 'shut', t: T, L: 0.55, shiver: 0, front: c => doll(c, { x: 0, y: -64, s: 1, face: 0, L: 0.6, shadow: false }), hands: { l: [-24, -86], r: [24, -84] } });
  label('กอดตุ๊กตา (หนาว)', 1080, 1120, 26);
  // crouch picking log
  traveler(ctx, { x: 1380, y: gy2, s: 1, pose: 'crouch', face: 0.6, t: T, L: 0.7, hands: { l: [40, -30], r: [86, -34] }, over: c => log(c, { x: 64, y: -30, len: 110, r: 14, L: 0.7, rot: -0.1 }) });
  label('ย่อเก็บฟืน', 1380, 1120, 26);

  // row 3: props
  panel(30, 1170, 760, 520); label('ตุ๊กตาไม้ (เท่าฝ่ามือ ลายวนสีทอง)', 410, 1212);
  doll(ctx, { x: 180, y: 1540, s: 3, face: 0, L: 1 }); label('หน้าตรง', 180, 1600, 26);
  doll(ctx, { x: 400, y: 1540, s: 3, face: 0.8, L: 1 }); label('หันข้าง', 400, 1600, 26);
  [0.25, 0.5, 0.75].forEach((p, i) => doll(ctx, { x: 560 + i * 80, y: 1540, s: 1.6, p, L: 1 })); label('ขั้นถักจากกิ่งไม้', 640, 1600, 26);
  label('ไฟกลางคืน (มืด)', 230, 1660, 22); doll(ctx, { x: 330, y: 1676, s: 1, L: 0.2 });
  panel(810, 1170, 760, 520); label('ไม้ท่อนสวย vs ไม้ฟืนธรรมดา', 1190, 1212);
  log(ctx, { x: 1010, y: 1300, len: 260, r: 34, golden: true, L: 1 }); label('ไม้ท่อนสวย (ลายเดียวกับตุ๊กตา)', 1010, 1370, 24);
  log(ctx, { x: 1380, y: 1300, len: 260, r: 34, L: 1 }); label('ไม้ฟืนธรรมดา (ไม่มีลาย)', 1380, 1370, 24);
  sled(ctx, { x: 1010, y: 1630, s: 1, dir: 1, L: 1 }); label('เลื่อนเปล่า', 1010, 1672, 24);
  sled(ctx, { x: 1380, y: 1630, s: 1, dir: 1, L: 1, cargo: c => dollPile(c, 30, 1) }); label('เลื่อนเต็มตุ๊กตา (30)', 1380, 1672, 24);

  // row 4: fire sizes + village light + second traveler
  panel(30, 1710, 1140, 270); label('กองไฟ: 4 ขนาด (ไฟเป็นสีอุ่นสีเดียวในภาพ)', 600, 1748, 26);
  [0.95, 0.6, 0.3, 0].forEach((s, i) => { const x = 160 + i * 260; fireGlow(ctx, x, 1930, s, T, 0.35); fire(ctx, x, 1930, s, T); });
  panel(1190, 1710, 380, 270); label('แสงหมู่บ้าน', 1290, 1748, 26); label('คนใหม่ (ตอนจบ)', 1300, 1960, 22);
  village(ctx, 1280, 1860, 0.3, T);
  traveler(ctx, { x: 1480, y: 1960, s: 0.85, face: -0.5, mood: 'smile', scarf: E.P.scarf2, t: T, L: 0.9 });
};
window.SHEET = SHEET;
