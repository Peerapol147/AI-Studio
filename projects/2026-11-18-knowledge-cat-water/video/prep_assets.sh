#!/usr/bin/env bash
# Rebuilds video/assets/ (gitignored) from ../assets: copies VO/music/footage, makes the focus crops
# (no upscaled full-frame crops: each still is shown as a band over its own blurred fill) and the blurred fills.
set -e
cd "$(dirname "$0")"; mkdir -p assets; cp ../assets/audio/{vo-th.mp3,vo-en.mp3,music-jamendo-4228fb9b.mp3} ../assets/footage/*.jpg assets/
cd assets
fill(){ ffmpeg -v error -y -i "$1" -vf "scale=1080:1920:force_original_aspect_ratio=increase,crop=1080:1920,gblur=sigma=45,eq=brightness=-0.13:saturation=0.85" -q:v 5 "$2"; }
mk(){ ffmpeg -v error -y -i "$2" -vf "crop=$3" -q:v 2 "$1-crop.jpg"; fill "$2" "$1-fill.jpg"; }
mk hook hook-pixabay-3907504.jpg 840:540:230:45      # hands only; the sneaker logo (y>570) stays out
fill hook-crop.jpg hook-fill.jpg
mk elder elder-pixabay-3406054.jpg 944:1180:0:0
mk arth arth-pixabay-1704855.jpg 800:1060:160:160
ffmpeg -v error -y -i arth-pixabay-1704855.jpg -vf crop=240:240:405:495 -q:v 2 arth-lens.jpg
mk pop pop-wikimedia-cracking-knuckles.jpg 1100:680:180:280
mk doctor doctor-pixabay-2141808.jpg 900:854:300:0
mk hurt hurt-pixabay-5464607.jpg 900:698:0:150
mk clinic clinic-pixabay-818378.jpg 1080:753:200:100
