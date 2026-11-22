#!/usr/bin/env bash
# Rebuilds video/assets/ (gitignored) from ../assets: copies VO/music and bakes every NASA still with ONE space grade
# (deep navy, same as the space-fart episode) for the whole clip:
#   LUT .media/luts/grade_002.cube (space-fart ep: `hyperframes media-use resolve --type grade --intent "deep navy space blue cool"`)
#   + the same eq/colorbalance on every plate; only the per-source exposure trim (EXP) differs.
# Per still:  <n>-card.jpg = sharp graded crop (source px, shown as a rounded card, push-in in CSS)
#             <n>-bg.jpg   = 1080x1920 cover crop of the SAME still, heavy blur + darker (the card's backdrop)
#             <n>-full.jpg = 1080x1920 graded full-frame crop (portrait still with enough resolution: filter)
# Crops come from assets/footage/MAP.md + a look at each still (10% grid).
set -e
cd "$(dirname "$0")"; mkdir -p assets
cp ../assets/audio/{vo-th.mp3,music-jamendo-34a821bb.mp3} assets/
F=../assets/footage; LUT=.media/luts/grade_002.cube
grade(){ echo "lut3d=file=$LUT,eq=brightness=$1:contrast=1.07:saturation=0.86,colorbalance=rs=-0.05:gs=-0.02:bs=0.10:rm=-0.02:gm=-0.01:bm=0.07:rh=-0.02:bh=0.05"; }
card(){ # name crop exposure [source still, default = name]
  ffmpeg -v error -y -i "$F/${4:-$1}.jpg" -vf "crop=$2,$(grade $3)" -q:v 2 "assets/$1-card.jpg"; }
bg(){ # name exposure [source still]  (cover 1080x1920, blur, darker)
  ffmpeg -v error -y -i "$F/${3:-$1}.jpg" -vf "scale=1080:1920:force_original_aspect_ratio=increase,crop=1080:1920,$(grade $2),gblur=sigma=38,eq=brightness=-0.16:saturation=0.8,vignette=PI/4" -q:v 3 "assets/$1-bg.jpg"; }
full(){ # name crop exposure
  ffmpeg -v error -y -i "$F/$1.jpg" -vf "crop=$2,scale=1080:1920:flags=lanczos,$(grade $3),vignette=PI/5" -q:v 2 "assets/$1-full.jpg"; }
# hook / loop (frame 0): Chris Cassidy smiling in the station (face 54%,28% of the still). Card 760x720 at (140,700):
# crop 1000x947 from x 560 -> face lands at card (48%,38%) = screen ~(502,972), inside Y 500-1300, under the title
card hook     1000:947:560:0      0.01 ; bg hook 0.01
# gravity: Pettit floating (tilted frame), face ~ (880,660) -> card 740x800 crop 1100x1189
card gravity  1100:1189:400:91   -0.01 ; bg gravity -0.01
# toilet: ISS WHC (lid + canister), card 740x816
card toilet   980:1080:560:0      0.00 ; bg toilet 0.00
# funnel: UWMS ground review at JSC (not on ISS) -> labelled "ทดสอบบนโลก"; hose/funnel in hand at card (32%,48%)
card funnel   1200:1200:100:80   -0.01 ; bg funnel -0.01
# filter: water recovery rack (portrait 1275x1920) -> full frame
full filter   1080:1920:95:0     -0.02
# station: ISS exterior on black (no Earth), wide card 740x528
card station  1780:1271:70:0      0.04 ; bg station 0.04
# pettit: Don Pettit + floating water ball; face at card (49%,22%)
card pettit   1080:1168:640:0     0.02 ; bg pettit 0.02
# coffee: Kjell Lindgren drinking from the capillary cup (NOT Pettit: no name label on this shot)
card coffee   1200:1200:300:77    0.00 ; bg coffee 0.00
# thumbnail composition (video/thumb/): the frame-0 plates (thumbnail = frame 0)
mkdir -p thumb/assets; cp assets/hook-card.jpg assets/hook-bg.jpg thumb/assets/
