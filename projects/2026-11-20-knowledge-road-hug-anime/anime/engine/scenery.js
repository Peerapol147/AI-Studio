// Scenery helpers: painted (watercolor) backgrounds, drawn in world coords through A's transform.
// Everything rests on a ground line (no floating props). Meant to be cached once per shot framing.
/* global A, CH, noStroke, beginShape, endShape, vertex, fill, CLOSE */
const SKY = {
  dusk: [[0, '#3f4b8c'], [0.38, '#9a6aa4'], [0.66, '#f0906a'], [0.86, '#ffc785'], [1, '#ffe2a6']],
  tense: [[0, '#3a3270'], [0.4, '#93507e'], [0.7, '#e46a52'], [0.9, '#f8a868'], [1, '#ffd08e']],
  warm: [[0, '#5a64a6'], [0.36, '#c784a8'], [0.64, '#ffa772'], [0.86, '#ffd894'], [1, '#fff0c4']],
};
const SC = (() => {
  const NP = { noStroke: () => noStroke(), fill: c => fill(c), beginShape: () => beginShape(), vertex: (x, y) => vertex(x, y), endShape: () => endShape(CLOSE) };
  function sky(x0, y0, x1, y1, mood = 'dusk') {
    A.grad(NP, x0, y0, x1 - x0, y1 - y0, SKY[mood]);
    // painted cloud streaks
    A.seed(11);
    for (let i = 0; i < 7; i++) {
      const cy = A.lerp(y0, y1, 0.18 + i * 0.1), cx = A.R(x0, x1), w = A.R(380, 760), h = A.R(28, 60);
      A.wc([[cx - w / 2, cy], [cx - w / 4, cy - h], [cx + w / 3, cy - h * 0.7], [cx + w / 2, cy + h * 0.2], [cx, cy + h * 0.5]], i % 2 ? '#ffd6c0' : '#f6a6a0', 70, 0.25, 0.5);
    }
  }
  function sun(x, y, r, mood) {
    A.wc(A.ellPts(x, y, r * 2.4, r * 2.4, 0, 20), mood === 'warm' ? '#fff0b0' : '#ffd79a', 90, 0.35, 0.3);
    A.ell(x, y, r, r, { fill: '#fff3cf', w: 0 });
  }
  function skyline(x0, x1, base, col, hmin, hmax, sd, alpha = 255) {
    A.seed(sd); let x = x0;
    while (x < x1) {
      const w = A.R(50, 130), h = A.R(hmin, hmax);
      A.poly([[x, base], [x, base - h], [x + w, base - h], [x + w, base]], { fill: col, alpha, w: 0, curv: 0 });
      if (A.R() < 0.3) A.poly([[x + w * 0.4, base - h], [x + w * 0.45, base - h - 40], [x + w * 0.5, base - h]], { fill: col, alpha, w: 0, curv: 0 });
      x += w + A.R(-10, 18);
    }
  }
  // side view of the expressway shoulder. ground (feet) ~ y 1330, barrier top y 1110.
  function side(mood = 'dusk') {
    sky(-600, -400, 1680, 1180, mood);
    sun(820, 1010, 80, mood);
    skyline(-600, 1680, 1150, '#b07a92', 60, 230, 5, 170);
    skyline(-600, 1680, 1160, '#82587c', 30, 150, 9, 230);
    // lamp posts (standing on the barrier)
    for (let x = -420; x < 1680; x += 520) {
      A.rect(x - 7, 520, 14, 600, { fill: '#7e7480', w: 1.2 });
      A.poly([[x, 530], [x + 8, 510], [x + 130, 500], [x + 132, 512], [x + 6, 528]], { fill: '#7e7480', w: 1.2, curv: 0.2 });
      A.poly([[x + 112, 512], [x + 150, 512], [x + 146, 526], [x + 116, 526]], { fill: mood === 'warm' ? '#ffe9a8' : '#efe0c0', w: 1, curv: 0.2 });
    }
    // concrete barrier
    A.poly([[-600, 1110], [1680, 1110], [1680, 1240], [-600, 1240]], { fill: '#c9b3a8', w: 1.4, curv: 0 });
    A.poly([[-600, 1110], [1680, 1110], [1680, 1128], [-600, 1128]], { fill: '#e2cfc2', w: 0.8, curv: 0 });
    A.wc([[-600, 1180], [1680, 1170], [1680, 1240], [-600, 1240]], '#8e7480', 90, 0.1, 0.6);
    for (let x = -560; x < 1680; x += 230) A.stroke([[x, 1130], [x + 4, 1236]], { w: 0.7, ink: '#8e7a80' });
    // asphalt
    A.grad(NP, -600, 1240, 2280, 1100, [[0, '#7b6c78'], [0.25, '#665a6a'], [1, '#4c4256']]);
    A.seed(21);
    for (let i = 0; i < 9; i++) { const y = A.R(1260, 2200), x = A.R(-500, 1500); A.wc([[x, y], [x + A.R(200, 500), y + A.R(-20, 20)], [x + A.R(150, 450), y + A.R(40, 90)], [x - 40, y + 60]], i % 2 ? '#3f3648' : '#8a7c88', 60, 0.2, 0.7); }
    A.poly([[-600, 1262], [1680, 1262], [1680, 1272], [-600, 1272]], { fill: '#f1e6d4', w: 0, curv: 0 }); // edge line
    for (let x = -560; x < 1680; x += 300) A.poly([[x, 1790], [x + 170, 1790], [x + 170, 1806], [x, 1806]], { fill: '#efe2cc', w: 0, curv: 0 }); // lane dashes
  }
  // through the windshield: road to a vanishing point; vehicles stop on the LEFT shoulder (drive on the left)
  function pov(mood = 'dusk') {
    sky(-200, -200, 1280, 900, mood);
    sun(760, 820, 60, mood);
    skyline(-200, 1280, 880, '#b07a92', 30, 140, 15, 170);
    skyline(-200, 1280, 886, '#82587c', 15, 80, 19, 230);
    const vx = 560, vy = 880;
    A.grad(NP, -200, vy, 1480, 1100, [[0, '#7b6c78'], [1, '#4c4256']]);
    A.poly([[vx - 30, vy], [-400, 1900], [-200, 1900], [vx - 26, vy]], { fill: '#efe2cc', w: 0, curv: 0 });
    // left barrier wall + right median wall
    A.poly([[vx - 34, vy - 10], [vx - 30, vy], [-200, 1500], [-200, 1150]], { fill: '#c9b3a8', w: 1.2, curv: 0 });
    A.poly([[vx + 36, vy - 10], [vx + 34, vy], [1280, 1500], [1280, 1180]], { fill: '#b9a39c', w: 1.2, curv: 0 });
    // lane dashes
    for (let i = 0; i < 6; i++) { const t0 = Math.pow(i / 6, 1.8), t1 = Math.pow((i + 0.5) / 6, 1.8); const x0 = A.lerp(vx + 4, 640, t0), y0 = A.lerp(vy, 1900, t0), x1 = A.lerp(vx + 4, 640, t1), y1 = A.lerp(vy, 1900, t1); A.poly([[x0 - 1 - t0 * 8, y0], [x0 + 1 + t0 * 8, y0], [x1 + 1 + t1 * 8, y1], [x1 - 1 - t1 * 8, y1]], { fill: '#efe2cc', w: 0, curv: 0 }); }
  }
  // car interior frame (foreground overlay)
  function interior() {
    const dark = '#2b2430';
    A.poly([[-200, -200], [1280, -200], [1280, 110], [-200, 130]], { fill: dark, w: 1.4, curv: 0 });
    A.poly([[-200, 100], [150, 110], [-60, 1500], [-200, 1500]], { fill: dark, w: 1.4, curv: 0.1 });
    A.poly([[1280, 100], [940, 110], [1140, 1500], [1280, 1500]], { fill: dark, w: 1.4, curv: 0.1 });
    A.poly([[460, 110], [620, 110], [610, 190], [470, 190]], { fill: '#3a3340', w: 1.2, curv: 0.4 }); // mirror
    A.poly([[478, 122], [602, 122], [596, 178], [484, 178]], { fill: '#d79a86', w: 0.6, curv: 0.4 });
    A.poly([[-200, 1440], [300, 1380], [780, 1372], [1280, 1420], [1280, 2200], [-200, 2200]], { fill: '#3a3140', w: 1.6, curv: 0.4 }); // dashboard
    A.wc([[-200, 1450], [1280, 1430], [1280, 1500], [-200, 1520]], '#6a5a6e', 80, 0.1, 0.5);
    A.wc([[120, 140], [380, 140], [120, 900], [-40, 900]], '#ffffff', 26, 0.3, 0.2); // glare
  }
  function wide(mood = 'dusk') { // establishing: elevated expressway deck across the city
    sky(-400, -300, 1900, 1250, mood);
    sun(980, 1060, 90, mood);
    skyline(-400, 1900, 1240, '#b07a92', 80, 330, 25, 170);
    skyline(-400, 1900, 1290, '#82587c', 60, 240, 29, 230);
    A.grad(NP, -400, 1280, 2300, 900, [[0, '#6e4e6e'], [1, '#3e3048']]);
    for (let x = -300; x < 1900; x += 420) A.poly([[x, 1040], [x + 70, 1040], [x + 64, 1700], [x + 6, 1700]], { fill: '#a48c98', w: 1.3, curv: 0 });
    A.poly([[-400, 960], [1900, 960], [1900, 1050], [-400, 1050]], { fill: '#c9b3a8', w: 1.5, curv: 0 });
    A.poly([[-400, 1050], [1900, 1050], [1900, 1072], [-400, 1072]], { fill: '#8e7480', w: 1, curv: 0 });
    for (let x = -380; x < 1900; x += 38) A.stroke([[x, 930], [x, 960]], { w: 0.8, ink: '#5d4a58' });
    A.stroke([[-400, 930], [1900, 930]], { w: 1.2, ink: '#5d4a58' });
  }
  function close(mood = 'dusk') { // soft background for front close-ups
    sky(-300, -300, 1380, 1500, mood);
    sun(840, 1180, 120, mood);
    A.wc([[-300, 1300], [1380, 1280], [1380, 1520], [-300, 1540]], '#c9b3a8', 160, 0.3, 0.3);
    A.seed(31);
    for (let i = 0; i < 10; i++) { const x = A.R(-200, 1280), y = A.R(300, 1250), r = A.R(20, 70); A.wc(A.ellPts(x, y, r, r, 0, 14), i % 2 ? '#fff0c8' : '#ffc6a0', 70, 0.3, 0.2); }
    A.grad(NP, -300, 1500, 1680, 900, [[0, '#7b6c78'], [1, '#4c4256']]);
  }
  return { sky, sun, skyline, side, pov, interior, wide, close };
})();
