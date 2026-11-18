#!/usr/bin/env python3
"""Generates index.html from index.html.tpl (Thai only).
Shot times come from ../assets/audio/shots-th.json (never set by hand).
Caption chunks and word anchors are located in ../assets/audio/words.json (the real voice):
each time is the start of the first character of the phrase. Run: python3 build_index.py"""
import html, json, pathlib, re

HERE = pathlib.Path(__file__).parent
AUD = HERE.parent / 'assets' / 'audio'

def norm(s):
    return re.sub(r"[\s*?!.,'’…]", '', s.lower())

def finder():
    words = [w for w in json.loads((AUD / 'words.json').read_text())['words'] if w.get('type', 'word') == 'word']
    ch = []
    for w in words:
        for c in norm(w['text']):
            ch.append((c, w['start']))
    flat = ''.join(c for c, _ in ch)
    pos = 0
    def find(phrase):
        nonlocal pos
        p = norm(phrase)
        i = flat.find(p, pos)
        assert i >= 0, ('not in words', phrase)
        pos = i + len(p)
        return round(ch[i][1], 3)
    return find

# caption chunks (1-3 words, each >= 0.4 s); *x* = warm amber key word. Text = what the voice says (words.json).
CAPS = ["ตีสามแล้ว", "ยังเล่นมือถือ", "อยู่ใช่ไหม", "ยิ่ง*ดึก*เรื่องเล็ก", "ยิ่งดู*ใหญ่*",
        "เพราะตอนเหนื่อย", "สมองส่วนอารมณ์", "ไวขึ้น", "ส่วนที่คอย*เบรก*", "คุมได้น้อยลง",
        "ห้องมืด", "เงียบ", "ความคิดเลย*วน*", "เรื่องเดิม", "แต่เรื่องใหญ่", "ตอนตีสาม",
        "พอได้นอน", "มัก*เบาลง*", "ลอง*จด*สิ่งที่ต้องทำ", "พรุ่งนี้ลงกระดาษ", "แล้ววางมือถือ",
        "ถ้าคิดมาก", "จนกระทบชีวิต", "คุยกับ*ผู้เชี่ยวชาญ*นะ", "ตอนนี้*กี่โมง*แล้ว?", "คิดเรื่องอะไรอยู่"]
# word anchors for the motion, searched in speech order
ANCH = [('big', 'ใหญ่'), ('fast', 'ไวขึ้น'), ('brake', 'เบรก'), ('less', 'น้อยลง'), ('dark', 'มืด'),
        ('quiet', 'เงียบ'), ('loop', 'วนเรื่องเดิม'), ('big2', 'เรื่องใหญ่'), ('three', 'ตีสาม'), ('sleep', 'พอได้นอน'),
        ('lighter', 'เบาลง'), ('jot', 'จด'), ('paper', 'กระดาษ'), ('put', 'วาง'), ('phone2', 'มือถือ'),
        ('think', 'ถ้าคิดมาก'), ('hit', 'กระทบ'), ('life', 'ชีวิต'), ('talk', 'คุยกับ'), ('expert', 'ผู้เชี่ยวชาญ'),
        ('now', 'ตอนนี้'), ('time', 'กี่โมง'), ('what', 'คิดเรื่อง')]

shots = json.loads((AUD / 'shots-th.json').read_text())
DUR = round(shots['duration'], 3)
f = finder(); CAPT = [f(c) for c in CAPS]
f = finder(); K = {key: f(ph) for key, ph in ANCH}
SH = {s['id']: {'start': s['start'], 'end': s['end'], 'word': s['word_at'], 'hit': s.get('hit_at'),
                'ms': s.get('media_start'), 'src': s['src']} for s in shots['shots']}
DATA = {'dur': DUR, 'capt': CAPT, 'k': K, 'sh': SH}

def caps():
    out = []
    for i, txt in enumerate(CAPS):
        s = CAPT[i]; e = CAPT[i + 1] if i + 1 < len(CAPT) else DUR
        d = round(e - s, 3)
        assert d >= 0.4, (txt, d)
        n = len(txt.replace('*', ''))
        size = 92 if n <= 9 else (78 if n <= 13 else 70)
        body = re.sub(r'\*(.+?)\*', r'<em>\1</em>', html.escape(txt))
        out.append(f'  <div id="c{i}" class="clip cap" data-start="{s}" data-duration="{d}" data-track-index="20">'
                   f'<span style="font-size:{size}px">{body}</span></div>')
    return '\n'.join(out)

# footage: one timed <video> per shot (wrapper untimed). Visible window = [start, end + 0.12) for the crossfade.
GRADE = json.loads((HERE / 'grades.json').read_text())
def vids():
    out = []
    for sid, s in SH.items():
        if s['src'].startswith('graphic:'):
            continue
        name = sid
        dur = round(s['end'] - s['start'] + 0.12, 3)
        out.append((sid, f'<video id="v-{sid}" class="clip" data-start="{s["start"]}" data-duration="{dur}" data-media-start="{s["ms"]}" '
                    f'data-track-index="{1 + len(out) % 2}" muted playsinline src="assets/{name}.mp4" '
                    f"data-color-grading='{json.dumps(GRADE[sid])}'></video>"))
    # ending loops back to the hook footage (dimmed) under the comment bubble
    a = SH['ask']['start']
    out.append(('ask', f'<video id="v-ask" class="clip" data-start="{a}" data-duration="{round(DUR - a, 3)}" data-media-start="2.0" '
                f'data-track-index="1" muted playsinline src="assets/hook.mp4" '
                f"data-color-grading='{json.dumps(GRADE['hook'])}'></video>"))
    return dict(out)

V = vids()
page = (HERE / 'index.html.tpl').read_text()
page = re.sub(r'%%VID:(\w+)%%', lambda m: V[m.group(1)], page)
for key, v in {'%%DUR%%': str(DUR), '%%CAPS%%': caps(), '%%DATA%%': json.dumps(DATA, ensure_ascii=False)}.items():
    page = page.replace(key, v)
(HERE / 'index.html').write_text(page)
print('dur', DUR, 'captions', len(CAPS), 'K', K)
