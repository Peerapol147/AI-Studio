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
  boss:  { tall: 1.13, skin: '#d9a67c', skinSh: '#b9825e', shirt: '#f6f4ec', shirtSh: '#d6d8de', pants: '#232c4c', sock: '#f0efe8', shoe: '#1d1b22', hair: '#231a18', build: 1.24, hairStyle: 'spike', untucked: true, rolled: true, tank: '#c8443a' },
  jo:    { tall: 0.99, belly: 1, skin: '#e8b48c', skinSh: '#c98d68', shirt: '#f6f4ec', shirtSh: '#d6d8de', pants: '#232c4c', sock: '#f0efe8', shoe: '#1d1b22', hair: '#2a2224', build: 1.5, hairStyle: 'buzz', untucked: true },
  te:    { tall: 1.1, skin: '#ecc09a', skinSh: '#cf9a74', shirt: '#f6f4ec', shirtSh: '#d6d8de', pants: '#232c4c', sock: '#f0efe8', shoe: '#1d1b22', hair: '#3b2a22', build: 0.8, hairStyle: 'side', untucked: true },
  saeng: { faceAs: 'legend', skin: '#cf9a72', skinSh: '#b07e5a', shirt: '#5a6470', shirtSh: '#4a525c', pants: '#2a2a34', longPants: true, sock: '#2a2a34', shoe: '#3a3030', hair: '#8f8a8e', build: 1.25, hairStyle: 'grey', untucked: true, stache: true },
  kidK:  { skin: '#f1c9a5', skinSh: '#d9a07e', shirt: '#7aa0c8', shirtSh: '#6a8eb2', pants: '#3a3a44', sock: '#f1c9a5', shoe: '#5a4a3a', hair: '#1b1820', build: 0.8, hairStyle: 'mop', short: 0.74, untucked: true, casual: true },
  teacher: { skin: '#f0c8a4', skinSh: '#d8a884', shirt: '#f2b8c6', shirtSh: '#d99aa8', pants: '#3a4660', skirt: true, sock: '#e8c0a0', shoe: '#5a3a3a', hair: '#2a2024', build: 0.92, hairStyle: 'girl', tall: 1.02 },
  mewS:  { faceAs: 'mew', skin: '#f6d3b5', skinSh: '#dcb090', shirt: '#fbfaf5', shirtSh: '#dfe3ea', pants: '#26335a', skirt: true, sock: '#f4f4f0', shoe: '#1d1b22', hair: '#1f1a1e', build: 0.84, hairStyle: 'girl', short: 0.94 },
  fernS: { faceAs: 'fern', skin: '#e9bb93', skinSh: '#cc9a72', shirt: '#fbfaf5', shirtSh: '#dfe3ea', pants: '#26335a', skirt: true, sock: '#f4f4f0', shoe: '#1d1b22', hair: '#3a2620', build: 0.84, hairStyle: 'girl', short: 0.95 },
  nutS:  { faceAs: 'nut', skin: '#e3ad86', skinSh: '#c48e68', shirt: '#fbfaf5', shirtSh: '#dfe3ea', pants: '#26335a', sock: '#f4f4f0', shoe: '#1d1b22', hair: '#1c181c', build: 0.95, hairStyle: 'buzz' },
  extra: { skin: '#eebf98', skinSh: '#d09c76', shirt: '#fbfaf5', shirtSh: '#dfe3ea', pants: '#26335a', sock: '#f4f4f0', shoe: '#1d1b22', hair: '#231c20', build: 0.9, hairStyle: 'side' },
  shadow: { skin: '#26222e', skinSh: '#1d1a24', shirt: '#2c2836', shirtSh: '#221f2a', pants: '#1a1820', sock: '#1a1820', shoe: '#121016', hair: '#121016', build: 1.22, hairStyle: 'side', tall: 1.16, untucked: true, casual: true },
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
    const L = Object.assign({}, LOOK[c.look], c.lookOver || {}), po = P(c.pose || {}), u = c.s / 100 * (L.short || 1) * (L.tall || 1), bw = L.build;
    // auto-ground
    const hip0 = [0, -50];
    const lowF = legPts(hip0, po.legF, 1)[2][1], lowB = legPts(hip0, po.legB, -1)[2][1];
    const lowest = Math.max(po.groundF === false ? -999 : lowF, po.groundB === false ? -999 : lowB, lowF > -999 && lowB > -999 ? -999 : 0);
    const hip = [po.hip, -50 - (lowest - 0) - 3 - (po.air || 0)];
    A.push(); A.translate(c.x, c.y); A.scale((c.f || 1) * u, u);
    if (po.spin) { A.translate(0, hip[1]); A.rotate(po.spin); A.translate(0, -hip[1]); }
    if (po.lie) { A.translate(0, -hip[1] * po.lie * 0.86); A.translate(0, hip[1]); A.rotate(-Math.PI / 2 * po.lie * (po.lieDir || 1)); A.translate(0, -hip[1]); }
    if (!c.noShadow && !po.air) A.ell(po.hip, -0.5, 16 * bw, 2.2, { fill: '#000000', alpha: 40, w: 0 });
    const up = [sin(po.lean), -cos(po.lean)];
    const sh = add(hip, up, 27), neck = add(hip, up, 30), hc = add(hip, up, 40);
    const shirtCol = c.shirtOverride || L.shirt;
    const arm = (side, ang, hand) => {
      const s0 = [sh[0] + (side > 0 ? -2.6 : 4.2) * bw * cos(po.lean), sh[1] + (side > 0 ? -2.6 : 4.2) * bw * sin(po.lean) + 1]; const el = add(s0, dir(ang[0]), 15), hd = add(el, dir(ang[0] + ang[1]), 14);
      const far = side < 0, sk = far ? L.skinSh : L.skin;
      // sleeve (upper third) + skin arm
      const sl = add(s0, dir(ang[0]), L.rolled ? 5 : 7.5), dv = dir(ang[0]), nv = [dv[1], -dv[0]], r0 = 3.9 * bw, r1 = 4.5 * bw;
      A.limb(s0[0], s0[1], el[0], el[1], 3.3 * bw, 2.9 * bw, { fill: sk, w: 1 });
      A.limb(el[0], el[1], hd[0], hd[1], 2.9 * bw, 2.4 * bw, { fill: sk, w: 1 });
      A.ell(el[0], el[1], 2.55 * bw, 2.55 * bw, { fill: sk, w: 0 }); // hide the seam at the elbow
      // short sleeve: flared tube from the shoulder (not a ball)
      A.poly([add(add(s0, dv, -2.2), nv, r0), add(sl, nv, r1), add(sl, nv, -r1), add(add(s0, dv, -2.2), nv, -r0)], { fill: far ? L.shirtSh : shirtCol, w: 1, curv: 0.25 });
      handDraw(hd, ang[0] + ang[1], hand, sk);
    };
    const handDraw = (p, a, kind, sk) => {
      if (kind === 'open') A.ell(p[0] + sin(a) * 1.4, p[1] + cos(a) * 1.4, 2.6, 3.8, { fill: sk, w: 0.9 }, -a);
      else if (kind === 'wai') A.ell(p[0] + sin(a) * 1.6, p[1] + cos(a) * 1.6, 2.2, 4.4, { fill: sk, w: 0.9 }, -a);
      else { const d = dir(a), n = [d[1], -d[0]], r = 3.3 * Math.sqrt(bw), q = (u, v) => [p[0] + d[0] * u * r + n[0] * v * r, p[1] + d[1] * u * r + n[1] * v * r]; // fist: rounded block + knuckle line
        A.poly([q(-0.7, -0.95), q(0.75, -1.05), q(1.25, -0.2), q(1.05, 0.9), q(-0.7, 0.95)], { fill: sk, w: 0.95, curv: 0.5 }); A.stroke([q(0.55, -0.9), q(0.75, 0.75)], { w: 0.5 }); }
    };
    const leg = (side, ang, ft) => {
      const [h, k, a] = legPts(hip, ang, side), far = side < 0;
      const pant = far ? A.shadeHex ? A.shadeHex(L.pants, 0.8) : L.pants : L.pants;
      // shin (skin) + sock, thigh covered by shorts to just above the knee
      const pc = far ? shadeHex(L.pants, 0.78) : L.pants;
      if (L.longPants) { A.limb(k[0], k[1], a[0], a[1], 3.9 * bw, 3.4 * bw, { fill: pc, w: 1 }); A.limb(h[0], h[1], k[0], k[1], 5.0 * bw, 4.2 * bw, { fill: pc, w: 1 }); A.ell(k[0], k[1], 3.6 * bw, 3.6 * bw, { fill: pc, w: 0 }); }
      else {
        A.limb(k[0], k[1], a[0], a[1], 3.4 * bw, 2.6 * bw, { fill: far ? L.skinSh : L.skin, w: 1 });
        const s1 = [k[0] + (a[0] - k[0]) * 0.62, k[1] + (a[1] - k[1]) * 0.62];
        A.limb(s1[0], s1[1], a[0], a[1], 2.7 * bw, 2.5 * bw, { fill: L.sock, w: 0.9 });
        if (L.skirt) { A.limb(h[0], h[1], k[0], k[1], 3.8 * bw, 3.4 * bw, { fill: far ? L.skinSh : L.skin, w: 1 }); A.ell(k[0], k[1], 3.0 * bw, 3.0 * bw, { fill: far ? L.skinSh : L.skin, w: 0 }); }
        else { const kk = [h[0] + (k[0] - h[0]) * 0.86, h[1] + (k[1] - h[1]) * 0.86]; A.limb(h[0], h[1], kk[0], kk[1], 5.4 * bw, 4.9 * bw, { fill: pc, w: 1 }); }
      }
      // shoe: perpendicular to shin (ft 0) .. pointed along shin (ft 1)
      const sa = ang[0] + ang[1], fd0 = [cos(sa), -sin(sa)], fd1 = dir(sa), fd = [fd0[0] * (1 - ft) + fd1[0] * ft, fd0[1] * (1 - ft) + fd1[1] * ft];
      const n = [fd[1], -fd[0]], toe = add(a, fd, 7.5), heel = add(a, fd, -3.2);
      A.poly([add(heel, n, 2.2), add(toe, n, 1.4), add(toe, n, -1.6), add(heel, n, -2.4)], { fill: L.shoe, w: 0.9, curv: 0.45 });
    };
    arm(-1, po.armB, po.handB);
    leg(-1, po.legB, po.ftB);
    leg(1, po.legF, po.ftF);
    if (!L.skirt) A.ell(hip[0], hip[1] + 0.5, 6.6 * bw, 4.6 * bw, { fill: L.pants, w: 0 }); // pelvis: joins the two thighs under the shirt
    if (L.skirt) { const kx = (legPts(hip, po.legF, 1)[1][0] + legPts(hip, po.legB, -1)[1][0]) / 2; A.poly([[hip[0] - 8 * bw, hip[1] - 2], [hip[0] + 8 * bw, hip[1] - 2], [Math.max(hip[0] + 11.5 * bw, kx + 7), hip[1] + 26.5], [Math.min(hip[0] - 11.5 * bw, kx - 7), hip[1] + 26.5]], { fill: L.pants, w: 1.1, curv: 0.2 }); }
    // torso (shirt) — tucked: ends at belt; untucked: hangs over the hips
    const rotp = (p) => { const s = sin(po.lean), co = cos(po.lean), x = p[0], y = p[1]; return [hip[0] + x * co - y * s, hip[1] + x * s + y * co]; };
    const w = 8.4 * bw, tail = L.untucked ? 6 : 1.5;
    A.poly([[-w * 0.78, -30], [w * 0.7, -30], [w * 1.04, -25], [w * (L.belly ? 1.2 : 1.08), -12], [w * (L.belly ? 1.22 : 0.98), 0], [w * 1.04, tail], [-w * 1.0, tail], [-w * 0.98, 2], [-w * 1.06, -14], [-w * 1.04, -25]].map(rotp), { fill: shirtCol, w: 1.1, curv: 0.3 });
    if (!L.untucked) A.poly([[-w * 1.05, 0], [w * 1.0, 0], [w * 1.0, 2.4], [-w * 1.05, 2.4]].map(rotp), { fill: '#1e1a20', w: 0, curv: 0 }); // belt
    A.poly([[w * 0.0, -30.5], [w * 0.75, -30], [w * 0.42, -24.5]].map(rotp), { fill: L.shirtSh, w: 0.6, curv: 0 }); A.poly([[-w * 0.5, -30.5], [w * 0.0, -30.5], [-w * 0.1, -25.5]].map(rotp), { fill: L.shirtSh, w: 0.6, curv: 0 }); // collar (both wings)
    if (L.mark) A.stroke([[w * 0.35, -22], [w * 0.75, -22.3]].map(rotp), { ink: L.mark, w: 0.6 }); // embroidered initials (abstract)
    if (L.tank) A.poly([[-w * 0.05, -29.4], [w * 0.5, -29.4], [w * 0.24, -24.6]].map(rotp), { fill: L.tank, w: 0, curv: 0 }); // red undershirt at open collar
    A.stroke([[w * 0.2, -24], [w * 0.26, tail - 1]].map(rotp), { ink: '#c7cad2', w: 0.5 }); // button line
    // neck + head
    A.limb(neck[0], neck[1], neck[0] + up[0] * 5, neck[1] + up[1] * 5, 2.6 * bw, 2.6 * bw, { fill: L.skinSh, w: 0.8 });
    A.push(); A.translate(hc[0], hc[1]); A.rotate(po.lean + (po.head || 0)); headSide(L, c.face || {}); A.pop();
    arm(1, po.armF, po.handF);
    A.pop();
  }
  const shadeHex = (hex, f) => { const n = parseInt(hex.slice(1), 16); const r = (n >> 16) * f | 0, g = ((n >> 8) & 255) * f | 0, b = (n & 255) * f | 0; return '#' + ((1 << 24) + (r << 16) + (g << 8) + b).toString(16).slice(1); };
  // ---------- ONE head for every shot: the close-up face and the head on the side-view body are the same drawing.
  // turn = 0 front (close-ups) .. ~0.7 three-quarter (on the side body, facing +x). 100 units = face height, origin = face centre.
  // Features slide toward the facing side, the far half narrows, the skull grows backward: same eyes, brows, hair, mouth in wide shots and close-ups.
  const FACES = {
    legend: { skin: '#cf9a72', hair: '#8f8a8e', style: 'crew', shirt: '#4a5a6a', scar: true, stache: true, neck: 1.25 },
    mew:  { skin: '#f6d3b5', hair: '#1f1a1e', style: 'girlBob', shirt: 'girl', tie: '#26335a' },
    fern: { skin: '#e9bb93', hair: '#3a2620', style: 'girlTail', shirt: 'girl', tie: '#26335a' },
    nut:  { skin: '#e3ad86', hair: '#1c181c', style: 'buzz', shirt: 'boy' },
  };
  const faceOf = (who, L) => FACES[(L && L.faceAs) || who] || Object.assign({}, L || LOOK[who], { style: (L || LOOK[who]).hairStyle, shirt: (L || LOOK[who]).casual ? (L || LOOK[who]).shirt : (L || LOOK[who]).skirt ? 'girl' : 'boy', tie: '#26335a' });
  function head(F, c, turn) {
    const t = turn, ang = c.anger || 0, m = c.mouth || 0, bl = c.blink || 0, mood = c.mood || 'calm', eyes = c.eyes || 'normal', st = F.style;
    const wy = y => A.clamp((y + 62) / 40, 0, 1);
    const fs = x => (x > 2 ? 1 - 0.42 * t : 1 - 0.06 * t);                                  // far half narrows
    const Fm = (x, y) => [x * (1 + (fs(x) - 1) * wy(y)) + 13 * t * wy(y), y];              // features
    const Om = (x, y) => [x > 0 ? x * (1 - 0.2 * t * wy(y)) + (y > 28 ? 9 * t * (y - 28) / 24 : 0) : x - 8 * t * (y < 20 ? 1 : Math.max(0, 1 - (y - 20) / 20)) + (y > 28 ? 9 * t * (y - 28) / 24 : 0), y]; // outline + back hair
    const Hm = (x, y) => (Math.abs(x) >= 40 || y < -34) ? Om(x, y) : Fm(x, y);              // fringe follows the features, the rest the skull
    const mp = (pts, mf) => pts.map(p => mf(p[0], p[1]));
    const dk = window.CRISP ? 0.41 * Math.pow(A.k(), 0.7) : 1, dw = w => w * dk;           // feature strokes scale with the head (brows stay bold in wide shots)
    const fE = (x, y, rx, ry, o) => { const q = Fm(x, y); A.ell(q[0], q[1], rx * fs(x), ry, o); };
    const fS = (pts, o) => A.stroke(mp(pts, Fm), o), fP = (pts, o) => A.poly(mp(pts, Fm), o);
    // back hair
    if (st === 'girlBob' || st === 'girl') A.poly(mp([[-58, 40], [-56, -30], [-36, -64], [0, -72], [36, -64], [56, -30], [58, 40], [40, 46], [44, 10], [-44, 10], [-40, 46]], Om), { fill: F.hair, w: 1.2, curv: 0.35 });
    else if (st === 'girlTail') { A.poly(mp([[-50, 10], [-52, -32], [-34, -62], [0, -70], [34, -62], [52, -32], [50, 10]], Om), { fill: F.hair, w: 1.2, curv: 0.4 }); const tx = t ? -1 : 1; A.poly(mp([[40 * tx, -40], [74 * tx, -20], [80 * tx, 30], [66 * tx, 60], [58 * tx, 20], [46 * tx, -10]], Om), { fill: F.hair, w: 1.2, curv: 0.4 }); }
    else if (st !== 'buzz' && st !== 'crew') A.poly(mp([[-50, 10], [-54, -30], [-36, -62], [0, -70], [36, -62], [54, -30], [50, 10]], Om), { fill: F.hair, w: 1.2, curv: 0.4 });
    if (t < 0.3) { A.ell(-45, 6, 7, 11, { fill: F.skin, w: 1 }); A.ell(45, 6, 7, 11, { fill: F.skin, w: 1 }); }
    const fp = []; for (let i = 0; i <= 10; i++) { const a = Math.PI + i / 10 * Math.PI; fp.push([46 * cos(a), -5 + 50 * sin(a)]); }
    fp.push([44, 6], [36, 30], [14, 48], [0, 52], [-14, 48], [-36, 30], [-44, 6]);
    A.poly(mp(fp, Om), { fill: F.skin, w: 1.4, curv: 0.4 });
    if (t >= 0.3) { const ex = -45 + 9 * t; A.ell(ex, 9, 6.5, 10.5, { fill: shadeHex(F.skin, 0.93), w: 1 }); }
    // eyes
    for (const sx of [-1, 1]) {
      const ex = sx * 19, ey = 6, ry = (eyes === 'wide' ? 15 : 12) * (1 - bl) * (1 - ang * 0.3);
      if (eyes === 'shut' || c.eyesClosed) fS(mood === 'happy' ? [[ex - 10, ey + 3], [ex, ey - 4], [ex + 10, ey + 3]] : [[ex - 10, ey], [ex, ey + 4], [ex + 10, ey]], { w: dw(2.4) });
      else if (eyes === 'dazed') { fS([[ex - 9, ey - 8], [ex + 9, ey + 8]], { w: dw(2.6) }); fS([[ex + 9, ey - 8], [ex - 9, ey + 8]], { w: dw(2.6) }); }
      else if (eyes === 'fierce') { fP([[ex - 12 * sx, ey + 2], [ex + 12 * sx, ey - 6], [ex + 10 * sx, ey + 5], [ex - 10 * sx, ey + 6]], { fill: PAL.white, w: 1.4, curv: 0.2 }); fE(ex + sx * 1, ey + 0.5, 4.2, 5, { fill: '#1a1214', w: 0 }); fE(ex + sx * 1 + 1.6, ey - 1.4, 1.6, 1.6, { fill: '#fff6c8', w: 0 }); fS([[ex - 13 * sx, ey + 2], [ex + 13 * sx, ey - 7]], { w: dw(3.6) }); }
      else if (ry < 1.5) fS([[ex - 11, ey], [ex + 11, ey]], { w: dw(2.4) });
      else {
        fE(ex, ey, eyes === 'wide' ? 13 : 10.5, ry, { fill: PAL.white, w: 1.2 });
        const lx = (c.look || 0) * 3 + 2.5 * t, pr = eyes === 'wide' ? 0.45 : 1;
        fE(ex + lx, ey + ry * 0.12, 6.4 * pr, Math.min(ry * 0.85, 8.6) * pr, { fill: F.iris || '#3a2a24', w: 0.6 });
        if (eyes !== 'wide') fE(ex + lx, ey + ry * 0.15, 3.2, Math.min(ry * 0.45, 4.2), { fill: '#1a1214', w: 0 });
        fE(ex + lx + 2.4 * pr, ey - ry * 0.25 * pr, 2.2 * pr, 2.4 * pr, { fill: '#ffffff', w: 0 });
        fS([[ex - 12, ey - ry * 0.7], [ex, ey - ry * 1.05], [ex + 12, ey - ry * 0.7]], { w: dw(3.0) });
      }
      const inner = mood === 'sad' ? -26 : eyes === 'wide' ? -30 : eyes === 'fierce' ? -12 : -18 + ang * 10, outer = mood === 'sad' ? -16 : eyes === 'wide' ? -28 : eyes === 'fierce' ? -24 : -22 - ang * 4;
      fS([[sx * 8, ey + inner], [sx * 30, ey + outer]], { w: dw(4.2), curv: 0.2 });
      if (F.glasses) fP([[ex - 14, ey - 12], [ex + 14, ey - 12], [ex + 14, ey + 12], [ex - 14, ey + 12]], { ink: '#2a2428', w: dw(1.4), curv: 0.45 });
    }
    if (F.glasses) { fS([[-5, 2], [5, 2]], { ink: '#2a2428', w: dw(1.4) }); if (t >= 0.3) A.stroke([Fm(-33, 4), [-45 + 9 * t + 2, 4]], { ink: '#2a2428', w: dw(1.2) }); }
    if (F.scar) fS([[22, -22], [30, -6]], { ink: '#9a5a4a', w: dw(1.8) });
    if (t) { const n = Fm(4, 10); A.stroke([n, [n[0] + 9 * t, 21], [n[0] + 1, 25]], { w: dw(1.4) }); } else A.stroke([[1, 16], [3, 23], [-1, 24]], { w: dw(1.2) });
    if (F.stache) fP([[-16, 30], [0, 26], [16, 30], [12, 33], [0, 31], [-12, 33]], { fill: '#6e676c', w: 0.8, curv: 0.3 });
    // mouth: mouthO = jaw-drop "O" (wow)
    if (c.mouthO) { const h = 10 + c.mouthO * 26, w = 8 + c.mouthO * 7; fE(0, 38 + h * 0.3, w, h * 0.6, { fill: PAL.mouth, w: 1.3 }); fE(0, 38 + h * 0.55, w * 0.6, h * 0.22, { fill: PAL.tongue, w: 0 }); }
    else if (m > 0.08) { const h = 3 + m * 20, w = 9 + m * 9;
      fP([[-w, 33], [w, 33], [w * 0.7, 33 + h], [-w * 0.7, 33 + h]], { fill: PAL.mouth, w: 1.2, curv: 0.45 });
      if (m > 0.3) { fP([[-w * 0.8, 33.5], [w * 0.8, 33.5], [w * 0.7, 37], [-w * 0.7, 37]], { fill: '#ffffff', w: 0, curv: 0.2 }); fE(0, 33 + h * 0.8, w * 0.45, h * 0.22, { fill: PAL.tongue, w: 0 }); } }
    else if (mood === 'happy') fS([[-12, 32], [0, 38], [12, 32]], { w: dw(2.2) });
    else if (mood === 'smirk') fS([[-10, 36], [4, 35], [13, 29]], { w: dw(2.2) });
    else if (mood === 'sad') fS([[-9, 37], [-3, 34], [3, 36], [9, 34]], { w: dw(2.0) });
    else fS(ang > 0.3 ? [[-10, 37], [0, 34], [10, 37]] : [[-9, 35], [9, 35]], { w: dw(2.0) });
    // front hair
    const hp = (pts, o) => A.poly(mp(pts, Hm), o);
    if (st === 'mop') { if (c.bangsUp) hp([[-47, -8], [-48, -36], [-30, -60], [0, -68], [30, -60], [48, -36], [46, -10], [36, -30], [10, -40], [-20, -38], [-38, -24]], { fill: F.hair, w: 1.2, curv: 0.3 });
      else hp([[-47, -6], [-48, -36], [-30, -60], [0, -68], [30, -60], [48, -36], [47, 4], [40, -6], [36, 16], [26, -4], [16, 18], [6, -4], [-6, 16], [-16, -4], [-26, 14], [-34, -6], [-42, 6]], { fill: F.hair, w: 1.2, curv: 0.15 }); }
    else if (st === 'spike') hp([[-47, -6], [-50, -40], [-40, -48], [-44, -84], [-22, -62], [-14, -96], [2, -66], [16, -94], [22, -62], [44, -80], [40, -50], [50, -40], [46, -8], [34, -30], [10, -24], [-14, -30], [-34, -20]], { fill: F.hair, w: 1.2, curv: 0.03 });
    else if (st === 'buzz') hp([[-46, -6], [-46, -36], [-28, -56], [0, -62], [28, -56], [46, -36], [46, -6], [40, -26], [0, -34], [-40, -26]], { fill: shadeHex(F.skin, 0.55), w: 1, curv: 0.4 });
    else if (st === 'crew' || st === 'grey') hp([[-46, -10], [-46, -38], [-28, -58], [0, -64], [28, -58], [46, -38], [46, -10], [40, -28], [0, -38], [-40, -28]], { fill: F.hair, w: 1, curv: 0.4 });
    else if (st === 'side') hp([[-47, -4], [-48, -38], [-28, -62], [4, -68], [34, -60], [50, -36], [48, -10], [30, -34], [-8, -30], [-30, -20], [-44, -2]], { fill: F.hair, w: 1.2, curv: 0.35 });
    else if (st === 'bowl') hp([[-49, 0], [-50, -36], [-30, -62], [0, -68], [30, -62], [50, -36], [49, 0], [40, -12], [0, -14], [-40, -12]], { fill: F.hair, w: 1.2, curv: 0.45 });
    else if (st === 'girlBob' || st === 'girlTail' || st === 'girl') hp([[-48, 0], [-50, -36], [-30, -62], [0, -68], [30, -62], [50, -36], [48, 0], [36, -22], [14, -16], [-6, -26], [-28, -14], [-42, -2]], { fill: F.hair, w: 1.2, curv: 0.4 });
    if (c.blush) { fE(-28, 24, 9, 4, { fill: PAL.blush, alpha: 120 * c.blush, w: 0 }); fE(28, 24, 9, 4, { fill: PAL.blush, alpha: 120 * c.blush, w: 0 }); }
    if (c.sweat) { const q = Om(t ? -34 : 40, -30); A.poly([[q[0], -30], [q[0] + 5, -18], [q[0], -12], [q[0] - 5, -18]], { fill: PAL.sweat, w: 0.8, curv: 0.6 }); }
    if (c.tear) for (const sx of [-1, 1]) fP([[sx * 19 - 3, 20], [sx * 19, 14], [sx * 19 + 3, 20], [sx * 19, 27]], { fill: PAL.sweat, w: 0.7, curv: 0.6 });
  }
  const TURN = 0.82;
  function headSide(L, fc) { // head on the side-view body (called at the head centre, body units): same drawing as the close-up, turned 3/4
    const ink0 = A.INK; A.setInk(ink0, 3.4); A.push(); A.scale(0.212); A.translate(-6, 0);
    head(faceOf(null, L), Object.assign({ bangsUp: L.bangsUp }, fc), TURN); A.pop(); A.setInk(ink0, 1.5);
  }
  // ---------- front face (close-ups, reactions) — origin = face center, 100 = face height
  // c: { who: look key | 'legend' | girl keys, x, y, s, tilt, mood, anger, mouth, mouthO, blink, eyes, look, sweat, blush, shrug, turn }
  function face(c) {
    const F = faceOf(c.who);
    const ink0 = A.INK; A.setInk(ink0, 3.4); A.push(); A.translate(c.x, c.y); A.scale(c.s / 100); A.rotate(c.tilt || 0);
    const sh = c.shrug || 0, nk = F.neck || 1;
    if (!c.noBody) A.limb(0, 40, 0, 76, 16 * nk, 18 * nk, { fill: shadeHex(F.skin, 0.86), w: 1 });
    // body / uniform
    if (c.noBody) {} else if (F.shirt === 'boy' || F.shirt === 'girl') {
      A.poly([[-130, 700], [-118, 100 + sh], [-58, 70], [58, 70], [118, 100 + sh], [130, 700]], { fill: '#fbfaf5', w: 1.4, curv: 0.18 });
      if (F.shirt === 'boy') { A.poly([[-34, 62], [-1, 98], [-6, 106], [-44, 78]], { fill: '#e6e9ef', w: 1, curv: 0.1 }); A.poly([[34, 62], [1, 98], [6, 106], [44, 78]], { fill: '#e6e9ef', w: 1, curv: 0.1 }); A.stroke([[0, 104], [0, 700]], { w: 0.8 }); if (F.mark) A.stroke([[40, 150], [64, 148]], { ink: F.mark, w: 1.4 }); if (F.tank) A.poly([[-20, 76], [0, 98], [20, 76]], { fill: F.tank, w: 0, curv: 0 }); }
      else { A.poly([[-30, 64], [0, 92], [30, 64], [22, 60], [0, 80], [-22, 60]], { fill: '#eef0f4', w: 1, curv: 0.1 }); A.poly([[-4, 92], [-26, 130], [-10, 140], [0, 104], [10, 140], [26, 130], [4, 92]], { fill: F.tie, w: 1, curv: 0.2 }); A.ell(0, 96, 9, 7, { fill: F.tie, w: 1 }); }
    } else A.poly([[-134, 700], [-122, 100 + sh], [-60, 70], [60, 70], [122, 100 + sh], [134, 700]], { fill: F.shirt, w: 1.4, curv: 0.18 });
    head(F, c, c.turn || 0);
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
  // lightning bolt (zigzag) from (x0,y0) to (x1,y1); jitter re-seeded on twos so it crackles
  // lightning bolt (zigzag) from (x0,y0) to (x1,y1); jitter re-seeded on twos so it crackles.
  // electric look: wide blue glow -> cyan body -> white-hot core, with 2 branching forks
  const BOLT = ['#2f7dff', '#7fd4ff', '#e8fbff', '#ffffff'];
  function zig(x0, y0, x1, y1, amp, seg) { const pts = [[x0, y0]], dx = x1 - x0, dy = y1 - y0, L = Math.hypot(dx, dy) || 1, nx = -dy / L, ny = dx / L;
    for (let i = 1; i < seg; i++) { const k = i / seg, o = (A.R() - 0.5) * 2 * amp * Math.sin(Math.PI * k) + (i % 2 ? amp * 0.5 : -amp * 0.5); pts.push([x0 + dx * k + nx * o, y0 + dy * k + ny * o]); }
    pts.push([x1, y1]); return pts; }
  function ribbon(pts, w, col, al) { const Lf = [], Rt = []; pts.forEach((p, i) => { const q = pts[Math.min(i + 1, pts.length - 1)], r = pts[Math.max(i - 1, 0)], ddx = q[0] - r[0], ddy = q[1] - r[1], l = Math.hypot(ddx, ddy) || 1, ww = w * (i === 0 ? 0.6 : i === pts.length - 1 ? 0.15 : 1);
    Lf.push([p[0] - ddy / l * ww, p[1] + ddx / l * ww]); Rt.push([p[0] + ddy / l * ww, p[1] - ddx / l * ww]); }); A.poly(Lf.concat(Rt.reverse()), { fill: col, alpha: al, w: 0, curv: 0 }); }
  function bolt(x0, y0, x1, y1, t, amp = 26, seg = 9, wid = 1) {
    A.seed(Math.floor(t * 12) * 97 + Math.round(x0 + y1)); const pts = zig(x0, y0, x1, y1, amp, seg), dx = x1 - x0, dy = y1 - y0, L = Math.hypot(dx, dy) || 1, nx = -dy / L, ny = dx / L;
    const forks = [Math.floor(seg * 0.35), Math.floor(seg * 0.7)].map((b, j) => { const s = j ? -1 : 1, p = pts[b], len = L * A.R(0.22, 0.38); return zig(p[0], p[1], p[0] + (nx * s * 0.8 + dx / L * 0.6) * len, p[1] + (ny * s * 0.8 + dy / L * 0.6) * len, amp * 0.45, 4); });
    ribbon(pts, 17 * wid, BOLT[0], 70); for (const f of forks) ribbon(f, 9 * wid, BOLT[0], 60);
    ribbon(pts, 9.5 * wid, BOLT[1], 190); for (const f of forks) ribbon(f, 4.2 * wid, BOLT[1], 220);
    ribbon(pts, 4.6 * wid, BOLT[2], 255); for (const f of forks) ribbon(f, 1.8 * wid, BOLT[3], 255);
    ribbon(pts, 2.0 * wid, BOLT[3], 255);
  }
  function sparks(x, y, r, t, n = 6) { for (let i = 0; i < n; i++) { const a = i / n * Math.PI * 2 + Math.floor(t * 12) * 0.7; bolt(x, y, x + Math.cos(a) * r, y + Math.sin(a) * r, t + i, r * 0.12, 5, 0.7); } }
  return { body, face, at, P, stars, arc, burst, shadeHex, LOOK, bolt, sparks };
})();
