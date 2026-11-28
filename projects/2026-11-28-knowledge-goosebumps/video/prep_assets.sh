#!/usr/bin/env bash
# Rebuilds video/assets/ (gitignored) from ../assets: VO + music copies and every footage plate, 1080x1920 30 fps,
# ONE grade for the whole clip: look sunrise-coral grade "warm golden morning"
# (`hyperframes media-use resolve --type grade --intent "warm golden morning"` -> preset warm-daylight, inline; same
# eq/colorbalance on every plate). Video plates keep the SOURCE clock (start at source 0) so
# data-media-start = shots-th.json media_start. Pixabay stills are 1280 px wide and the 720p clips (mouse, concert)
# would break up full screen: they become a rounded "card" on a blurred copy of themselves (no full-screen upscale).
set -e
cd "$(dirname "$0")"; mkdir -p assets
cp ../assets/audio/vo-th.mp3 ../assets/audio/music-jamendo-34466c22.mp3 assets/
F=../assets/footage
ENC="-an -c:v libx264 -preset medium -crf 17 -pix_fmt yuv420p -r 30 -g 6"
GRADE="eq=contrast=1.06:saturation=1.06:gamma=1.0,colorbalance=rs=0.05:gs=0.015:bs=-0.06:rm=0.05:gm=0.01:bm=-0.05:rh=0.03:gh=0.01:bh=-0.04"
# rounded-corner alpha mask for a WxH card, radius 36
mask(){ echo "format=yuva420p,geq=lum='lum(X,Y)':cb='cb(X,Y)':cr='cr(X,Y)':a='if(gt(abs(X-W/2),W/2-36)*gt(abs(Y-H/2),H/2-36),if(lte(hypot(abs(X-W/2)-(W/2-36),abs(Y-H/2)-(H/2-36)),36),255,0),255)'"; }
# card: name src crop(w:h:x:y) cardW cardH cardY exposure [-t dur]
card(){ local n=$1 s=$2 c=$3 w=$4 h=$5 y=$6 ex=$7 t=$8 out
  case $s in *.mp4) out="$ENC assets/$n.mp4";; *) out="-frames:v 1 -q:v 2 assets/$n.jpg";; esac
  ffmpeg -v error -y ${t:+-t $t} -i "$F/$s" -filter_complex "[0]fps=30,split=3[a][b][c];\
[a]scale=1080:1920:force_original_aspect_ratio=increase,crop=1080:1920,gblur=sigma=40,eq=brightness=${BGB:--0.20}:saturation=0.9[bg];\
[b]crop=$c,scale=$w:$h:flags=lanczos,$(mask)[fg];\
[c]crop=$c,scale=$w:$h,format=gray,geq=lum=0,format=yuva420p,geq=lum=0:cb=128:cr=128:a=150,pad=$((w+120)):$((h+120)):60:60:color=black@0,gblur=sigma=26[sh];\
[bg][sh]overlay=(W-w)/2:$((y-40))[b2];[b2][fg]overlay=(W-w)/2:$y,$GRADE,eq=brightness=$ex,vignette=PI/5" $out; }
full(){ # name src crop exposure dur
  ffmpeg -v error -y -t "$5" -i "$F/$2" -vf "fps=30,crop=$3,scale=1080:1920:flags=lanczos,$GRADE,eq=brightness=$4,vignette=PI/5" $ENC "assets/$1.mp4"; }
# stills
card hook  pixabay-885563.jpg  1000:720:200:170 1000 720 800  0.0
card cat   pixabay-5534007.jpg 860:855:250:0    800 795 760  0.0
BGB=0.02 card human pixabay-222664.jpg  1000:853:140:0   1000 853 520  0.0
# hook card alone (graded, no bg) for the dive-through-the-skin graphic
ffmpeg -v error -y -i "$F/pixabay-885563.jpg" -vf "crop=1000:720:200:170,$GRADE" -q:v 2 assets/hook-skin.jpg
# full-screen video plates (source >= 1440 px tall)
full cold   pixabay-253979.mp4 1440:2560:0:0   0.0  3.0
full ape    pixabay-85379.mp4  810:1440:820:0  0.0  17.0   # real zoo gorilla (NickyPe); 388020 was AI
full music  pixabay-161062.mp4 1440:2560:0:0   0.0  5.2
full cta    pixabay-65390.mp4  810:1440:875:0  0.0  3.0
# 720p clips as cards
BGB=0.05 card mouse   pixabay-139660.mp4 900:720:60:0  1000 800 520 0.0 3.4
card concert pixabay-29322.mp4  1280:720:0:0  1000 562 420 0.0 3.0
ls -la assets
