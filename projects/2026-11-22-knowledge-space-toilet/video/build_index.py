#!/usr/bin/env python3
"""Generates index.html from index.html.tpl (one composition, Thai only).
Shot times come from ../assets/audio/shots-th.json (never set by hand); footage plates are timed from them.
Caption chunks and word anchors are located in ../assets/audio/words.json (the real voice): each time is the
start of the first character of the phrase. Lucide icons are inlined as <symbol>s.
Run: python3 build_index.py [--audio DIR] [--out FILE]
  --audio  folder with words.json + shots-th.json (default ../assets/audio, i.e. projects/<x>/assets/audio)
  --out    where to write the page (default index.html next to this script)
The repo root (for assets/vendor/lucide) is found by walking up from this file, so it works from
templates/brainrot-v2/ and from projects/<x>/video/ alike; set AI_STUDIO_ROOT to override."""
import argparse, hashlib, html, json, math, os, pathlib, re

HERE = pathlib.Path(__file__).resolve().parent

def repo_root():
    if os.environ.get('AI_STUDIO_ROOT'):
        return pathlib.Path(os.environ['AI_STUDIO_ROOT']).resolve()
    for d in [HERE, *HERE.parents]:
        if (d / 'assets' / 'vendor' / 'lucide').is_dir() or (d / '.git').exists():
            return d
    raise SystemExit(f'repo root not found above {HERE} (no assets/vendor/lucide or .git); set AI_STUDIO_ROOT')

_ap = argparse.ArgumentParser(description=__doc__.split('\n')[0])
_ap.add_argument('--audio', type=pathlib.Path, default=HERE.parent / 'assets' / 'audio')
_ap.add_argument('--out', type=pathlib.Path, default=HERE / 'index.html')
ARGS = _ap.parse_args()
AUD = ARGS.audio.resolve()
LUC = [repo_root() / 'assets' / 'vendor' / 'lucide', HERE / 'lucide']  # repo set + this episode's extra icons (fan, wind)
# scribe wrote "เม้น" / "เก้าสิบแปด"; the screen spells the script: เมนต์ / 98 (NASA, Don Pettit as transcribed)
ALIAS = {'เมนต์': 'เม้น', '98': 'เก้าสิบแปด'}

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

# caption chunks (1-3 words, script spelling); *x* = key word (yellow). The hook line is the big title (frame 0), not a caption.
CAPS = ["ตดในอวกาศ", "ว่า*แย่*แล้วนะ", "อึนี่*หนักกว่าอีก*", "เพราะไม่มี", "*แรงโน้มถ่วง*", "มัน*ไม่ตกลง*", "ไปเองไง",
        "ห้องน้ำบนสถานี", "อวกาศ", "เลยใช้*ลมดูด*แทน", "*ฉี่*ก็ดูด", "ลง*กรวย*", "*อึ*ก็ดูด", "ลง*ถุง*",
        "แต่ที่*ช็อกกว่า*คือ", "ฉี่*ไม่ได้ทิ้ง*นะ", "เขาเอาไป*กรอง*", "จนกลายเป็น", "*น้ำดื่ม*", "ปี *2023*", "*NASA* บอกว่า",
        "น้ำบนสถานี", "วนกลับมาใช้ได้ถึง", "*98 เปอร์เซ็นต์*", "นักบินอวกาศ", "*Don Pettit*", "เคยแซวไว้ว่า...",
        "มันเปลี่ยน*กาแฟ*", "*เมื่อวาน*", "ให้กลายเป็น", "*กาแฟวันนี้*", "ถ้าได้ไปอวกาศ", "กล้าดื่ม*กาแฟ*", "แก้วนี้*ไหม?*",
        "*เมนต์*บอกหน่อย"]
# word anchors for the motion, searched in speech order
ANCH = [('puat', 'ปวดอึ'), ('thamngai', 'ทำไงดี'), ('tod', 'ตดใน'), ('yae', 'แย่แล้ว'), ('ue', 'อึนี่'), ('nak', 'หนักกว่า'),
        ('raeng', 'แรงโน้มถ่วง'), ('maitok', 'ไม่ตกลง'), ('hongnam', 'ห้องน้ำ'), ('lomdut', 'ลมดูด'), ('chi', 'ฉี่ก็'),
        ('kruai', 'กรวย'), ('ue2', 'อึก็'), ('thung', 'ถุง'), ('chok', 'ช็อก'), ('maidai', 'ไม่ได้'), ('thing', 'ทิ้ง'),
        ('krong', 'กรอง'), ('namduem', 'น้ำดื่ม'), ('y2023', '2023'), ('nasa', 'NASA'), ('sathani', 'สถานี'),
        ('kao', '98'), ('percent', 'เปอร์เซ็นต์'), ('don', 'Don'), ('saew', 'แซว'), ('man', 'มันเปลี่ยน'), ('kafae', 'กาแฟ'),
        ('muewan', 'เมื่อวาน'), ('kafae2', 'กาแฟวันนี้'), ('thaidai', 'ถ้าได้ไป'), ('kladuem', 'กล้าดื่ม'), ('mai', 'ไหม'),
        ('ment', 'เมนต์'), ('noi', 'หน่อย')]
ICONS = ['circle-check', 'circle-x', 'message-circle', 'fan', 'wind', 'globe', 'arrow-down', 'rocket', 'calendar', 'star']

def load_shots():
    """shots-th.json from tools/shot_times.py, refused if shots.json/footage.json/words.json changed since."""
    f = AUD / 'shots-th.json'
    if not f.exists():
        raise SystemExit(f'{f} missing: run python3 tools/shot_times.py <project> th (it deletes the file when it fails)')
    s = json.loads(f.read_text())
    proj = AUD.parents[1]                       # <project>/assets/audio -> <project>
    for name, want in (s.get('inputs') or {}).items():
        p = proj / name
        have = hashlib.sha256(p.read_bytes()).hexdigest() if p.exists() else None
        if have != want:
            raise SystemExit(f'{f} is stale: {name} changed after shot_times ran. '
                             f'Rerun python3 tools/shot_times.py {proj} th, then this script.')
    if 'inputs' not in s:
        print(f'WARN {f} has no "inputs" (written by an old shot_times.py): cannot tell if it is stale')
    return s


shots = load_shots()
# length = the voice (vo-th.mp3 34.72 s) + a short tail for the loop seam (title springs back in the last 0.3 s),
# on a frame boundary. Shot times are untouched; only the last shot (loop, end "auto") runs to DUR.
VO_END = 34.72
DUR = round(math.ceil((VO_END + 0.25) * 30) / 30, 3)
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
        n = len(re.sub(r'[ัิ-ฺ็-๎* .]', '', txt))  # base glyphs only (marks take no width)
        size = 96 if n <= 9 else (88 if n <= 11 else (80 if n <= 13 else 72))
        body = re.sub(r'\*(.+?)\*', r'<em>\1</em>', html.escape(txt))
        out.append(f'  <div id="c{i}" class="clip cap" data-start="{s}" data-duration="{d}" '
                   f'data-track-index="20"><span style="font-size:{size}px">{body}</span></div>')
    return '\n'.join(out)

def icons():
    out = []
    for n in ICONS:
        f = next((d / f'{n}.svg' for d in LUC if (d / f'{n}.svg').exists()), None)
        if f is None:
            raise SystemExit(f'missing icon {n}.svg in {LUC} (add it from lucide-static, see assets/vendor/README.md)')
        src = f.read_text()
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
ARGS.out.write_text(page)
if __name__ == '__main__':
    print('dur', DUR, 'captions', len(CAPS))
    print('K', K)
