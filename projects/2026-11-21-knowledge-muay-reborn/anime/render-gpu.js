// Full render on the user's PC (RTX): node render-gpu.js [long|short] [part,...]
// Fable version: sharp look (CRISP=1) drawn at 2x and scaled down (PD=2; set PD=1 in the environment if the GPU runs out of memory).
// Renders each part on the GPU -> renders/parts-fable/<fmt>-pNN.mp4, joins them, adds final-mix(-short).m4a -> renders/muay-reborn-fable-<fmt>.mp4
// A part that already exists is skipped (delete it to re-render). Same frames as render.js (swiftshader) — only faster.
const { spawnSync } = require('child_process'); const fs = require('fs'); const path = require('path');
const fmt = process.argv[2] || 'long'; const only = (process.argv[3] || '').split(',').filter(Boolean);
const proj = path.resolve(__dirname, '..'); const D = JSON.parse(fs.readFileSync(path.join(__dirname, 'episode-data.json')));
const outDir = path.join(proj, 'renders', 'parts-fable'); fs.mkdirSync(outDir, { recursive: true });
const parts = fmt === 'short' ? D.short.segments.map(([a, b], i) => [i + 1, a, b]) : Object.entries(D.parts).map(([n, [a, b]]) => [n, a, n === String(Object.keys(D.parts).length) ? D.duration : b]);
const env = Object.assign({ CRISP: '1', PD: '2' }, process.env, { FMT: fmt }, process.platform === 'win32' ? { GPU: '1' } : {}); // GPU flags are Windows (D3D11); elsewhere software rendering
const list = [];
const fr = x => Math.round(x * 24) / 24; // part edges on the 24 fps frame grid (no audio drift across joins)
for (const [n, a0, b0] of parts) { const a = fr(a0), b = fr(b0);
  const out = path.join(outDir, `${fmt}-p${String(n).padStart(2, '0')}.mp4`); list.push(out);
  if (only.length && !only.includes(String(n))) continue;
  if (fs.existsSync(out)) { console.log('skip (exists)', out); continue; }
  console.log(`part ${n}: ${a.toFixed(2)}-${b.toFixed(2)} s`); const t0 = Date.now();
  const r = spawnSync(process.execPath, [path.join(__dirname, 'render.js'), 'video', out + '.tmp.mp4', '24', String(a), String(b)], { env, stdio: 'inherit' });
  if (r.status !== 0) { console.error('render failed on part', n); process.exit(1); }
  fs.renameSync(out + '.tmp.mp4', out); console.log(`part ${n} done in ${((Date.now() - t0) / 1000).toFixed(0)} s`);
}
if (only.length) process.exit(0);
const txt = path.join(outDir, `${fmt}-list.txt`); fs.writeFileSync(txt, list.map(f => `file '${f.replace(/\\/g, '/')}'`).join('\n'));
const audio = path.join(proj, 'assets', 'audio', fmt === 'short' ? 'final-mix-short.m4a' : 'final-mix.m4a');
const final = path.join(proj, 'renders', `muay-reborn-fable-${fmt}.mp4`);
const r = spawnSync('ffmpeg', ['-v', 'error', '-y', '-f', 'concat', '-safe', '0', '-i', txt, '-i', audio, '-map', '0:v', '-map', '1:a', '-c:v', 'copy', '-c:a', 'copy', '-shortest', '-movflags', '+faststart', final], { stdio: 'inherit' });
if (r.status !== 0) process.exit(1); console.log('DONE ->', final);
// deliver: copy the clip + thumbnail + titles/description into the user's Downloads folder
const dl = path.join(require('os').homedir(), 'Downloads', 'muay-reborn-fable'); fs.mkdirSync(dl, { recursive: true });
for (const f of [final, path.join(proj, 'renders', 'muay-reborn-fable-thumb.jpg'), path.join(proj, 'upload.md')]) if (fs.existsSync(f)) fs.copyFileSync(f, path.join(dl, path.basename(f)));
console.log('COPIED to', dl);
