#!/usr/bin/env python3
"""cues-th.json: one CC0 sound (sound-effects skill library) per visible action; times = the word in
../assets/audio/words.json (same table as const W in index.html.tpl) or the shot start in shots-th.json."""
import json, pathlib
H = pathlib.Path(__file__).resolve().parent.parent
S = {s['id']: s for s in json.load(open(H.parent / 'assets/audio/shots-th.json'))['shots']}
C = [
 (2.56, 'hover_or_small_ui', 'clock digit flips 01:00 -> 02:00 (ตีสอง)', 'tick/fs384187.ogg', -14),
 (S['setup_yawn']['start'] - 0.07, 'scene_cut', 'hook -> setup (yawn)', 'whoosh/fs-264777-swoosh.ogg', -28),
 (9.24, 'appear', 'sign drops in (ชื่อเรียก)', 'pop/fs-447910-plop.ogg', -18),
 (10.52, 'typing', 'type Revenge', 'typing/fs-416777-digital-typing-wav.ogg', -22, 0.34),
 (10.96, 'typing', 'type Bedtime', 'typing/fs-416777-digital-typing-wav.ogg', -22, 0.38),
 (11.42, 'typing', 'type Procrastination', 'typing/fs-416777-digital-typing-wav.ogg', -22, 0.9),
 (13.68 - 0.07, 'movement', 'whoosh into the revenge shot (แก้แค้น)', 'whoosh/fs-683101-quick-woosh.ogg', -20),
 (14.94, 'appear', 'card ไม่ใช่โรค pops', 'pop/fs-824189-pop-in-sfx.ogg', -21),
 (16.02, 'success', 'card morphs to แค่ชื่อเรียก', 'ding/fs-634690-lil-pip.ogg', -21),
 (S['work']['start'] - 0.07, 'scene_cut', 'into the reveal (ทั้งวัน)', 'whoosh/fs-169867-swoosh.ogg', -28),
 (22.55, 'movement', 'my-time bar stretches into sleep (เอาคืน)', 'transition/fs-786514-swoosh-v2.ogg', -22),
 (26.34, 'appear', 'short soft alarm beep on the twist (ตลก)', 'ui-blip/kenney-digital-threetone1.ogg', -24),
 (32.52, 'appear', 'clock face springs in (กันเวลา)', 'pop/kenney-interface-drop-002.ogg', -22),
 (33.64, 'appear', 'pill หัวค่ำ', 'pop/kenney-interface-pluck-001.ogg', -20),
 (34.74, 'success', '30-minute ring full + label', 'ding/kenney-interface-confirmation-001.ogg', -24),
 (36.50, 'click', 'phone lands face down (วางมือถือ)', 'click/kenney-interface-click-001.ogg', -16),
 (36.96, 'click', 'lamp switched off', 'click/kenney-interface-toggle-001.ogg', -18),
]
cues = []
for c in C:
    d = {'t': round(c[0], 2), 'type': c[1], 'desc': c[2], 'sfx': c[3], 'gain': c[4]}
    if len(c) > 5: d['dur'] = c[5]
    cues.append(d)
cues.sort(key=lambda c: c['t'])
json.dump(cues, open(H / 'sound/cues-th.json', 'w'), ensure_ascii=False, indent=1)
print(len(cues), 'cues')
