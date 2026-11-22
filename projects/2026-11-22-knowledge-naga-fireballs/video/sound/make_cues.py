#!/usr/bin/env python3
"""Writes sound/cues-th.json from the same word-locked times the composition uses (build_index.DATA).
Key moments only, one sound per cue, files from the sound-effects skill (CC0). No sfx while the voice says
"ไม่มีเสียง ไม่มีควัน" (s7, 13.52-15.99): the silence is the point.
Also writes assets/music-bed-th.wav (gitignored): the music with the twist (t1 -> t8, 29.5-45.5 s) 5 dB lower,
fades 0.4 s each side. tools/sound_pass_vo.py then ducks it under the voice as usual."""
import json, pathlib, sys, contextlib, io, subprocess
HERE = pathlib.Path(__file__).resolve().parent
sys.path.insert(0, str(HERE.parent))
with contextlib.redirect_stdout(io.StringIO()):
    import build_index as B
D = B.DATA
T = {k.split('_')[0]: v['start'] for k, v in D['sh'].items()}; H = {k.split('_')[0]: v['hit'] for k, v in D['sh'].items()}; K = D['k']
c = [  # t, type, desc, sfx, gain, [dur for build_up]
    (0.05, 'movement', 'hook: soft rise of the ball out of the river', 'whoosh/fs830856.ogg', -30),
    (H['s5'], 'appear', 'ball breaks the water on "ผุด" (plop, water)', 'pop/fs-447910-plop.ogg', -16),
    (T['s6'] + 0.25, 'appear', 'more balls surface along the river', 'pop/fs-447910-plop.ogg', -24),
    (T['s8'] + 0.05, 'movement', 'ball shoots up after the silent shot (soft whoosh)', 'whoosh/fs-683101-quick-woosh.ogg', -22),
    (T['s10'], 'build_up', 'naga shadow under the water (low eerie swell)', 'riser/fs-396161-scary-hits-risers-001.ogg', -24, 2.0),
    (K['chut'] + 0.12, 'appear', 'ball leaves the surface above the naga (water)', 'pop/fs-447910-plop.ogg', -18),
    (T['s12'], 'success', 'Buddha: soft bell', 'ding/fs-349504-triangle-open-04.ogg', -20),
    (T['t1'], 'reveal', 'twist: lights-on flash', 'impact/fs-177242-cinematic-impact.ogg', -16),
    (T['t2'], 'appear', 'hypothesis card pops', 'kit/pop.ogg', -18),
    (H['t4'], 'reveal', 'bubble catches fire on "ติดไฟ"', 'impact/kenney-impact-impactsoft-heavy-000.ogg', -18),
    (T['t5'], 'build_up', 'old TV static', 'glitch/kenney-sci-computernoise-000.ogg', -30, 2.4),
    (T['t6b'], 'movement', 'tracer rounds go up', 'whoosh/fs-169867-swoosh.ogg', -24),
    (K['khu'], 'error_or_tech', '"ขู่ฟ้อง!" glitch', 'glitch/kenney-interface-glitch-002.ogg', -14),
    (T['t8'] + 0.05, 'appear', 'three cards fly in', 'pop/kenney-interface-pluck-001.ogg', -20),
    (K['thukfai'], 'hover_or_small_ui', 'empty tick circles (nobody wins)', 'tick/fs384187.ogg', -20),
    (K['mikhon'], 'appear', '"มีคนทำ?" pops', 'kit/pop.ogg', -20),
    (T['c2'], 'appear', 'comment bubble pops', 'pop/fs-824189-pop-in-sfx.ogg', -20),
]
silent = (T['s7'], T['s8'])
out = []
for row in c:
    t, ty, d, f, g = row[:5]
    assert not (silent[0] <= t < silent[1]), ('sfx inside the silent shot', d)
    cue = {'t': round(t, 3), 'type': ty, 'desc': d, 'sfx': f, 'gain': g}
    if len(row) > 5: cue['dur'] = row[5]
    out.append(cue)
(HERE / 'cues-th.json').write_text(json.dumps(out, indent=1, ensure_ascii=False))
# music: "The crossroads of change" (zero-project, CC BY 3.0). The track fades in from silence over its first ~3.5 s,
# so the bed starts at 3.5 s into the track (already audible at -30 dB RMS, builds to full by ~8 s).
# sound_pass_vo.py then shifts the bed start by its beat search (prints "Music starts X s"): pass that X as env MUSIC_OFF
# so the twist dip lands at video time t1 -> t8.
TRACK_IN = 3.5
import os
off = float(os.environ.get("MUSIC_OFF", "0"))
a, b = T['t1'] + off, T['t8'] + off
vol = f"volume='if(between(t,{a-0.4:.2f},{b+0.4:.2f}),pow(10,-5/20*min(1,min(t-{a-0.4:.2f},{b+0.4:.2f}-t)/0.4)),1)':eval=frame"
subprocess.run(['ffmpeg', '-v', 'error', '-y', '-ss', str(TRACK_IN), '-i', str(HERE.parent / 'assets' / 'music-jamendo-1195819.mp3'), '-af', vol,
                str(HERE.parent / 'assets' / 'music-bed-th.wav')], check=True)
print('th', len(out), 'cues; music bed -5 dB', a, '->', b)
