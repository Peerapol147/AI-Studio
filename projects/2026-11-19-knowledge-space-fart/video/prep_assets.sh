#!/usr/bin/env bash
# Rebuilds video/assets/ (gitignored) from ../assets: copies VO/music and bakes every NASA still with ONE space grade
# (deep navy) for the whole clip:
#   LUT .media/luts/grade_002.cube (from `hyperframes media-use resolve --type grade --intent "deep navy space blue cool"`)
#   + the same eq/colorbalance on every plate; only the per-source exposure trim (EXP) differs.
# Per still:  <n>-card.jpg = sharp graded crop (source px, shown as a rounded card, push-in in CSS)
#             <n>-bg.jpg   = 1080x1920 cover crop of the SAME still, heavy blur + darker (the card's backdrop)
#             <n>-full.jpg = 1080x1920 graded full-frame crop (only portrait stills with enough resolution: rocket, linger)
set -e
cd "$(dirname "$0")"; mkdir -p assets
cp ../assets/audio/{vo-th.mp3,music-jamendo-b6fb4ded.mp3} assets/
F=../assets/footage; LUT=.media/luts/grade_002.cube
grade(){ echo "lut3d=file=$LUT,eq=brightness=$1:contrast=1.07:saturation=0.86,colorbalance=rs=-0.05:gs=-0.02:bs=0.10:rm=-0.02:gm=-0.01:bm=0.07:rh=-0.02:bh=0.05"; }
card(){ # name crop exposure [source still, default = name]
  ffmpeg -v error -y -i "$F/${4:-$1}.jpg" -vf "crop=$2,$(grade $3)" -q:v 2 "assets/$1-card.jpg"; }
bg(){ # name exposure [source still] [pre-crop]  (cover 1080x1920, blur, darker)
  ffmpeg -v error -y -i "$F/${3:-$1}.jpg" -vf "${4:+crop=$4,}scale=1080:1920:force_original_aspect_ratio=increase,crop=1080:1920,$(grade $2),gblur=sigma=38,eq=brightness=-0.16:saturation=0.8,vignette=PI/4" -q:v 3 "assets/$1-bg.jpg"; }
full(){ # name crop exposure
  ffmpeg -v error -y -i "$F/$1.jpg" -vf "crop=$2,scale=1080:1920:flags=lanczos,$(grade $3),vignette=PI/5" -q:v 2 "assets/$1-full.jpg"; }
# hook / loop (frame 0): crop around the floating astronaut, face lands at card y ~180 of 700 (= Y ~900 on screen)
card hook     1073:1015:0:300    -0.03 ; bg hook -0.03
full rocket   1080:1920:67:0     -0.02
card hadfield 1020:1275:220:0    -0.03 ; bg hadfield -0.03
# tried (review 1): Hadfield himself in the cupola (hadfield_alt) -- "พวกเขาลองกัน" stays on the person who said it
card tried    1150:1150:0:60     -0.03 hadfield_alt ; bg tried -0.03 hadfield_alt
# nozzle (review 1): the RS-25 nozzle on display (nozzle_alt), whole bell, exit at the card bottom
card nozzle   1170:1590:54:250   -0.02 nozzle_alt ; bg nozzle -0.02 nozzle_alt
card earth    1240:1240:340:18   -0.02 ; bg earth -0.02
# linger (review 1): no real person near the smoke -> only the empty lower module (no one in it), blurred, as the
# backdrop for the cartoon astronaut + cloud
bg linger -0.03 linger 1280:900:0:1000
# station: drop the white caption strip at the bottom
card station  1200:1200:264:20    0.02 ; bg station 0.02
card you      1200:1200:360:40   -0.03 ; bg you -0.03
# thumbnail composition (video/thumb/): ISS exterior plates only (review 1: no real person next to the smoke on the cover)
mkdir -p thumb/assets; cp assets/station-card.jpg assets/station-bg.jpg thumb/assets/
