#!/usr/bin/env bash
# vertical (9:16) review sheets: 12 per sheet (6x2, 320x569 each): bash tileV.sh <dir> <out prefix> [first] [last]
set -euo pipefail
d="$1"; out="$2"; a="${3:-1}"; b="${4:-999}"; tmp="$(mktemp -d)"; i=0
for f in $(ls "$d"/*.jpg | sed -n "${a},${b}p"); do b2=$(basename "$f" .jpg); ffmpeg -v error -y -i "$f" -vf "scale=320:568,drawtext=text='${b2}':x=3:y=3:fontsize=14:fontcolor=yellow:box=1:boxcolor=black@0.6" "$tmp/$(printf %04d $i).jpg"; i=$((i+1)); done
rm -f "$out"-*.jpg; ffmpeg -v error -y -framerate 1 -i "$tmp/%04d.jpg" -vf "tile=6x2" -q:v 3 "$out-%02d.jpg"; rm -rf "$tmp"; ls "$out"-*.jpg
