#!/usr/bin/env bash
# Rebuilds video/assets/ plates from ../assets (ocean-teal grade "teal cyan underwater": one eq/colorbalance for all).
# Video plates keep the source clock (start at source 0) so data-media-start = shots-th.json media_start.
# Stills (Pixabay <=1280 px) are never blown up full screen: <id>-bg.jpg = blurred dark backdrop (1080x1920),
# <id>.jpg = graded original at native size, shown as a card on top (build_index.py: still plate + -bg sibling).
set -e
cd "$(dirname "$0")"; mkdir -p assets
cp ../assets/audio/vo-th.mp3 ../assets/audio/music-mixkit-680.mp3 assets/
F=../assets/footage
GR="eq=contrast=1.05:saturation=0.92:brightness=-0.01,colorbalance=rs=-0.05:gs=0.01:bs=0.07:rm=-0.03:bm=0.03:rh=-0.01:bh=0.02"
ENC="-an -c:v libx264 -preset medium -crf 17 -pix_fmt yuv420p -r 30 -g 6"
vplate(){ # name src crop(w:h:x:y)
  ffmpeg -v error -y -i "$F/$2" -vf "fps=30,crop=$3,scale=1080:1920:flags=lanczos,$GR,vignette=PI/6" $ENC "assets/$1.mp4"; }
vplate tiger-yawn   pixabay-122124.mp4 405:720:470:0
vplate tiger-face   pixabay-143892.mp4 608:1080:800:0
vplate hyena-rock   pixabay-85691.mp4  810:1440:880:0
vplate hyena-eat    pixabay-85692.mp4  608:1080:760:0
vplate hyena-walk   pixabay-258584.mp4 405:720:380:0
vplate gator        pixabay-136331.mp4 608:1080:1000:0
vplate splash       pixabay-173059.mp4 608:1080:800:0
vplate croc-drone   pixabay-214432.mp4 608:1080:500:0
still(){ # name src [extra filter for the card]
  ffmpeg -v error -y -i "$F/$2" -vf "${3:+$3,}$GR" -q:v 2 "assets/$1.jpg"
  ffmpeg -v error -y -i "$F/$2" -vf "scale=1080:1920:force_original_aspect_ratio=increase,crop=1080:1920,gblur=sigma=38,$GR,eq=brightness=-0.16:saturation=0.8,vignette=PI/4" -q:v 3 "assets/$1-bg.jpg"; }
still croc-open   pixabay-9846352.jpg
still croc-lunge  pixabay-1214750.jpg
still tiger-skull pixabay-7564428.jpg
still croc-head   pixabay-9846341.jpg
still shark-jump  pixabay-5217363.jpg
still shark-mouth pixabay-8463561.jpg
still shark-swim  pixabay-534838.jpg
still croc-teeth  pixabay-9846339.jpg
ffmpeg -v error -y -ss 4.5 -i assets/tiger-face.mp4 -frames:v 1 -vf "gblur=sigma=38,eq=brightness=-0.16:saturation=0.8,vignette=PI/4" -q:v 3 assets/tiger-bg.jpg
ls -la assets
