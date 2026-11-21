#!/usr/bin/env python3
"""Writes sound/cues-th.json from the same word-locked times the composition uses (build_index.DATA).
Key moments only (one CC0 sound per cue, files from the sound-effects skill). energy-left episode."""
import json, pathlib, sys, contextlib, io
HERE = pathlib.Path(__file__).resolve().parent
sys.path.insert(0, str(HERE.parent))
with contextlib.redirect_stdout(io.StringIO()):
    import build_index as B
D = B.DATA
T = {k: v['start'] for k, v in D['sh'].items()}; H = {k: v['hit'] for k, v in D['sh'].items()}; K = D['k']
c = [
    (0.30, 'movement', 'hook: soft whoosh under the title, red battery blinking', 'whoosh/fs-683101-quick-woosh.ogg', -20),
    (T['believe'], 'scene_cut', 'whip to the traffic jam ("หลายคนเชื่อว่า")', 'whoosh/fs-127197-fast-simple-chop-5-aif.ogg', -14),
    (T['past'], 'error_or_tech', 'glitch cut to the old b/w pumpjack on "แต่"', 'glitch/kenney-interface-glitch-002.ogg', -12),
    (K['lue30'], 'appear', 'battery fills to "เหลือ 30 ปี"', 'pop/fs-824189-pop-in-sfx.ogg', -12),
    (K['sisip2'] + 0.05, 'hover_or_small_ui', 'counter 30->56 starts running', 'click/kenney-interface-tick-001.ogg', -14),
    (H['count2'], 'reveal', 'hit "ห้าสิบกว่าปีซะ": 56 pops + zoom punch', 'impact/kenney-impact-impactsoft-heavy-000.ogg', -22),
    (K['han'], 'appear', '÷ pops on "หารด้วย"', 'kit/pop.ogg', -14),
    (K['joe'], 'hover_or_small_ui', 'pill morphs to "เจอแหล่งใหม่"', 'ui-blip/kenney-digital-twotone2.ogg', -16),
    (T['now'], 'scene_cut', 'zoom cut to the city, bar splits into 4', 'whoosh/fs-683101-quick-woosh.ogg', -18),
    (K['oiln'], 'hover_or_small_ui', 'oil bar lands ~56', 'tick/fs384187.ogg', -16),
    (K['gasn'], 'hover_or_small_ui', 'gas bar lands ~48', 'tick/fs384187.ogg', -16),
    (K['coaln'], 'hover_or_small_ui', 'coal bar lands ~140', 'tick/fs384187.ogg', -16),
    (K['uran'], 'hover_or_small_ui', 'uranium bar lands ~85', 'tick/fs384187.ogg', -16),
    (K['maimod'], 'success', 'bar fills green "ไม่หมด ∞" + zoom punch', 'ding/kenney-interface-confirmation-001.ogg', -20),
    (K['mod2'], 'appear', 'fossil bars turn red on "หมด"', 'pop/kenney-interface-drop-002.ogg', -16),
    (K['palang'], 'hover_or_small_ui', 'switch light goes off, bulb off', 'click/kenney-interface-toggle-001.ogg', -14),
    (T['ask'], 'movement', 'back to the hook pumpjack + question', 'whoosh/fs-683101-quick-woosh.ogg', -22),
]
DUCK = -8  # every cue sits on speech (template rule after the brainrot review)
out = [{'t': round(t, 3), 'type': ty, 'desc': d, 'sfx': f, 'gain': g + DUCK} for t, ty, d, f, g in c]
(HERE / 'cues-th.json').write_text(json.dumps(out, indent=1, ensure_ascii=False))
print('th', len(out), 'cues')
