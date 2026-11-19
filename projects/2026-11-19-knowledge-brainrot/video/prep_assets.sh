#!/usr/bin/env bash
# Rebuilds video/assets/ (gitignored) from ../assets: copies VO/music and bakes every footage plate as a
# 1080x1920 30 fps clip with ONE night grade (blue-purple) for the whole clip:
#   LUT .media/luts/grade_001.cube (from `hyperframes media-use resolve --type grade --intent "cool blue purple night"`)
#   + the same eq/colorbalance on every plate; only the per-source exposure trim (EXP) differs.
# Plate = the source range the shot plays (start offset noted per plate). hook-v.mp4 keeps the source clock
# (starts at source 0) so data-media-start in index.html = shots-th.json media_start (2.0) and loop = 2.0 - dur.
set -e
cd "$(dirname "$0")"; mkdir -p assets
cp ../assets/audio/{vo-th.mp3,music-jamendo-b386828e.mp3} assets/
F=../assets/footage; LUT=.media/luts/grade_001.cube
ENC="-an -c:v libx264 -preset medium -crf 16 -pix_fmt yuv420p -r 30 -g 6"
grade(){ echo "lut3d=file=$LUT,eq=brightness=$1:contrast=1.06:saturation=0.82,colorbalance=rs=-0.06:gs=-0.04:bs=0.12:rm=0.04:gm=-0.05:bm=0.12:rh=0.03:bh=0.08,vignette=PI/5"; }
plate(){ # name src ss dur crop exposure [extra]
  ffmpeg -v error -y -ss "$3" -t "$4" -i "$F/$2" -vf "fps=30,${7:+$7,}crop=$5,scale=1080:1920:flags=lanczos,$(grade $6)" $ENC "assets/$1-v.mp4"; }
# v3 shots (assets/audio/shots-th.json v3, 23 shots). Plate = the source range each shot plays (start offset below).
# hook + loop: hand + glowing feed, crop 720x1280 @ (920,160) so fingertip/screen land in Y ~900-1300 under the title
plate hook      hook-a.mp4    0    4.6  720:1280:920:160   -0.02
# tease and beforebed: two different parts of bed.mp4
plate tease     bed.mp4       0.5  1.9  1440:2560:0:0      -0.10
plate beforebed bed.mp4       8.5  1.6  990:1760:250:380   -0.12
plate night     scrollbed.mp4 0.2  1.9  810:1440:875:0     -0.02
plate noproof   noproof.mp4   0    2.3  810:1440:875:0     -0.02
# heavy: two hands on a lit phone in a dark room (hook-b), screen in the middle of the crop
plate heavy     hook-b.mp4    2.0  1.4  810:1440:875:0     -0.06
plate stress    stress.mp4    0.5  1.6  810:1440:875:0     -0.04
# screen: hands scrolling outdoors (hook-c, greyer daylight -> darker trim)
plate screen    hook-c.mp4    1.0  2.0  810:1440:800:0     -0.14
# sleep: 10.4 s = eyes closed, restless frown (sleeps badly), not the pillow-over-head part
plate sleep     sleep.mp4     10.4 1.8  810:1440:875:0     -0.20
# stills for the thumbnail (= frame 0 image) and the graphic-scene backdrop
ffmpeg -v error -y -ss 2.0 -i assets/hook-v.mp4 -frames:v 1 -q:v 2 assets/hook0.jpg
mkdir -p thumb/assets; cp assets/hook0.jpg thumb/assets/hook-cover.jpg
