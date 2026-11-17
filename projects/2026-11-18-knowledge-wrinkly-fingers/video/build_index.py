#!/usr/bin/env python3
"""Generates index.html from index.html.tpl (one composition, variable "lang": th only for this episode).
Shot times come from ../assets/audio/shots-th.json (never set by hand).
Caption chunks and word anchors are located in ../assets/audio/words.json (the real voice):
each time is the start of the first character of the phrase. Run: python3 build_index.py"""
import html, json, pathlib, re

HERE = pathlib.Path(__file__).parent
AUD = HERE.parent / 'assets' / 'audio'
SHOTS = json.loads((AUD / 'shots-th.json').read_text())
WORDS = [w for w in json.loads((AUD / 'words.json').read_text())['words'] if w.get('type', 'word') == 'word']
DUR = round(SHOTS['duration'], 2)

# flatten the transcript to characters with their start times
CH = []
for w in WORDS:
    txt = w['text'].replace(' ', '')
    for c in txt:
        CH.append((c, w['start']))
FLAT = ''.join(c for c, _ in CH)

def finder():
    pos = 0
    def find(phrase):
        nonlocal pos
        p = re.sub(r'[\s*?!]', '', phrase)
        i = FLAT.find(p, pos)
        assert i >= 0, ('not in words.json', phrase)
        pos = i + len(p)
        return round(CH[i][1], 3)
    return find

# caption chunks, 1-3 words, *x* = key word (yellow)
CAPS = ["ทำไมแช่น้ำนานๆ", "แล้วนิ้ว*เหี่ยว*", "หลายคนคิดว่า", "ผิวอมน้ำ", "จน*พอง*", "แต่ความจริง", "คือ",
        "*ระบบประสาท*สั่งให้", "หลอดเลือดใต้ผิว", "*หดตัว*", "เนื้อข้างใต้", "*ยุบ*ลง", "ผิวข้างบนเลย",
        "*ย่น*เป็นลูกคลื่น", "หลักฐานคือ", "คนที่เส้นประสาท", "นิ้ว*เสียหาย*", "แช่นานแค่ไหน", "ก็*ไม่เหี่ยว*",
        "นิ้ว*เหี่ยว*เลย", "แปลว่า", "เส้นประสาทนิ้ว", "ยัง*ทำงานดี*", "แล้วมันช่วย", "จับของเปียก",
        "ได้จริงไหม?", "คอมเมนต์เลย!"]
f = finder()
CAPT = [f(c) for c in CAPS]
CAPT[0] = 0.0  # the first chunk is on screen from frame 0

# word anchors for the motion (searched in order of speech)
f = finder()
K = {}
for key, phrase in [('wet', 'อมน้ำ'), ('puff', 'พอง'), ('but', 'แต่ความจริง'), ('is', 'คือ'), ('nerve', 'ระบบประสาท'),
                    ('vessel', 'หลอดเลือด'), ('shrink', 'หดตัว'), ('flesh', 'เนื้อข้างใต้'), ('sink', 'ยุบ'),
                    ('skin', 'ผิวข้างบน'), ('fold', 'ย่น'), ('proof', 'หลักฐาน'), ('people', 'คนที่เส้นประสาท'),
                    ('damaged', 'เสียหาย'), ('soak', 'แช่นาน'), ('notwrinkly', 'ไม่เหี่ยว'), ('sign', 'นิ้วเหี่ยวเลย'),
                    ('means', 'แปลว่า'), ('nerve2', 'เส้นประสาทนิ้ว'), ('works', 'ทำงานดี'), ('help', 'แล้วมัน'),
                    ('grip', 'จับ'), ('really', 'ได้จริงไหม'), ('comment', 'คอมเมนต์')]:
    K[key] = f(phrase)
SH = {s['id']: s for s in SHOTS['shots']}

def caps():
    out = []
    for i, txt in enumerate(CAPS):
        s = CAPT[i]
        e = CAPT[i + 1] if i + 1 < len(CAPS) else DUR
        d = round(e - s, 3)
        assert d >= 0.4, (txt, d)
        n = len(txt.replace('*', ''))
        size = 88 if n <= 9 else (78 if n <= 13 else 68)
        body = re.sub(r'\*(.+?)\*', r'<em>\1</em>', html.escape(txt))
        out.append(f'  <div id="cth{i}" class="clip cap" data-start="{s}" data-duration="{d}" '
                   f'data-track-index="20"><span style="font-size:{size}px">{body}</span></div>')
    return '\n'.join(out)

def vid(sid, file, pos, extra_after=0.12):
    s = SH[sid]
    ms = s.get('media_start', 0)
    d = round(s['dur'] + (extra_after if s['end'] < DUR - 0.01 else 0), 3)
    return (f'<video id="v-{sid}" class="clip m" data-start="{s["start"]}" data-duration="{d}" data-track-index="{2 + list(SH).index(sid) % 3}" '
            f'data-media-start="{ms}" src="assets/{file}" style="object-position:{pos}" muted playsinline></video>')

page = (HERE / 'index.html.tpl').read_text()
for k, v in {'%%DUR%%': str(DUR), '%%CAPS_TH%%': caps(), '%%CAPTIMES%%': json.dumps(CAPT),
             '%%K%%': json.dumps(K), '%%SHOTS%%': json.dumps({k: {'start': v['start'], 'end': v['end'], 'hit_at': v.get('hit_at')} for k, v in SH.items()}),
             '%%V_SOAK%%': vid('soak', 'soak-pixabay-51807.mp4', '30% 50%'),
             '%%V_NERVE%%': vid('nerve', 'nerve-pixabay-362487.mp4', '45% 50%'),
             '%%V_VESSEL%%': vid('vessel', 'vessel-pixabay-26799.mp4', '50% 50%'),
             '%%V_GRIP%%': vid('grip', 'grip-pixabay-4906.mp4', '42% 50%')}.items():
    page = page.replace(k, v)
(HERE / 'index.html').write_text(page)
print('index.html written', DUR, 'captions', len(CAPS))
print('K', K)
