#!/usr/bin/env bash
# Rebuilds video/assets/ plates from ../assets (retro-cream grade "retro film faded warm": one curves/eq/colorbalance for all).
# Video plates keep the source clock (start at source 0) so data-media-start = shots-th.json media_start.
# Stills (Pixabay <=1280 px) are never blown up full screen: <id>-bg.jpg = blurred backdrop, <id>.jpg = card on top.
# Flag stills (Bhutan, Nepal) become short waving plates (geq ripple + light sweep) on a blurred backdrop.
set -e
cd "$(dirname "$0")"; mkdir -p assets
cp ../assets/audio/vo-th.mp3 ../assets/audio/music-jamendo-1559873.mp3 assets/
F=../assets/footage
GR="curves=all='0/0.07 0.5/0.52 1/0.95',eq=contrast=0.97:saturation=0.8,colorbalance=rs=0.05:gs=0.01:bs=-0.06:rm=0.04:gm=0.0:bm=-0.04:rh=0.03:bh=-0.04"
ENC="-an -c:v libx264 -preset medium -crf 17 -pix_fmt yuv420p -r 30 -g 6"
vplate(){ # name src crop(w:h:x:y) [max seconds]
  ffmpeg -v error -y -t "${4:-12}" -i "$F/$2" -vf "fps=30,crop=$3,scale=1080:1920:flags=lanczos,$GR,vignette=PI/6" $ENC "assets/$1.mp4"; }
vplate flag-th     pixabay-244977.mp4 810:1440:875:0 6
vplate magnifier   pixabay-104270.mp4 608:1080:456:0 6
vplate bt-valley   pixabay-292862.mp4 405:720:420:0 9
vplate np-himal    pixabay-10104.mp4 810:1440:200:0 7
vplate ir-desert   pixabay-70872.mp4 810:1440:875:0 6
vplate ir-flag     pixabay-141424.mp4 405:720:330:0 7
vplate jp-fuji     pixabay-173522.mp4 810:1440:875:0 7
vplate jp-tokyo    pixabay-243075.mp4 810:1440:240:0 7
vplate jp-torii    pixabay-53789.mp4 810:1440:875:0 6
vplate th-wat      pixabay-143645.mp4 810:1440:1180:0 4
vplate mekong      pixabay-32194.mp4 405:720:430:0 7
vplate ayutthaya   pixabay-145845.mp4 608:1080:656:0 8
BG="scale=1080:1920:force_original_aspect_ratio=increase,crop=1080:1920,gblur=sigma=38,$GR,eq=brightness=-0.14:saturation=0.75,vignette=PI/4"
still(){ # name src
  ffmpeg -v error -y -i "$F/$2" -vf "$GR" -q:v 2 "assets/$1.jpg"
  ffmpeg -v error -y -i "$F/$2" -vf "$BG" -q:v 3 "assets/$1-bg.jpg"; }
still bt-taktsang  pixabay-2691190.jpg
still np-durbar    pixabay-739723.jpg
still ir-isfahan   pixabay-3362936.jpg
still th-ananta    pixabay-7046511.jpg
# waving flag plate: name src bg-src(video) bg-at flag-w flag-h
flag(){
  ffmpeg -v error -y -ss "$4" -i "$F/$3" -frames:v 1 -vf "$BG" -q:v 3 "assets/$1-bg.jpg"
  ffmpeg -v error -y -loop 1 -framerate 30 -t 3.2 -i "assets/$1-bg.jpg" -loop 1 -framerate 30 -t 3.2 -i "$F/$2" -filter_complex \
   "[1:v]format=rgba,scale=$5:$6:flags=lanczos,pad=iw+60:ih+60:30:30:color=0x00000000,\
geq=r='min(255,r(X,Y+14*sin(2*PI*(X/460-T*0.8)))*(0.9+0.13*sin(2*PI*(X/460-T*0.8)+1.2)))':\
g='min(255,g(X,Y+14*sin(2*PI*(X/460-T*0.8)))*(0.9+0.13*sin(2*PI*(X/460-T*0.8)+1.2)))':\
b='min(255,b(X,Y+14*sin(2*PI*(X/460-T*0.8)))*(0.9+0.13*sin(2*PI*(X/460-T*0.8)+1.2)))':\
a='alpha(X,Y+14*sin(2*PI*(X/460-T*0.8)))',$GR[f];\
   [0:v][f]overlay=x=(W-w)/2:y=1010-h/2:format=auto,format=yuv420p" $ENC "assets/$1.mp4"; }
flag bt-flag pixabay-162244.png pixabay-292862.mp4 6 900 600
flag np-flag pixabay-162370.png pixabay-10104.mp4 3 640 765
ffmpeg -v error -y -i ../assets/audio/vo-th.mp3 -af "volume=0.4dB" -ac 2 -ar 48000 assets/vo-th-mix.wav
ls -la assets
