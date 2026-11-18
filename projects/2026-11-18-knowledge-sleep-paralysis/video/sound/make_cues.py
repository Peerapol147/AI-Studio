#!/usr/bin/env python3
"""Writes sound/cues-th.json from the same word-locked times the composition uses (build_index.DATA).
One bundled CC0 sound per cue (.claude/skills/sound-effects/sfx/). The heartbeat is a separate stem (make_heart.py)."""
import json, pathlib, sys, contextlib, io
HERE = pathlib.Path(__file__).parent
sys.path.insert(0, str(HERE.parent))
with contextlib.redirect_stdout(io.StringIO()):
    import build_index as B
D = B.DATA
T = {k: v['start'] for k, v in D['sh'].items()}; H = {k: v['hit'] for k, v in D['sh'].items()}; K = D['k']
HOOKHIT = 0.5  # same constant as index.html.tpl
c = [
    (HOOKHIT, 'hover_or_small_ui', 'hook: fingers twitch, camera kick', 'tick/fs384187.ogg', -10),
    (T['frozen'], 'movement', 'camera dives onto the stuck hand', 'whoosh/fs393811.ogg', -14),
    (T['belief'], 'scene_cut', 'whip-pan to The Nightmare', 'whoosh/fs-683101-quick-woosh.ogg', -13),
    (T['truth'] - 0.8, 'build_up', 'riser into the lights coming on', 'riser/fs867126.ogg', -10),
    (T['truth'], 'scene_cut', 'match-cut back to the bedroom, lamp on', 'transition/fs-816262-broomstick-whoosh-3-quiet-okm1.ogg', -12),
    (T['lock'], 'scene_cut', 'zoom-through into the head', 'whoosh/fs-169867-swoosh.ogg', -13),
    (K['dream'], 'appear', 'dream bubble pops out', 'pop/fs-447910-plop.ogg', -10),
    (H['lock'], 'click', 'padlock snaps shut', 'click/fs788933.ogg', -4),
    (K['wake'], 'appear', 'brain lights up (awake)', 'riser/kenney-digital-powerup1.ogg', -12),
    (K['stuck'], 'hover_or_small_ui', 'padlock rattles', 'click/kenney-interface-select-003.ogg', -8),
    (T['shadow'], 'scene_cut', 'cross-section melts back into the dark room', 'transition/fs-683096-woosh.ogg', -15),
    (H['shadow'], 'appear', 'the shadow presses on the chest', 'impact/kenney-impact-impactsoft-heavy-001.ogg', -13),
    (T['risk'], 'scene_cut', 'whip-pan to the badge', 'whoosh/fs810485.ogg', -13),
    (K['nosleep'], 'hover_or_small_ui', 'clock ticks to 3:00', 'tick/fs528561.ogg', -6),
    (K['stress'], 'appear', 'badge morphs: stress', 'pop/kenney-interface-drop-002.ogg', -10),
    (K['supine'], 'appear', 'badge morphs: lying on the back', 'pop/kenney-interface-drop-003.ogg', -10),
    (T['doctor'], 'movement', 'badge morphs into the doctor', 'transition/fs-786514-swoosh-v2.ogg', -13),
    (K['doctor'], 'success', 'see a doctor', 'ding/fs-571513-soft-notifications-bell-ding-d.ogg', -12),
    (T['ask'], 'scene_cut', 'zoom-through back to the hook bedroom', 'whoosh/fs830856.ogg', -13),
    (K['ask'], 'appear', 'comment bubble pops', 'kit/pop.ogg', -8),
    (K['what'], 'appear', 'second question pops', 'pop/fs-824189-pop-in-sfx.ogg', -10),
]
out = [{'t': round(t, 3), 'type': ty, 'desc': d, 'sfx': f, 'gain': g} for t, ty, d, f, g in c]
for o in out:
    if o['type'] == 'build_up': o['dur'] = 0.8
(HERE / 'cues-th.json').write_text(json.dumps(out, indent=1, ensure_ascii=False))
print(len(out), 'cues')
