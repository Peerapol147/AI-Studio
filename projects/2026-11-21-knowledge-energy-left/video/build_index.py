#!/usr/bin/env python3
"""Generates index.html from index.html.tpl (one composition, Thai only) — energy-left ("น้ำมันจะหมดโลกปีไหน?").
Copied from templates/brainrot-v2/build_index.py and re-targeted.
Shot times come from ../assets/audio/shots-th.json (never set by hand); every plate is timed from them.
Caption chunks and word anchors are located in ../assets/audio/words.json (the real voice): each time is the
start of the first character of the phrase. Lucide icons are inlined as <symbol>s. The oil "years left" line
(count shot) is read from ../owid-years-reserves-left.csv (World, Oil, 1980-2020).
Run: python3 build_index.py [--audio DIR] [--out FILE]"""
import argparse, csv, hashlib, html, json, math, os, pathlib, re

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
ARGS = _ap.parse_args()
AUD = ARGS.audio.resolve()
LUC = repo_root() / 'assets' / 'vendor' / 'lucide'

def norm(s):
    return re.sub(r"[\s*?!.,'’…~]", '', s.lower())

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

# caption chunks (1-3 words): (screen text, spoken text to locate it in words.json). *x* = key word (yellow).
# The hook line (0-2 s) and the closing question (ask shot) are the big title text (= speech word for word), not captions.
# Numbers: digits only where the screen may show them (30, 140); other spoken amounts stay as Thai words.
CAPS = [("หลายคนเชื่อว่า", None), ("อีก *30 ปี*", "อีกสามสิบปี"), ("ก็หมดแล้ว", None),
        ("แต่*สี่สิบกว่าปี*", None), ("ก่อน", None), ("ตัวเลขก็บอกว่า", None), ("เหลือแค่ *30 ปี*", "เหลือแค่สามสิบปี"),
        ("เหมือนกัน", None), ("ผ่านไป", None), ("สี่สิบปี", None), ("ตัวเลขกลับเป็น", None), ("*ห้าสิบกว่าปี*", None),
        ("ซะงั้น", None), ("เพราะเลขนี้คือ", None), ("น้ำมันที่*ขุดได้คุ้ม*", None), ("*หารด้วย*ที่โลก", None),
        ("*ใช้ต่อปี*", None), ("พอขุดเก่งขึ้น", None), ("เจอแหล่งใหม่", None), ("ตัวเลขก็*ขยับได้*", None),
        ("ถ้าใช้เท่าตอนนี้", None), ("*น้ำมัน*เหลือ", None), ("ประมาณ*ห้าสิบกว่าปี*", None), ("*ก๊าซ*เกือบห้าสิบ", None),
        ("*ถ่านหิน 140*", "ถ่านหินร้อยสี่สิบ"), ("*ยูเรเนียม*", None), ("แปดสิบกว่าปี", None), ("ส่วน*แดด*", None),
        ("*ลม*", None), ("*น้ำ*", None), ("*ไม่หมด*", None), ("ธรรมชาติ", None), ("เติมให้*ตลอด*", None),
        ("แต่ของที่ขุด", None), ("ขึ้นมาใช้", None), ("ยังไงก็มี", None), ("*วันหมด*อยู่ดี", None),
        ("อย่าลืม*ประหยัด*", None), ("*พลังงาน*กันนะ", None)]
# word anchors for the motion, searched in speech order
ANCH = [('chuea', 'หลายคน'), ('samsip', 'สามสิบปี'), ('sisip', 'สี่สิบกว่า'), ('lue30', 'เหลือแค่'),
        ('phan', 'ผ่านไป'), ('sisip2', 'สี่สิบปี'), ('klab', 'ตัวเลขกลับ'), ('hasip', 'ห้าสิบกว่า'), ('praw', 'เพราะ'),
        ('namman', 'น้ำมันที่'), ('khud', 'ขุดได้คุ้ม'), ('han', 'หารด้วย'), ('chai', 'ใช้ต่อปี'), ('kheng', 'ขุดเก่ง'),
        ('joe', 'เจอแหล่ง'), ('khayab', 'ขยับ'), ('thachai', 'ถ้าใช้'), ('oil', 'น้ำมันเหลือ'), ('oiln', 'ห้าสิบกว่าปี'),
        ('gas', 'ก๊าซ'), ('gasn', 'ห้าสิบ'), ('coal', 'ถ่านหิน'), ('coaln', 'ร้อยสี่สิบ'), ('ura', 'ยูเรเนียม'),
        ('uran', 'แปดสิบ'), ('daed', 'แดด'), ('lom', 'ลม'), ('nam', 'น้ำ'), ('maimod', 'ไม่หมด'), ('thammachat', 'ธรรมชาติ'),
        ('term', 'เติมให้'), ('tae2', 'แต่ของ'), ('yangngai', 'ยังไง'), ('mod2', 'หมดอยู่'), ('yalue', 'อย่าลืม'),
        ('prayat', 'ประหยัด'), ('palang', 'พลังงาน'), ('khit', 'คิดว่า'), ('arai', 'อะไร'), ('korn', 'ก่อน')]
ICONS = ['fuel', 'flame', 'mountain', 'atom', 'sun', 'wind', 'droplets', 'infinity', 'users', 'hourglass', 'zap',
         'search', 'pickaxe', 'calendar-clock', 'leaf', 'lightbulb', 'lightbulb-off', 'triangle-alert', 'arrow-up',
         'arrow-down', 'circle-x', 'message-circle']

def load_shots():
    """shots-th.json from tools/shot_times.py, refused if shots.json/footage.json/words.json changed since."""
    f = AUD / 'shots-th.json'
    if not f.exists():
        raise SystemExit(f'{f} missing: run python3 tools/shot_times.py <project> th (it deletes the file when it fails)')
    s = json.loads(f.read_text())
    proj = AUD.parents[1]
    for name, want in (s.get('inputs') or {}).items():
        p = proj / name
        have = hashlib.sha256(p.read_bytes()).hexdigest() if p.exists() else None
        if have != want:
            raise SystemExit(f'{f} is stale: {name} changed after shot_times ran. '
                             f'Rerun python3 tools/shot_times.py {proj} th, then this script.')
    return s

shots = load_shots()
DUR = round(math.floor(shots['duration'] * 30) / 30, 3)  # clip ends with the voice (no silent tail)
f = finder(); capt = [f(srch or txt) for txt, srch in CAPS]
f = finder(); K = {key: f(ph) for key, ph in ANCH}
SH = {s['id']: {'start': s['start'], 'end': s['end'], 'word': s['word_at'], 'hit': s.get('hit_at'),
                'ms': s.get('media_start')} for s in shots['shots']}
SH['ask']['end'] = DUR
OWID = []
with open(AUD.parents[1] / 'owid-years-reserves-left.csv') as fh:
    for r in csv.DictReader(fh):
        if r['Entity'] == 'World' and 1980 <= int(r['Year']) <= 2020:
            OWID.append([int(r['Year']), round(float(r['Oil']), 2)])
DATA = {'dur': DUR, 'capt': capt, 'k': K, 'sh': SH, 'owid': OWID}
CAP_END = SH['ask']['start']  # last caption ("กันนะ") clears on the cut to the closing question

def caps():
    out = []
    for i, (txt, _) in enumerate(CAPS):
        s = capt[i]
        e = capt[i + 1] if i + 1 < len(capt) else CAP_END
        d = round(e - s, 3)
        assert d >= 0.4, (txt, d)
        n = len(re.sub(r'[ัิ-ฺ็-๎*\s]', '', txt))  # base glyphs only (marks take no width)
        size = 96 if n <= 9 else (88 if n <= 11 else (80 if n <= 14 else 72))
        body = re.sub(r'\*(.+?)\*', r'<em>\1</em>', html.escape(txt))
        out.append(f'  <div id="c{i}" class="clip cap" data-start="{s}" data-duration="{d}" '
                   f'data-track-index="20"><span style="font-size:{size}px">{body}</span></div>')
    return '\n'.join(out)

def icons():
    out = []
    for n in ICONS:
        f = LUC / f'{n}.svg'
        if not f.exists():
            raise SystemExit(f'missing icon {f} (add it from lucide-static, see assets/vendor/README.md)')
        inner = re.search(r'<svg[^>]*>\s*(.*)</svg>', f.read_text(), re.S).group(1).strip()
        inner = re.sub(r'\s+', ' ', inner)
        out.append(f'<symbol id="ic-{n}" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" '
                   f'stroke-linecap="round" stroke-linejoin="round">{inner}</symbol>')
    return '\n'.join(out)

# media: (tag id, shot that times it, last shot it covers, file, data-media-start). Plates are cut at the chosen
# source point by prep_assets.sh, so media-start is 0 (save-*: source 9.14-11.38 reversed, see prep_assets.sh).
XF = 0.12  # outgoing plate stays 0.12 s under the incoming transition (crossfade <= 0.12 s)
MEDIA = [('believe', 'believe', 'believe', 'believe.mp4', 'vid'), ('hourglass', 'hourglass', 'hourglass', 'hourglass.mp4', 'vid'),
         ('now', 'now', 'now', 'now.mp4', 'vid'), ('coal', 'coal', 'coal', 'coal.mp4', 'vid'),
         ('uranium-bg', 'uranium', 'uranium', 'uranium-bg.mp4', 'vid'), ('uranium-card', 'uranium', 'uranium', 'uranium-card.mp4', 'cvid'),
         ('sun-a', 'sun', 'sun', 'sun-a.mp4', 'bvid'), ('sun-b', 'sun', 'sun', 'sun-b.mp4', 'bvid'),
         ('sun-c', 'sun', 'sun', 'sun-c.mp4', 'bvid'),
         ('gas-bg', 'gas', 'gas', 'gas-bg.mp4', 'vid'), ('gas-card', 'gas', 'gas', 'gas-card.mp4', 'cvid'),
         ('refill-bg', 'refill', 'refill', 'refill-bg.mp4', 'vid'), ('refill-card', 'refill', 'refill', 'refill-card.mp4', 'cvid'),
         ('finite-bg', 'finite', 'finite', 'finite-bg.mp4', 'vid'), ('finite-card', 'finite', 'finite', 'finite-card.mp4', 'cvid'),
         ('save-bg', 'save', 'save', 'save-bg.mp4', 'vid'), ('save-card', 'save', 'save', 'save-card.mp4', 'cvid')]
def videos():
    out = {}
    for i, (vid, a_id, b_id, src, cls) in enumerate(MEDIA):
        a = SH[a_id]['start']; b = min(DUR, SH[b_id]['end'] + XF)
        out[vid] = (f'<video id="v-{vid}" class="clip {cls}" data-start="{a}" data-duration="{round(b - a, 3)}" '
                    f'data-media-start="0" data-track-index="{1 + i % 2}" muted playsinline src="assets/{src}"></video>')
    return out

page = (HERE / 'index.html.tpl').read_text()
rep = {'%%DUR%%': str(DUR), '%%CAPS%%': caps(), '%%ICONS%%': icons(), '%%DATA%%': json.dumps(DATA, ensure_ascii=False)}
for vid, tag in videos().items():
    rep[f'%%V_{vid.upper().replace("-", "_")}%%'] = tag
for key, v in rep.items():
    page = page.replace(key, v)
assert '%%' not in page, re.findall(r'%%\w+%%', page)
ARGS.out.write_text(page)
if __name__ == '__main__':
    print('dur', DUR, 'captions', len(CAPS))
    print('K', K)
