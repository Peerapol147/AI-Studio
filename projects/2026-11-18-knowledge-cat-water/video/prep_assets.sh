#!/usr/bin/env bash
# Rebuilds video/assets/ (gitignored) from ../assets: copies VO/music, makes the stills' "cards" (native-res crops shown
# ~900 px wide, never upscaled full-frame) + their blurred/darkened fills, and the 1080x1920 video plates:
#   hook/ask = sharp band with feathered top/bottom over the same footage blurred (focus lands in Y 500-1300)
#   belief/dry = straight 9:16 crops from 4K (downscaled, sharp)
set -e
cd "$(dirname "$0")"; mkdir -p assets; cp ../assets/audio/{vo-th.mp3,music-jamendo-b6fb4ded.mp3} assets/
F=../assets/footage; cd assets
fill(){ ffmpeg -v error -y -i "$1" -vf "scale=1080:1920:force_original_aspect_ratio=increase,crop=1080:1920,gblur=sigma=40,eq=brightness=-0.16:saturation=0.85" -q:v 5 "$2"; }
card(){ ffmpeg -v error -y -i "../$F/$2" -vf "crop=$3" -q:v 2 "$1-card.jpg"; fill "../$F/$2" "$1-fill.jpg"; }
card fishing  fishing-inaturalist-40917494.jpg    1400:1400:600:120
card fishing2 fishing2-inaturalist-246153880.jpg  1300:1188:300:100
card van      van-pixabay-1581688.jpg             940:960:140:0
card van2     van2-pixabay-5966014.jpg            1080:960:100:0
card vet      vet-pixabay-4588434.jpg             860:853:380:0
card ancestor ancestor-inaturalist-368888333.jpg  1400:1436:300:100
card guess    guess-pixabay-1199240.jpg           860:853:300:0
card swim     swim-pixabay-1547186.jpg            960:960:120:0
ENC="-an -c:v libx264 -preset medium -crf 16 -pix_fmt yuv420p -r 30 -g 6"
FEATHER="format=rgba,geq=r='r(X,Y)':g='g(X,Y)':b='b(X,Y)':a='255*clip(min(Y/150\,(H-1-Y)/150)\,0\,1)'"
# hook: kitten + glass. band = 4K crop 1400x1555 @ (1250,60) -> 1080x1200 placed at y=560 (head ~Y 680-1200)
ffmpeg -v error -y -i ../$F/hook-pixabay-133585.mp4 -filter_complex \
 "[0]split[a][b];[a]crop=1215:2160:1750:0,scale=1080:1920,gblur=sigma=40,eq=brightness=-0.16:saturation=0.85[bg];\
  [b]crop=1400:1555:1650:60,scale=1080:1200,$FEATHER[fg];[bg][fg]overlay=0:560,format=yuv420p" $ENC hook-v.mp4
# ask: tabby drinking (1080p). band = crop 1000x1080 @ x=380 -> 1080x1166 at y=300 (face ~Y 530-830)
ffmpeg -v error -y -i ../$F/ask-pixabay-57866.mp4 -filter_complex \
 "[0]split[a][b];[a]crop=608:1080:700:0,scale=1080:1920,gblur=sigma=40,eq=brightness=-0.16:saturation=0.85[bg];\
  [b]crop=1000:1080:380:0,scale=1080:1166,$FEATHER[fg];[bg][fg]overlay=0:300,format=yuv420p" $ENC ask-v.mp4
ffmpeg -v error -y -i ../$F/belief-pixabay-33328.mp4 -vf "crop=1215:2160:0:0,scale=1080:1920" $ENC belief-v.mp4
ffmpeg -v error -y -i ../$F/dry-pixabay-89769.mp4 -vf "crop=1215:2160:1300:0,scale=1080:1920,eq=brightness=-0.08:saturation=0.9,colorbalance=rs=0.12:gs=0.03:bs=-0.12" $ENC dry-v.mp4
ffmpeg -v error -y -i hook-v.mp4 -frames:v 1 -q:v 2 hook0.jpg
mkdir -p ../thumb/assets; cp hook0.jpg ../thumb/assets/
