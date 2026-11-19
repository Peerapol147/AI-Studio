#!/usr/bin/env python3
"""Writes sound/cues-th.json from the same word-locked times the composition uses (build_index.DATA).
Storyboard sfx column, key moments only: year spins, mission ticks, money up/down, glitches. Files from the
sound-effects skill (CC0). Every cue sits on speech, so gains start low (DUCK, lesson from the brainrot mix)."""
import json, pathlib, sys, contextlib, io
HERE = pathlib.Path(__file__).resolve().parent
sys.path.insert(0, str(HERE.parent))
with contextlib.redirect_stdout(io.StringIO()):
    import build_index as B
D = B.DATA
T = {k: v['start'] for k, v in D['sh'].items()}; K = D['k']
OLAND = K['nai'] + 0.8
c = [
    (0.28, 'movement', 'year rolls back 2026 -> 2000 (VHS rewind)', 'glitch/fs-339521-vhs-rewind-forward-and-eject.ogg', -14),
    (K['pee'], 'error_or_tech', 'glitch: 2026 (cool) -> 2000 (sepia) on "ปี"', 'glitch/kenney-interface-glitch-002.ogg', -10),
    (K['y2000'], 'reveal', 'year lands on 2000 (punch)', 'impact/kenney-impact-impactsoft-heavy-000.ogg', -12),
    (T['wake_bed'], 'scene_cut', 'whip to the alarm clock, HUD flies in', 'whoosh/fs-683101-quick-woosh.ogg', -14),
    (K['roo'], 'appear', 'future-knowledge bubbles pop', 'pop/kenney-interface-pluck-001.ogg', -12),
    (K['wait'], 'error_or_tech', '"แต่เดี๋ยวนะ": age 33 -> 8 flips red', 'ui-blip/kenney-digital-twotone2.ogg', -10),
    (K['p2'], 'appear', '"ป.2" pops', 'pop/fs-824189-pop-in-sfx.ogg', -10),
    (K['maidai'], 'error_or_tech', 'lock shakes red on "ไม่ได้"', 'ui-blip/kenney-digital-pepsound2.ogg', -12),
    (K['m1'], 'success', 'mission 1 ticked', 'ding/kenney-interface-confirmation-001.ogg', -10),
    (K['hok'], 'success', 'gold 60,000+ lands, money meter up', 'ding/kenney-interface-glass-001.ogg', -10),
    (K['m2'], 'success', 'mission 2 ticked + up arrow', 'ding/kenney-interface-confirmation-002.ogg', -10),
    (K['panha'], 'success', 'SET ~1,500 lands, money meter up', 'ding/kenney-interface-glass-002.ogg', -10),
    (K['m3'], 'hover_or_small_ui', 'mission 3 starts pulsing (never ticked)', 'ui-blip/kenney-ui-rollover2.ogg', -12),
    (K['btc'], 'appear', 'bitcoin coin pops', 'pop/kenney-interface-maximize-001.ogg', -12),
    (K['kwa'], 'movement', 'year rolls forward 2000 -> 2010', 'glitch/fs-402451-fast-forward.ogg', -16),
    (K['rob'], 'appear', '"อีกรอบ!" stamp', 'impact/kenney-impact-impactpunch-heavy-000.ogg', -16),
    (T['crash'], 'error_or_tech', 'glitch cut to the crash', 'glitch/kenney-sci-computernoise-001.ogg', -14),
    (K['ruang'], 'reveal', 'money meter drops red, line falls', 'transition/kenney-interface-minimize-001.ogg', -10),
    (T['outro'], 'error_or_tech', 'glitch back to the alarm clock (outro)', 'glitch/kenney-interface-glitch-002.ogg', -12),
    (K['nai'] + 0.05, 'movement', 'year rolls 2010 -> 2026 (rewind, match of the hook)', 'riser/fs-174363-rewind.ogg', -16),
]
DUCK = -8
out = [{'t': round(t, 3), 'type': ty, 'desc': d, 'sfx': f, 'gain': g + DUCK} for t, ty, d, f, g in c]
(HERE / 'cues-th.json').write_text(json.dumps(out, indent=1, ensure_ascii=False))
print('th', len(out), 'cues')
