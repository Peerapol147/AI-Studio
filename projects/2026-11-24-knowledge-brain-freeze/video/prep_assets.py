#!/usr/bin/env python3
"""Rebuilds video/assets/ (gitignored) from ../assets: VO + music copied, every footage plate baked at 1080x1920 30 fps
with ONE grade for the whole clip (palette sunrise-coral grade "warm golden morning").
`hyperframes media-use resolve --type grade --intent "warm golden morning"` resolves to the built-in preset
`warm-daylight` (a runtime data-color-grading payload, no .cube LUT in 0.9.61), so the same look is baked here with one
ffmpeg chain (GRADE) used on every plate; only crop differs.
Video plates keep the SOURCE clock (plate t = source t) so data-media-start = shots-th.json media_start.
Stills (hook, gulp) = picture card on a blurred copy of the same picture (source <= 1280 px: never blown up full screen).
Card outline colour = look.json palette ink (read from templates/looks/looks.json).
  python3 prep_assets.py
"""
import json, pathlib, shutil, subprocess, tempfile
from PIL import Image, ImageDraw, ImageFilter, ImageEnhance

HERE = pathlib.Path(__file__).resolve().parent
PROJ = HERE.parent
ROOT = PROJ.parents[1]
F = PROJ / 'assets' / 'footage'
OUT = HERE / 'assets'
OUT.mkdir(exist_ok=True)
LOOK = json.loads((PROJ / 'look.json').read_text())
PAL = json.loads((ROOT / 'templates' / 'looks' / 'looks.json').read_text())['palette'][LOOK['palette']]
INK = tuple(int(PAL['ink'][i:i + 2], 16) for i in (1, 3, 5))

GRADE = ('colorbalance=rs=0.05:gs=0.01:bs=-0.06:rm=0.03:bm=-0.04:rh=0.02:bh=-0.03,'
         'eq=contrast=1.05:saturation=1.08:brightness=0.01:gamma=1.02')
ENC = ['-an', '-c:v', 'libx264', '-preset', 'medium', '-crf', '17', '-pix_fmt', 'yuv420p', '-r', '30', '-g', '6']


def run(*a):
    subprocess.run(['ffmpeg', '-v', 'error', '-y', *a], check=True)


for a in ('vo-th.mp3', LOOK['music_file']):
    shutil.copy(PROJ / 'assets' / 'audio' / a, OUT / a)


def video(name, src, t, crop):
    run('-t', str(t), '-i', str(F / src), '-filter_complex',
        f'[0:v]fps=30,crop={crop},scale=1080:1920:flags=lanczos,{GRADE},format=yuv420p[o]', '-map', '[o]', *ENC,
        str(OUT / f'{name}-v.mp4'))


# eatfast: media_start 2.92, shot 1.10 s (+0.12 overlap); the boy walks right across the frame -> crop pans with him
video('eatfast', 'pixabay-334213.mp4', 4.5, "810:1440:'min(1300,max(640,650+(t-2.92)*620))':0")
# ouch: media_start 3.42, hands on face 3.4-4.5 s, face centred at x ~1280
video('ouch', 'pixabay-44637.mp4', 4.8, '810:1440:875:0')


def card(name, src, box, top, width=960, blur_dark=0.55):
    """picture card (crop box of src scaled to width) on a blurred, darkened full-screen copy of the same picture"""
    with tempfile.TemporaryDirectory() as d:
        g = pathlib.Path(d) / 'g.png'
        run('-i', str(F / src), '-vf', f'{GRADE},format=rgb24', '-frames:v', '1', str(g))
        im = Image.open(g).convert('RGB')
    W, H = im.size
    s = 1920 / H
    bg = im.resize((round(W * s), 1920), Image.LANCZOS)
    x0 = (bg.width - 1080) // 2
    bg = bg.crop((x0, 0, x0 + 1080, 1920)).filter(ImageFilter.GaussianBlur(38))
    bg = ImageEnhance.Brightness(bg).enhance(blur_dark)
    c = im.crop(box)
    h = round(c.height * width / c.width)
    c = c.resize((width, h), Image.LANCZOS)
    left = (1080 - width) // 2
    r, edge = 44, 10
    sh = Image.new('L', (1080, 1920), 0)
    ImageDraw.Draw(sh).rounded_rectangle((left - edge, top - edge + 24, left + width + edge, top + h + edge + 24), r + edge, fill=150)
    bg.paste(Image.new('RGB', (1080, 1920), (0, 0, 0)), (0, 0), sh.filter(ImageFilter.GaussianBlur(30)))
    ImageDraw.Draw(bg).rounded_rectangle((left - edge, top - edge, left + width + edge, top + h + edge), r + edge, fill=INK)
    m = Image.new('L', (width, h), 0)
    ImageDraw.Draw(m).rounded_rectangle((0, 0, width - 1, h - 1), r, fill=255)
    bg.paste(c, (left, top), m)
    bg.save(OUT / f'{name}.jpg', quality=93)
    print(name, 'card', box, '->', width, 'x', h, 'at Y', top, '-', top + h)


# hook: face + spoon. crop x 190-1090, y 40-960 -> 960x981 card at Y 560: eyes ~Y 760, mouth + spoon ~Y 1020-1150
card('hook', 'pixabay-481425.jpg', (190, 40, 1090, 960), 560)
# gulp: cone at the mouth (right half of the picture)
card('gulp', 'pixabay-2588541.jpg', (470, 0, 1280, 852), 330)
print('ok', sorted(p.name for p in OUT.iterdir()))
