// Deterministic frame render: window.renderFrame(t) -> screenshot -> ffmpeg.
// node render.js video <out.mp4> [fps=24] [t0] [t1] | node render.js stills <dir> mid|t1,t2,... | node render.js sheet <out.png> <n>
const { chromium } = require('playwright'); const path = require('path'); const { spawn } = require('child_process'); const fs = require('fs');
(async () => {
  const [mode, out, a, b, c] = process.argv.slice(2);
  const root = path.resolve(__dirname, '../../..'); const { server, port } = await require('./serve.js')(root);
  const br = await chromium.launch();
  const sheet = mode === 'sheet';
  const p = await br.newPage({ viewport: sheet ? { width: 1600, height: 2000 } : { width: 1080, height: 1920 }, deviceScaleFactor: 1 });
  p.on('pageerror', e => console.log('PAGEERR', e.message.slice(0, 300)));
  await p.goto(`http://localhost:${port}/${path.relative(root, __dirname)}/index.html${sheet ? '?sheet=' + (a || 1) : ''}`);
  await p.waitForFunction(() => window.ready, null, { timeout: 60000 });
  if (sheet) { await p.screenshot({ path: out, type: out.endsWith('.png') ? 'png' : 'jpeg', ...(out.endsWith('.png') ? {} : { quality: 90 }) }); }
  else if (mode === 'stills') {
    fs.mkdirSync(out, { recursive: true });
    const times = a === 'mid' ? await p.evaluate(() => EP.shots.flatMap(s => [+((s.t0 + s.t1) / 2).toFixed(2)])) : a.split(',').map(Number);
    for (const t of times) { const id = await p.evaluate(t => renderFrame(t), t); await p.screenshot({ path: `${out}/t${t.toFixed(2).padStart(6, '0')}_${id}.jpg`, quality: 85, type: 'jpeg' }); }
  } else {
    const dur = await p.evaluate(() => EP.duration);
    const fps = +a || 24, t0 = +b || 0, t1 = +c || dur, n = Math.round((t1 - t0) * fps);
    const ff = spawn('ffmpeg', ['-v', 'error', '-y', '-f', 'image2pipe', '-framerate', String(fps), '-c:v', 'mjpeg', '-i', '-', '-c:v', 'libx264', '-pix_fmt', 'yuv420p', '-crf', '16', '-preset', 'medium', '-r', String(fps), out], { stdio: ['pipe', 'inherit', 'inherit'] });
    const st = Date.now();
    for (let i = 0; i < n; i++) {
      await p.evaluate(t => renderFrame(t), t0 + i / fps);
      const buf = await p.screenshot({ type: 'jpeg', quality: 94 });
      if (!ff.stdin.write(buf)) await new Promise(r => ff.stdin.once('drain', r));
      if (i % 120 === 0) console.log(`frame ${i}/${n} ${((Date.now() - st) / 1000).toFixed(0)}s`);
    }
    ff.stdin.end(); await new Promise(r => ff.on('close', r));
  }
  await br.close(); server.close();
})();
