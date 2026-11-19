#!/usr/bin/env bash
# Rebuilds video/assets/ (gitignored) from ../assets: copies VO/music, makes the focus crops of the stills
# (each still is shown as a band over its own blurred fill, never upscaled to full frame), the blurred fills,
# and the footage bands (crop + scale + 30 fps, kept from 0 s so data-media-start = the source time).
set -e
cd "$(dirname "$0")"; mkdir -p assets
cp ../assets/audio/vo-th.mp3 ../assets/audio/music-jamendo-2f1bc5f2.mp3 assets/
cp ../../../assets/vendor/flubber.min.js assets/
F=../assets/footage
cd assets
fill(){ ffmpeg -v error -y -i "$1" -vf "scale=1080:1920:force_original_aspect_ratio=increase,crop=1080:1920,gblur=sigma=45,eq=brightness=-0.13:saturation=0.85" -q:v 5 "$2"; }
mk(){ ffmpeg -v error -y -i "$2" -vf "crop=$3,scale=$4" -q:v 2 "$1-crop.jpg"; fill "$2" "$1-fill.jpg"; }
mk hook ../$F/pixabay-4245628.jpg 740:813:320:40 1080:1187     # man in a one-leg squat: face + bent knee
mk xray ../$F/pixabay-5314881.jpg 960:1280:0:0 1080:1440        # knee x-ray, whole image
mk pain ../$F/pixabay-10309879.jpg 900:900:330:60 1080:1080     # hands on the knee
# footage: from 0 s to the end of the used range (+0.6 s), so the timing stays in source seconds
vid(){ # name src crop scale until
  ffmpeg -v error -y -i "../$F/$2" -t "$5" -vf "crop=$3,scale=$4,fps=30" -an -c:v libx264 -crf 18 -preset veryfast -pix_fmt yuv420p -g 15 "$1.mp4"
  ffmpeg -v error -y -ss 0.5 -i "$1.mp4" -frames:v 1 -q:v 3 "$1-still.jpg"; fill "$1-still.jpg" "$1-fill.jpg"; rm "$1-still.jpg"; }
vid common pixabay-32937.mp4 864:1080:900:0 1080:1350 1.6     # seniors stretching, the man in yellow centred
vid nopain pixabay-11506.mp4 640:640:820:440 1080:1080 4.4     # deep squat 2.3-3.8 s, crop on the legs/knees so the kettlebells stay out
vid study pixabay-143379.mp4 864:1080:900:0 1080:1350 2.2     # lab sample tubes
vid doctor pixabay-229071.mp4 864:1080:250:0 1080:1350 1.6    # nurse holding the knee and shin
ls -la
