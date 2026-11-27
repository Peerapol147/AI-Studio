#!/usr/bin/env bash
# Rebuilds video/assets/ plates from ../assets (sunrise-coral grade "warm golden morning" = hyperframes media-use preset
# warm-daylight, baked with one ffmpeg curves/eq/colorbalance chain for every plate).
# Video plates keep the source clock (start at source 0) so data-media-start = shots-th.json media_start.
# Stills (Pixabay <=1280 px) are never blown up full screen: <id>-bg.jpg = blurred backdrop, <id>.jpg = card on top.
# r1 (pixabay-1018062, cup on white): the white backdrop is flood-filled away from the corners -> r1.png cut-out that
# floats on a dark backdrop (blurred cafe picture, darkened) instead of a white card.
set -e
cd "$(dirname "$0")"; mkdir -p assets
cp ../assets/audio/vo-th.mp3 ../assets/audio/music-jamendo-fb1328d9.mp3 assets/
F=../assets/footage
GR="curves=r='0/0.02 0.5/0.54 1/1':g='0/0.01 0.5/0.5 1/0.97':b='0/0.01 0.5/0.45 1/0.9',eq=contrast=1.04:saturation=1.06,colorbalance=rm=0.03:bm=-0.03:rh=0.02:bh=-0.03"
ENC="-an -c:v libx264 -preset medium -crf 17 -pix_fmt yuv420p -r 30 -g 6"
vplate(){ # name src crop(w:h:x:y) seconds
  ffmpeg -v error -y -t "$4" -i "$F/$2" -vf "fps=30,crop=$3,scale=1080:1920:flags=lanczos,$GR,vignette=PI/6" $ENC "assets/$1.mp4"; }
vplate r4      pixabay-79908.mp4  1215:2160:1270:0 4.5
vplate r4num   pixabay-82601.mp4  810:1440:750:0   6
vplate r4punch pixabay-331066.mp4 608:1080:723:0   5
# r2 (pixabay-134 is only 1280x720: a 9:16 crop would be blown up 2.7x and soft) -> 16:9 card on its own blurred copy
ffmpeg -v error -y -t 5 -i "$F/pixabay-134.mp4" -filter_complex "[0:v]fps=30,split[a][b];[a]crop=405:720:437:0,scale=1080:1920,gblur=sigma=34,$GR,eq=brightness=-0.16:saturation=0.8,vignette=PI/4[bg];[b]crop=1040:720:120:0,scale=980:-2:flags=lanczos,$GR,pad=iw+16:ih+16:8:8:color=0x1A0A06[fg];[bg][fg]overlay=(W-w)/2:1000-h/2" $ENC assets/r2.mp4
BG="scale=1080:1920:force_original_aspect_ratio=increase,crop=1080:1920,gblur=sigma=38,$GR,eq=brightness=-0.16:saturation=0.8,vignette=PI/4"
still(){ # name src
  ffmpeg -v error -y -i "$F/$2" -vf "$GR" -q:v 2 "assets/$1.jpg"
  ffmpeg -v error -y -i "$F/$2" -vf "$BG" -q:v 3 "assets/$1-bg.jpg"; }
still hook   pixabay-3908006.jpg
still cafe   pixabay-2546041.jpg
still espm   pixabay-4334647.jpg
still pour   pixabay-3759005.jpg
still cta    pixabay-6600644.jpg
# r1 cut-out + dark backdrop (blurred cafe picture, darker)
ffmpeg -v error -y -i "$F/pixabay-1018062.jpg" -vf "$GR" -q:v 2 assets/r1-src.png
python3 - <<'EOF'
from PIL import Image, ImageDraw, ImageFilter
im = Image.open('assets/r1-src.png').convert('RGB')
w, h = im.size
key = im.copy()
for p in [(0, 0), (w - 1, 0), (0, h - 1), (w - 1, h - 1), (w // 2, 0), (w // 2, h - 1)]:
    ImageDraw.floodfill(key, p, (255, 0, 255), thresh=28)
mask = Image.new('L', (w, h), 255)
px, kp = mask.load(), key.load()
for y in range(h):
    for x in range(w):
        if kp[x, y] == (255, 0, 255):
            px[x, y] = 0
mask = mask.filter(ImageFilter.MinFilter(3)).filter(ImageFilter.GaussianBlur(1.6))
out = im.convert('RGBA'); out.putalpha(mask)
out = out.crop(out.getbbox())
# the photo cuts the cup at the bottom edge: fade the lowest 22 % so it dissolves into the backdrop instead of a hard cut
W, H = out.size; a = out.getchannel('A'); ap = a.load(); f0 = int(H * 0.78)
for y in range(f0, H):
    k = 1 - (y - f0) / (H - f0)
    for x in range(W):
        ap[x, y] = int(ap[x, y] * k * k)
out.putalpha(a)
out.save('assets/r1.png')
print('r1 cut-out', out.size)
EOF
rm -f assets/r1-src.png
ffmpeg -v error -y -i "$F/pixabay-2546041.jpg" -vf "$BG,eq=brightness=-0.12" -q:v 3 assets/r1-bg.jpg
ls -la assets
ffmpeg -v error -y -ss 1.8 -i $F/pixabay-79908.mp4 -frames:v 1 -vf "crop=2100:2160:830:0,scale=600:-1,$GR" -q:v 2 assets/cover-cola.jpg   # cover B
ffmpeg -v error -y -i assets/espm.jpg -vf crop=640:640:300:200 -q:v 2 assets/cover-esp.jpg   # cover B
ffmpeg -v error -y -i assets/cafe.jpg -vf crop=440:700:500:140 -q:v 2 assets/cover-ame.jpg   # cover B
# mix voice: the mono vo (-18.4 LUFS) becomes dual-mono stereo in sound_pass_vo.py, which reads +3 LU (-15.4) -> WARN.
# sound_pass_vo.py measures a stereo copy (+0.4 dB, as never-colonized) at -18.0 LUFS (same voice level as the mono file).
ffmpeg -v error -y -i ../assets/audio/vo-th.mp3 -af "volume=0.4dB" -ac 2 -ar 48000 assets/vo-th-mix.wav
