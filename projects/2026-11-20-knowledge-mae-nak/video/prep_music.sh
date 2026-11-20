#!/usr/bin/env bash
# Music bed for the sound pass: "Dark Space" by CAIMO1 (CC BY 3.0, https://www.jamendo.com/track/1544453).
# Measured (not heard): energy sits almost all below 120 Hz and the first 60 s carry a steady low pulse every
# ~0.48 s (~123 BPM, kick-like). For a ghost story: high-pass 140 Hz (x2) to take the thump out, keep the pad,
# and drop the bed another 4 dB through the twist (t1 32.04 -> c1 54.76) as storyboard "เสียง" asks.
# The envelope is in video time: cues avoid scene_cut/reveal so sound_pass_vo.py starts the music at offset 0.
set -e; cd "$(dirname "$0")"; mkdir -p assets
ffmpeg -v error -y -t 60 -i ../assets/audio/music-jamendo-a573d9da.mp3 -af "highpass=f=140,highpass=f=140,\
volume='if(lt(t,32.04),1,if(lt(t,32.54),1-0.369*(t-32.04)/0.5,if(lt(t,54.76),0.631,if(lt(t,55.26),0.631+0.369*(t-54.76)/0.5,1))))':eval=frame" \
  -ar 48000 assets/music-bed.wav
ffmpeg -nostats -i assets/music-bed.wav -af ebur128 -f null - 2>&1 | grep -E "^\s+I:" | tail -1
