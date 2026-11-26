#!/usr/bin/env python3
"""Cover (uploaded thumbnail) A/B check, separate from frame 0 (palmaris feedback 7-8, 2026-11-26).

  python3 tools/cover_check.py <project> [--final] [--no-git]
  python3 tools/cover_check.py log <project> --variant a --ctr 9.8 [--impressions 1200] [--note ".."]

The user: "ปกชีพ ไม่น่ากด ... คนกดสูงสุดแค่ 11% อยากได้ปกที่เห็นแล้วอยากกด" and "มันล้นๆ บาลานซ์ไม่ดีปะ".
Frame 0 of the clip keeps its own rule (understood in 1 s with the sound off: the Shorts feed shows frame 0, and most
views come from the feed). The cover is the image uploaded as thumbnail and may be a curiosity line instead, made in 2
variants every episode so CTR can be compared (YouTube "Test & compare", or one per platform), then logged.

look.json "covers": [{"id": "a", "lines": ["หมอตัดเส้นนี้", "ไปใช้ได้!?"]}, {"id": "b", "lines": [...]}]
images + layout: <project>/covers/cover-<id>.jpg and cover-<id>.json from `node tools/cover_shot.js video/cover.html
<project>/covers a,b` (template: templates/brainrot-v3/cover.html). The jpgs are committed (small, public anyway once
uploaded) so later episodes can be compared with them.

ERROR (exit 1):
  - the text in the image (cover-<id>.json) is not the look.json text (cover_shot.js injects look.json; a stale image or
    a hand-edited cover.html fails)
  - fewer than 2 variants, a variant with 0 or more than 2 lines, two variants with the same text
  - a word repeated inside one cover (same token twice, or the same 3+ letter Thai run twice: "ร่างกาย... ร่างกาย")
  - cover text equal/similar (look.py similarity >= 0.6) to a cover or frame-0 text of ANY earlier episode of the channel
  - layout (from cover-<id>.json): text lines overlapping each other or the badge, a text/badge box closer than
    MARGIN px to the image edge or overflowing its box, a text line whose letters are under MIN_PX tall when the
    cover is shrunk to 200 px wide, or a text area with too little light/dark contrast at 200 px (p95-p5 luma < MIN_CONTRAST)
  - --final: images/layout missing
WARN: images missing (not final), no earlier cover images found to compare.
Writes <project>/covers/cover-<id>-200.png (what a phone grid shows) and covers/compare.png (this episode's A/B next to
up to 6 earlier covers of the channel): the director looks at compare.png before sending.
Thresholds are tool settings from the feedback (2 lines, 200 px), not research numbers.
"""
import argparse, datetime, io, json, pathlib, re, subprocess, sys

sys.path.insert(0, str(pathlib.Path(__file__).resolve().parent))
import look  # noqa: E402

ROOT = pathlib.Path(__file__).resolve().parents[1]
MARGIN = 40          # px from the 1080x1920 edge
MIN_PX = 9           # text font size after shrinking to 200 px wide (170 px font -> 31 px; 60 px font -> 11 px)
MIN_CONTRAST = 0.30  # p95 - p5 luma (0..1) inside a text line box at 200 px
THAI_RUN = 3
SMALL = 200


def tokens(text):
    return [t for t in re.split(r'[\s*?!.,:;"\'“”‘’=\-–—()/]+', text.lower()) if t]


def repeated(lines):
    """First repeated word/run in a cover, or None."""
    toks = tokens(' '.join(lines))
    seen = set()
    for t in toks:
        if len(t) >= 2 and t in seen:
            return t
        seen.add(t)
    s = look._norm(''.join(lines))
    for n in range(len(s) // 2, THAI_RUN - 1, -1):
        for i in range(len(s) - n + 1):
            sub = s[i:i + n]
            if re.search(r'[ก-ฮ]', sub) and s.count(sub) >= 2:
                return sub
    return None


def _plain(t):
    return re.sub(r'[\s*]+', '', t or '')


def _overlap(a, b):
    w = min(a['x'] + a['w'], b['x'] + b['w']) - max(a['x'], b['x'])
    h = min(a['y'] + a['h'], b['y'] + b['h']) - max(a['y'], b['y'])
    return max(0, w) * max(0, h) / max(1, min(a['w'] * a['h'], b['w'] * b['h']))


def layout_errors(geo, vid):
    errs = []
    W, H = geo.get('w') or 1080, geo.get('h') or 1920
    items = [i for i in geo.get('items', []) if i['kind'] in ('text', 'badge')]
    texts = [i for i in items if i['kind'] == 'text']
    if len(texts) > 2:
        errs.append(f'cover {vid}: {len(texts)} text lines on the image (max 2)')
    for e in geo.get('errors') or []:
        errs.append(f'cover {vid}: page error {e}')
    for k, a in enumerate(items):
        if a['x'] < MARGIN or a['y'] < MARGIN or a['x'] + a['w'] > W - MARGIN or a['y'] + a['h'] > H - MARGIN:
            errs.append(f'cover {vid}: {a["kind"]} {a["text"]!r} touches/leaves the edge (keep {MARGIN} px inside)')
        if a.get('overflow'):
            errs.append(f'cover {vid}: {a["kind"]} {a["text"]!r} overflows its box')
        for b in items[k + 1:]:
            if _overlap(a, b) > 0.02:
                errs.append(f'cover {vid}: {a["kind"]} {a["text"]!r} overlaps {b["kind"]} {b["text"]!r}')
        if a['kind'] == 'text' and a.get('font_px', 99) * SMALL / W < MIN_PX:
            errs.append(f'cover {vid}: text {a["text"]!r} is {a["font_px"] * SMALL / W:.1f} px at {SMALL} px wide '
                        f'(min {MIN_PX}): make it bigger or shorter')
    return errs


def small_and_contrast(img_path, geo, vid, out):
    from PIL import Image
    im = Image.open(img_path).convert('RGB')
    W = im.width
    s = SMALL / W
    sm = im.resize((SMALL, round(im.height * s)), Image.LANCZOS)
    sm.save(out)
    errs = []
    g = sm.convert('L')
    for i in (geo or {}).get('items', []):
        if i['kind'] != 'text':
            continue
        box = (int(i['x'] * s), int(i['y'] * s), max(int(i['x'] * s) + 1, int((i['x'] + i['w']) * s)),
               max(int(i['y'] * s) + 1, int((i['y'] + i['h']) * s)))
        crop = g.crop(box)
        px = sorted(crop.get_flattened_data() if hasattr(crop, 'get_flattened_data') else crop.getdata())
        if not px:
            continue
        c = (px[int(len(px) * .95) - 1 if len(px) > 1 else 0] - px[int(len(px) * .05)]) / 255
        if c < MIN_CONTRAST:
            errs.append(f'cover {vid}: text {i["text"]!r} has low contrast at {SMALL} px ({c:.2f} < {MIN_CONTRAST})')
    return sm, errs


def old_covers(root, channel, exclude, use_git):
    """[(episode id, PIL image)] of earlier covers: projects/*/covers/cover-*.jpg here and on claude/ep-* branches."""
    from PIL import Image
    found = {}
    for f in sorted((root / 'projects').glob('*/covers/cover-*.jpg')):
        pid = f.parts[-3]
        m = look.ID_RE.match(pid)
        if m and m.group(2) == channel and pid != exclude and pid < exclude:
            found.setdefault(f'{pid}/{f.name}', lambda f=f: Image.open(f))
    if use_git:
        refs = (look._git(root, 'for-each-ref', '--format=%(refname)', 'refs/remotes/origin/claude/ep-*',
                          'refs/heads/claude/ep-*') or '').split()
        for ref in refs:
            names = look._git(root, 'ls-tree', '-r', '--name-only', ref, 'projects') or ''
            for n in names.split():
                mm = re.match(r'projects/([^/]+)/covers/(cover-[^/]+\.jpg)$', n)
                if not mm:
                    continue
                pid = mm.group(1); m = look.ID_RE.match(pid)
                if not (m and m.group(2) == channel and pid != exclude and pid < exclude):
                    continue
                key = f'{pid}/{mm.group(2)}'
                if key not in found:
                    def ld(ref=ref, n=n):
                        b = subprocess.run(['git', '-C', str(root), 'show', f'{ref}:{n}'], capture_output=True).stdout
                        return Image.open(io.BytesIO(b))
                    found[key] = ld
    keys = sorted(found)[-6:]
    out = []
    for k in keys:
        try:
            out.append((k, found[k]().convert('RGB')))
        except Exception:                                     # unreadable blob: skip, it is only for looking at
            pass
    return out


def compare_sheet(mine, olds, out):
    from PIL import Image, ImageDraw
    tiles = [(f'THIS {k}', im) for k, im in mine] + [(k, im) for k, im in olds]
    th = max(im.height for _, im in tiles) if tiles else 356
    sheet = Image.new('RGB', (len(tiles) * (SMALL + 10) + 10, th + 40), (24, 24, 24))
    d = ImageDraw.Draw(sheet)
    for n, (k, im) in enumerate(tiles):
        im = im.resize((SMALL, round(im.height * SMALL / im.width)))
        x = 10 + n * (SMALL + 10)
        sheet.paste(im, (x, 30))
        d.text((x, 8), k[-30:], fill=(255, 255, 255) if k.startswith('THIS') else (170, 170, 170))
    sheet.save(out)


def earlier_texts(root, project, use_git):
    """[(episode id, text)] of frame-0 cover_text and covers[].lines of every earlier episode of the channel."""
    m = look.ID_RE.match(project.name)
    h = look.history(root, m.group(2), project.name, use_git, until=m.group(1))
    h.pop('_refs', None)
    out = []
    for pid, e in h.items():
        lk = e['look'] or {}
        for t in [lk.get('cover_text') or e.get('cover_text')] + [' '.join(c.get('lines', [])) for c in lk.get('covers') or []]:
            if t:
                out.append((pid, t))
    return out


def check(root, project, final=False, use_git=True):
    errs, warns = [], []
    f = project / 'look.json'
    if not f.exists():
        return [f'{f} missing'], []
    lk = json.loads(f.read_text())
    covers = lk.get('covers') or []
    if len(covers) < 2:
        errs.append('look.json "covers": need 2 variants (A/B) every episode: '
                    '[{"id": "a", "lines": [..]}, {"id": "b", "lines": [..]}]')
    texts = {}
    for c in covers:
        vid, lines = c.get('id', '?'), [l for l in c.get('lines') or [] if l.strip()]
        if not lines:
            errs.append(f'cover {vid}: no text lines')
            continue
        if len(lines) > 2:
            errs.append(f'cover {vid}: {len(lines)} lines (max 2: the user found 3 long lines "ล้นๆ")')
        r = repeated(lines)
        if r:
            errs.append(f'cover {vid}: {r!r} appears twice in {" / ".join(lines)!r}: drop one')
        texts[vid] = ' '.join(lines)
    ids = list(texts)
    for i, a in enumerate(ids):
        for b in ids[i + 1:]:
            if look.similarity(texts[a], texts[b]) >= 0.8:
                errs.append(f'covers {a} and {b} say the same thing: an A/B test needs 2 different lines')
    for pid, old in earlier_texts(root, project, use_git):
        for vid, t in texts.items():
            sim = look.similarity(t, old)
            if sim >= look.SIMILAR:
                errs.append(f'cover {vid} {t!r} too close to {pid} {old!r} (similarity {sim:.2f})')
    cdir = project / 'covers'
    mine = []
    for vid in ids:
        img, lay = cdir / f'cover-{vid}.jpg', cdir / f'cover-{vid}.json'
        if not img.exists() or not lay.exists():
            (errs if final else warns).append(
                f'cover {vid}: {img.name}/{lay.name} missing: node tools/cover_shot.js <video/cover.html> {cdir} {",".join(ids)}')
            continue
        geo = json.loads(lay.read_text())
        shown = [i['text'] for i in geo.get('items', []) if i['kind'] == 'text']
        want = next((c.get('lines') or [] for c in covers if c.get('id') == vid), [])
        if [_plain(t) for t in shown] != [_plain(t) for t in want]:
            errs.append(f'cover {vid}: the image says {" / ".join(shown)!r} but look.json covers says '
                        f'{" / ".join(want)!r}: re-run node tools/cover_shot.js (it takes the text from look.json)')
        errs += layout_errors(geo, vid)
        sm, e2 = small_and_contrast(img, geo, vid, cdir / f'cover-{vid}-{SMALL}.png')
        errs += e2
        mine.append((vid, sm))
    if mine:
        m = look.ID_RE.match(project.name)
        olds = old_covers(root, m.group(2), project.name, use_git)
        if not olds:
            warns.append('no earlier cover images found (projects/*/covers/ here or on claude/ep-* branches): '
                         'compare by eye with the channel page')
        compare_sheet(mine, olds, cdir / 'compare.png')
        print('look at:', cdir / 'compare.png', f'({len(olds)} earlier covers)')
    return errs, warns


def log_ctr(root, project, variant, ctr, impressions=None, note=''):
    m = look.ID_RE.match(project.name)
    f = root / 'channels' / m.group(2) / 'cover-ctr.md'
    if not f.exists():
        f.write_text('# CTR ปก A/B (tools/cover_check.py log)\nจดหลังลง ≥48 ชม. จาก YouTube Studio (Impressions click-through rate) '
                     'เทียบกับสถิติเดิมสูงสุด 11% (ผู้ใช้ 2026-11-26)\n\n'
                     '| วันที่จด | ตอน | ปก | ข้อความ | CTR % | impressions | หมายเหตุ |\n|---|---|---|---|---|---|---|\n')
    lk = json.loads((project / 'look.json').read_text()) if (project / 'look.json').exists() else {}
    text = next((' / '.join(c.get('lines', [])) for c in lk.get('covers') or [] if c.get('id') == variant), '')
    row = f'| {datetime.date.today()} | {project.name} | {variant} | {text} | {ctr} | {impressions or ""} | {note} |\n'
    with f.open('a') as fh:
        fh.write(row)
    print('logged in', f, row.strip())


def main(argv=None):
    argv = list(sys.argv[1:] if argv is None else argv)
    if argv and argv[0] == 'log':
        ap = argparse.ArgumentParser()
        ap.add_argument('project', type=pathlib.Path); ap.add_argument('--variant', required=True)
        ap.add_argument('--ctr', type=float, required=True); ap.add_argument('--impressions', type=int)
        ap.add_argument('--note', default='')
        a = ap.parse_args(argv[1:]); p = a.project.resolve()
        log_ctr(p.parents[1] if p.parent.name == 'projects' else ROOT, p, a.variant, a.ctr, a.impressions, a.note)
        return 0
    ap = argparse.ArgumentParser(description=__doc__.split('\n')[0])
    ap.add_argument('project', type=pathlib.Path); ap.add_argument('--final', action='store_true')
    ap.add_argument('--no-git', action='store_true')
    a = ap.parse_args(argv)
    p = a.project.resolve()
    root = p.parents[1] if p.parent.name == 'projects' else ROOT
    errs, warns = check(root, p, a.final, not a.no_git)
    for w in warns:
        print('WARN ', w)
    for e in errs:
        print('ERROR', e)
    print('cover: FAIL' if errs else 'cover: OK')
    return 1 if errs else 0


if __name__ == '__main__':
    sys.exit(main())
