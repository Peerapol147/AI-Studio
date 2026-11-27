// Cover A/B stills + layout for tools/cover_check.py (palmaris feedback 7-8, 2026-11-26).
// Use: node tools/cover_shot.js <video/cover.html> <out dir, e.g. projects/<x>/covers> [a,b] [--look <look.json>]
// The text, palette and font come from look.json (default <out dir>/../look.json): its "covers" entry for the variant
// ({id, lines, badge}) and the look's palette/font values in templates/looks/looks.json are injected as
// window.__COVER, so the image always shows the text tools/cover_check.py checks (review 2026-11-26).
// For each variant: opens cover.html?v=<id>, waits for fonts, writes <out>/cover-<id>.jpg (the image to upload) and
// <out>/cover-<id>.json = {w, h, items: [{kind, text, x, y, w, h, font_px, overflow}]} from every element marked
// data-cover="text" (one per text line), "badge" or "art" (the hero picture). Needs node + playwright (preinstalled).
const { chromium } = require('playwright');
const path = require('path');
const fs = require('fs');
(async () => {
  const args = process.argv.slice(2);
  const li = args.indexOf('--look');
  const lookPath = li >= 0 ? args.splice(li, 2)[1] : null;
  const [html, out, list] = args;
  if (!html || !out) { console.error('use: node tools/cover_shot.js <cover.html> <out dir> [a,b] [--look look.json]'); process.exit(2); }
  const variants = (list || 'a,b').split(',').filter(Boolean);
  const lf = path.resolve(lookPath || path.join(out, '..', 'look.json'));
  if (!fs.existsSync(lf)) { console.error(`${lf} missing: covers need look.json "covers" (text) + palette/font`); process.exit(2); }
  const look = JSON.parse(fs.readFileSync(lf, 'utf8'));
  let cat = null;                                    // templates/looks/looks.json: walk up from look.json to the repo
  for (let d = path.dirname(lf); d !== path.dirname(d); d = path.dirname(d)) {
    const c = path.join(d, 'templates', 'looks', 'looks.json');
    if (fs.existsSync(c)) { cat = JSON.parse(fs.readFileSync(c, 'utf8')); break; }
  }
  const vars = {};
  // covers may use their own dark palette (look.json cover_palette, caffeine-ranking 2026-11-27); default = the look's palette
  const palName = look.cover_palette || look.palette;
  const pal = cat && cat.palette && cat.palette[palName];
  if (pal) for (const k of ['bg', 'bg2', 'ink', 'text', 'accent', 'accent2', 'panel']) if (pal[k]) vars['--' + k] = pal[k];
  const font = cat && cat.font && cat.font[look.font];
  if (font) { vars['--font'] = `'${font.family}'`; vars['--tw'] = String(font.title_weight || 900); }
  fs.mkdirSync(out, { recursive: true });
  const b = await chromium.launch();
  let bad = 0;
  for (const v of variants) {
    const cv = (look.covers || []).find(c => c.id === v);
    if (!cv || !(cv.lines || []).length) { console.error(`look.json has no "covers" entry with lines for id ${v}`); bad = 1; continue; }
    const p = await b.newPage({ viewport: { width: 1080, height: 1920 } });
    await p.addInitScript(c => { window.__COVER = c; }, { lines: cv.lines, badge: cv.badge || '', vars });
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
    geo.look = { file: lf, lines: cv.lines, palette: palName || null, font: look.font || null };
    fs.writeFileSync(path.join(out, `cover-${v}.json`), JSON.stringify(geo, null, 1));
    if (!geo.items.some(i => i.kind === 'text')) { console.error(`cover-${v}: no data-cover="text" element`); bad = 1; }
    if (errs.length) { console.error(`cover-${v}: page errors: ${errs.join(' | ')}`); bad = 1; }
    console.log(path.join(out, `cover-${v}.jpg`), `${geo.items.length} items`);
    await p.close();
  }
  await b.close();
  process.exit(bad);
})();
