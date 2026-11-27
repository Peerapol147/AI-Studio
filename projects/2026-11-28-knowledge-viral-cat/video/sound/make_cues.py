#!/usr/bin/env python3
"""cues-th.json from the built index.html word-time table (const W) + shots-th.json (run after build_index.py)."""
import json, re, pathlib
H = pathlib.Path(__file__).resolve().parent.parent
src = re.search(r'const W=(\{.*?\});', (H / 'index.html').read_text(), re.S).group(1)
W = json.loads(re.sub(r'(\w+):', r'"\1":', src))
S = {s['id']: s for s in json.load(open(H.parent / 'assets/audio/shots-th.json'))['shots']}
C = [(W['fight1'], 'appear', 'bubble 1 pops (ลายแปลก...)', 'pop/kenney-interface-drop-001.ogg', -22),
     (W['fight2'], 'appear', 'bubble 2 pops (ลายจริงมั้ย?)', 'pop/kenney-interface-drop-002.ogg', -22),
     (W['fight3'], 'appear', 'bubble 3 pops (painted??)', 'pop/fs-824189-pop-in-sfx.ogg', -23),
     (W['tasi'] - 0.1, 'scene_cut', 'brush swipe under ทาสี?', 'transition/fs-816262-broomstick-whoosh-3-quiet-okm1.ogg', -20),
     (5.98, 'hover_or_small_ui', 'view counter 1K', 'tick/fs384187.ogg', -25),
     (6.24, 'hover_or_small_ui', 'view counter 10K', 'tick/fs384187.ogg', -25),
     (6.50, 'hover_or_small_ui', 'view counter 100K', 'tick/fs384187.ogg', -25),
     (6.76, 'hover_or_small_ui', 'view counter 1M+', 'tick/fs384187.ogg', -25),
     (7.02, 'appear', 'counter lands หลายล้านวิว', 'ding/kenney-interface-confirmation-001.ogg', -25),
     (S['thai_say']['start'], 'scene_cut', 'folding book opens', 'transition/fs-850347-swipe-various.ogg', -25),
     (W['wilat_say'], 'appear', 'แมววิลาศ? label', 'pop/fs-447910-plop.ogg', -22),
     (W['tamra'], 'appear', 'chip สมุดข่อย', 'pop/kenney-interface-pluck-001.ogg', -24),
     (W['mongkol'], 'appear', '17 icons pop', 'pop/kenney-interface-drop-003.ogg', -24),
     (W['sip7'], 'reveal', 'big 17', 'ding/kenney-interface-glass-001.ogg', -23),
     (W['wilat'], 'appear', 'วิลาศ label', 'pop/fs-447910-plop.ogg', -23),
     (W['hu'], 'scene_cut', 'circle on the ears', 'whoosh/fs-127197-fast-simple-chop-5-aif.ogg', -24),
     (W['hang'], 'scene_cut', 'arrow to the tail', 'whoosh/fs-683101-quick-woosh.ogg', -24),
     (W['kha'], 'scene_cut', 'circle on the legs', 'whoosh/fs-127197-fast-simple-chop-5-aif.ogg', -24),
     (W['maitong'], 'appear', 'ไม่ต้องทาสี', 'pop/fs-824189-pop-in-sfx.ogg', -23),
     (W['kerd'], 'appear', 'เกิดเองได้', 'pop/fs-824189-pop-in-sfx.ogg', -24),
     (W['yeen'], 'appear', 'ยีน KIT label', 'ui-blip/kenney-digital-twotone1.ogg', -25),
     (S['cells']['start'], 'scene_cut', 'DNA dots spring into the cat', 'transition/fs-786514-swoosh-v2.ogg', -25),
     (W['tueng'], 'appear', 'arrows: pigment stops', 'whoosh/fs-683101-quick-woosh.ogg', -25),
     (W['sikao'], 'appear', 'circle on the white paw', 'whoosh/fs-127197-fast-simple-chop-5-aif.ogg', -24),
     (W['boran'], 'reveal', 'big ? (แมวโบราณ?)', 'impact/kenney-impact-impactsoft-heavy-000.ogg', -21),
     (W['yangtob'], 'appear', 'ยังตอบไม่ได้', 'pop/fs-447910-plop.ogg', -23),
     (W['sikon'], 'appear', 'check สีขน', 'click/kenney-interface-select-001.ogg', -23),
     (W['nata'] + 0.08, 'appear', 'check หน้าตา', 'click/kenney-interface-select-001.ogg', -23),
     (W['maidai'], 'reveal', 'X over DNA (ไม่ได้ตรวจ)', 'impact/fs-222517-dramatic-hit.ogg', -21),
     (W['law'] + 0.1, 'reveal', 'stamp thud', 'impact/kenney-impact-impactpunch-heavy-000.ogg', -20),
     (W['hen'], 'appear', 'chips pop', 'pop/kenney-interface-drop-001.ogg', -25),
     (W['siam'], 'appear', 'name tag วิเชียรมาศ', 'pop/kenney-interface-pluck-002.ogg', -24),
     (W['korat'], 'appear', 'name tag สีสวาด', 'pop/kenney-interface-pluck-002.ogg', -24),
     (W['khao'], 'appear', 'name tag ขาวมณี', 'pop/kenney-interface-pluck-002.ogg', -24),
     (W['laitrong'], 'appear', 'question ลายตรงตำราไหม?', 'pop/fs-824189-pop-in-sfx.ogg', -23)]
cues = [{'t': round(t, 2), 'type': ty, 'desc': d, 'sfx': s, 'gain': g} for t, ty, d, s, g in C]
cues.sort(key=lambda c: c['t'])
json.dump(cues, open(H / 'sound/cues-th.json', 'w'), ensure_ascii=False, indent=1)
print(len(cues), 'cues')
