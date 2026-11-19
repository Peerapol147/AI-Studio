#!/usr/bin/env python3
"""Writes sound/cues-th.json from the same word-locked times the composition uses (build_index.DATA).
Storyboard sfx column, key moments only (12 cues, not every shot). Files from the sound-effects skill (CC0)."""
import json, pathlib, sys, contextlib, io
HERE = pathlib.Path(__file__).resolve().parent
sys.path.insert(0, str(HERE.parent))
with contextlib.redirect_stdout(io.StringIO()):
    import build_index as B
D = B.DATA
T = {k: v['start'] for k, v in D['sh'].items()}; H = {k: v['hit'] for k, v in D['sh'].items()}; K = D['k']
c = [
    (0.30, 'movement', 'hook: soft whoosh under the title (finger on the glowing feed)', 'whoosh/fs-683101-quick-woosh.ogg', -20),
    (K['tsong'], 'hover_or_small_ui', '"02:00" chip + moon pops on "ตีสอง"', 'tick/fs384187.ogg', -12),
    (K['nao'] + 0.05, 'appear', 'brain melts on "เน่า" (soft drip)', 'pop/kenney-interface-drop-002.ogg', -10),
    (K['oxford'], 'appear', 'zoom punch: Oxford card + green pill', 'pop/fs-824189-pop-in-sfx.ogg', -9),
    (K['year'] + 0.1, 'hover_or_small_ui', '+230% counter runs', 'click/kenney-interface-tick-001.ogg', -13),
    (T['supposed'], 'error_or_tech', 'glitch cut on "คนคิดว่า"', 'glitch/kenney-interface-glitch-002.ogg', -10),
    (K['clip'], 'movement', 'brain un-melts (reverse swoosh) on "คลิปสั้น"', 'riser/fs-174363-rewind.ogg', -14),
    (T['heavy'], 'scene_cut', 'fast scroll footage', 'whoosh/fs-127197-fast-simple-chop-5-aif.ogg', -13),
    (K['yae'], 'hover_or_small_ui', 'focus bar drops on "แย่กว่า"', 'ui-blip/kenney-digital-twotone2.ogg', -13),
    (T['corr'], 'error_or_tech', 'glitch cut on "สัมพันธ์"', 'glitch/kenney-sci-computernoise-001.ogg', -22),
    (K['trick'], 'success', 'zoom punch + lightbulb on "ทริก"', 'ding/kenney-interface-confirmation-001.ogg', -20),
    (H['putdown'], 'reveal', 'phone lands face-down on the nightstand on "เตียง"', 'impact/kenney-impact-impactsoft-heavy-000.ogg', -22),
    (K['kimong'], 'appear', 'comment bubble "กี่โมง?" pops', 'kit/pop.ogg', -18),
]
# review 2026-11-19: SFX masked the voice in the speech band at 16.86/19.34/20.26 -> every cue sits on speech, all -8 dB;
# remeasure: glitch 16.86 / ding 19.34 / thump 20.26 / pop 24.18 still within 0-4 dB of the voice -> those 4 a further 8-12 dB down
DUCK = -8
out = [{'t': round(t, 3), 'type': ty, 'desc': d, 'sfx': f, 'gain': g + DUCK} for t, ty, d, f, g in c]
(HERE / 'cues-th.json').write_text(json.dumps(out, indent=1, ensure_ascii=False))
print('th', len(out), 'cues')
