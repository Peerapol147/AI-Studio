#!/usr/bin/env python3
"""Writes sound/cues-th.json from the same word-locked times the composition uses (build_index.DATA).
Key moments only (one sound per cue), files from the sound-effects skill (CC0). Every cue sits on or next to speech,
so all cues get DUCK (template review 2026-11-19: SFX masked the voice at -0..-4 dB)."""
import json, pathlib, sys, contextlib, io
HERE = pathlib.Path(__file__).resolve().parent
sys.path.insert(0, str(HERE.parent))
with contextlib.redirect_stdout(io.StringIO()):
    sys.argv = [sys.argv[0], '--out', '/dev/null']
    import build_index as B
D = B.DATA
T = {k: v['start'] for k, v in D['sh'].items()}; K = D['k']
c = [
    (0.30, 'movement', 'hook: soft whoosh under the title, year chip starts counting', 'whoosh/fs-683101-quick-woosh.ogg', -20),
    (K['y2070'], 'appear', 'year chip lands on 2070 + punch-in', 'pop/fs-824189-pop-in-sfx.ogg', -12),
    (T['s02'] - 0.06, 'scene_cut', 'whip to grandma laughing', 'transition/fs-702773-swipe-wav.ogg', -16),
    (K['tiktok'], 'appear', 'phone frame, hearts float', 'pop/kenney-interface-pluck-001.ogg', -14),
    (K['y1997'], 'appear', 'timeline node 1997 pops', 'pop/kenney-interface-drop-001.ogg', -12),
    (K['y2012'], 'appear', 'timeline node 2012 pops, bar fills', 'pop/kenney-interface-drop-003.ogg', -12),
    (T['s06'], 'reveal', '"2070" chip jumps to the centre (zoom punch)', 'impact/kenney-impact-impactsoft-heavy-001.ogg', -16),
    (T['s07'] - 0.06, 'scene_cut', 'whip into split screen 1', 'whoosh/fs-169867-swoosh.ogg', -18),
    (K['jan'], 'appear', 'chat bubble "สวัสดีวันจันทร์" pops', 'pop/fs-447910-plop.ogg', -12),
    (T['s09'], 'success', 'right panel "Gen Z" opens', 'ding/fs-634690-lil-pip.ogg', -16),
    (K['dek'], 'hover_or_small_ui', 'counter runs to 462,240', 'click/kenney-interface-tick-001.ogg', -14),
    (T['s14'] - 0.06, 'scene_cut', 'whip into split screen 2', 'transition/fs-850347-swipe-various.ogg', -18),
    (K['ha'], 'error_or_tech', '"หา?" shakes on the man in headphones', 'glitch/kenney-interface-glitch-002.ogg', -14),
    (K['phan'], 'hover_or_small_ui', 'counter runs to 1,000 ล้าน', 'click/kenney-interface-select-002.ogg', -14),
    (T['s20'] - 0.06, 'scene_cut', 'whip into split screen 3', 'whoosh/fs830856.ogg', -18),
    (K['y2050'], 'appear', '2050 pops', 'pop/kenney-interface-maximize-001.ogg', -13),
    (T['s24'], 'movement', 'myopic blur -> sharp', 'riser/fs-174363-rewind.ogg', -18),
    (T['s25'], 'error_or_tech', 'serious turn: glitch cut to the dark ear scene', 'glitch/kenney-sci-computernoise-000.ogg', -16),
    (K['bao'], 'hover_or_small_ui', 'volume slider slides down', 'ui-blip/kenney-ui-rollover2.ogg', -14),
    (K['mai'], 'reveal', '"ถาวร" lands (zoom punch)', 'impact/kenney-impact-impactsoft-heavy-000.ogg', -16),
    (T['s28'] - 0.06, 'scene_cut', 'whip to the dancing couple', 'transition/fs-786514-swoosh-v2.ogg', -18),
    (K['ment'], 'appear', '"เมนต์บอกหน่อย" pops in the comment bubble', 'kit/pop.ogg', -16),
]
DUCK = -8
out = [{'t': round(t, 3), 'type': ty, 'desc': d, 'sfx': f, 'gain': g + DUCK} for t, ty, d, f, g in c]
(HERE / 'cues-th.json').write_text(json.dumps(out, indent=1, ensure_ascii=False))
print('th', len(out), 'cues')
