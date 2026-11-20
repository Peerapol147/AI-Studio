#!/usr/bin/env bash
# Rebuilds video/assets/ (gitignored) from ../assets: copies VO/music and bakes every footage plate at the exact
# pixel size it is shown at (no upscaling in the browser). Three grades, same chain for every plate of a kind:
#   NEU  = full-frame / card shots (bright, slightly warm)       WARM = left split panel "ยุคนี้" (sepia-warm)
#   NEON = right split panel "Gen Z" (purple-magenta, green highs)
# 720p sources (172681, 16453, 179212, 2284, 28043, 73613) are only used as cards (≤1.3x) or half panels (downscaled).
# Video plates keep the source clock (start at source 0) so data-media-start in index.html = shots-th.json media_start.
set -e
cd "$(dirname "$0")"; mkdir -p assets
cp ../assets/audio/{vo-th.mp3,music-jamendo-b69493a8.mp3} assets/
F=../assets/footage
ENC="-an -c:v libx264 -preset medium -crf 16 -pix_fmt yuv420p -r 30 -g 6"
NEU="eq=contrast=1.05:saturation=1.08:brightness=0.01,colorbalance=rm=0.03:bm=-0.03"
WARM="eq=contrast=1.04:saturation=0.62:brightness=0.02,colorbalance=rs=0.10:gs=0.03:bs=-0.12:rm=0.10:gm=0.02:bm=-0.12:rh=0.05:bh=-0.08,vignette=PI/5"
NEON="eq=contrast=1.10:saturation=1.15:brightness=-0.03,colorbalance=rs=0.06:gs=-0.06:bs=0.16:rm=0.07:gm=-0.07:bm=0.12:rh=-0.04:gh=0.07:bh=0.03,vignette=PI/5"
vplate(){ # name src t0 dur crop WxH grade [pre]
  ffmpeg -v error -y -ss "$3" -t "$4" -i "$F/$2" -vf "fps=30,${8:+$8,}crop=$5,scale=$6:flags=lanczos,$7" $ENC "assets/$1.mp4"; }
still(){ # name src crop WxH grade  -> jpg
  ffmpeg -v error -y -i "$F/$2" -vf "crop=$3,scale=$4:flags=lanczos,$5" -q:v 2 "assets/$1.jpg"; }
blurbg(){ # name src [ss] -> small blurred, darkened backdrop (shown 1080x1920 behind a card)
  ffmpeg -v error -y ${3:+-ss $3} -i "$F/$2" -frames:v 1 -vf "scale=-2:480,crop=270:480,gblur=sigma=14,eq=brightness=-0.12:saturation=0.9" -q:v 3 "assets/$1-bg.jpg"; }

# --- cards 700x930 (720p video: crop 542x720 -> 1.29x) ---
vplate hook   pixabay-172681.mp4 0 11.5 542:720:569:0 700:930 "$NEU"      # grandma (blue shirt); s01 ms 5.0, loop ms 4.17
vplate baby   pixabay-73613.mp4  0 4.0  542:720:369:0 700:930 "$NEU"      # baby feet, ms 2.3 (both feet sharp)
# 2284: only 0-1.25 s (abstract waves on the TV behind; later a person is on screen) -> slowed 1.7x to cover 2.04 s
vplate phones pixabay-2284.mp4   0 1.25 542:720:80:0  700:930 "$NEU" "setpts=PTS*1.7"
still  grin   pixabay-2739143.jpg 853:1134:0:60     700:930 "$NEU"         # s02 grandma laughing (b/w)
vplate tikgr  pixabay-172681.mp4 0 4.0  420:560:560:0 540:720 "$NEU"     # s03 grandma (tighter crop than s01) in the phone frame, ms 1.0
still  couple pixabay-1546130.jpg 1280:960:0:0     860:645 "$NEU"         # s28
# --- full frame 1080x1920 (1440p sources, ≤1.33x) ---
vplate selfie pixabay-241224.mp4 0 3.0  810:1440:1095:0 1080:1920 "$NEU"  # s04 friends selfie
vplate buds   pixabay-84583.mp4  0 8.0  810:1440:1131:0 1080:1920 "eq=contrast=1.08:saturation=0.8:brightness=-0.10,colorbalance=bs=0.10:bm=0.06,vignette=PI/4"
vplate buds2  pixabay-84583.mp4  0 8.0  675:1200:1199:120 1080:1920 "eq=contrast=1.08:saturation=0.8:brightness=-0.12,colorbalance=bs=0.10:bm=0.06,vignette=PI/4"
# brand name printed on the cordless phone in 3188291 -> blurred out before any use
ffmpeg -v error -y -i $F/pixabay-3188291.jpg -vf "delogo=x=279:y=307:w=70:h=52" -q:v 1 assets/src-3188291.jpg
# --- split panels 400x640 (left WARM / right NEON) ---
still  hands  ../../video/assets/src-3188291.jpg 533:853:250:0     400:640 "$WARM"        # s07 elderly hand + cordless phone
vplate poppy  pixabay-16453.mp4  0 7.0  450:720:420:0 400:640 "$WARM"      # s08 flowers
vplate radio  pixabay-143126.mp4 0 7.5  900:1440:1350:0 400:640 "$WARM"     # s14 old radio, hand on the knob
still  specs  pixabay-4117523.jpg 533:853:420:0     400:640 "$WARM"        # s20 grandma with glasses
vplate phoneg pixabay-174009.mp4 1.0 4.0 900:1440:1086:0 400:640 "$NEON"   # s09 young woman + phone
vplate hpgirl pixabay-161062.mp4 0 4.0  1440:2304:0:128 400:640 "$NEON"    # s16 young woman, headphones
vplate hpgma  pixabay-172681.mp4 0 6.0  450:720:610:0 400:640 "$NEON"      # s17 grandma holding her headphones, ms 2.92
still  gzw1   pixabay-7289453.jpg 520:832:160:60  400:640 "$NEON"        # s21 young woman, glasses + phone
still  gzw2   pixabay-7289453.jpg 330:528:230:150 400:640 "$NEON"        # s22 same, close on the glasses
vplate cat    pixabay-179212.mp4 3.0 3.0 612:720:250:0 340:400 "$NEON"     # s10 cat in the chat bubble
ffmpeg -v error -y -ss 4 -i $F/pixabay-16453.mp4 -frames:v 1 -vf "crop=720:540:300:90,scale=340:255,$WARM" -q:v 2 assets/flowers.jpg
# --- blurred backdrops behind the cards ---
blurbg hook pixabay-172681.mp4 5; blurbg baby pixabay-73613.mp4 1; blurbg phones pixabay-2284.mp4 0.3
blurbg grin pixabay-2739143.jpg; blurbg dance pixabay-172681.mp4 1.5; blurbg couple pixabay-1546130.jpg
# thumbnail images
mkdir -p thumb/assets
ffmpeg -v error -y -i assets/src-3188291.jpg -vf "crop=600:853:150:0,scale=540:768:flags=lanczos,$WARM" -q:v 2 thumb/assets/left.jpg
ffmpeg -v error -y -ss 5.0 -i $F/pixabay-172681.mp4 -frames:v 1 -vf "crop=542:720:569:0,scale=540:718:flags=lanczos,$NEON" -q:v 2 thumb/assets/right.jpg
echo done
