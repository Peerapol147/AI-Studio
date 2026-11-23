#!/usr/bin/env bash
# tile stills into review sheets of 9 (3x3, 640 px wide each, file name burned in): bash tile.sh <stills dir> <out prefix>
set -euo pipefail
d="$1"; out="$2"; i=0; n=0; files=("$d"/*.jpg); rm -f "$out"-*.jpg
while [ $i -lt ${#files[@]} ]; do
  args=(); fc=""; k=0
  for f in "${files[@]:$i:9}"; do b=$(basename "$f" .jpg); args+=(-i "$f"); fc+="[$k:v]scale=640:-2,drawtext=text='${b}':x=8:y=8:fontsize=22:fontcolor=yellow:box=1:boxcolor=black@0.6[v$k];"; k=$((k+1)); done
  ins=""; for j in $(seq 0 $((k-1))); do ins+="[v$j]"; done
  lay="0_0|w0_0|w0+w1_0|0_h0|w0_h0|w0+w1_h0|0_h0+h3|w0_h0+h3|w0+w1_h0+h3"; lay=$(echo "$lay" | cut -d'|' -f1-$k)
  if [ $k -eq 1 ]; then ffmpeg -v error -y "${args[@]}" -filter_complex "${fc%;}" -map "[v0]" -frames:v 1 "$out-$(printf %02d $n).jpg"; else
  ffmpeg -v error -y "${args[@]}" -filter_complex "${fc}${ins}xstack=inputs=$k:layout=$lay:fill=gray" -frames:v 1 -q:v 3 "$out-$(printf %02d $n).jpg"; fi
  i=$((i+9)); n=$((n+1))
done
ls "$out"-*.jpg
