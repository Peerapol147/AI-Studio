#!/usr/bin/env bash
# compact review sheets: 16 stills per sheet (4x4, 480 px each, shot name burned in): bash tile16.sh <dir> <out prefix> [first] [last]
set -euo pipefail
d="$1"; out="$2"; a="${3:-1}"; b="${4:-999}"; tmp="$(mktemp -d)"; i=0
for f in $(ls "$d"/*.jpg | sed -n "${a},${b}p"); do b2=$(basename "$f" .jpg); ffmpeg -v error -y -i "$f" -vf "scale=480:270:force_original_aspect_ratio=decrease,pad=480:270:(ow-iw)/2:(oh-ih)/2,drawtext=text='${b2}':x=4:y=4:fontsize=17:fontcolor=yellow:box=1:boxcolor=black@0.6" "$tmp/$(printf %04d $i).jpg"; i=$((i+1)); done
rm -f "$out"-*.jpg; ffmpeg -v error -y -framerate 1 -i "$tmp/%04d.jpg" -vf "tile=4x4" -q:v 3 "$out-%02d.jpg"; rm -rf "$tmp"; ls "$out"-*.jpg
