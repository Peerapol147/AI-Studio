#!/usr/bin/env python3
"""Generates index.html from index.html.tpl (one composition, variable "lang": th | en).
Shot times come from ../assets/audio/shots-<lang>.json (never set by hand): footage clips get
data-start = shot start and data-media-start = media_start, so the action lands on the word.
Caption chunks and word anchors are located in ../assets/audio/words*.json (the real voice):
each time is the start of the first character of the phrase. Run: python3 build_index.py"""
import html, json, pathlib, re

HERE = pathlib.Path(__file__).parent
AUD = HERE.parent / 'assets' / 'audio'
SRC = {'th': ('shots-th.json', 'words.json'), 'en': ('shots-en.json', 'words-en.json')}
# the transcript writes the outro word as English "Comment"; the screen shows the script spelling
ALIAS = {'คอมเมนต์': 'comment'}

def norm(s):
    s = s.lower()
    for a, b in ALIAS.items():
        s = s.replace(a, b)
    return re.sub(r"[\s*?!.,:'’…]", '', s)

def finder(lang):
    words = [w for w in json.loads((AUD / SRC[lang][1]).read_text())['words'] if w.get('type', 'word') == 'word']
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
        assert i >= 0, ('not in words', lang, phrase)
        pos = i + len(p)
        return round(ch[i][1], 3)
    return find

# caption chunks (1-3 words TH, 1-4 EN); *x* = key word (yellow). The hook line is the big title (frame 0), not a caption.
CAPS = {
 'th': ["หลายคนเชื่อว่า", "*หาว*เพราะ", "สมองขาด", "*ออกซิเจน*", "แต่ความจริงคือ", "นักวิจัยเคย", "ให้คนหายใจ",
        "*ออกซิเจน*บริสุทธิ์", "ผลคือ", "ก็ยัง*หาว*", "*เท่าเดิม*", "นักวิจัยบางคน", "คิดว่า", "การ*หาว*อาจ",
        "ช่วยให้สมอง", "*เย็นลง*", "แต่ยังเถียง", "กันอยู่", "แต่ถ้า*หาว*บ่อย", "ผิดปกติ", "หลายวัน", "ทั้งที่นอนพอ",
        "ไป*หาหมอ*นะ", "แล้วดูถึงตรงนี้", "*หาว*ไปกี่ทีแล้ว?", "คอมเมนต์เลย!"],
 'en': ["People say", "your brain needs", "more *oxygen,*", "but when scientists", "had people", "breathe pure *oxygen,*",
        "they *yawned*", "just as *much.*", "One idea:", "*yawning* may help", "*cool* your brain.", "It's still debated.",
        "*Yawning* way too much", "for days?", "See a *doctor.*", "So... how many times", "have you *yawned* yet?",
        "Comment below!"],
}
# word anchors for the motion, searched in speech order
ANCH = {
 'th': [('lack', 'ขาด'), ('pure', 'บริสุทธิ์'), ('yawnI', 'การหาว'), ('ask', 'แล้วดู'), ('howmany', 'กี่ที'), ('comment', 'Comment')],
 'en': [('lack', 'needs'), ('pure', 'pure'), ('yawnI', 'yawning'), ('ask', 'So how'), ('howmany', 'many'), ('comment', 'Comment')],
}
# footage bands (layout only; times come from shots-<lang>.json)
VID = {
 'hook': {'style': 'left:-285px;top:640px;width:1800px;height:1012px'},
 'same': {'style': 'left:-414px;top:640px;width:1800px;height:1012px'},
 'warn': {'style': 'left:-1110px;top:300px;width:2400px;height:1350px', 'fill': 'warn-fill.mp4'},
 'ask':  {'style': 'left:-960px;top:240px;width:2400px;height:1350px', 'fill': 'ask-fill.mp4'},
}
TAIL = 0.25  # footage keeps playing this long past its cut, under the outgoing transition

DATA, SHOTS = {}, {}
for lang in ('th', 'en'):
    shots = json.loads((AUD / SRC[lang][0]).read_text())
    SHOTS[lang] = shots
    dur = round(shots['duration'], 3)
    f = finder(lang)
    capt = [f(c) for c in CAPS[lang]]
    f = finder(lang)
    k = {key: f(ph) for key, ph in ANCH[lang]}
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
            size = 104 if n <= 10 else (94 if n <= 15 else 84)
        body = re.sub(r'\*(.+?)\*', r'<em>\1</em>', html.escape(txt))
        out.append(f'  <div id="c{lang}{i}" class="clip cap" data-start="{s}" data-duration="{d}" '
                   f'data-track-index="{20 if lang == "th" else 21}"><span style="font-size:{size}px">{body}</span></div>')
    return '\n'.join(out)

def videos(sid, fill=False):
    out = []
    for li, lang in enumerate(('th', 'en')):
        s = next(x for x in SHOTS[lang]['shots'] if x['id'] == sid)
        dur = min(s['end'] + TAIL, DATA[lang]['dur']) - s['start']
        src = VID[sid]['fill'] if fill else pathlib.Path(s['src']).name
        cls = 'fill' if fill else 'band'
        sty = '' if fill else f' style="{VID[sid]["style"]}"'
        tr = (4 if fill else 2) + li
        out.append(f'<div class="vl vl-{lang}"><video id="v{"f" if fill else ""}-{sid}-{lang}" class="clip {cls}" '
                   f'data-start="{s["start"]}" data-duration="{round(dur, 3)}" data-media-start="{s["media_start"]}" '
                   f'data-track-index="{tr}" muted playsinline src="assets/{src}"{sty}></video></div>')
    return ''.join(out)

DUR = max(DATA['th']['dur'], DATA['en']['dur'])
page = (HERE / 'index.html.tpl').read_text()
rep = {'%%DUR%%': str(DUR), '%%CAPS_TH%%': caps('th'), '%%CAPS_EN%%': caps('en'),
       '%%DATA%%': json.dumps(DATA, ensure_ascii=False)}
for sid in VID:
    rep[f'%%V_{sid}%%'] = videos(sid)
    if 'fill' in VID[sid]:
        rep[f'%%F_{sid}%%'] = videos(sid, fill=True)
for key, v in rep.items():
    page = page.replace(key, v)
assert '%%' not in page, re.findall(r'%%\w+%%', page)
(HERE / 'index.html').write_text(page)
for lang in DATA:
    print(lang, DATA[lang]['dur'], 'captions', len(CAPS[lang]), 'K', DATA[lang]['k'])
