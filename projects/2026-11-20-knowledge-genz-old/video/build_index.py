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
# scribe wrote "เม้นต์" (the screen spells เมนต์)
ALIAS = {'เมนต์': 'เม้นต์'}

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

# caption chunks (1-3 words); *x* = key word (yellow). The hook line (0-4.6 s) is the big title (frame 0), not a caption.
CAPS = ["Gen Z คือคน", "ที่เกิดปี", "*1997*", "ถึง *2012*", "ปีนั้นส่วนใหญ่ก็", "*หกสิบกว่า*แล้ว",
        "ยายยุคนี้", "ส่งรูป*ดอกไม้*", "*สวัสดีวันจันทร์*", "ส่วนยาย *Gen Z*", "น่าจะส่ง", "*รูปแมว*", "แทน*รูปหลาน*",
        "เพราะปี *2024*", "*เด็กไทย*เกิด", "ไม่ถึง*ห้าแสน*คน", "*ครั้งแรก*ในรอบ", "เกือบ*แปดสิบปี*เลย",
        "ยายยุคนี้", "เปิด*ลูกทุ่ง*", "*ลั่นบ้าน*", "ส่วนยาย *Gen Z*", "อาจจะ", "*หา? อะไรนะ*", "บ่อยกว่า",
        "เพราะ *WHO*", "บอกว่า", "คนหนุ่มสาว", "กว่า*พันล้านคน*", "*เสี่ยงหูเสื่อม*", "จากเสียงดัง",
        "ยายยุคนี้", "ใส่*แว่น*แค่ตอน", "*อ่านหนังสือ*", "ส่วนยาย *Gen Z*", "น่าจะใส่", "*ทั้งวัน*",
        "เพราะงานวิจัย", "คาดว่า", "ปี *2050*", "คนราว*ครึ่งโลก*", "จะ*สายตาสั้น*",
        "แต่*เรื่องหู*", "*เตรียมได้*", "ตั้งแต่ตอนนี้นะ", "*เบาเสียง*หูฟัง", "หน่อย", "เพราะหูที่เสื่อม", "จากเสียงดัง",
        "*ไม่กลับมา*แล้ว", "แล้วตอนแก่", "อยากเป็น*แบบไหน*", "*เมนต์*บอกหน่อย"]
# word anchors for the motion, searched in speech order
ANCH = [('y2070', '2070'), ('yay', 'ยายGen Z'), ('tiktok', 'TikTok'), ('genz', 'Gen Z คือ'), ('y1997', '1997'),
        ('y2012', '2012'), ('pinan', 'ปีนั้น'), ('hok', 'หกสิบ'), ('yuk1', 'ยายยุคนี้'), ('dok', 'ดอกไม้'), ('jan', 'จันทร์'),
        ('gz1', 'ส่วนยาย'), ('maew', 'รูปแมว'), ('taen', 'แทน'), ('lan', 'หลาน'), ('y2024', '2024'), ('dek', 'เด็กไทย'),
        ('hasaen', 'ห้าแสน'), ('khrang', 'ครั้งแรก'), ('paet', 'แปดสิบ'), ('yuk2', 'ยายยุคนี้'), ('luk', 'ลูกทุ่ง'),
        ('lan2', 'ลั่นบ้าน'), ('gz2', 'ส่วนยาย'), ('ha', 'หา'), ('arai', 'อะไรนะ'), ('who', 'WHO'), ('num', 'คนหนุ่มสาว'),
        ('phan', 'พันล้าน'), ('siang', 'เสี่ยง'), ('dang', 'เสียงดัง'), ('yuk3', 'ยายยุคนี้'), ('waen', 'แว่น'),
        ('aan', 'อ่านหนังสือ'), ('gz3', 'ส่วนยาย'), ('thang', 'ทั้งวัน'), ('wijai', 'งานวิจัย'), ('y2050', '2050'),
        ('khrueng', 'ครึ่งโลก'), ('san', 'สายตาสั้น'), ('tae', 'แต่เรื่องหู'), ('triam', 'เตรียม'), ('bao', 'เบาเสียง'),
        ('noi', 'หน่อย'), ('suam', 'เสื่อม'), ('mai', 'ไม่กลับมา'), ('tonkae', 'ตอนแก่'), ('yak', 'อยากเป็น'),
        ('baepnai', 'แบบไหน'), ('ment', 'เมนต์')]
ICONS = ['trending-down', 'arrow-down', 'smartphone', 'message-circle', 'clock', 'circle-check', 'triangle-alert', 'trending-up', 'users', 'user',
         'calendar', 'calculator', 'globe', 'file-text', 'eye', 'glasses', 'sun', 'moon', 'zap', 'heart', 'music',
         'volume-2', 'volume-1', 'ear', 'shield-check', 'sparkles', 'cat', 'flower-2', 'radio', 'headphones', 'book-open',
         'hourglass', 'play']

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
SH['s29']['end'] = DUR
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

# footage <video>s: (id, plate, first shot, last shot, data-media-start). Plates keep the source clock (prep_assets.sh).
# loop = hook plate ending on source 5.0 s (= the frame-0 image) so the last frame meets frame 0.
LOOPMS = round(SH['s01']['ms'] - (DUR - SH['s29']['start']), 3)
VIDS = [('hook', 'hook', 's01', 's01', SH['s01']['ms']), ('selfie', 'selfie', 's04', 's04', 0.3),
        ('poppy', 'poppy', 's08', 's10', 0.5), ('phoneg', 'phoneg', 's09', 's10', 0.2), ('cat', 'cat', 's10', 's10', 1.0),
        ('baby', 'baby', 's12', 's12', 2.3), ('radio', 'radio', 's14', 's17', 0.2), ('hpgirl', 'hpgirl', 's16', 's16', 0.5),
        ('hpman', 'hpman', 's17', 's17', SH['s17']['ms']), ('phones', 'phones', 's19', 's19', 0),
        ('coder', 'coder', 's21', 's21', 0), ('coder2', 'coder', 's22', 's22', 3.0),
        ('buds', 'buds', 's26', 's26', 1.0), ('buds2', 'buds2', 's26b', 's26b', 4.0), ('loop', 'hook', 's29', 's29', LOOPMS)]
XF = 0.12  # outgoing plate stays 0.12 s under the incoming transition (crossfade <= 0.12 s)
def videos():
    out = {}
    for i, (vid, plate, s0, s1, ms) in enumerate(VIDS):
        a = SH[s0]['start']; b = min(DUR, SH[s1]['end'] + XF)
        out[vid] = (f'<video id="v-{vid}" class="clip vid" data-start="{a}" data-duration="{round(b - a, 3)}" '
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
    print('dur', DUR, 'captions', len(CAPS), 'loop media_start', LOOPMS)
    print('K', K)
