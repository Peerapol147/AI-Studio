#!/usr/bin/env python3
"""Writes assets/heart.wav (gitignored): a heartbeat stem on the same beat times the composition uses (build_index.DATA['hb']).
Each beat (lub + softer dub 0.24 s later) is built with numpy from a real CC0 recording, Kenney "impactSoft_heavy_000"
(Impact Sounds pack, kenney.nl), low-passed at 140 Hz and slowed 0.75x into a soft low thump. Last beat (the shadow's hit) is strongest."""
import json, pathlib, subprocess, sys, contextlib, io
import numpy as np, soundfile as sf
from scipy.signal import butter, sosfiltfilt
HERE = pathlib.Path(__file__).parent
sys.path.insert(0, str(HERE.parent))
with contextlib.redirect_stdout(io.StringIO()):
    import build_index as B
SR = 48000
SRC = HERE.parents[3] / '.claude/skills/sound-effects/sfx/impact/kenney-impact-impactsoft-heavy-000.ogg'
raw = subprocess.run(['ffmpeg', '-v', 'error', '-i', str(SRC), '-ac', '1', '-ar', str(SR), '-f', 'f32le', '-'], capture_output=True).stdout
x = np.frombuffer(raw, dtype=np.float32).copy()
x = np.interp(np.arange(0, len(x), 0.75), np.arange(len(x)), x)          # slow down 0.75x -> lower pitch
x = sosfiltfilt(butter(4, 140, 'low', fs=SR, output='sos'), x)
x = x[:int(0.32 * SR)]; f = int(0.06 * SR); x[-f:] *= np.linspace(1, 0, f)
x /= np.abs(x).max()
out = np.zeros(int((B.DUR + 0.5) * SR))
hb = B.DATA['hb']
for i, t in enumerate(hb):
    g = 0.30 if t < 5 else 0.34
    if i == len(hb) - 1: g = 0.36            # "ทับอก"
    for dt, gg in ((0.0, g), (0.24, g * 0.6)):
        a = int((t + dt) * SR); n = min(len(x), len(out) - a); out[a:a + n] += gg * x[:n]
sf.write(HERE.parent / 'assets' / 'heart.wav', out[:int(B.DUR * SR)].astype(np.float32), SR)
print('beats', hb, 'peak', round(float(np.abs(out).max()), 3))
