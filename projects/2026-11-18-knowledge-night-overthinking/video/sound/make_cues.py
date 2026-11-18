#!/usr/bin/env python3
"""Writes sound/cues-th.json from the same word-locked times the composition uses (build_index.DATA).
Soft and quiet on purpose (viewer is in bed at 3 a.m.): 6 cues, no hard pops or bright dings.
No 'scene_cut'/'reveal' types, so tools/sound_pass_vo.py keeps the music at offset 0 of assets/music-bed.mp3
(= 2.5 s into the original track, past its fade-in)."""
import json, pathlib, sys, contextlib, io
HERE = pathlib.Path(__file__).parent
sys.path.insert(0, str(HERE.parent))
with contextlib.redirect_stdout(io.StringIO()):
    import build_index as B
D = B.DATA; K = D['k']; H = {k: v['hit'] for k, v in D['sh'].items()}
c = [
    (H['small'], 'movement', 'thought bubble swells on "ใหญ่"', 'transition/fs-816262-broomstick-whoosh-3-quiet-okm1.ogg', -16),
    (H['brain'], 'movement', 'emotion spot pulses harder on "ไวขึ้น"', 'impact/kenney-impact-impactsoft-heavy-000.ogg', -20),
    (K['loop'], 'movement', 'bubble orbits the head on "วน"', 'whoosh/fs-264777-swoosh.ogg', -20),
    (K['lighter'], 'appear', 'dawn light, bubble shrinks on "เบาลง"', 'ding/fs-349504-triangle-open-04.ogg', -24),
    (K['phone2'] + 0.2, 'appear', 'phone lands face down (soft tap)', 'pop/kenney-interface-drop-001.ogg', -18),
    (K['now'], 'appear', 'comment bubble settles', 'pop/fs-447910-plop.ogg', -22),
]
out = [{'t': round(t, 3), 'type': ty, 'desc': d, 'sfx': f, 'gain': g} for t, ty, d, f, g in c]
(HERE / 'cues-th.json').write_text(json.dumps(out, indent=1, ensure_ascii=False))
print('th', len(out), 'cues')
