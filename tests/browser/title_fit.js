// Frame-0 title geometry check for templates/brainrot-v3 (run by tests/test_title_fit_v3.py).
// argv: list of index.html files. For each page: every title line fits its box (no horizontal overflow), and the
// ink of each line's top (Thai upper vowel + tone mark stacked) does not reach into the line above
// (its text or its highlight plate). Prints JSON [{file, problems: [...]}].
const { chromium } = require('playwright');
(async () => {
  const b = await chromium.launch();
  const p = await b.newPage({ viewport: { width: 1080, height: 1920 } });
  const out = [];
  for (const f of process.argv.slice(2)) {
    await p.goto('file://' + f);
    await p.evaluate(() => document.fonts.ready);
    await p.waitForTimeout(150);
    const problems = await p.evaluate(() => {
      const probs = [];
      const title = document.getElementById('title');
      const ts = getComputedStyle(title);
      const inner = title.getBoundingClientRect();
      // card: lines must stay inside the card's padding; other covers: inside the 960 px title box
      const card = document.getElementById('root').classList.contains('cv-card');
      const left = inner.left + (card ? parseFloat(ts.paddingLeft) : 0), right = inner.right - (card ? parseFloat(ts.paddingRight) : 0);
      const ctx = document.createElement('canvas').getContext('2d');
      const lines = [...title.querySelectorAll('.tl')];
      const geo = lines.map(tl => {
        const cs = getComputedStyle(tl);
        ctx.font = `${cs.fontWeight} ${cs.fontSize} ${cs.fontFamily}`;
        const r = document.createRange(); r.selectNodeContents(tl);
        const rects = [...r.getClientRects()];
        const text = tl.textContent;
        let inkTop = Infinity, inkBottom = -Infinity, l = Infinity, rr = -Infinity;
        // per text node: content-area rect + canvas metrics -> ink extent
        const walker = document.createTreeWalker(tl, NodeFilter.SHOW_TEXT);
        let n;
        while ((n = walker.nextNode())) {
          const rg = document.createRange(); rg.selectNodeContents(n);
          const box = rg.getBoundingClientRect();
          const pcs = getComputedStyle(n.parentElement);
          ctx.font = `${pcs.fontWeight} ${pcs.fontSize} ${pcs.fontFamily}`;
          const m = ctx.measureText(n.textContent);
          inkTop = Math.min(inkTop, box.top + (m.fontBoundingBoxAscent - m.actualBoundingBoxAscent));
          inkBottom = Math.max(inkBottom, box.top + m.fontBoundingBoxAscent + m.actualBoundingBoxDescent);
          l = Math.min(l, box.left); rr = Math.max(rr, box.right);
        }
        const tlr = tl.getBoundingClientRect();
        l = Math.min(l, tlr.left); rr = Math.max(rr, tlr.right);
        let plateBottom = -Infinity;
        for (const e of [tl, ...tl.querySelectorAll('em')]) {
          const s = getComputedStyle(e);
          if (s.backgroundColor !== 'rgba(0, 0, 0, 0)' || s.backgroundImage !== 'none') plateBottom = Math.max(plateBottom, e === tl ? tlr.bottom : Math.max(...[...e.getClientRects()].map(x => x.bottom)));
        }
        // a highlighted word on its own plate must hold its stacked marks (else they vanish into the line's colour)
        for (const e of tl.querySelectorAll('em')) {
          const s = getComputedStyle(e);
          if (s.backgroundColor === 'rgba(0, 0, 0, 0)') continue;
          const er = e.getBoundingClientRect();
          const rg = document.createRange(); rg.selectNodeContents(e);
          const box = rg.getBoundingClientRect();
          ctx.font = `${s.fontWeight} ${s.fontSize} ${s.fontFamily}`;
          const m = ctx.measureText(e.textContent);
          const top = box.top + (m.fontBoundingBoxAscent - m.actualBoundingBoxAscent);
          if (top < er.top - 1) probs.push(`highlight "${e.textContent}" marks at ${top.toFixed(0)} stick out above its plate (${er.top.toFixed(0)})`);
        }
        return { text, inkTop, inkBottom, l, r: rr, plateBottom };
      });
      lines.forEach((tl, i) => { const fs = parseFloat(getComputedStyle(tl).fontSize); const min = lines.length <= 2 ? 72 : 60; if (fs < min) probs.push(`line ${i + 1} font ${fs}px < ${min}px (unreadable on a phone)`); });
      const tb = title.getBoundingClientRect().bottom;
      const lim = document.getElementById('root').classList.contains('op-number') ? 840 : document.getElementById('root').classList.contains('op-pov') ? 770 : 720;
      if (tb > lim) probs.push(`title ends at Y ${tb.toFixed(0)}: below ${lim}`);
      geo.forEach((g, i) => {
        if (g.l < left - 1 || g.r > right + 1) probs.push(`line ${i + 1} "${g.text}" overflows the title box (${g.l.toFixed(0)}-${g.r.toFixed(0)} vs ${left.toFixed(0)}-${right.toFixed(0)})`);
        if (i > 0) {
          const above = geo[i - 1];
          const floor = Math.max(above.inkBottom, above.plateBottom);
          if (g.inkTop < floor - 1) probs.push(`line ${i + 1} "${g.text}" top ink at ${g.inkTop.toFixed(0)} reaches into line ${i} (bottom ${floor.toFixed(0)})`);
        }
      });
      return probs;
    });
    out.push({ file: f, problems });
  }
  await b.close();
  console.log(JSON.stringify(out));
})();
