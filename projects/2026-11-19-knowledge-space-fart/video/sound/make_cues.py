#!/usr/bin/env python3
"""Writes sound/cues-th.json from the same word-locked times the composition uses (build_index.DATA).
Key moments only (one sound per cue), files from the sound-effects skill (CC0). No realistic/crude fart sound:
the cloud uses soft plop/pop sounds."""
import json, pathlib, sys, contextlib, io
HERE = pathlib.Path(__file__).resolve().parent
sys.path.insert(0, str(HERE.parent))
with contextlib.redirect_stdout(io.StringIO()):
    import build_index as B
D = B.DATA
T = {k: v['start'] for k, v in D['sh'].items()}; K = D['k']
c = [
    (0.30, 'movement', 'hook: soft whoosh under the title (astronaut card, small puff)', 'whoosh/fs-683101-quick-woosh.ogg', -20),
    (K['kerd'], 'appear', 'cloud puffs up beside the astronaut + "?" (soft plop)', 'pop/fs-447910-plop.ogg', -12),
    (K['chuea'], 'appear', 'pill "ความเชื่อ" pops', 'pop/fs-824189-pop-in-sfx.ogg', -13),
    (K['tidiao'], 'appear', 'cloud bursts on "ทีเดียว" (soft pop, not a fart sound)', 'kit/pop.ogg', -11),
    (T['rocket'], 'movement', 'zoom-through to the rocket launch (rocket whoosh)', 'whoosh/fs-264777-swoosh.ogg', -10),
    (T['hadfield'], 'scene_cut', 'whip to Chris Hadfield + name label', 'transition/fs-702773-swipe-wav.ogg', -17),
    (K['phon'], 'error_or_tech', 'glitch + stamp: pill morphs to "ไม่ได้ผล"', 'glitch/kenney-interface-glitch-002.ogg', -10),
    (K['phaeo'], 'movement', 'cloud deflates to a wisp on "แผ่ว"', 'transition/kenney-interface-minimize-001.ogg', -14),
    (T['nozzle'], 'scene_cut', 'zoom to the RS-25 nozzle photo', 'whoosh/fs-127197-fast-simple-chop-5-aif.ogg', -14),
    (K['panha'], 'reveal', 'zoom punch "ปัญหาจริงๆ"', 'impact/kenney-impact-impactsoft-heavy-000.ogg', -16),
    (K['klin'], 'appear', 'cloud swells green on "กลิ่น" (soft plop)', 'pop/fs-447910-plop.ogg', -10),
    (K['phatlom0'], 'hover_or_small_ui', 'fan off: red slash', 'click/kenney-interface-toggle-001.ogg', -15),
    (K['phatlom'], 'movement', 'fan spins up, air pulled in (short airy whoosh)', 'transition/fs-816262-broomstick-whoosh-3-quiet-okm1.ogg', -9),
    (K['saikrong'], 'success', 'charcoal filter ✅ pill', 'ding/kenney-interface-confirmation-001.ogg', -15),
    (K['jalong'] + 0.1, 'appear', '"?" pops over the small cloud', 'pop/kenney-interface-pluck-001.ogg', -15),
    (T['comment'], 'appear', 'cloud becomes the comment bubble', 'kit/pop.ogg', -14),
]
DUCK = -8  # every cue sits on speech (template rule): all -8 dB, then re-measured
out = [{'t': round(t, 3), 'type': ty, 'desc': d, 'sfx': f, 'gain': g + DUCK} for t, ty, d, f, g in c]
(HERE / 'cues-th.json').write_text(json.dumps(out, indent=1, ensure_ascii=False))
print('th', len(out), 'cues')
