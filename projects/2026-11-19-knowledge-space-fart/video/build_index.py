#!/usr/bin/env python3
"""Generates index.html from index.html.tpl (one composition, Thai only).
Shot times come from ../assets/audio/shots-th.json (never set by hand).
Caption chunks and word anchors are located in ../assets/audio/words.json (the real voice): each time is the
start of the first character of the phrase. Lucide icons are inlined as <symbol>s. Run: python3 build_index.py"""
import html, json, math, pathlib, re

HERE = pathlib.Path(__file__).resolve().parent
AUD = HERE.parent / 'assets' / 'audio'
LUC = [HERE / 'lucide', HERE.parents[2] / 'assets' / 'vendor' / 'lucide']  # project-local extras first (fan, wind, message-circle)
# scribe wrote "เม้น"; the screen spells the script: เมนต์
ALIAS = {'เมนต์': 'เม้น'}

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

# caption chunks (1-3 words, script spelling); *x* = key word (yellow). The hook line is the big title (frame 0).
CAPS = ["หลายคนเชื่อว่า", "ตด*แรงๆ*", "ทีเดียว", "ตัวจะ*พุ่งไป*", "เหมือน*จรวด*เลย",
        "นักบินอวกาศ", "*คริส แฮดฟิลด์*", "เล่าว่า", "พวกเขา*ลองกัน*", "มาหมดแล้วจริงๆ",
        "แต่*ไม่ได้ผล*", "เพราะลมมัน", "*แผ่ว*เกินไป", "แล้ว*ก้น*เรา", "ก็ไม่ใช่*หัวฉีด*", "*จรวด*ซะด้วย",
        "*ปัญหา*จริงๆ", "คือ*กลิ่น*ต่างหาก", "ในอวกาศ", "อากาศ*ไม่ลอย*", "ขึ้นลงเอง", "เหมือนบนโลก",
        "ถ้าไม่มี*พัดลม*", "กลิ่นก็จะ*ค้าง*", "อยู่แถวนั้นแหละ", "สถานีอวกาศ", "เลยต้องเปิด", "*พัดลม*ตลอด",
        "และมี*ไส้กรองถ่าน*", "คอย*จับกลิ่น*ไว้", "แล้วถ้าเป็น*คุณ*", "จะลองตด", "ในอวกาศ*ไหม?*", "*เมนต์*บอกหน่อย"]
# word anchors for the motion, searched in speech order
ANCH = [('tod0', 'ถ้าตด'), ('kerd', 'เกิดอะไร'), ('chuea', 'หลายคนเชื่อ'), ('raeng', 'แรงๆ'), ('tidiao', 'ทีเดียว'),
        ('phung', 'พุ่งไป'), ('jaruat', 'จรวด'), ('nakbin', 'นักบิน'), ('chris', 'คริส'), ('lao', 'เล่าว่า'),
        ('phuak', 'พวกเขา'), ('long', 'ลองกัน'), ('maidai', 'ไม่ได้'), ('phon', 'ผล'), ('lom', 'ลมมัน'), ('phaeo', 'แผ่ว'),
        ('kon', 'ก้น'), ('maichai', 'ไม่ใช่'), ('huachit', 'หัวฉีด'), ('panha', 'ปัญหา'), ('klin', 'กลิ่น'),
        ('naiwakat', 'ในอวกาศ'), ('mailoi', 'ไม่ลอย'), ('bonlok', 'บนโลก'), ('phatlom0', 'พัดลม'), ('klin2', 'กลิ่น'),
        ('khang', 'ค้าง'), ('sathani', 'สถานี'), ('poed', 'เปิด'), ('phatlom', 'พัดลม'), ('tlot', 'ตลอด'),
        ('saikrong', 'ไส้กรอง'), ('than', 'ถ่าน'), ('jap', 'จับกลิ่น'), ('khun', 'คุณ'), ('jalong', 'จะลอง'),
        ('tod2', 'ตด'), ('mai', 'ไหม'), ('ment', 'เมนต์'), ('noi', 'หน่อย')]
ICONS = ['rocket', 'circle-help', 'circle-x', 'circle-check', 'fan', 'wind', 'message-circle', 'globe', 'arrow-up',
         'users', 'thermometer', 'triangle-alert']

shots = json.loads((AUD / 'shots-th.json').read_text())
DUR = math.floor(shots['duration'] * 30) / 30  # clip ends with the voice (no silent tail), on a frame boundary
DUR = round(DUR, 3)
f = finder(); capt = [f(c) for c in CAPS]
f = finder(); K = {key: f(ph) for key, ph in ANCH}
SH = {s['id']: {'start': s['start'], 'end': s['end'], 'word': s['word_at'], 'hit': s.get('hit_at'),
                'ms': s.get('media_start')} for s in shots['shots']}
SH['loop']['end'] = DUR
DATA = {'dur': DUR, 'capt': capt, 'k': K, 'sh': SH}

def caps():
    out = []
    for i, txt in enumerate(CAPS):
        s = capt[i]
        e = capt[i + 1] if i + 1 < len(capt) else DUR
        d = round(e - s, 3)
        assert d >= 0.4, (txt, d)
        n = len(re.sub(r'[ัิ-ฺ็-๎* ]', '', txt))  # base glyphs only (marks take no width)
        size = 96 if n <= 9 else (88 if n <= 11 else (80 if n <= 13 else 72))
        body = re.sub(r'\*(.+?)\*', r'<em>\1</em>', html.escape(txt))
        out.append(f'  <div id="c{i}" class="clip cap" data-start="{s}" data-duration="{d}" '
                   f'data-track-index="20"><span style="font-size:{size}px">{body}</span></div>')
    return '\n'.join(out)

def icons():
    out = []
    for n in ICONS:
        src = next((d / f'{n}.svg') for d in LUC if (d / f'{n}.svg').exists()).read_text()
        inner = re.search(r'<svg[^>]*>\s*(.*)</svg>', src, re.S).group(1).strip()
        inner = re.sub(r'\s+', ' ', inner)
        out.append(f'<symbol id="ic-{n}" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" '
                   f'stroke-linecap="round" stroke-linejoin="round">{inner}</symbol>')
    return '\n'.join(out)

page = (HERE / 'index.html.tpl').read_text()
rep = {'%%DUR%%': str(DUR), '%%CAPS%%': caps(), '%%ICONS%%': icons(), '%%DATA%%': json.dumps(DATA, ensure_ascii=False)}
for key, v in rep.items():
    page = page.replace(key, v)
assert '%%' not in page, re.findall(r'%%\w+%%', page)
(HERE / 'index.html').write_text(page)
if __name__ == '__main__':
    print('dur', DUR, 'captions', len(CAPS))
    print('K', K)
