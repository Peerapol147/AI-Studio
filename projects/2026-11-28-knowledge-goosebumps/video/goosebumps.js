/* goosebumps episode graphics. Pure function of t (seek-safe): GB.render(t, SC) is called every frame from
   episode(t) in index.html, after the template has placed the scenes.
   - #ov-skin: ONE glowing skin cross-section (3 layers, follicles, hairs, arrector pili, nerve) that keeps its state
     across the shots dive -> muscle -> pop -> twist -> regrow -> newhair (spring tracks keyed on words).
   - per-shot overlays (.ovh data-host="<shot ids>") follow their host scene's opacity / whip / z-order (and the
     still's push when data-kb is set): cat aura, human scan, nope (cat vs human puff), ancestor (ape -> human),
     brain (dopamine), music waves, cta chip.
   Colours: only the look's CSS variables (+ the episode mixes defined in EPISODE CSS). Times = shots-th.json
   start / hit_at and words.json word starts (see T). */
window.GB = (function () {
  const NS = 'http://www.w3.org/2000/svg';
  const clamp = (x, a = 0, b = 1) => Math.min(b, Math.max(a, x)), lerp = (a, b, u) => a + (b - a) * u;
  const eo = x => { x = clamp(x); return 1 - Math.pow(1 - x, 3); }, eio = x => { x = clamp(x); return x * x * (3 - 2 * x); };
  const S = (tau, w, z) => { if (tau <= 0) return 0; if (z < 1) { const wd = w * Math.sqrt(1 - z * z);
    return 1 - Math.exp(-z * w * tau) * (Math.cos(wd * tau) + z * w / wd * Math.sin(wd * tau)); } return 1 - Math.exp(-w * tau) * (1 + w * tau); };
  function track(keys, t, w = 7, z = 0.82) {   // spring keyframes [[t, v | [v..], w?, z?], ...]
    const v0 = keys[0][1]; const arr = Array.isArray(v0); let v = arr ? v0.slice() : v0;
    for (let k = 1; k < keys.length; k++) { const s = S(t - keys[k][0], keys[k][2] || w, keys[k][3] || z), p = keys[k - 1][1], q = keys[k][1];
      if (arr) for (let i = 0; i < v.length; i++) v[i] += (q[i] - p[i]) * s; else v += (q - p) * s; }
    return v;
  }
  const pulse = (t, at, d = 0.5) => (t < at ? 0 : Math.exp(-(t - at) / d));
  const win = (t, a, b, f = 0.15) => clamp((t - a) / f) * (1 - clamp((t - b) / f));
  function rng(seed) { return () => { seed = (seed * 1664525 + 1013904223) >>> 0; return seed / 4294967296; }; }
  function el(tag, at, parent) { const e = document.createElementNS(NS, tag); for (const k in at) e.setAttribute(k, at[k]); if (parent) parent.appendChild(e); return e; }
  const f1 = v => (+v).toFixed(1), f3 = v => (+v).toFixed(3);
  const $ = id => document.getElementById(id);

  const T = {
    pong: 3.0, big: 4.46, dive: 5.9, muscle: 7.58, muscleW: 7.66, cold: 9.34, pop: 10.74, popW: 10.82, shrink: 11.12,
    stand: 12.52, popEnd: 13.7, few: 14.44, nope: 15.84, barely: 15.92, fail: 16.42, ape: 17.44, anc: 19.1, trace: 19.18,
    ancestor: 19.92, twist: 20.64, useless: 21.14, mouse: 23.14, harvard: 23.46, inmice: 24.16, regrow: 25.02, sys: 25.1,
    wake: 25.78, newhair: 26.58, newW: 27.14, cold2: 27.56, music: 28.78, research: 30.56, brain: 31.96, brainW: 32.04,
    release: 32.34, dopa: 32.56, cta: 35.76, ctaGoose: 36.28
  };
  const R = {}; let built = false;

  /* ------------------------------------------------------------ shared defs */
  function defs(svg) {
    const d = el('defs', {}, svg);
    const lg = (id, stops, x2 = 0, y2 = 1) => { const g = el('linearGradient', { id, x1: 0, y1: 0, x2, y2 }, d);
      stops.forEach(([o, c, a]) => el('stop', { offset: o, style: `stop-color:${c};stop-opacity:${a == null ? 1 : a}` }, g)); };
    const rg = (id, stops, cx = .5, cy = .5, r = .5) => { const g = el('radialGradient', { id, cx, cy, r }, d);
      stops.forEach(([o, c, a]) => el('stop', { offset: o, style: `stop-color:${c};stop-opacity:${a == null ? 1 : a}` }, g)); };
    lg('gAir', [[0, 'var(--bg)'], [.8, 'var(--bg)'], [1, 'var(--bg2)', .55]]);
    lg('gEpi', [[0, 'var(--skinhi)'], [.3, 'var(--skin)'], [1, 'var(--skinlo)']]);
    lg('gDerm', [[0, 'var(--skinlo)'], [.5, 'var(--bg2)', .55], [1, 'var(--bg)']]);
    lg('gHypo', [[0, 'var(--bg)'], [1, 'var(--skinlo)', .8]]);
    lg('gSheath', [[0, 'var(--skin)', .9], [.5, 'var(--skinhi)', .55], [1, 'var(--skin)', .9]], 1, 0);
    lg('gMus', [[0, 'var(--muscle)'], [.5, 'var(--accent2)'], [1, 'var(--muscle)']], 0, 1);
    rg('gFat', [[0, 'var(--accent)', .38], [.75, 'var(--accent2)', .22], [1, 'var(--skinhi)', .6]], .42, .38, .6);
    rg('gPap', [[0, '#fff', .9], [.4, 'var(--accent2)', .95], [1, 'var(--muscle)', .9]], .45, .4, .6);
    rg('gBok', [[0, 'var(--accent2)', .55], [1, 'var(--accent2)', 0]]);
    rg('gBokY', [[0, 'var(--accent)', .5], [1, 'var(--accent)', 0]]);
    rg('gDot', [[0, '#fff', 1], [.35, 'var(--accent)', 1], [1, 'var(--accent)', 0]]);
    rg('gDotP', [[0, '#fff', 1], [.35, 'var(--accent2)', 1], [1, 'var(--accent2)', 0]]);
    rg('gGland', [[0, 'var(--accent)', .35], [1, 'var(--skin)', .75]], .4, .4, .6);
    rg('gBrain', [[0, 'var(--accent2)', .55], [.7, 'var(--bg2)', .4], [1, 'var(--bg)', .2]], .45, .45, .6);
    const flt = (id, sd, k = 1) => { const f = el('filter', { id, x: '-60%', y: '-60%', width: '220%', height: '220%' }, d);
      el('feGaussianBlur', { in: 'SourceGraphic', stdDeviation: sd, result: 'b' }, f);
      const m = el('feMerge', {}, f); for (let i = 0; i < k; i++) el('feMergeNode', { in: 'b' }, m); el('feMergeNode', { in: 'SourceGraphic' }, m); };
    flt('glow', 5, 2); flt('glowL', 14, 2);
    const b = (id, sd) => { const f = el('filter', { id, x: '-30%', y: '-30%', width: '160%', height: '160%' }, d); el('feGaussianBlur', { stdDeviation: sd }, f); };
    b('blur3', 3); b('blur8', 8); b('blur16', 16);
  }

  /* ------------------------------------------------------------ skin cross-section (world 1080 x 1920) */
  const SURF = 720;
  const surfBase = x => SURF + 10 * Math.sin(x / 95) + 4 * Math.sin(x / 33 + 1);
  const juncY = x => SURF + 96 + 22 * Math.sin(x / 48) + 7 * Math.sin(x / 21);
  // follicles: o = opening x, k = size, dorm = dormant (short, no hair above until "ขนใหม่")
  const FOL = [
    { id: 'L', ox: 150, k: 0.8, back: true },
    { id: 'H', ox: 480, k: 1.1 },
    { id: 'D', ox: 850, k: 0.9, dorm: true }];
  const NERVE = 'M1180 1700 C1040 1560 990 1420 960 1250 C940 1120 930 1010 900 950 C880 925 860 920 840 925';
  const NERVE_H = 'M960 1250 C880 1120 760 1000 660 950 C620 930 590 920 560 915';

  function buildSkin(svg) {
    const cam = el('g', {}, svg); R.cam = cam;
    el('rect', { x: -900, y: -900, width: 2900, height: 1640, fill: 'url(#gAir)' }, cam);
    const far = el('g', { filter: 'url(#blur16)' }, cam); R.airBok = []; const r0 = rng(17);
    for (let i = 0; i < 16; i++) R.airBok.push({ e: el('circle', { r: 18 + r0() * 46, fill: r0() < .5 ? 'url(#gBok)' : 'url(#gBokY)', opacity: .7 }, far), x: -300 + r0() * 1700, y: -200 + r0() * 820, ph: r0() * 6 });
    // hypodermis (fat lobules) + dermis
    el('rect', { x: -900, y: 1330, width: 2900, height: 1400, fill: 'url(#gHypo)' }, cam);
    let p = ''; for (let x = -900; x <= 2000; x += 20) p += (p ? 'L' : 'M') + x + ' ' + f1(1330 + 18 * Math.sin(x / 70));
    el('path', { d: p + ' L2000 740 L-900 740 Z', fill: 'url(#gDerm)' }, cam);
    const fat = el('g', {}, cam); const rf = rng(5);
    for (let row = 0; row < 5; row++) for (let x = -700 + (row % 2) * 70; x < 1800; x += 140) {
      const y = 1420 + row * 120 + (rf() - .5) * 20;
      el('ellipse', { cx: f1(x + (rf() - .5) * 30), cy: f1(y), rx: f1(60 + rf() * 12), ry: f1(50 + rf() * 10), fill: 'url(#gFat)', stroke: 'var(--skinhi)', 'stroke-width': 3, opacity: .55 }, fat);
    }
    // collagen fibres (blurred, depth)
    const fib = el('g', { filter: 'url(#blur3)', opacity: .5 }, cam); const r1 = rng(11);
    for (let i = 0; i < 40; i++) { const y = 860 + r1() * 480, x = -600 + r1() * 2200, L = 160 + r1() * 240, a = (r1() - .5) * .5;
      el('path', { d: `M${f1(x)} ${f1(y)} c${f1(L * .3)} ${f1(-26 + a * 60)} ${f1(L * .6)} ${f1(26 + a * 80)} ${f1(L)} ${f1(a * L)}`, fill: 'none', stroke: i % 3 ? 'var(--skinhi)' : 'var(--accent2)', 'stroke-width': 3 + r1() * 4, opacity: .14 + r1() * .18, 'stroke-linecap': 'round' }, fib); }
    // capillary loop
    el('path', { d: 'M-600 1250 C-300 1200 -100 1290 150 1240 C400 1190 600 1290 900 1230 C1200 1170 1500 1260 1800 1220', fill: 'none', stroke: 'var(--muscle)', 'stroke-width': 18, opacity: .55, 'stroke-linecap': 'round' }, cam);
    el('path', { d: 'M-600 1250 C-300 1200 -100 1290 150 1240 C400 1190 600 1290 900 1230 C1200 1170 1500 1260 1800 1220', fill: 'none', stroke: 'var(--accent2)', 'stroke-width': 5, opacity: .5 }, cam);
    // nerve (base + lit + pulses)
    const ng = el('g', {}, cam);
    R.nerve = [NERVE, NERVE_H].map(d => {
      const base = el('path', { d, fill: 'none', stroke: 'var(--accent)', 'stroke-width': 6, opacity: .22, 'stroke-linecap': 'round' }, ng);
      const lit = el('path', { d, fill: 'none', stroke: 'var(--accent)', 'stroke-width': 8, opacity: 0, filter: 'url(#glow)', 'stroke-linecap': 'round' }, ng);
      const dots = [0, 1, 2].map(() => el('circle', { r: 16, fill: 'url(#gDot)', opacity: 0 }, ng));
      return { base, lit, dots, len: base.getTotalLength() };
    });
    // follicles
    R.fol = FOL.map(f => buildFollicle(cam, f));
    // epidermis (rebuilt per frame: bumps) + surface rim
    R.epi = el('path', { d: '', fill: 'url(#gEpi)' }, cam);
    R.cells = el('g', { opacity: .75 }, cam); const r2 = rng(3); R.cellList = [];
    for (let x = -560; x < 1640; x += 40) for (let k = 0; k < 4; k++) {
      const xx = x + (k % 2) * 20 + (r2() - .5) * 8; const fr = (k + .6) / 4.4;
      R.cellList.push({ x: xx, fr, e: el('ellipse', { cx: f1(xx), cy: 0, rx: f1(16 + (1 - fr) * 6), ry: f1(9 + fr * 4), fill: 'var(--skinhi)', opacity: f3(.14 + r2() * .16) }, R.cells) });
    }
    R.rim = el('path', { d: '', fill: 'none', stroke: '#fff', 'stroke-width': 5, opacity: .8, filter: 'url(#glow)' }, cam);
    R.rim2 = el('path', { d: '', fill: 'none', stroke: 'var(--accent2)', 'stroke-width': 3, opacity: .6 }, cam);
    R.junc = el('path', { d: '', fill: 'none', stroke: 'var(--accent2)', 'stroke-width': 4, opacity: .45, filter: 'url(#glow)' }, cam);
    // muscles + hairs above the surface drawn after the epidermis (in front)
    R.fol.forEach(F => { cam.appendChild(F.mus); cam.appendChild(F.musGlow); cam.appendChild(F.musLine); cam.appendChild(F.top); });
    // snow (air) + new-hair sparkle
    R.snow = []; const r3 = rng(91); const sg = el('g', {}, cam);
    for (let i = 0; i < 34; i++) { const g = el('g', { opacity: 0 }, sg); const s = 7 + r3() * 9;
      for (let a = 0; a < 3; a++) el('line', { x1: -s, y1: 0, x2: s, y2: 0, stroke: '#fff', 'stroke-width': 2.6, 'stroke-linecap': 'round', transform: `rotate(${a * 60})` }, g);
      el('circle', { r: s * .45, fill: 'url(#gDot)' }, g);
      R.snow.push({ g, x: -100 + r3() * 1300, y0: -300 + r3() * 500, sp: 70 + r3() * 90, ph: r3() * 6, w: .5 + r3() }); }
    R.spark = el('g', { opacity: 0 }, cam);
    el('circle', { r: 60, fill: 'url(#gBokY)' }, R.spark);
    for (let i = 0; i < 8; i++) el('line', { x1: 0, y1: -26, x2: 0, y2: -70, stroke: 'var(--accent)', 'stroke-width': 6, 'stroke-linecap': 'round', transform: `rotate(${i * 45})`, filter: 'url(#glow)' }, R.spark);
    // near bokeh in front (depth)
    const near = el('g', { filter: 'url(#blur8)' }, cam); R.nearBok = []; const r4 = rng(29);
    for (let i = 0; i < 18; i++) R.nearBok.push({ e: el('circle', { r: 6 + r4() * 16, fill: i % 3 ? 'url(#gBok)' : 'url(#gBokY)', opacity: .65 }, near), x: -300 + r4() * 1700, y: 800 + r4() * 900, ph: r4() * 6 });
    R.surfPts = null;
  }

  function buildFollicle(cam, f) {
    const g = el('g', f.back ? { filter: 'url(#blur3)', opacity: .7 } : {}, cam);
    const body = el('g', {}, g);            // scaled along the follicle (dormant grows)
    el('path', { d: 'M-30 0 C-32 120 -34 260 -38 340 C-66 360 -70 430 0 442 C70 430 66 360 38 340 C34 260 32 120 30 0 Z', fill: 'url(#gSheath)', stroke: 'var(--accent2)', 'stroke-width': 3, opacity: .95 }, body);
    el('path', { d: 'M-16 0 L-18 340 M16 0 L18 340', stroke: 'var(--skinhi)', 'stroke-width': 2, opacity: .5, fill: 'none' }, body);
    const pap = el('ellipse', { cx: 0, cy: 412, rx: 24, ry: 20, fill: 'url(#gPap)' }, body);
    const papGlow = el('circle', { cx: 0, cy: 405, r: 70, fill: 'url(#gBokY)', opacity: 0 }, body);
    const inHair = el('line', { x1: 0, y1: 4, x2: 0, y2: 398, stroke: 'var(--hair)', 'stroke-width': 11, 'stroke-linecap': 'round' }, body);
    // sebaceous gland
    const gl = el('g', { opacity: .9 }, g);
    [[44, 70, 22], [62, 96, 20], [40, 104, 18], [66, 66, 14]].forEach(([x, y, r]) => el('circle', { cx: x, cy: y, r, fill: 'url(#gGland)', stroke: 'var(--skinhi)', 'stroke-width': 2, opacity: .8 }, gl));
    // stem cells at the bulge (muscle insertion)
    const stem = []; const rs = rng(f.ox);
    for (let i = 0; i < 7; i++) stem.push(el('circle', { cx: f1(26 + rs() * 16), cy: f1(220 + (rs() - .5) * 50), r: f1(6 + rs() * 4), fill: 'url(#gDot)', opacity: .25 }, g));
    const stemGlow = el('circle', { cx: 32, cy: 220, r: 100, fill: 'url(#gBokY)', opacity: 0 }, g);
    // hair above the surface
    const top = el('g', f.back ? { filter: 'url(#blur3)', opacity: .75 } : {});
    const shaftGlow = el('path', { d: '', fill: 'none', stroke: 'var(--accent2)', 'stroke-width': 26, opacity: .35, filter: 'url(#blur8)', 'stroke-linecap': 'round' }, top);
    const shaft = el('path', { d: '', fill: 'none', stroke: 'var(--hair)', 'stroke-width': 12, 'stroke-linecap': 'round' }, top);
    const shaftHi = el('path', { d: '', fill: 'none', stroke: '#fff', 'stroke-width': 3.5, opacity: .7, 'stroke-linecap': 'round' }, top);
    const mus = el('path', { d: '', fill: 'url(#gMus)', stroke: 'var(--accent2)', 'stroke-width': 2.5 });
    const musGlow = el('path', { d: '', fill: 'var(--accent)', opacity: 0, filter: 'url(#glowL)' });
    const musLine = el('path', { d: '', fill: 'none', stroke: '#fff', 'stroke-width': 2, opacity: .35 });
    if (f.back) { mus.setAttribute('filter', 'url(#blur3)'); mus.setAttribute('opacity', '.7'); musLine.setAttribute('opacity', '0'); }
    return { f, g, body, pap, papGlow, inHair, gl, stem, stemGlow, top, shaft, shaftGlow, shaftHi, mus, musGlow, musLine };
  }

  // rotate local (x,y) by th (deg, clockwise in SVG) and scale k
  const rot = (x, y, th, k) => { const a = th * Math.PI / 180, c = Math.cos(a), s = Math.sin(a); return [k * (x * c - y * s), k * (x * s + y * c)]; };

  function skinState(t) {
    const st = {};
    // erection 0 (relaxed) .. 1 (standing): partial at "หดตัว", snap at "ตั้ง", relax during the twist
    st.erect = track([[0, 0], [T.shrink, 0.32, 5, .9], [T.stand, 1.0, 15, .32], [T.useless + .3, 0.0, 3.2, .95], [T.wake, 0.35, 6, .6], [T.newW, 0.55, 9, .5]], t);
    st.erectL = track([[0, 0], [T.shrink + .08, 0.3, 5, .9], [T.stand + .07, 1.0, 14, .35], [T.useless + .4, 0, 3, .95], [T.wake, 0.3, 6, .6]], t);
    st.musHi = clamp(win(t, T.muscleW, T.popEnd + .1, .2) * 0.8 + pulse(t, T.shrink, .5) * .4 + pulse(t, T.stand, .5) * .6 + win(t, T.sys, T.music, .3) * .5);
    st.nerve = clamp(pulse(t, T.popW, .7) * .9 + win(t, T.sys, T.music, .2) * .9);
    st.wake = clamp(S(t - T.wake, 9, .5)) * (t < T.music ? 1 : 0);
    st.grow = clamp(S(t - T.newW, 7, .62), 0, 1.15);
    st.hairNew = S(t - (T.newW + .06), 9, .55);
    return st;
  }

  function renderSkin(t) {
    const st = skinState(t);
    // camera: world focus (cx, cy) -> screen (540, 900), scale, roll
    const cam = track([[0, [470, 720, 1.9, 0]], [T.dive, [470, 720, 1.9, 0]], [T.dive + .35, [520, 860, 1.22, 0], 6, .9],
      [T.muscleW, [540, 900, 1.75, -2], 6, .85], [T.cold, [540, 900, 1.75, -2], 6], [T.pop, [530, 900, 1.6, 1.5], 9, .85], [T.stand - .05, [540, 780, 1.3, 0], 7, .7],
      [T.popEnd, [540, 860, 1.2, 0], 4], [T.twist, [540, 860, 1.25, -16], 30], [T.twist + .05, [560, 860, 1.32, 0], 6, .45], [T.useless, [620, 860, 1.2, 0], 3],
      [T.mouse, [620, 860, 1.2, 0]], [T.regrow, [780, 940, 1.5, 0], 30], [T.regrow + .05, [800, 960, 1.7, 0], 3.5, .9],
      [T.newhair, [820, 1000, 1.9, 0], 30], [T.newhair + .05, [830, 960, 1.8, 0], 4, .9], [T.newW, [850, 700, 1.3, 0], 4.5, .85]], t);
    const [cx, cy, sc, rl] = cam;
    const dx = 10 * Math.sin(t * .9), dy = 7 * Math.cos(t * .7), rr = rl + .6 * Math.sin(t * .5);
    R.cam.setAttribute('transform', `translate(${f1(540 + dx)} ${f1(900 + dy)}) rotate(${f3(rr)}) scale(${f3(sc)}) translate(${f1(-cx)} ${f1(-cy)})`);
    R.camM = { cx, cy, sc, rr, dx, dy };
    // follicle geometry + goose bumps
    const bumps = [];
    R.fol.forEach(F => {
      const f = F.f; const e = f.id === 'L' ? st.erectL : st.erect;
      const th = lerp(f.dorm ? 26 : 34, 6, e) + (f.id === 'H' ? 1.6 * Math.sin(t * 2.1) : 1.2 * Math.sin(t * 1.7 + f.ox));
      const len = f.dorm ? lerp(0.45, 1.0, st.grow) : 1;
      const lift = 30 * e * f.k;
      const ox = f.ox, oy = surfBase(ox) - lift;
      bumps.push({ x: ox + 40 * f.k, a: lift, w: 75 * f.k });
      F.g.setAttribute('transform', `translate(${f1(ox)} ${f1(oy)}) rotate(${f3(th)}) scale(${f3(f.k)})`);
      F.body.setAttribute('transform', `scale(1 ${f3(len)})`);
      // muscle: bulge (on the follicle) -> anchor (upper dermis, under the slant)
      const B = rot(30, 230 * len, th, f.k); const bx = ox + B[0], by = oy + B[1];
      const ax = ox + 175 * f.k, ay = juncY(ox + 175 * f.k) + 22;
      const L = Math.hypot(ax - bx, ay - by), ux = (ax - bx) / L, uy = (ay - by) / L, nx = -uy, ny = ux;
      const W = f.k * (13 + 13 * e) * (1 + .06 * Math.sin(t * 9) * e);
      let up = '', dn = '';
      for (let i = 0; i <= 16; i++) { const s = i / 16, w = W * Math.pow(Math.sin(Math.PI * s), .7) + 2;
        const px = bx + ux * L * s, py = by + uy * L * s; up += (i ? 'L' : 'M') + f1(px + nx * w) + ' ' + f1(py + ny * w); dn = 'L' + f1(px - nx * w) + ' ' + f1(py - ny * w) + dn; }
      const d = up + dn + 'Z';
      F.mus.setAttribute('d', d); F.musGlow.setAttribute('d', d);
      let ln = ''; for (let j = -1; j <= 1; j++) ln += `M${f1(bx + ux * 12 + nx * W * .4 * j)} ${f1(by + uy * 12 + ny * W * .4 * j)} L${f1(ax - ux * 12 + nx * W * .4 * j)} ${f1(ay - uy * 12 + ny * W * .4 * j)} `;
      F.musLine.setAttribute('d', ln);
      F.musGlow.setAttribute('opacity', f3(f.back ? st.musHi * .3 : st.musHi * (f.dorm ? .55 : .75)));
      F.mid = [(ax + bx) / 2, (ay + by) / 2];
      // hair above the surface
      let H = f.dorm ? 330 * st.hairNew : (f.id === 'H' ? 360 : 300);
      const tipX = Math.sin(th * Math.PI / 180), tipY = -Math.cos(th * Math.PI / 180);
      const bend = (1 - e) * 26 + 6 * Math.sin(t * 1.3 + f.ox);
      if (H > 2) {
        const hx = ox + tipX * H * f.k, hy = oy + tipY * H * f.k;
        const mx = ox + tipX * H * f.k * .5 + bend * .6, my = oy + tipY * H * f.k * .5 + bend * .3;
        const dd = `M${f1(ox)} ${f1(oy)} Q${f1(mx)} ${f1(my)} ${f1(hx)} ${f1(hy)}`;
        F.shaft.setAttribute('d', dd); F.shaftGlow.setAttribute('d', dd); F.shaftHi.setAttribute('d', dd);
        F.tip = [hx, hy];
      } else { F.shaft.setAttribute('d', ''); F.shaftGlow.setAttribute('d', ''); F.shaftHi.setAttribute('d', ''); F.tip = [ox, oy]; }
      F.shaftGlow.setAttribute('opacity', f3(.3 + .5 * pulse(t, T.stand, .6) * (f.dorm ? 0 : 1) + (f.dorm ? .6 * pulse(t, T.newW + .1, .9) : 0)));
      F.inHair.setAttribute('opacity', f.dorm ? f3(.25 + .75 * st.grow) : '1');
      // stem cells / root
      const wake = f.dorm ? st.wake : (f.id === 'H' ? st.wake * .35 : 0);
      F.stem.forEach((c, i) => c.setAttribute('opacity', f3(.22 + .78 * wake * (.6 + .4 * Math.sin(t * 6 + i)))));
      F.stemGlow.setAttribute('opacity', f3(wake * (.7 + .3 * Math.sin(t * 5)) + (f.dorm ? .5 * pulse(t, T.wake, .4) : 0)));
      F.papGlow.setAttribute('opacity', f3(f.dorm ? clamp(.8 * st.grow + .6 * pulse(t, T.newW, .5)) : 0));
      F.B = [bx, by];
    });
    // surface with goose bumps
    const surf = x => { let y = surfBase(x); bumps.forEach(b => { y -= b.a * Math.exp(-Math.pow((x - b.x) / b.w, 2)); }); return y; };
    let sp = '', jp = '', poly = [];
    for (let x = -900; x <= 2000; x += 16) { const y = surf(x); sp += (sp ? 'L' : 'M') + f1(x) + ' ' + f1(y); poly.push([x, y]); }
    for (let x = 2000; x >= -900; x -= 16) { const y = juncY(x); jp = (jp ? jp : '') ; poly.push([x, y]); }
    R.epi.setAttribute('d', 'M' + poly.map(p => f1(p[0]) + ' ' + f1(p[1])).join('L') + 'Z');
    R.rim.setAttribute('d', sp); R.rim2.setAttribute('d', sp.replace(/(\d+\.\d) (\d+\.\d)/g, (m, a, b) => a + ' ' + f1(+b + 10)));
    let jj = ''; for (let x = -900; x <= 2000; x += 16) jj += (jj ? 'L' : 'M') + x + ' ' + f1(juncY(x)); R.junc.setAttribute('d', jj);
    R.cellList.forEach(c => { const top = surf(c.x) + 14, bot = juncY(c.x) - 10; c.e.setAttribute('cy', f1(lerp(top, bot, c.fr))); });
    // nerve signal
    R.nerve.forEach((N, ni) => {
      N.lit.setAttribute('opacity', f3(st.nerve * (ni === 0 ? (t > T.sys ? 1 : .5) : (t > T.sys ? .4 : 1))));
      N.dots.forEach((dot, i) => {
        let u = -1;
        if (t >= T.popW && t < T.popW + .9 && ni === 1) u = (t - T.popW) / .5 - i * .25;
        if (t >= T.sys && t < T.music) u = ((t - T.sys) / .7 + i / 3) % 1;
        if (u < 0 || u > 1) { dot.setAttribute('opacity', 0); return; }
        const p = N.base.getPointAtLength(N.len * u);
        dot.setAttribute('cx', f1(p.x)); dot.setAttribute('cy', f1(p.y)); dot.setAttribute('opacity', f3(Math.sin(Math.PI * u)));
      });
    });
    // bokeh drift
    R.airBok.forEach(b => { b.e.setAttribute('cx', f1(b.x + 30 * Math.sin(t * .4 + b.ph))); b.e.setAttribute('cy', f1(b.y + 22 * Math.cos(t * .5 + b.ph))); });
    R.nearBok.forEach(b => { b.e.setAttribute('cx', f1(b.x + 40 * Math.sin(t * .35 + b.ph))); b.e.setAttribute('cy', f1(b.y - 18 * t % 900 + 30 * Math.cos(t * .6 + b.ph))); });
    // snow from "ตอนหนาว" (and a light flurry while the new hair grows)
    const sn = clamp((t - (T.newW + .1)) / .4) * (t < T.music ? 1 : 0);
    R.snow.forEach(s => { const tt = t - T.newW; const y = s.y0 + s.sp * tt + 260, x = s.x + 30 * Math.sin(tt * s.w + s.ph);
      s.g.setAttribute('transform', `translate(${f1(x)} ${f1(y)}) rotate(${f1(tt * 60 * s.w)})`); s.g.setAttribute('opacity', f3(sn * (y < 690 ? 0.9 : 0))); });
    const D = R.fol[2];
    R.spark.setAttribute('transform', `translate(${f1(D.tip[0])} ${f1(D.tip[1])}) scale(${f3(.6 + 1.2 * (1 - pulse(t, T.newW + .1, .35)))})`);
    R.spark.setAttribute('opacity', f3(t > T.newW ? pulse(t, T.newW + .1, .45) : 0));
    // dive: the real skin card zooms through the camera, cross-section behind
    const du = t - T.dive;
    if (du >= 0 && du < 1.0) {
      const k = 1 + 9 * Math.pow(clamp(du / .7), 2.2);
      R.diveImg.style.opacity = f3(1 - clamp((du - .25) / .35));
      R.diveImg.style.transform = `translate(-50%,-50%) scale(${f3(k)})`;
    } else R.diveImg.style.opacity = '0';
    // labels (screen space)
    const scr = (x, y) => { const a = R.camM.rr * Math.PI / 180, c = Math.cos(a), s = Math.sin(a), X = (x - R.camM.cx) * R.camM.sc, Y = (y - R.camM.cy) * R.camM.sc;
      return [540 + R.camM.dx + X * c - Y * s, 900 + R.camM.dy + X * s + Y * c]; };
    const H = R.fol[1];
    const mp = scr(H.mid[0], H.mid[1]);
    const lab = clamp(S(t - T.muscleW - .05, 14, .55), 0, 1.2) * (t < T.cold ? 1 : 0) + (t >= T.pop && t < T.popEnd ? clamp(S(t - T.pop, 14, .6), 0, 1.2) : 0);
    const lx = mp[0] - 40, ly = 420;
    R.mLab.style.opacity = f3(clamp(lab)); R.mLab.style.transform = `translate(${f1(lx)}px,${f1(ly)}px) translate(-50%,-50%) scale(${f3(lab)})`;
    R.mLead.setAttribute('d', `M${f1(lx)} ${f1(ly + 52)} L${f1(mp[0])} ${f1(mp[1] - 10)}`); R.mLead.setAttribute('opacity', f3(clamp(lab) * .9));
    R.mDot.setAttribute('cx', f1(mp[0])); R.mDot.setAttribute('cy', f1(mp[1])); R.mDot.setAttribute('opacity', f3(clamp(lab)));
    // twist "?"
    const q = t >= T.twist && t < T.mouse ? clamp(S(t - (T.twist + .12), 11, .4), 0, 1.3) : 0;
    const qj = (t < T.useless + .25 && t > T.twist) ? (Math.floor(t * 30) % 3 - 1) * 8 : 0;
    R.q.style.opacity = f3(clamp(q)); R.q.style.transform = `translate(${f1(800 + qj)}px,560px) translate(-50%,-50%) rotate(${f1(14 * Math.sin(t * 3))}deg) scale(${f3(q)})`;
    R.q2.style.opacity = f3(clamp(q) * (qj ? .8 : .0)); R.q2.style.transform = `translate(${f1(800 - qj * 1.6)}px,560px) translate(-50%,-50%) rotate(${f1(14 * Math.sin(t * 3))}deg) scale(${f3(q)})`;
  }

  /* ------------------------------------------------------------ silhouettes (nope / ancestor) */
  function resample(pts, N) {
    const segs = []; let L = 0;
    for (let i = 0; i < pts.length; i++) { const a = pts[i], b = pts[(i + 1) % pts.length]; const l = Math.hypot(b[0] - a[0], b[1] - a[1]); segs.push([a, b, l]); L += l; }
    const out = []; let si = 0, acc = 0;
    for (let k = 0; k < N; k++) { const d = k * L / N; while (acc + segs[si][2] < d) { acc += segs[si][2]; si++; }
      const [a, b, l] = segs[si]; const u = (d - acc) / l; out.push([lerp(a[0], b[0], u), lerp(a[1], b[1], u)]); }
    return out;
  }
  function normals(P) {
    let area = 0; for (let i = 0; i < P.length; i++) { const a = P[i], b = P[(i + 1) % P.length]; area += a[0] * b[1] - b[0] * a[1]; }
    const sg = area > 0 ? -1 : 1;
    return P.map((p, i) => { const a = P[(i - 2 + P.length) % P.length], b = P[(i + 2) % P.length]; const tx = b[0] - a[0], ty = b[1] - a[1], l = Math.hypot(tx, ty) || 1;
      return [sg * ty / l, -sg * tx / l]; });
  }
  function furPath(P, Nm, amp, t, seed = 0, sc = 1, c = [0, 0]) {
    let d = '';
    P.forEach((p, i) => { const sp = (i % 2 ? 1 : .12) * (.75 + .25 * Math.sin(i * 1.7 + seed)) * (1 + .12 * Math.sin(t * 7 + i));
      const x = c[0] + (p[0] - c[0]) * sc + Nm[i][0] * amp * sp, y = c[1] + (p[1] - c[1]) * sc + Nm[i][1] * amp * sp;
      d += (i ? 'L' : 'M') + f1(x) + ' ' + f1(y); });
    return d + 'Z';
  }
  const mirror = (half, cx, s = 1, oy = 0) => { const r = half.map(([x, y]) => [cx + x * s, oy + y * s]); const l = half.slice(1, -1).reverse().map(([x, y]) => [cx - x * s, oy + y * s]); return r.concat(l); };
  const HUMAN = [[0, 600], [30, 606], [46, 630], [48, 665], [34, 698], [22, 712], [24, 730], [80, 748], [108, 775], [120, 900], [128, 990], [106, 994], [92, 900], [86, 830], [84, 960], [80, 1100], [36, 1100], [8, 960], [0, 960]];
  const APE = [[0, 650], [44, 652], [64, 680], [62, 712], [48, 730], [60, 736], [150, 750], [205, 805], [222, 955], [236, 1090], [192, 1098], [162, 965], [142, 870], [134, 985], [124, 1140], [62, 1140], [22, 1030], [0, 1020]];
  const CAT = [[110, 820], [135, 790], [148, 748], [176, 782], [204, 756], [216, 800], [260, 770], [330, 735], [390, 732], [440, 745], [470, 790], [472, 830], [505, 800], [535, 750], [540, 700], [556, 696], [562, 712], [566, 770], [540, 830], [490, 870], [472, 1060], [446, 1060], [440, 905], [400, 918], [300, 920], [252, 902], [242, 1060], [216, 1060], [206, 880], [170, 868], [130, 850]];

  function silLayer(svg) {
    const g = el('g', {}, svg);
    const glow = el('path', { d: '', fill: 'none', stroke: 'var(--accent2)', 'stroke-width': 22, opacity: .45, filter: 'url(#blur8)', 'stroke-linejoin': 'round' }, g);
    const fill = el('path', { d: '', fill: 'var(--panel)', opacity: .55 }, g);
    const line = el('path', { d: '', fill: 'none', stroke: 'var(--accent)', 'stroke-width': 5, filter: 'url(#glow)', 'stroke-linejoin': 'round' }, g);
    return { g, glow, fill, line, set(d) { glow.setAttribute('d', d); fill.setAttribute('d', d); line.setAttribute('d', d); } };
  }

  function buildNope(root) {
    const svg = el('svg', { viewBox: '0 0 1080 1920', width: 1080, height: 1920, class: 'gsvg' }, root); defs(svg);
    const bg = el('g', { filter: 'url(#blur16)' }, svg); R.nBok = []; const r = rng(55);
    for (let i = 0; i < 12; i++) R.nBok.push({ e: el('circle', { r: 30 + r() * 60, fill: i % 2 ? 'url(#gBok)' : 'url(#gBokY)', opacity: .5 }, bg), x: r() * 1080, y: 300 + r() * 1300, ph: r() * 6 });
    el('line', { x1: 60, y1: 1112, x2: 1020, y2: 1112, stroke: 'var(--accent2)', 'stroke-width': 4, opacity: .5 }, svg);
    R.catP = resample(CAT.map(([x, y]) => [x - 40, y + 40]), 220); R.catN = normals(R.catP);
    R.humP = resample(mirror(HUMAN, 820, 1, 52), 200); R.humN = normals(R.humP);
    R.catS = silLayer(svg); R.humS = silLayer(svg);
  }
  function renderNope(t) {
    const cp = clamp(S(t - (T.barely + .02), 9, .45), 0, 1.25);
    const hp = clamp(S(t - (T.barely + .2), 12, .6)) * (1 - clamp(S(t - T.fail, 7, .9)));
    R.catS.set(furPath(R.catP, R.catN, 6 + 40 * cp, t, 1, 1 + .16 * cp, [300, 950]));
    R.humS.set(furPath(R.humP, R.humN, 1.5 + 4 * hp, t, 2, 1 + .025 * hp, [820, 1100]));
    R.humS.line.setAttribute('opacity', f3(1 - .45 * clamp(S(t - T.fail, 7, .9))));
    R.nBok.forEach(b => { b.e.setAttribute('cx', f1(b.x + 30 * Math.sin(t * .5 + b.ph))); b.e.setAttribute('cy', f1(b.y + 24 * Math.cos(t * .4 + b.ph))); });
    R.nopeCam.style.transform = `scale(${f3(1 + .05 * clamp((t - T.nope) / 1.5))})`;
  }

  function buildAnc(root) {
    const svg = el('svg', { viewBox: '0 0 1080 1920', width: 1080, height: 1920, class: 'gsvg' }, root); defs(svg);
    const bg = el('g', { filter: 'url(#blur16)' }, svg); R.aBok = []; const r = rng(77);
    for (let i = 0; i < 12; i++) R.aBok.push({ e: el('circle', { r: 30 + r() * 60, fill: i % 2 ? 'url(#gBok)' : 'url(#gBokY)', opacity: .5 }, bg), x: r() * 1080, y: 300 + r() * 1300, ph: r() * 6 });
    R.apeP = resample(mirror(APE, 540, 1.12, -90), 240); R.humAP = resample(mirror(HUMAN, 540, 1.12, -90), 240);
    R.ancS = silLayer(svg);
    R.roots = []; for (let i = 0; i < 240; i += 9) R.roots.push({ i, e: el('circle', { r: 7, fill: 'url(#gDot)', opacity: 0 }, svg) });
  }
  function renderAnc(t) {
    const u = eio((t - (T.trace + .1)) / 0.95);
    const P = R.apeP.map((p, i) => [lerp(p[0], R.humAP[i][0], u), lerp(p[1], R.humAP[i][1], u)]);
    const N = normals(P);
    R.ancS.set(furPath(P, N, lerp(30, 2, u), t, 3));
    R.roots.forEach(r => { const p = P[r.i], n = N[r.i]; r.e.setAttribute('cx', f1(p[0] + n[0] * 4)); r.e.setAttribute('cy', f1(p[1] + n[1] * 4));
      r.e.setAttribute('opacity', f3(clamp((u - .6) / .3) * (.55 + .45 * Math.sin(t * 6 + r.i)))); });
    R.aBok.forEach(b => { b.e.setAttribute('cx', f1(b.x + 30 * Math.sin(t * .5 + b.ph))); b.e.setAttribute('cy', f1(b.y + 24 * Math.cos(t * .4 + b.ph))); });
  }

  /* ------------------------------------------------------------ brain (dopamine) */
  const BRAIN = 'M250 860 C225 735 300 610 425 585 C505 535 650 535 730 588 C835 600 895 690 882 795 C912 862 870 945 795 955 C762 1005 690 1015 640 985 C600 1015 540 1005 498 975 C428 995 325 965 286 925 C266 903 252 882 250 860 Z';
  const GYRI = ['M330 700 C380 660 430 700 470 660 C510 620 560 660 600 630', 'M300 800 C360 760 400 800 450 770 C500 740 540 790 600 760 C650 735 700 770 760 730',
    'M320 890 C380 860 430 900 480 870 C530 840 580 880 640 860', 'M620 640 C660 670 700 650 740 690 C780 720 810 700 840 740', 'M680 840 C720 820 760 860 820 850',
    'M540 600 C520 660 560 700 540 760', 'M700 600 C690 650 720 690 700 740'];
  function buildBrain(root) {
    const svg = el('svg', { viewBox: '0 0 1080 1920', width: 1080, height: 1920, class: 'gsvg' }, root); defs(svg);
    const bg = el('g', { filter: 'url(#blur16)' }, svg); R.bBok = []; const r = rng(33);
    for (let i = 0; i < 14; i++) R.bBok.push({ e: el('circle', { r: 30 + r() * 60, fill: i % 2 ? 'url(#gBok)' : 'url(#gBokY)', opacity: .5 }, bg), x: r() * 1080, y: 300 + r() * 1300, ph: r() * 6 });
    const g = el('g', {}, svg); R.brainG = g;
    el('path', { d: BRAIN, fill: 'none', stroke: 'var(--accent2)', 'stroke-width': 30, opacity: .4, filter: 'url(#blur16)' }, g);
    el('path', { d: BRAIN, fill: 'url(#gBrain)' }, g);
    el('ellipse', { cx: 770, cy: 985, rx: 92, ry: 54, fill: 'url(#gBrain)', stroke: 'var(--accent2)', 'stroke-width': 4, opacity: .8 }, g);
    el('path', { d: 'M680 985 C692 1045 692 1095 682 1140 L640 1140 C646 1090 642 1040 630 995', fill: 'var(--panel)', stroke: 'var(--accent2)', 'stroke-width': 4, opacity: .85 }, g);
    const gy = el('g', { fill: 'none', stroke: 'var(--skinhi)', 'stroke-width': 5, opacity: .55, 'stroke-linecap': 'round' }, g); GYRI.forEach(d => el('path', { d }, gy));
    R.brainLine = el('path', { d: BRAIN, fill: 'none', stroke: 'var(--accent)', 'stroke-width': 6, filter: 'url(#glow)' }, g);
    R.brainLen = R.brainLine.getTotalLength();
    R.brainLine.setAttribute('stroke-dasharray', f1(R.brainLen));
    R.src = el('circle', { cx: 575, cy: 870, r: 90, fill: 'url(#gBokY)', opacity: 0 }, g);
    R.srcDot = el('circle', { cx: 575, cy: 870, r: 20, fill: 'url(#gDot)', opacity: .5 }, g);
    R.parts = []; const rp = rng(8);
    for (let i = 0; i < 56; i++) R.parts.push({ e: el('circle', { r: 6 + rp() * 9, fill: i % 4 ? 'url(#gDot)' : 'url(#gDotP)', opacity: 0 }, g), a: rp() * 6.283, sp: 150 + rp() * 330, lag: rp() * .5, w: rp() * 6 });
  }
  function renderBrain(t) {
    const u = t - T.brain;
    R.brainLine.setAttribute('stroke-dashoffset', f1(R.brainLen * (1 - eo(u / .7))));
    const hit = pulse(t, T.dopa, .6);
    R.src.setAttribute('opacity', f3(clamp(.25 + .75 * clamp(S(t - T.release, 10, .6)) * (.75 + .25 * Math.sin(t * 8)) + hit)));
    R.srcDot.setAttribute('r', f1(20 + 16 * hit));
    R.parts.forEach(p => { const tt = t - T.release - p.lag * .6; if (tt <= 0) { p.e.setAttribute('opacity', 0); return; }
      const d = p.sp * (1 - Math.exp(-tt * 1.6)), x = 575 + Math.cos(p.a) * d + 14 * Math.sin(tt * 3 + p.w), y = 870 + Math.sin(p.a) * d * .8 - 30 * tt;
      p.e.setAttribute('cx', f1(x)); p.e.setAttribute('cy', f1(y)); p.e.setAttribute('opacity', f3(clamp(tt / .15) * (.6 + .4 * Math.sin(tt * 9 + p.w)))); });
    R.brainG.setAttribute('transform', `translate(540 860) scale(${f3(1 + .05 * clamp(u / 2) + .04 * hit)}) rotate(${f3(-1.5 + 1.5 * clamp(u / 2))}) translate(-560 -800)`);
    R.bBok.forEach(b => { b.e.setAttribute('cx', f1(b.x + 30 * Math.sin(t * .5 + b.ph))); b.e.setAttribute('cy', f1(b.y + 24 * Math.cos(t * .4 + b.ph))); });
    const c = clamp(S(t - T.dopa, 13, .5), 0, 1.25);
    R.dChip.style.opacity = f3(clamp(c)); R.dChip.style.transform = `translate(540px,430px) translate(-50%,-50%) rotate(-3deg) scale(${f3(c)})`;
  }

  /* ------------------------------------------------------------ overlays on footage */
  function buildCat(root) {
    const svg = el('svg', { viewBox: '0 0 1080 1920', width: 1080, height: 1920, class: 'gsvg' }, root); defs(svg);
    const P = []; for (let i = 0; i < 150; i++) { const a = i / 150 * 6.283; const c = Math.cos(a), s = Math.sin(a);
      const r = 1 / Math.pow(Math.pow(Math.abs(c) / 330, 3) + Math.pow(Math.abs(s) / 360, 3), 1 / 3);
      P.push([540 + c * r, 1170 + s * r]); }
    R.auraP = P; R.auraN = normals(P); R.aura = silLayer(svg); R.aura.fill.setAttribute('opacity', '0');
  }
  function renderCat(t) {
    const a = clamp(S(t - (T.pong + .1), 8, .7)), b = clamp(S(t - T.big, 10, .4), 0, 1.3);
    R.aura.set(furPath(R.auraP, R.auraN, 10 + 22 * a + 34 * b, t, 4, .86 + .06 * a + .14 * b, [540, 1170]));
    R.aura.g.setAttribute('opacity', f3(clamp(a)));
  }
  function renderHuman(t) {
    const u = (t - T.popEnd) / 2.1;
    R.scan.style.transform = `translateX(${f1(lerp(-300, 1100, u))}px) rotate(14deg)`;
    R.scan.style.opacity = f3(.32 * Math.sin(Math.PI * clamp(u)));
  }
  function renderMusic(t) {
    R.waves.forEach((w, i) => { const ph = ((t - T.music) * .7 + i / 4) % 1; w.setAttribute('r', f1(60 + 360 * ph)); w.setAttribute('opacity', f3(.7 * (1 - ph) * clamp((t - T.music) / .3))); });
  }
  function renderCta(t) {
    const c = clamp(S(t - (T.cta + .05), 12, .5), 0, 1.25);
    R.cChip.style.opacity = f3(clamp(c)); R.cChip.style.transform = `translate(540px,470px) translate(-50%,-50%) rotate(${f1(-2 + 1.5 * Math.sin(t * 2.4))}deg) scale(${f3(c)})`;
  }

  /* ------------------------------------------------------------ chips over the stage (not hosted) */
  function chip(id, a, b, t, x, y, word) {
    const e = R[id]; const on = t >= a && t < b;
    const c = on ? clamp(S(t - a, 13, .5), 0, 1.25) * (1 - clamp((t - (b - .12)) / .12)) : 0;
    const k = word && t >= word ? 1 + .08 * pulse(t, word, .25) : 1;
    e.style.opacity = f3(clamp(c)); e.style.transform = `translate(${x}px,${y}px) translate(-50%,-50%) rotate(-2deg) scale(${f3(c * k)})`;
  }

  /* ------------------------------------------------------------ build + host plumbing */
  function build() {
    const skin = $('skin-in');
    const svg = el('svg', { viewBox: '0 0 1080 1920', width: 1080, height: 1920, class: 'gsvg' }, skin); defs(svg); buildSkin(svg);
    const hud = el('svg', { viewBox: '0 0 1080 1920', width: 1080, height: 1920, class: 'gsvg' }, skin); defs(hud);
    R.mLead = el('path', { d: '', stroke: 'var(--accent)', 'stroke-width': 5, fill: 'none', opacity: 0, filter: 'url(#glow)' }, hud);
    R.mDot = el('circle', { r: 16, fill: 'url(#gDot)', opacity: 0 }, hud);
    R.diveImg = $('dive-img'); R.mLab = $('m-lab'); R.q = $('q-mark'); R.q2 = $('q-mark2');
    R.nopeCam = $('nope-in'); buildNope(R.nopeCam); buildAnc($('anc-in')); buildBrain($('brain-in')); R.dChip = $('d-chip');
    buildCat($('cat-in')); R.scan = $('scan');
    const ws = el('svg', { viewBox: '0 0 1080 1920', width: 1080, height: 1920, class: 'gsvg' }, $('music-in')); defs(ws);
    R.waves = [0, 1, 2, 3].map(() => el('circle', { cx: 640, cy: 640, r: 60, fill: 'none', stroke: 'var(--accent)', 'stroke-width': 7, filter: 'url(#glow)', opacity: 0 }, ws));
    R.cChip = $('c-chip'); R.sChip = $('s-chip'); R.hChip = $('h-chip');
    R.hosts = Array.from(document.querySelectorAll('.ovh')).map(e => ({ e, ids: e.dataset.host.split(' '), kb: e.dataset.kb === '1', inner: e.firstElementChild }));
    built = true;
  }
  function follow(t, SC) {
    const byId = {}; SC.forEach(s => byId[s.id] = s);
    // continuous runs inside the skin scene: the next shot takes over without a transition
    [['dive', 'muscle'], ['regrow', 'newhair']].forEach(([a, b]) => { const A = byId[a], B = byId[b];
      if (t >= B.a && t < B.b + 0.2) { if (B.el.style.opacity !== '0') { B.el.style.opacity = '1'; B.el.style.transform = 'none'; } A.el.style.opacity = '0'; } });
    // hook: punch-in on the goose bumps at "ขนลุก" (frame 0 and the loop end stay at scale 1.0)
    const h = byId.hook; if (t < h.b) { const k = t < 0.86 ? 1 + .035 * (t / .86) : lerp(1.035, 1.16, clamp(S(t - .86, 10, .7), 0, 1.1)) + .02 * clamp((t - 1.5) / 1.4);
      h.kb.style.transformOrigin = '50% 62%'; h.kb.style.transform = `scale(${f3(k)})`; }
    // cat: punch-in on "ใหญ่"
    const c = byId.cat; if (t >= c.a && t < c.b + .2) { const k = 1.0 + .04 * clamp((t - c.a) / 3) + .1 * clamp(S(t - T.big, 11, .45), 0, 1.2);
      c.kb.style.transformOrigin = '50% 60%'; c.kb.style.transform = `scale(${f3(k)})`; }
    R.hosts.forEach(H => {
      let host = null, op = 0;
      H.ids.forEach(id => { const s = byId[id]; const o = +s.el.style.opacity || 0; if (o > 0 && (!host || s.a > host.a)) host = s; op = Math.max(op, o); });
      if (!host) { H.e.style.opacity = '0'; H.vis = false; return; }
      H.vis = true; H.e.style.opacity = f3(op); H.e.style.transform = host.el.style.transform || 'none'; H.e.style.zIndex = host.el.style.zIndex;
      if (H.kb) { H.inner.style.transform = host.kb.style.transform; H.inner.style.transformOrigin = host.kb.style.transformOrigin || '50% 50%'; }
    });
  }
  function render(t, SC) {
    if (!built) build();
    follow(t, SC);
    const vis = id => R.hosts.find(H => H.e.id === id).vis;
    if (vis('ov-skin')) renderSkin(t);
    if (vis('ov-nope')) renderNope(t);
    if (vis('ov-anc')) renderAnc(t);
    if (vis('ov-brain')) renderBrain(t);
    if (vis('ov-cat')) renderCat(t);
    if (vis('ov-human')) renderHuman(t);
    if (vis('ov-music')) renderMusic(t);
    if (vis('ov-cta')) renderCta(t);
    chip('sChip', T.ape - .02, T.twist, t, 540, 330, T.ancestor);
    chip('hChip', T.harvard - .05, T.music, t, 540, 330, T.inmice);
  }
  return { render, T };
})();
