#!/usr/bin/env python3
"""Mix music + ElevenLabs SFX under the silent render (no voice-over). Times follow episode.js shots.
python3 anime/mix.py  (run from the project folder) -> renders/wooden-dolls.mp4  (-16 LUFS, true peak <= -4 dBFS)"""
import subprocess, json, re, os, sys
P = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
A = lambda f: os.path.join(P, 'assets/audio', f)
EN = '--lang' in sys.argv and sys.argv[sys.argv.index('--lang') + 1] == 'en'
SILENT = os.path.join(P, 'renders/wooden-dolls-silent' + ('-en' if EN else '') + '.mp4')
OUT, DUR = os.path.join(P, 'renders/wooden-dolls' + ('-en' if EN else '') + '.mp4'), 55.0
# measured integrated loudness of each raw file (assets/audio/AUDIO.md); gain = target - measured
LUFS = {'music-jamendo-5193aa1b.mp3': -16.4, 'sfx-fire-loop.mp3': -42.3, 'sfx-fire-big.mp3': -20.3, 'sfx-fire-die.mp3': -42.9,
        'sfx-wind-loop.mp3': -14.9, 'sfx-blizzard.mp3': -15.3, 'sfx-log-drop.mp3': -14.2, 'sfx-twig-weave.mp3': -37.1,
        'sfx-sled-drag.mp3': -23.7, 'sfx-footsteps-snow.mp3': -23.8, 'sfx-shiver-breath.mp3': -19.9, 'sfx-morning-birds.mp3': -17.7}
LOOP = {'sfx-fire-loop.mp3', 'sfx-wind-loop.mp3'}
# (file, start, dur, target LUFS, fade in, fade out, offset in file)
EV = [
    ('music-jamendo-5193aa1b.mp3', 0, 55, -21, 0.05, 1.2, 0),
    # wind bed all the way, louder on the open treks
    ('sfx-wind-loop.mp3', 0, 3, -33, 0.05, 0.3, 0), ('sfx-wind-loop.mp3', 3, 3, -27, 0.2, 0.3, 3), ('sfx-wind-loop.mp3', 6, 13, -34, 0.2, 0.4, 6),
    ('sfx-wind-loop.mp3', 23, 6, -30, 0.2, 0.4, 2), ('sfx-wind-loop.mp3', 29, 7, -33, 0.2, 0.3, 9), ('sfx-wind-loop.mp3', 36, 3, -26, 0.2, 0.3, 14),
    ('sfx-wind-loop.mp3', 39, 8, -32, 0.2, 2.0, 4), ('sfx-wind-loop.mp3', 47, 8, -36, 1.0, 1.0, 11),
    # campfire crackle wherever the fire is on screen (quieter as it shrinks)
    ('sfx-fire-loop.mp3', 0, 3, -30, 0.02, 0.2, 0), ('sfx-fire-loop.mp3', 9, 10, -27, 0.2, 0.3, 3), ('sfx-fire-loop.mp3', 23, 3, -33, 0.2, 0.3, 8),
    ('sfx-fire-loop.mp3', 29, 7, -30, 0.2, 0.3, 11), ('sfx-fire-loop.mp3', 39, 6.2, -31, 0.1, 1.5, 2),
    ('sfx-log-drop.mp3', 9.65, 1.2, -25, 0, 0.3, 0), ('sfx-log-drop.mp3', 10.35, 1.2, -25, 0, 0.3, 0), ('sfx-log-drop.mp3', 11.05, 1.2, -25, 0, 0.3, 0),
    ('sfx-fire-big.mp3', 10.0, 3.0, -27, 0.3, 1.0, 0),
    ('sfx-twig-weave.mp3', 13.9, 2.1, -27, 0.05, 0.4, 0),
    ('sfx-blizzard.mp3', 19, 4, -21, 0.05, 0.5, 1),
    ('sfx-footsteps-snow.mp3', 19.2, 3.6, -29, 0.2, 0.5, 0),
    ('sfx-shiver-breath.mp3', 23.3, 2.6, -27, 0.1, 0.4, 0), ('sfx-shiver-breath.mp3', 0.4, 2.4, -31, 0.1, 0.4, 0),
    ('sfx-morning-birds.mp3', 26.2, 2.8, -32, 0.3, 0.6, 0),
    ('sfx-sled-drag.mp3', 3, 3, -29, 0.2, 0.4, 0), ('sfx-sled-drag.mp3', 36, 3, -26, 0.2, 0.4, 2),
    ('sfx-fire-die.mp3', 44.0, 3.0, -30, 0.05, 1.2, 0.5),
    ('sfx-morning-birds.mp3', 47.6, 4.2, -31, 0.8, 0.8, 0),
    ('sfx-footsteps-snow.mp3', 52.0, 1.2, -29, 0.05, 0.3, 0), ('sfx-sled-drag.mp3', 52.0, 1.1, -31, 0.05, 0.3, 0),
]
if EN:  # narration (ElevenLabs "George", per line, timed in script-en.json); music and beds sit lower under the voice
    EV = [(f, st, d, tgt - (4 if f.startswith('music') else 3), fi, fo, off) for f, st, d, tgt, fi, fo, off in EV]
    for lid, st, txt in json.load(open(os.path.join(P, 'script-en.json'))):
        f = f'vo-en/{lid}.mp3'
        r = subprocess.run(['ffmpeg', '-hide_banner', '-nostats', '-i', A(f), '-af', 'ebur128', '-f', 'null', '-'], capture_output=True, text=True)
        LUFS[f] = float(re.findall(r'I:\s+(-?[\d.]+) LUFS', r.stderr)[-1])
        d = float(subprocess.run(['ffprobe', '-v', 'error', '-show_entries', 'format=duration', '-of', 'csv=p=0', A(f)], capture_output=True, text=True).stdout)
        EV.append((f, st, d, -17, 0.0, 0.05, 0))

def run(cmd): return subprocess.run(cmd, capture_output=True, text=True)
def build(master_db):
    inp, fl, labs = ['-i', SILENT], [], []
    for i, (f, st, d, tgt, fi, fo, off) in enumerate(EV):
        inp += (['-stream_loop', '-1'] if f in LOOP else []) + ['-i', A(f)]
        g = tgt - LUFS[f]
        fl.append(f'[{i+1}:a]aformat=sample_rates=48000:channel_layouts=stereo,atrim={off}:{off+d},asetpts=PTS-STARTPTS,'
                  f'afade=t=in:d={fi},afade=t=out:st={max(0,d-fo)}:d={fo},volume={g}dB,adelay={int(st*1000)}|{int(st*1000)},apad=whole_dur={DUR}[a{i}]')
        labs.append(f'[a{i}]')
    fl.append(''.join(labs) + f'amix=inputs={len(labs)}:normalize=0,volume={master_db}dB,alimiter=limit=0.45:level=false,atrim=0:{DUR}[mix]')
    return inp, ';'.join(fl)
def measure(path):
    r = run(['ffmpeg', '-hide_banner', '-nostats', '-i', path, '-af', 'ebur128=peak=true', '-f', 'null', '-'])
    I = float(re.findall(r'I:\s+(-?[\d.]+) LUFS', r.stderr)[-1]); tp = float(re.findall(r'Peak:\s+(-?[\d.]+) dBFS', r.stderr)[-1])
    return I, tp
master = 0.0
for it in range(3):
    inp, fl = build(master)
    r = run(['ffmpeg', '-y', '-v', 'error'] + inp + ['-filter_complex', fl, '-map', '0:v', '-map', '[mix]', '-c:v', 'copy', '-c:a', 'aac', '-b:a', '192k', '-ar', '48000', '-t', str(DUR), '-movflags', '+faststart', OUT])
    if r.returncode: print(r.stderr[-2000:]); sys.exit(1)
    I, tp = measure(OUT); print(f'pass {it}: master {master:+.1f} dB -> {I} LUFS, true peak {tp} dBFS')
    if abs(I + 16) < 0.6 and tp <= -4: break
    master += -16 - I
json.dump({'lufs': I, 'true_peak': tp, 'master_db': master, 'events': EV}, open(os.path.join(P, 'renders/mix-report' + ('-en' if EN else '') + '.json'), 'w'), ensure_ascii=False, indent=1)
