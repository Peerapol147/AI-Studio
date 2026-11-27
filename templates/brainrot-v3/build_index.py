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
(tools/shot_times.py, refused if stale). Every shot needs a "beat" (hook ... loop). Camera (dev v3.7): every shot
moves at a speed set by its REAL length (camera() below: a short shot pushes faster, never a still frame > 0.5 s),
hook/twist ~1.3x stronger. Cuts (dev v3.7 #18, brainrot-v2 feel): the look's transition (look.py rotates it) plays
wherever the beat changes and inside hook/twist; every other cut is a HARD cut (was a 0.1 s crossfade); the loop shot
keeps a 0.1 s match into the hook plate. Zoom punch (v2): the picture punches in on highlighted *caption* words, at
most one per PUNCH_GAP s (episode.json "punch": "off" | ["caption text", ...] overrides). See docs/editing-v3.md.

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


# frame-0 title = look.json cover_text (the feed's first frame, checked for repeats by tools/look.py). The covers that
# get UPLOADED are separate since 2026-11-26 (look.json "covers" A/B -> cover.html, tools/cover_check.py)
_ct = LOOK.get('cover_text')
_shown = ' '.join(EP.get('title', []))
if _ct and _plain(_ct) != _plain(_shown):
    raise SystemExit(f'look.json cover_text {_ct!r} != episode.json title {_shown!r} (cover_text = the frame-0 title): '
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


def camera(d, beat, i):
    """Ken Burns of one shot from its real length d (s), brainrot-v2 feel (every shot moves: push + tilt + drift).
    push grows with length but slower than the length, so a short cut moves faster (1 s: 10 %/s, 2 s: 6.5 %/s,
    4 s+: 17 % = 4.3 %/s and less) and a 24 px pan (up/down, alternating) rides on every shot; it starts at 2.2x its mean speed on the cut (the punch) and keeps >= 40 % of the
    mean speed to the next cut (the old smootherstep stood still for the first and last ~10 % of every hold shot), and
    the drift never stops. hook/twist get 1.3x push (scale capped at 1.22) and a wider drift. k0 >= 1.04/1.06 keeps
    the plate edge out of frame under the tilt + drift."""
    fast = beat in FAST
    push = min(0.17, max(0.10, 0.07 + 0.03 * d)) * (1.3 if fast else 1.0)
    k0 = 1.06 if fast else 1.04
    rot = (0.8 if fast else 0.6) * (1 if i % 2 else -1)
    return {'k0': k0, 'k1': round(min(1.22, k0 + push), 4), 'r0': rot, 'r1': -rot, 'dr': 14 if fast else 10,
            'pan': 24 if i % 2 else -24}


def cut_kind(i, s, prev):
    """How shot i enters: none (first), match (loop seam), the look's transition (beat change / hook / twist), else cut."""
    if i == 0:
        return 'none'
    if s['beat'] == 'loop':
        return 'match'
    if s['beat'] in FAST or s['beat'] != prev['beat']:
        return LOOK['transition']
    return 'cut'


PUNCH_GAP = 1.5
PUNCH_AFTER_CUT = 0.3
PUNCH_MAX = 8      # review v3.7 Y5: a punch right on a cut/transition stacks two hits; skip it


def punches(caps, times, dur, hook_end, cuts=()):
    """Zoom-punch times: highlighted captions after the hook, >= PUNCH_GAP s apart, not in the last 0.5 s (loop seam),
    not within PUNCH_AFTER_CUT s after a shot enters (cut or the look's transition)."""
    want = EP.get('punch', 'auto')
    if want == 'off':
        return []
    if isinstance(want, list):
        pick = [t for c, t in zip(caps, times) if c in want or c.replace('*', '') in want]
    else:
        pick = [t for c, t in zip(caps, times) if '*' in c and t >= hook_end]
    out = []
    for t in pick:
        if any(0 <= t - c < PUNCH_AFTER_CUT for c in cuts):
            continue
        if t < dur - 0.5 and (not out or t - out[-1] >= PUNCH_GAP):
            out.append(t)
    if len(out) > PUNCH_MAX and not isinstance(want, list):   # review v3.7: 4-8 punches a clip, spread over it
        out = [out[round(k * (len(out) - 1) / (PUNCH_MAX - 1))] for k in range(PUNCH_MAX)]
    return out


def punch_feel():
    """Punch strength (scale kick) and decay per look, so every episode does not punch the same (review v3.7 ⚪)."""
    h = int(hashlib.sha256('|'.join(str(LOOK[k]) for k in ('palette', 'font', 'caption', 'opening', 'cover', 'transition'))
                           .encode()).hexdigest(), 16)
    return {'amp': round(0.06 + 0.04 * (h % 101) / 100, 3), 'decay': round(6 + 3 * (h // 101 % 101) / 100, 2)}


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
            inner = f'<img class="vid" src="{html.escape(plate)}" alt=""/>'
        out.append(f'  <div class="sc" id="sh-{sid}"><div class="kb" id="kb-{sid}">{inner}</div><div class="vig"></div></div>')
        sc.append({'id': sid, 'a': a, 'b': b, 'beat': s['beat'], 'still': loop or i == 0, 'cam': camera(b - a, s['beat'], i),
                   'k': cut_kind(i, s, SHOTS[i - 1] if i else None)})
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
BAND = {'pov': 540, 'number': 570}
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
    tilt = LOOK['cover'] == 'tilt' and LOOK['opening'] != 'midstory'   # tight 1.26 line (no plates), see index.html.tpl
    per = (1.26 if tilt else 1.42) + (0.16 if LOOK['opening'] == 'midstory' else 0)
    gap = {'tilt': 30}.get(LOOK['cover'], 14)
    kick_h = {'pov': 104, 'number': NUM_SIZE(len(lines)) + 12}.get(LOOK['opening'], 0)
    fixed = gap * (len(rows) + len(lines) - 1) + kick_h + (74 if LOOK['cover'] == 'card' else 0)
    room = BAND.get(LOOK['opening'], TITLE_BAND) - fixed
    # a line with a highlight plate grows: the plate is an inline-block 1.12 em + .38 em top + .24 em bottom padding
    # tilt: the highlighted word is an underline (1.12 em + 4 px + 16 px border), ~24 px below the 1.26 line
    pers = [max(per, 1.74 + (0.16 if LOOK['opening'] == 'midstory' else 0)) if '*' in ln and not tilt else per for ln in lines]
    room -= 24 * sum('*' in ln for ln in lines) if tilt else 0
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
DATA = {'dur': DUR, 'capt': capt, 'sc': SC, 'hookEnd': HOOK_END, 'punch': punches(CAPS, capt, DUR, HOOK_END, [s['a'] for s in SC[1:]]), 'punchFeel': punch_feel(), 'look': {k: LOOK[k] for k in
        ('palette', 'font', 'caption', 'opening', 'cover', 'transition')}}
rep = {'%%DUR%%': str(DUR), '%%VARS%%': ';'.join(f'{k}:{v}' for k, v in VARS.items()),
       '%%SCENES%%': SCENES, '%%CAPS%%': caps(), '%%TITLE%%': title(), '%%ICONS%%': icons(),
       '%%CAPSTYLE%%': 'cap-' + LOOK['caption'], '%%OPENING%%': f"op-{LOOK['opening']} cv-{LOOK['cover']}",
       '%%VO%%': html.escape(EP.get('vo', 'assets/vo-th.mp3')), '%%MUSIC%%': MUSIC,
       '%%DATA%%': json.dumps(DATA, ensure_ascii=False), '%%LOOKNAME%%': html.escape(
           f"{LOOK['palette']} / {LOOK['font']} / {LOOK['caption']} / {LOOK['opening']} / {LOOK['cover']} / {LOOK['transition']}")}
page = (HERE / 'index.html.tpl').read_text()
for k, v in rep.items():
    page = page.replace(k, v)
left = re.findall(r'%%\w+%%', page)
if left:
    raise SystemExit(f'unfilled placeholders {left}')
A.out.write_text(page)
if __name__ == '__main__':
    print('dur', DUR, 'shots', len(SHOTS), 'captions', len(CAPS), 'look', rep['%%LOOKNAME%%'])
