#!/usr/bin/env python3
"""Generates index.html from index.html.tpl (one composition, Thai only).
Shot times come from ../assets/audio/shots-th.json (never set by hand); footage in-points (media_start)
come from ../shots.json. Caption chunks and word anchors are located in ../assets/audio/words.json
(the real voice): each time is the start of the first character of the phrase. Run: python3 build_index.py"""
import html, json, pathlib, re

HERE = pathlib.Path(__file__).parent
PROJ = HERE.parent
AUD = PROJ / 'assets' / 'audio'
# the transcript spells the sound "ก๊อบ" and the outro word "เม้น"; the screen shows the script spelling
ALIAS = {'กร๊อบ': 'ก๊อบ', 'เมนต์': 'เม้น'}

def norm(s):
    for a, b in ALIAS.items():
        s = s.replace(a, b)
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

# caption chunks (1-3 words); *x* = key word (yellow). The hook line is the big title (frame 0), not a caption.
CAPS = ["เข่าเสื่อม", "หรือเปล่า?", "เคยโดนทักป่ะ", "ว่าเข่าดัง", "เพราะ*น้ำในข้อแห้ง*", "จริงๆ แล้ว...", "เข่าดัง",
        "เจอได้*บ่อยมาก*", "แม้แต่คนที่", "ไม่เจ็บเข่า", "เสียงอาจมาจาก", "*ฟองแก๊ส*", "ในน้ำไขข้อ", "หรือ*เอ็น*ที่ลาก",
        "ผ่านกระดูก", "แต่ก็มีงานวิจัย", "เจอว่า", "คนที่เข่าดัง", "บ่อยๆ", "*เสี่ยง*เข่าเสื่อม", "มากกว่านะ",
        "ดังแต่ไม่เจ็บ", "ส่วนใหญ่ไม่ต้องห่วง", "แต่ถ้าเจ็บ", "บวม", "หรือติดขัดด้วย", "ไป*หาหมอ*เลย",
        "แล้วเข่าใคร", "ดังบ้าง?", "เมนต์บอกหน่อย"]
# word anchors for the motion, searched in speech order
ANCH = [('crack', 'กร๊อบ'), ('tak', 'ทัก'), ('water', 'น้ำในข้อ'), ('dry', 'แห้ง'), ('truth', 'จริงๆ'), ('often', 'บ่อยมาก'),
        ('nopain', 'ไม่เจ็บ'), ('sound', 'เสียง'), ('gas', 'ฟองแก๊ส'), ('fluid', 'น้ำไขข้อ'), ('tendon', 'เอ็น'),
        ('drag', 'ลาก'), ('bone', 'กระดูก'), ('study', 'งานวิจัย'), ('often2', 'บ่อยๆ'), ('risk', 'เสี่ยง'),
        ('ok', 'ไม่เจ็บ'), ('fine', 'ไม่ต้องห่วง'), ('hurt', 'เจ็บ'), ('swell', 'บวม'), ('stiff', 'ติดขัด'),
        ('doctor', 'หาหมอ'), ('ask', 'แล้วเข่าใคร'), ('dang', 'ดังบ้าง'), ('comment', 'เมนต์')]

shots = json.loads((AUD / 'shots-th.json').read_text())
plan = {s['id']: s for s in json.loads((PROJ / 'shots.json').read_text())['shots']}
DUR = round(shots['duration'], 3)
f = finder()
CAPT = [f(c) for c in CAPS]
f = finder()
K = {key: f(ph) for key, ph in ANCH}
SH = {s['id']: {'start': s['start'], 'end': s['end'], 'word': s['word_at'], 'hit': s.get('hit_at'),
                'media': plan.get(s['id'], {}).get('media_start', 0)} for s in shots['shots']}
DATA = {'dur': DUR, 'capt': CAPT, 'k': K, 'sh': SH}

def caps():
    out = []
    for i, txt in enumerate(CAPS):
        s = CAPT[i]
        e = CAPT[i + 1] if i + 1 < len(CAPT) else DUR
        d = round(e - s, 3)
        assert d >= 0.4, (txt, d)
        n = len(re.sub(r'[ัิ-ฺ็-๎*]', '', txt))  # spacing characters only
        size = 100 if n <= 8 else (90 if n <= 11 else 80)
        body = re.sub(r'\*(.+?)\*', r'<em>\1</em>', html.escape(txt))
        out.append(f'  <div id="c{i}" class="clip cap" data-start="{s}" data-duration="{d}" '
                   f'data-track-index="20"><span style="font-size:{size}px">{body}</span></div>')
    return '\n'.join(out)

TOP = {'common': 285, 'nopain': 150, 'study': 285, 'doctor': 330}
HGT = {'common': 1350, 'nopain': 1080, 'study': 1350, 'doctor': 926}

def vid(id_, shot, src):
    s = SH[shot]
    st = round(s['start'], 3)
    d = round(s['end'] - s['start'] + 0.2, 3)   # +0.2 s covers the outgoing whip
    return (f'<video id="v-{id_}" class="clip band vb" data-start="{st}" data-duration="{d}" data-media-start="{s["media"]}" '
            f'data-track-index="{5}" muted playsinline src="assets/{src}" style="top:{TOP[id_]}px;height:{HGT[id_]}px"></video>')

page = (HERE / 'index.html.tpl').read_text()
rep = {'%%DUR%%': str(DUR), '%%CAPS%%': caps(), '%%DATA%%': json.dumps(DATA, ensure_ascii=False),
       '%%V_COMMON%%': vid('common', 'common', 'common.mp4'), '%%V_NOPAIN%%': vid('nopain', 'nopain', 'nopain.mp4'),
       '%%V_STUDY%%': vid('study', 'study', 'study.mp4'), '%%V_DOCTOR%%': vid('doctor', 'doctor', 'doctor.mp4')}
for key, v in rep.items():
    page = page.replace(key, v)
(HERE / 'index.html').write_text(page)
print('dur', DUR, 'captions', len(CAPS))
print('K', K)
print('media', {k: v['media'] for k, v in SH.items() if v['media']})
