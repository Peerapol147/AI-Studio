#!/usr/bin/env python3
"""Generates index.html (one composition, Thai only) from index.html.tpl.
- Shot times come ONLY from ../assets/audio/shots-th.json (start/end); media_start too, except the
  overrides in MEDIA below (chosen after looking at the real frames; see comments).
- Caption chunks: text below, times = first character start in ../assets/audio/words.json.
Run: python3 build_index.py"""
import html, json, pathlib, re

HERE = pathlib.Path(__file__).parent
PROJ = HERE.parent
SHOTS = json.load(open(PROJ / 'assets/audio/shots-th.json'))
WORDS = [w for w in json.load(open(PROJ / 'assets/audio/words.json'))['words'] if w['type'] == 'word']
DUR = SHOTS['duration']

# media_start overrides (source clip has NASA burnt-in text on the right from ~2.3 s, and the
# "Learn more"/logo end card from ~70.3 s):
MEDIA = {
    'hook': 53.60,   # planned 1.78: blob + face sit where the burnt-in text is; 53.6 = astronaut with blob, no text
    'cheek': 52.00,  # planned 14.92: same text problem; 52.0 = blob right in front of the cheek
    'outro': 57.50,  # planned 69.92: cuts to the "Learn more at nasa.gov" card at ~70.3 s
}
# crop per shot: x0 (left edge of the 540-px source window) at shot start / end, blob centre (source px)
CROP = {
    'hook': (300, 290, 520, 530), 'cheek': (380, 370, 575, 500), 'belief': (455, 450, 690, 330),
    'truth': (380, 380, 520, 330), 'nolimit': (450, 450, 800, 260), 'float': (150, 140, 260, 520),
    'nopull': (380, 400, 620, 400), 'merge': (400, 400, 670, 430), 'tension': (260, 250, 455, 530),
    'stick': (210, 200, 360, 320), 'bigger': (200, 200, 360, 280), 'wipe': (300, 300, 520, 200),
    'earth': (420, 420, 640, 300), 'nofall': (250, 250, 380, 420), 'tissue': (200, 200, 340, 420),
    'outro': (280, 270, 400, 600), 'outro2': (260, 250, 400, 400),
}

STREAM = ''.join(w['text'] for w in WORDS)
CHT = []  # start time per character of STREAM
for w in WORDS:
    for c in (w.get('characters') or [{'text': ch, 'start': w['start']} for ch in w['text']]):
        CHT.append(c['start'])
assert len(CHT) == len(STREAM)

# caption chunks (1-3 words each); *word* = yellow highlight
CHUNKS = ["ถ้าร้องไห้", "ในอวกาศ", "น้ำตาจะไหล", "ลง*แก้ม*ไหม?", "หลายคนคิดว่า", "ไหลเหมือนบนโลก",
          "แต่ความจริงคือ", "*ไม่ไหลเลย*", "เพราะบนสถานี", "อวกาศ", "ทุกอย่าง*ลอย*ได้", "ไม่มีอะไรดึง",
          "น้ำตาลงมา", "น้ำเลย*รวมตัว*", "เป็นก้อนกลมๆ", "ด้วย*แรงตึงผิว*", "น้ำตาก็", "*เกาะ*อยู่ที่ตา",
          "ร้องต่อก้อน", "ก็*ยิ่งใหญ่*ขึ้น", "ต้องเช็ดออกเอง", "บนโลก", "น้ำตาไหลลงมา", "แต่ในอวกาศ",
          "น้ำตา*ไม่ตก*", "ต้องเตรียมผ้าเช็ดหน้า", "แล้วเพื่อนๆ", "คิดว่า", "อะไรจะทำให้", "นักบินร้องไห้",
          "ได้ก่อนกัน?"]

def chunk_times():
    pos, out = 0, []
    for ch in CHUNKS:
        plain = re.sub(r'[*? ]', '', ch)
        assert STREAM[pos:pos + len(plain)] == plain, (ch, STREAM[pos:pos + 20])
        out.append(round(CHT[pos], 2)); pos += len(plain)
    assert pos == len(STREAM)
    out[0] = 0.0
    return out

def caps():
    ts = chunk_times(); rows = []
    for i, (s, txt) in enumerate(zip(ts, CHUNKS)):
        e = ts[i + 1] if i + 1 < len(ts) else DUR
        d = round(e - s, 3); assert d >= 0.4, (txt, d)
        n = len(re.sub(r'[*?่้๊๋ิีึืุู็์ั]', '', txt))
        size = 80 if n <= 11 else (72 if n <= 14 else 62)
        inner = re.sub(r'\*(.+?)\*', r'<em>\1</em>', html.escape(txt))
        rows.append(f'  <div id="c{i}" class="clip cap" data-start="{s}" data-duration="{d}" '
                    f'data-track-index="20"><span style="font-size:{size}px">{inner}</span></div>')
    return '\n'.join(rows), ts

def shots():
    tags, js = [], []
    for k, s in enumerate(SHOTS['shots']):
        ms = MEDIA.get(s['id'], s['media_start'])
        x0a, x0b, bx, by = CROP[s['id']]
        d = round(s['end'] - s['start'], 3)
        tags.append(f'  <div class="shot" id="sh-{s["id"]}" style="z-index:{k + 1}"><video id="v-{s["id"]}" class="clip m" '
                    f'data-start="{s["start"]}" data-duration="{d}" data-media-start="{ms}" data-track-index="{1 + k % 2}" '
                    f'src="assets/nasa-moving-water.mp4" muted playsinline></video></div>')
        js.append([s['id'], s['start'], s['end'], x0a, x0b, bx, by])
    return '\n'.join(tags), js

caps_html, cap_t = caps()
shot_html, shot_js = shots()
W = {s['id']: s['word_at'] for s in SHOTS['shots']}
page = (HERE / 'index.html.tpl').read_text()
page = (page.replace('%%DUR%%', str(DUR)).replace('%%CAPS%%', caps_html).replace('%%SHOTS%%', shot_html)
        .replace('%%SHOTJS%%', json.dumps(shot_js)).replace('%%CAPTIMES%%', json.dumps(cap_t)))
(HERE / 'index.html').write_text(page)
print('index.html written; captions:', len(cap_t), 'shots:', len(shot_js))
for t, c in zip(cap_t, CHUNKS): print(f'{t:6.2f} {c}')
