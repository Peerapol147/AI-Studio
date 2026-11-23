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

// ---- test frame: dark cave version (?sheet=2) ----
SHEET.cave = (ctx, t = 2.2) => {
  const { traveler, doll, log, sled, dollPile, fire, circle, ellipse } = E;
  const W = 1080, H = 1920, R = E.rng(31);
  ctx.save(); ctx.beginPath(); ctx.rect(0, 0, W, H); ctx.clip();
  ctx.fillStyle = '#0b0a0d'; ctx.fillRect(0, 0, W, H);
  // far exit glimmer (the goal), cold daylight deep in the tunnel
  const gx = 700, gy = 820; const g0 = ctx.createRadialGradient(gx, gy, 0, gx, gy, 160); g0.addColorStop(0, 'rgba(170,200,255,0.55)'); g0.addColorStop(1, 'rgba(120,150,220,0)'); ctx.fillStyle = g0; ctx.fillRect(gx - 160, gy - 160, 320, 320);
  // tunnel walls: layered jagged rock rings narrowing to the exit
  for (let k = 0; k < 6; k++) {
    const s = 1 - k * 0.15, col = E.mix('#2a2420', '#0d0c10', k / 5);
    ctx.fillStyle = col; ctx.beginPath(); ctx.moveTo(-50, -50); ctx.lineTo(W + 50, -50); ctx.lineTo(W + 50, H + 50); ctx.lineTo(-50, H + 50); ctx.closePath();
    const cx = 540 + (gx - 540) * (k / 6), cy = 1300 + (gy - 1300) * (k / 6), rx = 620 * s, ry = 760 * s;
    for (let i = 0; i <= 40; i++) { const a = i / 40 * Math.PI * 2; const j = 1 + (R() - 0.5) * 0.18; const x = cx + Math.cos(a) * rx * j, y = cy + Math.sin(a) * ry * j * (Math.sin(a) > 0 ? 0.55 : 1); i ? ctx.lineTo(x, y) : ctx.moveTo(x, y); }
    ctx.closePath(); ctx.fill('evenodd');
  }
  // floor + stalactites
  ctx.fillStyle = '#1c1815'; ctx.beginPath(); ctx.moveTo(-50, H); ctx.lineTo(-50, 1500); ctx.quadraticCurveTo(540, 1380, W + 50, 1500); ctx.lineTo(W + 50, H); ctx.fill();
  for (let i = 0; i < 14; i++) { const x = R() * W, h = 80 + R() * 260, w = 20 + R() * 40; ctx.fillStyle = '#16130f'; ctx.beginPath(); ctx.moveTo(x - w, 0); ctx.lineTo(x, h); ctx.lineTo(x + w, 0); ctx.fill(); }
  // things found on the path: sticks near the edge of the light
  log(ctx, { x: 820, y: 1640, len: 90, r: 10, L: 0.6, rot: 0.3 }); log(ctx, { x: 230, y: 1700, len: 80, r: 9, L: 0.5, rot: -0.5 });
  // traveler with a torch, dragging the sled of dolls
  const tx = 560, ty = 1640, torch = [tx + 70, ty - 250];
  sled(ctx, { x: tx - 290, y: ty + 10, s: 0.95, dir: 1, L: 0.7, cargo: c => dollPile(c, 12, 0.7, 7, 0.5) });
  ctx.strokeStyle = '#6b5a47'; ctx.lineWidth = 3; ctx.beginPath(); ctx.moveTo(tx - 170, ty - 22); ctx.lineTo(tx - 40, ty - 96); ctx.stroke();
  traveler(ctx, { x: tx, y: ty, s: 1, pose: 'walk', face: 0.6, phase: 1, t, L: 0.95, mood: 'worry', hands: { l: [-40, -96], r: [62, -168] } });
  ctx.strokeStyle = '#4a3322'; ctx.lineWidth = 9; ctx.lineCap = 'round'; ctx.beginPath(); ctx.moveTo(tx + 62, ty - 168); ctx.lineTo(torch[0], torch[1]); ctx.stroke();
  ctx.fillStyle = '#2a1a10'; ctx.beginPath(); ctx.ellipse(torch[0], torch[1] + 4, 16, 9, 0, 0, Math.PI * 2); ctx.fill(); fire(ctx, torch[0], torch[1] + 6, 0.36, t, { embers: 0, torch: true });
  // darkness: everything outside the torch light falls to black
  const m = document.createElement('canvas'); m.width = W; m.height = H; const mc = m.getContext('2d');
  mc.fillStyle = 'rgba(2,2,4,0.95)'; mc.fillRect(0, 0, W, H); mc.globalCompositeOperation = 'destination-out';
  const hole = mc.createRadialGradient(torch[0], torch[1], 40, torch[0], torch[1], 700); hole.addColorStop(0, 'rgba(0,0,0,1)'); hole.addColorStop(0.55, 'rgba(0,0,0,0.75)'); hole.addColorStop(1, 'rgba(0,0,0,0)'); mc.fillStyle = hole; mc.fillRect(0, 0, W, H);
  const exitHole = mc.createRadialGradient(gx, gy, 0, gx, gy, 120); exitHole.addColorStop(0, 'rgba(0,0,0,0.9)'); exitHole.addColorStop(1, 'rgba(0,0,0,0)'); mc.fillStyle = exitHole; mc.fillRect(0, 0, W, H);
  ctx.drawImage(m, 0, 0);
  E.fireGlow(ctx, torch[0], torch[1] + 60, 0.45, t, 0.9);
  // eyes watching from the dark (cold white, never warm)
  for (const [x, y, s] of [[120, 1080, 1], [930, 1240, 0.8], [210, 1350, 0.7], [980, 940, 0.6]]) for (const d of [-1, 1]) { ellipse(ctx, x + d * 13 * s, y, 6 * s, 3.2 * s, 'rgba(225,235,255,0.85)'); }
  E.text(ctx, 'Burn it to see.. or keep it?', 360, 76);
  ctx.restore();
};
