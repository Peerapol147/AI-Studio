#!/usr/bin/env bash
# Rebuilds video/assets/ (gitignored) from ../assets: copies VO/music and bakes every footage plate as a
# 1080x1920 30 fps clip. Two looks only:
#   night = LUT .media/luts/grade_001.cube (media-use "cool blue purple night", from the template) + dark indigo trim
#   warm  = dark warm gold (Buddha / heaven / candle), heavy vignette
# Source in-points = media_start that tools/shot_times.py computes from footage.json action_at
# (s1 3.92, s2 3.92, s4 5.92, s5 2.82, s9 0.92, s12 0.92, s13 1.92, s14 0.92; h1 = 0 from shots.json).
# hook-v.mp4 keeps the source clock (starts at source 0) so data-media-start = shots-th media_start 0.
# loop-v.mp4 = the same crop, source 0..3.2 REVERSED: the clip's last frame is source ~0 = the frame-0 image.
set -e
cd "$(dirname "$0")"; mkdir -p assets
cp ../assets/audio/{vo-th.mp3,music-jamendo-d3803fc4.mp3} assets/
F=../assets/footage; LUT=.media/luts/grade_001.cube
ENC="-an -c:v libx264 -preset medium -crf 19 -pix_fmt yuv420p -r 30 -g 6"
# night: painterly river -> real night: saturation down, brightness down, indigo push, heavy vignette (grain = overlay in index.html)
night(){ echo "lut3d=file=$LUT,eq=brightness=$1:contrast=1.08:saturation=0.62:gamma=0.86,colorbalance=rs=-0.08:gs=-0.05:bs=0.10:rm=-0.04:gm=-0.04:bm=0.08:rh=-0.06:gh=-0.04:bh=0.02,vignette=PI/3.6"; }
warm(){ echo "eq=brightness=$1:contrast=1.12:saturation=0.78:gamma=0.82,colorbalance=rs=0.05:gs=0.0:bs=-0.08:rm=0.06:gm=0.01:bm=-0.08,vignette=PI/3.2"; }
plate(){ # name src ss dur pre-filter(crop/scale to 1080x1920) look exposure [post]
  ffmpeg -v error -y -ss "$3" -t "$4" -i "$F/$2" -vf "fps=30,$5,$($6 $7)${8:+,$8}" $ENC "assets/$1-v.mp4"; }
RIV="crop=864:1536:108:384,scale=1080:1920:flags=lanczos"         # water fills Y ~980-1920, moon up at Y ~270
DEEP="crop=648:1152:216:768,scale=1080:1920:flags=lanczos"        # water only (t3 gas backdrop)
plate hook    river_moon_v.mp4    0     2.6  "$RIV"                             night -0.10
ffmpeg -v error -y -ss 0 -t 3.2 -i $F/river_moon_v.mp4 -vf "fps=30,$RIV,$(night -0.10),reverse" $ENC assets/loop-v.mp4
plate moon    moon_clouds_v.mp4   3.92  2.7  "scale=1080:1920"                  night -0.06
plate mekong  river_moon_v.mp4    3.92  1.0  "scale=1080:1920"                  night -0.12
plate dusk    dusk_to_night_v.mp4 5.92  4.0  "scale=1080:1920"                  night -0.02 "setpts=PTS/2"
plate orb     river_moon_v.mp4    2.82  2.85 "$RIV"                             night -0.16
plate riverbg river_moon_v.mp4    6.0   7.5  "$RIV"                             night -0.24
plate gasbg   river_moon_v.mp4    8.0   1.85 "$DEEP"                            night -0.30
plate candles candles_water_v.mp4 0.92  2.3  "scale=1080:1920"                  night -0.04
# Buddha: whole statue kept (scaled to 88% on black so the push-in never cuts the crown), aurora desaturated + toned gold + crushed by curves -> reads as a dim halo
buddha(){ echo "hue=s=0.2,colorchannelmixer=.62:.48:.12:0:.48:.42:.09:0:.26:.22:.06:0,curves=all='0/0 0.25/0.04 0.5/0.36 0.75/0.75 1/1',eq=contrast=1.1,vignette=PI/2.7"; }
plate buddha  golden_buddha_v.mp4 0.92  2.05 "scale=950:1690,pad=1080:1920:65:150:black" buddha
plate heaven  sky_rays_v.mp4      1.92  1.5  "scale=1080:1920"                  warm -0.14
plate candle  hands_candle_v.mp4  0.92  2.4  "scale=1080:1920"                  warm -0.02
# grain tile for the registry grain-overlay (seekable version), deterministic seed
ffmpeg -v error -y -f lavfi -i "color=c=gray:s=512x512,noise=alls=60:allf=u:all_seed=7,format=gray" -frames:v 1 assets/grain.png
# stills: frame-0 image for the thumbnail
ffmpeg -v error -y -ss 0 -i assets/hook-v.mp4 -frames:v 1 -q:v 2 assets/hook0.jpg
mkdir -p thumb/assets; cp assets/hook0.jpg thumb/assets/hook-cover.jpg
