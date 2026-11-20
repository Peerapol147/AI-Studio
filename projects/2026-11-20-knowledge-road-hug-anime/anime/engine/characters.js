// Character + prop helpers. Side view: origin = between the feet on the ground, 100 units = body height, facing +x.
// Front close-up: origin = face center, 100 units = face height. Call inside A.push()/A.pop() after placing.
/* global A */
const PAL = {
  skin: '#f3c7a1', skinSh: '#dda07f', mouth: '#7a2a32', tongue: '#d8676c', white: '#fffaf2', blush: '#f28b8b', sweat: '#bfe6ff',
  R: { top: '#f6c21c', top2: '#2b2733', pants: '#3a405c', shoe: '#1f1c24', hair: '#1d1a22', iris: '#4a2e1e' },
  D: { top: '#a9cdea', top2: '#7fa6cc', pants: '#55535e', shoe: '#5a3a28', hair: '#2b2526', grey: '#8d8589', iris: '#3a2a24', belt: '#2a2428' },
};
const CH = (() => {
  const sin = Math.sin, cos = Math.cos;
  // ---------- side view person ----------
  function person(c) {
    const P = PAL[c.who], u = c.s / 100;
    A.push(); A.translate(c.x, c.y); A.scale((c.f || 1) * u, u);
    const lean = c.lean || 0, st = c.stride || 0, ph = c.phase || 0;
    const legs = [[-1, 0.9], [1, 1.0]]; // back, front
    const hip = [0, -48];
    const arm = (side, ang) => { // ang: [shoulder from down (+ forward), elbow bend]
      const [a1, a2] = ang, sh = rot([side * 1.5, -77], lean, hip);
      const el = [sh[0] + 15 * sin(a1), sh[1] + 15 * cos(a1)], hd = [el[0] + 14 * sin(a1 + a2), el[1] + 14 * cos(a1 + a2)];
      const col = side < 0 ? shade(P.top, c.who) : P.top;
      A.limb(sh[0], sh[1], el[0], el[1], 3.6, 3.2, { fill: col, w: 1 });
      A.limb(el[0], el[1], hd[0], hd[1], 3.2, 2.8, { fill: col, w: 1 });
      if (c.who === 'R') A.limb(el[0] + (hd[0] - el[0]) * 0.75, el[1] + (hd[1] - el[1]) * 0.75, hd[0], hd[1], 3.0, 2.9, { fill: P.top2, w: 0.8 }); // black cuff
      hand(hd, a1 + a2, side > 0 ? (c.hand || 'fist') : (c.handBack || 'fist'));
    };
    const hand = (p, a, kind) => {
      if (kind === 'point') { A.ell(p[0], p[1], 2.9, 2.9, { fill: PAL.skin, w: 0.9 }); A.limb(p[0], p[1], p[0] + 5.5 * sin(a), p[1] + 5.5 * cos(a), 1.0, 0.9, { fill: PAL.skin, w: 0.8 }); }
      else if (kind === 'open') A.ell(p[0] + sin(a) * 1.2, p[1] + cos(a) * 1.2, 2.7, 3.8, { fill: PAL.skin, w: 0.9 }, -a);
      else A.ell(p[0], p[1], 3.0, 3.0, { fill: PAL.skin, w: 0.9 });
    };
    const leg = ([side, sh]) => {
      const sw = st * sin(ph + (side > 0 ? 0 : Math.PI));
      const kn = [side * 1.5 + sw * 7, -25], an = [side * 2.5 + sw * 12, -3 + Math.max(0, -sw) * 2];
      const col = side < 0 ? shade(P.pants, 'x') : P.pants;
      A.limb(hip[0] + side * 1.5, hip[1], kn[0], kn[1], 4.4, 3.8, { fill: col, w: 1 });
      A.limb(kn[0], kn[1], an[0], an[1], 3.8, 3.3, { fill: col, w: 1 });
      A.poly([[an[0] - 3.5, an[1] - 2], [an[0] + 6.5, an[1] - 1.5], [an[0] + 7.5, an[1] + 2.6], [an[0] - 3.8, an[1] + 3]], { fill: P.shoe, w: 0.9, curv: 0.4 });
    };
    arm(-1, c.armBack || [0.15, 0.3]);
    leg(legs[0]); leg(legs[1]);
    // torso
    const T = c.who === 'R'
      ? [[-7, -81], [6, -81], [8.5, -66], [8, -47], [-7.5, -46], [-8.5, -65]]
      : [[-7, -80], [6, -80], [9.5, -64], [12, -55], [9, -46], [-7, -46], [-8.5, -64]];
    A.poly(T.map(p => rot(p, lean, hip)), { fill: P.top, w: 1.1, curv: 0.3 });
    if (c.who === 'R') { // black side panel + collar stripe (generic jacket, no logo)
      A.poly([[-7.6, -72], [-2, -73], [-1.5, -47], [-7.4, -47]].map(p => rot(p, lean, hip)), { fill: P.top2, w: 0.6, curv: 0.2 });
      A.poly([[-5, -82], [5.5, -82], [5, -78.5], [-5, -78.5]].map(p => rot(p, lean, hip)), { fill: P.top2, w: 0.6, curv: 0.2 });
    } else {
      A.poly([[-7.2, -49.5], [9.4, -49.5], [9.2, -46.5], [-7.2, -46]].map(p => rot(p, lean, hip)), { fill: P.belt, w: 0, curv: 0 });
      A.poly([[0, -81], [5, -81], [2.5, -76]].map(p => rot(p, lean, hip)), { fill: '#e8f2fb', w: 0.6, curv: 0 }); // collar
    }
    // head
    const hc = rot([2, -91], lean, hip), hl = lean + (c.tilt || 0);
    A.limb(...rot([0.5, -80], lean, hip), ...rot([1.4, -85], lean, hip), 2.6, 2.6, { fill: PAL.skinSh, w: 0.8 });
    A.push(); A.translate(hc[0], hc[1]); A.rotate(hl); A.scale(1.2); headSide(c, P); A.pop();
    arm(1, c.armFront || [0.12, 0.25]);
    A.pop();
  }
  const shade = (hex, who) => { // darker tone for far limbs
    const n = parseInt(hex.slice(1), 16); const f = 0.82; const r = (n >> 16) * f | 0, g = ((n >> 8) & 255) * f | 0, b = (n & 255) * f | 0;
    return '#' + ((1 << 24) + (r << 16) + (g << 8) + b).toString(16).slice(1);
  };
  function rot(p, a, o) { const s = sin(a), c = cos(a), x = p[0] - o[0], y = p[1] - o[1]; return [o[0] + x * c - y * s, o[1] + x * s + y * c]; }
  function headSide(c, P) {
    const ang = c.anger || 0, m = c.mouth || 0, bl = c.blink || 0, mood = c.mood || 'calm';
    // back hair
    if (c.who === 'R') A.poly([[-9.5, 2], [-10.5, -5], [-7, -9.5], [-1, -11], [5, -10], [9, -6.5], [5, -7.5], [0, -6], [-4, -3], [-6, 2]], { fill: P.hair, w: 1, curv: 0.1 });
    else A.poly([[-9, 3], [-9.6, -4], [-5.5, -9.4], [1, -10.4], [7, -8.6], [9.4, -5.4], [4, -6.6], [-2, -5.6], [-6, 1]], { fill: P.hair, w: 1, curv: 0.4 });
    // face
    A.poly([[-7.8, -2], [-6.5, -7.5], [0, -9.4], [6.5, -7.6], [8.6, -3.6], [8.8, 0.5], [10.4, 2.0], [8.8, 3.0], [8.6, 5.6], [6.4, 8.2], [2.0, 8.6], [-3.6, 5.4], [-7.2, 3]], { fill: PAL.skin, w: 1.1, curv: 0.35 });
    // hair front + top
    if (c.who === 'R') A.poly([[-8.6, -2.5], [-8, -8], [-2.5, -11.6], [3, -12.2], [1.8, -10], [7.5, -10.6], [6.4, -8.6], [10.4, -7.8], [7.6, -5.8], [5.8, -6.2], [2, -6.8], [-2.5, -5], [-5, -1]], { fill: P.hair, w: 1, curv: 0.05 });
    else {
      A.poly([[-8.2, -2], [-7.6, -7.6], [-2, -10.4], [4.5, -10], [8.6, -7], [8.2, -5.2], [3, -7.4], [-2.6, -6.4], [-5.5, -2.6]], { fill: P.hair, w: 1, curv: 0.4 });
      A.poly([[-7.6, -1], [-6.4, -4.2], [-4.6, -2], [-5, 0.6]], { fill: P.grey, w: 0, curv: 0.4 }); // grey temple
    }
    A.ell(-2.4, 0.8, 1.1, 1.6, { fill: PAL.skin, w: 0.7 }); // ear
    // eye
    const eh = Math.max(0.2, 2.1 * (1 - bl) * (1 - ang * 0.25));
    if (c.eyesClosed) A.stroke(mood === 'happy' ? [[4.2, -0.2], [5.4, -1.4], [6.6, -0.2]] : [[4.2, -0.8], [5.4, 0.2], [6.6, -0.8]], { w: 1.4 });
    else { A.ell(5.4, -0.6, 1.15, eh, { fill: P.iris, w: 0.9 }); if (eh > 1) A.ell(5.7, -1.3, 0.45, 0.6, { fill: '#ffffff', w: 0 }); }
    // brow
    const by = mood === 'sad' ? [[3.2, -3.6], [7.4, -5.2]] : [[3.0, -4.4 - (1 - ang) * 0.4], [7.6, -4.4 + ang * 2.0]];
    A.stroke(by, { w: 2.2, curv: 0.2 });
    if (c.who === 'D') { A.ell(5.6, -0.5, 2.4, 2.0, { ink: '#2a2428', w: 0.9 }); A.stroke([[3.2, -0.8], [-1.4, -1.6]], { ink: '#2a2428', w: 0.8 }); }
    // mouth
    if (m > 0.08) {
      const h = 0.5 + m * 2.8, w = 1.5 + m * 0.6;
      A.ell(6.9, 4.7, w, h, { fill: PAL.mouth, w: 0.9 }); if (m > 0.4) A.ell(6.9, 4.7 + h * 0.5, w * 0.7, h * 0.35, { fill: PAL.tongue, w: 0 });
    } else if (mood === 'happy') A.stroke([[5.4, 4.2], [6.8, 5.2], [8.2, 4.4]], { w: 1.1 });
    else A.stroke(ang > 0.3 || mood === 'sad' ? [[5.6, 5.0], [7.0, 4.5], [8.2, 4.8]] : [[5.6, 4.7], [8.2, 4.6]], { w: 1.1 });
    if (c.blush) A.ell(5.6, 2.6, 2.2, 1.0, { fill: PAL.blush, alpha: 110 * c.blush, w: 0 });
    if (c.sweat) A.poly([[-2.5, -6], [-1.6, -3.6], [-2.5, -2.4], [-3.4, -3.6]], { fill: PAL.sweat, w: 0.6, curv: 0.6 });
  }
  // ---------- front close-up (head + shoulders) ----------
  function face(c) {
    const P = PAL[c.who], ang = c.anger || 0, m = c.mouth || 0, bl = c.blink || 0, mood = c.mood || 'calm';
    const ink0 = A.INK; A.setInk(ink0, 3.4); A.push(); A.translate(c.x, c.y); A.scale(c.s / 100); A.rotate(c.tilt || 0);
    // body
    const sh = c.shrug || 0;
    if (c.who === 'R') {
      A.poly([[-120, 210], [-112, 95 + sh], [-58, 68], [58, 68], [112, 95 + sh], [120, 210]], { fill: P.top, w: 1.4, curv: 0.25 });
      A.poly([[-16, 66], [16, 66], [8, 210], [-8, 210]], { fill: P.top2, w: 1, curv: 0.1 });
      A.poly([[-112, 100 + sh], [-90, 92 + sh], [-86, 210], [-118, 210]], { fill: P.top2, w: 1, curv: 0.1 });
      A.poly([[112, 100 + sh], [90, 92 + sh], [86, 210], [118, 210]], { fill: P.top2, w: 1, curv: 0.1 });
    } else {
      A.poly([[-124, 210], [-116, 98 + sh], [-56, 70], [56, 70], [116, 98 + sh], [124, 210]], { fill: P.top, w: 1.4, curv: 0.25 });
      A.poly([[-30, 64], [0, 96], [30, 64], [22, 58], [0, 78], [-22, 58]], { fill: '#e8f2fb', w: 1, curv: 0.1 });
      A.stroke([[0, 96], [0, 210]], { w: 0.8 }); A.ell(4, 130, 2.6, 2.6, { fill: '#f4f4f4', w: 0.6 }); A.ell(4, 170, 2.6, 2.6, { fill: '#f4f4f4', w: 0.6 });
    }
    A.limb(0, 40, 0, 74, 16, 18, { fill: PAL.skinSh, w: 1 });
    // back hair
    A.poly(c.who === 'R' ? [[-50, 10], [-54, -30], [-36, -62], [0, -70], [36, -62], [54, -30], [50, 10]] : [[-48, 6], [-50, -32], [-30, -60], [0, -66], [30, -60], [50, -32], [48, 6]], { fill: P.hair, w: 1.2, curv: 0.4 });
    A.ell(-45, 6, 7, 11, { fill: PAL.skin, w: 1 }); A.ell(45, 6, 7, 11, { fill: PAL.skin, w: 1 });
    const fp = []; for (let i = 0; i <= 10; i++) { const a = Math.PI + i / 10 * Math.PI; fp.push([46 * cos(a), -5 + 50 * sin(a)]); }
    fp.push([44, 6], [36, 30], [14, 48], [0, 52], [-14, 48], [-36, 30], [-44, 6]);
    A.poly(fp, { fill: PAL.skin, w: 1.4, curv: 0.4 });
    // front hair
    if (c.who === 'R') A.poly([[-47, -6], [-48, -34], [-30, -58], [0, -66], [30, -58], [48, -34], [46, -8], [38, -26], [30, -14], [22, -30], [10, -16], [0, -32], [-10, -16], [-22, -30], [-30, -14], [-38, -26]], { fill: P.hair, w: 1.2, curv: 0.05 });
    else {
      A.poly([[-46, -6], [-47, -36], [-28, -58], [4, -64], [34, -56], [48, -34], [47, -12], [30, -30], [-10, -32], [-30, -24], [-42, -10]], { fill: P.hair, w: 1.2, curv: 0.4 });
      A.poly([[-46, -4], [-45, -20], [-40, -16], [-41, -2]], { fill: P.grey, w: 0, curv: 0.4 }); A.poly([[46, -4], [45, -20], [40, -16], [41, -2]], { fill: P.grey, w: 0, curv: 0.4 });
    }
    // eyes
    for (const sx of [-1, 1]) {
      const ex = sx * 19, ey = 6, ry = 12 * (1 - bl) * (1 - ang * 0.3);
      if (c.eyesClosed) A.stroke(mood === 'happy' ? [[ex - 10, ey + 3], [ex, ey - 4], [ex + 10, ey + 3]] : [[ex - 10, ey], [ex, ey + 4], [ex + 10, ey]], { w: 2.4 });
      else if (ry < 1.5) A.stroke([[ex - 11, ey], [ex + 11, ey]], { w: 2.4 });
      else {
        A.ell(ex, ey, 10.5, ry, { fill: PAL.white, w: 1.2 });
        const lx = (c.look || 0) * 3;
        A.ell(ex + lx, ey + ry * 0.12, 6.4, Math.min(ry * 0.85, 8.6), { fill: P.iris, w: 0.6 });
        A.ell(ex + lx, ey + ry * 0.15, 3.2, Math.min(ry * 0.45, 4.2), { fill: '#1a1214', w: 0 });
        A.ell(ex + lx + 2.4, ey - ry * 0.25, 2.2, 2.4, { fill: '#ffffff', w: 0 });
        A.stroke([[ex - 12, ey - ry * 0.7], [ex, ey - ry * 1.05], [ex + 12, ey - ry * 0.7]], { w: 3.2 }); // lid
        if (c.tear) A.poly([[ex + sx * 4, ey + ry], [ex + sx * 6, ey + ry + 7], [ex + sx * 4, ey + ry + 10], [ex + sx * 2, ey + ry + 7]], { fill: PAL.sweat, w: 0.6, curv: 0.6 });
      }
      // brows: angry = inner low, sad = inner high
      const inner = mood === 'sad' ? -26 : -18 + ang * 10, outer = mood === 'sad' ? -16 : -22 - ang * 4;
      A.stroke([[sx * 8, ey + inner], [sx * 30, ey + outer]], { w: 4.2, curv: 0.2 });
      if (c.who === 'D') A.poly([[ex - 14, ey - 12], [ex + 14, ey - 12], [ex + 14, ey + 12], [ex - 14, ey + 12]], { ink: '#2a2428', w: 1.2, curv: 0.45 });
    }
    if (c.who === 'D') A.stroke([[-5, 2], [5, 2]], { ink: '#2a2428', w: 1.2 });
    A.stroke([[1, 16], [3, 23], [-1, 24]], { w: 1.2 }); // nose
    // mouth
    if (m > 0.08) {
      const h = 3 + m * 20, w = 9 + m * 9;
      A.poly([[-w, 33], [w, 33], [w * 0.7, 33 + h], [-w * 0.7, 33 + h]], { fill: PAL.mouth, w: 1.2, curv: 0.45 });
      if (m > 0.3) { A.poly([[-w * 0.8, 33.5], [w * 0.8, 33.5], [w * 0.7, 37], [-w * 0.7, 37]], { fill: '#ffffff', w: 0, curv: 0.2 }); A.ell(0, 33 + h * 0.8, w * 0.45, h * 0.22, { fill: PAL.tongue, w: 0 }); }
    } else if (mood === 'happy') A.stroke([[-12, 32], [0, 38], [12, 32]], { w: 2.2 });
    else if (mood === 'sad') A.stroke([[-9, 37], [-3, 34], [3, 36], [9, 34]], { w: 2.0 });
    else A.stroke(ang > 0.3 ? [[-10, 37], [0, 34], [10, 37]] : [[-9, 35], [9, 35]], { w: 2.0 });
    if (c.blush) { A.ell(-28, 24, 9, 4, { fill: PAL.blush, alpha: 120 * c.blush, w: 0 }); A.ell(28, 24, 9, 4, { fill: PAL.blush, alpha: 120 * c.blush, w: 0 }); }
    if (c.sweat) A.poly([[40, -30], [45, -18], [40, -12], [35, -18]], { fill: PAL.sweat, w: 0.8, curv: 0.6 });
    A.pop(); A.setInk(ink0, 1.5);
  }
  // ---------- FX ----------
  function angerMark(x, y, s, t) { // pulsing anime vein mark
    const k = s * (1 + 0.15 * Math.sin(t * 18)); A.push(); A.translate(x, y); A.scale(k / 10);
    for (let i = 0; i < 4; i++) { A.push(); A.rotate(i * Math.PI / 2); A.stroke([[2, -8], [2.5, -3], [7.5, -2.5]], { ink: '#e23b3b', w: 2.6, curv: 0.6 }); A.pop(); }
    A.pop();
  }
  function shoutLines(x, y, r, n, t, color = '#fff6e0') { // radial speech burst
    for (let i = 0; i < n; i++) { const a = i / n * Math.PI * 2 + t * 0.6, r0 = r * (0.9 + 0.2 * Math.sin(t * 20 + i)); A.stroke([[x + cos(a) * r0, y + sin(a) * r0], [x + cos(a) * r0 * 1.35, y + sin(a) * r0 * 1.35]], { ink: color, w: 3.2 }); }
  }
  function sparkle(x, y, s, t) { const k = s * (0.6 + 0.4 * Math.abs(Math.sin(t * 5))); A.poly([[x, y - k], [x + k * 0.25, y - k * 0.25], [x + k, y], [x + k * 0.25, y + k * 0.25], [x, y + k], [x - k * 0.25, y + k * 0.25], [x - k, y], [x - k * 0.25, y - k * 0.25]], { fill: '#fff4c2', w: 0, curv: 0 }); }
  function heart(x, y, s, col = '#ff6f9f') { A.push(); A.translate(x, y); A.scale(s / 20);
    A.poly([[0, 6], [-10, -2], [-11, -9], [-6, -13], [0, -9], [6, -13], [11, -9], [10, -2]], { fill: col, w: 1.2, curv: 0.45 }); A.ell(-5, -8, 2, 1.6, { fill: '#ffffff', w: 0 }, -0.6); A.pop(); }
  function hearts(t, n, sc = 1) { // slow floating hearts (screen space)
    A.push(); A.reset();
    for (let i = 0; i < n; i++) { const sp = 0.07 + 0.04 * ((i * 37) % 5) / 5, k = (t * sp + i / n) % 1, x = 90 + ((i * 263) % 900) + 30 * Math.sin(t * 0.8 + i);
      heart(x, 1500 - k * 1300, (22 + (i * 13) % 26) * sc * (0.6 + 0.4 * Math.sin(k * Math.PI)), i % 3 ? '#ff7aa8' : '#ff9fc2'); }
    A.pop(); }
  // ---------- vehicles (generic: no plates, no logos) ----------
  function carSide(x, y, s, f, col, t, hazard) { // y = ground, s = length px
    A.push(); A.translate(x, y); A.scale(f * s / 100, s / 100);
    A.poly([[1, -11], [1.5, -23], [8, -27.5], [27, -29.5], [37, -43], [65, -43.5], [77, -31], [95, -28], [99, -20], [98.5, -11]], { fill: col, w: 1.1, curv: 0.25 });
    A.poly([[30, -30], [39, -41], [51, -41], [51, -30]], { fill: '#41506e', w: 0.8, curv: 0.1 });
    A.poly([[53.5, -30], [53.5, -41], [64, -41], [73, -30]], { fill: '#41506e', w: 0.8, curv: 0.1 });
    A.stroke([[52, -29], [52, -12]], { w: 0.7 }); A.stroke([[31, -21], [36, -21]], { w: 0.8 }); A.stroke([[58, -21], [63, -21]], { w: 0.8 });
    A.poly([[95.5, -25], [99, -24], [98.5, -20], [95, -21]], { fill: '#fff3c8', w: 0.6, curv: 0.2 }); // headlight
    const on = hazard && Math.floor(t * 2.4) % 2 === 0;
    A.poly([[1.4, -24], [4.5, -24.5], [4.5, -19.5], [1.4, -19.5]], { fill: on ? '#ffb02e' : '#b8443a', w: 0.6, curv: 0.2 });
    for (const wx of [21, 79]) { A.ell(wx, -8, 8.6, 8.6, { fill: '#25212a', w: 1 }); A.ell(wx, -8, 4.2, 4.2, { fill: '#a9a4ae', w: 0.6 }); }
    A.pop();
  }
  function carRear(x, y, s, col, t, hazard) { // y = ground, s = width px
    A.push(); A.translate(x, y); A.scale(s / 100);
    A.ell(-36, -6, 9, 7, { fill: '#25212a', w: 0.8 }); A.ell(36, -6, 9, 7, { fill: '#25212a', w: 0.8 });
    A.poly([[-48, -8], [-49, -34], [-36, -42], [-26, -64], [26, -64], [36, -42], [49, -34], [48, -8]], { fill: col, w: 1.1, curv: 0.2 });
    A.poly([[-23, -60], [23, -60], [31, -44], [-31, -44]], { fill: '#41506e', w: 0.8, curv: 0.15 });
    const on = hazard && Math.floor(t * 2.4) % 2 === 0;
    for (const sx of [-1, 1]) { A.poly([[sx * 46, -34], [sx * 30, -34], [sx * 30, -27], [sx * 46, -26]], { fill: '#c43a3a', w: 0.7, curv: 0.1 }); if (on) A.ell(sx * 40, -30.5, 9, 5, { fill: '#ffb02e', alpha: 230, w: 0 }); }
    A.rect(-30, -20, 60, 8, { fill: shadeHex(col, 0.75), w: 0.6 }); // bumper strip (no plate)
    A.pop();
  }
  function motoSide(x, y, s, f, t) { // generic scooter-style motorbike, y = ground, s = length px
    A.push(); A.translate(x, y); A.scale(f * s / 100, s / 100);
    for (const wx of [14, 80]) { A.ell(wx, -12, 12, 12, { fill: '#25212a', w: 1 }); A.ell(wx, -12, 5, 5, { fill: '#9a96a2', w: 0.6 }); }
    A.poly([[8, -26], [30, -28], [44, -24], [62, -26], [76, -38], [82, -40], [84, -30], [72, -20], [40, -16], [20, -18]], { fill: '#2d2a3a', w: 1, curv: 0.3 });
    A.poly([[22, -32], [50, -33], [52, -28], [22, -27]], { fill: '#1d1a22', w: 0.8, curv: 0.4 }); // seat
    A.poly([[76, -40], [80, -58], [86, -58], [84, -40]], { fill: '#2d2a3a', w: 0.8, curv: 0.2 });
    A.stroke([[78, -58], [90, -60]], { w: 1.6 });
    A.ell(87, -46, 3, 3.6, { fill: '#fff3c8', w: 0.6 });
    A.ell(8, -28, 2.6, 2, { fill: '#c43a3a', w: 0.5 });
    // helmet hanging on mirror/handle
    A.poly([[86, -56], [94, -56], [97, -48], [92, -44], [86, -46]], { fill: '#f6c21c', w: 0.8, curv: 0.6 });
    A.pop();
  }
  const shadeHex = (hex, f) => { const n = parseInt(hex.slice(1), 16); const r = (n >> 16) * f | 0, g = ((n >> 8) & 255) * f | 0, b = (n & 255) * f | 0; return '#' + ((1 << 24) + (r << 16) + (g << 8) + b).toString(16).slice(1); };
  return { person, face, heart, hearts, angerMark, shoutLines, sparkle, carSide, carRear, motoSide, shadeHex };
})();
