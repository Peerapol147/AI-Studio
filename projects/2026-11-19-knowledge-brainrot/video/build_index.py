#!/usr/bin/env python3
"""Generates index.html from index.html.tpl (one composition, Thai only).
Shot times come from ../assets/audio/shots-th.json (never set by hand); footage plates are timed from them.
Caption chunks and word anchors are located in ../assets/audio/words.json (the real voice): each time is the
start of the first character of the phrase. Lucide icons are inlined as <symbol>s. Run: python3 build_index.py"""
import html, json, math, pathlib, re

HERE = pathlib.Path(__file__).resolve().parent
AUD = HERE.parent / 'assets' / 'audio'
LUC = HERE.parents[2] / 'assets' / 'vendor' / 'lucide'
# v3: scribe wrote "ถ่ายคลิป" for "ไถคลิป" (2x) and "เม้น" for "เมนต์"; the screen spells the script
ALIAS = {'ไถคลิป': 'ถ่ายคลิป', 'เมนต์': 'เม้น'}
HOOK = 'Brainrot ทำให้สมองพัง จริงหรอ'  # = the big title at frame 0 (not a caption)

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
CAPS = ["Brainrot", "แปลว่า*สมองเน่า*", "ผู้คนมักจะใช้", "*แซวตัวเอง*", "เวลาไถคลิป", "แนว *Short*", "หรือ *TikTok*",
        "*ทั้งคืน*", "มันฮิตซะจน", "*Oxford* เลือกเป็น", "*คำแห่งปี*", "2024", "แต่*ยังไม่มีหลักฐาน*",
        "ว่าคลิปสั้น", "ทำให้สมอง", "*เน่าจริง*นะ", "งานวิจัย", "แค่เจอว่า", "คนที่ไถคลิป", "*หนักๆ*",
        "มักทำการ*ทดสอบ*", "เกี่ยวกับ*สมาธิ*", "ได้*แย่กว่า*", "คนที่*ไม่ค่อยมี*", "พฤติกรรมนี้", "หรืออาจเป็นเพราะ",
        "*เครียด*อยู่แล้ว", "เลยทำให้ไถหน้าจอ", "*หนักกว่าเดิม*", "ก็ได้", "*ทริก*ง่ายๆ นะ", "อย่าไถ*บนเตียง*",
        "ก่อนนอน", "คนที่เล่นมือถือ", "ก่อนนอน", "มัก*นอนน้อยลง*", "และ*หลับยาก*", "คืนนี้จะไถ", "ถึง*กี่โมง?*",
        "เมนต์บอกหน่อย", "อย่าลืม*พักผ่อน*"]
# word anchors for the motion, searched in speech order
ANCH = [('jing', 'จริงหรอ'), ('b2', 'Brainrot'), ('smnao', 'สมอง'), ('nao', 'เน่า'), ('saew', 'แซวตัวเอง'),
        ('short', 'Short'), ('tiktok', 'TikTok'), ('thangkuen', 'ทั้งคืน'), ('oxford', 'Oxford'), ('year', 'คำแห่งปี'),
        ('laksan', 'หลักฐาน'), ('naojing', 'เน่าจริง'), ('wijai', 'งานวิจัย'), ('jer', 'เจอว่า'), ('nak', 'หนักๆ'),
        ('test', 'ทดสอบ'), ('samathi', 'สมาธิ'), ('yae', 'แย่กว่า'), ('maikoi', 'ไม่ค่อยมี'), ('phrut', 'พฤติกรรม'),
        ('arj', 'หรืออาจ'), ('kriat', 'เครียด'), ('naja', 'หน้าจอ'), ('nakkwa', 'หนักกว่าเดิม'), ('trick', 'ทริก'),
        ('ngai', 'ง่ายๆ'), ('tiang', 'เตียง'), ('mue', 'มือถือ'), ('nonnoi', 'นอนน้อย'), ('lubyak', 'หลับยาก'),
        ('khuenni', 'คืนนี้'), ('kimong', 'กี่โมง'), ('ment', 'เมนต์'), ('luem', 'อย่าลืม'), ('phak', 'พักผ่อน')]
ICONS = ['moon', 'check', 'arrow-right', 'smartphone', 'brain', 'bed', 'lightbulb', 'message-circle', 'clock', 'circle-check', 'circle-x',
         'triangle-alert', 'book-open', 'target', 'trending-up', 'trending-down', 'search', 'zap']

shots = json.loads((AUD / 'shots-th.json').read_text())
DUR = math.floor(shots['duration'] * 30) / 30  # clip ends with the voice (no silent tail), on a frame boundary
DUR = round(DUR, 3)
f = finder(); f(HOOK); capt = [f(c) for c in CAPS]
f = finder(); f('Brainrot ทำให้สมองพัง'); K = {key: f(ph) for key, ph in ANCH}
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
        src = (LUC / f'{n}.svg').read_text()
        inner = re.search(r'>\s*(.*)</svg>', src, re.S).group(1).strip()
        inner = re.sub(r'\s+', ' ', inner)
        out.append(f'<symbol id="ic-{n}" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" '
                   f'stroke-linecap="round" stroke-linejoin="round">{inner}</symbol>')
    return '\n'.join(out)

# footage scenes: (scene id, shot id, plate, data-media-start). Plates are cut at the chosen source point by
# prep_assets.sh, except hook-v.mp4 which keeps the source clock: hook = shots-th media_start 2.0,
# loop = 2.0 - loop duration so the LAST frame of the clip is source 2.0 s = the frame-0 image (seamless loop).
FOOT = [('hook', 'hook-v', SH['hook']['ms']), ('tease', 'tease-v', 0), ('night', 'night-v', 0), ('noproof', 'noproof-v', 0),
        ('heavy', 'heavy-v', 0), ('stress', 'stress-v', 0), ('screen', 'screen-v', 0), ('beforebed', 'beforebed-v', 0),
        ('sleep', 'sleep-v', 0), ('loop', 'hook-v', round(SH['hook']['ms'] - (DUR - SH['loop']['start']), 3))]
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
(HERE / 'index.html').write_text(page)
if __name__ == '__main__':
    print('dur', DUR, 'captions', len(CAPS), 'loop media_start', FOOT[-1][2])
    print('K', K)
