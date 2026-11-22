#!/usr/bin/env python3
"""Writes sound/cues-th.json from the same word-locked times the composition uses (build_index.DATA).
Storyboard sound column: whoosh on the zoom-outs, card flip x5, counter tick, low hit on "ภัยพิบัติ", glitch on "สติหลุด".
Key moments only, one real CC0 file per cue from the sound-effects skill (paths relative to its sfx/ folder)."""
import json, pathlib, sys, contextlib, io
HERE = pathlib.Path(__file__).resolve().parent
sys.path.insert(0, str(HERE.parent))
sys.argv = sys.argv[:1]
with contextlib.redirect_stdout(io.StringIO()):
    import build_index as B
D = B.DATA
T = {k: v['start'] for k, v in D['sh'].items()}; H = {k: v['hit'] for k, v in D['sh'].items()}; K = D['k']
c = [
    (0.30, 'movement', 'hook: soft whoosh under the title, map breathing', 'whoosh/fs-683101-quick-woosh.ogg', -20),
    (K['kon'], 'hover_or_small_ui', 'sonar ring on the dot at "กอน"', 'ui-blip/kenney-digital-twotone1.ogg', -16),
    (T['dot'], 'movement', 'camera dives into the dot', 'whoosh/fs-127197-fast-simple-chop-5-aif.ogg', -14),
    (T['lake'], 'movement', 'zoom out, the shore grows out of the dot', 'transition/fs-786514-swoosh-v2.ogg', -14),
    (T['surround'], 'movement', 'darkness flows in from the edges (dark riser)', 'riser/fs-396161-scary-hits-risers-001.ogg', -16),
    (K['dark'], 'reveal', '"ทวีปมืด" slam + punch-in', 'impact/fs-222517-dramatic-hit.ogg', -12),
    (H['netero'], 'appear', 'red circle on Zigg', 'pop/kenney-interface-drop-002.ogg', -14),
    (T['attempts'] + 0.08, 'typing', '149 routes + counter running', 'typing/fs-511418-data-reveal-sound.ogg', -18),
    (H['attempts'], 'reveal', 'counter lands on 149 (punch-in)', 'impact/kenney-impact-impactsoft-heavy-000.ogg', -14),
    (K['five'], 'success', '144 routes go grey, 5 glow gold', 'ding/kenney-interface-glass-001.ogg', -16),
    (T['treasure'], 'appear', 'gold treasure icons pop on the pins', 'pop/fs-824189-pop-in-sfx.ogg', -16),
    (T['but'], 'error_or_tech', 'glitch cut, gold turns red', 'glitch/kenney-interface-glitch-002.ogg', -12),
    (K['pai'], 'reveal', 'low hit on "ภัยพิบัติ"', 'impact/kenney-sci-lowfrequency-explosion-000.ogg', -12),
    (T['c1_threat'], 'scene_cut', 'card flip 1 (Pap)', 'transition/fs-702773-swipe-wav.ogg', -14),
    (H['c1_count'], 'reveal', '1,000 dots -> 7 (punch-in)', 'impact/kenney-impact-impactsoft-heavy-001.ogg', -14),
    (T['c2_threat'], 'scene_cut', 'card flip 2 (Brion)', 'transition/fs-850347-swipe-various.ogg', -14),
    (T['c3_threat'], 'scene_cut', 'card flip 3 (Hellbell)', 'transition/fs-702773-swipe-wav.ogg', -14),
    (H['c3_count'], 'hover_or_small_ui', 'bar stops at 99%', 'tick/fs384187.ogg', -14),
    (T['c4_threat'], 'scene_cut', 'card flip 4 (Ai)', 'transition/fs-850347-swipe-various.ogg', -14),
    (T['c4_mind'], 'error_or_tech', 'glitch on "สติหลุด"', 'glitch/kenney-sci-computernoise-001.ogg', -18),
    (H['c5_reward'], 'success', 'check mark "ได้มา"', 'ding/kenney-interface-confirmation-001.ogg', -18),
    (T['c5_zobae'], 'scene_cut', 'card flip 5 (Zobae)', 'transition/fs-702773-swipe-wav.ogg', -14),
    (K['maitai'], 'reveal', '"ไม่ตาย" slam', 'impact/fs-177242-cinematic-impact.ogg', -14),
    (T['again'], 'movement', 'new ship leaves the dot', 'whoosh/kit-whoosh.ogg', -16),
    (K['khum'], 'appear', '"คุ้มเสี่ยงสุด?" pops', 'kit/pop.ogg', -16),
    (T['loop'], 'movement', 'camera zooms back into the dot (loop to frame 0)', 'riser/fs-174363-rewind.ogg', -16),
]
# Brainrot v2 lesson: SFX on top of speech masked the voice -> every cue -8 dB from the start
DUCK = -8
sfx = HERE.parents[3] / '.claude' / 'skills' / 'sound-effects' / 'sfx'
out = []
for t, ty, d, f, g in c:
    if not (sfx / f).exists():
        alt = {'whoosh/kit-whoosh.ogg': 'kit/whoosh.ogg'}.get(f)
        assert alt and (sfx / alt).exists(), ('missing sfx', f)
        f = alt
    out.append({'t': round(t, 3), 'type': ty, 'desc': d, 'sfx': f, 'gain': g + DUCK})
(HERE / 'cues-th.json').write_text(json.dumps(out, indent=1, ensure_ascii=False))
print('th', len(out), 'cues')
