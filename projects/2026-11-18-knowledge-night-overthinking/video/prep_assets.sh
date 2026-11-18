#!/usr/bin/env bash
# Rebuilds video/assets/ (gitignored) from ../assets: copies the VO, trims the music past its fade-in,
# and makes 1080x1920 9:16 crops of every footage file (same timeline as the source, so data-media-start = shots-th.json media_start).
# No colour work here: the grade lives on each <video> as data-color-grading (hyperframes media-treatment).
set -e
cd "$(dirname "$0")"; mkdir -p assets
cp ../assets/audio/vo-th.mp3 assets/
# music: start 2.5 s into the track (skips the natural fade-in); 30 s is more than the clip needs
ffmpeg -v error -y -ss 2.5 -t 30 -i ../assets/audio/music-jamendo-9e753e56.mp3 -c:a libmp3lame -q:a 2 assets/music-bed.mp3
# crop <name> <source> <crop centre x as a fraction of the source width>
crop(){ local src=../assets/footage/$2
  ffmpeg -v error -y -i "$src" -an -vf "crop=ih*9/16:ih:max(0\,min(iw-ih*9/16\,iw*$3-ih*9/32)):0,scale=1080:1920:flags=lanczos,setsar=1" \
    -c:v libx264 -preset slow -crf 15 -pix_fmt yuv420p -g 6 -movflags +faststart "assets/$1.mp4"; }
crop hook    hook-pixabay-233390.mp4    0.5
crop scroll  scroll-pixabay-169445.mp4  0.47
crop tired   tired-pixabay-44647.mp4    0.47
crop room    room-pixabay-172144.mp4    0.62
crop sleep   sleep-pixabay-42966.mp4    0.37
crop morning morning-pixabay-128321.mp4 0.42
crop write   write-pixabay-100344.mp4   0.58
ls -la assets
