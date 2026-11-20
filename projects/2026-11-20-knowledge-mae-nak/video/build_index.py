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
# scribe wrote "คู่หนึ่ง" / "วันหนึ่ง" / "เลยอ่ะ" / "เม้น"; the screen spells the script (vo-th.txt): คู่นึง / วันนึง / เลยอะ / เมนต์
# (words.json is one Thai character cluster per token, so these only ever rewrite the caption phrase side)
ALIAS = {'นึง': 'หนึ่ง', 'เลยอะ': 'เลยอ่ะ', 'เมนต์': 'เม้น'}

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

# caption chunks (1-3 words, each >= 0.4 s); *x* = key word (yellow). The hook line (0-3.5 s) is the big title +
# the kinetic "มาก?" (title = speech word for word), not a caption.
CAPS = ["เล่ากันว่า...", "ริมคลอง*พระโขนง*", "มีผัวเมีย", "คู่นึง", "*รักกันมาก*", "ผัวโดน*เกณฑ์*", "ไปเป็นทหาร",
        "ตอนเมีย*ท้องแก่*", "แล้วนาคก็", "คลอดลูกไม่ออก", "*ตายทั้งกลม*", "แต่พอผัว", "*กลับมา*...", "เมียกับลูก",
        "*ยังรออยู่*", "ที่บ้านเลยอะ", "เพื่อนบ้านเตือนว่า", "อยู่กับ*ผี*", "เขาก็*ไม่เชื่อ*", "จนวันนึง",
        "นาค*ตำน้ำพริก*อยู่", "*มะนาว*ตก", "ลงไป*ใต้ถุน*", "นาค*ยื่นแขน*...", "*ยาว*ลงไปเก็บ", "ผัวเห็น*เต็มตา*",
        "คืนนั้นเลย", "แอบ*หนีไปวัด*", "ผีนาคก็", "*อาละวาด*", "ทั้งคลองเลยนะ", "แต่*ฉบับเขียน*", "ที่เก่าสุด",
        "ที่เจอ", "อยู่ใน*หนังสือพิมพ์*", "เมื่อ*ร้อยกว่าปี*ก่อน", "ในนั้น", "นาคเป็น*ลูกสาว*", "*ขุนศรี*",
        "แล้วผัวชื่อ", "*นายชุ่ม*", "ไม่ใช่*มาก*", "*ว่ากันว่า*", "ชื่อมาก", "เพิ่งมาโผล่*ทีหลัง*", "ใน*ละครร้อง*",
        "*บางตำรา*", "ยังบอกว่า", "ผีทั้งคลอง", "อาจเป็นแค่*อุบาย*", "ของลูกชาย", "ที่ไม่อยากให้", "พ่อมี*เมียใหม่*",
        "ส่วนฉาก*มะนาวตก*", "เรายัง*หาไม่เจอ*เลย", "ว่ามาจาก*ฉบับไหน*", "แล้วที่เคยได้ยินมา", "ผัวแม่นาค*ชื่ออะไร*",
        "*เมนต์*บอกหน่อย"]
# word anchors for the motion, searched in speech order
ANCH = [('maenak', 'แม่นาค'), ('nai', 'ในฉบับ'), ('maidai', 'ไม่ได้ชื่อ'), ('mak', 'มาก'), ('lao', 'เล่ากันว่า'),
        ('rim', 'ริมคลอง'), ('phuamia', 'ผัวเมีย'), ('rak', 'รักกัน'), ('kenn', 'เกณฑ์'), ('thahan', 'ทหาร'),
        ('thong', 'ท้องแก่'), ('khlod', 'คลอดลูก'), ('tai', 'ตายทั้งกลม'), ('klab', 'กลับมา'), ('mia', 'เมียกับลูก'),
        ('ror', 'รออยู่'), ('phuean', 'เพื่อนบ้าน'), ('phi', 'อยู่กับผี'), ('maichuea', 'ไม่เชื่อ'), ('tam', 'ตำน้ำพริก'),
        ('manao', 'มะนาว'), ('tok', 'ตกลงไป'), ('taithun', 'ใต้ถุน'), ('yuen', 'ยื่นแขน'), ('yao', 'ยาวลงไป'),
        ('kep', 'เก็บ'), ('hen', 'เห็น'), ('temta', 'เต็มตา'), ('nee', 'หนีไปวัด'), ('alawat', 'อาละวาด'),
        ('chabab', 'ฉบับเขียน'), ('kaosud', 'เก่าสุด'), ('jer', 'ที่เจอ'), ('nangsue', 'หนังสือพิมพ์'), ('roi', 'ร้อยกว่า'),
        ('nainan', 'ในนั้น'), ('luksao', 'ลูกสาว'), ('khunsri', 'ขุนศรี'), ('chum', 'นายชุ่ม'), ('maichai', 'ไม่ใช่มาก'),
        ('wakan', 'ว่ากันว่า'), ('chuemak', 'ชื่อมาก'), ('thilang', 'ทีหลัง'), ('lakhon', 'ละครร้อง'), ('bang', 'บางตำรา'),
        ('phithang', 'ผีทั้งคลอง'), ('ubai', 'อุบาย'), ('lukchai', 'ลูกชาย'), ('pho', 'พ่อมี'), ('miamai', 'เมียใหม่'),
        ('manao2', 'มะนาวตก'), ('haimai', 'หาไม่เจอ'), ('chababnai', 'ฉบับไหน'), ('khoei', 'เคยได้ยิน'),
        ('phua3', 'ผัวแม่นาค'), ('arai', 'ชื่ออะไร'), ('ment', 'เมนต์')]
ICONS = ['circle-check', 'triangle-alert', 'search', 'book-open', 'circle-help', 'message-circle', 'arrow-right', 'moon', 'flame']

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
SH['c1_loop']['end'] = DUR
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

# footage scenes: (shot id, plate, data-media-start). Plates are cut at the chosen source point by prep_assets.sh
# (s2_khlong at its media_start 4.0, s7_out at 1.92), except canal-v which keeps the source clock (h1 media_start 0.0)
# and loop-v = 159306 0-3.6 s REVERSED: loop media_start = 3.6 - c1 duration, so the LAST frame of the clip is
# source 0.0 = the frame-0 image (seamless loop back to the hook).
LOOPLEN = 3.6
FOOT = [('h1_canal', 'canal-v', SH['h1_canal']['ms']), ('h2_name', 'nameb-v', 0), ('s1_moon', 'moon-v', 0),
        ('s2_khlong', 'khlong-v', 0), ('s3_couple', 'couple-v', 0), ('s4_soldier', 'soldier-v', 0),
        ('s5_pregnant', 'preg-v', 0), ('s6_candle', 'candle-v', 0), ('s7_out', 'out-v', 0), ('s8_boat', 'boat-v', 0),
        ('s9_wait', 'wait-v', 0), ('s10_neigh', 'neigh-v', 0), ('s11_nope', 'nope-v', 0), ('s12_mortar', 'mortar-v', 0),
        ('s14_under', 'under-v', 0), ('s15_arm', 'under2-v', 0), ('s17_temple', 'temple-v', 0),
        ('s18_rampage', 'storm-v', 0), ('t1_paper', 'paper-v', 0), ('t5_stage', 'stage-v', 0),
        ('c1_loop', 'loop-v', round(LOOPLEN - (DUR - SH['c1_loop']['start']), 3))]
XF = 0.12  # outgoing plate stays 0.12 s under the incoming transition (crossfade <= 0.12 s)
def videos():
    out = {}
    for i, (sid, plate, ms) in enumerate(FOOT):
        a = SH[sid]['start']; b = min(DUR, SH[sid]['end'] + XF)
        cls = 'clip vcard' if sid == 't5_stage' else 'clip vid'
        out[sid] = (f'<video id="v-{sid}" class="{cls}" data-start="{a}" data-duration="{round(b - a, 3)}" '
                    f'data-media-start="{ms}" data-track-index="{1 + i % 2}" muted playsinline src="assets/{plate}.mp4"></video>')
    return out

page = (HERE / 'index.html.tpl').read_text()
rep = {'%%DUR%%': str(DUR), '%%CAPS%%': caps(), '%%ICONS%%': icons(), '%%DATA%%': json.dumps(DATA, ensure_ascii=False)}
for sid, tag in videos().items():
    rep[f'%%V_{sid.split("_")[0].upper()}%%'] = tag
for key, v in rep.items():
    page = page.replace(key, v)
assert '%%' not in page, re.findall(r'%%\w+%%', page)
ARGS.out.write_text(page)
if __name__ == '__main__':
    print('dur', DUR, 'captions', len(CAPS), 'loop media_start', FOOT[-1][2])
    print('K', K)
