#!/usr/bin/env python3
"""Rebuilds video/assets/ (gitignored) from ../assets for the v2 redo: VO (take 1, George) + music copied, every
footage plate baked at 1080x1920 30 fps with ONE grade (palette night-violet, grade "cool blue purple night":
cool shadows, a touch of violet in the highlights, more contrast + saturation so it reads crisp, faces not crushed).
Video plates keep the SOURCE clock (plate t = source t) so data-media-start = shots-th.json media_start.
16:9 sources are cropped to 9:16 around the face / hands / ice cream; when the face sits at the very top of the
source (345611, 44637, 49808) the picture is lowered (shift) over a blurred copy of itself so the face lands at
Y 500-1300. Stills (hook, culprit, rush2) = picture card on a blurred copy of the same picture (never blown up).
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

GRADE = ('colorbalance=rs=-0.04:gs=-0.02:bs=0.07:rm=0.00:gm=-0.02:bm=0.04:rh=0.02:gh=-0.01:bh=0.03,'
         'eq=contrast=1.12:saturation=1.28:brightness=0.015:gamma=1.04,unsharp=5:5:0.55')
ENC = ['-an', '-c:v', 'libx264', '-preset', 'medium', '-crf', '17', '-pix_fmt', 'yuv420p', '-r', '30', '-g', '6']


def run(*a):
    subprocess.run(['ffmpeg', '-v', 'error', '-y', *a], check=True)


for a in ('vo-th.mp3', LOOK['music_file']):
    shutil.copy(PROJ / 'assets' / 'audio' / a, OUT / a)


def video(name, src, t, crop, shift=0):
    """crop = 'w:h:x:y' (x may be an expression of source t); shift = px the picture is lowered (blurred fill on top)"""
    if shift:
        g = (f'[0:v]fps=30,crop={crop},scale=1080:1920:flags=lanczos,{GRADE},split[a][b];'
             f'[a]scale=270:480,boxblur=18:2,scale=1080:1920,eq=brightness=-0.10:saturation=1.1[bg];'
             f"[b]crop=1080:{1920 - shift}:0:0,format=rgba,geq=r='r(X,Y)':g='g(X,Y)':b='b(X,Y)':a='255*clip(Y/170,0,1)'[fg];"
             f'[bg][fg]overlay=0:{shift},format=yuv420p[o]')
    else:
        g = f'[0:v]fps=30,crop={crop},scale=1080:1920:flags=lanczos,{GRADE},format=yuv420p[o]'
    run('-t', str(t), '-i', str(F / src), '-filter_complex', g, '-map', '[o]', *ENC, str(OUT / f'{name}-v.mp4'))
    print(name, src, crop, 'shift', shift)


# t = media_start + shot length + 0.4 (transition overlap); x chosen from contact sheets (face / hands / ice cream centred)
video('why', 'pixabay-307248.mp4', 3.0, '810:1440:875:0')                # vanilla scoops + chocolate pour (centre)
video('belief', 'pixabay-149479.mp4', 4.7, "608:1080:'min(520,300+(t-3.0)*150)':0")   # woman licks the bar; crop drifts right with her
video('forehead', 'pixabay-345611.mp4', 7.4, '1215:2160:1762:0', 360)    # hands over face; forehead ~Y 620
video('rush1', 'pixabay-334213.mp4', 6.3, "810:1440:'min(1460,max(790,790+(t-3.0)*520))':0")  # boy spoons it in, crop pans right with him
video('warm', 'pixabay-204420.mp4', 4.0, '1215:2160:770:0')              # man laughing (relief)
video('doctor', 'pixabay-49808.mp4', 3.8, "608:1080:'min(1010,700+(t-0.5)*110)':0", 200)   # doctor + stethoscope, pans right with her


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


# hook (= frame 0 + loop): card BELOW the title (title ends ~Y 700) so the face is never covered
card('hook', 'pixabay-481425.jpg', (190, 110, 1090, 960), 720, width=860)
# culprit: the cone at the mouth (tongue on the ice cream) = where the cold hits
card('culprit', 'pixabay-2588541.jpg', (470, 0, 1280, 852), 360)
print('ok', sorted(p.name for p in OUT.iterdir()))
