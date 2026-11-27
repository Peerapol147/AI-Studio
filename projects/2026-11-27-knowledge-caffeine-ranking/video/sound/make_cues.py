#!/usr/bin/env python3
"""cues-th.json from the built index.html word-time table (const W) + shots-th.json (run after build_index.py).
One sound per cue, spaced out (not every cut): impact on "แล้วอันดับหนึ่ง", hit on "ชื่อดูแรง"."""
import json, re, pathlib
H = pathlib.Path(__file__).resolve().parent.parent
W = json.loads(re.search(r'const W=(\{.*?\});', (H / 'index.html').read_text()).group(1))
S = {s['id']: s for s in json.load(open(H.parent / 'assets/audio/shots-th.json'))['shots']}
C = [(S['hook_bottle']['start'], 'scene_cut', 'bottle springs to centre', 'whoosh/fs-683101-quick-woosh.ogg', -26),
     (W['xb'], 'appear', 'hand-drawn X on the bottle (ชูกำลัง)', 'pop/kenney-interface-pluck-001.ogg', -24),
     (W['set'], 'appear', 'gauge grows + 4 -> 1', 'pop/fs-824189-pop-in-sfx.ogg', -24),
     (W['r4'], 'appear', 'rank 4 label', 'pop/fs-447910-plop.ogg', -22),
     (W['n34'], 'hover_or_small_ui', 'gauge fills to ~30+', 'tick/fs384187.ogg', -24),
     (W['r3'], 'appear', 'rank 3 label + bottle', 'pop/fs-447910-plop.ogg', -22),
     (W['bel'], 'error_or_tech', 'belief bolts crackle', 'glitch/kenney-interface-glitch-002.ogg', -30),
     (W['rule'], 'hover_or_small_ui', 'ceiling line 50 (อย.)', 'tick/fs528561.ogg', -24),
     (W['name'], 'reveal', 'hit: bolts shrink (ชื่อดูแรง)', 'impact/kenney-impact-impactpunch-heavy-000.ogg', -22),
     (W['r2'], 'appear', 'rank 2 label', 'pop/fs-447910-plop.ogg', -22),
     (W['pass'], 'success', 'espresso passes the 50 line (แซง)', 'ding/kenney-interface-confirmation-001.ogg', -25),
     (S['r1']['start'] + 0.08, 'reveal', 'impact: แล้วอันดับหนึ่ง', 'impact/fs-177242-cinematic-impact.ogg', -18),
     (W['s3'], 'appear', 'shots pour (สามช็อต)', 'pop/kenney-interface-drop-002.ogg', -25),
     (W['n200'], 'build_up', 'gauge rockets to ~200', 'riser/kenney-digital-powerup2.ogg', -28),
     (W['adult'], 'appear', '400 line + FDA label', 'pop/fs-824189-pop-in-sfx.ogg', -25),
     (W['half'], 'success', 'แก้วเดียว ≈ เกือบครึ่ง', 'ding/fs-349504-triangle-open-04.ogg', -27),
     (W['cta'], 'appear', 'cta question pill', 'pop/fs-824189-pop-in-sfx.ogg', -24)]
cues = []
for t, ty, d, s, g in C:
    c = {'t': round(t, 2), 'type': ty, 'desc': d, 'sfx': s, 'gain': g}
    if ty == 'build_up':
        c['type'] = 'appear'          # powerup plays from the word (not a pre-roll riser)
    cues.append(c)
cues.sort(key=lambda c: c['t'])
json.dump(cues, open(H / 'sound/cues-th.json', 'w'), ensure_ascii=False, indent=1)
print(len(cues), 'cues')
