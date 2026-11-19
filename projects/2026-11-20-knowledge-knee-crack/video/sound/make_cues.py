#!/usr/bin/env python3
"""Writes sound/cues-th.json from the same word-locked times the composition uses (build_index.DATA)."""
import json, pathlib, sys, contextlib, io
HERE = pathlib.Path(__file__).parent
sys.path.insert(0, str(HERE.parent))
with contextlib.redirect_stdout(io.StringIO()):
    import build_index as B
D = B.DATA
T = {k: v['start'] for k, v in D['sh'].items()}; H = {k: v['hit'] for k, v in D['sh'].items()}; K = D['k']
c = [
    (H['hook'], 'appear', 'hook: knee ring flashes on "กร๊อบ" (crack)', 'click/fs788933.ogg', -6),
    (T['oa-q'], 'scene_cut', 'zoom-through into the knee diagram, red + ?', 'whoosh/fs-264777-swoosh.ogg', -12),
    (T['tease'], 'scene_cut', 'whip to the elder remark bubble', 'whoosh/fs-683101-quick-woosh.ogg', -12),
    (K['tak'], 'appear', 'remark bubble shakes on "ทัก"', 'pop/fs-824189-pop-in-sfx.ogg', -10),
    (T['dry'], 'scene_cut', 'whip back to the knee', 'whoosh/fs810485.ogg', -13),
    (K['dry'], 'movement', 'synovial fluid drains on "แห้ง"', 'transition/kenney-interface-minimize-001.ogg', -9),
    (T['truth'], 'success', 'red -> blue, fluid refills (ความจริง)', 'ding/kenney-interface-confirmation-001.ogg', -10),
    (T['common'], 'scene_cut', 'whip to seniors exercising', 'whoosh/fs393811.ogg', -13),
    (K['nopain'], 'success', 'chip turns green: ไม่เจ็บ ก็ดังได้', 'ding/kenney-interface-glass-001.ogg', -11),
    (T['gas'], 'scene_cut', 'zoom-through into the joint, sound ripples', 'whoosh/fs-169867-swoosh.ogg', -13),
    (K['gas'], 'appear', 'small gas bubbles bloom', 'pop/fs-447910-plop.ogg', -8),
    (H['tendon'], 'appear', 'tendon snaps over the bony bump on "ลาก"', 'pop/fs-258269-mouth-pop.ogg', -5),
    (T['study'], 'scene_cut', 'whip to the lab', 'whoosh/fs830856.ogg', -13),
    (T['bars'], 'scene_cut', 'zoom-through to the x-ray + bars card', 'transition/fs-702773-swipe-wav.ogg', -13),
    (K['often2'], 'movement', 'bar "ดังบ่อย" grows', 'transition/kenney-interface-maximize-005.ogg', -10),
    (K['risk'], 'reveal', 'bar "เสี่ยงเข่าเสื่อม" grows, joint space glows red', 'impact/kenney-impact-impactsoft-heavy-000.ogg', -9),
    (K['ok'], 'success', 'green check on "ไม่เจ็บ"', 'ding/kenney-interface-confirmation-002.ogg', -10),
    (T['rule-pain'], 'scene_cut', 'whip to hands on the sore knee', 'whoosh/fs-127197-fast-simple-chop-5-aif.ogg', -13),
    (H['rule-pain'], 'reveal', 'punch-in on "บวม"', 'impact/kenney-impact-impactpunch-heavy-000.ogg', -10),
    (T['stiff'], 'error_or_tech', 'badge morphs to the red warning', 'ui-blip/kenney-digital-twotone1.ogg', -10),
    (T['doctor'], 'scene_cut', 'whip to the nurse checking the knee', 'whoosh/fs-683101-quick-woosh.ogg', -13),
    (T['cta'], 'scene_cut', 'zoom-through back to the hook frame', 'whoosh/fs-264777-swoosh.ogg', -13),
    (K['ask'], 'appear', 'comment bubble pops', 'kit/pop.ogg', -8),
]
out = [{'t': round(t, 3), 'type': ty, 'desc': d, 'sfx': f, 'gain': g} for t, ty, d, f, g in c]
(HERE / 'cues-th.json').write_text(json.dumps(out, indent=1, ensure_ascii=False))
print('th', len(out), 'cues')
