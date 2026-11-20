#!/usr/bin/env python3
"""Writes sound/cues-th.json from the same word-locked times the composition uses (build_index.DATA).
Storyboard "เสียง": wind/fog, candle out, the arm (creak stand-in), paper on the twist; no screams, no jump-scare hit.
Files from the sound-effects skill library (all CC0). The library has no wood-creak or paper-flip recording:
arm = a soft scary riser ending on "ยาว" + a soft heavy thump; paper = swipe/swoosh takes; lights-on = a toggle click.
No cue uses type scene_cut/reveal, so sound_pass_vo.py keeps the music at offset 0 (the twist volume envelope
baked into assets/music-bed.wav by prep_music.sh stays aligned)."""
import json, pathlib, sys, contextlib, io
HERE = pathlib.Path(__file__).resolve().parent
sys.path.insert(0, str(HERE.parent)); sys.argv = [sys.argv[0]]
with contextlib.redirect_stdout(io.StringIO()):
    import build_index as B
D = B.DATA
T = {k: v['start'] for k, v in D['sh'].items()}; H = {k: v['hit'] for k, v in D['sh'].items()}; K = D['k']
c = [
    (0.05, 'movement', 'hook: night wind over the canal (fog)', 'whoosh/fs-264777-swoosh.ogg', -12),
    (T['h2_name'], 'movement', 'fog dissolve into "มาก?"', 'transition/fs-683096-woosh.ogg', -18),
    (H['s7_out'] - 0.06, 'movement', 'candle blown out on "ตายทั้งกลม"', 'transition/fs-816262-broomstick-whoosh-3-quiet-okm1.ogg', -2),
    (K['tok'], 'appear', 'lime drops through the floor gap ("ตก")', 'pop/kenney-interface-drop-001.ogg', -14),
    # scary riser: swells for ~2.5 s, its hit sits 2.5 s into the file -> placed so the hit lands on "ยาว" (creak stand-in)
    (H['s15_arm'] - 2.5, 'appear', 'the arm: low swell from "ใต้ถุน", hit on "ยาว" (creak stand-in, not a jump scare)', 'riser/fs-396161-scary-hits-risers-001.ogg', -8),
    (H['s15_arm'] + 0.02, 'appear', 'arm stretches long on "ยาว": soft low thump', 'impact/kenney-impact-impactsoft-heavy-000.ogg', -6),
    (T['s18_rampage'], 'movement', 'gale over the water, lantern swings', 'whoosh/fs-169867-swoosh.ogg', -8),
    (T['t1_paper'], 'click', 'lights on: switch click under the flash', 'click/kenney-interface-toggle-001.ogg', -12),
    (T['t1_paper'] + 0.05, 'movement', 'paper swish as the page appears', 'transition/fs-702773-swipe-wav.ogg', -16),
    (K['nangsue'] + 0.1, 'appear', 'stamp "ฉบับเขียนเก่าสุดที่พบ"', 'impact/fs745291.ogg', -16),
    (T['t3_khunsri'], 'movement', 'card content turns (paper)', 'transition/fs-786514-swoosh-v2.ogg', -22),
    (K['chum'], 'appear', '"ชุ่ม" lands', 'pop/fs-447910-plop.ogg', -16),
    (K['wakan'], 'hover_or_small_ui', 'tag "ว่ากันว่า"', 'pop/kenney-interface-pluck-001.ogg', -10),
    (T['t5b_some'], 'movement', 'old book pages turn ("บางตำรา")', 'transition/fs-702773-swipe-wav.ogg', -16),
    (T['t8_lime'], 'appear', 'lime rolls back in', 'pop/kenney-interface-drop-002.ogg', -18),
    (T['c1_loop'], 'movement', 'back to the dark canal: wind', 'whoosh/fs-264777-swoosh.ogg', -10),
]
# first mix measured voice/(music+SFX) in 300-4000 Hz at +20..+43 dB on the story cues (SFX inaudible) -> story cues
# raised 6-14 dB (arm riser/thump the most); twist UI cues stay ~+15-20 dB under the voice; paper turn at 37.26 lowered (was +7.7)
DUCK = -4
out = []
for row in c:
    t, ty, d, f, g = row[:5]
    e = {'t': round(t, 3), 'type': ty, 'desc': d, 'sfx': f, 'gain': g + DUCK}
    if len(row) > 5: e['dur'] = round(row[5], 3)
    out.append(e)
(HERE / 'cues-th.json').write_text(json.dumps(out, indent=1, ensure_ascii=False))
print('th', len(out), 'cues')
