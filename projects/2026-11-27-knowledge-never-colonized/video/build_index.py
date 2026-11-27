#!/usr/bin/env python3
"""Brainrot v3: one composition whose LOOK comes from the project's look.json (editing v3).
Generates index.html from index.html.tpl + episode.json (this folder) + ../look.json + the real voice timing.

  python3 build_index.py [--audio DIR] [--look FILE] [--episode FILE] [--out FILE]
    --audio    words.json + shots-th.json (default ../assets/audio)
    --look     look.json (default ../look.json = projects/<x>/look.json, written by tools/look.py pick)
    --episode  episode.json (default ./episode.json)
    --out      default ./index.html

look.json picks palette / font / caption / opening / cover / transition from templates/looks/looks.json (music_mood and
voice are for the voice step; music_file becomes the music track). Shot times come from shots-th.json only
(tools/shot_times.py, refused if stale). Every shot needs a "beat" (hook ... loop): hook + twist shots get the
fast camera, the rest hold the picture (slow 8 % push + 1 deg drift, no cut); the look's transition plays wherever the
beat changes and inside hook/twist, other cuts inside one beat are a 0.1 s match. See docs/editing-v3.md.

episode.json:
{
  "title":  ["บรรทัด 1", "บรรทัด *2*"],      # hook question on screen = the spoken hook word for word; *x* = accent
  "kicker": "POV: ..." | "71%" | null,       # opening pov: the POV line; opening number: the big number (from research.md)
  "caps":   ["ซับ", "*คำสำคัญ*", ...],         # 1-3 words per chunk, in speech order, found in words.json
  "plates": {"<shot id>": "assets/x.mp4" | "assets/x.jpg" | "graphic"},   # one per shot; graphic = empty slot #g-<id>
  "vo": "assets/vo-th.mp3"
}
The loop shot plays the hook plate so the clip's LAST frame is the frame-0 picture (video: media_start is set so it
ends on the hook's media_start; still: the push runs backwards to the frame-0 scale).
Repo root (templates/looks, assets/vendor/lucide) is found by walking up; AI_STUDIO_ROOT overrides."""
import argparse, hashlib, html, json, math, os, pathlib, re, sys

HERE = pathlib.Path(__file__).resolve().parent
BEATS = ('hook', 'setup', 'explain', 'reveal', 'twist', 'share', 'cta', 'loop')
FAST = ('hook', 'twist')


def repo_root():
    if os.environ.get('AI_STUDIO_ROOT'):
        return pathlib.Path(os.environ['AI_STUDIO_ROOT']).resolve()
    for d in [HERE, *HERE.parents]:
        if (d / 'templates' / 'looks' / 'looks.json').exists():
            return d
    raise SystemExit(f'repo root not found above {HERE} (no templates/looks/looks.json); set AI_STUDIO_ROOT')


ap = argparse.ArgumentParser(description=__doc__.split('\n')[0])
ap.add_argument('--audio', type=pathlib.Path, default=HERE.parent / 'assets' / 'audio')
ap.add_argument('--look', type=pathlib.Path, default=HERE.parent / 'look.json')
ap.add_argument('--episode', type=pathlib.Path, default=HERE / 'episode.json')
ap.add_argument('--out', type=pathlib.Path, default=HERE / 'index.html')
A = ap.parse_args()
AUD = A.audio.resolve()
ROOT = repo_root()
CAT = json.loads((ROOT / 'templates' / 'looks' / 'looks.json').read_text())

if not A.look.exists():
    raise SystemExit(f'{A.look} missing: run python3 tools/look.py pick <project> --write (then tools/look.py check)')
LOOK = json.loads(A.look.read_text())
LOOK.setdefault('cover', 'stack')          # look.json written before the cover axis existed
for axis in ('palette', 'font', 'caption', 'opening', 'cover', 'transition'):
    if LOOK.get(axis) not in CAT[axis] or str(LOOK.get(axis)).startswith('_'):
        raise SystemExit(f'look.json {axis}={LOOK.get(axis)!r} not in templates/looks/looks.json')
PAL, FONT = CAT['palette'][LOOK['palette']], CAT['font'][LOOK['font']]
EP = json.loads(A.episode.read_text())


def _plain(s):
    return re.sub(r"[\s*?!.,:;'\"“”‘’=\-–—()…]+", '', (s or '').lower())


# frame 0 = the cover: the on-screen title must be the cover_text that tools/look.py checked for repeats
_ct = LOOK.get('cover_text')
_shown = ' '.join(EP.get('title', []))
if _ct and _plain(_ct) != _plain(_shown):
    raise SystemExit(f'look.json cover_text {_ct!r} != episode.json title {_shown!r} (frame 0 = cover): '
                     'make them the same text, then rerun tools/look.py check')
if not _ct:
    print('WARN look.json cover_text not set: write the frame-0 title there and run tools/look.py check', file=sys.stderr)


def norm(s):
    return re.sub(r"[\s*?!.,'’…:]", '', s.lower())


def finder():
    words = [w for w in json.loads((AUD / 'words.json').read_text())['words'] if w.get('type', 'word') == 'word']
    ch = [(c, w['start']) for w in words for c in norm(w['text'])]
    flat = ''.join(c for c, _ in ch)
    pos = 0

    def find(phrase):
        nonlocal pos
        p = norm(phrase)
        i = flat.find(p, pos)
        if i < 0:
            raise SystemExit(f'caption {phrase!r} not found in words.json after char {pos} (write it as the voice says it, or "shown|as transcribed" when words.json spells it differently)')
        pos = i + len(p)
        return round(ch[i][1], 3)
    return find


def load_shots():
    f = AUD / 'shots-th.json'
    if not f.exists():
        raise SystemExit(f'{f} missing: run python3 tools/shot_times.py <project> th (it deletes the file when it fails)')
    s = json.loads(f.read_text())
    proj = AUD.parents[1]
    for name, want in (s.get('inputs') or {}).items():
        p = proj / name
        if (hashlib.sha256(p.read_bytes()).hexdigest() if p.exists() else None) != want:
            raise SystemExit(f'{f} is stale: {name} changed after shot_times ran. Rerun python3 tools/shot_times.py {proj} th')
    return s


TL = load_shots()
DUR = round(math.floor(TL['duration'] * 30) / 30, 3)
SHOTS = TL['shots']
for s in SHOTS:
    if s.get('beat') not in BEATS:
        raise SystemExit(f'shot {s["id"]}: beat {s.get("beat")!r} missing/unknown in shots.json (one of {", ".join(BEATS)})')
if SHOTS[0]['beat'] != 'hook' or SHOTS[-1]['beat'] != 'loop':
    raise SystemExit('first shot must be beat "hook" and the last beat "loop" (tools/pacing.py explains why)')
PLATES = EP['plates']
missing = [s['id'] for s in SHOTS if s['id'] not in PLATES]
if missing:
    raise SystemExit(f'episode.json plates has no entry for: {", ".join(missing)}')

find = finder()
CAPS = EP['caps']
# caption "shown|heard": show the script spelling, find its time with the words.json spelling
# (stomach-growl: scribe wrote "Borborygmus" for บอร์บอริกมัส and "คร่ำคร่าก" for โครกคราก)
for c in CAPS:
    if '|' in c and (c.count('|') > 1 or not c.partition('|')[0].strip() or not c.partition('|')[2].strip()):
        raise SystemExit(f'caption {c!r}: write exactly "shown|as transcribed" (one |, text on both sides)')
CAPS_MATCH = [c.partition('|')[2] or c for c in CAPS]
CAPS = [c.partition('|')[0] for c in CAPS]
capt = [find(c) for c in CAPS_MATCH]
HOOK_END = next((s['start'] for s in SHOTS if s['beat'] != 'hook'), DUR)
hook_plate = PLATES[SHOTS[0]['id']]
hook_ms = SHOTS[0].get('media_start') or 0.0
XF = 0.12


def is_video(p):
    return p.lower().endswith(('.mp4', '.webm', '.mov'))


def scenes():
    out, sc = [], []
    for i, s in enumerate(SHOTS):
        sid, a = s['id'], s['start']
        b = DUR if i == len(SHOTS) - 1 else SHOTS[i + 1]['start']
        plate = hook_plate if s['beat'] == 'loop' else PLATES[sid]
        loop = s['beat'] == 'loop'
        inner = ''
        if plate == 'graphic':
            inner = f'<div class="gslot" id="g-{sid}"></div>'
        elif is_video(plate):
            ms = round(hook_ms - (DUR - a), 3) if loop else (s.get('media_start') or 0)
            if ms < 0:
                raise SystemExit(f'loop shot is {DUR - a:.2f} s but the hook media_start is {hook_ms}: pick a later hook '
                                 f'in-point (media_start >= loop length) so the last frame = frame 0')
            end = min(DUR, b + XF)
            inner = (f'<video id="v-{sid}" class="clip vid" data-start="{a}" data-duration="{round(end - a, 3)}" '
                     f'data-media-start="{ms}" data-track-index="{1 + i % 2}" muted playsinline src="{html.escape(plate)}"></video>')
        else:
            # episode edit (never-colonized, same as bite-force-ranking): a Pixabay still (<=1280 px) is never blown up
            # full screen: blurred backdrop <x>-bg.jpg + the picture as a card on top (style.md "การ์ดภาพ")
            bg = re.sub(r'\.jpg$', '-bg.jpg', plate)
            if (HERE / bg).exists():
                from PIL import Image
                w, h = Image.open(HERE / plate).size
                cw = 960 if w >= h else 620
                ch = round(cw * h / w)
                top = 1010 - ch // 2
                inner = (f'<img class="vid" src="{html.escape(bg)}" alt=""/>'
                         f'<div class="card" id="cd-{sid}" style="left:{(1080 - cw) // 2}px;top:{top}px;width:{cw}px;height:{ch}px">'
                         f'<img src="{html.escape(plate)}" alt=""/></div>')
            else:
                inner = f'<img class="vid" src="{html.escape(plate)}" alt=""/>'
        out.append(f'  <div class="sc" id="sh-{sid}"><div class="kb" id="kb-{sid}">{inner}</div><div class="vig"></div></div>')
        sc.append({'id': sid, 'a': a, 'b': b, 'beat': s['beat'], 'still': loop or i == 0})
    return '\n'.join(out), sc


def caps():
    out = []
    for i, txt in enumerate(CAPS):
        s = capt[i]
        e = capt[i + 1] if i + 1 < len(capt) else DUR
        d = round(e - s, 3)
        if d < 0.4:
            raise SystemExit(f'caption {txt!r} is on screen {d} s (< 0.4 s): merge it with the next chunk')
        n = len(re.sub(r'[ัิ-ฺ็-๎*\s]', '', txt))
        size = 96 if n <= 9 else (88 if n <= 11 else 80)
        if n > 12:
            print(f'WARN caption {txt!r} has {n} letters: style wants 1-3 words per beat, split it')
        body = re.sub(r'\*(.+?)\*', r'<em>\1</em>', html.escape(txt))
        out.append(f'  <div id="c{i}" class="clip cap" data-start="{s}" data-duration="{d}" data-track-index="20">'
                   f'<span style="font-size:{size}px">{body}</span></div>')
    return '\n'.join(out)


# width of a title line in em of its font size (measured in Chromium at weight 900/700: Thai letters ~0.57-0.60 em
# for Kanit / Prompt / Noto Sans Thai / Sarabun, Latin capitals ~0.82): marks above/below the line take no width.
# The old rule 880/n*1.9 overflowed: "ทั้งที่เพิ่งกินข้าว?" (stomach-growl) ran past the card and past the 960 px title box.
def line_ems(ln):
    t = re.sub(r'\*', '', ln)
    w = 0.0
    for ch in t:
        if re.match(r'[\u0e31\u0e34-\u0e3a\u0e47-\u0e4e]', ch):
            continue                       # combining Thai vowel / tone mark
        if ch == ' ':
            w += 0.28
        elif 'A' <= ch <= 'Z' or ch in 'MW@%&':
            w += 0.84
        else:
            w += 0.62
    return w


TITLE_BAND = 450                           # title starts at Y 250, must end by ~Y 700 (style.md)
# pov / number put a kicker above the question: let those titles run lower (captions start at Y 1100);
# review v3.3: a 270 px number inside the 450 px band shrank the question to 10-59 px
BAND = {'pov': 500, 'number': 570}
NUM_SIZE = lambda n: 220 if n <= 1 else 170 if n == 2 else 140   # the big number above the question
MIN_TITLE = (72, 60)                       # px for <= 2 / 3+ lines; smaller is unreadable on a phone -> refuse, never shrink silently


def title_room(ln):
    """px a title line may use: 960 title box minus the stroke / card padding / plate padding of this look."""
    room = 960 - 30                        # 22 px text stroke + margin
    if LOOK['cover'] == 'card':
        room = 960 - 80 - 20               # card padding 40+40
    if LOOK['opening'] == 'midstory':
        room -= 52                         # accent plate padding 26+26
    if LOOK['cover'] == 'tilt':
        room -= 40                         # rotated lines
    room -= 34 * ln.count('*') // 2        # padding of each highlighted word on a plate
    return room


def title():
    lines = EP['title']
    big = 150 if LOOK['opening'] in ('question', 'pov') else 118
    rows = []
    kick = EP.get('kicker')
    if LOOK['opening'] == 'pov':
        rows.append(f'<div class="kick pov">{html.escape(kick or "POV:")}</div>')
    if LOOK['opening'] == 'number':
        if not kick:
            raise SystemExit('opening "number" needs episode.json kicker = the number (from research.md)')
        num = NUM_SIZE(len(lines))
        rows.append(f'<div class="kick num" style="font-size:{num}px">{html.escape(kick)}</div>')
    sizes = [min(big, int(title_room(ln) / max(0.5, line_ems(ln)))) for ln in lines]
    # keep the whole title inside the Y 240-700 band (style.md): taller Thai line-height (1.42) needs a height cap
    per = 1.42 + (0.16 if LOOK['opening'] == 'midstory' else 0)
    gap = {'tilt': 30}.get(LOOK['cover'], 14)
    kick_h = {'pov': 104, 'number': NUM_SIZE(len(lines)) + 12}.get(LOOK['opening'], 0)
    fixed = gap * (len(rows) + len(lines) - 1) + kick_h + (74 if LOOK['cover'] == 'card' else 0)
    room = BAND.get(LOOK['opening'], TITLE_BAND) - fixed
    # a line with a highlight plate grows: the plate is an inline-block 1.12 em + .38 em top + .24 em bottom padding
    pers = [max(per, 1.74 + (0.16 if LOOK['opening'] == 'midstory' else 0)) if '*' in ln else per for ln in lines]
    if sum(sz * pp for sz, pp in zip(sizes, pers)) > room:
        k = room / sum(sz * pp for sz, pp in zip(sizes, pers))
        sizes = [int(sz * k) for sz in sizes]
    floor = MIN_TITLE[0] if len(lines) <= 2 else MIN_TITLE[1]
    if min(sizes) < floor:
        raise SystemExit(f'title {lines!r} would be {min(sizes)} px with opening {LOOK["opening"]!r} / cover '
                         f'{LOOK["cover"]!r} (min {floor} px, unreadable on a phone): shorten the lines, use fewer '
                         'lines, or pick another opening/cover in look.json')
    for ln, size in zip(lines, sizes):
        body = re.sub(r'\*(.+?)\*', r'<em>\1</em>', html.escape(ln))
        rows.append(f'<div class="tl" style="font-size:{size}px">{body}</div>')
    return '\n'.join(rows)


def icons():
    luc = ROOT / 'assets' / 'vendor' / 'lucide'
    out = []
    for n in EP.get('icons', []):
        f = luc / f'{n}.svg'
        if not f.exists():
            raise SystemExit(f'missing icon {f}')
        inner = re.sub(r'\s+', ' ', re.search(r'>\s*(.*)</svg>', f.read_text(), re.S).group(1).strip())
        out.append(f'<symbol id="ic-{n}" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" '
                   f'stroke-linecap="round" stroke-linejoin="round">{inner}</symbol>')
    return '\n'.join(out)


SCENES, SC = scenes()
VARS = {'--bg': PAL['bg'], '--bg2': PAL['bg2'], '--ink': PAL['ink'], '--text': PAL['text'], '--accent': PAL['accent'],
        '--accent2': PAL['accent2'], '--panel': PAL['panel'], '--paneltext': PAL['panel_text'], '--font': f"'{FONT['family']}'",
        '--tw': str(FONT['title_weight']), '--cw': str(FONT['cap_weight'])}
music = LOOK.get('music_file')
MUSIC = (f'<audio id="music" class="clip" data-start="0" data-duration="{DUR}" data-track-index="31" data-volume="0.1" '
         f'src="assets/{html.escape(pathlib.Path(music).name)}"></audio>') if music else '<!-- no music_file in look.json yet -->'
DATA = {'dur': DUR, 'capt': capt, 'sc': SC, 'hookEnd': HOOK_END, 'look': {k: LOOK[k] for k in
        ('palette', 'font', 'caption', 'opening', 'cover', 'transition')}}
rep = {'%%DUR%%': str(DUR), '%%VARS%%': ';'.join(f'{k}:{v}' for k, v in VARS.items()),
       '%%SCENES%%': SCENES, '%%CAPS%%': caps(), '%%TITLE%%': title(), '%%ICONS%%': icons(),
       '%%CAPSTYLE%%': 'cap-' + LOOK['caption'], '%%OPENING%%': f"op-{LOOK['opening']} cv-{LOOK['cover']}",
       '%%VO%%': html.escape(EP.get('vo', 'assets/vo-th.mp3')), '%%MUSIC%%': MUSIC,
       '%%DATA%%': json.dumps(DATA, ensure_ascii=False), '%%LOOKNAME%%': html.escape(
           f"{LOOK['palette']} / {LOOK['font']} / {LOOK['caption']} / {LOOK['opening']} / {LOOK['cover']} / {LOOK['transition']}")}
page = (HERE / 'index.html.tpl').read_text()
# episode edit: graphics markup generated from maps.json by make_gfx.py
page = page.replace('<!--EPISODE_GFX-->', (HERE / 'gfx.html').read_text())
for k, v in rep.items():
    page = page.replace(k, v)
left = re.findall(r'%%\w+%%', page)
if left:
    raise SystemExit(f'unfilled placeholders {left}')
A.out.write_text(page)
if __name__ == '__main__':
    print('dur', DUR, 'shots', len(SHOTS), 'captions', len(CAPS), 'look', rep['%%LOOKNAME%%'])
