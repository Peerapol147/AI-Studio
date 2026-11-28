#!/usr/bin/env python3
"""Bake the episode globe plate: assets/globe-v.mp4 (1080x1920, 30 fps, the whole clip, clock = composition time).

The globe = NASA Blue Marble (day) + Black Marble (night lights) equirectangular maps (assets/footage/tex/, 4096x2048)
mapped per pixel onto a sphere (orthographic, camera 12 deg above the equator). Its per-frame state (position, radius,
longitude, light, night mix, sun/orbit) comes from ep/state.js via node (ep/dump_state.cjs), the same code the page
uses for the overlays (Thailand marker, rings, speed lines). Background = the graphic-slot field of the look
(radial bg2 -> bg + stars + vignette). Colours from look.json palette.
  python3 bake_globe.py            (after ./make.sh, needs index.html)
"""
import json, math, pathlib, subprocess, sys
import numpy as np
from PIL import Image, ImageDraw

HERE = pathlib.Path(__file__).resolve().parent
PROJ = HERE.parent
W, H, FPS = 1080, 1920, 30
look = json.loads((PROJ / 'look.json').read_text())
root = next(d for d in [HERE, *HERE.parents] if (d / 'templates/looks/looks.json').exists())
PAL = json.loads((root / 'templates/looks/looks.json').read_text())['palette'][look['palette']]
hexc = lambda h: np.array([int(h[i:i + 2], 16) for i in (1, 3, 5)], np.float32)
BG, BG2, ACC, TXT = hexc(PAL['bg']), hexc(PAL['bg2']), hexc(PAL['accent']), hexc(PAL['text'])

states = json.loads(subprocess.run(['node', str(HERE / 'ep/dump_state.cjs'), str(HERE / 'index.html')],
                                   check=True, capture_output=True, text=True).stdout)

# ---- background (same as .gslot: radial bg2 -> bg at 72 %, stars, vignette of .vig)
yy, xx = np.mgrid[0:H, 0:W].astype(np.float32)
d = np.sqrt(((xx - 540) / (540 * 1.414)) ** 2 + ((yy - 0.42 * H) / (0.58 * H * 1.414)) ** 2)
k = np.clip(d / 0.72, 0, 1)[..., None]
bg = BG2 * (1 - k) + BG * k
stars = np.asarray(Image.open(HERE / 'assets/stars.png').convert('RGBA'), np.float32)
a = stars[..., 3:4] / 255
bg = bg * (1 - a) + stars[..., :3] * a
dv = np.sqrt(((xx - 540) / 540) ** 2 + ((yy - 0.45 * H) / (0.45 * H)) ** 2) / 1.414   # ellipse at 50% 45%
vig = np.clip((dv - 0.55) / 0.45, 0, 1) * 0.45
bg = bg * (1 - vig[..., None])
BGI = bg.astype(np.float32)

# ---- textures
def load(p):
    return np.asarray(Image.open(p).convert('RGB'), np.float32)
DAY = load(PROJ / 'assets/footage/tex/earth-blue-marble.jpg')
NIGHT = load(PROJ / 'assets/footage/tex/earth-night.jpg')
TH, TW = DAY.shape[:2]

# ---- sphere tables at a fixed radius RI (2x supersampled, then resized to the frame radius)
RI = 800
SZ = RI * 2 + 4
PHI = math.radians(12)
j, i = np.mgrid[0:SZ, 0:SZ].astype(np.float32)
X = (i + 0.5 - SZ / 2) / RI
Y = (SZ / 2 - j - 0.5) / RI
DD = X * X + Y * Y
IN = DD < 1
X, Y = X[IN], Y[IN]
Z = np.sqrt(1 - DD[IN])
WY = Y * math.cos(PHI) + Z * math.sin(PHI)
WZ = -Y * math.sin(PHI) + Z * math.cos(PHI)
LAT = np.arcsin(np.clip(WY, -1, 1))
LON0 = np.arctan2(X, WZ) / (2 * math.pi)
V = (0.5 - LAT / math.pi) * TH
EDGE = np.clip((1 - np.sqrt(DD[IN])) * RI * 1.5, 0, 1)


def bilinear(T, u, v):
    u = np.mod(u, TW)
    v = np.clip(v, 0, TH - 1.001)
    x0 = np.floor(u).astype(np.int32); y0 = np.floor(v).astype(np.int32)
    fx = (u - x0)[:, None]; fy = (v - y0)[:, None]
    x1 = (x0 + 1) % TW; y1 = y0 + 1
    return (T[y0, x0] * (1 - fx) + T[y0, x1] * fx) * (1 - fy) + (T[y1, x0] * (1 - fx) + T[y1, x1] * fx) * fy


def sphere(s):
    L = np.array(s['L'], np.float32)
    u = (LON0 + s['lon'] / 360 + 0.5) * TW
    day = bilinear(DAY, u, V)
    ndl = X * L[0] + Y * L[1] + Z * L[2]
    soft = max(0.005, s['soft'])
    lit = np.clip((ndl + soft) / (2 * soft), 0, 1); lit = lit * lit * (3 - 2 * lit)
    shade = (0.28 + 0.92 * np.maximum(ndl, 0)) * (1 - s['flat']) + 1.05 * s['flat']
    shade = shade * (0.8 + 0.2 * Z)
    col = day * (lit * shade + (1 - lit) * 0.05)[:, None]
    if s['night'] > 0:
        nk = ((1 - lit) * s['night'] * 1.5)[:, None]
        col += bilinear(NIGHT, u, V) * nk * np.array([1, 0.92, 0.7], np.float32)
    rim = ((1 - Z) ** 2.2 * 0.75 * lit)[:, None]
    col = col * (1 - rim) + np.array([140, 185, 255], np.float32) * rim
    out = np.zeros((SZ, SZ, 4), np.float32)
    out[IN, :3] = np.clip(col, 0, 255)
    out[IN, 3] = EDGE * 255
    return Image.fromarray(out.astype(np.uint8), 'RGBA')


def radial(img, cx, cy, r0, r1, rgb, stops):
    """additive-ish soft glow: alpha over [r0, r1] following stops [(pos, alpha)]"""
    x0, y0, x1, y1 = int(max(0, cx - r1)), int(max(0, cy - r1)), int(min(W, cx + r1 + 1)), int(min(H, cy + r1 + 1))
    if x1 <= x0 or y1 <= y0:
        return
    gy, gx = np.mgrid[y0:y1, x0:x1].astype(np.float32)
    rr = np.sqrt((gx - cx) ** 2 + (gy - cy) ** 2)
    p = np.clip((rr - r0) / max(1e-3, r1 - r0), 0, 1)
    al = np.interp(p, [q for q, _ in stops], [q for _, q in stops]).astype(np.float32)[..., None]
    img[y0:y1, x0:x1] = img[y0:y1, x0:x1] * (1 - al) + rgb * al


def sun(img, t, so):
    radial(img, 540, 780, 20, 260, ACC, [(0, 0.85 * so), (0.35, 0.3 * so), (1, 0)])
    rr = 78 + 3 * math.sin(t * 5)
    radial(img, 540, 780, rr - 1.5, rr + 1.5, np.array([255, 246, 208], np.float32), [(0, so), (1, 0)])
    radial(img, 540, 780, 0, rr - 1.4, np.array([255, 246, 208], np.float32), [(0, so), (1, so)])


def orbit_path(img, so):
    lay = Image.new('L', (W, H), 0)
    dr = ImageDraw.Draw(lay)
    n = 220
    pts = [(540 + 330 * math.cos(2 * math.pi * q / n), 780 + 150 * math.sin(2 * math.pi * q / n)) for q in range(n + 1)]
    for q in range(0, n, 2):
        dr.line([pts[q], pts[q + 1]], fill=255, width=4)
    al = np.asarray(lay, np.float32)[..., None] / 255 * 0.6 * so
    img[:] = img * (1 - al) + TXT * al


out = HERE / 'assets/globe-v.mp4'
ff = subprocess.Popen(['ffmpeg', '-v', 'error', '-y', '-f', 'rawvideo', '-pix_fmt', 'rgb24', '-s', f'{W}x{H}', '-r', str(FPS),
                       '-i', '-', '-c:v', 'libx264', '-preset', 'medium', '-crf', '15', '-pix_fmt', 'yuv420p', '-g', '15',
                       str(out)], stdin=subprocess.PIPE)
cache = {}
for n, s in enumerate(states):
    img = BGI.copy()
    if s['id']:
        t = s['t']; sn = s['sun']
        if sn['left'] > 0:
            radial(img, -160, 840, 40, 820, ACC, [(0, sn['left']), (1, 0)])
        if sn['so'] > 0:
            orbit_path(img, sn['so'])
            if not sn['behind']:
                sun(img, t, sn['so'])
        R = s['r']
        gk = 0.32 if s['night'] > 0.9 and s['flat'] < 0.5 else 0.5
        radial(img, s['x'], s['y'], R * 0.96, R * 1.16, np.array([120, 175, 255], np.float32), [(0, gk), (1, 0)])
        key = (round(s['lon'], 4), tuple(round(v, 4) for v in s['L']), round(s['soft'], 4), round(s['flat'], 4), round(s['night'], 4))
        sp = cache.get(key)
        if sp is None:
            cache.clear(); sp = sphere(s); cache[key] = sp
        size = max(2, int(round(SZ * R / RI)))
        im = sp.resize((size, size), Image.LANCZOS)
        ox, oy = s['x'] - size / 2, s['y'] - size / 2
        base = Image.fromarray(np.clip(img, 0, 255).astype(np.uint8), 'RGB').convert('RGBA')
        # sub-pixel placement: shift by the fractional part with an affine transform
        fx, fy = ox - math.floor(ox), oy - math.floor(oy)
        if fx or fy:
            im = im.transform((size + 1, size + 1), Image.AFFINE, (1, 0, -fx, 0, 1, -fy), resample=Image.BILINEAR)
        base.alpha_composite(im, (int(math.floor(ox)), int(math.floor(oy)))) if ox > -size and oy > -size else None
        img = np.asarray(base.convert('RGB'), np.float32)
        if sn['so'] > 0 and sn['behind']:
            sun(img, t, sn['so'])
    ff.stdin.write(np.clip(img, 0, 255).astype(np.uint8).tobytes())
    if n % 100 == 0:
        print('frame', n, '/', len(states), file=sys.stderr)
ff.stdin.close(); ff.wait()
print('wrote', out, len(states), 'frames')
