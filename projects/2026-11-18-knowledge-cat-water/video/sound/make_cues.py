#!/usr/bin/env python3
"""Writes sound/cues-th.json from the same word-locked times the composition uses (build_index.DATA)."""
import json, pathlib, sys, contextlib, io
HERE = pathlib.Path(__file__).resolve().parent
sys.path.insert(0, str(HERE.parent))
with contextlib.redirect_stdout(io.StringIO()):
    import build_index as B
D = B.DATA
T = {k: v['start'] for k, v in D['sh'].items()}; H = {k: v['hit'] for k, v in D['sh'].items()}; K = D['k']
c = [
    (0.42, 'appear', 'hook: droplets pop at the glass rim', 'pop/fs-447910-plop.ogg', -14),
    (T['belief'], 'scene_cut', 'whip-pan to the cat by the sea', 'whoosh/fs-683101-quick-woosh.ogg', -14),
    (K['belief'], 'appear', 'pill "ความเชื่อ" springs in', 'pop/kenney-interface-pluck-001.ogg', -13),
    (T['fishing'], 'scene_cut', 'zoom-through to the fishing cat card', 'whoosh/fs-264777-swoosh.ogg', -14),
    (K['truth'], 'success', 'pill morphs to green "ความจริง ✅"', 'ding/kenney-interface-confirmation-001.ogg', -12),
    (K['fcat'], 'appear', 'name tag "เสือปลา"', 'kit/pop.ogg', -12),
    (K['thai'], 'hover_or_small_ui', 'Thailand map lens pops', 'tick/fs384187.ogg', -12),
    (K['dive'], 'appear', 'fish leaps + splash on "ดำน้ำ"', 'pop/fs-447910-plop.ogg', -7),
    (T['van'], 'scene_cut', 'whip-pan to the Turkish Van card', 'whoosh/fs810485.ogg', -14),
    (K['van'], 'hover_or_small_ui', 'name tag "เตอร์กิชแวน" slides in', 'tick/fs528561.ogg', -10),
    (K['play'], 'appear', 'faucet splash on "เล่นน้ำ"', 'pop/kenney-interface-drop-002.ogg', -11),
    (T['vet'], 'scene_cut', 'whip-pan to the damp cat', 'whoosh/fs393811.ogg', -14),
    (K['vet'], 'appear', 'pill "สัตวแพทย์"', 'pop/kenney-interface-pluck-002.ogg', -13),
    (T['fur'], 'scene_cut', 'zoom-through into the fur diagram', 'whoosh/fs-169867-swoosh.ogg', -14),
    (K['fur'] + 0.1, 'appear', 'drops start filling the cat', 'pop/kenney-interface-drop-001.ogg', -14),
    (H['fur'], 'reveal', 'thud: cat sinks, gauge swings on "หนัก"', 'impact/kenney-impact-impactsoft-heavy-000.ogg', -7),
    (K['dryslow'], 'hover_or_small_ui', 'dial becomes a clock on "แห้งช้า"', 'tick/fs721514.ogg', -10),
    (T['ancestor'], 'scene_cut', 'whip-pan to the wild ancestor', 'whoosh/fs830856.ogg', -14),
    (K['anc'], 'appear', 'name tag "บรรพบุรุษแมวบ้าน"', 'kit/pop.ogg', -13),
    (T['dry'], 'movement', 'map lens grows over the dry land (soft wind)', 'transition/fs-816262-broomstick-whoosh-3-quiet-okm1.ogg', -9),
    (T['guess'], 'scene_cut', 'zoom-through to the kitten at the water', 'whoosh/fs-127197-fast-simple-chop-5-aif.ogg', -15),
    (K['guess'], 'appear', 'pill "สมมติฐาน"', 'pop/kenney-interface-pluck-001.ogg', -13),
    (T['swim'], 'scene_cut', 'whip-pan to the cat at the pool', 'whoosh/fs-683101-quick-woosh.ogg', -14),
    (K['swim'], 'appear', 'pool splash on "ว่ายน้ำได้"', 'pop/kenney-interface-drop-003.ogg', -10),
    (K['just'], 'appear', 'boing: zoom into the face', 'pop/fs-258269-mouth-pop.ogg', -10),
    (T['ask'], 'scene_cut', 'zoom-through to the tabby', 'whoosh/fs-264777-swoosh.ogg', -14),
    (K['b1'], 'appear', 'button "ทีมเล่นน้ำ 💦"', 'kit/pop.ogg', -9),
    (K['b2'], 'appear', 'button "ทีมข่วน 😾"', 'pop/fs-824189-pop-in-sfx.ogg', -9),
]
out = [{'t': round(t, 3), 'type': ty, 'desc': d, 'sfx': f, 'gain': g} for t, ty, d, f, g in c]
(HERE / 'cues-th.json').write_text(json.dumps(out, indent=1, ensure_ascii=False))
print('th', len(out), 'cues')
