#!/usr/bin/env python3
"""Generates index.html from index.html.tpl (one composition, Thai only). Lore อนิเมะ EP1: ทวีปมืด (Hunter x Hunter).
Copied from templates/brainrot-v2 (Brainrot v2) and adapted: no footage, the whole clip is our own motion graphic.
Shot times come from ../assets/audio/shots-th.json (never set by hand).
Caption chunks and word anchors are located in ../assets/audio/words.json (the real voice): each time is the
start of the first character of the phrase. Lucide icons are inlined as <symbol>s.
Still slots S1-S11 (shots.json "still"): if ../assets/stills/S#.png|jpg|jpeg|webp exists it is copied to
assets/stills/ (gitignored) and shown in a tilted card; otherwise the graphic fallback plays. See STILLS.md.
Run: python3 build_index.py [--audio DIR] [--out FILE] [--duration SEC]
  --audio     folder with words.json + shots-th.json (default ../assets/audio, i.e. projects/<x>/assets/audio)
  --out       where to write the page (default index.html next to this script)
  --duration  clip length (default: end of the voice + 0.43 s tail, on a frame boundary; must stay <= 59.5)
The repo root (for assets/vendor/lucide) is found by walking up from this file; set AI_STUDIO_ROOT to override."""
import argparse, hashlib, html, json, math, os, pathlib, re, shutil, subprocess

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
_ap.add_argument('--duration', type=float, default=None)
ARGS, _ = _ap.parse_known_args()
AUD = ARGS.audio.resolve()
PROJ = AUD.parents[1]
LUC = repo_root() / 'assets' / 'vendor' / 'lucide'
# scribe spelled the names differently from the script; the screen spells the script.
# display -> as transcribed (applied after removing spaces)
ALIAS = {'กอน': 'กร', 'เน็ตโร': 'เนดโร', 'ซิกก์โซลดิ๊ก': 'ซิกโซดิก', 'บียอนด์': 'บียอน', 'เมนต์': 'เม้นต์',
         'แล้วหนึ่ง': 'และหนึ่ง'}

def norm(s):
    s = re.sub(r"[\s*?!.,'’…“”]", '', s.lower())
    for a, b in ALIAS.items():
        s = s.replace(a, b)
    return s

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

# caption chunks (1-3 words); *x* = key word (yellow); "shown|spoken" when the screen writes digits.
# The hook sentence (ทุกที่ที่กอนเคยไปมา เป็นแค่จุดเล็กๆ กลางทะเลสาบยักษ์) is the big title from frame 0, not a caption.
CAPS = ["ชื่อ*โมเบียส*นะ", "ที่ล้อมรอบอยู่", "คือ*ทวีปมืด*", "ใหญ่จน*เน็ตโร*", "ที่เคยไปกับ", "*ซิกก์ โซลดิ๊ก*",
        "ยังบอกว่า", "มัน*ใหญ่เกินไปแล้ว*", "คนพยายาม", "ข้ามไป", "*149* ครั้ง|ร้อยสี่สิบเก้าครั้ง",
        "มีแค่*ห้า*ครั้ง", "ที่มีคน*รอด*", "กลับมา", "ห้าครั้งนั้น", "ไปเอา*ของวิเศษ*", "แต่ที่ติด", "กลับมาจริงๆ",
        "คือ*ภัยพิบัติ*", "ไปเอา*หินปั่นไฟ*", "เจอ*ปาปุ*", "ตัวที่เลี้ยงคน", "เป็นสัตว์เลี้ยง", "ไป*พันคน*",
        "รอด*เจ็ด*", "ไปเอา*สมุนไพร*", "รักษาทุกโรค", "เจอ*ไบรออน*", "อาวุธพืช", "รอด*สองคน*", "ไปเอา*ข้าว*",
        "อายุยืน", "เจองูสองหาง", "*เฮลเบล*", "โดนไป *99*|โดนไปเก้าสิบเก้า", "*เปอร์เซ็นต์*", "ไปเอา*น้ำวิเศษ*",
        "เจอ*ไอ*", "ก๊าซที่มีชีวิต", "รอด*สามคน*", "แต่*สติหลุด*", "ไปแล้ว", "ทีมสุดท้าย", "ได้ของมา*จริง*",
        "แต่*ของตาย*", "กลางทาง", "แถมพา*โรค*", "ที่ทำให้คน", "*ไม่ตาย*", "กลับมาด้วย", "แล้วหนึ่งในคน", "ที่*รอด*",
        "คือ*บียอนด์*", "ลูกชาย*เน็ตโร*", "ที่กำลังจะ", "กลับไป*อีกรอบ*", "ถ้าต้องไปเอง", "ของชิ้นไหน",
        "*คุ้มเสี่ยงสุด*", "*เมนต์*มาเลย"]
# word anchors for the motion, searched in speech order
ANCH = [('kon', 'กอน'), ('jud', 'จุดเล็กๆ'), ('lake', 'กลางทะเลสาบ'), ('yak', 'ยักษ์'), ('mobius', 'โมเบียส'),
        ('dark', 'ทวีปมืด'), ('netero', 'เน็ตโร'), ('zigg', 'ซิกก์โซลดิ๊ก'), ('yai', 'ใหญ่เกินไปแล้ว'),
        ('n149', 'ร้อยสี่สิบเก้า'), ('five', 'ห้าครั้ง'), ('rod', 'รอดกลับมา'), ('wiset', 'ของวิเศษ'),
        ('jing', 'จริงๆ'), ('pai', 'ภัยพิบัติ'),
        ('hin', 'หินปั่นไฟ'), ('papu', 'ปาปุ'), ('pet', 'สัตว์เลี้ยง'), ('pan', 'พันคน'), ('jed', 'เจ็ด'),
        ('herb', 'สมุนไพร'), ('raksa', 'รักษาทุกโรค'), ('brion', 'ไบรออน'), ('arwut', 'อาวุธพืช'), ('song', 'สองคน'),
        ('khao', 'ข้าว'), ('ayu', 'อายุยืน'), ('ngu', 'งูสองหาง'), ('hell', 'เฮลเบล'), ('n99', 'เก้าสิบเก้า'),
        ('pct', 'เปอร์เซ็นต์'), ('nam', 'น้ำวิเศษ'), ('ai', 'ไอ'), ('gas', 'ก๊าซ'), ('cheewit', 'ชีวิต'),
        ('sam', 'สามคน'), ('sati', 'สติหลุด'), ('team', 'ทีมสุดท้าย'), ('jring', 'จริง'), ('tai', 'ของตาย'),
        ('klang', 'กลางทาง'), ('rok', 'โรค'), ('maitai', 'ไม่ตาย'), ('neung', 'หนึ่ง'), ('rod6', 'รอด'),
        ('beyond', 'บียอนด์'), ('luk', 'ลูกชาย'), ('net2', 'เน็ตโร'), ('klab', 'กลับไป'), ('rob', 'อีกรอบ'),
        ('ao', 'ถ้าต้องไปเอง'), ('chin', 'ชิ้นไหน'), ('khum', 'คุ้มเสี่ยงสุด'), ('ment', 'เมนต์')]
ICONS = ['triangle-alert', 'landmark', 'mountain', 'flag', 'star', 'user', 'users', 'zap', 'leaf', 'droplets',
         'hourglass', 'infinity', 'message-circle', 'eye', 'flask-conical', 'circle-check', 'circle-x', 'map-pin', 'compass']

def load_shots():
    """shots-th.json from tools/shot_times.py, refused if shots.json/footage.json/words.json changed since."""
    f = AUD / 'shots-th.json'
    if not f.exists():
        raise SystemExit(f'{f} missing: run python3 tools/shot_times.py <project> th (it deletes the file when it fails)')
    s = json.loads(f.read_text())
    for name, want in (s.get('inputs') or {}).items():
        p = PROJ / name
        have = hashlib.sha256(p.read_bytes()).hexdigest() if p.exists() else None
        if have != want:
            raise SystemExit(f'{f} is stale: {name} changed after shot_times ran. '
                             f'Rerun python3 tools/shot_times.py {PROJ} th, then this script.')
    return s

def vo_len():
    vo = AUD / 'vo-th.mp3'
    try:
        return float(subprocess.run(['ffprobe', '-v', 'error', '-show_entries', 'format=duration', '-of', 'csv=p=0', str(vo)],
                                    capture_output=True, text=True).stdout)
    except Exception:
        return None

shots = load_shots()
_end = vo_len() or shots['duration']
DUR = ARGS.duration if ARGS.duration else math.ceil((_end + 0.43) * 30) / 30   # short tail after the voice
DUR = round(DUR, 3)
assert DUR <= 59.5, ('clip too long', DUR)
SPOK = [c.split('|')[1] if '|' in c else c for c in CAPS]
SHOWN = [c.split('|')[0] for c in CAPS]
f = finder(); capt = [f(c) for c in SPOK]
f = finder(); K = {key: f(ph) for key, ph in ANCH}
SH = {s['id']: {'start': s['start'], 'end': s['end'], 'word': s['word_at'], 'hit': s.get('hit_at')} for s in shots['shots']}
SH['loop']['end'] = DUR

# ---- still slots: S# -> file in ../assets/stills (gitignored), copied to assets/stills (gitignored) ----
SRC_STILLS = PROJ / 'assets' / 'stills'
DST_STILLS = HERE / 'assets' / 'stills'
slots = {}
for sh in json.loads((PROJ / 'shots.json').read_text())['shots']:
    if sh.get('still'):
        slots[sh['still']] = sh['id']
STILLS = {}
for sid in sorted(slots, key=lambda x: int(x[1:])):
    for ext in ('png', 'jpg', 'jpeg', 'webp', 'PNG', 'JPG', 'JPEG', 'WEBP'):
        src = SRC_STILLS / f'{sid}.{ext}'
        if src.exists():
            DST_STILLS.mkdir(parents=True, exist_ok=True)
            for old in DST_STILLS.glob(f'{sid}.*'):
                old.unlink()
            dst = DST_STILLS / f'{sid}.{ext.lower()}'
            shutil.copyfile(src, dst)
            STILLS[sid] = f'assets/stills/{dst.name}'
            break
    else:
        for old in DST_STILLS.glob(f'{sid}.*') if DST_STILLS.exists() else []:
            old.unlink()
DATA = {'dur': DUR, 'capt': capt, 'k': K, 'sh': SH, 'stills': STILLS}

def caps():
    out = []
    for i, txt in enumerate(SHOWN):
        s = capt[i]
        e = capt[i + 1] if i + 1 < len(capt) else DUR
        d = round(e - s, 3)
        assert d >= 0.4, (txt, d)
        n = len(re.sub(r'[ัิ-ฺ็-๎*]', '', txt))  # base glyphs only (marks take no width)
        size = 96 if n <= 9 else (88 if n <= 11 else (80 if n <= 13 else 72))
        body = re.sub(r'\*(.+?)\*', r'<em>\1</em>', html.escape(txt))
        out.append(f'  <div id="c{i}" class="clip cap" data-start="{s}" data-duration="{d}" '
                   f'data-track-index="20"><span style="font-size:{size}px">{body}</span></div>')
    return '\n'.join(out)

def icons():
    out = []
    for n in ICONS:
        f = LUC / f'{n}.svg'
        if not f.exists():
            f = HERE / 'vendor' / 'lucide-extra' / f'{n}.svg'
        if not f.exists():
            raise SystemExit(f'missing icon {n} (add it from lucide-static, see assets/vendor/README.md)')
        src = f.read_text()
        inner = re.search(r'>\s*(.*)</svg>', src, re.S).group(1).strip()
        inner = re.sub(r'\s+', ' ', inner)
        out.append(f'<symbol id="ic-{n}" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" '
                   f'stroke-linecap="round" stroke-linejoin="round">{inner}</symbol>')
    return '\n'.join(out)

def imgs(prefix, ids):
    return ''.join(f'<img id="{prefix}-{s}" class="simg" src="{STILLS[s]}" alt=""/>' for s in ids if s in STILLS)

page = (HERE / 'index.html.tpl').read_text()
rep = {'%%DUR%%': str(DUR), '%%CAPS%%': caps(), '%%ICONS%%': icons(), '%%DATA%%': json.dumps(DATA, ensure_ascii=False),
       '%%CARD_IMGS%%': imgs('si', ['S1', 'S2', 'S3', 'S4', 'S5', 'S10']),
       '%%WIN_IMGS%%': imgs('wi', ['S6', 'S7', 'S8', 'S9', 'S11'])}
for key, v in rep.items():
    page = page.replace(key, v)
assert '%%' not in page, re.findall(r'%%\w+%%', page)
ARGS.out.write_text(page)
if __name__ == '__main__':
    print('dur', DUR, 'voice', round(_end, 3), 'captions', len(CAPS), 'stills', STILLS or 'none (graphic fallback)')
