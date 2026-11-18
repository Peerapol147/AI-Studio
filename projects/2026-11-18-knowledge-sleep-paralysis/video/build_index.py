#!/usr/bin/env python3
"""Generates index.html from index.html.tpl (one composition, Thai only).
Shot times come from ../assets/audio/shots-th.json (never set by hand).
Caption chunks and word anchors are located in ../assets/audio/words.json (the real voice):
each time is the start of the first character of the phrase. Run: python3 build_index.py"""
import html, json, pathlib, re

HERE = pathlib.Path(__file__).parent
AUD = HERE.parent / 'assets' / 'audio'
# the transcript spells "ล็อก" as "ล็อค"; the screen shows the script spelling
ALIAS = {'ล็อก': 'ล็อค'}

def norm(s):
    s = s.lower()
    for a, b in ALIAS.items():
        s = s.replace(a, b)
    return re.sub(r"[\s*?!.,'’…]", '', s)

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

# caption chunks (1-3 words); *x* = key word (yellow). Text = what the voice really says.
CAPS = ["ตื่นกลางดึก", "ลืมตาได้", "แต่ขยับไม่ได้เลย", "คนไทยเรียก", "*ผีอำ*", "แต่ความจริงคือ", "*สมองตื่นก่อน*ร่างกาย",
        "ตอนฝัน", "สมอง*ล็อก*", "กล้ามเนื้อไว้", "ไม่ให้เราขยับ", "ตามฝัน", "ถ้าตื่นช่วงนี้", "เลยขยับไม่ได้",
        "แถมยัง*ฝันค้าง*", "เห็นเงา", "รู้สึกถูกทับอก", "มักเกิดตอน", "อดนอน", "เครียด", "หรือนอนหงาย",
        "ถ้าเป็นบ่อยมาก", "*ปรึกษาแพทย์*นะ", "คุณเคยโดนไหม", "เห็นอะไร?"]
# word anchors for the motion, searched in speech order
ANCH = [('open', 'ลืมตา'), ('move1', 'ขยับ'), ('thai', 'คนไทย'), ('ghost', 'ผีอำ'), ('truth', 'แต่ความจริง'),
        ('brain', 'สมองตื่นก่อน'), ('body', 'ร่างกาย'), ('dream', 'ตอนฝัน'), ('lock', 'ล็อก'), ('muscle', 'กล้ามเนื้อ'),
        ('nomove', 'ไม่ให้เรา'), ('follow', 'ตามฝัน'), ('wake', 'ตื่นช่วง'), ('stuck', 'ขยับไม่ได้'), ('residue', 'ฝันค้าง'),
        ('shadow', 'เห็นเงา'), ('feel', 'รู้สึก'), ('chest', 'ทับอก'), ('often', 'มักเกิด'), ('nosleep', 'อดนอน'),
        ('stress', 'เครียด'), ('supine', 'นอนหงาย'), ('ifoften', 'ถ้าเป็น'), ('doctor', 'ปรึกษาแพทย์'),
        ('ask', 'คุณเคย'), ('what', 'เห็นอะไร')]

shots = json.loads((AUD / 'shots-th.json').read_text())
DUR = round(shots['duration'], 3)
f = finder()
CAPT = [f(c) for c in CAPS]
f = finder()
K = {key: f(ph) for key, ph in ANCH}
SH = {s['id']: {'start': s['start'], 'end': s['end'], 'word': s['word_at'], 'hit': s.get('hit_at')} for s in shots['shots']}
# heartbeat (lub times): accelerating under the hook, stops before "แต่ความจริง"; returns under the shadow,
# the last (strong) beat lands on the shadow shot's hit ("ทับอก"). Used by the vignette and by sound/make_heart.py.
HB = [0.05, 0.82, 1.52, 2.16, 2.74, 3.28]
hs = SH['shadow']
HB2 = [round(hs['hit'] - 1.08, 3), round(hs['hit'] - 0.54, 3), hs['hit']]
assert HB[-1] + 0.3 < SH['truth']['start'] and HB2[0] > hs['start']
DATA = {'dur': DUR, 'capt': CAPT, 'k': K, 'sh': SH, 'hb': HB + HB2}

def caps():
    out = []
    for i, txt in enumerate(CAPS):
        s = CAPT[i]
        e = CAPT[i + 1] if i + 1 < len(CAPT) else DUR
        d = round(e - s, 3)
        assert d >= 0.4, (txt, d)
        n = len(txt.replace('*', ''))
        size = 96 if n <= 9 else (86 if n <= 13 else 78)
        body = re.sub(r'\*(.+?)\*', r'<em>\1</em>', html.escape(txt))
        out.append(f'  <div id="c{i}" class="clip cap" data-start="{s}" data-duration="{d}" '
                   f'data-track-index="20"><span style="font-size:{size}px">{body}</span></div>')
    return '\n'.join(out)

if __name__ == '__main__':
    page = (HERE / 'index.html.tpl').read_text()
    for key, v in {'%%DUR%%': str(DUR), '%%CAPS%%': caps(), '%%DATA%%': json.dumps(DATA, ensure_ascii=False)}.items():
        page = page.replace(key, v)
    (HERE / 'index.html').write_text(page)
    # cover composition (1 frame): same page in THUMB mode, no audio, no captions
    tp = (HERE / 'index.html.tpl').read_text()
    for key, v in {'%%DUR%%': '1', '%%CAPS%%': '', '%%DATA%%': json.dumps(DATA, ensure_ascii=False)}.items():
        tp = tp.replace(key, v)
    tp = re.sub(r'<audio[^>]*></audio>\n', '', tp)
    tp = tp.replace('data-composition-id="main"', 'data-composition-id="thumb"').replace('window.__timelines["main"]', 'window.__timelines["thumb"]')
    tp = tp.replace('<script>\n/* Motion', '<script>window.__THUMB=1;</script>\n<script>\n/* Motion')
    tp = re.sub(r'<img [^>]*belief[^>]*/>', '', tp)
    (HERE / 'thumb' / 'index.html').write_text(tp)
    print('dur', DUR, 'captions', len(CAPS))
    print('K', K)
    print('HB', DATA['hb'])
