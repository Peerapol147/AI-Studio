#!/usr/bin/env bash
# Rebuilds video/assets/ (gitignored) from ../assets: the voice for the preview/render timeline.
# No footage in this episode (own motion graphics only). User stills (../assets/stills/S#.*) are copied by build_index.py.
set -e
cd "$(dirname "$0")"; mkdir -p assets
cp ../assets/audio/vo-th.mp3 assets/
