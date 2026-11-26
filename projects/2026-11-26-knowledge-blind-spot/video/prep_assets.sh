#!/usr/bin/env bash
# Rebuilds video/assets/ (gitignored): VO + music copies and every footage plate (1080x1920, 30 fps).
# Palette mono-yellow, grade "high contrast black and white": one B&W grade (GR) on every plate.
# Landscape sources (1280x720) are NOT blown up to fill 9:16: each is a full-width sharp card (<= 1.125x) on a
# blurred, darkened copy of itself. Plates whose shot uses media_start keep the SOURCE clock (encoded from 0, no -ss).
# sci / years use other parts of the who clip (new angle; their media_start is 0 in shots-th.json).
#   bash prep_assets.sh [name ...]   # names: hook hole cover nerve never brain who sci years fill
set -e
cd "$(dirname "$0")"; mkdir -p assets
cp ../assets/audio/vo-th.mp3 ../assets/audio/music-jamendo-16c1c37e.mp3 assets/
F=../assets/footage
GR="hue=s=0,eq=contrast=1.28:brightness=0.02,curves=preset=increase_contrast"
ENC="-an -c:v libx264 -preset medium -crf 17 -pix_fmt yuv420p -r 30 -g 15"
WANT=" ${*:-hook hole cover nerve never brain who sci years fill} "
want(){ [[ "$WANT" == *" $1 "* ]]; }
# CARD <crop w:h:x:y> <card w> <card h> <card y> : sharp card over a blurred darker copy (same crop)
CARD(){ echo "fps=30,$GR,crop=$1,split[a][b];[a]scale=1080:1920:force_original_aspect_ratio=increase,crop=1080:1920,gblur=sigma=42,eq=brightness=-0.28[bg];[b]scale=$2:$3:flags=lanczos[c];[bg][c]overlay=(W-w)/2:$4"; }
CARDI(){ echo "$GR,crop=$1,split[a][b];[a]scale=1080:1920:force_original_aspect_ratio=increase,crop=1080:1920,gblur=sigma=42,eq=brightness=-0.28[bg];[b]scale=$2:$3:flags=lanczos[c];[bg][c]overlay=(W-w)/2:$4"; }

# hook (+loop): 91698 macro eye, iris at source (693,360) -> plate (540,1005)
want hook && ffmpeg -v error -y -t 8 -i $F/pixabay-91698.mp4 -filter_complex "$(CARD 960:720:213:0 1080 810 600)" $ENC assets/hook-v.mp4
# hole: 34848 green eye (blinks), iris at source ~(580,340) -> plate ~(551,982)
want hole && ffmpeg -v error -y -t 8 -i $F/pixabay-34848.mp4 -filter_complex "$(CARD 960:720:100:0 1080 810 600)" $ENC assets/hole-v.mp4
# cover: 1869740 FLIPPED (hand over the eye on the viewer's left = mirror of the viewer's own left eye)
want cover && ffmpeg -v error -y -i $F/pixabay-1869740.jpg -filter_complex "hflip,$(CARDI 900:853:40:0 1080 1024 470)" -q:v 2 assets/cover-v.jpg
# nerve: 31145 eye cross-section (alpha) on black, B&W; optic nerve leaves at source ~(1110,650) -> plate (937,1018)
want nerve && ffmpeg -v error -y -f lavfi -i color=c=black:s=1080x1920 -i $F/pixabay-31145.png -filter_complex "[1]crop=1262:1141:9:9,scale=1080:976:flags=lanczos,format=rgba,hue=s=0,eq=contrast=1.35:brightness=-0.06[e];[0][e]overlay=0:470" -frames:v 1 -q:v 2 assets/nerve-v.jpg
# never: 1694 street, feet walking
want never && ffmpeg -v error -y -t 8 -i $F/pixabay-1694.mp4 -filter_complex "$(CARD 960:720:160:0 1080 810 560)" $ENC assets/never-v.mp4
# brain: 91633 neuron on black, 1.5x square card (black ground blends into the blurred ground)
want brain && ffmpeg -v error -y -t 5.4 -i $F/pixabay-91633.mp4 -filter_complex "$(CARD 720:720:310:0 1080 1080 400)" $ENC assets/brain-v.mp4
# who: 107189 candle + quill (wide)
want who && ffmpeg -v error -y -t 4 -i $F/pixabay-107189.mp4 -filter_complex "$(CARD 960:720:160:0 1080 810 540)" $ENC assets/who-v.mp4
# sci: same clip later (16 s), tighter on the writing hand + quill
want sci && ffmpeg -v error -y -ss 16 -t 3 -i $F/pixabay-107189.mp4 -filter_complex "$(CARD 720:720:500:0 1080 1080 420)" $ENC assets/sci-v.mp4
# years: same clip (31 s), candle flame close
want years && ffmpeg -v error -y -ss 31 -t 4 -i $F/pixabay-107189.mp4 -filter_complex "$(CARD 640:720:150:0 960 1080 420)" $ENC assets/years-v.mp4
# fill: 3382663 field (the hole + fill are drawn in episode.js)
want fill && ffmpeg -v error -y -i $F/pixabay-3382663.jpg -filter_complex "$(CARDI 900:690:190:0 1080 828 520)" -q:v 2 assets/fill-v.jpg

# cover B hero: frame-0 eye (91698 @4.6) square, same B&W grade (cover.html #art)
ffmpeg -v error -y -ss 4.6 -i $F/pixabay-91698.mp4 -frames:v 1 -vf "crop=720:720:333:0,scale=900:900:flags=lanczos,$GR" -q:v 2 assets/cover-eye.jpg
echo ok
