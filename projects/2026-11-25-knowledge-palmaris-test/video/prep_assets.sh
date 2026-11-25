#!/usr/bin/env bash
# Rebuilds video/assets/ (gitignored): VO + music copies and every footage plate (1080x1920, 30 fps).
# One grade for all = palette mono-yellow "high contrast black and white" (hue=s=0 + contrast curves).
# Every plate keeps the SOURCE clock (encoded from source 0, never -ss) so data-media-start = shots-th.json media_start.
# The 3D hands (Pixabay 32185/32187) are white on a light blue-grey studio wall: in black and white the hand and the wall
# have the same brightness, so the wall is keyed out by colour (wall is cool b>r, the hand is warm r>b) and pushed to
# near black -> white hand on black, same look as the drawn hands. Overlays (tendon, labels) are drawn in episode.js.
#   bash prep_assets.sh [name ...]     # names: xray none one grip graft fix ball (default: all)
set -e
cd "$(dirname "$0")"; mkdir -p assets
cp ../assets/audio/vo-th.mp3 ../assets/audio/music-jamendo-fb1328d9.mp3 assets/
F=../assets/footage
GRADE="hue=s=0,eq=contrast=1.35:brightness=0.03,curves=preset=increase_contrast"
ENC="-an -c:v libx264 -preset medium -crf 18 -pix_fmt yuv420p -r 30 -g 15"
WANT=" ${*:-xray none one grip graft fix ball} "
want(){ [[ "$WANT" == *" $1 "* ]]; }
# key the cool studio wall of the 3D hand renders to near black ($1 offset, $2 softness, $3 contrast)
KEY(){ local e="255*clip((r(X,Y)-b(X,Y)+$1)/$2,0,1)"; echo "split[ka][kb];[ka]format=rgb24,geq=r='$e':g='$e':b='$e',format=gray,dilation,dilation,dilation,dilation,erosion,erosion,erosion,erosion,gblur=sigma=3[km];[kb]format=gray,eq=contrast=$3:brightness=0.04[kl];[kl][km]blend=all_expr='A*(0.10+0.90*B/255)',format=yuv420p"; }
# card on a blurred, darkened copy of itself: $1 crop (w:h:x:y of the source), $2 card w, $3 card h, $4 x, $5 y
CARD(){ echo "fps=30,$GRADE,crop=$1,split[a][b];[a]scale=1080:1920:force_original_aspect_ratio=increase,crop=1080:1920,gblur=sigma=40,eq=brightness=-0.22[bg];[b]scale=$2:$3:flags=lanczos[card];[bg]drawbox=x=$(($4+10)):y=$(($5+26)):w=$2:h=$3:color=black@0.6:t=fill[bg2];[bg2][card]overlay=$4:$5"; }
# soft-edged blur patch (hides letters/logos): $1 w, $2 h, $3 x, $4 y, $5 in label, $6 out label
FEATHER="format=yuva420p,geq=lum='lum(X,Y)':cb='cb(X,Y)':cr='cr(X,Y)':a='255*clip(min(min(X,W-X),min(Y,H-Y))/22,0,1)'"
PATCH(){ echo "[$5]split[$6a][$6b];[$6b]crop=$1:$2:$3:$4,gblur=sigma=10,$FEATHER[$6p];[$6a][$6p]overlay=$3:$4[$6]"; }

# muscle / rare: x-ray hand (177206) turned upright, negated (dark ground, light bones = a real x-ray), fingertips
# trimmed so the wrist sits at Y ~990 above the captions; forearm runs down to Y ~1480 (episode.js fades the rest)
if want xray; then ffmpeg -v error -y -t 5.4 -i "$F/pixabay-177206.mp4" -vf "fps=30,transpose=2,negate,hue=s=0,eq=contrast=1.45:brightness=-0.06,\
scale=918:1632,crop=918:1482:0:150,pad=1080:1920:81:0:black" $ENC assets/xray-v.mp4; fi

# none: one 3D hand twice side by side (left = mirrored on the source clock, right = unmirrored 3 s later = "another
# person"); thumbs point outwards so the pair does not read as one shape
if want none; then ffmpeg -v error -y -t 6.0 -i "$F/pixabay-32185.mp4" -ss 3 -t 6.0 -i "$F/pixabay-32185.mp4" -filter_complex "\
[0:v]fps=30,crop=720:1080:640:0,hflip,scale=536:804,$(KEY 1 9 1.25)[L];[1:v]fps=30,setpts=PTS-STARTPTS,crop=720:1080:640:0,scale=536:804,$(KEY 1 9 1.25)[R];\
color=c=0x141414:s=1080x1920:r=30:d=6[bg];[bg][L]overlay=0:260:shortest=1[b1];[b1][R]overlay=544:260:shortest=1" $ENC assets/none-v.mp4; fi

# one: the same person's two palms (32187): top = source, bottom = mirrored; dark band between for captions/labels
if want one; then ffmpeg -v error -y -t 8.2 -i "$F/pixabay-32187.mp4" -filter_complex "\
[0:v]fps=30,crop=1520:1080:400:0,scale=1080:768,$(KEY 10 8 1.05),split[T][B0];[B0]hflip[B];\
color=c=0x141414:s=1080x1920:r=30:d=8.2[bg];[bg][T]overlay=0:170:shortest=1[b1];[b1][B]overlay=0:1310:shortest=1" $ENC assets/one-v.mp4; fi

# grip: hand takes the mug (9830 ~15.4 s), card cropped below the face (shirt + table only)
if want grip; then ffmpeg -v error -y -t 18.0 -i "$F/pixabay-9830.mp4" -vf "$(CARD 900:860:640:210 960 917 60 160)" $ENC assets/grip-v.mp4; fi

# graft: surgical team (238889) full frame, darkened under the drawn arm
if want graft; then ffmpeg -v error -y -t 4.8 -i "$F/pixabay-238889.mp4" -vf "fps=30,crop=810:1440:1150:0,scale=1080:1920,$GRADE,eq=brightness=-0.20" $ENC assets/graft-v.mp4; fi

# fix: surgeon (378726), soft + dark behind the repair diagram
if want fix; then ffmpeg -v error -y -t 7.9 -i "$F/pixabay-378726.mp4" -vf "fps=30,crop=608:1080:640:0,scale=1080:1920,$GRADE,gblur=sigma=3,eq=brightness=-0.18" $ENC assets/fix-v.mp4; fi

# ball: still (7295619) as a card on its own blur; club letters on cap + jersey and the maker logo blurred out
if want ball; then ffmpeg -v error -y -i "$F/pixabay-7295619.jpg" -filter_complex "\
$(PATCH 240 150 270 380 0:v s1);$(PATCH 130 100 305 185 s1 s2);\
[s2]hue=s=0,eq=contrast=1.3:brightness=0.02,curves=preset=increase_contrast,crop=955:1060:0:20,split[a][b];\
[a]scale=1080:1920:force_original_aspect_ratio=increase,crop=1080:1920,gblur=sigma=40,eq=brightness=-0.25[bg];[b]scale=1000:1110:flags=lanczos[card];\
[bg]drawbox=x=50:y=146:w=1000:h=1110:color=black@0.6:t=fill[bg2];[bg2][card]overlay=40:120" -q:v 2 assets/ball-v.jpg; fi
echo ok
