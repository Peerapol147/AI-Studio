// Smoke check for templates/brainrot-v3/compositions/components/hand-rig (run by tests/test_hand_rig.py).
// For each pose: no page error, the SVG has drawn paths, draw() returned points on screen, and drawing the same state
// twice gives the same markup (seek-safe). Writes <out>/hand-<pose>.png. Prints JSON.
const { chromium } = require('playwright');
const path = require('path');
(async () => {
  const [demo, out] = process.argv.slice(2);
  const b = await chromium.launch();
  const res = [];
  for (const pose of ['rest', 'test', 'flex']) {
    const p = await b.newPage({ viewport: { width: 1080, height: 1920 } });
    const errs = []; p.on('pageerror', e => errs.push(String(e)));
    await p.goto('file://' + path.resolve(demo) + '?pose=' + pose);
    await p.waitForTimeout(200);
    await p.screenshot({ path: path.join(out, `hand-${pose}.png`) });
    const info = await p.evaluate(() => {
      const svg = document.getElementById('hand');
      const paths = [...svg.querySelectorAll('path')].filter(e => (e.getAttribute('d') || '').length > 10).length;
      const before = svg.innerHTML;
      const R2 = document.createElementNS('http://www.w3.org/2000/svg', 'svg'); R2.style.display = 'none'; document.body.appendChild(R2);
      const pose = { o: 0.5, op: 0.5, flex: 20, X: 540, Y: 1300, S: 1 };
      const r2 = window.HandRig(R2); r2.draw(pose); const a = R2.innerHTML.replace(/hr\d+/g, 'hr'); r2.draw(pose);
      const same = R2.innerHTML.replace(/hr\d+/g, 'hr') === a;
      return { paths, rig: window.__rig, same, bytes: before.length };
    });
    res.push({ pose, errs, ...info });
    await p.close();
  }
  await b.close();
  console.log(JSON.stringify(res));
})();
