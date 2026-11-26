// Cover A/B stills + layout for tools/cover_check.py (palmaris feedback 7-8, 2026-11-26).
// Use: node tools/cover_shot.js <video/cover.html> <out dir, e.g. projects/<x>/covers> [a,b]
// For each variant: opens cover.html?v=<id>, waits for fonts, writes <out>/cover-<id>.jpg (the image to upload) and
// <out>/cover-<id>.json = {w, h, items: [{kind, text, x, y, w, h, font_px, overflow}]} from every element marked
// data-cover="text" (one per text line), "badge" or "art" (the hero picture). Needs node + playwright (preinstalled).
const { chromium } = require('playwright');
const path = require('path');
const fs = require('fs');
(async () => {
  const [html, out, list] = process.argv.slice(2);
  if (!html || !out) { console.error('use: node tools/cover_shot.js <cover.html> <out dir> [a,b]'); process.exit(2); }
  const variants = (list || 'a,b').split(',').filter(Boolean);
  fs.mkdirSync(out, { recursive: true });
  const b = await chromium.launch();
  let bad = 0;
  for (const v of variants) {
    const p = await b.newPage({ viewport: { width: 1080, height: 1920 } });
    const errs = [];
    p.on('pageerror', e => errs.push(String(e)));
    await p.goto('file://' + path.resolve(html) + '?v=' + encodeURIComponent(v));
    await p.evaluate(() => document.fonts.ready);
    await p.waitForTimeout(300);
    const geo = await p.evaluate(() => {
      const root = document.getElementById('root') || document.body;
      const R = root.getBoundingClientRect();
      const items = [...document.querySelectorAll('[data-cover]')].map(e => {
        const cs = getComputedStyle(e);
        let r = e.getBoundingClientRect();
        if (e.dataset.cover === 'text') {
          // the inked glyphs (+ text stroke) and any inline plate with a background, not the full-width block box or
          // the font's tall ascent/descent box (Thai fonts reserve room for stacked marks, so line boxes always touch)
          const rg = document.createRange(); rg.selectNodeContents(e);
          const lr = [...rg.getClientRects()].filter(q => q.width && q.height);
          const ctx = document.createElement('canvas').getContext('2d');
          ctx.font = `${cs.fontWeight} ${cs.fontSize} ${cs.fontFamily}`;
          const m = ctx.measureText(e.textContent || '');
          const sw = (parseFloat(cs.webkitTextStrokeWidth) || 0) / 2;
          const rs = lr.map(q => { const base = q.top + m.fontBoundingBoxAscent;
            return { left: q.left - sw, right: q.right + sw, top: base - m.actualBoundingBoxAscent - sw, bottom: base + m.actualBoundingBoxDescent + sw }; });
          for (const c of e.querySelectorAll('*')) {
            const ccs = getComputedStyle(c);
            if (ccs.backgroundColor !== 'rgba(0, 0, 0, 0)' || ccs.backgroundImage !== 'none') rs.push(c.getBoundingClientRect());
          }
          if (rs.length) {
            const l = Math.min(...rs.map(q => q.left)), t = Math.min(...rs.map(q => q.top));
            r = { left: l, top: t, width: Math.max(...rs.map(q => q.right)) - l, height: Math.max(...rs.map(q => q.bottom)) - t };
          }
        }
        return { kind: e.dataset.cover, text: (e.textContent || '').trim(), x: r.left - R.left, y: r.top - R.top, w: r.width, h: r.height,
                 font_px: parseFloat(cs.fontSize), overflow: e.clientWidth > 0 && e.scrollWidth > e.clientWidth + 1 };
      }).filter(i => i.w > 0 && i.h > 0);
      return { w: R.width, h: R.height, items };
    });
    geo.errors = errs;
    const el = await p.$('#root');
    await (el || p).screenshot({ path: path.join(out, `cover-${v}.jpg`), type: 'jpeg', quality: 88 });
    fs.writeFileSync(path.join(out, `cover-${v}.json`), JSON.stringify(geo, null, 1));
    if (!geo.items.some(i => i.kind === 'text')) { console.error(`cover-${v}: no data-cover="text" element`); bad = 1; }
    if (errs.length) { console.error(`cover-${v}: page errors: ${errs.join(' | ')}`); bad = 1; }
    console.log(path.join(out, `cover-${v}.jpg`), `${geo.items.length} items`);
    await p.close();
  }
  await b.close();
  process.exit(bad);
})();
