#!/usr/bin/env python3
"""cues-th.json from the built index.html word-time table (const W) + shots-th.json (run after build_index.py)."""
import json, re, pathlib
H = pathlib.Path(__file__).resolve().parent.parent
W = json.loads(re.search(r'const W=(\{.*?\});', (H / 'index.html').read_text()).group(1))
S = {s['id']: s for s in json.load(open(H.parent / 'assets/audio/shots-th.json'))['shots']}
C = [(S['hook']['end'] - 0.42, 'scene_cut', 'hook: zoom into Thailand', 'whoosh/fs-683101-quick-woosh.ogg', -24),
     (W['colon'], 'appear', 'coloniser labels pop (ชาติตะวันตก)', 'pop/kenney-interface-drop-002.ogg', -24),
     (S['guess']['start'], 'scene_cut', 'whip to the world map', 'transition/fs-702773-swipe-wav.ogg', -26),
     (W['def'], 'appear', 'definition card', 'pop/fs-824189-pop-in-sfx.ogg', -24),
     (W['guessq'], 'appear', 'big ? over the magnifier', 'pop/kenney-interface-drop-001.ogg', -22),
     (W['q3'], 'appear', '3 question marks (สามประเทศ)', 'pop/kenney-interface-drop-002.ogg', -22),
     (S['r4']['start'], 'appear', 'rank 4 badge', 'pop/fs-447910-plop.ogg', -20),
     (W['c4'], 'hover_or_small_ui', 'chip 2357-2359', 'tick/fs384187.ogg', -24),
     (W['s4'], 'appear', 'stamp ยังเป็นเอกราช', 'ding/kenney-interface-confirmation-001.ogg', -24),
     (S['r3']['start'], 'appear', 'rank 3 badge', 'pop/fs-447910-plop.ogg', -20),
     (W['c3a'], 'hover_or_small_ui', 'chip 2450', 'tick/fs384187.ogg', -24),
     (W['s3'], 'appear', 'stamp ยึดครอง ≠ เมืองขึ้น', 'ding/kenney-interface-confirmation-001.ogg', -24),
     (S['r2']['start'], 'appear', 'rank 2 badge', 'pop/fs-447910-plop.ogg', -20),
     (W['c2'], 'hover_or_small_ui', 'chip 2488-2495', 'tick/fs384187.ogg', -24),
     (W['s2'], 'appear', 'stamp ไม่เคยเป็นอาณานิคม', 'ding/kenney-interface-confirmation-001.ogg', -24),
     (S['r1']['start'], 'appear', 'rank 1 number', 'pop/fs-447910-plop.ogg', -21),
     (W['r1n'], 'reveal', '1 ไทย big pop (ไทยเรา) impact', 'impact/fs-177242-cinematic-impact.ogg', -19),
     (W['c1'], 'hover_or_small_ui', 'chip ร.5', 'tick/fs384187.ogg', -25),
     (W['uk'], 'scene_cut', 'arrows squeeze in (บีบมาสองฝั่ง)', 'transition/fs-786514-swoosh-v2.ogg', -25),
     (W['tw'], 'reveal', 'low hit: รอดได้ แต่ต้องแลก', 'impact/fs-222517-dramatic-hit.ogg', -20),
     (S['tw_mekong']['start'], 'scene_cut', 'whip to the Mekong', 'whoosh/fs-683101-quick-woosh.ogg', -24),
     (S['tw_malay']['start'], 'scene_cut', 'whip to the Malay map', 'whoosh/fs-169867-swoosh.ogg', -26),
     (W['tai'], 'appear', 'ไท = อิสระ shimmer', 'ding/fs-349504-triangle-open-04.ogg', -28),
     (W['ctaq'], 'appear', 'ควรติดอีกไหม? pill', 'pop/fs-824189-pop-in-sfx.ogg', -24),
     (W['q6'], 'appear', 'extra ? pin', 'pop/kenney-interface-drop-001.ogg', -22)]
cues = [{'t': round(t, 2), 'type': ty, 'desc': d, 'sfx': s, 'gain': g} for t, ty, d, s, g in C]
cues.append({'t': round(W['tw'] - 2.4, 2), 'type': 'build_up', 'dur': 2.4, 'desc': 'riser into "แต่รอดได้"',
             'sfx': 'riser/fs-685256-riser-sound-effect-short-wav.ogg', 'gain': -27})
cues.sort(key=lambda c: c['t'])
json.dump(cues, open(H / 'sound/cues-th.json', 'w'), ensure_ascii=False, indent=1)
print(len(cues), 'cues')
