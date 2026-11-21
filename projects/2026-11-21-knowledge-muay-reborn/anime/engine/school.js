// Thai classroom / bedroom scenery (watercolor + ink), drawn in world coords, cached per shot framing.
// Side classroom: feet on GROUND (y 1330). Generic: no school name, no logos, no flags.
/* global A, noStroke, beginShape, endShape, vertex, fill, CLOSE */
const SCH = (() => {
  const NP = { noStroke: () => noStroke(), fill: c => fill(c), beginShape: () => beginShape(), vertex: (x, y) => vertex(x, y), endShape: () => endShape(CLOSE) };
  const M = {
    morning: { wall: [[0, '#f3e3c3'], [0.7, '#f6e9cd'], [1, '#e9d5b0']], floor: [[0, '#cdb48c'], [1, '#a88c66']], board: '#3d6650', sun: '#fff2c2', tint: null },
    tense:   { wall: [[0, '#d9b9a4'], [0.7, '#e2c4ab'], [1, '#c9a58c']], floor: [[0, '#b39272'], [1, '#86684e']], board: '#35574a', sun: '#ffd9a8', tint: '#7a3a44' },
  };
  function desk(x, y, s, col = '#c98d52') { // side-view school desk + chair on the ground at y (wood top, metal legs)
    A.push(); A.translate(x, y); A.scale(s / 100);
    A.rect(-2, -62, 4, 62, { fill: '#6d6a72', w: 0.8 }); A.rect(56, -62, 4, 62, { fill: '#6d6a72', w: 0.8 });
    A.rect(-8, -66, 74, 7, { fill: col, w: 1.1 }); A.rect(0, -59, 58, 12, { fill: A.lerp ? '#b27a45' : col, w: 0.8 });
    // chair behind
    A.rect(-34, -38, 3.5, 38, { fill: '#6d6a72', w: 0.7 }); A.rect(-12, -38, 3.5, 38, { fill: '#6d6a72', w: 0.7 });
    A.rect(-38, -41, 32, 5, { fill: col, w: 1 }); A.rect(-38, -82, 3.5, 44, { fill: '#6d6a72', w: 0.7 }); A.rect(-41, -84, 9, 22, { fill: col, w: 0.9 });
    A.pop();
  }
  function classroom(mood = 'morning') {
    const m = M[mood];
    A.grad(NP, -400, -300, 1880, 1460, m.wall);
    A.seed(3);
    for (let i = 0; i < 8; i++) { const x = A.R(-300, 1400), y = A.R(-200, 1000); A.wc(A.ellPts(x, y, A.R(160, 320), A.R(80, 180)), i % 2 ? '#ead2ad' : '#fff4dc', 60, 0.3, 0.6); }
    // ceiling strip + fan
    A.rect(-400, -300, 1880, 160, { fill: '#e6d3b2', w: 1 });
    A.rect(390, -140, 8, 120, { fill: '#77727a', w: 0.8 }); A.ell(394, -20, 26, 12, { fill: '#8a8590', w: 1 });
    A.poly([[394, -20], [250, -6], [246, 6], [394, -10]], { fill: '#a19ca6', w: 0.9, curv: 0.2 }); A.poly([[394, -20], [540, -6], [544, 6], [394, -10]], { fill: '#a19ca6', w: 0.9, curv: 0.2 });
    // chalkboard (green) with wooden frame + chalk scribbles (abstract)
    A.rect(-260, 300, 900, 520, { fill: '#8a5a36', w: 1.4 }); A.rect(-236, 322, 852, 476, { fill: m.board, w: 1 });
    A.wc([[-200, 360], [560, 340], [580, 760], [-210, 770]], '#5a8a70', 70, 0.2, 0.7);
    for (let i = 0; i < 5; i++) A.stroke([[-180 + i * 20, 420 + i * 70], [-20 + i * 90 + A.R(0, 120), 418 + i * 70 + A.R(-8, 8)]], { ink: '#e9efe6', w: 1.2, curv: 0.4 });
    A.stroke([[300, 430], [360, 520], [440, 440], [520, 540]], { ink: '#f3e6b0', w: 1.2, curv: 0.3 });
    A.rect(-250, 812, 880, 18, { fill: '#7a4e2e', w: 1 }); A.rect(-120, 800, 40, 12, { fill: '#f4f1e8', w: 0.6 }); A.rect(-40, 802, 26, 10, { fill: '#f3d27a', w: 0.6 });
    // clock
    A.ell(760, 220, 54, 54, { fill: '#fffaf0', w: 1.4 }); A.stroke([[760, 220], [760, 186]], { w: 1.4 }); A.stroke([[760, 220], [784, 232]], { w: 1.4 });
    // windows (right) with sunlight beams
    for (const wx of [900, 1180]) { A.rect(wx, 260, 240, 560, { fill: '#8a5a36', w: 1.3 }); A.rect(wx + 16, 276, 208, 528, { fill: m.sun, w: 0.8 });
      A.wc([[wx + 20, 560], [wx + 200, 520], [wx + 220, 800], [wx + 20, 800]], '#9ccf8e', 110, 0.2, 0.6); // trees outside
      A.stroke([[wx + 120, 276], [wx + 120, 804]], { w: 1.1 }); A.stroke([[wx + 16, 540], [wx + 224, 540]], { w: 1.1 }); }
    A.wc([[880, 300], [1400, 300], [700, 1500], [180, 1500]], '#fff6d8', 55, 0.2, 0.3);
    // skirting + floor
    A.rect(-400, 1120, 1880, 40, { fill: '#a07850', w: 1 });
    A.grad(NP, -400, 1160, 1880, 1100, m.floor);
    for (let y = 1200; y < 2300; y += 70 + (y - 1200) * 0.12) A.stroke([[-400, y], [1480, y]], { ink: '#8f7556', w: 0.6, curv: 0 });
    // back row of desks (small, far)
    for (let x = -260; x < 1500; x += 300) desk(x, 1170, 120, '#c2915e');
    if (m.tint) A.wc([[-400, -300], [1480, -300], [1480, 2300], [-400, 2300]], m.tint, 40, 0.1, 0.2);
  }
  function bedroom() { // night: old champion's room (generic gloves + belt, no logos)
    A.grad(NP, -400, -300, 1880, 2600, [[0, '#1e2340'], [0.6, '#2c3358'], [1, '#232845']]);
    A.rect(640, 200, 300, 380, { fill: '#5a4a3a', w: 1.3 }); A.rect(656, 216, 268, 348, { fill: '#33406e', w: 0.8 }); // window
    A.ell(860, 300, 36, 36, { fill: '#f6efcf', w: 0 }); A.wc(A.ellPts(860, 300, 90, 90), '#8a9ad0', 70, 0.3, 0.3);
    // belt on the wall (gold plate, red strap, abstract emblem)
    A.rect(60, 330, 460, 70, { fill: '#9a2a2e', w: 1.3 }); A.ell(290, 365, 110, 82, { fill: '#d9a93a', w: 1.4 }); A.ell(290, 365, 70, 50, { fill: '#f2d27a', w: 1 }); A.ell(290, 365, 22, 22, { fill: '#9a2a2e', w: 0.8 });
    // gloves hanging on a nail
    A.stroke([[260, 520], [240, 600]], { w: 1 }); A.stroke([[260, 520], [300, 596]], { w: 1 }); A.ell(260, 518, 6, 6, { fill: '#888', w: 0.6 });
    A.ell(226, 650, 46, 60, { fill: '#b8323a', w: 1.3 }); A.ell(318, 646, 46, 60, { fill: '#b8323a', w: 1.3 }); A.ell(208, 628, 12, 20, { fill: '#d75a5e', w: 0, alpha: 200 });
    // bed
    A.rect(-200, 1000, 1400, 120, { fill: '#6a4a36', w: 1.3 }); A.rect(-200, 1110, 1400, 900, { fill: '#3e3a5e', w: 1.1 });
    A.wc([[-200, 990], [1200, 980], [1200, 1300], [-200, 1320]], '#e9e3d6', 160, 0.1, 0.5); // sheet
    A.poly([[60, 900], [520, 880], [560, 1040], [40, 1060]], { fill: '#f1ece2', w: 1.2, curv: 0.4 }); // pillow
    A.wc([[-400, -300], [1480, -300], [1480, 2300], [-400, 2300]], '#141833', 70, 0.1, 0.2);
  }
  function flat(c1, c2) { A.grad(NP, -400, -300, 1880, 2600, [[0, c1], [1, c2]]); A.seed(9); for (let i = 0; i < 6; i++) A.wc(A.ellPts(A.R(0, 1080), A.R(0, 1920), A.R(200, 420), A.R(200, 420)), '#ffffff', 40, 0.3, 0.5); }
  function burst(c1, c2, cx = 540, cy = 900) { // dramatic radial background
    A.grad(NP, -400, -300, 1880, 2600, [[0, c1], [1, c2]]);
    for (let i = 0; i < 36; i++) { const a = i / 36 * Math.PI * 2, b = a + Math.PI / 36 * 0.8; A.poly([[cx, cy], [cx + Math.cos(a) * 2400, cy + Math.sin(a) * 2400], [cx + Math.cos(b) * 2400, cy + Math.sin(b) * 2400]], { fill: i % 2 ? '#000000' : '#ffffff', alpha: i % 2 ? 40 : 30, w: 0, curv: 0 }); }
  }
  function sketchbook(x, y, s, rot, torn, stomp) { // open sketchbook: left page drawing of a boxer in guard; right page caption (DOM)
    A.push(); A.translate(x, y); A.rotate(rot || 0); A.scale(s / 100);
    A.poly([[-104, -70], [0, -64], [104, -70], [108, 70], [0, 76], [-108, 70]], { fill: '#3c5a8a', w: 1.2, curv: 0.1 });
    A.poly([[-98, -64], [0, -58], [0, 70], [-100, 64]], { fill: '#fbf7ec', w: 1, curv: 0.1 });
    A.poly([[0, -58], [98, -64], [100, 64], [0, 70]], { fill: '#f7f2e4', w: 1, curv: 0.1 });
    A.stroke([[0, -58], [0, 70]], { w: 1 });
    // pencil boxer (simple, child-like)
    const ink = '#4a4a5a';
    A.ell(-50, -30, 9, 10, { ink, w: 0.7 }); A.stroke([[-50, -20], [-48, 10]], { ink, w: 0.7 }); A.stroke([[-48, 10], [-60, 38]], { ink, w: 0.7 }); A.stroke([[-48, 10], [-34, 36]], { ink, w: 0.7 });
    A.stroke([[-50, -14], [-36, -20], [-34, -30]], { ink, w: 0.7 }); A.stroke([[-50, -12], [-62, -18], [-58, -30]], { ink, w: 0.7 });
    A.ell(-34, -32, 4, 4, { fill: '#e05a5a', w: 0.5 }); A.ell(-58, -32, 4, 4, { fill: '#e05a5a', w: 0.5 });
    A.rect(-62, -2, 26, 5, { fill: '#e8c040', w: 0.4 }); // belt
    for (let i = 0; i < 4; i++) A.stroke([[14, -40 + i * 18], [86, -42 + i * 18]], { ink: '#c9c4b4', w: 0.4, curv: 0 });
    if (stomp) { A.poly([[-80, 20], [-10, -6], [30, 10], [-20, 50], [-70, 54]], { fill: '#8a7a6a', alpha: 120, w: 0, curv: 0.3 }); A.stroke([[-90, -50], [-10, 30]], { ink: '#7a6a5a', w: 0.6 }); A.stroke([[-20, -60], [-70, 40]], { ink: '#7a6a5a', w: 0.5 }); }
    A.pop();
  }
  return { classroom, bedroom, flat, burst, desk, sketchbook };
})();
