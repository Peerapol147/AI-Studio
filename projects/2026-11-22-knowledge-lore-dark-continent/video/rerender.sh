#!/usr/bin/env bash
# One command: rebuild the page (picks up ../assets/stills/S#.png|jpg|jpeg|webp if present), render, mix, export the thumbnail.
# Run from anywhere:  bash projects/2026-11-22-knowledge-lore-dark-continent/video/rerender.sh
# Output: ../renders/lore-dark-continent-th.mp4 (+ -thumb.jpg), sound report in ../renders/sound-th/SOUND.md
set -euo pipefail
V="$(cd "$(dirname "$0")" && pwd)"; P="$(dirname "$V")"; R="$(cd "$P/../.." && pwd)"
CLI="$R/.claude/skills/hyperframes/scripts/plugin-cli.mjs"
cd "$V"
bash prep_assets.sh
python3 prep_footage.py   # graded 9:16 footage proxies -> video/assets/footage (gitignored)
python3 build_index.py
python3 sound/make_cues.py
mkdir -p "$P/renders"
node "$CLI" render -o "$P/renders/lore-dark-continent-th-silent.mp4" -q delivery --skill=hyperframes
cd "$P"
python3 "$R/tools/sound_pass_vo.py" --video renders/lore-dark-continent-th-silent.mp4 --voice assets/audio/vo-th.mp3 \
  --cues video/sound/cues-th.json --music assets/audio/music-jamendo-a573d9da.mp3 \
  --manifest "$R/.claude/skills/sound-effects/sfx/manifest.json" --out renders/sound-th \
  --music-source "Dark Space by CAIMO1 https://www.jamendo.com/track/1544453" --music-license "CC BY 3.0" \
  --use-case "YouTube Shorts, TikTok, Facebook/Instagram Reels"
cp renders/sound-th/after.mp4 renders/lore-dark-continent-th.mp4
rm -f renders/lore-dark-continent-th-silent.mp4
# thumbnail (own graphic, unchanged by stills): 1 frame -> jpg (< 2 MB)
if [ ! -f renders/lore-dark-continent-th-thumb.jpg ]; then
  ( cd "$V/thumb" && node "$CLI" render -o "$P/renders/thumb.mp4" -q delivery --skill=hyperframes )
  ffmpeg -v error -y -ss 0.5 -i renders/thumb.mp4 -frames:v 1 -q:v 2 renders/lore-dark-continent-th-thumb.jpg && rm -f renders/thumb.mp4
fi
ffprobe -v error -show_entries format=duration -of csv=p=0 renders/lore-dark-continent-th.mp4
ffmpeg -nostats -i renders/lore-dark-continent-th.mp4 -af ebur128=peak=true -f null - 2>&1 | grep -E "I:|Peak:" | tail -2
