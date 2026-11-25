#!/usr/bin/env bash
# Rebuilds video/assets/ (gitignored): VO + music copies and every footage plate (1080x1920, 30 fps).
# v3 (palette sunrise-coral, grade "warm golden morning"): one warm grade for every plate (WARM below).
# Every plate keeps the SOURCE clock (encoded from source 0, never -ss) so data-media-start = shots-th.json media_start.
# Exception: up-v.mp4 plays source 17.28-18.16 slowed to plate 17.28-18.88 (the hand tilting back = the "flex" shot).
# The 3D hands (Pixabay 32185/32187) are white renders on a cool blue-grey wall: the wall is keyed out by colour
# (wall b>r, hand r>=b), the hand gets a warm skin tint and sits on the palette's warm gradient (bg2 -> bg), its cut-off
# wrist fades into the dark below Y ~1460 (above the app buttons). Overlays (tendon, rings, labels) are in episode.js.
#   bash prep_assets.sh [name ...]   # names: bg palm up none one xray graft fix grip squeeze ball elbow (default: all)
set -e
cd "$(dirname "$0")"; mkdir -p assets
cp ../assets/audio/vo-th.mp3 ../assets/audio/music-jamendo-fb1328d9.mp3 assets/
F=../assets/footage
WARM="eq=contrast=1.06:saturation=1.14:gamma=1.03,colorbalance=rs=0.05:gs=0.0:bs=-0.08:rm=0.07:gm=0.01:bm=-0.07:rh=0.05:gh=0.02:bh=-0.05"
ENC="-an -c:v libx264 -preset medium -crf 18 -pix_fmt yuv420p -r 30 -g 15"
WANT=" ${*:-bg palm up none one xray graft fix grip squeeze ball elbow} "
want(){ [[ "$WANT" == *" $1 "* ]]; }
# hand layer with alpha: $1 = key expression (0..255). Hand tinted to warm skin.
# KA (32187): wall r-b <= -8, hand r-b >= 1. KB (32185): wall near the hand is neutral (r-b ~0) but g > r, hand r > g.
KA="255*clip((r(X,Y)-b(X,Y)+3)/5,0,1)"
KB="255*clip((r(X,Y)-g(X,Y)+0.5*(r(X,Y)-b(X,Y)))/6,0,1)"
HAND(){ echo "format=rgb24,split[hc][hk];[hk]geq=r='$1':g='$1':b='$1',format=gray,erosion,erosion,dilation,dilation,gblur=sigma=1.6[hm];[hc]colorchannelmixer=rr=1.0:gg=0.84:bb=0.72,eq=contrast=1.12:gamma=0.95[ht];[ht][hm]alphamerge"; }

# warm gradient backdrop (palette bg2 #C2453A centre -> bg #2A0F12) + dark fade under the wrist (Y 1330-1470)
if want bg; then
ffmpeg -v error -y -f lavfi -i color=c=black:s=1080x1920:d=1 -vf "format=rgb24,geq=\
r='lerp(194,42,clip(hypot(X-540,(Y-820)*0.75)/1050,0,1))':g='lerp(69,15,clip(hypot(X-540,(Y-820)*0.75)/1050,0,1))':b='lerp(58,18,clip(hypot(X-540,(Y-820)*0.75)/1050,0,1))'" -frames:v 1 assets/bg-warm.png
ffmpeg -v error -y -f lavfi -i color=c=black:s=1080x1920:d=1 -vf "format=rgba,geq=r=42:g=15:b=18:a='255*clip((Y-1330)/140,0,1)'" -frames:v 1 assets/fade-low.png
fi

# palm: 32187 (open palm, fingers left, wrist off the right edge) turned upright (fingers up, thumb on the left),
# whole hand big: x 27-1053, fingertips ~Y 100, wrist at the fade ~Y 1440
if want palm; then ffmpeg -v error -y -t 18.0 -i "$F/pixabay-32187.mp4" -loop 1 -i assets/bg-warm.png -loop 1 -i assets/fade-low.png -filter_complex "\
[0:v]fps=30,transpose=1,scale=1026:1824,$(HAND "$KA")[h];[1:v]fps=30,format=rgb24[bg];[bg][h]overlay=27:-380:shortest=1[c];[c][2:v]overlay=0:0:shortest=1,$WARM" $ENC assets/palm-v.mp4; fi

# up: 32185 (upright hand, palm side, thumb right) at 1.45x, wrist at the fade; source 17.28-18.16 slowed x1.8
if want up; then ffmpeg -v error -y -t 19.2 -i "$F/pixabay-32185.mp4" -loop 1 -i assets/bg-warm.png -loop 1 -i assets/fade-low.png -filter_complex "\
[0:v]fps=30,split[s1][s2];[s1]trim=0:17.28,setpts=PTS-STARTPTS[a];[s2]trim=17.28:18.17,setpts=(PTS-STARTPTS)/0.55[b];[a][b]concat=n=2:v=1[src];\
[src]scale=2784:1566,$(HAND "$KB")[h];[1:v]fps=30,format=rgb24[bg];[bg][h]overlay=-954:-106:shortest=1[c];[c][2:v]overlay=0:0:shortest=1,$WARM,trim=0:19.0" $ENC assets/up-v.mp4; fi

# none: one 3D hand twice side by side (left = mirrored, right = 3 s later), both on the warm gradient
if want none; then ffmpeg -v error -y -t 7.0 -i "$F/pixabay-32185.mp4" -ss 3 -t 7.0 -i "$F/pixabay-32185.mp4" -loop 1 -i assets/bg-warm.png -filter_complex "\
[0:v]fps=30,crop=720:1080:640:0,hflip,scale=560:840,$(HAND "$KB")[L];[1:v]fps=30,setpts=PTS-STARTPTS,crop=720:1080:640:0,scale=560:840,$(HAND "$KB")[R];\
[2:v]fps=30,format=rgb24[bg];[bg][L]overlay=-20:250:shortest=1[b1];[b1][R]overlay=540:250:shortest=1,$WARM" $ENC assets/none-v.mp4; fi

# one: the same person's two palms (32187): top = source, bottom = mirrored
if want one; then ffmpeg -v error -y -t 8.2 -i "$F/pixabay-32187.mp4" -loop 1 -i assets/bg-warm.png -filter_complex "\
[0:v]fps=30,crop=1520:1080:400:0,scale=1080:768,$(HAND "$KA"),split[T][B0];[B0]hflip[B];\
[1:v]fps=30,format=rgb24[bg];[bg][T]overlay=0:170:shortest=1[b1];[b1][B]overlay=0:1290:shortest=1,$WARM" $ENC assets/one-v.mp4; fi

# xray: 177206 turned upright, negated (dark ground, light bones) and toned warm (dark maroon -> cream)
if want xray; then ffmpeg -v error -y -t 7.0 -i "$F/pixabay-177206.mp4" -vf "fps=30,transpose=2,negate,hue=s=0,eq=contrast=1.45:brightness=-0.06,\
scale=918:1632,crop=918:1482:0:150,pad=1080:1920:81:0:black,colorchannelmixer=rr=1.0:gg=0.86:bb=0.70,colorbalance=rs=0.12:bs=-0.05" $ENC assets/xray-v.mp4; fi

# graft: surgical team (238889), right part of the frame (faces, hands, instrument)
if want graft; then ffmpeg -v error -y -t 4.0 -i "$F/pixabay-238889.mp4" -vf "fps=30,crop=810:1440:1150:0,scale=1080:1920,$WARM,eq=brightness=-0.04" $ENC assets/graft-v.mp4; fi

# fix: surgeon (378726) face in the top half; the repair diagram sits below it
if want fix; then ffmpeg -v error -y -t 8.0 -i "$F/pixabay-378726.mp4" -vf "fps=30,crop=608:1080:1000:0,scale=1080:1920,$WARM,eq=brightness=-0.05" $ENC assets/fix-v.mp4; fi

# grip: hand takes the mug (9830 ~14.4 s), card cropped below the face on its own blurred copy
if want grip; then ffmpeg -v error -y -t 16.0 -i "$F/pixabay-9830.mp4" -filter_complex "\
[0:v]fps=30,$WARM,crop=900:860:640:210,split[a][b];[a]scale=1080:1920:force_original_aspect_ratio=increase,crop=1080:1920,gblur=sigma=40,eq=brightness=-0.18[bg];\
[b]scale=1000:956:flags=lanczos[card];[bg]drawbox=x=50:y=176:w=1000:h=956:color=black@0.55:t=fill[bg2];[bg2][card]overlay=40:150" $ENC assets/grip-v.mp4; fi

# squeeze: both hands wrapped round a warm mug (375102, 720x1280) at 1.7x, hands at Y ~700-1050
if want squeeze; then ffmpeg -v error -y -t 4.0 -i "$F/pixabay-375102.mp4" -vf "fps=30,scale=1224:2176,crop=1080:1920:0:380,$WARM" $ENC assets/squeeze-v.mp4; fi

# soft-edged blur patch (hides letters/logos): $1 w, $2 h, $3 x, $4 y, $5 in label, $6 out label
FEATHER="format=yuva420p,geq=lum='lum(X,Y)':cb='cb(X,Y)':cr='cr(X,Y)':a='255*clip(min(min(X,W-X),min(Y,H-Y))/22,0,1)'"
PATCH(){ echo "[$5]split[$6a][$6b];[$6b]crop=$1:$2:$3:$4,gblur=sigma=12,$FEATHER[$6p];[$6a][$6p]overlay=$3:$4[$6]"; }

# ball: 1479770 (pitcher, ball just released) as a card on its own blur; cap logo, jersey letters, glove + shoe logos blurred
if want ball; then ffmpeg -v error -y -i "$F/pixabay-1479770.jpg" -filter_complex "\
$(PATCH 110 80 450 160 0:v s1);$(PATCH 200 140 440 400 s1 s2);$(PATCH 140 120 520 430 s2 s3);$(PATCH 140 90 1080 750 s3 s4);$(PATCH 110 70 380 900 s4 s5);\
[s5]$WARM,split[a][b];[a]scale=1080:1920:force_original_aspect_ratio=increase,crop=1080:1920,gblur=sigma=40,eq=brightness=-0.2[bg];[b]crop=1100:1024:120:0,scale=1060:987:flags=lanczos[card];\
[bg]drawbox=x=30:y=206:w=1060:h=987:color=black@0.55:t=fill[bg2];[bg2][card]overlay=10:180" -q:v 2 assets/ball-v.jpg; fi

# elbow: 7295619 full frame (portrait), club letters on cap + jersey and maker logos blurred
if want elbow; then ffmpeg -v error -y -i "$F/pixabay-7295619.jpg" -filter_complex "\
$(PATCH 240 150 270 380 0:v s1);$(PATCH 130 100 305 185 s1 s2);$(PATCH 70 60 340 340 s2 s3);$(PATCH 100 90 685 325 s3 s4);$(PATCH 90 70 675 900 s4 s5);\
[s5]$WARM,crop=720:1280:20:0,scale=1080:1920:flags=lanczos" -q:v 2 assets/elbow-v.jpg; fi
echo ok
