#!/usr/bin/env bash
# Rebuilds video/assets/ (gitignored): VO + music copies, the grip footage plate.
# grip: Pixabay 720x1280 -> card 756x1344 (x1.05, not blown up) with round corners on a blurred, darkened copy of itself,
# one grade for the clip = palette mono-yellow "high contrast black and white". Keeps the source clock (starts at
# source 0) so data-media-start = shots-th.json media_start.
set -e
cd "$(dirname "$0")"; mkdir -p assets
cp ../assets/audio/vo-th.mp3 ../assets/audio/music-jamendo-fb1328d9.mp3 assets/
F=../assets/footage
GRADE="hue=s=0,eq=contrast=1.35:brightness=0.03,curves=preset=increase_contrast"
ffmpeg -v error -y -t 4.0 -i "$F/pixabay-375102.mp4" -filter_complex "\
[0:v]fps=30,$GRADE,split[a][b];\
[a]scale=1080:1920:force_original_aspect_ratio=increase,crop=1080:1920,gblur=sigma=40,eq=brightness=-0.18[bg];\
[b]scale=756:1344:flags=lanczos,format=yuva420p,geq=lum='lum(X,Y)':cb='cb(X,Y)':cr='cr(X,Y)':a='if(gt(abs(X-378),330)*gt(abs(Y-672),624),if(lte(hypot(abs(X-378)-330,abs(Y-672)-624),48),255,0),255)'[card];\
[bg]drawbox=x=170:y=158:w=756:h=1344:color=black@0.55:t=fill[bg2];\
[bg2][card]overlay=162:130" -an -c:v libx264 -preset medium -crf 16 -pix_fmt yuv420p -r 30 -g 6 assets/grip-v.mp4
