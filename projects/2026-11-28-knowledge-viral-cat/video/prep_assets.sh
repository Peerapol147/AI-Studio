#!/usr/bin/env bash
# Rebuilds video/assets/ plates from ../assets (ocean-teal grade "teal cyan underwater": one eq/colorbalance for the whole clip).
# Plates with a media_start in shots-th.json (hook, reveal, reveal_b) keep the source clock (start at source 0).
# Plates without one start at the in-point chosen here (hookblur = hook source 5.36 s, khao = face visible from 6 s).
# Stills (Pixabay 1280 px) are never blown up full screen: card on a blurred backdrop of the same picture.
set -e
cd "$(dirname "$0")"; mkdir -p assets vendor
cp ../assets/audio/vo-th.mp3 ../assets/audio/music-jamendo-209419.mp3 assets/
# rough.js falls back to Math.random() only when no seed is given; every call here passes a seed, but the render
# contract forbids the token: swap it for a fixed mulberry32 so the file is deterministic by construction
{ echo 'var __hfR=(function(a){return function(){a|=0;a=a+0x6D2B79F5|0;var t=Math.imul(a^a>>>15,1|a);t=t+Math.imul(t^t>>>7,61|t)^t;return((t^t>>>14)>>>0)/4294967296;};})(20261128);'
  sed 's/Math\.random()/__hfR()/g' ../../../assets/vendor/rough.js; } > vendor/rough.js
F=../assets/footage
GR="eq=contrast=1.05:saturation=0.9:gamma=0.98,colorbalance=rs=-0.05:gs=0.01:bs=0.05:rm=-0.04:gm=0.01:bm=0.04:rh=-0.02:bh=0.03"
ENC="-an -c:v libx264 -preset medium -crf 17 -pix_fmt yuv420p -r 30 -g 6"
vplate(){ # name src crop(w:h:x:y) [ss] [max seconds]
  ffmpeg -v error -y -ss "${4:-0}" -t "${5:-12}" -i "$F/$2" -vf "fps=30,crop=$3,scale=1080:1920:flags=lanczos,$GR,vignette=PI/6" $ENC "assets/$1.mp4"; }
# hook / loop: the face sits at source Y ~500 of 1440 -> full-bleed it would hide behind the frame-0 title (Y 250-700).
# Keep the cat lower: 1215x1440 crop scaled to 1080x1280 at Y 560 (feathered top edge) over the same clip blurred.
lowplate(){ # name src ss t crop(w:h:x:y) fg-height y extra
  ffmpeg -v error -y -ss "$3" -t "$4" -i "$F/$2" -filter_complex \
  "[0:v]fps=30,split[a][b];[a]scale=-2:1920,crop=1080:1920,gblur=sigma=40,$GR,eq=brightness=-0.08[bg];\
[b]crop=$5,scale=1080:$6:flags=lanczos,$GR,format=rgba,geq=r='r(X,Y)':g='g(X,Y)':b='b(X,Y)':a='255*min(1,min(Y/140,(H-1-Y)/90))'[fg];\
[bg][fg]overlay=0:$7:format=auto,vignette=PI/6$8" $ENC "assets/$1.mp4"; }
hookplate(){ lowplate "$1" pixabay-168334.mp4 "$2" "$3" 1215:1440:800:0 1280 560 "$4"; }
hookplate hook 0 6.2 ""
# hook_fight: the same cat right after the hook in-point, blurred under the comment bubbles
hookplate hookblur 5.3 1.9 ",gblur=sigma=14,eq=brightness=-0.1"
vplate paint   pixabay-108560.mp4 405:720:430:0 2 4
# viral: the source is HLG/BT.2020 (10 bit) -> tone-map to SDR BT.709 first (else the render auto-promotes to HDR HEVC)
ffmpeg -v error -y -t 5.6 -i "$F/pixabay-339775.mp4" -vf "zscale=t=linear:npl=100,format=gbrpf32le,zscale=p=bt709,tonemap=hable:desat=0,zscale=t=bt709:m=bt709:r=tv,format=yuv420p,fps=30,scale=1080:1920:flags=lanczos,eq=brightness=0.04:saturation=1.15,$GR,vignette=PI/6" $ENC -color_primaries bt709 -color_trc bt709 -colorspace bt709 assets/viral.mp4
vplate reveal  pixabay-185937.mp4 608:1080:1160:330 0 10.6
vplate revealb pixabay-347102.mp4 1215:2160:700:0 0 5.2
# khao: face sits at the top of the 720 px frame -> lower card; cta: 39009 never shows a face, use 16975 (two cats look at camera)
lowplate khao pixabay-46226.mp4 6 4 640:720:250:0 1440 480 ""
lowplate cta  pixabay-16975.mp4 2 5 1080:1440:640:0 1440 250 ""
BG="scale=1080:1920:force_original_aspect_ratio=increase,crop=1080:1920,gblur=sigma=38,$GR,eq=brightness=-0.14:saturation=0.75,vignette=PI/4"
still(){ # name src
  ffmpeg -v error -y -i "$F/$2" -vf "$GR" -q:v 2 "assets/$1.jpg"
  ffmpeg -v error -y -i "$F/$2" -vf "$BG" -q:v 3 "assets/$1-bg.jpg"; }
still white pixabay-3683186.jpg
still siam  pixabay-806210.jpg
still korat pixabay-2669735.jpg
ls -la assets
# mono voice -> stereo at -3 dB per channel, so the mix script's stereo LUFS reads the voice at its real -18 (not -15)
ffmpeg -v error -y -i ../assets/audio/vo-th.mp3 -af "pan=stereo|c0=0.7071*c0|c1=0.7071*c0" -ar 48000 assets/vo-th-mix.wav
