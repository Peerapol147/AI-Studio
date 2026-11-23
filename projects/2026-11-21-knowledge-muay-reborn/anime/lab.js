// Dev lab: one custom still without touching episode.js.  node lab.js <out.jpg> "<query e.g. crisp=1&pd=2>" <shot.js>
// shot.js is evaluated in the page and must return a shot object ({cam0,bg,bgKey,draw,...}); rendered at t=0.5.
const { chromium } = require('playwright'); const path = require('path'); const fs = require('fs');
(async () => {
  const [out, qs, file] = process.argv.slice(2); const long = !/fmt=short/.test(qs); const VW = long ? 1920 : 1080, VH = long ? 1080 : 1920; const pd = +((qs.match(/pd=([\d.]+)/) || [])[1] || 1);
  const root = path.resolve(__dirname, '../../..'); const { server, port } = await require('./serve.js')(root);
  const br = await chromium.launch({ args: ['--use-angle=swiftshader', '--enable-unsafe-swiftshader', '--ignore-gpu-blocklist'] });
  const p = await br.newPage({ viewport: { width: VW, height: VH }, deviceScaleFactor: Math.max(1, pd) }); p.setDefaultTimeout(900000);
  p.on('pageerror', e => console.log('PAGEERR', e.message.slice(0, 300)));
  await p.goto(`http://localhost:${port}/${path.relative(root, __dirname)}/index.html?${qs}`);
  await p.waitForFunction(() => window.ready && window.renderFrame, null, { timeout: 1200000 });
  const t0 = Date.now();
  await p.evaluate(async (src) => { const sh = (0, eval)('(' + src + ')'); EP.shots = [Object.assign({ id: 'lab', t0: 0, t1: 999 }, sh)]; EP.fx = []; EP.moves = []; DATA.subs = []; await renderFrame(sh.at || 0.5); }, fs.readFileSync(file, 'utf8'));
  await p.screenshot({ path: out, quality: 92, type: 'jpeg' }); console.log(out, ((Date.now() - t0) / 1000).toFixed(1) + 's');
  await br.close(); server.close();
})();
