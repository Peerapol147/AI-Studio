#!/usr/bin/env bash
# Rebuilds video/assets/ (gitignored) from ../assets: VO, music, and the Fuseli still
# (band crop = the sleeper + the figure on her chest, shown over a blurred fill of the same painting).
set -e
cd "$(dirname "$0")"; mkdir -p assets; cp ../assets/audio/{vo-th.mp3,music-jamendo-165c7963.mp3} assets/
cd assets
SRC=../../assets/footage/belief-wikimedia-nightmare.jpg
ffmpeg -v error -y -i $SRC -vf "crop=1280:1160:640:90,scale=1080:-2" -q:v 2 belief-crop.jpg
ffmpeg -v error -y -i $SRC -vf "scale=1080:1920:force_original_aspect_ratio=increase,crop=1080:1920,gblur=sigma=45,eq=brightness=-0.16:saturation=0.7" -q:v 5 belief-fill.jpg
