#!/usr/bin/env bash
# Rebuilds video/assets/ (gitignored) from ../assets for "น้ำมันจะหมดโลกปีไหน?" (energy-left, th).
# ONE grade for every shot (warm-dusk energy look): the same eq/colorbalance/vignette on every plate and still,
# only the per-source exposure trim differs. past/past2 = same grade then black-and-white + sepia (old film; grain
# is a seek-safe overlay in index.html). 720p sources and 1280 px stills are never blown up to full screen:
# they become a "card" (sharp crop) over a blurred, darkened copy of the same source (bg).
set -e
cd "$(dirname "$0")"; mkdir -p assets thumb/assets
cp ../assets/audio/{vo-th.mp3,music-jamendo-2f1bc5f2.mp3} assets/
F=../assets/footage
ENC="-an -c:v libx264 -preset medium -crf 17 -pix_fmt yuv420p -r 30 -g 6"
grade(){ echo "eq=brightness=$1:contrast=1.08:saturation=0.9,colorbalance=rs=-0.04:gs=-0.01:bs=0.05:rh=0.05:gh=0.01:bh=-0.04,vignette=PI/5"; }
BW="hue=s=0,eq=contrast=1.18:brightness=-0.02,colorbalance=rs=0.10:gs=0.04:bs=-0.08:rm=0.06:bm=-0.05"
BLUR="scale=1080:1920:force_original_aspect_ratio=increase,crop=1080:1920,boxblur=36:2,eq=brightness=-0.20:saturation=0.75"
# full-frame 9:16 plate from a >=1440p source: name src ss dur crop exposure
plate(){ ffmpeg -v error -y -ss "$3" -t "$4" -i "$F/$2" -vf "fps=30,crop=$5,scale=1080:1920:flags=lanczos,$(grade $6)" $ENC "assets/$1.mp4"; }
# band plate for the sun split (1080x640): name src ss dur crop exposure
band(){ ffmpeg -v error -y -ss "$3" -t "$4" -i "$F/$2" -vf "fps=30,crop=$5,scale=1080:640:flags=lanczos,$(grade $6)" $ENC "assets/$1.mp4"; }
# card video (sharp crop) + blurred bg video from a 720p source: name src ss dur crop WxH exposure [pre]
card(){ ffmpeg -v error -y -ss "$3" -t "$4" -i "$F/$2" -vf "fps=30,${8:+$8,}crop=$5,scale=$6:flags=lanczos,$(grade $7)" $ENC "assets/$1-card.mp4"
        ffmpeg -v error -y -ss "$3" -t "$4" -i "$F/$2" -vf "fps=30,${8:+$8,}$(grade $7),$BLUR" $ENC "assets/$1-bg.mp4"; }
# still: graded card jpg (1.15x the card box for the push-in) + blurred bg jpg: name src crop WxH exposure [bw]
still(){ local X=""; [ -n "$6" ] && X=",$BW"
  ffmpeg -v error -y -i "$F/$2" -vf "crop=$3,scale=$4:flags=lanczos,$(grade $5)$X" -q:v 2 "assets/$1-card.jpg"
  ffmpeg -v error -y -i "$F/$2" -vf "$(grade $5)$X,$BLUR" -q:v 3 "assets/$1-bg.jpg"; }

# --- footage plates (start = source point the shot opens on; dur = shot + 0.12 crossfade + margin)
# believe: crop x>=1310 keeps the right-hand traffic and drops the rooftop brand sign at source x~1180-1270
plate believe   pixabay-84970.mp4   0.5  1.3  810:1440:1310:0   -0.02
plate hourglass pixabay-326934.mp4  1.0  2.0  810:1440:1125:0   -0.02
plate now       pixabay-336755.mp4  1.0  1.7  810:1440:960:0     0.02
plate coal      pixabay-40030.mp4   1.0  1.8  810:1440:495:0     0.04
band  sun-a     pixabay-42388.mp4   0.5  2.6  2430:1440:65:0    -0.02
band  sun-b     pixabay-84625.mp4   0.5  2.6  2430:1440:65:0    -0.02
band  sun-c     pixabay-172575.mp4  0.5  2.6  1215:720:32:0     -0.02
# sun backdrop behind the strips (no black screen before a strip lands)
ffmpeg -v error -y -ss 0.5 -t 2.6 -i $F/pixabay-42388.mp4 -vf "fps=30,$(grade -0.02),$BLUR" $ENC assets/sun-bg.mp4
# gas: blue flame lit from ~3.0 s (pan arrives ~5 s); refill: dam overflow; finite: b/w hourglass
card  gas       pixabay-11290.mp4   3.1  1.5  1008:360:166:330 840x300 0.0
# uranium: card on the steam plume, plume pushed to the card's right (x~690/820) where index.html draws the two
# hyperboloid cooling towers under it (the source never shows the towers: they are behind the hill)
card  uranium   pixabay-29413.mp4   0.3  2.6  1204:860:767:0  840x600 -0.02
card  refill    pixabay-172575.mp4  3.0  1.8  1008:720:136:0  840x600 -0.02
card  finite    pixabay-26452.mp4   1.0  1.6  576:720:480:0   560x700 0.0
# save: source = switching the strip ON (press 10.2-10.8, glow from ~10.6). Played BACKWARDS from 11.26 so the
# glow goes OFF at shot+0.66 = "พลังงาน" 37.40 and the finger then withdraws (reads as "switch off").
card  save      pixabay-4975.mp4    9.14 2.24 720:720:100:0   840x840 0.0  "reverse"

# --- stills (1280 px): card + blurred bg
still hook     pixabay-106913.jpg  1029:853:121:0   943x782  0.02
still past     pixabay-848300.jpg  922:720:358:0    943x736  0.0  bw
# past2: crop x>=730 drops the maker plate on the walking beam and the badge on the base (both left of x 720)
still past2    pixabay-643836.jpg  460:590:730:150  736x943  0.0  bw
still drill    pixabay-4713386.jpg 460:590:600:100  736x943  0.02
still newfield pixabay-4713386.jpg 1093:853:187:0   943x736  0.02
still oil      pixabay-3629119.jpg 1166:853:57:0    943x690  -0.02
# graphic-scene backdrops: blurred, darkened neighbours (count <- past, formula <- drill, finite2 <- hourglass)
ffmpeg -v error -y -i $F/pixabay-848300.jpg -vf "$(grade -0.06),$BW,$BLUR" -q:v 3 assets/gbg-count.jpg
ffmpeg -v error -y -i $F/pixabay-4713386.jpg -vf "$(grade -0.08),$BLUR" -q:v 3 assets/gbg-formula.jpg
ffmpeg -v error -y -ss 2 -i $F/pixabay-26452.mp4 -frames:v 1 -vf "$(grade -0.08),$BLUR" -q:v 3 assets/gbg-finite.jpg
# thumbnail uses the frame-0 images
cp assets/hook-card.jpg assets/hook-bg.jpg thumb/assets/
