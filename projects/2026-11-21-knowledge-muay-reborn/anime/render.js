// Render frames with Playwright (deterministic: window.renderFrame(t)) and pipe JPEGs to ffmpeg.
// node render.js video <out.mp4> [fps] [t0] [t1]   |   node render.js stills <outdir> t1,t2,...
const { chromium } = require('playwright'); const path = require('path'); const { spawn } = require('child_process'); const fs = require('fs');
(async () => {
  const [mode, out, a, b, c] = process.argv.slice(2); const FMT = process.env.FMT || 'long'; const PD = +(process.env.PD || 1); const SCALE = +(process.env.SCALE || Math.max(1, PD)); const QS = (process.env.CRISP ? '&crisp=1' : '') + (process.env.PD ? '&pd=' + PD : '') + (process.env.INK ? '&ink=' + process.env.INK : ''); const VW = FMT === 'long' ? 1920 : 1080, VH = FMT === 'long' ? 1080 : 1920;
  const root = path.resolve(__dirname, '../../..'); const { server, port } = await require('./serve.js')(root);
  const br = await chromium.launch({ args: process.env.GPU ? ['--use-angle=d3d11', '--enable-gpu', '--ignore-gpu-blocklist', '--enable-gpu-rasterization'] : ['--use-angle=swiftshader', '--enable-unsafe-swiftshader', '--ignore-gpu-blocklist'] });
  const p = await br.newPage({ viewport: { width: VW, height: VH }, deviceScaleFactor: SCALE }); p.setDefaultTimeout(900000);
  p.on('pageerror', e => console.log('PAGEERR', e.message.slice(0, 300)));
  p.on('console', m => { const s = m.text(); if (m.type() === 'error' && !/404|TUNNEL|regular/.test(s)) console.log('CONSOLE', s.slice(0, 300)); });
  await p.goto(`http://localhost:${port}/${path.relative(root, __dirname)}/index.html?fmt=${FMT}${process.env.THUMB ? "&thumb=1" : ""}${QS}`);
  await p.waitForFunction(() => window.ready && window.renderFrame, null, { timeout: 1200000 });
  const dur = await p.evaluate(() => DATA.duration);
  if (mode === 'stills') {
    fs.mkdirSync(out, { recursive: true });
    // 'mid' = the middle of every shot (SHOTS=regex filters by shot id; 'mid3' = 3 frames per shot at 20/50/80%)
    const times = /^mid/.test(a) ? await p.evaluate(([re, n]) => EP.shots.filter(s => !re || new RegExp(re).test(s.id)).flatMap(s => { const e = Math.min(s.t1, DATA.duration); return n > 1 ? [0.2, 0.5, 0.8].map(k => +(s.t0 + (e - s.t0) * k).toFixed(2)) : [+((s.t0 + e) / 2).toFixed(2)]; }), [process.env.SHOTS || '', a === 'mid3' ? 3 : 1]) : a.split(',').map(Number);
    for (const t of times) { let id; try { id = await p.evaluate(t => renderFrame(t), t); } catch (e) { console.log('FAIL', t, e.message.split('\n').slice(0, 3).join(' / ')); continue; } await p.screenshot({ path: `${out}/t${t.toFixed(2).padStart(6, '0')}_${id}.jpg`, quality: 85, type: 'jpeg' }); }
  } else {
    const fps = +a || 24, t0 = +b || 0, t1 = +c || dur, n = Math.round((t1 - t0) * fps);
    const ff = spawn('ffmpeg', ['-v', 'error', '-y', '-f', 'image2pipe', '-framerate', String(fps), '-c:v', 'mjpeg', '-i', '-', '-vf', `fps=24,scale=${VW}:${VH}:flags=lanczos`, '-c:v', 'libx264', '-pix_fmt', 'yuv420p', '-crf', '17', '-preset', 'medium', out], { stdio: ['pipe', 'inherit', 'inherit'] });
    const st = Date.now();
    for (let i = 0; i < n; i++) {
      await p.evaluate(t => renderFrame(t), t0 + i / fps);
      const buf = await p.screenshot({ type: 'jpeg', quality: 95 });
      if (!ff.stdin.write(buf)) await new Promise(r => ff.stdin.once('drain', r));
      if (i % 48 === 0) console.log(`frame ${i}/${n} ${((Date.now() - st) / 1000).toFixed(0)}s`);
    }
    ff.stdin.end(); await new Promise(r => ff.on('close', r));
  }
  await br.close(); server.close();
})();
