#!/usr/bin/env bash
# Plates 1080x1920 30fps, one grade (ocean-teal "teal cyan underwater"): Pixabay full, NASA light (keep the gold)
set -euo pipefail
cd "$(dirname "$0")"
F=../assets/footage
G_PIX="eq=contrast=1.06:saturation=1.06:gamma=0.98,colorbalance=rs=-0.06:gs=0.01:bs=0.08:rm=-0.03:gm=0.01:bm=0.04:rh=-0.02:bh=0.02"
G_NASA="colorbalance=rs=-0.03:gs=0.0:bs=0.04,eq=contrast=1.04:saturation=1.02,unsharp=5:5:0.5"
plate(){ # out src cropw croph x y dur grade [extra]
  local out=$1 src=$2 w=$3 h=$4 x=$5 y=$6 t=$7 g=$8 extra=${9:-}
  ffmpeg -v error -y -i "$F/$src" -t "$t" -an \
    -vf "crop=$w:$h:$x:$y,scale=1080:1920:flags=lanczos,fps=30,$g${extra:+,$extra},setsar=1,format=yuv420p" \
    -c:v libx264 -preset medium -crf 18 -g 15 -movflags +faststart "assets/$out"
  echo "assets/$out"
}
plate hook.mp4    nasa-sdo-arching-eruption.mp4    405 720  498  0 9  "$G_NASA"
plate storm.mp4   nasa-sdo-phoenix-eruption.mp4    405 720  600  0 6  "$G_NASA"
plate cme.mp4     nasa-sdo-phoenix-limb-flare.mp4  405 720  437  0 6  "$G_NASA"
plate y2012.mp4   nasa-soho-cme-2013.mp4           405 720  437  0 9.5 "$G_NASA"
plate sun.mp4     pixabay-53110.mp4                810 1440 1645 0 16 "$G_PIX" "eq=gamma=1.12"
plate wires.mp4   pixabay-2151.mp4                 607 1080 847  0 5  "$G_PIX"
plate worse.mp4   pixabay-377885.mp4               607 1080 656  0 8  "$G_PIX"
plate miss.mp4    pixabay-5069.mp4                 607 1080 846  0 6  "$G_PIX"
plate aurora.mp4  pixabay-90875.mp4                810 1440 650  0 11.5 "$G_PIX" "eq=gamma=1.08:saturation=1.15"
plate count.mp4   pixabay-90875.mp4                810 1440 0    0 22 "$G_PIX" "eq=gamma=1.08:saturation=1.15"
plate aurora2.mp4 pixabay-218646.mp4               759 1350 1520 810 6 "$G_PIX"
plate ask.mp4     pixabay-169445.mp4               1215 2160 1490 0 7 "$G_PIX"
# blurred sun backgrounds for the 1859 graphics (no footage of 1859 exists)
BL="gblur=sigma=34,eq=brightness=-0.10:saturation=0.9"
plate sunblur-a.mp4 nasa-sdo-phoenix-eruption.mp4  405 720 520 0 2.5 "$G_NASA" "$BL"
plate sunblur-b.mp4 nasa-sdo-phoenix-limb-flare.mp4 405 720 437 0 2.5 "$G_NASA" "$BL"
ffmpeg -v error -y -ss 10 -i "$F/nasa-sdo-arching-eruption.mp4" -t 4 -an \
  -vf "crop=405:720:498:0,scale=1080:1920:flags=lanczos,fps=30,$G_NASA,$BL,setsar=1,format=yuv420p" \
  -c:v libx264 -preset medium -crf 18 -g 15 assets/sunblur-c.mp4 && echo assets/sunblur-c.mp4
cp ../assets/audio/vo-th.mp3 ../assets/audio/music-jamendo-34466c22.mp3 assets/
