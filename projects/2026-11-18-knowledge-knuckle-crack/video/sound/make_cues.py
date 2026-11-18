#!/usr/bin/env python3
"""Writes sound/cues-<lang>.json from the same word-locked times the composition uses (build_index.DATA)."""
import json, pathlib, sys, contextlib, io
HERE = pathlib.Path(__file__).parent
sys.path.insert(0, str(HERE.parent))
with contextlib.redirect_stdout(io.StringIO()):
    import build_index as B
HOOKHIT = 0.45  # same constant as index.html.tpl
for lang, D in B.DATA.items():
    T = {k: v['start'] for k, v in D['sh'].items()}; H = {k: v['hit'] for k, v in D['sh'].items()}
    W = {k: v['word'] for k, v in D['sh'].items()}; K = D['k']
    c = [
        (HOOKHIT, 'appear', 'hook: x-ray lens + crack burst', 'click/fs788933.ogg', -6),
        (T['elder'], 'scene_cut', 'whip-pan to the stern elder', 'whoosh/fs-683101-quick-woosh.ogg', -12),
        (H['grind'], 'movement', 'bones grind, red sparks', 'transition/fs-702773-swipe-wav.ogg', -12),
        (T['truth'], 'scene_cut', 'zoom-through from the x-ray into the joint', 'whoosh/fs-264777-swoosh.ogg', -12),
        (W['fluid'], 'appear', 'synovial fluid shimmers', 'pop/kenney-interface-drop-001.ogg', -10),
        (H['pull'], 'movement', 'bones slide apart', 'whoosh/fs-127197-fast-simple-chop-5-aif.ogg', -11),
        (H['press'], 'movement', 'gauge needle drops', 'transition/kenney-interface-scroll-001.ogg', -9),
        (H['bubble'], 'appear', 'gas bubble blooms', 'pop/fs-447910-plop.ogg', -7),
        (K['pop'], 'appear', 'knuckle crack: punch-in + shake', 'pop/fs-258269-mouth-pop.ogg', -4),
        (T['doctor'], 'scene_cut', 'whip-pan to the doctor', 'whoosh/fs810485.ogg', -13),
        (T['decades'], 'scene_cut', 'zoom-through into the two hands', 'whoosh/fs-169867-swoosh.ogg', -13),
        (K['none'], 'success', 'left hand check', 'ding/kenney-interface-confirmation-001.ogg', -10),
        (H['noarth'], 'success', 'right hand check', 'ding/kenney-interface-glass-001.ogg', -10),
        (T['hurt'], 'scene_cut', 'whip-pan to the sore wrist', 'whoosh/fs393811.ogg', -13),
        (T['ask'], 'scene_cut', 'zoom-through back to the hook hands', 'whoosh/fs830856.ogg', -13),
        (K['ask'], 'appear', 'comment bubble pops', 'kit/pop.ogg', -8),
    ]
    out = [{'t': round(t, 3), 'type': ty, 'desc': d, 'sfx': f, 'gain': g} for t, ty, d, f, g in c]
    (HERE / f'cues-{lang}.json').write_text(json.dumps(out, indent=1, ensure_ascii=False))
    print(lang, len(out), 'cues')
