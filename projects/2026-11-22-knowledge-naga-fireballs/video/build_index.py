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
# scribe wrote "เม้น"; the screen spells the script: เมนต์
ALIAS = {'เมนต์': 'เม้น'}

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
CAPS = ["*เล่ากันว่า*", "ทุกคืน*ออกพรรษา*", "ริม*แม่น้ำโขง*", "แถว*หนองคาย*", "พอฟ้ามืด", "จะมี*ลูกไฟ*", "สี*แดงอมชมพู*",
        "*ผุด*ขึ้นมา", "จากใต้น้ำ", "บางปีนับได้", "เป็น*ร้อยๆ ลูก*", "เลยนะ", "*ไม่มีเสียง*", "*ไม่มีควัน*", "พุ่งขึ้นฟ้า",
        "แล้วก็*ดับ*", "หายไปเฉยๆ", "ชาวบ้านเชื่อว่า", "ใต้แม่น้ำโขง", "มี*พญานาค*อยู่", "คืนนั้น*พญานาค*",
        "จะ*จุดลูกไฟ*", "ถวาย*พระพุทธเจ้า*", "ตอนเสด็จกลับ", "จาก*สวรรค์*", "ชั้น*ดาวดึงส์*", "ไม่เชื่อ", "ก็*อย่าลบหลู่*นะ",
        "แต่บางคน", "ก็*คิดต่าง*", "มี*หมอ*คนนึง", "บอกว่า", "เป็น*ก๊าซ*", "จากโคลน", "ก้นแม่น้ำ", "ลอยขึ้นมา",
        "แล้ว*ติดไฟ*เอง", "ส่วน*รายการทีวี*", "เมื่อยี่สิบ", "กว่าปีก่อน", "ไปถ่ายเจอ", "*ทหาร*ฝั่งลาว", "ยิง*กระสุน*",
        "ส่องแสง", "ขึ้นฟ้า", "คนในพื้นที่", "*ไม่พอใจ*กันมาก", "ถึงขั้น", "*ขู่ฟ้อง*เลย", "จนถึงวันนี้", "ก็ยังไม่มี",
        "*คำตอบ*ไหน", "ที่*ทุกฝ่าย*", "ยอมรับ", "แล้วคิดว่าไง", "*พญานาค*", "หรือ*มีคนทำ?*", "*เมนต์*บอกหน่อย"]
# word anchors for the motion, searched in speech order
ANCH = [('khon', 'คนจุด'), ('lao_kan', 'เล่ากันว่า'), ('mekong', 'แม่น้ำโขง'), ('nongkhai', 'หนองคาย'), ('famuet', 'ฟ้ามืด'),
        ('luk', 'ลูกไฟ'), ('amchom', 'อมชมพู'), ('phut', 'ผุด'), ('bangpi', 'บางปี'), ('roi', 'ร้อยๆ'),
        ('siang', 'ไม่มีเสียง'), ('khwan', 'ไม่มีควัน'), ('phung', 'พุ่งขึ้นฟ้า'), ('dap', 'ดับ'),
        ('chaoban', 'ชาวบ้าน'), ('naga1', 'พญานาค'), ('naga2', 'พญานาค'), ('chut', 'จุดลูกไฟ'), ('buddha', 'พระพุทธเจ้า'),
        ('sawan', 'สวรรค์'), ('daodueng', 'ดาวดึงส์'), ('maichuea', 'ไม่เชื่อ'), ('lop', 'ลบหลู่'), ('bangkhon', 'บางคน'),
        ('mo', 'หมอ'), ('gas', 'ก๊าซ'), ('khlon', 'โคลน'), ('loi', 'ลอยขึ้นมา'), ('tidfai', 'ติดไฟ'), ('tv', 'รายการทีวี'),
        ('yisip', 'ยี่สิบ'), ('thahan', 'ทหาร'), ('lao', 'ลาว'), ('ying', 'ยิง'), ('krasun', 'กระสุน'), ('khuenfa', 'ขึ้นฟ้า'),
        ('phuenthi', 'ในพื้นที่'), ('maipor', 'ไม่พอใจ'), ('khu', 'ขู่'), ('fong', 'ฟ้อง'), ('wanni', 'จนถึงวันนี้'),
        ('khamtop', 'คำตอบ'), ('thukfai', 'ทุกฝ่าย'), ('yomrap', 'ยอมรับ'), ('naga3', 'พญานาค'), ('rue', 'หรือ'),
        ('mikhon', 'มีคนทำ'), ('men', 'เมนต์')]
ICONS = ['volume-x', 'cloud-off', 'stethoscope', 'message-circle-more', 'circle-help', 'flame', 'map-pin', 'calendar', 'users']

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
        if want is None and name == 'footage.json':
            print('WARN footage.json written after shot_times (shots-th.json records it as absent): times unchanged; '
                  'plate in-points = MS below (from shot_times action_at math)')
            continue
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
SH['c2_comment']['end'] = DUR
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

# footage plates: (video id, first shot, last shot, plate, data-media-start). Plates are cut at the source in-point
# (prep_assets.sh: s1 3.92, s2 3.92, s4 5.92, s5 2.82, s9/s12/s14 0.92, s13 1.92 = shot_times media_start from footage.json
# action_at), so they start at 0. hook-v keeps the source clock: h1 media_start 0 (shots-th.json); h2 continues the same take.
# loop-v = source 0..3.2 s reversed, started so the LAST frame is source ~0 = the frame-0 image (seamless loop).
LOOPLEN = 3.2
FOOT = [('hook', 'h1_fire', 'h2_who', 'hook-v', SH['h1_fire']['ms']), ('moon', 's1_moon', 's1_moon', 'moon-v', 0),
        ('mekong', 's2_mekong', 's2_mekong', 'mekong-v', 0), ('dusk', 's4_dark', 's4_dark', 'dusk-v', 0),
        ('orb', 's5_orb', 's5_orb', 'orb-v', 0), ('count', 's6_count', 's6_count', 'riverbg-v', 0),
        ('silent', 's7_silent', 's7_silent', 'riverbg-v', round(SH['s7_silent']['start'] - SH['s6_count']['start'], 3)),
        ('vanish', 's8_vanish', 's8_vanish', 'riverbg-v', round(SH['s8_vanish']['start'] - SH['s6_count']['start'], 3)),
        ('candles', 's9_villagers', 's9_villagers', 'candles-v', 0), ('buddha', 's12_buddha', 's12_buddha', 'buddha-v', 0),
        ('heaven', 's13_heaven', 's13_heaven', 'heaven-v', 0), ('candle', 's14_respect', 's14_respect', 'candle-v', 0),
        ('gas', 't3_gas', 't4_ignite', 'gasbg-v', 0),
        ('loop', 'c1_ask', 'c2_comment', 'loop-v', round(LOOPLEN - (DUR - SH['c1_ask']['start']), 3))]
XF = 0.12  # outgoing plate stays 0.12 s under the incoming transition (crossfade <= 0.12 s)
def videos():
    out = {}
    for i, (vid, s0, s1, plate, ms) in enumerate(FOOT):
        a = SH[s0]['start']; b = min(DUR, SH[s1]['end'] + XF)
        assert ms >= 0, (vid, ms)
        out[vid] = (f'<video id="v-{vid}" class="clip vid" data-start="{a}" data-duration="{round(b - a, 3)}" '
                    f'data-media-start="{ms}" data-track-index="{1 + i % 2}" muted playsinline src="assets/{plate}.mp4"></video>')
    return out

page = (HERE / 'index.html.tpl').read_text()
rep = {'%%NAGA%%': (HERE / 'naga.js').read_text(), '%%DUR%%': str(DUR), '%%CAPS%%': caps(), '%%ICONS%%': icons(), '%%DATA%%': json.dumps(DATA, ensure_ascii=False)}
for sid, tag in videos().items():
    rep[f'%%V_{sid.upper()}%%'] = tag
for key, v in rep.items():
    page = page.replace(key, v)
assert '%%' not in page, re.findall(r'%%\w+%%', page)
ARGS.out.write_text(page)
if __name__ == '__main__':
    print('dur', DUR, 'captions', len(CAPS), 'loop media_start', FOOT[-1][4])
    print('K', K)
