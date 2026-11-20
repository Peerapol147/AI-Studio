#!/usr/bin/env bash
# Rebuilds video/assets/ (gitignored) from ../assets: copies VO/music and bakes every footage plate as a
# 1080x1920 30 fps clip with ONE grade per section (no CSS filters on footage):
#   NIGHT (story h1-s18 + c1): cool teal-blue shadows/mids, warm highlights kept (candle/lantern), grain, vignette
#   PAPER (twist t1-t8b): cream paper, brown ink, light grain
# Only the per-source exposure/curve trim differs. Plates are cut at the source point the shot plays (= shots-th.json
# media_start where it is set: s2_khlong 4.0, s7_out 1.92), so data-media-start in index.html is 0 except canal-v
# (source clock, h1 media_start 0.0) and loop-v (reverse of 159306 0-3.6 s: its LAST frame = source 0.0 = frame 0).
# 159306: the Chinese window lattice + characters sit in source X 0-265 (moving left over time) -> every crop starts at X>=290.
set -e
cd "$(dirname "$0")"; mkdir -p assets
cp ../assets/audio/{vo-th.mp3,music-jamendo-a573d9da.mp3} assets/
F=../assets/footage
ENC="-an -c:v libx264 -preset medium -crf 17 -pix_fmt yuv420p -r 30 -g 6"
night(){ # $1 exposure, $2 extra curve (optional)
  echo "${2:+$2,}eq=brightness=$1:contrast=1.08:saturation=0.72,colorbalance=rs=-0.10:gs=0.02:bs=0.09:rm=-0.08:gm=0.03:bm=0.06:rh=0.05:gh=0.01:bh=-0.05,noise=alls=7:allf=t,vignette=PI/4.2"; }
paper(){ echo "eq=brightness=$1:contrast=1.02:saturation=0.35,colorbalance=rs=0.04:gs=0.02:bs=-0.08:rm=0.07:gm=0.03:bm=-0.10:rh=0.05:gh=0.02:bh=-0.10,noise=alls=5:allf=t,vignette=PI/5"; }
DAY="curves=all='0/0 0.35/0.14 0.7/0.36 1/0.55'"   # daylight -> night (316320 boat, 135760 temple, stilthouse jpg)
plate(){ # name src ss dur crop grade [pre] [post]   (ONLY="a b" bash prep_assets.sh = rebuild just those plates)
  [ -n "$ONLY" ] && [[ " $ONLY " != *" $1 "* ]] && return 0
  ffmpeg -v error -y -ss "$3" -t "$4" -i "$F/$2" -vf "fps=30,${7:+$7,}crop=$5,scale=1080:1920:flags=lanczos,$6${8:+,$8}" $ENC "assets/$1-v.mp4"; }
still(){ # name jpg dur crop grade
  [ -n "$ONLY" ] && [[ " $ONLY " != *" $1 "* ]] && return 0
  ffmpeg -v error -y -loop 1 -t "$3" -i "$F/$2" -vf "fps=30,crop=$4,scale=1080:1920:flags=lanczos,$5" $ENC "assets/$1-v.mp4"; }
# --- story (night) ---
plate canal   pixabay-159306.mp4 0    2.5 440:782:290:170 "$(night -0.02)"            # h1 (source clock 0)
plate loop    pixabay-159306.mp4 0    3.6 440:782:290:170 "$(night -0.02)" "" reverse # c1: ends on source 0.0
plate nameb   pixabay-159306.mp4 2.2  1.5 440:782:290:170 "$(night -0.12),gblur=sigma=14"  # h2 kinetic "มาก?" backdrop
plate moon    pixabay-249590.mp4 0    1.4 810:1440:520:0  "$(night 0.0)"
plate khlong  pixabay-159306.mp4 4.0  1.65 400:711:300:330 "$(night -0.02)"          # s2 media_start 4.0, later + lower (water/reeds)
plate couple  pixabay-82680.mp4  0.5  2.45 608:1080:600:0 "$(night -0.04)"
plate soldier pixabay-217981.mp4 0    2.0 405:720:598:0   "$(night -0.10 'hue=h=170:s=0.5')" "split[a][b];[b]crop=iw:ih*0.36:0:0,gblur=sigma=30[t];[a][t]overlay=0:0"
plate preg    pixabay-228519.mp4 0    1.6 810:1440:60:0   "$(night 0.06)"     # stone house, lit window left
plate candle  pixabay-4926.mp4   1.0  1.35 405:720:330:0  "$(night -0.02)"
plate out     pixabay-175213.mp4 1.92 1.75 810:1440:870:0 "$(night 0.0)"              # s7 media_start 1.92: flame out at source 2.0 = "ตายทั้งกลม"
plate boat    pixabay-316320.mp4 0    1.9 608:1080:440:0  "$(night -0.03 "curves=all='0/0 0.4/0.17 0.8/0.42 1/0.55'")"
plate wait    pixabay-134358.mp4 0.5  1.45 405:720:560:0  "$(night 0.10)"     # dark wooden house only (hooded lantern figure on the left cropped out)
plate neigh   pixabay-228519.mp4 4.0  2.3 810:1440:820:0  "$(night 0.06)"     # lane between houses
plate nope    pixabay-6714.mp4   1.4  2.2 405:720:440:0   "$(night -0.04)" "" reverse # light door closing
plate mortar  pixabay-11690.mp4  1.2  1.25 405:720:470:0  "$(night 0.08 "curves=all='0/0 0.5/0.36 1/0.8'")"
still under   stilthouse-flickr.jpg 1.4 360:640:250:30 "$(night -0.04 "$DAY")"
still under2  stilthouse-flickr.jpg 2.5 300:533:330:150 "$(night -0.08 "$DAY")"
plate temple  pixabay-135760.mp4 0    1.75 540:960:260:480 "$(night 0.06 "curves=all='0/0 0.4/0.2 0.8/0.5 1/0.66'")"
plate storm   pixabay-16160.mp4  0    1.8 405:720:440:0   "$(night 0.04)"
# --- twist (paper) ---
plate paper   pixabay-170043.mp4 0    2.25 405:720:300:0  "$(paper 0.02)"
plate stage   pixabay-145631.mp4 0    1.35 720:720:280:0  "eq=saturation=0.8:brightness=-0.02,colorbalance=rs=0.04:bs=-0.06,noise=alls=5:allf=t" # card, not full frame
# paper still for the twist "desk" (one continuous background)
ffmpeg -v error -y -ss 1.0 -i assets/paper-v.mp4 -frames:v 1 -q:v 3 assets/paper.jpg
# stills for the thumbnail (= frame 0 image)
ffmpeg -v error -y -ss 0 -i assets/canal-v.mp4 -frames:v 1 -q:v 2 assets/canal0.jpg
mkdir -p thumb/assets; cp assets/canal0.jpg thumb/assets/canal-cover.jpg
echo plates ok
