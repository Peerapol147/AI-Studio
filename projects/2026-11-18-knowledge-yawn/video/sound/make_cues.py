#!/usr/bin/env python3
"""Writes sound/cues-<lang>.json from the same word-locked times the composition uses (build_index.DATA)."""
import json, pathlib, sys, contextlib, io
HERE = pathlib.Path(__file__).parent
sys.path.insert(0, str(HERE.parent))
with contextlib.redirect_stdout(io.StringIO()):
    import build_index as B
for lang, D in B.DATA.items():
    T = {k: v['start'] for k, v in D['sh'].items()}; H = {k: v['hit'] for k, v in D['sh'].items()}
    K = D['k']
    c = [
        (H['hook'] - 0.04, 'appear', 'hook: yawn burst on the mouth', 'pop/fs-824189-pop-in-sfx.ogg', -9),
        (T['myth'], 'scene_cut', 'zoom-through into the head diagram', 'whoosh/fs-264777-swoosh.ogg', -13),
        (K['lack'], 'movement', 'O2 gauge drops red', 'transition/kenney-interface-minimize-001.ogg', -9),
        (T['mask'], 'scene_cut', 'match cut to the oxygen mask', 'whoosh/fs-683101-quick-woosh.ogg', -14),
        (T['pure'], 'scene_cut', 'zoom-through back to the diagram', 'whoosh/fs-169867-swoosh.ogg', -14),
        (K['pure'], 'success', 'gauge full: O2 100%', 'ding/kenney-interface-confirmation-001.ogg', -10),
        (T['same'], 'scene_cut', 'whip-pan to the second yawn', 'whoosh/fs810485.ogg', -13),
        (H['same'], 'appear', 'before/after bars level out', 'pop/kenney-interface-drop-001.ogg', -8),
        (T['idea'], 'scene_cut', 'zoom-through: brain heats up', 'whoosh/fs-127197-fast-simple-chop-5-aif.ogg', -13),
        (T['cool'] - 0.02, 'movement', 'cool air flows in, brain turns blue', 'transition/fs-786514-swoosh-v2.ogg', -11),
        (T['debate'], 'appear', 'question marks pop', 'pop/kenney-interface-pluck-001.ogg', -9),
        (T['warn'], 'scene_cut', 'whip-pan to the tired woman', 'whoosh/fs393811.ogg', -14),
        (T['ask'], 'scene_cut', 'zoom-through to the yawning cat', 'whoosh/fs830856.ogg', -14),
        (K['ask'], 'appear', 'comment bubble pops', 'kit/pop.ogg', -8),
    ]
    out = [{'t': round(t, 3), 'type': ty, 'desc': d, 'sfx': f, 'gain': g} for t, ty, d, f, g in c]
    (HERE / f'cues-{lang}.json').write_text(json.dumps(out, indent=1, ensure_ascii=False))
    print(lang, len(out), 'cues')
