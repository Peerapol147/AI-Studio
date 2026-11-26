#!/usr/bin/env python3
"""Contact sheets of EVERY 0.25 s of a render, for the director and the reviewer (palmaris feedback 1, 2026-11-26).

The user: "Motion มันห่วยแตกลงขนาดนี้ เกิดอะไรขึ้น". The director had looked at 14 frames and sent it, and told the
reviewer not to judge the graphics. Rule now: before anything goes to the user, the director AND the reviewer look at
every sheet made here, and nobody may tell the reviewer to skip the visual side.

  python3 tools/contact_sheet.py make   <video.mp4> <out dir> [--step 0.25] [--cols 8] [--rows 5]
      -> <out>/sheet-01.jpg ... (40 frames = 10 s per sheet, timestamp under each frame, a red frame around frames that
         did not change for > 0.5 s), <out>/INDEX.md (sheets + still spans), <out>/frames.json
  python3 tools/contact_sheet.py verify <project> [<out dir>]
      exit 1 unless review.md has a "## ตรวจภาพทุกเฟรม" section that names every sheet file of <out dir>
      (default: the newest renders/frames-*/ of the project) with a note per sheet.
Needs ffmpeg and Pillow.
"""
import argparse, json, pathlib, re, subprocess, sys, tempfile

STILL = 0.5           # s without change that counts as a still frame (style.md Motion: no still frame > 0.5 s)
DIFF = 0.005          # share of pixels whose luma changed by > 8 (at 216 px wide) below which two frames are "the same"
                      # (measured: a slow 8 % push-in ~0.08, a small moving element ~0.025, a held frame 0.000)
TILE_W = 216
HEAD = '## ตรวจภาพทุกเฟรม'


def make(video, out, step=0.25, cols=8, rows=5):
    from PIL import Image, ImageDraw, ImageChops, ImageStat
    out.mkdir(parents=True, exist_ok=True)
    for old in out.glob('sheet-*.jpg'):
        old.unlink()
    with tempfile.TemporaryDirectory() as td:
        subprocess.run(['ffmpeg', '-v', 'error', '-y', '-i', str(video), '-vf', f'fps=1/{step},scale={TILE_W}:-2',
                        f'{td}/f%05d.png'], check=True)
        files = sorted(pathlib.Path(td).glob('f*.png'))
        if not files:
            raise SystemExit(f'no frames from {video}')
        frames = [Image.open(f).convert('RGB') for f in files]
    times = [round(i * step, 3) for i in range(len(frames))]
    small = [f.convert('L') for f in frames]
    diffs = [None] + [ImageStat.Stat(ImageChops.difference(small[i], small[i - 1]).point(lambda p: 255 if p > 8 else 0)).mean[0] / 255
                      for i in range(1, len(small))]
    still, spans, run0 = set(), [], None
    for i in range(1, len(frames) + 1):
        same = i < len(frames) and diffs[i] < DIFF
        if same and run0 is None:
            run0 = i - 1
        if not same and run0 is not None:
            if (i - 1 - run0) * step > STILL:
                spans.append((times[run0], times[i - 1]))
                still.update(range(run0, i))
            run0 = None
    th = frames[0].height
    per = cols * rows
    sheets = []
    for s in range(0, len(frames), per):
        chunk = list(range(s, min(s + per, len(frames))))
        r = (len(chunk) + cols - 1) // cols
        sheet = Image.new('RGB', (cols * (TILE_W + 6) + 6, r * (th + 26) + 6), (20, 20, 20))
        d = ImageDraw.Draw(sheet)
        for k, i in enumerate(chunk):
            x, y = 6 + (k % cols) * (TILE_W + 6), 6 + (k // cols) * (th + 26)
            sheet.paste(frames[i], (x, y))
            if i in still:
                d.rectangle([x - 3, y - 3, x + TILE_W + 2, y + th + 2], outline=(255, 40, 40), width=3)
            d.text((x + 2, y + th + 4), f'{times[i]:.2f}s' + (' STILL' if i in still else ''),
                   fill=(255, 90, 90) if i in still else (235, 235, 235))
        name = f'sheet-{len(sheets) + 1:02d}.jpg'
        sheet.save(out / name, quality=85)
        sheets.append({'file': name, 'from': times[chunk[0]], 'to': times[chunk[-1]]})
    (out / 'frames.json').write_text(json.dumps({'video': str(video), 'step': step, 'times': times,
                                                 'diff': diffs, 'still_spans': spans, 'sheets': sheets}, indent=1))
    lines = [f'# Contact sheets: {video} (every {step} s, {len(frames)} frames)', '',
             'ผู้กำกับและ reviewer ต้องเปิดดู**ทุกแผ่น**ก่อนส่งผู้ใช้ (feedback palmaris ข้อ 1) แล้วจดใน review.md หัวข้อ',
             f'`{HEAD}` ทีละแผ่น: `- sheet-01.jpg (0.00-9.75s): <สิ่งที่เห็น/ปัญหา หรือ "ผ่าน">`', '',
             '| แผ่น | ช่วงเวลา |', '|---|---|'] + [f'| {s["file"]} | {s["from"]:.2f}-{s["to"]:.2f}s |' for s in sheets]
    lines += ['', f'## ภาพนิ่งเกิน {STILL} วิ (กรอบแดงในแผ่น)'] + ([f'- {a:.2f}-{b:.2f}s' for a, b in spans] or ['- ไม่มี'])
    (out / 'INDEX.md').write_text('\n'.join(lines) + '\n')
    print('\n'.join(lines))
    return sheets, spans


def verify(project, out=None):
    if out is None:
        cands = sorted((project / 'renders').glob('frames-*/frames.json'), key=lambda f: f.stat().st_mtime)
        if not cands:
            print(f'ERROR no renders/frames-*/ in {project}: python3 tools/contact_sheet.py make <mp4> {project}/renders/frames-th')
            return 1
        out = cands[-1].parent
    sheets = [s['file'] for s in json.loads((out / 'frames.json').read_text())['sheets']]
    rv = project / 'review.md'
    text = rv.read_text() if rv.exists() else ''
    m = re.search(rf'^{re.escape(HEAD)}[^\n]*\n(.*?)(?=^## |\Z)', text, re.M | re.S)
    errs = []
    if not m:
        errs.append(f'review.md has no "{HEAD}" section (reviewer must look at every sheet in {out})')
    else:
        body = m.group(1)
        for s in sheets:
            line = next((l for l in body.splitlines() if s in l), None)
            if not line:
                errs.append(f'{s} not reviewed (no line naming it under "{HEAD}")')
            elif not re.sub(rf'.*{re.escape(s)}[^:：]*[:：]?', '', line).strip():
                errs.append(f'{s}: no note (write what was seen, or "ผ่าน")')
    for e in errs:
        print('ERROR', e)
    print('frames: FAIL' if errs else f'frames: OK ({len(sheets)} sheets reviewed)')
    return 1 if errs else 0


def main(argv=None):
    ap = argparse.ArgumentParser(description=__doc__.split('\n')[0])
    sub = ap.add_subparsers(dest='cmd', required=True)
    m = sub.add_parser('make'); m.add_argument('video', type=pathlib.Path); m.add_argument('out', type=pathlib.Path)
    m.add_argument('--step', type=float, default=0.25); m.add_argument('--cols', type=int, default=8)
    m.add_argument('--rows', type=int, default=5)
    v = sub.add_parser('verify'); v.add_argument('project', type=pathlib.Path); v.add_argument('out', type=pathlib.Path, nargs='?')
    a = ap.parse_args(argv)
    if a.cmd == 'make':
        make(a.video, a.out, a.step, a.cols, a.rows)
        return 0
    return verify(a.project, a.out)


if __name__ == '__main__':
    sys.exit(main())
