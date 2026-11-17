#!/usr/bin/env python3
"""Generates index.html from index.html.tpl. Thai only.
- SHOTS: read from ../assets/audio/shots-th.json (start/end/hit_at, made by tools/shot_times.py)
  joined by id with ../shots.json (kind, focus). No hand-typed shot times.
- Captions: chunk texts below, times = first character of each chunk in ../assets/audio/words.json
  (the transcript writes "Comment"; it is captioned as "คอมเมนต์").
- Word times for secondary graphic beats (W) come from words.json via the same matcher.
Run: python3 build_index.py"""
import html, json, pathlib, sys

HERE = pathlib.Path(__file__).resolve().parent
PROJ = HERE.parent
sys.path.insert(0, str(PROJ.parent.parent / 'tools'))
from shot_times import char_stream, find  # noqa: E402

shots_lang = json.loads((PROJ / 'assets/audio/shots-th.json').read_text())
meta = {s['id']: s for s in json.loads((PROJ / 'shots.json').read_text())['shots']}
words = json.loads((PROJ / 'assets/audio/words.json').read_text())
stream = char_stream(words['words'])

VO_DUR = 28.92
DUR = round(VO_DUR + 0.18, 2)   # cut right after the last word (+ <=0.3 s)

SHOTS = []
for s in shots_lang['shots']:
    m = meta[s['id']]
    SHOTS.append({'id': s['id'], 'kind': m['kind'], 'src': m.get('src'), 'focus': m.get('focus', '50% 50%'),
                  'start': s['start'], 'end': s['end'], 'word_at': s['word_at'], 'hit_at': s.get('hit_at')})
SHOTS[-1]['end'] = DUR   # last shot holds to the end of the composition

# caption chunks, 1-3 words, in spoken order. (display text, text to match in the transcript)
CHUNKS = ["เพื่อนๆ", "รู้ไหมว่า", "คนแก่", "ราวหนึ่งในสี่", "อาจกำลัง", "ขาดน้ำ", "ทั้งที่", "ไม่รู้สึก", "หิวน้ำเลย",
          "เวลาเห็น", "คุณยาย", "มึนๆ งงๆ", "เราคิดว่า", "แค่แก่", "ตามวัย", "แต่ความจริงคือ", "อาจเป็น", "แค่ขาดน้ำ",
          "เพราะพอ", "อายุมากขึ้น", "สมอง", "ส่งสัญญาณ", "หิวน้ำ", "ช้าลง", "และเบาลง", "ร่างกาย", "ก็เก็บน้ำ",
          "ได้น้อยลง", "มีการทดลอง", "ให้งดน้ำ", "หนึ่งวัน", "คนแก่", "ขาดน้ำมากกว่า", "คนหนุ่ม", "แต่กลับ",
          "หิวน้ำน้อยกว่า", "เลยต้องชวน", "จิบน้ำ", "เป็นช่วงๆ", "ไม่ต้องรอหิว", "ใครเป็น", "โรคหัวใจ", "หรือโรคไต",
          "ถามหมอ", "ก่อนนะ", "ที่บ้าน", "เพื่อนๆ", "ใครชอบ", "ลืมกินน้ำ", "บ้าง?", ("คอมเมนต์", "Comment"), "บอกหน่อย"]

pos, CAPS = 0, []
for c in CHUNKS:
    disp, key = (c, c) if isinstance(c, str) else c
    t, pos2 = find(stream, key, pos)
    assert t is not None, f'caption "{key}" not found'
    CAPS.append((round(t, 3), disp)); pos = pos2

def word_time(text, after=0.0):
    p = 0
    while True:
        t, p2 = find(stream, text, p)
        assert t is not None, text
        if t >= after: return round(t, 3)
        p = p2

# secondary beats inside graphic shots (words.json, not hand typed)
W = {
    'quarter_dry': word_time('ขาดน้ำ'),                    # "...อาจกำลังขาดน้ำ": one icon drains
    'slower': word_time('ช้าลง'),                          # wave starts slowing
    'less': word_time('น้อยลง'),                           # body water level drops
    'young': word_time('คนหนุ่ม'),                         # young bar of the first pair
    'thirst_end': word_time('เลย', 4.0),                  # end of "หิวน้ำ" (next word "เลย"): meter shows 0
}
# sip shot: 4 glasses land on the syllables of "จิบน้ำเป็นช่วงๆ"
_j = word_time('จิบ', 20.0)
W['glasses'] = [_j, word_time('เป็น', _j), word_time('ช่วง', _j), word_time('ๆ', word_time('ช่วง', _j))]
W['hiw'] = word_time('หิว', word_time('ไม่ต้องรอ'))       # "หิว" in "รอหิว": strike-through on the drop


def caps():
    out = []
    for i, (s, txt) in enumerate(CAPS):
        e = CAPS[i + 1][0] if i + 1 < len(CAPS) else DUR
        d = round(e - s, 3)
        assert d > 0.15, (txt, d)
        size = 84 if len(txt) <= 9 else (76 if len(txt) <= 13 else 68)
        out.append(f'  <div id="c{i}" class="clip cap" data-start="{s}" data-duration="{d}" '
                   f'data-track-index="20"><span style="font-size:{size}px">{html.escape(txt)}</span></div>')
    return '\n'.join(out)

# grades applied via `hyperframes media-treatment` (canonical data-color-grading), kept here so rebuilds keep them
GRADES = {}
NAVY = {'wait'}   # shown on the navy brand background (photo dropped after review), clock overlay does the work

def shot_divs():
    out = []
    for s in SHOTS:
        if s['kind'] != 'footage': continue
        if s['id'] in NAVY:
            out.append(f'  <div class="shot navy" id="sh-{s["id"]}"></div>'); continue
        grade = f' data-color-grading="{html.escape(json.dumps(GRADES[s["id"]]))}"' if s['id'] in GRADES else ''
        out.append(f'  <div class="shot" id="sh-{s["id"]}"><img class="m" src="{s["src"].replace("assets/footage/", "assets/")}"{grade} '
                   f'style="object-position:{s["focus"]}" alt=""/></div>')
    return '\n'.join(out)

page = (HERE / 'index.html.tpl').read_text()
page = (page.replace('%%DUR%%', str(DUR)).replace('%%VODUR%%', str(VO_DUR)).replace('%%CAPS%%', caps())
        .replace('%%SHOTDIVS%%', shot_divs()).replace('%%SHOTS%%', json.dumps(SHOTS, ensure_ascii=False))
        .replace('%%W%%', json.dumps(W)).replace('%%CAPTIMES%%', json.dumps([c[0] for c in CAPS])))
(HERE / 'index.html').write_text(page)
for s in SHOTS: print(f"{s['id']:9s} {s['kind']:8s} {s['start']:6.2f}-{s['end']:6.2f} hit {s['hit_at']}")
print('W', W)
print('captions:', ' | '.join(f'{t}:{x}' for t, x in CAPS))
print('index.html written')
