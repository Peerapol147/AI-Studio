#!/usr/bin/env python3
"""Rebuilds video/assets/ (gitignored) from ../assets.
- copies the voice; music: trims the leading silence (file is silent until ~0.86 s) and bakes the soft
  section (bed -9 dB from 46.3 s = "retire" to the end, 1 s ramp) so the sound pass keeps one bed.
- player stills (CC BY / BY-SA, see assets/CREDITS.md): every crop is cut so no club/league/FIFA/UEFA crest or
  kit-brand logo is in frame; whatever sits near the crop edge is blurred out BEFORE cropping (boxes below, as
  fractions of the source). Also writes a heavy-blur backdrop of each crop (card on its own blurred plate) and a
  black-and-white copy of the pair photo for the "retire" beat. Grade = one mild contrast/saturation trim for all.
"""
import pathlib, shutil, subprocess
from PIL import Image, ImageFilter, ImageEnhance, ImageOps

HERE = pathlib.Path(__file__).resolve().parent
SRC = HERE.parent / 'assets'
OUT = HERE / 'assets'; IMG = OUT / 'img'
IMG.mkdir(parents=True, exist_ok=True)
F = SRC / 'footage'

shutil.copy(SRC / 'audio' / 'vo-th.mp3', OUT / 'vo-th.mp3')
subprocess.run(['ffmpeg', '-v', 'error', '-y', '-ss', '0.86', '-i', str(SRC / 'audio' / 'music-jamendo-a9fd2e6b.mp3'), '-t', '60',
                '-af', "volume='1-0.645*min(max((t-46.3)/1.0,0),1)':eval=frame", '-c:a', 'libmp3lame', '-q:a', '2',
                str(OUT / 'music-bed.mp3')], check=True)

# name: (source, crop box (x0,y0,x1,y1) fractions, [logo boxes to blur, fractions of source])
PLATES = {
    # Messi, Argentina WC 2022: face/shoulders only (collar), logos start at y~0.37
    'messi_face': ('messi_argentina_wc2022.jpg', (0.27, 0.0, 0.81, 0.36), [(0.15, 0.36, 0.92, 0.56)]),
    # Messi half body: adidas, AFA crest, QATAR text, FIFA sleeve patch, captain band all blurred
    'messi_half': ('messi_argentina_wc2022.jpg', (0.06, 0.0, 0.94, 0.70),
                   [(0.35, 0.385, 0.47, 0.475), (0.46, 0.385, 0.59, 0.455), (0.57, 0.36, 0.71, 0.49),
                    (0.16, 0.38, 0.29, 0.52), (0.78, 0.37, 0.89, 0.47), (0.72, 0.42, 0.89, 0.55)]),
    # Messi from the 2011 pair photo (2nd Messi face). adidas at y~0.61 -> crop stops at 0.53
    'messi_face2': ('pair_ronaldo_messi_2011.jpg', (0.55, 0.17, 0.97, 0.53), [(0.66, 0.57, 0.80, 0.67), (0.47, 0.47, 0.62, 0.62)]),
    # Ronaldo, Portugal 2026: face only, crest/Puma from y~0.58
    'ronaldo_face': ('ronaldo_portugal_2026.jpg', (0.14, 0.0, 0.86, 0.50), [(0.40, 0.56, 0.60, 0.85)]),
    # Ronaldo, Portugal fist WC 2022 (720 px: small card only). FIFA patch at y~0.55+
    'ronaldo_fist': ('ronaldo_portugal_wc2022_fist.jpg', (0.18, 0.02, 1.0, 0.50), [(0.30, 0.49, 0.50, 0.66)]),
    # Ronaldo, Euro 2016 run: upper body; crest, swoosh, UEFA armband, another player's boots blurred
    'ronaldo_run': ('ronaldo_portugal_euro2016.jpg', (0.10, 0.0, 0.74, 0.50),
                    [(0.31, 0.22, 0.43, 0.32), (0.22, 0.22, 0.33, 0.30), (0.45, 0.28, 0.60, 0.38),
                     (0.55, 0.0, 0.74, 0.07), (0.15, 0.13, 0.30, 0.21)]),
    # pair 2011 (Ronaldo left, Messi right): stop above the watch boxes; Nike + Portugal crest blurred
    'pair': ('pair_ronaldo_messi_2011.jpg', (0.02, 0.0, 1.0, 0.55),
             [(0.47, 0.47, 0.62, 0.62), (0.14, 0.50, 0.31, 0.60), (0.66, 0.57, 0.80, 0.67)]),
}

def blur_boxes(im, boxes):
    """Soft-edged blur patches (feathered mask) so the covered logo reads as fabric, not a block."""
    W, H = im.size
    soft = im.filter(ImageFilter.GaussianBlur(max(W, H) / 90))
    mask = Image.new('L', im.size, 0)
    from PIL import ImageDraw
    d = ImageDraw.Draw(mask)
    for x0, y0, x1, y1 in boxes:
        d.rounded_rectangle((int(x0 * W), int(y0 * H), int(x1 * W), int(y1 * H)), radius=int(0.02 * W), fill=255)
    mask = mask.filter(ImageFilter.GaussianBlur(max(W, H) / 160))
    return Image.composite(soft, im, mask)

for name, (src, crop, boxes) in PLATES.items():
    im = Image.open(F / src).convert('RGB')
    im = blur_boxes(im, boxes)
    W, H = im.size
    im = im.crop((int(crop[0] * W), int(crop[1] * H), int(crop[2] * W), int(crop[3] * H)))
    im = ImageEnhance.Contrast(im).enhance(1.06); im = ImageEnhance.Color(im).enhance(1.05)
    im.save(IMG / f'{name}.jpg', quality=92)
    bg = im.resize((max(1, im.width // 6), max(1, im.height // 6)), Image.BILINEAR).filter(ImageFilter.GaussianBlur(10))
    bg = ImageEnhance.Brightness(bg.resize((540, int(540 * im.height / im.width)), Image.BILINEAR)).enhance(0.8)
    bg.save(IMG / f'{name}_bg.jpg', quality=85)
    print(name, im.size)
    if name == 'pair':
        ImageEnhance.Contrast(ImageOps.grayscale(im)).enhance(1.1).convert('RGB').save(IMG / 'pair_bw.jpg', quality=92)
        ImageOps.grayscale(bg).convert('RGB').save(IMG / 'pair_bw_bg.jpg', quality=85)

th = HERE / 'thumb' / 'assets'; th.mkdir(parents=True, exist_ok=True)
for n in ('messi_face', 'ronaldo_face', 'messi_face_bg', 'ronaldo_face_bg'):
    shutil.copy(IMG / f'{n}.jpg', th / f'{n}.jpg')
