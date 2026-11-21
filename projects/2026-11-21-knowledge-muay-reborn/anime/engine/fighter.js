// Fighter rig: side view with full joints (for Muay Thai moves) + front faces for close-ups / reactions.
// Side view: origin = ground under the pelvis, 100 units = body height, facing +x (f:-1 mirrors).
// All limb angles are WORLD angles measured from straight down, positive = toward facing direction.
//   leg [thigh, knee]  : knee = thigh + rel (negative = shin swings back, a normal bent knee)
//   arm [upper, elbow] : elbow = upper + rel (positive = forearm swings forward/up)
// Feet are auto-grounded (lowest grounded ankle sits on y=0) unless pose.air is set (lift in units).
/* global A, PAL */
const LOOK = {
  // Thai school uniform: white short-sleeve shirt, navy shorts, white socks, black shoes (generic, no school name)
  kla:   { skin: '#f1c9a5', skinSh: '#d9a07e', shirt: '#fbfaf5', shirtSh: '#dfe3ea', pants: '#26335a', sock: '#f4f4f0', shoe: '#1d1b22', hair: '#1b1820', build: 0.86, hairStyle: 'mop', mark: '#3a5ccc' },
  boss:  { skin: '#d9a67c', skinSh: '#b9825e', shirt: '#f6f4ec', shirtSh: '#d6d8de', pants: '#232c4c', sock: '#f0efe8', shoe: '#1d1b22', hair: '#231a18', build: 1.18, hairStyle: 'spike', untucked: true, rolled: true, tank: '#c8443a' },
  jo:    { skin: '#e8b48c', skinSh: '#c98d68', shirt: '#f6f4ec', shirtSh: '#d6d8de', pants: '#232c4c', sock: '#f0efe8', shoe: '#1d1b22', hair: '#2a2224', build: 1.32, hairStyle: 'buzz', untucked: true },
  te:    { skin: '#ecc09a', skinSh: '#cf9a74', shirt: '#f6f4ec', shirtSh: '#d6d8de', pants: '#232c4c', sock: '#f0efe8', shoe: '#1d1b22', hair: '#3b2a22', build: 0.95, hairStyle: 'side', untucked: true },
  pond:  { skin: '#f3d0ae', skinSh: '#d9a985', shirt: '#fbfaf5', shirtSh: '#dfe3ea', pants: '#26335a', sock: '#f4f4f0', shoe: '#1d1b22', hair: '#1b1820', build: 0.9, hairStyle: 'bowl', glasses: true, short: 0.86 },
};
const FT = (() => {
  const sin = Math.sin, cos = Math.cos;
  const DEF = { hip: 0, lean: 0, head: 0, legF: [0.12, -0.1], legB: [-0.12, -0.05], armF: [0.15, 0.25], armB: [-0.1, 0.2], ftF: 0, ftB: 0, handF: 'fist', handB: 'fist', air: 0, spin: 0 };
  const P = (o) => Object.assign({}, DEF, o);
  const dir = (a) => [sin(a), cos(a)];
  const add = (p, d, l) => [p[0] + d[0] * l, p[1] + d[1] * l];
  function legPts(hip, L, side) { const h = [hip[0] + side * 1.6, hip[1]]; const k = add(h, dir(L[0]), 25); const a = add(k, dir(L[0] + L[1]), 24); return [h, k, a]; }
  // ---------- pose interpolation: keys = [[t, pose, easeName?], ...]
  function lerpP(a, b, k) { const o = {}; for (const key in a) { const x = a[key], y = b[key];
    if (Array.isArray(x)) o[key] = x.map((v, i) => v + (y[i] - v) * k); else if (typeof x === 'number') o[key] = x + (y - x) * k; else o[key] = k < 0.5 ? x : y; } return o; }
  function at(keys, t) {
    if (t <= keys[0][0]) return P(keys[0][1]);
    for (let i = 0; i < keys.length - 1; i++) { const [t0, p0] = keys[i], [t1, p1, e] = keys[i + 1];
      if (t < t1) { let k = (t - t0) / (t1 - t0); k = e === 'lin' ? k : e === 'snap' ? 1 - Math.pow(1 - k, 3) : e === 'hold' ? 0 : A.ease(k); return lerpP(P(p0), P(p1), k); } }
    return P(keys[keys.length - 1][1]);
  }
  // ---------- side view body
  // c: { look, x, y, s, f, pose, face:{mood, anger, mouth, blink, eyes:'normal|fierce|dazed|shut|wide', sweat}, rot }
  function body(c) {
    const L = LOOK[c.look], po = P(c.pose || {}), u = c.s / 100 * (L.short || 1), bw = L.build;
    // auto-ground
    const hip0 = [0, -50];
    const lowF = legPts(hip0, po.legF, 1)[2][1], lowB = legPts(hip0, po.legB, -1)[2][1];
    const lowest = Math.max(po.groundF === false ? -999 : lowF, po.groundB === false ? -999 : lowB, lowF > -999 && lowB > -999 ? -999 : 0);
    const hip = [po.hip, -50 - (lowest - 0) - 3 - (po.air || 0)];
    A.push(); A.translate(c.x, c.y); A.scale((c.f || 1) * u, u);
    if (po.spin) { A.translate(0, hip[1]); A.rotate(po.spin); A.translate(0, -hip[1]); }
    if (!c.noShadow && !po.air) A.ell(po.hip, -0.5, 16 * bw, 2.2, { fill: '#000000', alpha: 40, w: 0 });
    const up = [sin(po.lean), -cos(po.lean)];
    const sh = add(hip, up, 27), neck = add(hip, up, 30), hc = add(hip, up, 40);
    const shirtCol = c.shirtOverride || L.shirt;
    const arm = (side, ang, hand) => {
      const s0 = [sh[0] + side * 1.2 * bw, sh[1]]; const el = add(s0, dir(ang[0]), 15), hd = add(el, dir(ang[0] + ang[1]), 14);
      const far = side < 0, sk = far ? L.skinSh : L.skin;
      // sleeve (upper third) + skin arm
      const sl = add(s0, dir(ang[0]), L.rolled ? 5 : 8);
      A.limb(s0[0], s0[1], el[0], el[1], 3.3 * bw, 3.0 * bw, { fill: sk, w: 1 });
      A.limb(el[0], el[1], hd[0], hd[1], 3.0 * bw, 2.6 * bw, { fill: sk, w: 1 });
      A.limb(s0[0], s0[1], sl[0], sl[1], 4.4 * bw, 4.2 * bw, { fill: far ? L.shirtSh : shirtCol, w: 1 });
      handDraw(hd, ang[0] + ang[1], hand, sk);
    };
    const handDraw = (p, a, kind, sk) => {
      if (kind === 'open') A.ell(p[0] + sin(a) * 1.4, p[1] + cos(a) * 1.4, 2.6, 3.8, { fill: sk, w: 0.9 }, -a);
      else if (kind === 'wai') A.ell(p[0] + sin(a) * 1.6, p[1] + cos(a) * 1.6, 2.2, 4.4, { fill: sk, w: 0.9 }, -a);
      else A.ell(p[0], p[1], 3.2, 3.2, { fill: sk, w: 0.95 });
    };
    const leg = (side, ang, ft) => {
      const [h, k, a] = legPts(hip, ang, side), far = side < 0;
      const pant = far ? A.shadeHex ? A.shadeHex(L.pants, 0.8) : L.pants : L.pants;
      // shin (skin) + sock, thigh covered by shorts to just above the knee
      A.limb(k[0], k[1], a[0], a[1], 3.3 * bw, 2.6 * bw, { fill: far ? L.skinSh : L.skin, w: 1 });
      const s1 = [k[0] + (a[0] - k[0]) * 0.62, k[1] + (a[1] - k[1]) * 0.62];
      A.limb(s1[0], s1[1], a[0], a[1], 2.9 * bw, 2.7 * bw, { fill: L.sock, w: 0.9 });
      const kk = [h[0] + (k[0] - h[0]) * 0.86, h[1] + (k[1] - h[1]) * 0.86];
      A.limb(h[0], h[1], kk[0], kk[1], 5.4 * bw, 4.9 * bw, { fill: far ? shadeHex(L.pants, 0.78) : L.pants, w: 1 });
      // shoe: perpendicular to shin (ft 0) .. pointed along shin (ft 1)
      const sa = ang[0] + ang[1], fd0 = [cos(sa), -sin(sa)], fd1 = dir(sa), fd = [fd0[0] * (1 - ft) + fd1[0] * ft, fd0[1] * (1 - ft) + fd1[1] * ft];
      const n = [fd[1], -fd[0]], toe = add(a, fd, 7.5), heel = add(a, fd, -3.2);
      A.poly([add(heel, n, 2.2), add(toe, n, 1.4), add(toe, n, -1.6), add(heel, n, -2.4)], { fill: L.shoe, w: 0.9, curv: 0.45 });
    };
    arm(-1, po.armB, po.handB);
    leg(-1, po.legB, po.ftB);
    leg(1, po.legF, po.ftF);
    // torso (shirt) — tucked: ends at belt; untucked: hangs over the hips
    const rotp = (p) => { const s = sin(po.lean), co = cos(po.lean), x = p[0], y = p[1]; return [hip[0] + x * co - y * s, hip[1] + x * s + y * co]; };
    const w = 7.2 * bw, tail = L.untucked ? 6 : 1.5;
    A.poly([[-w * 0.95, -29], [w * 0.85, -29], [w * 1.05, -18], [w * 1.0, 2], [w * 1.1, tail], [-w * 1.05, tail], [-w * 1.05, 2], [-w * 1.1, -18]].map(rotp), { fill: shirtCol, w: 1.1, curv: 0.3 });
    if (!L.untucked) A.poly([[-w * 1.05, 0], [w * 1.0, 0], [w * 1.0, 2.4], [-w * 1.05, 2.4]].map(rotp), { fill: '#1e1a20', w: 0, curv: 0 }); // belt
    A.poly([[w * 0.2, -29.5], [w * 0.95, -29], [w * 0.55, -25]].map(rotp), { fill: L.shirtSh, w: 0.6, curv: 0 }); // collar
    if (L.mark) A.stroke([[w * 0.35, -22], [w * 0.75, -22.3]].map(rotp), { ink: L.mark, w: 0.6 }); // embroidered initials (abstract)
    if (L.tank) A.poly([[w * 0.1, -28.6], [w * 0.8, -28.4], [w * 0.5, -24]].map(rotp), { fill: L.tank, w: 0, curv: 0 }); // red undershirt at open collar
    A.stroke([[w * 0.1, -24], [w * 0.2, -8]].map(rotp), { ink: '#c7cad2', w: 0.5 }); // shirt crease
    // neck + head
    A.limb(neck[0], neck[1], neck[0] + up[0] * 5, neck[1] + up[1] * 5, 2.6 * bw, 2.6 * bw, { fill: L.skinSh, w: 0.8 });
    A.push(); A.translate(hc[0], hc[1]); A.rotate(po.lean + (po.head || 0)); A.scale(1.22); headSide(L, c.face || {}); A.pop();
    arm(1, po.armF, po.handF);
    A.pop();
  }
  const shadeHex = (hex, f) => { const n = parseInt(hex.slice(1), 16); const r = (n >> 16) * f | 0, g = ((n >> 8) & 255) * f | 0, b = (n & 255) * f | 0; return '#' + ((1 << 24) + (r << 16) + (g << 8) + b).toString(16).slice(1); };
  function hairSide(L, back) {
    const st = L.hairStyle, col = L.hair;
    if (back) { // behind face
      if (st === 'mop') A.poly([[-9, 4], [-10.2, -4], [-7, -9.5], [0, -11.2], [6, -10], [9.6, -6]], { fill: col, w: 1, curv: 0.4 });
      else if (st === 'side') A.poly([[-9.4, 5], [-10, -4], [-6.5, -9.6], [0, -10.8], [6, -9.6], [9, -6]], { fill: col, w: 1, curv: 0.4 });
      else if (st === 'bowl') A.poly([[-8.8, 2], [-9.6, -4], [-6, -9.4], [0, -10.6], [6, -9.6], [9.2, -5]], { fill: col, w: 1, curv: 0.5 });
      else if (st === 'grey') A.poly([[-8.6, 0], [-9.2, -5], [-6, -9.4], [0, -10.2], [6, -9.2], [8.6, -6]], { fill: col, w: 1, curv: 0.4 });
      return;
    }
    if (st === 'mop') { // long bangs covering the eye (meek); L.bangsUp = swept back (awakened)
      if (L.bangsUp) A.poly([[-8.4, -2.4], [-7.8, -8.4], [-2, -11.6], [5, -11.4], [10.2, -8.6], [8.6, -7.2], [4, -8], [-1, -6.6], [-5.6, -2.2]], { fill: col, w: 1, curv: 0.3 });
      else A.poly([[-8.4, -2.4], [-7.8, -8.4], [-2, -11.2], [5, -10.6], [9.4, -7], [10.6, -1.2], [8.6, -3.8], [7.8, 0.6], [6.2, -3.6], [4.4, -1], [3.2, -5.4], [-2.4, -6.2], [-5.6, -2.2]], { fill: col, w: 1, curv: 0.25 });
    } else if (st === 'spike') {
      A.poly([[-8.6, -2], [-9, -8], [-6, -10], [-6.5, -14.5], [-2.5, -11.4], [-1, -15.6], [2, -11.6], [4.5, -15.2], [5.6, -11], [9.4, -12.6], [8.6, -8.4], [11.4, -7.6], [8.4, -5.6], [3, -7.2], [-2, -6.2], [-5.4, -1.6]], { fill: col, w: 1, curv: 0.02 });
      A.poly([[-8.4, -3], [-7.8, -7], [-6.4, -6.6], [-6.8, -2.6]], { fill: shadeHex(L.skin, 0.75), w: 0, curv: 0.3 }); // undercut
    } else if (st === 'buzz') A.poly([[-8.2, -3], [-7.6, -8.2], [-2, -10.4], [4.6, -10], [8.6, -7.2], [8.4, -5.8], [3, -7.4], [-2.4, -6.4], [-5.6, -2.8]], { fill: shadeHex(L.skin, 0.55), w: 0.8, curv: 0.4 });
    else if (st === 'side') A.poly([[-8.6, -1.4], [-8.2, -8.4], [-2, -11.4], [5, -11.4], [9.8, -8.4], [9.6, -5.4], [6, -7], [2, -6.4], [-2, -6], [-5.6, -1]], { fill: col, w: 1, curv: 0.35 });
    else if (st === 'bowl') A.poly([[-8.6, -1], [-8.2, -8], [-2, -10.8], [5, -10.4], [9.2, -7.4], [9.4, -4], [-1, -4.6], [-5.6, -0.8]], { fill: col, w: 1, curv: 0.45 });
    else if (st === 'grey') A.poly([[-8, -3], [-7.4, -8.2], [-2, -10.2], [4.4, -9.8], [8.2, -7.4], [8.0, -6], [3, -7.4], [-2.4, -6.6], [-5.4, -3]], { fill: '#9a9498', w: 0.8, curv: 0.4 });
  }
  function headSide(L, fc) {
    const ang = fc.anger || 0, m = fc.mouth || 0, bl = fc.blink || 0, mood = fc.mood || 'calm', eyes = fc.eyes || 'normal';
    hairSide(L, true);
    A.poly([[-7.8, -2], [-6.5, -7.5], [0, -9.4], [6.5, -7.6], [8.6, -3.6], [8.8, 0.5], [10.4, 2.0], [8.8, 3.0], [8.6, 5.6], [6.4, 8.2], [2.0, 8.6], [-3.6, 5.4], [-7.2, 3]], { fill: L.skin, w: 1.1, curv: 0.35 });
    A.ell(-2.2, 0.8, 1.1, 1.6, { fill: L.skin, w: 0.7 });
    // eye
    if (eyes === 'shut' || bl > 0.5) A.stroke(mood === 'happy' ? [[4.2, -0.2], [5.4, -1.4], [6.6, -0.2]] : [[4.2, -0.8], [5.4, 0.2], [6.6, -0.8]], { w: 1.4 });
    else if (eyes === 'dazed') { A.stroke([[4.2, -2], [6.6, 0.6]], { w: 1.2 }); A.stroke([[6.6, -2], [4.2, 0.6]], { w: 1.2 }); }
    else if (eyes === 'fierce') { A.poly([[3.6, -0.4], [7.0, -1.6], [6.6, 0.4], [4.0, 0.6]], { fill: '#1a1214', w: 0.6, curv: 0.2 }); A.ell(5.9, -0.7, 0.5, 0.4, { fill: '#fff6c8', w: 0 }); }
    else { const eh = eyes === 'wide' ? 2.6 : Math.max(0.2, 2.0 * (1 - ang * 0.3)); A.ell(5.4, -0.6, eyes === 'wide' ? 1.6 : 1.1, eh, { fill: eyes === 'wide' ? '#fffaf2' : '#2a1e1e', w: 0.9 }); if (eyes === 'wide') A.ell(5.6, -0.4, 0.5, 0.6, { fill: '#2a1e1e', w: 0 }); else if (eh > 1) A.ell(5.7, -1.3, 0.45, 0.6, { fill: '#ffffff', w: 0 }); }
    const by = mood === 'sad' ? [[3.2, -3.6], [7.4, -5.2]] : eyes === 'fierce' ? [[3.0, -4.6], [7.6, -2.4]] : [[3.0, -4.4 - (1 - ang) * 0.4], [7.6, -4.4 + ang * 2.0]];
    A.stroke(by, { w: 2.0, curv: 0.2 });
    if (L.glasses) { A.ell(5.6, -0.5, 2.5, 2.1, { ink: '#2a2428', w: 0.9 }); A.stroke([[3.2, -0.8], [-1.4, -1.6]], { ink: '#2a2428', w: 0.8 }); }
    hairSide(L, false);
    // mouth
    if (m > 0.08) { const h = 0.5 + m * 2.8, w = 1.5 + m * 0.6; A.ell(6.9, 4.7, w, h, { fill: PAL.mouth, w: 0.9 }); if (m > 0.4) A.ell(6.9, 4.7 + h * 0.5, w * 0.7, h * 0.35, { fill: PAL.tongue, w: 0 }); }
    else if (mood === 'happy' || mood === 'smirk') A.stroke(mood === 'smirk' ? [[5.6, 5.0], [7.2, 4.8], [8.4, 3.9]] : [[5.4, 4.2], [6.8, 5.2], [8.2, 4.4]], { w: 1.1 });
    else A.stroke(ang > 0.3 || mood === 'sad' ? [[5.6, 5.0], [7.0, 4.5], [8.2, 4.8]] : [[5.6, 4.7], [8.2, 4.6]], { w: 1.1 });
    if (fc.sweat) A.poly([[-2.5, -6], [-1.6, -3.6], [-2.5, -2.4], [-3.4, -3.6]], { fill: PAL.sweat, w: 0.6, curv: 0.6 });
    if (fc.bruise) A.ell(4.2, 2.8, 1.6, 1.1, { fill: '#c9879a', alpha: 150, w: 0 });
  }
  // ---------- front face (close-ups, reactions) — origin = face center, 100 = face height
  // c: { who: look key | 'legend' | girl keys, x, y, s, tilt, mood, anger, mouth, mouthO, blink, eyes, look, sweat, blush, shrug, lying }
  const FACES = {
    legend: { skin: '#cf9a72', hair: '#8f8a8e', style: 'crew', shirt: '#4a5a6a', scar: true, stache: true, neck: 1.25 },
    mew:  { skin: '#f6d3b5', hair: '#1f1a1e', style: 'girlBob', shirt: 'girl', tie: '#26335a' },
    fern: { skin: '#e9bb93', hair: '#3a2620', style: 'girlTail', shirt: 'girl', tie: '#26335a' },
    nut:  { skin: '#e3ad86', hair: '#1c181c', style: 'buzz', shirt: 'boy' },
  };
  function face(c) {
    const F = FACES[c.who] || Object.assign({ style: LOOK[c.who].hairStyle, shirt: 'boy', glasses: LOOK[c.who].glasses }, LOOK[c.who]);
    const ang = c.anger || 0, m = c.mouth || 0, bl = c.blink || 0, mood = c.mood || 'calm', eyes = c.eyes || 'normal';
    const ink0 = A.INK; A.setInk(ink0, 3.4); A.push(); A.translate(c.x, c.y); A.scale(c.s / 100); A.rotate(c.tilt || 0);
    const sh = c.shrug || 0, nk = F.neck || 1;
    // body / uniform
    if (F.shirt === 'boy' || F.shirt === 'girl') {
      A.poly([[-126, 220], [-118, 100 + sh], [-58, 70], [58, 70], [118, 100 + sh], [126, 220]], { fill: '#fbfaf5', w: 1.4, curv: 0.25 });
      if (F.shirt === 'boy') { A.poly([[-34, 62], [0, 100], [-10, 112], [-44, 76]], { fill: '#e6e9ef', w: 1, curv: 0.1 }); A.poly([[34, 62], [0, 100], [10, 112], [44, 76]], { fill: '#e6e9ef', w: 1, curv: 0.1 }); A.stroke([[0, 104], [0, 220]], { w: 0.8 }); if (F.mark) A.stroke([[40, 150], [64, 148]], { ink: F.mark, w: 1.4 }); }
      else { A.poly([[-30, 64], [0, 92], [30, 64], [22, 60], [0, 80], [-22, 60]], { fill: '#eef0f4', w: 1, curv: 0.1 }); A.poly([[-4, 92], [-26, 130], [-10, 140], [0, 104], [10, 140], [26, 130], [4, 92]], { fill: F.tie, w: 1, curv: 0.2 }); A.ell(0, 96, 9, 7, { fill: F.tie, w: 1 }); }
    } else A.poly([[-130, 220], [-122, 100 + sh], [-60, 70], [60, 70], [122, 100 + sh], [130, 220]], { fill: F.shirt, w: 1.4, curv: 0.25 });
    A.limb(0, 40, 0, 76, 16 * nk, 18 * nk, { fill: shadeHex(F.skin, 0.86), w: 1 });
    // back hair
    const st = F.style;
    if (st === 'girlBob') A.poly([[-58, 40], [-56, -30], [-36, -64], [0, -72], [36, -64], [56, -30], [58, 40], [40, 46], [44, 10], [-44, 10], [-40, 46]], { fill: F.hair, w: 1.2, curv: 0.35 });
    else if (st === 'girlTail') { A.poly([[-50, 10], [-52, -32], [-34, -62], [0, -70], [34, -62], [52, -32], [50, 10]], { fill: F.hair, w: 1.2, curv: 0.4 }); A.poly([[40, -40], [74, -20], [80, 30], [66, 60], [58, 20], [46, -10]], { fill: F.hair, w: 1.2, curv: 0.4 }); }
    else if (st !== 'buzz' && st !== 'crew') A.poly([[-50, 10], [-54, -30], [-36, -62], [0, -70], [36, -62], [54, -30], [50, 10]], { fill: F.hair, w: 1.2, curv: 0.4 });
    A.ell(-45, 6, 7, 11, { fill: F.skin, w: 1 }); A.ell(45, 6, 7, 11, { fill: F.skin, w: 1 });
    const fp = []; for (let i = 0; i <= 10; i++) { const a = Math.PI + i / 10 * Math.PI; fp.push([46 * cos(a), -5 + 50 * sin(a)]); }
    fp.push([44, 6], [36, 30], [14, 48], [0, 52], [-14, 48], [-36, 30], [-44, 6]);
    A.poly(fp, { fill: F.skin, w: 1.4, curv: 0.4 });
    // eyes
    for (const sx of [-1, 1]) {
      const ex = sx * 19, ey = 6, ry = (eyes === 'wide' ? 15 : 12) * (1 - bl) * (1 - ang * 0.3);
      if (eyes === 'shut' || c.eyesClosed) A.stroke(mood === 'happy' ? [[ex - 10, ey + 3], [ex, ey - 4], [ex + 10, ey + 3]] : [[ex - 10, ey], [ex, ey + 4], [ex + 10, ey]], { w: 2.4 });
      else if (eyes === 'fierce') { A.poly([[ex - 12 * sx, ey - 2 + 4], [ex + 12 * sx, ey - 6], [ex + 10 * sx, ey + 5], [ex - 10 * sx, ey + 6]].map(p => [p[0], p[1]]), { fill: PAL.white, w: 1.4, curv: 0.2 }); A.ell(ex + sx * 1, ey + 0.5, 4.2, 5, { fill: '#1a1214', w: 0 }); A.ell(ex + sx * 1 + 1.6, ey - 1.4, 1.6, 1.6, { fill: '#fff6c8', w: 0 }); A.stroke([[ex - 13 * sx, ey + 2], [ex + 13 * sx, ey - 7]], { w: 3.6 }); }
      else if (ry < 1.5) A.stroke([[ex - 11, ey], [ex + 11, ey]], { w: 2.4 });
      else {
        A.ell(ex, ey, eyes === 'wide' ? 13 : 10.5, ry, { fill: PAL.white, w: 1.2 });
        const lx = (c.look || 0) * 3, pr = eyes === 'wide' ? 0.45 : 1;
        A.ell(ex + lx, ey + ry * 0.12, 6.4 * pr, Math.min(ry * 0.85, 8.6) * pr, { fill: F.iris || '#3a2a24', w: 0.6 });
        if (eyes !== 'wide') A.ell(ex + lx, ey + ry * 0.15, 3.2, Math.min(ry * 0.45, 4.2), { fill: '#1a1214', w: 0 });
        A.ell(ex + lx + 2.4 * pr, ey - ry * 0.25 * pr, 2.2 * pr, 2.4 * pr, { fill: '#ffffff', w: 0 });
        A.stroke([[ex - 12, ey - ry * 0.7], [ex, ey - ry * 1.05], [ex + 12, ey - ry * 0.7]], { w: 3.0 });
      }
      const inner = mood === 'sad' ? -26 : eyes === 'wide' ? -30 : -18 + ang * 10, outer = mood === 'sad' ? -16 : eyes === 'wide' ? -28 : -22 - ang * 4;
      A.stroke([[sx * 8, ey + inner], [sx * 30, ey + outer]], { w: 4.2, curv: 0.2 });
      if (F.glasses) A.poly([[ex - 14, ey - 12], [ex + 14, ey - 12], [ex + 14, ey + 12], [ex - 14, ey + 12]], { ink: '#2a2428', w: 1.2, curv: 0.45 });
    }
    if (F.glasses) A.stroke([[-5, 2], [5, 2]], { ink: '#2a2428', w: 1.2 });
    if (F.scar) A.stroke([[22, -22], [30, -6]], { ink: '#9a5a4a', w: 1.6 });
    A.stroke([[1, 16], [3, 23], [-1, 24]], { w: 1.2 });
    if (F.stache) A.poly([[-16, 30], [0, 26], [16, 30], [12, 33], [0, 31], [-12, 33]], { fill: '#6e676c', w: 0.8, curv: 0.3 });
    // mouth: mouthO = jaw-drop "O" (wow)
    if (c.mouthO) { const h = 10 + c.mouthO * 26, w = 8 + c.mouthO * 7; A.ell(0, 38 + h * 0.3, w, h * 0.6, { fill: PAL.mouth, w: 1.3 }); A.ell(0, 38 + h * 0.55, w * 0.6, h * 0.22, { fill: PAL.tongue, w: 0 }); }
    else if (m > 0.08) { const h = 3 + m * 20, w = 9 + m * 9;
      A.poly([[-w, 33], [w, 33], [w * 0.7, 33 + h], [-w * 0.7, 33 + h]], { fill: PAL.mouth, w: 1.2, curv: 0.45 });
      if (m > 0.3) { A.poly([[-w * 0.8, 33.5], [w * 0.8, 33.5], [w * 0.7, 37], [-w * 0.7, 37]], { fill: '#ffffff', w: 0, curv: 0.2 }); A.ell(0, 33 + h * 0.8, w * 0.45, h * 0.22, { fill: PAL.tongue, w: 0 }); } }
    else if (mood === 'happy') A.stroke([[-12, 32], [0, 38], [12, 32]], { w: 2.2 });
    else if (mood === 'smirk') A.stroke([[-10, 36], [4, 35], [13, 29]], { w: 2.2 });
    else if (mood === 'sad') A.stroke([[-9, 37], [-3, 34], [3, 36], [9, 34]], { w: 2.0 });
    else A.stroke(ang > 0.3 ? [[-10, 37], [0, 34], [10, 37]] : [[-9, 35], [9, 35]], { w: 2.0 });
    // front hair
    if (st === 'mop') { if (c.bangsUp) A.poly([[-47, -8], [-48, -36], [-30, -60], [0, -68], [30, -60], [48, -36], [46, -10], [36, -30], [10, -40], [-20, -38], [-38, -24]], { fill: F.hair, w: 1.2, curv: 0.3 });
      else A.poly([[-47, -6], [-48, -36], [-30, -60], [0, -68], [30, -60], [48, -36], [47, 4], [40, -6], [36, 16], [26, -4], [16, 18], [6, -4], [-6, 16], [-16, -4], [-26, 14], [-34, -6], [-42, 6]], { fill: F.hair, w: 1.2, curv: 0.15 }); }
    else if (st === 'spike') A.poly([[-47, -6], [-50, -40], [-40, -48], [-44, -84], [-22, -62], [-14, -96], [2, -66], [16, -94], [22, -62], [44, -80], [40, -50], [50, -40], [46, -8], [34, -30], [10, -24], [-14, -30], [-34, -20]], { fill: F.hair, w: 1.2, curv: 0.03 });
    else if (st === 'buzz') A.poly([[-46, -6], [-46, -36], [-28, -56], [0, -62], [28, -56], [46, -36], [46, -6], [40, -26], [0, -34], [-40, -26]], { fill: shadeHex(F.skin, 0.55), w: 1, curv: 0.4 });
    else if (st === 'crew') A.poly([[-46, -10], [-46, -38], [-28, -58], [0, -64], [28, -58], [46, -38], [46, -10], [40, -28], [0, -38], [-40, -28]], { fill: F.hair, w: 1, curv: 0.4 });
    else if (st === 'side') A.poly([[-47, -4], [-48, -38], [-28, -62], [4, -68], [34, -60], [50, -36], [48, -10], [30, -34], [-8, -30], [-30, -20], [-44, -2]], { fill: F.hair, w: 1.2, curv: 0.35 });
    else if (st === 'bowl') A.poly([[-49, 0], [-50, -36], [-30, -62], [0, -68], [30, -62], [50, -36], [49, 0], [40, -12], [0, -14], [-40, -12]], { fill: F.hair, w: 1.2, curv: 0.45 });
    else if (st === 'girlBob' || st === 'girlTail') A.poly([[-48, 0], [-50, -36], [-30, -62], [0, -68], [30, -62], [50, -36], [48, 0], [36, -22], [14, -16], [-6, -26], [-28, -14], [-42, -2]], { fill: F.hair, w: 1.2, curv: 0.4 });
    if (c.blush) { A.ell(-28, 24, 9, 4, { fill: PAL.blush, alpha: 120 * c.blush, w: 0 }); A.ell(28, 24, 9, 4, { fill: PAL.blush, alpha: 120 * c.blush, w: 0 }); }
    if (c.sweat) A.poly([[40, -30], [45, -18], [40, -12], [35, -18]], { fill: PAL.sweat, w: 0.8, curv: 0.6 });
    A.pop(); A.setInk(ink0, 1.5);
  }
  // ---------- FX
  function stars(x, y, r, t, n = 4) { for (let i = 0; i < n; i++) { const a = t * 5 + i / n * Math.PI * 2; const px = x + Math.cos(a) * r, py = y + Math.sin(a) * r * 0.35; const k = 9;
    A.poly([[px, py - k], [px + k * 0.3, py - k * 0.3], [px + k, py], [px + k * 0.3, py + k * 0.3], [px, py + k], [px - k * 0.3, py + k * 0.3], [px - k, py], [px - k * 0.3, py - k * 0.3]], { fill: '#ffe46b', w: 1, curv: 0 }); } }
  function arc(cx, cy, r, a0, a1, w = 26, col = '#ffffff', alpha = 200) { // motion smear (crescent)
    const pts = [], n = 14; for (let i = 0; i <= n; i++) { const a = a0 + (a1 - a0) * i / n; pts.push([cx + Math.cos(a) * r, cy + Math.sin(a) * r]); }
    for (let i = n; i >= 0; i--) { const a = a0 + (a1 - a0) * i / n, rr = r - w * Math.sin(i / n * Math.PI); pts.push([cx + Math.cos(a) * rr, cy + Math.sin(a) * rr]); }
    A.poly(pts, { fill: col, alpha, w: 0, curv: 0.3 });
  }
  function burst(x, y, r, t, col = '#fff6d8', n = 10) { const pts = []; for (let i = 0; i < n * 2; i++) { const a = i / (n * 2) * Math.PI * 2 + t, rr = i % 2 ? r * 0.45 : r * (0.9 + 0.2 * Math.sin(i * 3.3)); pts.push([x + Math.cos(a) * rr, y + Math.sin(a) * rr]); } A.poly(pts, { fill: col, w: 1.6, curv: 0 }); }
  return { body, face, at, P, stars, arc, burst, shadeHex, LOOK };
})();
