#!/usr/bin/env bash
# contact sheet (6 columns): bash anime/sheet.sh <out.jpg> <t1,t2,...>
set -euo pipefail
here="$(cd "$(dirname "$0")" && pwd)"; out="$1"; times="$2"
tmp="$(mktemp -d)"; node "$here/render.js" stills "$tmp" "$times"
ffmpeg -v error -y -pattern_type glob -i "$tmp/*.jpg" -vf "scale=270:-1,tile=6x4:padding=6:color=white" -frames:v 1 "$out"
ls "$tmp" | tr '\n' ' '; echo; rm -rf "$tmp"
