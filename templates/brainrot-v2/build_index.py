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
LUC = repo_root() / 'assets' / 'vendor' / 'lucide'
# scribe wrote "และ" / "Trick" / "test"; the screen spells the script: แล้ว / ทริก / เทส
ALIAS = {'แล้ว': 'และ', 'ทริก': 'trick', 'เทส': 'test'}

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
CAPS = ["เลื่อนถึงตีสอง", "แล้วบ่นว่า", "สมอง*เน่า*", "*Oxford*", "ยกให้เป็น", "*คำแห่งปี*", "2024",
        "แต่นิยาม", "ยังเขียนว่า", "ความเสื่อม", "ที่*คนคิดว่า*", "เกิด", "*ยังไม่มีหลักฐาน*", "ว่าคลิปสั้น",
        "ทำสมองเน่า", "*ถาวร*", "คนดู*หนักๆ*", "มักทำ*เทส*", "สมาธิ", "ได้*แย่กว่า*", "แต่แค่*สัมพันธ์*กัน",
        "อาจเพราะ*เครียด*", "เลยเลื่อนหนัก", "*ทริก*", "อย่าเลื่อนบน*เตียง*", "คนเล่นมือถือ", "ก่อนนอน",
        "มัก*นอนน้อยลง*", "คืนนี้เลื่อนถึง", "*กี่โมง?*", "ก่อนสงสัย", "อีกรอบว่า"]
# word anchors for the motion, searched in speech order
ANCH = [('tsong', 'ตีสอง'), ('bon', 'บ่นว่า'), ('nao', 'เน่า'), ('oxford', 'Oxford'), ('year', 'คำแห่งปี'),
        ('y2024', '2024'), ('niyam', 'นิยาม'), ('sueam', 'ความเสื่อม'), ('khit', 'คนคิดว่า'), ('kerd', 'เกิด'),
        ('noproof', 'ยังไม่มีหลักฐาน'), ('clip', 'คลิปสั้น'), ('nao2', 'เน่า'), ('thavorn', 'ถาวร'),
        ('khondu', 'คนดู'), ('nak', 'หนักๆ'), ('test', 'เทส'), ('samathi', 'สมาธิ'), ('yae', 'แย่กว่า'),
        ('samphan', 'สัมพันธ์'), ('arj', 'อาจเพราะ'), ('kriat', 'เครียด'), ('lnak', 'เลื่อนหนัก'), ('trick', 'ทริก'),
        ('ya', 'อย่าเลื่อน'), ('tiang', 'เตียง'), ('mue', 'มือถือ'), ('konnon', 'ก่อนนอน'), ('nonnoi', 'นอนน้อย'),
        ('khuenni', 'คืนนี้'), ('kimong', 'กี่โมง'), ('songsai', 'สงสัย'), ('rob', 'อีกรอบ')]
ICONS = ['moon', 'smartphone', 'brain', 'bed', 'lightbulb', 'message-circle', 'clock', 'circle-check', 'circle-x',
         'triangle-alert', 'book-open', 'target', 'trending-up', 'trending-down', 'search', 'zap']

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
        n = len(re.sub(r'[ัิ-ฺ็-๎*]', '', txt))  # base glyphs only (marks take no width)
        size = 96 if n <= 9 else (88 if n <= 11 else 80)
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
        src = f.read_text()
        inner = re.search(r'>\s*(.*)</svg>', src, re.S).group(1).strip()
        inner = re.sub(r'\s+', ' ', inner)
        out.append(f'<symbol id="ic-{n}" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" '
                   f'stroke-linecap="round" stroke-linejoin="round">{inner}</symbol>')
    return '\n'.join(out)

# footage scenes: (scene id, shot id, plate, data-media-start). Plates are cut at the chosen source point by
# prep_assets.sh, except hook-v.mp4 which keeps the source clock: hook = shots-th media_start 2.0,
# loop = 2.0 - loop duration so the LAST frame of the clip is source 2.0 s = the frame-0 image (seamless loop).
FOOT = [('hook', 'hook-v', SH['hook']['ms']), ('bed', 'bed-v', 0), ('noproof', 'noproof-v', 0), ('heavy', 'heavy-v', 0),
        ('stress', 'stress-v', 0), ('scrollbed', 'scrollbed-v', 0), ('sleep', 'sleep-v', 0),
        ('loop', 'hook-v', round(SH['hook']['ms'] - (DUR - SH['loop']['start']), 3))]
XF = 0.12  # outgoing plate stays 0.12 s under the incoming transition (crossfade <= 0.12 s)
def videos():
    out = {}
    for i, (sid, plate, ms) in enumerate(FOOT):
        a = SH[sid]['start']; b = min(DUR, SH[sid]['end'] + XF)
        out[sid] = (f'<video id="v-{sid}" class="clip vid" data-start="{a}" data-duration="{round(b - a, 3)}" '
                    f'data-media-start="{ms}" data-track-index="{1 + i % 2}" muted playsinline src="assets/{plate}.mp4"></video>')
    return out

page = (HERE / 'index.html.tpl').read_text()
rep = {'%%DUR%%': str(DUR), '%%CAPS%%': caps(), '%%ICONS%%': icons(), '%%DATA%%': json.dumps(DATA, ensure_ascii=False)}
for sid, tag in videos().items():
    rep[f'%%V_{sid.upper()}%%'] = tag
for key, v in rep.items():
    page = page.replace(key, v)
assert '%%' not in page, re.findall(r'%%\w+%%', page)
ARGS.out.write_text(page)
if __name__ == '__main__':
    print('dur', DUR, 'captions', len(CAPS), 'loop media_start', FOOT[-1][2])
    print('K', K)
