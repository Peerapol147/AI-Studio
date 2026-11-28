#!/usr/bin/env bash
# Rebuilds video/assets/ (gitignored media) from ../assets: VO + music, footage plates (1080x1920 30 fps, one
# "cool blue purple night" grade for the whole clip = LUT .media/luts/grade_001.cube from
# `hyperframes media-use resolve --type grade --intent "cool blue purple night"` + the same eq/colorbalance),
# still cards, globe textures (NASA Blue Marble + Black Marble, downscaled 2048x1024) and a starfield.
# Video plates keep the SOURCE clock (start at source 0) so data-media-start = shots-th.json media_start.
# 720p sources become a sharp 4:5 card (x1.74) over a blurred copy of the same clip (no 2.7x upscale).
set -e
cd "$(dirname "$0")"; mkdir -p assets
cp ../assets/audio/vo-th.mp3 ../assets/audio/music-jamendo-8217e1c7.mp3 assets/
F=../assets/footage; LUT=.media/luts/grade_001.cube
ENC="-an -c:v libx264 -preset medium -crf 17 -pix_fmt yuv420p -r 30 -g 6"
grade(){ echo "lut3d=file=$LUT,eq=brightness=$1:contrast=1.06:saturation=0.85,colorbalance=rs=-0.05:gs=-0.03:bs=0.10:rm=0.03:gm=-0.04:bm=0.10:rh=0.02:bh=0.06"; }
full(){ # name src len crop exposure [extra]
  ffmpeg -v error -y -t "$3" -i "$F/$2" -vf "fps=30,${6:+$6,}crop=$4,scale=1080:1920:flags=lanczos,$(grade $5)" $ENC "assets/$1-v.mp4"; }
card(){ # name src len cropx exposure : 576x720 card -> 1000x1250 at (40,330) over blurred full frame
  ffmpeg -v error -y -t "$3" -i "$F/$2" -filter_complex "[0:v]fps=30,split[a][b];\
[a]scale=-2:1920,crop=1080:1920,boxblur=28:2,eq=brightness=-0.16:saturation=0.7[bg];\
[b]crop=576:720:$4:0,scale=1000:1250:flags=lanczos,pad=1012:1262:6:6:color=0x10080A[fg];\
[bg][fg]overlay=34:324,$(grade $5)" $ENC "assets/$1-v.mp4"; }
card feet    pixabay-3627.mp4   2.6  330  -0.02
card traffic pixabay-1900.mp4   2.4  420  -0.06
full air     pixabay-92768.mp4  2.9  810:1440:880:0  -0.04
full nothing pixabay-285663.mp4 2.7  1440:2560:0:0  0.0
card calm    pixabay-27230.mp4  3.3  360  -0.08
card tide    pixabay-148100.mp4 3.2  80   0.0
# still cards (Ken Burns runs in the page): blurred copy behind a sharp card
still(){ # name src cardw cardh y
  ffmpeg -v error -y -i "$F/$2" -filter_complex "[0:v]split[a][b];[a]scale=-2:1920,crop=1080:1920,boxblur=30:2,eq=brightness=-0.22:saturation=0.6[bg];\
[b]scale=$3:$4:flags=lanczos,pad=$(($3+12)):$(($4+12)):6:6:color=0x10080A[fg];[bg][fg]overlay=(W-w)/2:$5,$(grade 0)" -frames:v 1 -q:v 2 "assets/$1.jpg"; }
still jet  nasa-airbos-shockwaves.jpg 900 810 760
# storm: ISS photo of Hurricane Helene (NASA iss072e001650), crop 862x1078 round the eye (x 850), card 1000x1250 at y -40
ffmpeg -v error -y -i "$F/nasa-iss072e001650-helene.jpg" -filter_complex "[0:v]split[a][b];[a]scale=-2:1920,crop=1080:1920,boxblur=30:2,eq=brightness=-0.22:saturation=0.6[bg];\
[b]crop=862:1078:850:0,scale=1000:1250:flags=lanczos,pad=1012:1262:6:6:color=0x10080A[fg];[bg][fg]overlay=34:-46,$(grade 0)" -frames:v 1 -q:v 2 assets/storm.jpg
ffmpeg -v error -y -i "$F/nasa-GSFC_20171208_Archive_e001386.jpg" -vf "scale=1040:1040:flags=lanczos,pad=1080:1920:20:560:black" -frames:v 1 -q:v 2 assets/calmearth.jpg
ffmpeg -v error -y -i "$F/nasa-GSFC_20171208_Archive_e001982.jpg" -vf "crop=820:820:358:22,scale=960:960:flags=lanczos,pad=1080:1920:60:520:black" -frames:v 1 -q:v 2 assets/moon.jpg
ffmpeg -v error -y -i "$F/tex/earth-blue-marble.jpg" -vf scale=2048:1024:flags=lanczos -q:v 3 assets/tex-day.jpg
ffmpeg -v error -y -i "$F/tex/earth-night.jpg" -vf scale=2048:1024:flags=lanczos -q:v 3 assets/tex-night.jpg
python3 - <<'PY'
import random
from PIL import Image, ImageDraw, ImageFilter
r=random.Random(7); im=Image.new('RGB',(1080,1920),(0,0,0)); d=ImageDraw.Draw(im)
for _ in range(900):
    x,y=r.uniform(0,1080),r.uniform(0,1920); b=int(r.uniform(60,255)*r.random()**1.5)+40; s=r.choice([0.6,0.8,1,1.2,1.8])
    d.ellipse([x-s,y-s,x+s,y+s],fill=(b,b,min(255,b+25)))
im=im.filter(ImageFilter.GaussianBlur(0.6)).convert('L')
rgba=Image.new('RGBA',im.size,(255,255,255,0)); rgba.putalpha(im.point(lambda v:min(255,int(v*1.2)))); rgba.save('assets/stars.png')  # transparent: the slot gradient shows through
PY
echo done
