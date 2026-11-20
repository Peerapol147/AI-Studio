#!/usr/bin/env python3
"""Writes sound/cues-th.json from the same word-locked times the composition uses (build_index.DATA).
One real sound per key moment (16 cues over 57 s, not every shot). Files from the sound-effects skill (CC0).
No cue uses type scene_cut/reveal on purpose: the sound pass then keeps the music at its own start (0 s of the
trimmed bed) instead of shifting it, so the baked quiet section (retire -> end, prep_assets.py) stays at 46.3 s."""
import json, pathlib, sys, contextlib, io
HERE = pathlib.Path(__file__).resolve().parent
sys.path.insert(0, str(HERE.parent))
with contextlib.redirect_stdout(io.StringIO()):
    import build_index as B
D = B.DATA
T = {k: v['start'] for k, v in D['sh'].items()}; H = {k: v['hit'] for k, v in D['sh'].items()}; K = D['k']
c = [
    (T['chat'] + 0.06, 'appear', 'group chat: first bubble pops', 'pop/kenney-interface-pluck-001.ogg', -18),
    (K['taek'], 'movement', 'chat panel cracks in two on "แตก"', 'impact/kenney-impact-impactsoft-heavy-000.ogg', -16),
    (K['thiang'] + 0.08, 'appear', 'two speech bubbles collide on "เถียง"', 'pop/fs-258269-mouth-pop.ogg', -16),
    (K['bdo'], 'hover_or_small_ui', 'golden balls drop into the year slots', 'ding/fs-634690-lil-pip.ogg', -20),
    (H['split55'], 'movement', '"5 : 5" scoreboard slams on "ห้าใบ"', 'impact/fs-222517-dramatic-hit.ogg', -18),
    (K['ngan'], 'success', 'boxing bell rings on "งั้น"', 'ding/fs-349504-triangle-open-04.ogg', -12),
    (H['bell'], 'movement', 'gloves collide on "หมัด"', 'impact/kenney-impact-impactpunch-heavy-000.ogg', -14),
    (K['pidiao'], 'hover_or_small_ui', 'counter rolls to 91', 'tick/fs384187.ogg', -18),
    (K['guin'], 'movement', '"สถิติโลก" stamp lands', 'impact/kenney-impact-impactsoft-heavy-001.ogg', -16),
    (K['suan'], 'movement', 'CR7 counter-punch glove on "สวน"', 'impact/kenney-impact-impactpunch-heavy-001.ogg', -14),
    (K['n140'], 'hover_or_small_ui', 'counter rolls to 140', 'tick/fs384187.ogg', -18),
    (K['paetbai'], 'success', '8 golden balls pop in', 'ding/kenney-interface-confirmation-001.ogg', -20),
    (K['n146'], 'hover_or_small_ui', 'counter rolls to 146 (hit)', 'tick/fs384187.ogg', -18),
    (K['samat'], 'movement', '"3 : 3" scoreboard, split back to centre', 'impact/fs-177242-cinematic-impact.ogg', -18),
    (T['retire'], 'movement', 'tone change: soft whoosh into black and white', 'transition/fs-816262-broomstick-whoosh-3-quiet-okm1.ogg', -16),
    (H['lucky'], 'success', 'colour returns, "โชคดีที่สุด" shimmer', 'ding/fs-571513-soft-notifications-bell-ding-d.ogg', -20),
    (T['cta'] + 0.08, 'appear', 'team buttons pop', 'pop/fs-824189-pop-in-sfx.ogg', -18),
]
out = [{'t': round(t, 3), 'type': ty, 'desc': d, 'sfx': f, 'gain': g} for t, ty, d, f, g in c]
(HERE / 'cues-th.json').write_text(json.dumps(out, indent=1, ensure_ascii=False))
print('th', len(out), 'cues')
