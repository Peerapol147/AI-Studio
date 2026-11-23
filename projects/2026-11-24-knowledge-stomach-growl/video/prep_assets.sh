#!/usr/bin/env bash
# Rebuilds video/assets/ (gitignored) from ../assets: copies VO + music and bakes every footage plate as a
# 1080x1920 30 fps clip with ONE grade for the whole clip (palette retro-cream grade "retro film faded warm"):
#   LUT .media/luts/grade_001.cube (`hyperframes media-use resolve --type grade --intent "retro film faded warm"`,
#   film-fade, intensity 0.75 via lut3d mix) + the same eq on every plate; only the exposure trim differs.
# Plates keep the SOURCE clock (start at source 0) so data-media-start = shots-th.json media_start.
# loop uses the hook plate (build_index sets media_start = 8.0 - loop length). assume = graphic (source looks AI).
set -e
cd "$(dirname "$0")"; mkdir -p assets
cp ../assets/audio/vo-th.mp3 ../assets/audio/music-jamendo-0e1622b6.mp3 assets/
F=../assets/footage; LUT=.media/luts/grade_001.cube
[ -f "$LUT" ] || npx --yes hyperframes@0.9.61 media-use resolve --type grade --intent "retro film faded warm"
ENC="-an -c:v libx264 -preset medium -crf 17 -pix_fmt yuv420p -r 30 -g 6"
grade(){ echo "split[a][b];[b]lut3d=file=$LUT[l];[a][l]blend=all_mode=normal:all_opacity=0.75,eq=brightness=$1:contrast=1.04:saturation=0.9,vignette=PI/6"; }
plate(){ # name src dur crop exposure
  ffmpeg -v error -y -t "$3" -i "$F/$2" -filter_complex "[0:v]fps=30,crop=$4,scale=1080:1920:flags=lanczos,format=gbrp,$(grade $5),format=yuv420p[o]" -map "[o]" $ENC "assets/$1-v.mp4"; }
# hook: hands on belly at 8.0 s, crop 810x1440 @ x 735 so the hands sit centre, Y ~530-1600
plate hook    pixabay-168342.mp4 9.6  810:1440:735:0   0.0
plate plate   pixabay-2339.mp4   3.7  405:720:380:0    0.02
plate think   pixabay-25033.mp4  4.4  405:720:440:0    0.05
plate anatomy pixabay-84372.mp4  3.3  405:720:490:0    -0.02
plate full    pixabay-129236.mp4 5.3  405:720:340:0    0.0
plate empty   pixabay-199841.mp4 3.8  810:1440:1000:0  0.0
plate loud    pixabay-2340.mp4   3.2  405:720:700:0    -0.06
# ask: the source girl turns away ~1.7 s after media_start 0.42 -> keep the source clock up to 0.42 (so
# data-media-start = 0.42 still lands on the laugh), then play at half speed so the 2.5 s shot stays on the laugh
ffmpeg -v error -y -t 1.9 -i "$F/pixabay-40.mp4" -filter_complex "[0:v]setpts='if(lt(T,0.42),PTS,(0.42+(T-0.42)*2)/TB)',fps=30,crop=405:720:200:0,scale=1080:1920:flags=lanczos,format=gbrp,$(grade 0.0),format=yuv420p[o]" -map "[o]" $ENC assets/ask-v.mp4
