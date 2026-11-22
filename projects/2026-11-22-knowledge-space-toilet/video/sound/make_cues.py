#!/usr/bin/env python3
"""Writes sound/cues-th.json from the same word-locked times the composition uses (build_index.DATA).
Key moments only (one sound per cue), files from the sound-effects skill (CC0). No fart / crude toilet sounds:
the blob uses soft plops/pops, the suction a reversed swoosh, the filter a bubble plop, the 98% a ding, the cup a glass clink."""
import json, pathlib, sys, contextlib, io
HERE = pathlib.Path(__file__).resolve().parent
sys.path.insert(0, str(HERE.parent))
with contextlib.redirect_stdout(io.StringIO()):
    import build_index as B
D = B.DATA
T = {k: v['start'] for k, v in D['sh'].items()}; K = D['k']
c = [
    (0.30, 'movement', 'hook: soft whoosh under the title (Cassidy card push-in)', 'whoosh/fs-683101-quick-woosh.ogg', -20),
    (T['what'] + 0.08, 'appear', 'worried drop pops in beside the astronaut', 'pop/fs-824189-pop-in-sfx.ogg', -13),
    (K['tod'], 'appear', 'drop puffs into the green cloud (callback, soft plop, not a fart sound)', 'pop/fs-447910-plop.ogg', -11),
    (K['ue'], 'reveal', 'cloud turns back into a HEAVY drop, squash + zoom punch', 'impact/kenney-impact-impactsoft-heavy-000.ogg', -16),
    (T['gravity'], 'scene_cut', 'whip to Pettit floating + "ไม่มีแรงโน้มถ่วง" pill', 'transition/fs-702773-swipe-wav.ogg', -17),
    (K['lomdut'], 'movement', 'fan spins up, blob sucked in a spiral (reversed swoosh = suck)', 'riser/fs-174363-rewind.ogg', -12),
    (K['kruai'] - 0.05, 'hover_or_small_ui', '"กรวย" label + arrow on the funnel photo', 'click/kenney-interface-toggle-001.ogg', -15),
    (K['thung'] + 0.12, 'appear', 'blob drops into the bag, neck ties shut', 'pop/kenney-interface-pluck-001.ogg', -13),
    (K['chok'], 'error_or_tech', 'glitch + shocked blob "!"', 'glitch/kenney-interface-glitch-002.ogg', -10),
    (K['thing'] - 0.04, 'appear', 'blob bounces out of the bin (red X)', 'pop/fs-258269-mouth-pop.ogg', -12),
    (T['filter'], 'movement', 'water-recovery rack, bubbles rise (bubble plop)', 'pop/fs527522.ogg', -14),
    (K['namduem'], 'success', 'drop turns clear blue, sparkle + "น้ำดื่ม" check pill', 'ding/fs-634690-lil-pip.ogg', -14),
    (K['y2023'], 'hover_or_small_ui', 'pill morphs to "NASA · 2023"', 'tick/fs384187.ogg', -14),
    (K['kao'] + 0.95, 'success', '98% ring completes (turns green)', 'ding/kenney-interface-confirmation-001.ogg', -15),
    (T['pettit'], 'scene_cut', 'whip to Don Pettit + name label', 'transition/fs-702773-swipe-wav.ogg', -18),
    (K['kafae'], 'appear', 'drop morphs into a coffee cup (cup clink)', 'ding/kenney-interface-glass-001.ogg', -14),
    (T['coffee'] + 0.05, 'hover_or_small_ui', 'Lindgren sips from the capillary cup (glass tap)', 'ding/kenney-interface-glass-002.ogg', -18),
    (T['comment'], 'appear', 'cup becomes the comment bubble', 'kit/pop.ogg', -14),
]
DUCK = -8  # every cue sits on speech (template rule): all -8 dB, then re-measured
out = [{'t': round(t, 3), 'type': ty, 'desc': d, 'sfx': f, 'gain': g + DUCK} for t, ty, d, f, g in c]
(HERE / 'cues-th.json').write_text(json.dumps(out, indent=1, ensure_ascii=False))
print('th', len(out), 'cues')
