#!/usr/bin/env bash
# Rebuilds video/assets/ (gitignored) from ../assets: copies VO/music and bakes every footage plate as a
# 1080x1920 30 fps clip. Plates KEEP THE SOURCE CLOCK (start at source 0), so data-media-start in index.html
# = media_start from assets/audio/shots-th.json exactly.
# Looks (one per era, same for every plate of that era):
#   NOW  (hook/outro, 2026): LUT .media/luts/grade_001.cube (cool blue night, `hyperframes media-use resolve`) + eq
#   PAST (2000-2010, everything between): warm faded "old photo" grade (lifted blacks, low saturation, warm mids)
#   Film grain on top of the past is the registry `grain-overlay` component in index.html (not baked).
# Plate kinds: full = 9:16 crop full-bleed; card = 4:3 "old photo" card (white border) on a blurred copy of itself
# (720p sources would be 2.7x upscaled full-bleed); blur = blurred full-bleed backdrop for graphic shots.
set -e
cd "$(dirname "$0")"; mkdir -p assets
cp ../assets/audio/{vo-th.mp3,music-jamendo-b6fb4ded.mp3} assets/
F=../assets/footage; LUT=.media/luts/grade_001.cube
ENC="-an -c:v libx264 -preset medium -crf 17 -pix_fmt yuv420p -r 30 -g 6"
NOW="lut3d=file=$LUT,colorbalance=rs=-0.12:gs=-0.02:bs=0.16:rm=-0.1:bm=0.14,eq=brightness=-0.08:contrast=1.08:saturation=0.9,vignette=PI/4.5"
SEPIA="colorchannelmixer=.697:.385:.095:0:.175:.843:.084:0:.136:.267:.566"
PAST="eq=contrast=0.9:saturation=0.74:brightness=0.0,colorbalance=rs=0.07:gs=0.02:bs=-0.08:rm=0.06:gm=0.01:bm=-0.07:rh=0.03:bh=-0.05,curves=all='0/0.07 0.5/0.52 1/0.93',vignette=PI/5"
full(){ # name src dur crop grade [exposure] [extra filter after scale, e.g. delogo]
  ffmpeg -v error -y -t "$3" -i "$F/$2" -vf "fps=30,crop=$4,scale=1080:1920:flags=lanczos${7:+,$7},$5,eq=brightness=${6:-0}" $ENC "assets/$1.mp4"; }
blur(){ # name src dur crop
  ffmpeg -v error -y -t "$3" -i "$F/$2" -vf "fps=30,crop=$4,scale=540:960,gblur=sigma=14,scale=1080:1920,$PAST,eq=brightness=-0.13:saturation=0.85" $ENC "assets/$1.mp4"; }
card(){ # name src dur bgcrop(9:16) fgcrop(4:3)
  ffmpeg -v error -y -t "$3" -i "$F/$2" -filter_complex \
   "[0:v]fps=30,split[a][b];[a]crop=$4,scale=540:960,gblur=sigma=16,scale=1080:1920,eq=brightness=-0.16[bg];\
[b]crop=$5,scale=720:540:flags=lanczos,pad=748:568:14:14:color=0xF4EBDD[fg];[bg][fg]overlay=166:600,$PAST" $ENC "assets/$1.mp4"; }
# the clock face prints its maker's name: soften that patch (no brand names on screen)
rblur(){ echo "split[m][r];[r]crop=$1,gblur=sigma=9[rb];[m][rb]overlay=${1#*:*:}"; }
DL=$(rblur 340:130:340:740)
# hook / outro: alarm clock, NOW (2026, cool) and PAST (2000, warm) versions of the same frames (glitch swaps them)
full hookc wake_bed.mp4 5.4 810:1440:1560:0 "$NOW" 0 "$DL"
full hookw wake_bed.mp4 5.4 810:1440:1560:0 "$SEPIA,$PAST" 0 "$DL"
full bed   wake_bed.mp4 2.4 700:1244:1660:90 "$PAST" 0 "$(rblur 360:130:250:690)"
card fm    future_mind.mp4 3.0 405:720:640:0 960:720:320:0
card kh    kid_hands.mp4 3.4 405:720:420:0 960:720:160:0
card ks    kid_school.mp4 2.8 405:720:640:0 960:720:320:0
blur ksb   kid_school.mp4 6.0 405:720:640:0
full gold  gold.mp4 6.7 810:1440:875:0 "$PAST" -0.02
blur goldb gold.mp4 10 810:1440:875:0
full stock stock.mp4 7.3 810:1440:875:0 "$PAST" -0.04
blur stockb stock.mp4 10 810:1440:875:0
card pg    piggy.mp4 8.3 810:1440:1300:0 1920:1440:420:0
blur teenb teen.mp4 5.3 405:720:600:0
full crash crash.mp4 2.4 810:1440:1180:0 "$PAST"
blur crashb crash.mp4 3.6 810:1440:1180:0
# thumbnail backdrop = frame-0 image (hook NOW plate at source 3.0 s) and the PAST version
ffmpeg -v error -y -ss 3.0 -i assets/hookc.mp4 -frames:v 1 -q:v 2 assets/hook0.jpg
ffmpeg -v error -y -ss 3.0 -i assets/hookw.mp4 -frames:v 1 -q:v 2 assets/hookw0.jpg
mkdir -p thumb/assets; cp assets/hook0.jpg thumb/assets/hook-cover.jpg; cp assets/hookw0.jpg thumb/assets/hook-cover-w.jpg
