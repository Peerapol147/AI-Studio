#!/usr/bin/env python3
"""Generates index.html from index.html.tpl (one composition, Thai only) - Messi vs Ronaldo episode.
Shot times come from ../assets/audio/shots-th.json (never set by hand).
Caption chunks and word anchors are located in ../assets/audio/words.json (the real voice): each time is the
start of the first character of the phrase. Lucide icons are inlined as <symbol>s.
Run: python3 build_index.py [--audio DIR] [--out FILE]"""
import argparse, hashlib, html, json, math, os, pathlib, re

HERE = pathlib.Path(__file__).resolve().parent

def repo_root():
    if os.environ.get('AI_STUDIO_ROOT'):
        return pathlib.Path(os.environ['AI_STUDIO_ROOT']).resolve()
    for d in [HERE, *HERE.parents]:
        if (d / 'assets' / 'vendor' / 'lucide').is_dir() or (d / '.git').exists():
            return d
    raise SystemExit(f'repo root not found above {HERE}; set AI_STUDIO_ROOT')

_ap = argparse.ArgumentParser(description=__doc__.split('\n')[0])
_ap.add_argument('--audio', type=pathlib.Path, default=HERE.parent / 'assets' / 'audio')
_ap.add_argument('--out', type=pathlib.Path, default=HERE / 'index.html')
ARGS, _ = _ap.parse_known_args()
AUD = ARGS.audio.resolve()
LUC = repo_root() / 'assets' / 'vendor' / 'lucide'
ALIAS = {}

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

# caption chunks (1-3 words): (on screen, as spoken in words.json). *x* = key word (yellow).
# Screen spells the script: numbers as digits, กินเนสส์ / เมนต์ (scribe wrote กินเนส / เม้นต์).
# The hook line (0-2.9 s) is the big title + name cards, not a caption.
CAPS = [("ถามทีไร", None), ("วง*แตก*ทุกที", None), ("*เถียง*กันไม่เคยจบ", None), ("สักวงเลย", None),
        ("ก็*10 ปี*เต็ม", "ก็สิบปีเต็ม"), ("จาก *2008-2017*", "จาก2008-2017"), ("*บัลลงดอร์*", None), ("มีเจ้าของ", None),
        ("แค่*สองคน*", None), ("แบ่งกันคนละ", None), ("*5 ใบ*เป๊ะ", "ห้าใบเป๊ะ"), ("งั้นมา*แลกหมัด*", None),
        ("กันเลยครับ", None), ("*หมัดแรก*", None), ("*เมสซี่*", None), ("ปี *2012*", "ปี2012"), ("ปีเดียวยิงไป", None),
        ("*91 ลูก*", "เก้าสิบเอ็ดลูก"), ("กินเนสส์บันทึก", "กินเนสบันทึก"), ("เป็น*สถิติโลก*", None), ("*CR7*", "CR7"),
        ("*สวน*ทันที", None), ("ยิงใน*แชมเปียนส์ลีก*", None), ("*140 ลูก*", "ร้อยสี่สิบลูก"), ("มากสุด*ตลอดกาล*", None),
        ("โรนัลโด้*ยกถ้วย*", None), ("แชมเปียนส์ลีก", None), ("*5 สมัย*", "ห้าสมัย"), ("เมสซี่ตอบด้วย", None),
        ("*บัลลงดอร์*", None), ("*8 ใบ*", "แปดใบ"), ("เมสซี่ได้", None), ("*แชมป์โลก*", None), ("*2022*", None),
        ("ฝันที่รอมา", None), ("ทั้งชีวิต", None), ("โรนัลโด้พา", None), ("โปรตุเกส", None), ("คว้า*ยูโร 2016*", "คว้ายูโร2016"),
        ("แถมยิงทีมชาติ", None), ("*146 ลูก*", "ร้อยสี่สิบหกลูก"), ("*สถิติโลก*", None), ("ฝั่งผู้ชายเลยนะ", None),
        ("ฝั่งละ *3 หมัด*", "ฝั่งละสามหมัด"), ("ไม่มีใคร*ล้ม*", None), ("แบบนี้", None), ("จะให้*เถียงจบ*", None),
        ("ได้ไงล่ะ", None), ("ปีนี้ทั้งคู่", None), ("ก็ประกาศ", None), ("*เลิกเล่นทีมชาติ*", None), ("ไปแล้ว", None),
        ("แต่ยังไง", None), ("พวกเราก็", None), ("*โชคดีที่สุด*", None), ("ที่เกิดทันดู", None), ("ยุคของนักเตะ", None),
        ("ระดับ*ปรากฏการณ์*", None), ("อย่าง*เมสซี่*", None), ("กับ*โรนัลโด้*", None), ("แล้วเพื่อนอยู่", None),
        ("*ทีมไหน?*", "ทีมไหน"), ("*เมนต์*มาเลย", "เม้นต์มาเลย")]
# word anchors for the motion, searched in speech order
ANCH = [('messi0', 'เมสซี่'), ('ronaldo0', 'โรนัลโด้'), ('khrai', 'ใครเก่ง'), ('tham', 'ถามทีไร'), ('taek', 'แตก'),
        ('thiang', 'เถียงกัน'), ('sakwong', 'สักวง'), ('sippi', 'สิบปี'), ('y0817', '2008-2017'), ('bdo', 'บัลลงดอร์'),
        ('songkhon', 'สองคน'), ('haabai', 'ห้าใบ'), ('ngan', 'งั้น'), ('laek', 'แลก'), ('mat', 'หมัดกัน'), ('matraek', 'หมัดแรก'),
        ('messi1', 'เมสซี่'), ('y2012', '2012'), ('pidiao', 'ปีเดียว'), ('n91', 'เก้าสิบเอ็ด'), ('luk91', 'ลูก'),
        ('guin', 'กินเนส'), ('sathiti', 'สถิติโลก'), ('cr7', 'cr7'), ('suan', 'สวน'), ('ucl', 'แชมเปียนส์ลีก'),
        ('n140', 'ร้อยสี่สิบ'), ('luk140', 'ลูก'), ('makssud', 'มากสุด'), ('talod', 'ตลอดกาล'), ('ronaldo2', 'โรนัลโด้'),
        ('yokthuay', 'ยกถ้วย'), ('haasamai', 'ห้าสมัย'), ('messi3', 'เมสซี่'), ('bdo2', 'บัลลงดอร์'), ('paetbai', 'แปดใบ'),
        ('messi4', 'เมสซี่'), ('champlok', 'แชมป์โลก'), ('y2022', '2022'), ('fan', 'ฝันที่'), ('ronaldo3', 'โรนัลโด้'),
        ('euro', 'ยูโร'), ('y2016', '2016'), ('thaem', 'แถมยิง'), ('n146', 'ร้อยสี่สิบหก'), ('luk146', 'ลูก'),
        ('sathiti2', 'สถิติโลก'), ('phuchai', 'ผู้ชาย'), ('samat', 'สามหมัด'), ('lom', 'ล้ม'), ('baebni', 'แบบนี้'),
        ('thiangjob', 'เถียงจบ'), ('pini', 'ปีนี้'), ('lerk', 'เลิกเล่น'), ('chokdee', 'โชคดี'), ('kerdtan', 'ที่เกิดทัน'),
        ('yuk', 'ยุค'), ('prakot', 'ปรากฏการณ์'), ('messi5', 'เมสซี่'), ('ronaldo5', 'โรนัลโด้'), ('teamnai', 'ทีมไหน'),
        ('men', 'เม้นต์')]
ICONS = ['trophy', 'globe', 'star', 'message-circle', 'users', 'flame', 'zap', 'calendar', 'heart']

def load_shots():
    f = AUD / 'shots-th.json'
    if not f.exists():
        raise SystemExit(f'{f} missing: run python3 tools/shot_times.py <project> th')
    s = json.loads(f.read_text())
    proj = AUD.parents[1]
    for name, want in (s.get('inputs') or {}).items():
        p = proj / name
        have = hashlib.sha256(p.read_bytes()).hexdigest() if p.exists() else None
        if have != want:
            raise SystemExit(f'{f} is stale: {name} changed after shot_times ran.')
    return s

shots = load_shots()
DUR = round(math.floor(shots['duration'] * 30) / 30, 3)
f = finder(); capt = [f(s or d) for d, s in CAPS]
f = finder(); K = {key: f(ph) for key, ph in ANCH}
SH = {s['id']: {'start': s['start'], 'end': s['end'], 'word': s['word_at'], 'hit': s.get('hit_at')} for s in shots['shots']}
SH['cta']['end'] = DUR
DATA = {'dur': DUR, 'capt': capt, 'k': K, 'sh': SH}

def caps():
    out = []
    for i, (txt, _) in enumerate(CAPS):
        s = capt[i]
        e = capt[i + 1] if i + 1 < len(capt) else DUR
        d = round(e - s, 3)
        assert d >= 0.4, (txt, d)
        n = len(re.sub(r'[ัิ-ฺ็-๎* ]', '', txt))  # base glyphs only (marks take no width)
        size = 96 if n <= 9 else (88 if n <= 11 else (80 if n <= 14 else 70))
        body = re.sub(r'\*(.+?)\*', r'<em>\1</em>', html.escape(txt))
        out.append(f'  <div id="c{i}" class="clip cap" data-start="{s}" data-duration="{d}" '
                   f'data-track-index="20"><span style="font-size:{size}px">{body}</span></div>')
    return '\n'.join(out)

def icons():
    out = []
    for n in ICONS:
        src = (LUC / f'{n}.svg').read_text()
        inner = re.sub(r'\s+', ' ', re.search(r'>\s*(.*)</svg>', src, re.S).group(1).strip())
        out.append(f'<symbol id="ic-{n}" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" '
                   f'stroke-linecap="round" stroke-linejoin="round">{inner}</symbol>')
    return '\n'.join(out)

page = (HERE / 'index.html.tpl').read_text()
rep = {'%%DUR%%': str(DUR), '%%CAPS%%': caps(), '%%ICONS%%': icons(), '%%DATA%%': json.dumps(DATA, ensure_ascii=False)}
for key, v in rep.items():
    page = page.replace(key, v)
assert '%%' not in page, re.findall(r'%%\w+%%', page)
if __name__ == '__main__':
    ARGS.out.write_text(page)
    print('dur', DUR, 'captions', len(CAPS))
    print('K', K)
