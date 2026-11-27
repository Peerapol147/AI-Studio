#!/usr/bin/env bash
# Rebuilds video/assets/ plates from ../assets/footage. One grade for the whole clip (mono-yellow "high contrast black
# and white" + the director's note: dark, contrasty, warm lamp light): saturation 0.35, contrast up, warm balance.
# Night plates get the darker gamma, morning/day plates are lifted. Video plates keep the source clock (start at
# source 0) so data-media-start = shots-th.json media_start.
set -e
cd "$(dirname "$0")"; mkdir -p assets
cp ../assets/audio/vo-th.mp3 ../assets/audio/music-jamendo-b386828e.mp3 assets/
F=../assets/footage
BASE="eq=contrast=1.22:saturation=0.35,colorbalance=rs=0.07:gs=0.02:bs=-0.09:rm=0.06:gm=0.01:bm=-0.07:rh=0.03:bh=-0.07"
NIGHT="$BASE,eq=brightness=-0.05:gamma=0.82,vignette=PI/5"
DAY="$BASE,eq=brightness=0.03:gamma=1.04,vignette=PI/7"
ENC="-an -c:v libx264 -preset medium -crf 18 -pix_fmt yuv420p -r 30 -g 6"
vplate(){ # name src crop(w:h:x:y) grade seconds
  ffmpeg -v error -y -t "$5" -i "$F/$2" -vf "fps=30,crop=$3,scale=1080:1920:flags=lanczos,$4" $ENC "assets/$1.mp4"; }
vplate hook        pixabay-233390.mp4 1440:2560:0:0   "$NIGHT" 6
vplate setup_yawn  pixabay-44647.mp4  810:1440:742:0  "$NIGHT" 5
vplate reveal_time pixabay-26452.mp4  608:1080:666:0  "$NIGHT" 4
vplate revenge     pixabay-42408.mp4  608:1080:480:0  "$BASE,eq=brightness=0.06:gamma=1.1,vignette=PI/5" 3
vplate who         pixabay-142641.mp4 810:1440:700:0  "$DAY"   3
vplate work        pixabay-7269.mp4   608:1080:1080:0 "$DAY"   3
vplate rush        pixabay-1694.mp4   608:1080:950:0  "$DAY"   3
vplate night_me    pixabay-202987.mp4 810:1440:870:0  "$NIGHT" 3
vplate tired       pixabay-151295.mp4 810:1440:1200:0 "$DAY"   6
vplate twist_me    pixabay-31672.mp4  608:1080:650:0  "$DAY"   4
vplate tip         pixabay-20156.mp4  810:1440:700:0  "$BASE"  4
vplate tip_alarm   pixabay-15629.mp4  810:1440:1585:0 "$DAY"   3
# cta: crop keeps the bed, pillow and wall lamp, the window (lightning outside) is left out of frame
vplate cta         pixabay-120483.mp4 450:800:0:280   "$NIGHT" 3
# hook_awake: a square card (man + glowing phone both in frame) over a blurred copy of itself
ffmpeg -v error -y -t 5 -i "$F/pixabay-61298.mp4" -filter_complex "[0:v]fps=30,split[a][b];\
[a]crop=810:1440:900:0,scale=1080:1920,gblur=sigma=34,$NIGHT,eq=brightness=-0.08[bg];\
[b]crop=1440:1440:100:0,scale=820:-2:flags=lanczos,$NIGHT[fg];[bg][fg]overlay=(W-w)/2:1060-h/2" $ENC assets/hook_awake.mp4
# name: night_me clip, a later section (5 s on) with another crop, blurred: the plate under the "มีชื่อเรียก" sign
ffmpeg -v error -y -ss 5 -t 2 -i "$F/pixabay-202987.mp4" -vf "fps=30,crop=810:1440:1300:0,scale=1080:1920,gblur=sigma=14,$NIGHT,eq=brightness=0.02" $ENC assets/name.mp4
# twist: source is 8.8 s long but the shot needs media 7.42-10.1: the sunrise part plays as is, the 7:00 alarm clock
# part (8.0-8.8) is slowed 2.7x so it holds to the end of the shot (720p source -> 405x720 crop, sharpened a little)
ffmpeg -v error -y -i "$F/pixabay-729.mp4" -filter_complex "[0:v]crop=405:720:170:0,scale=1080:1920:flags=lanczos,unsharp=5:5:0.6,split[a][b];\
[a]trim=0:8.0,setpts=PTS-STARTPTS[x];[b]trim=8.0:8.8,setpts=(PTS-STARTPTS)*2.7[y];[x][y]concat=n=2:v=1,fps=30,$DAY,eq=brightness=-0.05" $ENC assets/twist.mp4
ls -la assets
