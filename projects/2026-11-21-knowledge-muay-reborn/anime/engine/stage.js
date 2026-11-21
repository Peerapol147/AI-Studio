// Long-format world (1920x1080 at zoom 1). Feet of the front plane on y = G. Students HT px tall.
// Scale reference: front plane 1 m ≈ 260 px; back wall (base y=WB) 1 m ≈ 145 px (≈0.55 depth factor).
/* global A, SCH, noStroke, fill, beginShape, vertex, endShape, CLOSE */
const STAGE = (() => {
  const G = 905, HT = 430, DESK = 290, WB = 690, M = 145; // wall base y, px per metre at the wall
  const NP = { noStroke: () => noStroke(), fill: c => fill(c), beginShape: () => beginShape(), vertex: (x, y) => vertex(x, y), endShape: () => endShape(CLOSE) };
  const X0 = -260, X1 = 2180; // drawn span (camera headroom)
  function classroom(mood = 'morning') {
    const tense = mood === 'tense';
    A.grad(NP, X0, -200, X1 - X0, WB + 200, tense ? [[0, '#d8b7a0'], [1, '#e6c7ad']] : [[0, '#efdcb8'], [0.8, '#f6e8cb'], [1, '#ecd8b4']]);
    A.seed(3); for (let i = 0; i < 7; i++) { const x = A.R(X0, X1), y = A.R(0, 600); A.wc(A.ellPts(x, y, A.R(160, 300), A.R(60, 140)), i % 2 ? '#e8cfa8' : '#fff4dc', 55, 0.3, 0.6); }
    // ceiling band + 2 fans
    const ceil = WB - 3.0 * M; A.rect(X0, -200, X1 - X0, ceil + 200, { fill: tense ? '#c9a891' : '#e4d0ac', w: 1 });
    for (const fx of [420, 1500]) { A.rect(fx - 4, ceil, 8, 70, { fill: '#77727a', w: 0.8 }); A.ell(fx, ceil + 74, 24, 10, { fill: '#8a8590', w: 1 });
      A.poly([[fx, ceil + 74], [fx - 150, ceil + 86], [fx - 152, ceil + 94], [fx, ceil + 82]], { fill: '#a19ca6', w: 0.9, curv: 0.2 }); A.poly([[fx, ceil + 74], [fx + 150, ceil + 86], [fx + 152, ceil + 94], [fx, ceil + 82]], { fill: '#a19ca6', w: 0.9, curv: 0.2 }); }
    // chalkboard: bottom 0.9 m, 1.2 m tall, 3.6 m wide
    const bb = WB - 0.9 * M, bt = bb - 1.2 * M, bx = 120, bw = 3.6 * M * 1.9;
    A.rect(bx - 14, bt - 14, bw + 28, bb - bt + 28, { fill: '#8a5a36', w: 1.4 }); A.rect(bx, bt, bw, bb - bt, { fill: tense ? '#35574a' : '#3d6650', w: 1 });
    A.wc([[bx + 30, bt + 20], [bx + bw - 40, bt + 14], [bx + bw - 30, bb - 20], [bx + 20, bb - 16]], '#5a8a70', 70, 0.2, 0.7);
    for (let i = 0; i < 4; i++) A.stroke([[bx + 60 + i * 14, bt + 34 + i * 30], [bx + 260 + i * 70 + A.R(0, 140), bt + 32 + i * 30 + A.R(-6, 6)]], { ink: '#e9efe6', w: 1.1, curv: 0.4 });
    A.stroke([[bx + 600, bt + 40], [bx + 640, bt + 110], [bx + 690, bt + 50], [bx + 740, bt + 120]], { ink: '#f3e6b0', w: 1.1, curv: 0.3 });
    A.rect(bx - 10, bb + 6, bw + 20, 12, { fill: '#7a4e2e', w: 1 }); A.rect(bx + 80, bb - 2, 30, 9, { fill: '#f4f1e8', w: 0.6 }); A.rect(bx + 130, bb - 1, 20, 8, { fill: '#f3d27a', w: 0.6 });
    // clock above board, bulletin board (colored paper, no text)
    A.ell(bx + bw / 2, bt - 70, 34, 34, { fill: '#fffaf0', w: 1.3 }); A.stroke([[bx + bw / 2, bt - 70], [bx + bw / 2, bt - 94]], { w: 1.3 }); A.stroke([[bx + bw / 2, bt - 70], [bx + bw / 2 + 16, bt - 62]], { w: 1.3 });
    A.rect(-180, bt + 10, 220, 150, { fill: '#c98f5a', w: 1.1 }); [['#f6d55c', -160, bt + 30], ['#8ecae6', -90, bt + 40], ['#f4a3a8', -150, bt + 100], ['#b8e0a8', -70, bt + 96]].forEach(([c, x, y]) => A.rect(x, y, 56, 44, { fill: c, w: 0.7 }));
    // windows (right): sill 0.9 m, 1.4 m tall, trees outside, light shafts on the floor
    for (const wx of [1290, 1640]) { const wt = bb - 1.5 * M; A.rect(wx, wt, 270, bb - wt + 10, { fill: '#8a5a36', w: 1.3 }); A.rect(wx + 12, wt + 12, 246, bb - wt - 14, { fill: tense ? '#ffd9a8' : '#fff2c2', w: 0.8 });
      A.wc([[wx + 16, wt + 120], [wx + 250, wt + 80], [wx + 252, bb - 6], [wx + 16, bb - 6]], '#9ccf8e', 115, 0.2, 0.6); A.stroke([[wx + 135, wt + 12], [wx + 135, bb - 4]], { w: 1.1 }); A.stroke([[wx + 12, wt + 110], [wx + 258, wt + 110]], { w: 1 }); }
    // skirting + floor (tiles in perspective)
    A.rect(X0, WB - 26, X1 - X0, 26, { fill: '#a07850', w: 1 });
    A.grad(NP, X0, WB, X1 - X0, 1200 - WB, tense ? [[0, '#b39272'], [1, '#86684e']] : [[0, '#d2ba92'], [1, '#b0946c']]);
    for (let y = WB + 30, k = 0; y < 1300; k++, y += 26 + k * 12) A.stroke([[X0, y], [X1, y]], { ink: '#9c815f', w: 0.5, curv: 0 });
    for (let x = -600; x < 2600; x += 220) A.stroke([[960 + (x - 960) * 0.55, WB], [x, 1300]], { ink: '#9c815f', w: 0.5, curv: 0 });
    if (!tense) for (const wx of [1290, 1640]) A.wc([[wx - 80, WB + 40], [wx + 200, WB + 40], [wx + 60, 1200], [wx - 360, 1200]], '#fff6d8', 70, 0.2, 0.3);
    // back row of desks against the wall (depth factor 0.6)
    for (let x = 40; x < 2100; x += 330) SCH.desk(x, WB + 60, DESK * 0.6, '#c2915e');
  }

  // ---- Muay Thai gym (small, old, evening): concrete wall, ring corner (left), heavy bag, bench, open front (right) with street light
  function gym(mood = 'eve') {
    const night = mood === 'night';
    A.grad(NP, X0, -200, X1 - X0, WB + 200, night ? [[0, '#3a3b52'], [1, '#4a4a60']] : [[0, '#b9a58f'], [1, '#cdb79c']]);
    A.seed(5); for (let i = 0; i < 9; i++) A.wc(A.ellPts(A.R(X0, X1), A.R(0, 650), A.R(120, 260), A.R(50, 120)), i % 3 ? '#a8927c' : '#d8c4a8', 70, 0.3, 0.7); // stained concrete
    for (let y = 120; y < WB; y += 95) A.stroke([[X0, y], [1400, y + 4]], { ink: '#9a846e', w: 0.5, curv: 0 });
    // open front (right): roller-shutter opening with warm street
    A.rect(1420, 40, 760, WB - 40, { fill: night ? '#20233a' : '#f2b47c', w: 1.3 });
    A.wc([[1430, 50], [2170, 50], [2170, 380], [1430, 420]], night ? '#3a3f66' : '#f6d29a', 110, 0.2, 0.5);
    for (let x = 1460; x < 2170; x += 170) A.rect(x, 300 + (x % 3) * 30, 120, WB - 300, { fill: night ? '#2c2f48' : '#c98a62', w: 0.9 }); // shop houses
    A.rect(1400, 20, 800, 40, { fill: '#6f6a74', w: 1.2 }); // shutter box
    // sign board above the door frame (text in DOM)
    A.rect(1480, 70, 520, 120, { fill: '#b3232b', w: 1.4 }); A.rect(1492, 82, 496, 96, { fill: '#c8343a', w: 0.6 });
    // ring corner (post + 3 ropes) on the left, canvas floor edge
    A.rect(-100, WB - 40, 760, 40, { fill: '#3b5ba0', w: 1.2 });
    A.rect(560, 140, 30, WB - 140, { fill: '#c8343a', w: 1.2 }); A.ell(575, 140, 22, 12, { fill: '#d84a50', w: 1 });
    for (const y of [250, 370, 490]) { A.stroke([[-260, y + 8], [575, y]], { ink: '#f1e8d8', w: 3.2 }); A.stroke([[-260, y + 10], [575, y + 3]], { ink: '#2a2228', w: 0.8 }); }
    // heavy bag on a chain
    A.stroke([[1080, -100], [1080, 150]], { w: 1.4 }); A.poly([[1020, 150], [1140, 150], [1150, 520], [1080, 540], [1010, 520]], { fill: '#8e2f35', w: 1.4, curv: 0.35 });
    A.rect(1010, 300, 140, 22, { fill: '#2a2228', w: 0.8 }); A.wc([[1030, 180], [1060, 170], [1060, 500], [1030, 500]], '#b8545a', 120, 0.1, 0.4);
    // trophy cabinet with the belt (abstract gold plate, no emblem)
    A.rect(760, 230, 230, 300, { fill: '#6a4a36', w: 1.3 }); A.rect(775, 245, 200, 270, { fill: night ? '#4a5070' : '#e9dcc0', w: 0.8, alpha: 220 });
    A.rect(790, 360, 170, 40, { fill: '#9a2a2e', w: 1 }); A.ell(875, 380, 52, 40, { fill: '#d9a93a', w: 1.2 }); A.ell(875, 380, 30, 22, { fill: '#f2d27a', w: 0.8 });
    A.poly([[800, 470], [820, 430], [840, 470]], { fill: '#d9a93a', w: 0.8, curv: 0 }); A.poly([[910, 470], [930, 440], [950, 470]], { fill: '#d9a93a', w: 0.8, curv: 0 });
    // floor
    A.grad(NP, X0, WB, X1 - X0, 1300 - WB, night ? [[0, '#3a3446'], [1, '#241f2c']] : [[0, '#8f7a66'], [1, '#6e5c4c']]);
    A.seed(8); for (let i = 0; i < 6; i++) { const x = A.R(X0, X1), y = A.R(WB + 40, 1200); A.wc([[x, y], [x + 300, y - 10], [x + 260, y + 50], [x - 20, y + 40]], '#5c4c40', 60, 0.2, 0.7); }
    // bench (front-ish) + rope hanging + gloves on the bench
    A.rect(200, 790, 520, 26, { fill: '#7a5638', w: 1.2 }); A.rect(230, 816, 20, 90, { fill: '#5a3e28', w: 1 }); A.rect(670, 816, 20, 90, { fill: '#5a3e28', w: 1 });
    A.ell(330, 768, 44, 30, { fill: '#b8323a', w: 1.2 }); A.ell(410, 772, 44, 30, { fill: '#b8323a', w: 1.2 });
    if (night) A.wc([[X0, -200], [X1, -200], [X1, 1300], [X0, 1300]], '#141833', 60, 0.1, 0.2);
  }
  // ---- bedroom at night (long): bed in the middle, belt + gloves on the wall, moon window
  function bedroom() {
    A.grad(NP, X0, -200, X1 - X0, 1500, [[0, '#1e2340'], [0.6, '#2c3358'], [1, '#232845']]);
    A.rect(1300, 120, 330, 380, { fill: '#5a4a3a', w: 1.3 }); A.rect(1316, 136, 298, 348, { fill: '#33406e', w: 0.8 });
    A.wc(A.ellPts(1520, 230, 90, 90), '#8a9ad0', 70, 0.3, 0.3); A.ell(1520, 230, 34, 34, { fill: '#f6efcf', w: 0 });
    A.rect(300, 230, 420, 64, { fill: '#9a2a2e', w: 1.3 }); A.ell(510, 262, 100, 74, { fill: '#d9a93a', w: 1.4 }); A.ell(510, 262, 62, 44, { fill: '#f2d27a', w: 1 });
    A.stroke([[930, 200], [912, 270]], { w: 1 }); A.stroke([[930, 200], [966, 268]], { w: 1 }); A.ell(930, 198, 6, 6, { fill: '#888', w: 0.6 });
    A.ell(900, 320, 42, 56, { fill: '#b8323a', w: 1.3 }); A.ell(980, 316, 42, 56, { fill: '#b8323a', w: 1.3 });
    A.grad(NP, X0, WB, X1 - X0, 600, [[0, '#2a2438'], [1, '#1c1828']]);
    A.rect(180, 640, 1500, 90, { fill: '#6a4a36', w: 1.3 }); A.rect(180, 720, 1500, 220, { fill: '#3e3a5e', w: 1.1 }); // bed frame
    A.poly([[220, 560], [600, 548], [620, 650], [210, 660]], { fill: '#f1ece2', w: 1.2, curv: 0.4 }); // pillow
    A.wc([[X0, -200], [X1, -200], [X1, 1300], [X0, 1300]], '#141833', 60, 0.1, 0.2);
  }
  // ---- school bathroom: tiles, mirror (front view of whoever looks into it is drawn as a face), sink
  function bathroom() {
    A.grad(NP, X0, -200, X1 - X0, 1500, [[0, '#cfe3e6'], [1, '#b6d0d4']]);
    for (let x = X0; x < X1; x += 90) A.stroke([[x, -200], [x, 1300]], { ink: '#a3c0c4', w: 0.5, curv: 0 });
    for (let y = -200; y < 1300; y += 90) A.stroke([[X0, y], [X1, y]], { ink: '#a3c0c4', w: 0.5, curv: 0 });
    A.rect(560, 60, 800, 700, { fill: '#8d9aa0', w: 1.4 }); A.rect(580, 80, 760, 660, { fill: '#dfeef0', w: 0.8 }); // mirror
    A.wc([[600, 100], [900, 90], [700, 720], [600, 720]], '#ffffff', 90, 0.2, 0.3); A.stroke([[1200, 120], [1300, 260]], { ink: '#ffffff', w: 2 });
    A.rect(500, 800, 920, 70, { fill: '#f4f4f0', w: 1.3 }); A.rect(880, 760, 30, 50, { fill: '#9aa4aa', w: 1 }); A.rect(860, 760, 90, 16, { fill: '#9aa4aa', w: 1 }); // sink + tap
    A.wc([[X0, 870], [X1, 870], [X1, 1300], [X0, 1300]], '#8fb0b4', 120, 0.1, 0.4);
  }
  // ---- behind the school: concrete fence wall, a tree, dirt ground, late afternoon
  function backyard() {
    A.grad(NP, X0, -200, X1 - X0, WB + 200, [[0, '#f2b48a'], [0.6, '#f7cf9c'], [1, '#f8dcae']]);
    A.wc(A.ellPts(1500, 200, 120, 120), '#fff0c0', 90, 0.3, 0.3);
    A.rect(X0, 380, X1 - X0, WB - 380, { fill: '#b7aea2', w: 1.3 }); for (let x = X0; x < X1; x += 260) A.stroke([[x, 380], [x, WB]], { ink: '#8f877c', w: 0.7 });
    A.seed(12); for (let i = 0; i < 6; i++) A.wc(A.ellPts(A.R(X0, X1), A.R(480, 680), A.R(80, 200), A.R(30, 70)), '#6f8a5a', 90, 0.3, 0.6); // moss
    A.rect(300, 120, 70, WB - 120, { fill: '#6a4a36', w: 1.3 }); for (let i = 0; i < 5; i++) A.wc(A.ellPts(335 + A.R(-220, 220), 120 + A.R(-120, 80), A.R(140, 230), A.R(90, 150)), i % 2 ? '#5f8f4e' : '#7aa860', 140, 0.2, 0.5);
    A.grad(NP, X0, WB, X1 - X0, 600, [[0, '#c9a77c'], [1, '#a8845c']]);
    A.seed(14); for (let i = 0; i < 8; i++) { const x = A.R(X0, X1), y = A.R(WB + 30, 1200); A.wc([[x, y], [x + 200, y], [x + 180, y + 30], [x, y + 30]], '#9a7650', 70, 0.2, 0.7); }
  }
  // ---- Kla's small room at night (training): desk lamp, wall mirror, drawings pinned on the wall
  function kidroom() {
    A.grad(NP, X0, -200, X1 - X0, WB + 200, [[0, '#2f3554'], [1, '#3c4266']]);
    A.wc(A.ellPts(520, 420, 420, 300), '#ffd98a', 70, 0.3, 0.3); // lamp glow
    for (let i = 0; i < 5; i++) { const x = 160 + i * 130, y = 200 + (i % 2) * 60; A.rect(x, y, 100, 130, { fill: '#f7f2e4', w: 1, alpha: 230 }); A.stroke([[x + 20, y + 40], [x + 70, y + 90]], { ink: '#6a6a7a', w: 0.6 }); A.ell(x + 50, y + 8, 6, 6, { fill: '#e05a5a', w: 0.5 }); }
    A.rect(1240, 100, 360, 560, { fill: '#7a6a5a', w: 1.3 }); A.rect(1256, 116, 328, 528, { fill: '#46507a', w: 0.8 }); A.stroke([[1300, 150], [1380, 260]], { ink: '#9aa6d0', w: 1.4 }); // mirror
    A.rect(300, 560, 520, 30, { fill: '#7a5638', w: 1.2 }); A.rect(320, 590, 20, 120, { fill: '#5a3e28', w: 1 }); A.rect(780, 590, 20, 120, { fill: '#5a3e28', w: 1 }); // desk
    A.rect(640, 470, 14, 90, { fill: '#33303a', w: 1 }); A.poly([[600, 440], [700, 440], [680, 480], [620, 480]], { fill: '#f2c24a', w: 1.1, curv: 0.2 });
    A.grad(NP, X0, WB, X1 - X0, 600, [[0, '#4a4054'], [1, '#2e2838']]);
  }
  // ---- corridor seen through the classroom's side window (for the cliffhanger)
  function corridor() {
    A.grad(NP, X0, -200, X1 - X0, 1500, [[0, '#d8c4a4'], [1, '#c4ad8a']]);
    A.rect(300, 80, 1320, 760, { fill: '#8a5a36', w: 1.6 }); A.rect(330, 110, 1260, 700, { fill: '#e9e0cf', w: 0.8 });
    A.wc([[340, 120], [1580, 120], [1580, 800], [340, 800]], '#f6efe0', 120, 0.2, 0.4);
    A.stroke([[960, 110], [960, 810]], { w: 1.4 }); A.stroke([[330, 460], [1590, 460]], { w: 1.2 });
    A.rect(X0, 840, X1 - X0, 500, { fill: '#c8ab84', w: 1.2 });
  }
  function flat(c1, c2) { A.grad(NP, X0, -300, X1 - X0, 1700, [[0, c1], [1, c2]]); A.seed(9); for (let i = 0; i < 6; i++) A.wc(A.ellPts(A.R(0, 1920), A.R(0, 1080), A.R(200, 420), A.R(200, 420)), '#ffffff', 40, 0.3, 0.5); }
  function burst(c1, c2, cx = 960, cy = 540) { A.grad(NP, X0, -300, X1 - X0, 1700, [[0, c1], [1, c2]]);
    for (let i = 0; i < 40; i++) { const a = i / 40 * Math.PI * 2, b = a + Math.PI / 40 * 0.8; A.poly([[cx, cy], [cx + Math.cos(a) * 2600, cy + Math.sin(a) * 2600], [cx + Math.cos(b) * 2600, cy + Math.sin(b) * 2600]], { fill: i % 2 ? '#000000' : '#ffffff', alpha: i % 2 ? 45 : 30, w: 0, curv: 0 }); } }
  return { G, HT, DESK, WB, M, classroom, classroomTense: () => classroom('tense'), gym, gymNight: () => gym('night'), bedroom, bathroom, backyard, kidroom, corridor, flat, burst };
})();
