#!/usr/bin/env bash
# Rebuilds video/assets/ (gitignored) from ../assets: copies VO/music/footage, makes the still focus crops,
# the blurred fills (stills: jpg; warn/ask footage: blurred 9:16 videos, same timeline as the source)
# and the thumbnail stills in thumb/assets/. No upscaled full-frame crops.
set -e
cd "$(dirname "$0")"; mkdir -p assets thumb/assets
cp ../assets/audio/{vo-th.mp3,vo-en.mp3,music-jamendo-4228fb9b.mp3} ../assets/footage/*.jpg ../assets/footage/*.mp4 assets/
cd assets
fill(){ ffmpeg -v error -y -i "$1" -vf "scale=1080:1920:force_original_aspect_ratio=increase,crop=1080:1920,gblur=sigma=45,eq=brightness=-0.13:saturation=0.85" -q:v 5 "$2"; }
mk(){ ffmpeg -v error -y -i "$2" -vf "crop=$3" -q:v 2 "$1-crop.jpg"; fill "$1-crop.jpg" "$1-fill.jpg"; }
mk mask mask-pixabay-8687776.jpg 760:960:140:0       # face + mask, the bed rail stays soft
mk doctor doctor-pixabay-5321351.jpg 853:1010:0:170  # head to hips, plain white
# blurred moving fills behind the footage bands (9:16 crop around the subject)
vfill(){ ffmpeg -v error -y -i "$1" -vf "crop=608:1080:$3:0,scale=540:960,gblur=sigma=24,eq=brightness=-0.15:saturation=0.85,scale=1080:1920" -an -c:v libx264 -crf 26 -pix_fmt yuv420p -g 25 "$2"; }
vfill warn-pixabay-83875.mp4 warn-fill.mp4 1016
vfill ask-pixabay-119515.mp4 ask-fill.mp4 896
cd ../thumb/assets
ffmpeg -v error -y -ss 1.8 -i ../../assets/hook-pixabay-44647.mp4 -frames:v 1 -q:v 2 hook-frame.jpg
