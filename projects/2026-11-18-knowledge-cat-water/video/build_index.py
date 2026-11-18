#!/usr/bin/env python3
"""Generates index.html from index.html.tpl (one composition, variable "lang": th | en).
Shot times come from ../assets/audio/shots-<lang>.json (never set by hand).
Caption chunks and word anchors are located in ../assets/audio/words*.json (the real voice):
each time is the start of the first character of the phrase. Run: python3 build_index.py"""
import html, json, pathlib, re

HERE = pathlib.Path(__file__).parent
AUD = HERE.parent / 'assets' / 'audio'
SRC = {'th': ('shots-th.json', 'words.json'), 'en': ('shots-en.json', 'words-en.json')}
# the transcript spells the sound "ก๊อบ" and the outro word as English "Comment"; the screen shows the script spelling
ALIAS = {'กร๊อบ': 'ก๊อบ', 'คอมเมนต์': 'comment'}

def norm(s):
    s = s.lower()
    for a, b in ALIAS.items():
        s = s.replace(a, b)
    return re.sub(r"[\s*?!.,'’…]", '', s)

def finder(lang):
    words = [w for w in json.loads((AUD / SRC[lang][1]).read_text())['words'] if w.get('type', 'word') == 'word']
    ch = []
    for w in words:
        for c in norm(w['text']):
            ch.append((c, w['start']))
    flat = ''.join(c for c, _ in ch)
    pos = 0
    def find(phrase, reset=False):
        nonlocal pos
        if reset:
            pos = 0
        p = norm(phrase)
        i = flat.find(p, pos)
        assert i >= 0, ('not in words', lang, phrase)
        pos = i + len(p)
        return round(ch[i][1], 3)
    return find

# caption chunks (1-3 words TH, 1-4 EN); *x* = key word (yellow). The hook line is the big title (frame 0), not a caption.
CAPS = {
 'th': ["ผู้ใหญ่ชอบขู่ว่า", "กระดูกเสียดสีกัน", "เดี๋ยวข้อเสื่อม", "แต่ความจริงคือ", "ในข้อนิ้ว", "มีน้ำหล่อลื่นอยู่",
        "พอดึงข้อออก", "ความดันลดลง", "เกิด*ฟองแก๊ส*", "แล้วก็ดัง*กร๊อบ*", "หมอคนหนึ่ง", "หักนิ้วแค่มือซ้าย",
        "มาหลายสิบปี", "สุดท้าย*ไม่มี*", "ข้ออักเสบ", "สักข้าง", "แต่ถ้าหักแล้ว", "เจ็บหรือบวม", "ไป*หาหมอ*นะ",
        "แล้วคุณหักนิ้ว", "วันละกี่ที?", "คอมเมนต์เลย!"],
 'en': ["People say it's", "bones grinding,", "causing arthritis.", "But actually,", "your joints hold", "slippery fluid.",
        "Pull them apart,", "pressure drops,", "a gas *bubble*", "forms...", "pop!", "One doctor", "*cracked* only his",
        "left hand", "for decades.", "*Neither* hand", "got arthritis.", "If it hurts", "or swells,", "see a *doctor.*",
        "How often do you", "*crack* yours?", "Comment below!"],
}
# word anchors for the motion, searched in speech order
ANCH = {
 'th': [('crack1', 'ก๊อบ'), ('grind', 'เสียดสี'), ('truth', 'แต่ความจริง'), ('fluid', 'น้ำหล่อลื่น'), ('pull', 'พอดึง'),
        ('press', 'ความดัน'), ('bubble', 'ฟองแก๊ส'), ('pop', 'ก๊อบ'), ('doctor', 'หมอ'), ('left', 'มือซ้าย'),
        ('decades', 'หลายสิบปี'), ('none', 'ไม่มี'), ('both', 'สักข้าง'), ('hurt', 'เจ็บ'), ('see', 'ไปหาหมอ'),
        ('ask', 'แล้วคุณ'), ('howmany', 'กี่ที'), ('comment', 'Comment')],
 'en': [('crack1', 'crack'), ('grind', 'grinding'), ('truth', 'But'), ('fluid', 'slippery'), ('pull', 'Pull'),
        ('press', 'pressure'), ('bubble', 'bubble'), ('pop', 'pop'), ('doctor', 'doctor'), ('left', 'left'),
        ('decades', 'decades'), ('none', 'Neither'), ('both', 'arthritis'), ('hurt', 'hurts'), ('see', 'see'),
        ('ask', 'How'), ('howmany', 'often'), ('comment', 'Comment')],
}

DATA = {}
for lang in ('th', 'en'):
    shots = json.loads((AUD / SRC[lang][0]).read_text())
    dur = round(shots['duration'], 3)
    f = finder(lang)
    capt = [f(c) for c in CAPS[lang]]
    f = finder(lang)
    k = {}
    for key, ph in ANCH[lang]:
        k[key] = f(ph)
    sh = {s['id']: {'start': s['start'], 'end': s['end'], 'word': s['word_at'], 'hit': s.get('hit_at')} for s in shots['shots']}
    DATA[lang] = {'dur': dur, 'capt': capt, 'k': k, 'sh': sh}

def caps(lang):
    out, capt, dur = [], DATA[lang]['capt'], DATA[lang]['dur']
    for i, txt in enumerate(CAPS[lang]):
        s = capt[i]
        e = capt[i + 1] if i + 1 < len(capt) else dur
        d = round(e - s, 3)
        assert d >= 0.4, (lang, txt, d)
        n = len(txt.replace('*', ''))
        if lang == 'th':
            size = 96 if n <= 9 else (86 if n <= 13 else 76)
        else:
            size = 92 if n <= 10 else (80 if n <= 15 else 70)
        body = re.sub(r'\*(.+?)\*', r'<em>\1</em>', html.escape(txt))
        out.append(f'  <div id="c{lang}{i}" class="clip cap" data-start="{s}" data-duration="{d}" '
                   f'data-track-index="{20 if lang == "th" else 21}"><span style="font-size:{size}px">{body}</span></div>')
    return '\n'.join(out)

DUR = max(DATA['th']['dur'], DATA['en']['dur'])
page = (HERE / 'index.html.tpl').read_text()
for key, v in {'%%DUR%%': str(DUR), '%%CAPS_TH%%': caps('th'), '%%CAPS_EN%%': caps('en'),
               '%%DATA%%': json.dumps(DATA, ensure_ascii=False)}.items():
    page = page.replace(key, v)
(HERE / 'index.html').write_text(page)
for lang in DATA:
    print(lang, DATA[lang]['dur'], 'captions', len(CAPS[lang]), 'K', DATA[lang]['k'])
