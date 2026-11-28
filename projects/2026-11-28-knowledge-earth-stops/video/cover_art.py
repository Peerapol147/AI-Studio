#!/usr/bin/env python3
"""Cover art (A/B) from the same NASA Blue Marble map as the clip's globe:
  covers-art/globe-a.png : whole globe (Asia facing) with atmosphere glow, transparent background, 1000x1000
  covers-art/globe-b.png : close crop of the globe centred on mainland Southeast Asia, 1080x1500 (placed at y 420 of the cover), + thai.json (x, y of
                           Thailand in that image for the hand-drawn ring)"""
import json, math, pathlib
import numpy as np
from PIL import Image

HERE = pathlib.Path(__file__).resolve().parent
PROJ = HERE.parent
OUT = HERE / 'covers-art'; OUT.mkdir(exist_ok=True)
DAY = np.asarray(Image.open(PROJ / 'assets/footage/tex/earth-blue-marble.jpg').convert('RGB'), np.float32)
TH, TW = DAY.shape[:2]


def bilinear(u, v):
    u = np.mod(u, TW); v = np.clip(v, 0, TH - 1.001)
    x0 = np.floor(u).astype(np.int32); y0 = np.floor(v).astype(np.int32)
    fx = (u - x0)[..., None]; fy = (v - y0)[..., None]; x1 = (x0 + 1) % TW; y1 = y0 + 1
    return (DAY[y0, x0] * (1 - fx) + DAY[y0, x1] * fx) * (1 - fy) + (DAY[y1, x0] * (1 - fx) + DAY[y1, x1] * fx) * fy


def render(w, h, cx, cy, R, lon_c, lat_c, L, glow=True):
    j, i = np.mgrid[0:h, 0:w].astype(np.float32)
    X = (i + 0.5 - cx) / R; Y = (cy - j - 0.5) / R; DD = X * X + Y * Y
    out = np.zeros((h, w, 4), np.float32)
    if glow:
        r = np.sqrt(DD); g = np.clip((1.16 - r) / 0.2, 0, 1) * (r >= 0.97) * 0.55
        out[..., :3] = np.array([120, 175, 255], np.float32); out[..., 3] = g * 255
    IN = DD < 1
    x, y = X[IN], Y[IN]; z = np.sqrt(1 - DD[IN]); p = math.radians(lat_c)
    WY = y * math.cos(p) + z * math.sin(p); WZ = -y * math.sin(p) + z * math.cos(p)
    lat = np.arcsin(np.clip(WY, -1, 1)); lon = np.arctan2(x, WZ) + math.radians(lon_c)
    col = bilinear((lon / (2 * math.pi) + 0.5) * TW, (0.5 - lat / math.pi) * TH)
    ndl = x * L[0] + y * L[1] + z * L[2]
    col = col * ((0.32 + 0.9 * np.maximum(ndl, 0)) * (0.82 + 0.18 * z))[:, None] * 1.08
    rim = ((1 - z) ** 2.2 * 0.7)[:, None]; col = col * (1 - rim) + np.array([140, 185, 255]) * rim
    e = np.clip((1 - np.sqrt(DD[IN])) * R * 1.5, 0, 1)
    a0 = out[IN, 3:4] / 255
    out[IN, :3] = np.clip(col, 0, 255) * e[:, None] + out[IN, :3] * (1 - e[:, None])
    out[IN, 3] = 255 * (e + a0[:, 0] * (1 - e))
    return Image.fromarray(out.astype(np.uint8), 'RGBA')


def project(cx, cy, R, lon_c, lat_c, la, lo):
    la, dl, p = math.radians(la), math.radians(lo - lon_c), math.radians(lat_c)
    X = math.cos(la) * math.sin(dl); Y = math.sin(la); Z = math.cos(la) * math.cos(dl)
    return cx + X * R, cy - (Y * math.cos(p) - Z * math.sin(p)) * R


L = [-0.45, 0.38, 0.81]; n = math.sqrt(sum(v * v for v in L)); L = [v / n for v in L]
# A: whole globe, 2x supersampled
im = render(2000, 2000, 1000, 1000, 840, 100, 12, L).resize((1000, 1000), Image.LANCZOS)
im.save(OUT / 'globe-a.png')
# B: close crop on mainland Southeast Asia (Thailand ~14N 100.5E), globe radius 1500 px
cx, cy, R, lo, la = 540 * 2, 1300 * 2, 1100 * 2, 101, -18
imb = render(2160, 3000, cx, cy, R, lo, la, L, glow=True).resize((1080, 1500), Image.LANCZOS)
imb.save(OUT / 'globe-b.png')
tx, ty = project(cx, cy, R, lo, la, 15.0, 101.0)
json.dump({'x': round(tx / 2, 1), 'y': round(ty / 2, 1)}, open(OUT / 'thai.json', 'w'))
print('thai', tx / 2, ty / 2)
