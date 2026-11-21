// DOM overlay driven by EP.overlay(t) hooks: subtitles, bubbles, tag, move card, fx words, title, end question.
/* global A, DATA, EP */
window.overlay = (t) => {
  const $ = id => document.getElementById(id);
  const shot = EP.shots.find(s => t >= s.t0 && t < s.t1) || EP.shots[EP.shots.length - 1], lt = t - shot.t0;
  const sp = (x, w = 20, z = 0.5) => A.spring(x, w, z);
  // subtitles
  const s = (DATA.subs || []).find(c => t >= c.t0 && t < c.t1), sub = $('sub');
  if (s && !shot.noSub) { sub.style.display = 'block'; const who = EP.NAMES_AT ? EP.NAMES_AT(s.v, t) : (EP.NAMES || {})[s.v]; sub.innerHTML = (who ? `<i style="color:${EP.COL[s.v] || '#fff'}">${who}</i>` : '') + s.text; sub.style.color = EP.COL[s.v] || '#fff';
    // one line, never broken mid-word: shrink long lines to fit (Thai marks above/below don't take width)
    const n = s.text.replace(/[\u0E31\u0E34-\u0E3A\u0E47-\u0E4E]/g, '').length, base = FMT.name === 'short' ? 64 : (shot.bars ? 44 : 56), room = FMT.name === 'short' ? 960 : 1760;
    sub.style.fontSize = Math.min(base, Math.floor(room / (n * 0.56))) + 'px'; }
  else sub.style.display = 'none';
  // tag
  const tg = $('tag'), tag = shot.tag && (!shot.tag.at || lt >= shot.tag.at) ? shot.tag : null;
  tg.style.display = tag ? 'block' : 'none'; if (tag) { tg.innerHTML = tag.text + (tag.sub ? `<small>${tag.sub}</small>` : ''); tg.style.background = tag.col || '#ffd23f'; tg.style.transform = `scale(${0.6 + 0.4 * sp(lt - (tag.at || 0), 18)})`; }
  // move card
  const mv = $('move'), card = (EP.moves || []).find(m => t >= m.t0 && t < m.t1);
  mv.style.display = card ? 'block' : 'none';
  if (card) { mv.querySelector('.n').textContent = card.name; const k = sp(t - card.t0, 16, 0.42); mv.style.transform = `scale(${1.6 - 0.6 * k}) rotate(${-3 * (1 - k)}deg)`; mv.style.opacity = Math.min(1, (card.t1 - t) / 0.2); }
  // bubbles + fx words: EP.bubbles / EP.fx entries {t0,t1,text,x,y,kind,tx}
  const bb = $('bubs'); bb.innerHTML = '';
  for (const b of (EP.bubbles || [])) if (t >= b.t0 && t < b.t1) { const d = document.createElement('div'); d.className = 'bub ' + (b.kind || ''); d.textContent = b.text;
    d.style.left = b.x + 'px'; d.style.top = b.y + 'px'; if (b.tx) d.style.setProperty('--tx', b.tx); if (b.col) d.style.borderColor = b.col; d.style.transform = `translate(-50%,-100%) scale(${0.5 + 0.5 * sp(t - b.t0, 22, 0.45)})`; bb.appendChild(d); }
  const fx = $('fxs'); fx.innerHTML = '';
  for (const f of (EP.fx || [])) if (t >= f.t0 && t < f.t1) { const d = document.createElement('div'); d.className = 'fx ' + (f.cls || ''); if (f.html) d.innerHTML = f.text; else d.textContent = f.text; const sx = FMT.name === 'short' ? 540 + (f.x - 960) * 0.56 : f.x, sy = FMT.name === 'short' ? 960 + (f.y - 540) * 1.1 : f.y; d.style.left = sx + 'px'; d.style.top = sy + 'px';
    if (f.size) d.style.fontSize = f.size + 'px'; d.style.transform = `translate(-50%,-50%) rotate(${f.rot || -8}deg) scale(${0.4 + 0.75 * sp(t - f.t0, 26, 0.35)})`; fx.appendChild(d); }
  // title / hook text / end question
  const ti = $('title'); ti.style.display = shot.title ? 'flex' : 'none'; if (shot.title) ti.style.transform = `scale(${0.9 + 0.1 * sp(lt, 12, 0.5) + 0.01 * lt})`;
  const hk = $('hook'); hk.style.display = shot.hook ? 'block' : 'none'; if (shot.hook) { hk.textContent = shot.hook; if (shot.thumb) { hk.style.fontSize = '170px'; hk.style.color = '#ffe24a'; hk.style.top = '40px'; } hk.style.transform = `translateX(-50%) scale(${1 + 0.03 * Math.sin(t * 5)})`; }
  const eq = $('endq'); eq.style.display = shot.endq ? 'block' : 'none';
  if (shot.endq) { eq.querySelector('.a').textContent = shot.endq[0]; eq.querySelector('.b').innerHTML = shot.endq[1]; eq.style.transform = `translate(-50%,-50%) scale(${0.85 + 0.15 * sp(lt, 14)})`; }
  const vg = $('vig'); vg.style.display = shot.vig ? 'block' : 'none'; if (shot.vig) vg.style.opacity = shot.vig;
  $('sepia').style.display = shot.sepia ? 'block' : 'none'; $('bars').style.display = shot.bars ? 'block' : 'none'; document.querySelector('main').classList.toggle('bars', !!shot.bars);
  { const g = $('grain'), x = g.getContext('2d'), im = x.createImageData(480, 270); let r = (Math.floor(t * 24) * 2654435761) >>> 0; for (let i = 0; i < im.data.length; i += 4) { r ^= r << 13; r ^= r >>> 17; r ^= r << 5; const v = (r >>> 0) & 255; im.data[i] = im.data[i + 1] = im.data[i + 2] = v; im.data[i + 3] = 255; } x.putImageData(im, 0, 0); }
  $('flash').style.opacity = shot.flash ? Math.max(0, 1 - lt / shot.flash) : 0;
  if (EP.overlayExtra) EP.overlayExtra(t, shot, lt);
};
