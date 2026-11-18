#!/usr/bin/env python3
"""Generates index.html from index.html.tpl (one composition, Thai only).
Shot times come from ../assets/audio/shots-th.json (never set by hand).
Caption chunks and word anchors are located in ../assets/audio/words.json (the real voice):
each time is the start of the first character of the phrase. Run: python3 build_index.py"""
import html, json, pathlib, re

HERE = pathlib.Path(__file__).resolve().parent
AUD = HERE.parent / 'assets' / 'audio'
TAIL = 0.46  # vo-th.mp3 is 26.64 s; video = vo + short tail (<= 0.6 s)
VO_DUR = 26.64
# scribe transcribed the breed as English "Turkish Van"; the screen shows the Thai spelling
ALIAS = {'เตอร์กิชแวน': 'turkishvan'}

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

# caption chunks (1-3 words); *x* = key word (yellow). The hook line is the big title (frame 0), not a caption.
CAPS = ["หลายคนเชื่อว่า", "แมวทุกตัว", "เกลียดน้ำ", "แต่ความจริงคือ", "*เสือปลา*", "ที่พบในไทย", "*ดำน้ำ*จับปลากิน",
        "เป็นปกติ", "แมวบางพันธุ์", "อย่าง*เตอร์กิชแวน*", "ก็ขึ้นชื่อว่า", "ชอบ*เล่นน้ำ*", "สัตวแพทย์", "อธิบายว่า",
        "ขนแมวเปียก", "แล้ว*หนัก*", "*แห้งช้า*", "แมวเลยอาจ", "ไม่สบายตัว", "และบรรพบุรุษ", "แมวบ้านมาจาก",
        "ถิ่น*แห้งแล้ง*", "บางคนเลย", "*เดา*ว่า", "แมวไม่คุ้น", "กับน้ำ", "แมวหลายตัว", "*ว่ายน้ำได้*",
        "แค่ไม่อยาก*เปียก*", "แมวที่บ้านคุณ", "*ทีมเล่นน้ำ*", "หรือ*ทีมข่วน*?"]
# word anchors for the motion, searched in speech order
ANCH = [('belief', 'หลายคน'), ('truth', 'ความจริง'), ('fcat', 'เสือปลา'), ('thai', 'ไทย'), ('dive', 'ดำน้ำ'),
        ('fish', 'ปลากิน'), ('breed', 'แมวบางพันธุ์'), ('van', 'Turkish'), ('famous', 'ขึ้นชื่อ'), ('play', 'เล่นน้ำ'),
        ('vet', 'สัตวแพทย์'), ('fur', 'ขนแมว'), ('wet', 'เปียก'), ('heavy', 'หนัก'), ('dryslow', 'แห้งช้า'),
        ('uncomf', 'ไม่สบาย'), ('anc', 'บรรพบุรุษ'), ('from', 'มาจาก'), ('arid', 'แห้งแล้ง'), ('guess', 'เดาว่า'),
        ('water', 'กับน้ำ'), ('swim', 'ว่ายน้ำได้'), ('just', 'แค่'), ('wetx', 'เปียก'), ('ask', 'แมวที่บ้าน'),
        ('b1', 'ทีมเล่นน้ำ'), ('b2', 'ทีมข่วน')]

shots = json.loads((AUD / 'shots-th.json').read_text())
DUR = round(VO_DUR + TAIL, 3)
f = finder(); capt = [f(c) for c in CAPS]
f = finder(); K = {key: f(ph) for key, ph in ANCH}
SH = {s['id']: {'start': s['start'], 'end': s['end'], 'word': s['word_at'], 'hit': s.get('hit_at')} for s in shots['shots']}
DATA = {'dur': DUR, 'capt': capt, 'k': K, 'sh': SH}

def caps():
    out = []
    for i, txt in enumerate(CAPS):
        s = capt[i]
        e = capt[i + 1] if i + 1 < len(capt) else DUR
        d = round(e - s, 3)
        assert d >= 0.4, (txt, d)
        n = len(re.sub(r'[ัิ-ฺ็-๎*]', '', txt))  # base glyphs only (marks take no width)
        size = 96 if n <= 9 else (88 if n <= 11 else 80)
        body = re.sub(r'\*(.+?)\*', r'<em>\1</em>', html.escape(txt))
        out.append(f'  <div id="c{i}" class="clip cap" data-start="{s}" data-duration="{d}" '
                   f'data-track-index="20"><span style="font-size:{size}px">{body}</span></div>')
    return '\n'.join(out)

T = {k: v['start'] for k, v in SH.items()}
VID = {  # video plates: start at the shot cut, run past the outgoing transition
    'VHOOK': (0, round(T['belief'] + 0.3, 3)),
    'VBELIEF': (T['belief'], round(T['fishing'] + 0.3 - T['belief'], 3)),
    'VDRY': (T['dry'], round(T['guess'] + 0.3 - T['dry'], 3)),
    'VASK': (T['ask'], round(DUR - T['ask'], 3)),
}
page = (HERE / 'index.html.tpl').read_text()
rep = {'%%DUR%%': str(DUR), '%%CAPS%%': caps(), '%%DATA%%': json.dumps(DATA, ensure_ascii=False)}
for k, (s, d) in VID.items():
    rep[f'%%{k}%%'] = f'data-start="{s}" data-duration="{d}"'
for key, v in rep.items():
    page = page.replace(key, v)
(HERE / 'index.html').write_text(page)
print('dur', DUR, 'captions', len(CAPS), 'K', K)
