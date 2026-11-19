#!/usr/bin/env python3
"""Generates index.html from index.html.tpl (one composition, Thai only).
Shot times come from ../assets/audio/shots-th.json (never set by hand); footage plates are timed from them.
Caption chunks and word anchors are located in ../assets/audio/words.json (the real voice): each time is the
start of the first character of the phrase. Lucide icons are inlined as <symbol>s. Run: python3 build_index.py"""
import html, json, math, pathlib, re

HERE = pathlib.Path(__file__).resolve().parent
AUD = HERE.parent / 'assets' / 'audio'
LUC = HERE.parents[2] / 'assets' / 'vendor' / 'lucide'
# scribe wrote "ตื้อ" / "Bitcoin" / "2000"; the screen spells the script: ตื๊อ / บิตคอยน์ / 2000
ALIAS = {'ตื๊อ': 'ตื้อ', 'บิตคอยน์': 'bitcoin', 'สองพัน': '2000'}

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

# caption chunks (1-3 words); *x* = key word (yellow); "shown|searched" when the screen differs from the speech.
# Hook (0-2.3) and outro (35.1-end) have no caption: the big title on screen is the spoken line word for word.
CAPS = ["*รวย*ยังไงดี?|รวยยังไงดี", "ง่ายดิ", "เรารู้*อนาคต*หมด|เรารู้อนาคตหมด", "แต่*เดี๋ยวนะ*", "ปี 2000|ปี2000",
        "เราเพิ่ง *ป.2*|เราเพิ่งป.สอง", "เองอะ|เองอ่ะ", "เปิด*บัญชีหุ้น*", "เองก็ไม่ได้", "ต้องรอ*อายุ 20*|ต้องรออายุยี่สิบ",
        "งั้น*ภารกิจแรก*", "*ตื๊อแม่*", "ซื้อ*ทอง*เก็บไว้", "ตอนนั้นบาทละ", "*ห้าพันกว่า*", "ตอนนี้*หกหมื่นกว่า*",
        "แล้วนะ", "*ภารกิจสอง*", "อ้อนพ่อ", "ซื้อ*หุ้นไทย*", "ตอนนั้น*ดัชนี*", "แค่*สองร้อยกว่า*จุด", "ตอนนี้ราว",
        "*พันห้า*", "*ภารกิจสาม*", "เก็บค่าขนม", "รอ*บิตคอยน์*...|รอบิตคอยน์", "แต่กว่าจะมี", "ให้ซื้อ", "เราก็ขึ้น",
        "*ม.ปลาย*แล้ว|ม.ปลายแล้ว", "ต้อง*ตื๊อพ่อแม่*", "อีกรอบ", "แถมมันเคย*ร่วง*", "ราว*เก้าในสิบ*"]
# "ถือไหวป่ะ?" (34.22) is the big kinetic line of the hold shot = the speech, so no caption from there on
# word anchors for the motion, searched in speech order
ANCH = [('pee', 'ปี'), ('y2000', '2000'), ('ruay', 'รวย'), ('ngai', 'ง่ายดิ'), ('roo', 'รู้อนาคต'), ('wait', 'แต่เดี๋ยวนะ'),
        ('pee2', 'ปี2000'), ('p2', 'ป.สอง'), ('perd', 'เปิดบัญชี'), ('maidai', 'ไม่ได้'), ('torng', 'ต้องรอ'), ('ayu', 'อายุ'),
        ('yeesib', 'ยี่สิบ'), ('m1', 'ภารกิจแรก'), ('tuemae', 'ตื๊อแม่'), ('suethong', 'ซื้อทอง'), ('baht', 'บาทละ'),
        ('hapan', 'ห้าพัน'), ('tonni', 'ตอนนี้'), ('hok', 'หกหมื่น'), ('m2', 'ภารกิจสอง'), ('onpor', 'อ้อนพ่อ'),
        ('hun', 'หุ้นไทย'), ('dat', 'ดัชนี'), ('songroi', 'สองร้อย'), ('tonni2', 'ตอนนี้ราว'), ('panha', 'พันห้า'),
        ('m3', 'ภารกิจสาม'), ('kanom', 'ค่าขนม'), ('btc', 'บิตคอยน์'), ('kwa', 'กว่าจะมี'), ('sue', 'ซื้อ'), ('khuen', 'ขึ้น'),
        ('mplai', 'ม.ปลาย'), ('tue2', 'ตื๊อพ่อแม่'), ('rob', 'อีกรอบ'), ('tham', 'แถม'), ('ruang', 'ร่วง'), ('kao', 'เก้าในสิบ'),
        ('wai', 'ถือไหว'), ('pa', 'ป่ะ'), ('nai', 'ถ้าเป็นนาย'), ('tamtang', 'ทำต่าง'), ('yangngai', 'ยังไง')]
ICONS = ['calendar', 'baby', 'banknote', 'trending-up', 'trending-down', 'check', 'circle-help', 'bitcoin', 'coins', 'lock',
         'key', 'backpack', 'graduation-cap', 'message-circle', 'users', 'user', 'chart-line', 'triangle-alert', 'alarm-clock']

shots = json.loads((AUD / 'shots-th.json').read_text())
DUR = math.floor(shots['duration'] * 30) / 30  # clip ends with the voice (no silent tail), on a frame boundary
DUR = round(DUR, 3)
f = finder(); capt = [f(c.split('|')[-1]) for c in CAPS]
f = finder(); K = {key: f(ph) for key, ph in ANCH}
SH = {s['id']: {'start': s['start'], 'end': s['end'], 'word': s['word_at'], 'hit': s.get('hit_at'),
                'ms': s.get('media_start')} for s in shots['shots']}
SH['outro']['end'] = DUR
CEND = K['wai']  # captions stop where the big on-screen lines (= the speech) take over: hold + outro
DATA = {'dur': DUR, 'capt': capt, 'k': K, 'sh': SH, 'cend': CEND}

def caps():
    out = []
    for i, txt in enumerate(CAPS):
        s = capt[i]
        txt = txt.split('|')[0]
        e = capt[i + 1] if i + 1 < len(capt) else CEND
        d = round(e - s, 3)
        assert d >= 0.4, (txt, d)
        n = len(re.sub(r'[ัิ-ฺ็-๎*]', '', txt))  # base glyphs only (marks take no width)
        size = 96 if n <= 9 else (88 if n <= 11 else 80)
        body = re.sub(r'\*(.+?)\*', r'<em>\1</em>', html.escape(txt))
        out.append(f'  <div id="c{i}" class="clip cap" data-start="{s}" data-duration="{d}" '
                   f'data-track-index="20"><span style="font-size:{size}px">{body}</span></div>')
    return '\n'.join(out)

def icons():
    out = []
    for n in ICONS:
        src = (LUC / f'{n}.svg').read_text()
        inner = re.search(r'>\s*(.*)</svg>', src, re.S).group(1).strip()
        inner = re.sub(r'\s+', ' ', inner)
        out.append(f'<symbol id="ic-{n}" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" '
                   f'stroke-linecap="round" stroke-linejoin="round">{inner}</symbol>')
    return '\n'.join(out)

# footage scenes: (scene id = shot id, [plates], data-media-start). Plates keep the source clock (prep_assets.sh), so
# data-media-start = media_start from shots-th.json. Graphic shots (src null) run a blurred plate of the neighbouring
# footage, continuing where that footage left off. Outro: the hook plates ending on source 3.0 s = the frame-0 image.
ms = lambda k: SH[k]['ms']
FOOT = [('hook_year', ['hookc', 'hookw'], 3.0), ('wake_bed', ['bed'], ms('wake_bed')),
        ('future_mind', ['fm'], ms('future_mind')), ('kid_hands', ['kh'], ms('kid_hands')),
        ('kid_school', ['ks'], ms('kid_school')), ('locked', ['ksb'], 2.58), ('age20', ['ksb'], 4.28),
        ('gold', ['gold'], ms('gold')), ('gold_mom', ['gold'], ms('gold_mom')), ('gold_price', ['goldb'], 6.54),
        ('gold_now', ['goldb'], 7.82), ('stock', ['stock'], ms('stock')), ('stock_dad', ['stock'], ms('stock_dad')),
        ('set_price', ['stockb'], 6.7), ('set_now', ['stockb'], 8.26), ('piggy', ['pg'], ms('piggy')),
        ('coins', ['pg'], ms('coins')), ('teen', ['teenb'], ms('teen')), ('parents_again', ['teenb'], 3.78),
        ('crash', ['crash'], ms('crash')), ('hold', ['crashb'], 2.2),
        ('outro', ['hookc', 'hookw'], round(3.0 - (DUR - SH['outro']['start']), 3))]
assert [f[0] for f in FOOT] == [s['id'] for s in shots['shots']], 'one scene per shot, in order'
XF = 0.12  # outgoing plate stays 0.12 s under the incoming transition (crossfade <= 0.12 s)
def videos():
    out = {}
    for i, (sid, plates, m) in enumerate(FOOT):
        a = SH[sid]['start']; b = min(DUR, SH[sid]['end'] + XF)
        out[sid] = ''.join(f'<video id="v-{sid}-{p}" class="clip vid" data-start="{a}" data-duration="{round(b - a, 3)}" '
                           f'data-media-start="{m}" data-track-index="{1 + i % 2}" muted playsinline src="assets/{p}.mp4"></video>'
                           for p in plates)
    return out

page = (HERE / 'index.html.tpl').read_text()
rep = {'%%DUR%%': str(DUR), '%%CAPS%%': caps(), '%%ICONS%%': icons(), '%%DATA%%': json.dumps(DATA, ensure_ascii=False)}
for sid, tag in videos().items():
    rep[f'%%V_{sid.upper()}%%'] = tag
for key, v in rep.items():
    page = page.replace(key, v)
assert '%%' not in page, re.findall(r'%%\w+%%', page)
(HERE / 'index.html').write_text(page)
if __name__ == '__main__':
    print('dur', DUR, 'captions', len(CAPS), 'outro media_start', FOOT[-1][2])
    print('K', K)
