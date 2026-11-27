/* itch episode graphics: "inside the body" 3D-ish explainer layer (skin cross-section, body nerve map, spinal cord
   cross-section, itch-scratch cycle). Pure function of t (seek-safe): ITCH.render(t, SC) is called every frame from
   episode(t) in index.html. Colours only from the look's CSS variables (+ episode vars --pain/--skin in EPISODE CSS).
   Every scene change lands on a word (times = shots-th.json "start"/"hit_at" + words.json, see T below). */
window.ITCH = (function () {
  const NS = 'http://www.w3.org/2000/svg';
  const clamp = (x, a = 0, b = 1) => Math.min(b, Math.max(a, x)), lerp = (a, b, u) => a + (b - a) * u;
  const eo = x => { x = clamp(x); return 1 - Math.pow(1 - x, 3); }, eio = x => { x = clamp(x); return x * x * (3 - 2 * x); };
  const S = (tau, w, z) => { if (tau <= 0) return 0; if (z < 1) { const wd = w * Math.sqrt(1 - z * z);
    return 1 - Math.exp(-z * w * tau) * (Math.cos(wd * tau) + z * w / wd * Math.sin(wd * tau)); } return 1 - Math.exp(-w * tau) * (1 + w * tau); };
  // spring keyframe track: keys [[t, v], ...] (v number or array)
  function track(keys, t, w = 7, z = 0.82) {
    const v0 = keys[0][1]; const arr = Array.isArray(v0); let v = arr ? v0.slice() : v0;
    for (let k = 1; k < keys.length; k++) { const s = S(t - keys[k][0], w, z), p = keys[k - 1][1], q = keys[k][1];
      if (arr) for (let i = 0; i < v.length; i++) v[i] += (q[i] - p[i]) * s; else v += (q - p) * s; }
    return v;
  }
  const pulse = (t, at, d = 0.5) => (t < at ? 0 : Math.exp(-(t - at) / d));        // decaying flash after a word
  const win = (t, a, b, f = 0.15) => clamp((t - a) / f) * (1 - clamp((t - b) / f)); // on between a and b
  function rng(seed) { return () => { seed = (seed * 1664525 + 1013904223) >>> 0; return seed / 4294967296; }; }
  function el(tag, at, parent) { const e = document.createElementNS(NS, tag); for (const k in at) e.setAttribute(k, at[k]); if (parent) parent.appendChild(e); return e; }
  const f1 = v => (+v).toFixed(1), f3 = v => (+v).toFixed(3);

  // word / shot times (s) from shots-th.json + words.json
  const T = {
    hookIn: 2.14, hurt: 2.48, mast: 4.66, cellW: 4.74, release: 5.50, hist: 6.06, nerve: 7.34, wake: 7.92, nerveW: 8.16,
    itchW: 9.06, spine: 10.66, brain: 10.90, cmd: 11.54, must: 12.00, scr: 12.16, cmdEnd: 12.94,
    pain: 14.90, painW: 15.40, cover: 16.40, temp: 16.98, tempW: 17.22, tempEnd: 18.32,
    mouse: 18.32, mouseW: 19.26, sero: 20.44, release2: 20.94, seroW: 21.16, calm: 22.08, sero2: 23.18, sero2W: 23.46,
    boost: 24.8, push: 25.18, itchW2: 25.68, strong: 26.04, cycle: 27.10, more1: 27.18, scrW: 27.36, more2: 28.14, itchW3: 28.38, end: 29.14
  };
  const RUNS = [
    { id: 'r1', a: 2.14, b: 3.5, first: 'hook_in', scene: 'skin' },
    { id: 'r2', a: 4.66, b: 9.58, first: 'mast', scene: 'skin' },
    { id: 'r3', a: 10.66, b: 12.94, first: 'spine', scene: 'body' },
    { id: 'r4', a: 14.9, b: 18.32, first: 'pain_cover', scene: 'skin' },
    { id: 'r5', a: 20.44, b: 29.14, first: 'serotonin', scene: 'body' }
  ];
  const R = {}; let built = false;

  /* ------------------------------------------------------------------ build */
  function defs(svg) {
    const d = el('defs', {}, svg);
    const lg = (id, stops, x2 = 0, y2 = 1) => { const g = el('linearGradient', { id, x1: 0, y1: 0, x2, y2 }, d);
      stops.forEach(([o, c, a]) => el('stop', { offset: o, style: `stop-color:${c};stop-opacity:${a == null ? 1 : a}` }, g)); return g; };
    const rg = (id, stops, cx = .5, cy = .5, r = .5, fx, fy) => { const g = el('radialGradient', { id, cx, cy, r, fx: fx == null ? cx : fx, fy: fy == null ? cy : fy }, d);
      stops.forEach(([o, c, a]) => el('stop', { offset: o, style: `stop-color:${c};stop-opacity:${a == null ? 1 : a}` }, g)); return g; };
    lg('gAir', [[0, 'var(--bg)'], [1, 'var(--bg2)', .55]]);
    lg('gEpi', [[0, 'var(--skinhi)'], [.35, 'var(--skin)'], [1, 'var(--skinlo)']]);
    lg('gDerm', [[0, 'var(--skinlo)'], [.45, 'var(--bg2)', .9], [1, 'var(--bg)']]);
    rg('gCell', [[0, 'var(--skinhi)', .95], [.7, 'var(--skin)', .55], [1, 'var(--skinhi)', .9]], .45, .38, .55);
    rg('gMast', [[0, 'var(--accent2)', .35], [.62, 'var(--bg2)', .55], [.9, 'var(--accent2)', .65], [1, '#fff', .9]], .42, .36, .55);
    rg('gNuc', [[0, 'var(--bg)', .9], [1, 'var(--bg2)', .6]]);
    rg('gBok', [[0, 'var(--accent2)', .55], [1, 'var(--accent2)', 0]]);
    rg('gBokY', [[0, 'var(--accent)', .5], [1, 'var(--accent)', 0]]);
    rg('gDot', [[0, '#fff', 1], [.35, 'var(--accent)', 1], [1, 'var(--accent)', 0]]);
    rg('gDotP', [[0, '#fff', 1], [.35, 'var(--accent2)', 1], [1, 'var(--accent2)', 0]]);
    rg('gDotR', [[0, '#fff', 1], [.35, 'var(--pain)', 1], [1, 'var(--pain)', 0]]);
    rg('gVig', [[0, '#000', 0], [.62, '#000', 0], [1, '#000', .72]], .5, .42, .75);
    lg('gFinger', [[0, 'var(--skinlo)'], [.3, 'var(--skin)'], [.55, 'var(--skinhi)'], [.8, 'var(--skin)'], [1, 'var(--skinlo)']], 1, 0);
    lg('gNail', [[0, '#fff', .85], [.4, 'var(--skinhi)', .9], [1, 'var(--skin)', .9]], 0, 1);
    rg('gBody', [[0, 'var(--bg2)', .55], [1, 'var(--bg)', .25]], .5, .35, .7);
    rg('gBrain', [[0, '#fff', .9], [.4, 'var(--accent2)', .75], [1, 'var(--bg2)', .4]], .5, .45, .6);
    rg('gCord', [[0, 'var(--skinhi)', .45], [.8, 'var(--bg2)', .55], [1, 'var(--skinhi)', .8]], .45, .4, .6);
    rg('gGray', [[0, 'var(--accent2)', .55], [1, 'var(--skin)', .65]], .5, .45, .6);
    const flt = (id, sd, k = 1) => { const f = el('filter', { id, x: '-60%', y: '-60%', width: '220%', height: '220%' }, d);
      el('feGaussianBlur', { in: 'SourceGraphic', stdDeviation: sd, result: 'b' }, f);
      const m = el('feMerge', {}, f); for (let i = 0; i < k; i++) el('feMergeNode', { in: 'b' }, m); el('feMergeNode', { in: 'SourceGraphic' }, m); return f; };
    flt('glow', 5, 2); flt('glowL', 14, 2);
    const b = (id, sd) => { const f = el('filter', { id, x: '-30%', y: '-30%', width: '160%', height: '160%' }, d); el('feGaussianBlur', { stdDeviation: sd }, f); };
    b('blur3', 3); b('blur8', 8); b('blur16', 16);
    return d;
  }
  const surfY = x => 430 + 14 * Math.sin(x / 90) + 6 * Math.sin(x / 37 + 1);
  const juncY = x => 668 + 26 * Math.sin(x / 52) + 8 * Math.sin(x / 23);
  function pathFrom(fn, x0, x1, step) { let p = ''; for (let x = x0; x <= x1; x += step) p += (p ? 'L' : 'M') + f1(x) + ' ' + f1(fn(x)); return p; }

  // nerves: paths run in the direction the signal travels
  const ITCH_N = [
    'M560 560 C575 610 610 680 650 760 C635 900 610 1050 690 1250 C735 1380 650 1600 640 2000',
    'M640 515 C650 590 652 680 650 760 C635 900 610 1050 690 1250 C735 1380 650 1600 640 2000',
    'M735 572 C715 640 680 700 650 760 C635 900 610 1050 690 1250 C735 1380 650 1600 640 2000'];
  const PAIN_N = [
    'M300 540 C310 620 320 700 330 780 C360 960 390 1110 300 1330 C255 1470 330 1700 320 2000',
    'M392 498 C380 600 350 700 330 780 C360 960 390 1110 300 1330 C255 1470 330 1700 320 2000',
    'M228 600 C270 660 305 720 330 780 C360 960 390 1110 300 1330 C255 1470 330 1700 320 2000'];
  const MAST = [{ x: 470, y: 930, r: 62 }, { x: 830, y: 1010, r: 46 }, { x: 205, y: 1130, r: 42 }, { x: 560, y: 1330, r: 38 }];

  function nerve(g, d, col, w) {
    const base = el('path', { d, fill: 'none', stroke: col, 'stroke-width': w, 'stroke-linecap': 'round', opacity: .3 }, g);
    const glow = el('path', { d, fill: 'none', stroke: col, 'stroke-width': w * 3.2, 'stroke-linecap': 'round', opacity: 0, filter: 'url(#blur8)' }, g);
    const lit = el('path', { d, fill: 'none', stroke: col, 'stroke-width': w * 1.1, 'stroke-linecap': 'round', opacity: 0, filter: 'url(#glow)' }, g);
    const pul = el('path', { d, fill: 'none', stroke: '#fff', 'stroke-width': w * 1.5, 'stroke-linecap': 'round', opacity: 0, filter: 'url(#glow)' }, g);
    const len = base.getTotalLength();
    return { base, glow, lit, pul, len };
  }

  function buildSkin(root) {
    const g = el('g', { id: 'skinCam' }, root); R.skinCam = g;
    el('rect', { x: -600, y: -900, width: 2300, height: 1340, fill: 'url(#gAir)' }, g);
    // far air bokeh (out of focus)
    const far = el('g', { filter: 'url(#blur16)', opacity: .8 }, g); R.airBok = [];
    const r0 = rng(7);
    for (let i = 0; i < 14; i++) R.airBok.push({ e: el('circle', { r: 20 + r0() * 50, fill: r0() < .5 ? 'url(#gBok)' : 'url(#gBokY)' }, far), x: -200 + r0() * 1500, y: -300 + r0() * 650, s: .3 + r0() * .7, ph: r0() * 6 });
    // dermis
    el('path', { d: pathFrom(juncY, -600, 1700, 20) + ' L1700 2300 L-600 2300 Z', fill: 'url(#gDerm)' }, g);
    // far collagen fibres (blurred = depth of field)
    const fib = el('g', { filter: 'url(#blur3)', opacity: .5 }, g); const r1 = rng(11);
    for (let i = 0; i < 46; i++) { const y = 700 + r1() * 1400, x = -500 + r1() * 1900, L = 180 + r1() * 260, a = (r1() - .5) * .6;
      el('path', { d: `M${f1(x)} ${f1(y)} c${f1(L * .3)} ${f1(-30 + a * 60)} ${f1(L * .6)} ${f1(30 + a * 90)} ${f1(L)} ${f1(a * L)}`, fill: 'none', stroke: i % 3 ? 'var(--skinhi)' : 'var(--accent2)', 'stroke-width': 3 + r1() * 5, opacity: .18 + r1() * .2, 'stroke-linecap': 'round' }, fib); }
    // epidermis band
    const epi = pathFrom(surfY, -600, 1700, 20) + ' ' + pathFrom(juncY, -600, 1700, 20).replace('M', 'L').split('L').reverse().filter(Boolean).map((p, i) => (i ? 'L' : 'L') + p).join('') + 'Z';
    // simpler + robust: build polygon explicitly
    let pts = []; for (let x = -600; x <= 1700; x += 20) pts.push([x, surfY(x)]); for (let x = 1700; x >= -600; x -= 20) pts.push([x, juncY(x)]);
    el('path', { d: 'M' + pts.map(p => f1(p[0]) + ' ' + f1(p[1])).join(' L') + ' Z', fill: 'url(#gEpi)' }, g); void epi;
    // epidermal cells (keratinocytes): rows, flatter toward the surface
    const cells = el('g', { opacity: .9 }, g); R.cells = cells; const r2 = rng(3);
    for (let x = -560; x < 1680; x += 44) for (let k = 0; k < 6; k++) {
      const xx = x + (k % 2) * 22 + (r2() - .5) * 8; const top = surfY(xx) + 18, bot = juncY(xx) - 14; const y = lerp(top, bot, (k + .5) / 6);
      if (y > bot) continue; const flat = 1 - k / 6;
      el('ellipse', { cx: f1(xx), cy: f1(y), rx: f1(20 + flat * 6), ry: f1(15 - flat * 8), fill: 'url(#gCell)', opacity: f3(.45 + r2() * .35) }, cells);
      if (k > 1) el('circle', { cx: f1(xx + (r2() - .5) * 5), cy: f1(y), r: 4.5, fill: 'var(--bg2)', opacity: .55 }, cells);
    }
    // stratum corneum rim light + junction glow
    el('path', { d: pathFrom(surfY, -600, 1700, 20), fill: 'none', stroke: '#fff', 'stroke-width': 5, opacity: .75, filter: 'url(#glow)' }, g);
    el('path', { d: pathFrom(x => surfY(x) + 9, -600, 1700, 20), fill: 'none', stroke: 'var(--accent2)', 'stroke-width': 3, opacity: .5 }, g);
    el('path', { d: pathFrom(juncY, -600, 1700, 20), fill: 'none', stroke: 'var(--accent2)', 'stroke-width': 4, opacity: .45, filter: 'url(#glow)' }, g);
    // mast cells
    R.mast = MAST.map((m, i) => {
      const mg = el('g', {}, g);
      const halo = el('circle', { cx: m.x, cy: m.y, r: m.r * 1.5, fill: 'url(#gBok)', opacity: .5, filter: 'url(#blur8)' }, mg);
      const body = el('circle', { cx: m.x, cy: m.y, r: m.r, fill: 'url(#gMast)' }, mg);
      const mem = el('circle', { cx: m.x, cy: m.y, r: m.r, fill: 'none', stroke: '#fff', 'stroke-width': 3, opacity: .7, filter: 'url(#glow)' }, mg);
      const nuc = el('ellipse', { cx: m.x - m.r * .15, cy: m.y + m.r * .1, rx: m.r * .38, ry: m.r * .3, fill: 'url(#gNuc)' }, mg);
      const rr = rng(40 + i), gran = [];
      for (let k = 0; k < (i ? 14 : 34); k++) { const a = rr() * 6.283, d = Math.sqrt(rr()) * m.r * .78;
        gran.push({ e: el('circle', { r: i ? 4 : 6, fill: 'url(#gDot)' }, mg), a, d, ph: rr() * 6, sp: .6 + rr() }); }
      return { ...m, mg, halo, body, mem, nuc, gran };
    });
    // nerves (pain behind, itch in front)
    const ng = el('g', {}, g);
    R.pain = PAIN_N.map(d => nerve(ng, d, 'var(--pain)', 7));
    R.itch = ITCH_N.map(d => nerve(ng, d, 'var(--accent)', 8));
    R.painEnd = PAIN_N.map(d => { const m = d.match(/M(\d+) (\d+)/); return el('circle', { cx: m[1], cy: m[2], r: 13, fill: 'url(#gDotR)', opacity: .35 }, ng); });
    R.itchEnd = ITCH_N.map(d => { const m = d.match(/M(\d+) (\d+)/); return el('circle', { cx: m[1], cy: m[2], r: 14, fill: 'url(#gDot)', opacity: .35 }, ng); });
    // histamine particles (from the hero mast cell)
    const hg = el('g', {}, g); const r3 = rng(99); R.hist = [];
    const ends = ITCH_N.map(d => d.match(/M(\d+) (\d+)/).slice(1).map(Number));
    for (let i = 0; i < 40; i++) { const a = r3() * 6.283; R.hist.push({ e: el('circle', { r: 7 + r3() * 4, fill: 'url(#gDot)', opacity: 0 }, hg), a, sp: 170 + r3() * 190, ph: r3() * 6, tgt: ends[i % 3], jx: (r3() - .5) * 60, jy: (r3() - .5) * 50, lag: r3() * .35 }); }
    // scratch trail on the surface + the fingertip
    R.trail = el('path', { d: '', fill: 'none', stroke: 'var(--pain)', 'stroke-width': 16, 'stroke-linecap': 'round', opacity: 0, filter: 'url(#glowL)' }, g);
    R.trail2 = el('path', { d: '', fill: 'none', stroke: '#fff', 'stroke-width': 5, 'stroke-linecap': 'round', opacity: 0 }, g);
    const fg = el('g', {}, g); R.finger = fg;
    // fingertip in side profile: palmar pad (left) bulges, nail plate along the dorsal side, free edge past the tip
    const FP = 'M-96 -1000 L-98 -330 C-100 -250 -112 -170 -104 -100 C-96 -30 -50 8 0 10 C40 12 70 -10 78 -60 L84 -1000 Z';
    el('path', { d: FP, fill: 'url(#gFinger)' }, fg);
    el('path', { d: 'M-98 -330 C-100 -250 -112 -170 -104 -100 C-96 -30 -50 8 0 10', fill: 'none', stroke: 'var(--accent2)', 'stroke-width': 6, opacity: .85, filter: 'url(#glow)' }, fg);
    el('path', { d: 'M-96 -1000 L-98 -330', fill: 'none', stroke: 'var(--accent2)', 'stroke-width': 4, opacity: .6 }, fg);
    ['M-98 -300 C-70 -290 -40 -296 -20 -312', 'M-97 -330 C-72 -318 -46 -322 -28 -336', 'M-96 -700 C-70 -690 -44 -694 -24 -708'].forEach(d => el('path', { d, fill: 'none', stroke: 'var(--skinlo)', 'stroke-width': 4, 'stroke-linecap': 'round', opacity: .8 }, fg));
    // nail: thin plate on the dorsal side, cuticle at -250, free edge hooks past the tip
    el('path', { d: 'M52 -250 C66 -180 74 -110 70 -50 C66 -10 44 18 14 26 L8 14 C34 4 50 -24 52 -60 C54 -120 46 -190 36 -244 Z', fill: 'url(#gNail)' }, fg);
    el('path', { d: 'M14 26 C44 18 66 -10 70 -50', fill: 'none', stroke: '#fff', 'stroke-width': 5, 'stroke-linecap': 'round', opacity: .95, filter: 'url(#glow)' }, fg);
    el('path', { d: 'M58 -230 C68 -170 72 -110 69 -60', fill: 'none', stroke: '#fff', 'stroke-width': 3, opacity: .55 }, fg);
    el('path', { d: 'M84 -1000 L78 -60', fill: 'none', stroke: 'var(--accent2)', 'stroke-width': 4, opacity: .5 }, fg);
    // near-field dermis bokeh (in front, blurred, parallax)
    const near = el('g', { filter: 'url(#blur8)' }, g); R.nearBok = []; const r4 = rng(5);
    for (let i = 0; i < 22; i++) R.nearBok.push({ e: el('circle', { r: 6 + r4() * 18, fill: i % 4 ? 'url(#gBok)' : 'url(#gBokY)', opacity: .7 }, near), x: -300 + r4() * 1700, y: 650 + r4() * 1300, s: .4 + r4(), ph: r4() * 6 });
  }

  // body silhouette (front view, x-ray look)
  const BODY_L = [ // [c1, c2, p] cubic segments from the neck down the viewer-left side
    [[498, 470], [480, 480], [440, 488]], [[390, 496], [345, 505], [318, 535]], [[292, 562], [283, 600], [281, 640]],
    [[276, 740], [268, 830], [264, 905]], [[259, 990], [256, 1080], [258, 1170]], [[259, 1230], [266, 1290], [290, 1302]],
    [[314, 1310], [322, 1262], [321, 1190]], [[322, 1090], [330, 1000], [333, 920]], [[337, 840], [342, 760], [350, 690]],
    [[362, 780], [370, 880], [376, 980]], [[381, 1060], [368, 1150], [372, 1260]], [[376, 1360], [378, 1460], [380, 1600]]];
  function bodyPath() {
    const m = p => [1080 - p[0], p[1]], P = q => f1(q[0]) + ' ' + f1(q[1]);
    let d = 'M500 430 ', prev = [500, 430]; const segs = [];
    BODY_L.forEach(s => { segs.push([prev, s[0], s[1], s[2]]); d += `C${P(s[0])} ${P(s[1])} ${P(s[2])} `; prev = s[2]; });
    d += `L${P(m(prev))} `;
    for (let i = segs.length - 1; i >= 0; i--) { const [p0, c1, c2] = segs[i]; d += `C${P(m(c2))} ${P(m(c1))} ${P(m(p0))} `; }
    return d + 'Z';
  }
  const ARM_UP = 'M292 1085 C300 980 300 860 300 760 C302 660 340 592 420 574 C480 562 530 562 540 540 L540 420 C540 398 540 384 540 362';
  const ARM_DN = 'M550 362 L550 548 C540 578 470 584 428 590 C354 606 318 672 316 762 C316 862 314 980 306 1085';
  const CORD_DN = 'M540 380 L540 1500';
  function buildBody(root) {
    const g = el('g', { id: 'bodyCam', opacity: 0 }, root); R.bodyCam = g;
    el('rect', { x: -1400, y: -1400, width: 3900, height: 4800, fill: 'var(--bg)' }, g);
    el('ellipse', { cx: 540, cy: 760, rx: 900, ry: 1100, fill: 'url(#gBody)' }, g);
    const far = el('g', { filter: 'url(#blur16)' }, g); R.bodyBok = []; const r0 = rng(21);
    for (let i = 0; i < 18; i++) R.bodyBok.push({ e: el('circle', { r: 16 + r0() * 50, fill: i % 3 ? 'url(#gBok)' : 'url(#gBokY)', opacity: .5 }, far), x: -300 + r0() * 1700, y: -200 + r0() * 2200, ph: r0() * 6 });
    const sil = el('g', {}, g);
    const bp = bodyPath();
    el('path', { d: bp, fill: 'none', stroke: 'var(--accent2)', 'stroke-width': 14, opacity: .35, filter: 'url(#blur8)' }, sil);
    el('ellipse', { cx: 540, cy: 320, rx: 94, ry: 116, fill: 'none', stroke: 'var(--accent2)', 'stroke-width': 14, opacity: .35, filter: 'url(#blur8)' }, sil);
    const fill = el('g', { opacity: .8 }, sil);
    el('path', { d: bp, fill: 'var(--panel)' }, fill); el('ellipse', { cx: 540, cy: 320, rx: 94, ry: 116, fill: 'var(--panel)' }, fill);
    el('path', { d: bp, fill: 'url(#gBody)', opacity: .9 }, sil);
    el('path', { d: bp, fill: 'none', stroke: '#fff', 'stroke-width': 2.5, opacity: .45 }, sil);
    el('ellipse', { cx: 540, cy: 320, rx: 94, ry: 116, fill: 'none', stroke: '#fff', 'stroke-width': 2.5, opacity: .45 }, sil);
    // vertebrae + faint peripheral nerves
    for (let y = 450; y < 1480; y += 34) el('rect', { x: 522, y, width: 36, height: 22, rx: 8, fill: 'var(--skinhi)', opacity: .22 }, sil);
    const per = el('g', { opacity: .28, fill: 'none', stroke: 'var(--accent2)', 'stroke-width': 3 }, sil);
    ['M540 560 C620 560 700 580 760 640 C780 760 780 900 790 1080', 'M540 700 C470 720 430 760 400 820', 'M540 700 C610 720 650 760 680 820',
      'M540 860 C470 880 430 920 405 980', 'M540 860 C610 880 650 920 675 980', 'M540 1020 C480 1050 450 1090 430 1150', 'M540 1020 C600 1050 630 1090 650 1150',
      'M540 1300 C500 1360 470 1430 460 1560', 'M540 1300 C580 1360 610 1430 620 1560'].forEach(d => el('path', { d }, per));
    R.cordBase = el('path', { d: 'M540 400 L540 1500', stroke: 'var(--accent2)', 'stroke-width': 9, opacity: .5, filter: 'url(#glow)' }, g);
    // brain
    const bg = el('g', {}, g); R.brainG = bg;
    R.brainHalo = el('ellipse', { cx: 540, cy: 300, rx: 120, ry: 100, fill: 'url(#gBokY)', opacity: 0, filter: 'url(#blur16)' }, bg);
    R.brain = el('path', { d: 'M540 248 C500 236 462 252 456 290 C450 330 478 362 520 360 C528 362 536 356 540 350 C544 356 552 362 560 360 C602 362 630 330 624 290 C618 252 580 236 540 248 Z', fill: 'url(#gBrain)', opacity: .55, filter: 'url(#glow)' }, bg);
    const gy = el('g', { fill: 'none', stroke: '#fff', 'stroke-width': 2.5, opacity: .55 }, bg); R.gyri = gy;
    ['M540 252 L540 350', 'M470 290 C490 276 510 300 528 282', 'M468 322 C492 308 506 336 528 318', 'M612 290 C590 276 570 300 552 282',
      'M612 322 C588 308 574 336 552 318', 'M490 260 C500 274 520 262 528 270', 'M590 260 C580 274 560 262 552 270', 'M486 346 C500 334 516 352 530 340', 'M594 346 C580 334 564 352 550 340'].forEach(d => el('path', { d }, gy));
    // itch spot on the forearm + signal paths
    R.spot = el('circle', { cx: 292, cy: 1085, r: 18, fill: 'url(#gDot)', opacity: 0 }, g);
    R.spotRing = el('circle', { cx: 292, cy: 1085, r: 30, fill: 'none', stroke: 'var(--accent)', 'stroke-width': 4, opacity: 0 }, g);
    R.up = nerve(g, ARM_UP, 'var(--accent)', 7);
    R.upPain = nerve(g, ARM_UP, 'var(--pain)', 7);
    R.dn = nerve(g, ARM_DN, '#fff', 5);
    R.scrMarks = [0, 1, 2].map(i => el('path', { d: `M${262 + i * 22} 1040 C${270 + i * 22} 1070 ${270 + i * 22} 1100 ${262 + i * 22} 1130`, fill: 'none', stroke: 'var(--pain)', 'stroke-width': 7, 'stroke-linecap': 'round', opacity: 0, filter: 'url(#glow)' }, g));
    // serotonin particles going down the cord
    const sg = el('g', {}, g); const r5 = rng(77); R.sero = [];
    for (let i = 0; i < 46; i++) R.sero.push({ e: el('circle', { r: 6 + r5() * 6, fill: 'url(#gDotP)', opacity: 0 }, sg), ph: r5(), jx: (r5() - .5) * 46, sp: .3 + r5() * .25, w: r5() * 6 });
  }

  // spinal cord cross-section (local coords, centre 0,0) + the itch cycle ring
  function grayPath() {
    const L = [[-14, -44], [-40, -70], [-86, -150], [-118, -214], [-132, -236], [-108, -244], [-90, -214], [-64, -160], [-46, -116], [-64, -96],
      [-120, -70], [-176, -30], [-206, 30], [-200, 110], [-168, 160], [-122, 170], [-92, 130], [-64, 70], [-30, 40], [-14, 40]];
    const pts = L.concat(L.slice().reverse().map(p => [-p[0], p[1]]));
    let d = 'M' + pts.map(p => p.join(' ')).join(' L') + ' Z';
    return d;
  }
  const NEU = { x: -96, y: -176 };
  const AXON = 'M-96 -176 C-60 -110 -20 -80 40 -96 C110 -116 170 -170 220 -260 C240 -300 262 -340 280 -420';
  const FIBER = 'M-420 -380 C-300 -320 -190 -260 -96 -176';
  function buildCord(root) {
    const g = el('g', { id: 'cordG', opacity: 0 }, root); R.cordG = g;
    const inner = el('g', {}, g); R.cordInner = inner;
    el('ellipse', { cx: 0, cy: 0, rx: 380, ry: 310, fill: 'var(--accent2)', opacity: .25, filter: 'url(#blur16)' }, inner);
    el('ellipse', { cx: 0, cy: 0, rx: 340, ry: 280, fill: 'url(#gCord)' }, inner);
    // white-matter tract texture
    const tx = el('g', { opacity: .35 }, inner); const r = rng(13);
    for (let i = 0; i < 160; i++) { const a = r() * 6.283, d = Math.sqrt(r()) * .95; const x = Math.cos(a) * 330 * d, y = Math.sin(a) * 270 * d;
      el('circle', { cx: f1(x), cy: f1(y), r: f1(3 + r() * 5), fill: 'none', stroke: 'var(--skinhi)', 'stroke-width': 1.6 }, tx); }
    el('ellipse', { cx: 0, cy: 0, rx: 340, ry: 280, fill: 'none', stroke: '#fff', 'stroke-width': 4, opacity: .7, filter: 'url(#glow)' }, inner);
    el('path', { d: grayPath(), fill: 'url(#gGray)', opacity: .95 }, inner);
    el('path', { d: grayPath(), fill: 'none', stroke: 'var(--accent2)', 'stroke-width': 3, opacity: .8, filter: 'url(#glow)' }, inner);
    el('circle', { cx: 0, cy: 0, r: 12, fill: 'var(--bg)', stroke: 'var(--skinhi)', 'stroke-width': 3 }, inner);
    R.fiber = nerve(inner, FIBER, 'var(--accent)', 7);
    R.axon = nerve(inner, AXON, 'var(--accent)', 8);
    R.neuRings = [0, 1, 2].map(() => el('circle', { cx: NEU.x, cy: NEU.y, r: 30, fill: 'none', stroke: 'var(--accent)', 'stroke-width': 6, opacity: 0 }, inner));
    R.neuHalo = el('circle', { cx: NEU.x, cy: NEU.y, r: 70, fill: 'url(#gBokY)', opacity: .5, filter: 'url(#blur8)' }, inner);
    const den = el('g', { fill: 'none', stroke: 'var(--accent)', 'stroke-width': 5, 'stroke-linecap': 'round', opacity: .85 }, inner);
    ['M-96 -176 C-130 -200 -150 -210 -170 -200', 'M-96 -176 C-80 -215 -70 -230 -48 -236', 'M-96 -176 C-135 -160 -150 -140 -158 -120'].forEach(d => el('path', { d }, den));
    R.neu = el('circle', { cx: NEU.x, cy: NEU.y, r: 26, fill: 'url(#gDot)', filter: 'url(#glow)' }, inner);
    R.rec = []; for (let i = 0; i < 7; i++) { const a = -2.6 + i * .62; R.rec.push({ x: NEU.x + Math.cos(a) * 40, y: NEU.y + Math.sin(a) * 40 }); }
    const pg = el('g', {}, inner); const r2 = rng(55); R.seroC = [];
    for (let i = 0; i < 30; i++) R.seroC.push({ e: el('circle', { r: 7 + r2() * 5, fill: 'url(#gDotP)', opacity: 0 }, pg), x0: -320 + r2() * 640, ph: r2(), k: i % 7, lag: r2() * .6 });
    // cycle ring (screen-space group, around the shrunk cord)
    const cy = el('g', { id: 'cycleG', opacity: 0 }, root); R.cycleG = cy;
    R.ring = el('circle', { cx: 0, cy: 0, r: 330, fill: 'none', stroke: 'var(--accent2)', 'stroke-width': 10, 'stroke-dasharray': '150 57', 'stroke-linecap': 'round', opacity: .75, filter: 'url(#glow)' }, cy);
    R.arrows = [0, 1, 2, 3].map(() => el('path', { d: 'M-22 -24 L18 0 L-22 24', fill: 'none', stroke: '#fff', 'stroke-width': 10, 'stroke-linecap': 'round', 'stroke-linejoin': 'round', filter: 'url(#glow)' }, cy));
    R.comet = el('circle', { r: 26, fill: 'url(#gDot)', filter: 'url(#glow)' }, cy);
    R.comet2 = el('circle', { r: 16, fill: 'url(#gDot)', opacity: .6 }, cy);
  }

  function label(parent, txt, col, size) {
    const d = document.createElement('div'); d.className = 'ilab'; d.textContent = txt;
    d.style.setProperty('--lc', col); d.style.fontSize = size + 'px'; parent.appendChild(d); return d;
  }

  function build() {
    const wrap = document.getElementById('gfx'); R.wrap = wrap; R.inner = document.getElementById('gfx-in');
    const svg = el('svg', { width: 1080, height: 1920, viewBox: '0 0 1080 1920' }); svg.style.position = 'absolute'; svg.style.left = 0; svg.style.top = 0;
    R.inner.insertBefore(svg, R.inner.firstChild); defs(svg);
    buildSkin(svg); buildBody(svg); buildCord(svg);
    el('rect', { x: 0, y: 0, width: 1080, height: 1920, fill: 'url(#gVig)' }, svg);
    const L = document.getElementById('gfx-lab');
    R.lHist = label(L, 'ฮิสตามีน', 'var(--accent)', 76);
    R.lItch = label(L, 'ประสาทรับความคัน', 'var(--accent)', 56);
    R.lBrain = label(L, 'สมอง', '#fff', 60);
    R.lP = label(L, 'เจ็บ', 'var(--pain)', 64);
    R.lI = label(L, 'คัน', 'var(--accent)', 64);
    R.lTemp = label(L, 'ชั่วคราว', '#fff', 84);
    R.timer = document.getElementById('gfx-timer');
    R.lSero = label(L, 'เซโรโทนิน', 'var(--accent2)', 76);
    R.lSero2 = label(L, 'เซโรโทนิน', 'var(--accent2)', 56);
    R.lNeu = label(L, 'เซลล์ประสาทความคัน', 'var(--accent)', 52);
    R.nodes = [['คัน', 'var(--accent)'], ['เกา', '#fff'], ['เจ็บ', 'var(--pain)'], ['เซโรโทนิน', 'var(--accent2)']].map(([t, c]) => label(L, t, c, 66));
    R.mouseChip = document.getElementById('mouse-chip');
    built = true;
  }

  /* ------------------------------------------------------------------ render helpers */
  function cam(g, c, t, amp = 1) {
    const dx = amp * (7 * Math.sin(t * .9) + 3 * Math.sin(t * 2.3)), dy = amp * (6 * Math.cos(t * .7) + 2 * Math.sin(t * 1.9));
    g.setAttribute('transform', `translate(540 760) scale(${f3(c[2])}) translate(${f1(-c[0] + dx)} ${f1(-c[1] + dy)})`);
    return (x, y) => [540 + (x - c[0] + dx) * c[2], 760 + (y - c[1] + dy) * c[2]];
  }
  function setNerve(n, t, lvl, speed, gap, seg, dir = 1) {
    n.base.setAttribute('opacity', f3(.25 + .3 * lvl));
    n.glow.setAttribute('opacity', f3(.55 * lvl)); n.lit.setAttribute('opacity', f3(.9 * lvl));
    n.pul.setAttribute('opacity', f3(lvl > .02 ? Math.min(1, lvl * 1.2) : 0));
    n.pul.setAttribute('stroke-dasharray', `${seg} ${gap}`); n.pul.setAttribute('stroke-dashoffset', f1(-dir * ((t * speed) % (seg + gap))));
  }
  function place(lab, xy, s, o, dx = 0, dy = 0, rot = 0) {
    lab.style.opacity = f3(clamp(o)); lab.style.transform = `translate(${f1(xy[0] + dx)}px,${f1(xy[1] + dy)}px) translate(-50%,-50%) rotate(${rot}deg) scale(${f3(Math.max(0.001, s))})`;
  }
  const popS = (t, at) => (t < at ? 0 : S(t - at, 16, 0.5));
  function hideLabs() { [R.lHist, R.lItch, R.lBrain, R.lP, R.lI, R.lTemp, R.lSero, R.lSero2, R.lNeu, ...R.nodes].forEach(l => (l.style.opacity = '0')); R.timer.style.opacity = '0'; }

  /* ------------------------------------------------------------------ skin scene */
  function renderSkin(t, run) {
    let c, scratch = 0, itchLvl = 0, painLvl = 0, burst = -1, toNerve = 0, histOn = 0, itchCover = 0, fingerOn = 0, nx = 640;
    if (run === 'r1') {
      c = track([[T.hookIn, [620, 380, 2.6]], [T.hookIn + .08, [590, 420, 1.3]]], t, 6.5, .9);
      fingerOn = 1; scratch = 1; nx = 610 + 150 * Math.sin((t - T.hookIn) * 2 * Math.PI * 1.9);
      painLvl = clamp((t - T.hurt) / .12) * (0.75 + .25 * Math.sin(t * 30)); itchLvl = .15;
    } else if (run === 'r2') {
      c = track([[T.mast, [470, 930, 1.75]], [T.release, [470, 930, 2.05]], [T.hist, [520, 860, 1.45]], [T.nerve, [640, 690, 1.42]], [T.nerveW, [650, 1000, 1.18]]], t, 6, .85);
      burst = T.hist; histOn = 1; toNerve = eio((t - T.nerve) / .6); itchLvl = clamp((t - T.wake) / .2);
    } else {
      c = track([[T.pain, [560, 780, 1.12]], [T.cover, [520, 720, 1.28]], [T.temp, [600, 640, 1.42]]], t, 6, .85);
      fingerOn = 1; scratch = clamp((t - T.pain) / .2); nx = 520 + 160 * Math.sin((t - T.pain) * 2 * Math.PI * 1.6);
      painLvl = clamp((t - T.painW) / .35) * (.35 + .65 * clamp((t - (T.cover - .3)) / .3));
      itchCover = clamp((t - T.cover) / .25);
      const back = t > T.tempW + .2 ? clamp((t - T.tempW - .2) / .9) : 0;
      const flick = .5 + .5 * Math.sin(t * 22);
      itchLvl = lerp(1, .12, itchCover) + back * .75 * flick * itchCover;
      burst = 0;
    }
    const P = cam(R.skinCam, c, t);
    R.airBok.forEach(b => { b.e.setAttribute('cx', f1(b.x + 40 * Math.sin(t * .3 * b.s + b.ph))); b.e.setAttribute('cy', f1(b.y + 30 * Math.cos(t * .4 * b.s + b.ph))); });
    R.nearBok.forEach(b => { b.e.setAttribute('cx', f1(b.x + 60 * Math.sin(t * .35 * b.s + b.ph) + (c[0] - 540) * .25)); b.e.setAttribute('cy', f1(b.y - 40 * t * .2 * b.s % 300 + 25 * Math.cos(t * .5 + b.ph))); });
    R.cells.setAttribute('transform', `translate(0 ${f1(2 * Math.sin(t * 1.3))})`);
    // mast cells
    R.mast.forEach((m, i) => {
      const hero = i === 0; let sc = 1 + .03 * Math.sin(t * 2.2 + i), memO = .7, bodyO = 1, gl = .5;
      if (hero && burst > 0) { const pre = clamp((t - T.release) / (T.hist - T.release)); sc += .12 * eio(pre) + .02 * Math.sin(t * 40) * pre;
        if (t >= burst) { const u = t - burst; sc = 1.15 + .25 * eo(u / .3); memO = .7 * (1 - eo(u / .25)); bodyO = lerp(1, .35, eo(u / .4)); } gl = .5 + .5 * pre; }
      m.mg.setAttribute('transform', `translate(${m.x} ${m.y}) scale(${f3(sc)}) translate(${-m.x} ${-m.y})`);
      m.mem.setAttribute('opacity', f3(memO)); m.body.setAttribute('opacity', f3(bodyO)); m.halo.setAttribute('opacity', f3(gl));
      m.mem.setAttribute('stroke-dasharray', hero && burst > 0 && t >= burst ? `${f1(40 * (1 - eo((t - burst) / .3)) + 2)} 22` : 'none');
      m.gran.forEach(g => { const vis = !(hero && burst > 0 && t >= burst); const a = g.a + .25 * Math.sin(t * g.sp + g.ph);
        g.e.setAttribute('cx', f1(m.x + Math.cos(a) * g.d)); g.e.setAttribute('cy', f1(m.y + Math.sin(a) * g.d)); g.e.setAttribute('opacity', vis ? .9 : 0); });
    });
    // histamine
    R.hist.forEach((h, i) => {
      if (!histOn || t < burst) { h.e.setAttribute('opacity', 0); return; }
      const u = t - burst, d = h.sp * (1 - Math.exp(-3.2 * u)) + 14 * u;
      let x = MAST[0].x + Math.cos(h.a) * d + 10 * Math.sin(t * 3 + h.ph), y = MAST[0].y + Math.sin(h.a) * d + 10 * Math.cos(t * 2.6 + h.ph);
      const k = eio((t - T.nerve - h.lag) / .7);
      x = lerp(x, h.tgt[0] + h.jx, k); y = lerp(y, h.tgt[1] + 30 + h.jy, k);
      const fade = 1 - clamp((t - T.wake - .25 - h.lag) / .5) * .7;
      h.e.setAttribute('cx', f1(x)); h.e.setAttribute('cy', f1(y)); h.e.setAttribute('opacity', f3(clamp(u / .08) * fade));
    });
    // nerves
    R.itch.forEach((n, i) => setNerve(n, t + i * .13, itchLvl, 900, 260, 90));
    R.pain.forEach((n, i) => setNerve(n, t + i * .11, painLvl, 1150, 200, 110));
    R.itchEnd.forEach((e, i) => { e.setAttribute('opacity', f3(.3 + .7 * itchLvl)); e.setAttribute('r', f1(13 + 10 * itchLvl + 3 * Math.sin(t * 9 + i))); });
    R.painEnd.forEach((e, i) => { e.setAttribute('opacity', f3(.3 + .7 * painLvl)); e.setAttribute('r', f1(12 + 14 * painLvl + 4 * Math.sin(t * 13 + i))); });
    // finger + trail
    if (fingerOn) {
      const ny = surfY(nx) - 10 + 6 * Math.abs(Math.cos((t) * 2 * Math.PI * 1.9));
      const tilt = 34 + 6 * Math.cos((t) * 2 * Math.PI * 1.9);
      R.finger.setAttribute('transform', `translate(${f1(nx)} ${f1(ny)}) rotate(${f1(tilt)})`); R.finger.setAttribute('opacity', 1);
      const span = run === 'r1' ? [460, 760] : [360, 680];
      R.trail.setAttribute('d', pathFrom(x => surfY(x) + 4, span[0], span[1], 10)); R.trail2.setAttribute('d', pathFrom(x => surfY(x) + 4, span[0] + 30, span[1] - 30, 10));
      const tr = scratch * (.7 + .3 * Math.abs(Math.sin(t * 12)));
      R.trail.setAttribute('opacity', f3(tr)); R.trail2.setAttribute('opacity', f3(tr * .6));
    } else { R.finger.setAttribute('opacity', 0); R.trail.setAttribute('opacity', 0); R.trail2.setAttribute('opacity', 0); }
    // labels
    if (run === 'r2') {
      place(R.lHist, P(560, 760), popS(t, T.hist) * (1 - .25 * eio((t - T.nerve) / .5)), 1 - clamp((t - T.nerveW) / .3), 0, -40, -3);
      place(R.lItch, P(640, 470), popS(t, T.nerveW), 1, 0, -10, 0);
    }
    if (run === 'r4') {
      place(R.lP, P(300, 470), popS(t, T.painW) * (1 + .25 * pulse(t, T.cover, .3)), 1, 0, -20, -4);
      place(R.lI, P(640, 450), popS(t, T.pain + .3) * lerp(1, .8, itchCover), lerp(1, .4, itchCover) + .6 * (itchLvl - .12) * itchCover, 0, -20, 3);
      const tp = popS(t, T.tempW);
      place(R.lTemp, [560, 330], tp, clamp((t - T.tempW) / .05), 0, 0, -3);
      if (t >= T.tempW) {
        const u = clamp((t - T.tempW) / 1.0);
        R.timer.style.opacity = f3(clamp((t - T.tempW) / .1)); R.timer.style.transform = `translate(860px,330px) translate(-50%,-50%) scale(${f3(1.3 * tp)})`;
        R.timer.querySelector('circle.sweep').setAttribute('stroke-dashoffset', f1(-339.3 * u));
        R.timer.querySelector('line').setAttribute('transform', `rotate(${f1(360 * u * 1.15)} 60 60)`);
      }
    }
  }

  /* ------------------------------------------------------------------ body scene (+ cord + cycle in r5) */
  function renderBody(t, run) {
    let c, upLvl = 0, painUp = 0, dnLvl = 0, brainLvl = .2, seroOn = 0, spot = 0, scr = 0, cordMix = 0;
    if (run === 'r3') {
      c = track([[T.spine, [520, 760, .74]], [T.brain, [535, 560, .86]], [T.must, [430, 900, .9]]], t, 6, .85);
      spot = 1; upLvl = 1 - clamp((t - T.cmd) / .3) * .7; brainLvl = .3 + .7 * clamp((t - T.brain) / .12);
      dnLvl = clamp((t - T.cmd - .1) / .2); scr = clamp((t - T.scr) / .1);
    } else {
      c = track([[T.sero, [540, 560, 1.55]], [T.calm, [540, 640, 1.38]], [T.sero2, [540, 640, 1.38]], [T.sero2 + .02, [540, 640, 7.5]]], t, 6, .9);
      brainLvl = .45 + .55 * clamp((t - T.release2) / .2); painUp = (1 - eio((t - T.calm) / .45)) * clamp((t - T.sero) / .2);
      seroOn = clamp((t - T.release2) / .25); spot = .6;
      cordMix = eio((t - T.sero2 - .12) / .32);
    }
    const P = cam(R.bodyCam, c, t, run === 'r5' && t > T.sero2 ? 0 : 1);
    R.bodyBok.forEach(b => { b.e.setAttribute('cx', f1(b.x + 50 * Math.sin(t * .3 + b.ph))); b.e.setAttribute('cy', f1(b.y + 40 * Math.cos(t * .35 + b.ph))); });
    R.brain.setAttribute('opacity', f3(.35 + .65 * brainLvl)); R.brainHalo.setAttribute('opacity', f3(brainLvl * (.7 + .3 * Math.sin(t * 6))));
    R.gyri.setAttribute('opacity', f3(.3 + .5 * brainLvl));
    const bs = 1 + .06 * pulse(t, run === 'r3' ? T.brain : T.release2, .25);
    R.brainG.setAttribute('transform', `translate(540 300) scale(${f3(bs)}) translate(-540 -300)`);
    R.spot.setAttribute('opacity', f3(spot * (.7 + .3 * Math.sin(t * 8)))); R.spot.setAttribute('r', f1(16 + 5 * Math.sin(t * 8)));
    const rp = ((t * 1.4) % 1); R.spotRing.setAttribute('r', f1(20 + 60 * rp)); R.spotRing.setAttribute('opacity', f3(spot * (1 - rp)));
    setNerve(R.up, t, upLvl, 1300, 260, 120); setNerve(R.upPain, t, painUp, 1200, 220, 120);
    setNerve(R.dn, t, dnLvl, 1600, 400, 140);
    R.scrMarks.forEach((m, i) => { const ph = (t * 5.5 + i * .25) % 1; m.setAttribute('opacity', f3(scr * (1 - ph))); m.setAttribute('transform', `translate(0 ${f1(-30 + 60 * ph)})`); });
    R.cordBase.setAttribute('opacity', f3(.4 + .4 * seroOn));
    R.sero.forEach(p => { if (!seroOn) { p.e.setAttribute('opacity', 0); return; }
      const u = (p.ph + (t - T.release2) * p.sp); const y = 380 + (u % 1) * 900; const x = 540 + p.jx * (0.4 + (u % 1)) + 8 * Math.sin(t * 3 + p.w);
      const born = clamp((t - T.release2 - p.ph * .8) / .15); p.e.setAttribute('cx', f1(x)); p.e.setAttribute('cy', f1(y)); p.e.setAttribute('opacity', f3(born * seroOn * (1 - (u % 1) * .6))); });
    R.bodyCam.setAttribute('opacity', f3(1 - cordMix));
    // labels
    if (run === 'r3') place(R.lBrain, P(540, 200), popS(t, T.brain), 1, 0, -20, -2);
    if (run === 'r5') {
      place(R.lSero, P(700, 470), popS(t, T.seroW) * (1 + .15 * pulse(t, T.calm, .3)), 1 - cordMix, 0, 0, -3);
      place(R.lP, P(300, 900), 1 - eio((t - T.calm) / .3), painUp > .02 ? 1 : 0, 0, 0, -4);
    }
    // cord + cycle
    R.cordG.setAttribute('opacity', f3(cordMix));
    if (run === 'r5' && cordMix > 0) renderCord(t, cordMix);
    else { R.cordG.setAttribute('opacity', 0); R.cycleG.setAttribute('opacity', 0); }
  }
  function renderCord(t, mix) {
    const s = track([[T.sero2, .35], [T.sero2 + .12, 1.0], [T.strong, 1.12], [T.cycle, .42]], t, 10, .8);
    const cx = 540 + 4 * Math.sin(t * .8), cy = track([[T.sero2, 760], [T.cycle, 740]], t, 7, .85) + 4 * Math.cos(t * .7);
    R.cordG.setAttribute('transform', `translate(${f1(cx)} ${f1(cy)}) scale(${f3(s)}) rotate(${f1(2 * Math.sin(t * .5))})`);
    const Lp = (x, y) => [cx + x * s, cy + y * s];
    // serotonin particles from the top, docking on receptors
    R.seroC.forEach((p, i) => {
      const fall = ((p.ph + (t - T.sero2) * .45) % 1); let x = p.x0 * (1 - fall * .6), y = -420 + fall * 620;
      const dock = eio((t - T.push - p.lag) / .55);
      if (i < 14) { const r = R.rec[p.k]; x = lerp(x, r.x, dock); y = lerp(y, r.y, dock); }
      p.e.setAttribute('cx', f1(x)); p.e.setAttribute('cy', f1(y)); p.e.setAttribute('opacity', f3(mix * (i < 14 ? 1 : 1 - dock * .7)));
    });
    const boost = clamp((t - T.strong) / .08), base = clamp((t - T.sero2W) / .3) * .45;
    const lvl = Math.min(1, base + boost * .55 + .25 * clamp((t - T.push - .4) / .5));
    setNerve(R.fiber, t, .5 + .3 * boost, 700, 220, 70);
    setNerve(R.axon, t, lvl, 700 + 900 * boost, 220 - 120 * boost, 80 + 60 * boost);
    const ns = 1 + .8 * boost * Math.exp(-(t - T.strong) / .5) + .25 * boost + .06 * Math.sin(t * 12);
    R.neu.setAttribute('r', f1(26 * ns)); R.neuHalo.setAttribute('r', f1(70 * (1 + boost))); R.neuHalo.setAttribute('opacity', f3(.4 + .6 * boost));
    R.neuRings.forEach((r, i) => { const ph = ((((t - T.strong) * 1.6 + i / 3) % 1) + 1) % 1; const on = boost * (t > T.strong ? 1 : 0);
      r.setAttribute('r', f1(30 + 220 * ph)); r.setAttribute('opacity', f3(on * (1 - ph) * .9)); });
    const cyc = clamp((t - T.cycle) / .25);
    place(R.lSero2, Lp(270, -150), popS(t, T.sero2W) * (1 - cyc), mix * (1 - cyc), 0, 0, -3);
    place(R.lNeu, Lp(-60, -330), popS(t, T.itchW2 - .3) * (1 + .3 * pulse(t, T.strong, .3)) * (1 - cyc), mix * (1 - cyc), 0, 0, 2);
    // cycle
    R.cycleG.setAttribute('opacity', f3(cyc * mix));
    if (cyc > 0) {
      const u = Math.max(0, t - T.cycle), rs = popS(t, T.cycle);
      const th = -Math.PI / 2 + 2 * Math.PI * (.45 * u + .42 * u * u);
      R.cycleG.setAttribute('transform', `translate(540 ${f1(cy)}) scale(${f3(.6 + .4 * rs)})`);
      R.ring.setAttribute('transform', `rotate(${f1(th * 180 / Math.PI * .5)})`);
      R.comet.setAttribute('cx', f1(330 * Math.cos(th))); R.comet.setAttribute('cy', f1(330 * Math.sin(th)));
      R.comet2.setAttribute('cx', f1(330 * Math.cos(th - .22))); R.comet2.setAttribute('cy', f1(330 * Math.sin(th - .22)));
      R.arrows.forEach((a, i) => { const ang = -Math.PI / 4 + i * Math.PI / 2; a.setAttribute('transform', `translate(${f1(330 * Math.cos(ang))} ${f1(330 * Math.sin(ang))}) rotate(${f1(ang * 180 / Math.PI + 90)})`); });
      const nodeAng = [-Math.PI / 2, 0, Math.PI / 2, Math.PI];
      R.nodes.forEach((n, i) => { const ang = nodeAng[i]; const d = ((th - ang) % (2 * Math.PI) + 2 * Math.PI) % (2 * Math.PI);
        const hit = Math.exp(-d / .5) * (u > .05 ? 1 : 0); const k = i === 0 ? pulse(t, T.itchW3, .4) * .35 : 0;
        const r = 330 * (.6 + .4 * rs), xy = [540 + r * Math.cos(ang), cy + r * Math.sin(ang)];
        place(n, xy, popS(t, T.cycle + i * .08) * (1 + .22 * hit + k), cyc * mix, 0, 0, 0); });
    }
  }

  /* ------------------------------------------------------------------ layer transitions (match the template) */
  function layerState(t, a, b, SC) {
    const si = SC.findIndex(s => Math.abs(s.a - a) < 1e-3), first = SC[si];
    const nx = SC.find(s => Math.abs(s.a - b) < 1e-3);
    if (t < a) return null;
    let o = 1, ty = 0, clip = 0, sc = 1;
    const u = t - a;
    if (first.k === 'slide') ty = 1920 * (1 - eo(u / 0.16)); else if (first.k === 'match') o = eio(u / 0.1);
    else if (first.k === 'whip') { /* not used by this look */ }
    if (nx && t >= b) {
      const v = t - b;
      if (nx.k === 'slide') { if (v >= 0.16) return null; ty = -480 * eo(v / 0.16); clip = 1920 - 1920 * (1 - eo(v / 0.16)); }
      else { if (v >= 0.12) return null; o *= 1 - eio(v / 0.1); }
    }
    return { o, ty, clip, sc };
  }

  function render(t, SC) {
    if (!built) build();
    let run = null; for (const r of RUNS) { if (t >= r.a && t < r.b + 0.17) { run = r; break; } }
    hideLabs();
    const st = run && layerState(t, run.a, run.b, SC);
    if (!st) { R.wrap.style.opacity = '0'; }
    else {
      R.wrap.style.opacity = f3(st.o);
      R.wrap.style.clipPath = st.clip > 0 ? `inset(0 0 ${f1(st.clip)}px 0)` : 'none';
      R.inner.style.transform = `translateY(${f1(st.ty)}px)`;
      const skin = run.scene === 'skin';
      R.skinCam.setAttribute('opacity', skin ? 1 : 0); R.bodyCam.setAttribute('opacity', skin ? 0 : 1);
      if (skin) { R.cordG.setAttribute('opacity', 0); R.cycleG.setAttribute('opacity', 0); renderSkin(t, run.id); }
      else renderBody(t, run.id);
    }
    // "ในหนู" chip: visible through mouse -> cycle (18.32 - 29.14)
    const chip = R.mouseChip, ca = T.mouse, cb = T.end;
    const cs = layerState(t, ca, cb, SC);
    if (!cs || t < ca) chip.style.opacity = '0';
    else {
      const p = popS(t, ca + .06), mv = eio((t - T.sero) / .35);
      const x = lerp(540, 200, mv), y = lerp(560, 250, mv), sc = lerp(1, .62, mv) * p;
      chip.style.opacity = f3(cs.o * clamp((t - ca - .06) / .05));
      chip.style.clipPath = cs.clip > 0 ? `inset(0 0 ${f1(Math.max(0, cs.clip - (1920 - 1920)))}px 0)` : 'none';
      chip.style.transform = `translate(${f1(x)}px,${f1(y + cs.ty + 3 * Math.sin(t * 2))}px) translate(-50%,-50%) rotate(-3deg) scale(${f3(sc)})`;
    }
  }

  /* ------------------------------------------------------------------ footage overlays: follow grid, nail sparks, cta question */
  // spark keys [t, x, y] = where the nails dig in on the plate (picked from the rendered plate frames)
  const SPARK = { hook: { a: 1.30, b: 2.14, keys: [[1.30, 745, 985], [1.60, 745, 966], [1.90, 741, 830], [2.14, 738, 800]] },
                  scr: { a: 13.30, b: 14.90, keys: [[13.30, 760, 600], [13.50, 760, 594], [14.20, 960, 860], [14.90, 960, 860]] } };
  function sparkAt(t, sp) { const k = sp.keys; let i = 0; while (i < k.length - 2 && t > k[i + 1][0]) i++;
    const u = clamp((t - k[i][0]) / Math.max(.01, k[i + 1][0] - k[i][0])); return [lerp(k[i][1], k[i + 1][1], u), lerp(k[i][2], k[i + 1][2], u)]; }
  function extras(t, SC) {
    // follow: 3 people, the itch jumps panel to panel on "หลายคน ... คันตาม"
    const fo = document.getElementById('follow'), a = 32.579, b = 34.64, st = layerState(t, a, b, SC);
    if (!st) fo.style.opacity = '0';
    else {
      fo.style.opacity = f3(st.o); fo.style.transform = `translateY(${f1(st.ty)}px)`;
      fo.style.clipPath = st.clip > 0 ? `inset(0 0 ${f1(st.clip)}px 0)` : 'none';
      [32.66, 32.98, 33.28].forEach((at, i) => { const p = document.getElementById('fp-' + (i + 1)); const s = t < at ? 0 : S(t - at, 15, .55);
        const kb = 1 + .05 * clamp((t - at) / 2);
        p.style.opacity = f3(clamp((t - at) / .06)); p.style.transform = `translateX(${f1((i % 2 ? 1 : -1) * 140 * (1 - s))}px) scale(${f3(.86 + .14 * s)}) rotate(${f1((i - 1) * 1.2)}deg)`;
        const m = p.firstElementChild; m.style.transform = `scale(${f3(kb)})`; });
      [['zap1', 32.9], ['zap2', 33.2]].forEach(([id, at]) => { const z = document.getElementById(id); const u = t - at;
        z.setAttribute('opacity', f3(u < 0 ? 0 : Math.exp(-u / .35))); z.setAttribute('stroke-width', f1(6 + 10 * Math.exp(-Math.max(0, u) / .2))); });
    }
    // nail sparks (hook: red flash under the nails before "เจ็บ"; scratch2: "ผิวจะเจ็บนิดๆ")
    const sp = document.getElementById('spark'), rays = document.getElementById('spark-rays');
    let on = null; if (t >= SPARK.hook.a && t < SPARK.hook.b) on = SPARK.hook; else if (t >= SPARK.scr.a && t < SPARK.scr.b) on = SPARK.scr;
    if (!on) sp.setAttribute('opacity', 0);
    else { const xy = sparkAt(t, on), u = t - on.a, fl = .55 + .45 * Math.abs(Math.sin(t * 17)), inn = clamp(u / .12) * (1 - clamp((t - on.b + .1) / .1));
      sp.setAttribute('opacity', f3(inn * fl)); sp.setAttribute('transform', `translate(${f1(xy[0])} ${f1(xy[1])}) scale(${f3(.8 + .35 * fl)})`);
      rays.setAttribute('transform', `rotate(${f1(t * 140)})`); }
    // cta question
    const q = document.getElementById('ctaq'), qs = layerState(t, 34.64, 36.12, SC);
    if (!qs) q.style.opacity = '0';
    else { const p = popS(t, 34.72); q.style.opacity = f3(qs.o * clamp((t - 34.72) / .05));
      q.style.transform = `translate(-50%,${f1(qs.ty + 4 * Math.sin(t * 3))}px) rotate(-3deg) scale(${f3(p * (1 + .03 * Math.sin(t * 5)))})`; }
  }
  return { render, extras, T };
})();
