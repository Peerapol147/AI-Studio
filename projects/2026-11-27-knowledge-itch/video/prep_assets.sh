#!/usr/bin/env bash
# Rebuilds video/assets/ plates (gitignored) from ../assets: VO/music copies + every footage plate 1080x1920 30 fps
# with ONE night grade (look night-violet "cool blue purple night"): LUT .media/luts/grade_001.cube
# (`hyperframes media-use resolve --type grade --intent "cool blue purple night"`) + the same eq/colorbalance.
# Video plates keep the SOURCE clock (start at source 0) so data-media-start = shots-th.json media_start.
# 168341 (the only real scratching clip) is used 3x with clearly different framing: hook = close-up on the nails,
# scratch2 = wide, cta = rotated 90 deg close-up (another angle); follow = 3-panel grid (3 people) built in index.html.
set -e
cd "$(dirname "$0")"; mkdir -p assets
cp ../assets/audio/vo-th.mp3 ../assets/audio/music-jamendo-1693127.mp3 assets/
F=../assets/footage; LUT=.media/luts/grade_001.cube
ENC="-an -c:v libx264 -preset medium -crf 17 -pix_fmt yuv420p -r 30 -g 6"
grade(){ echo "lut3d=file=$LUT,eq=brightness=$1:contrast=1.06:saturation=0.82,colorbalance=rs=-0.06:gs=-0.04:bs=0.12:rm=0.04:gm=-0.05:bm=0.12:rh=0.03:bh=0.08"; }
plate(){ # name src dur crop exposure [pre-filter] [out size]
  ffmpeg -v error -y -t "$3" -i "$F/$2" -vf "fps=30,${6:+$6,}crop=$4,scale=${7:-1080:1920}:flags=lanczos,$(grade $5),vignette=PI/5" $ENC "assets/$1.mp4"; }
plate hook     pixabay-168341.mp4 4.4  720:1280:560:0     -0.03
plate scratch2 pixabay-168341.mp4 8.6  810:1440:330:0     -0.05
plate cta      pixabay-168341.mp4 15.2 1260:2240:90:240  -0.04 "transpose=2"
plate signal   pixabay-114977.mp4 1.8  700:1244:930:40    0.02  "hue=h=28:s=1.15"
plate watch    pixabay-61706.mp4  2.0  810:1440:1250:0    0.04
# follow grid panels (1000x540 each)
plate fp2      pixabay-168341.mp4 12.6 2560:1382:0:0      -0.04 "" 1000:540
plate fp3      pixabay-38079.mp4  2.4  1280:691:0:0       -0.02 "" 1000:540
# stills: card on a blurred copy of itself (no full-screen upscale of a 1280 px photo)
card(){ # name src exposure crop
  ffmpeg -v error -y -i "$F/$2" -filter_complex "[0]split[a][b];[a]scale=1080:1920:force_original_aspect_ratio=increase,crop=1080:1920,gblur=sigma=38,eq=brightness=-0.18[bg];[b]${4:+crop=$4,}scale=980:-2:flags=lanczos[fg];[bg][fg]overlay=(W-w)/2:(H-h)/2-150,$(grade $3),vignette=PI/5" -q:v 2 "assets/$1.jpg"; }
card mosquito   pixabay-719613.jpg  0.02 "900:851:300:0"
card mouse      pixabay-1554745.jpg 0.0  "1000:834:0:0"
card contagious pixabay-3382130.jpg 0.04 "900:853:190:0"
ffmpeg -v error -y -i "$F/pixabay-3382130.jpg" -vf "crop=1280:691:0:60,scale=1000:540,$(grade 0.04)" -q:v 2 assets/fp1.jpg
# hook still for cover A (frame-0 picture)
ffmpeg -v error -y -ss 2.0 -i assets/hook.mp4 -frames:v 1 -q:v 2 assets/hook0.jpg
