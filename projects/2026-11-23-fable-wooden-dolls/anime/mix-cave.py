#!/usr/bin/env python3
"""Cave version mix: Thai narration (assets/audio/vo-th.mp3) + music + SFX, times from timeline-th.json cues.
python3 anime/mix-cave.py -> renders/wooden-dolls-cave.mp4 (-16 LUFS, true peak <= -4 dBFS)"""
import subprocess, json, re, os, sys
P = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
A = lambda f: os.path.join(P, 'assets/audio', f)
TL = json.load(open(os.path.join(P, 'timeline-th.json'))); C = TL['cues']; B = {b['id']: b for b in TL['beats']}
SILENT, OUT, DUR = os.path.join(P, 'renders/wooden-dolls-cave-silent.mp4'), os.path.join(P, 'renders/wooden-dolls-cave.mp4'), TL['duration']
LOOP = {'sfx-fire-loop.mp3', 'sfx-cave-drips.mp3', 'sfx-torch-whoosh.mp3'}
LUFS = {}
def lufs(f):
    r = subprocess.run(['ffmpeg', '-hide_banner', '-nostats', '-i', A(f), '-af', 'ebur128', '-f', 'null', '-'], capture_output=True, text=True)
    return float(re.findall(r'I:\s+(-?[\d.]+) LUFS', r.stderr)[-1])
seg = lambda f, a, b, tgt, fi=0.3, fo=0.4, off=0: (f, a, b - a, tgt, fi, fo, off)
EV = [
    ('vo-th.mp3', 0, DUR, -16.5, 0, 0, 0),
    ('music-jamendo-5193aa1b.mp3', 0, DUR, -28, 0.05, 2.0, 0),
    seg('sfx-cave-drips.mp3', 0, DUR, -36, 0.05, 1.5),
    # torch flutter on the walks
    seg('sfx-torch-whoosh.mp3', B['B2']['t0'], C['three'] - 0.3, -36), seg('sfx-torch-whoosh.mp3', B['B5']['t0'], C['tiny'] - 0.6, -36),
    seg('sfx-torch-whoosh.mp3', C['lucky'] - 0.5, B['B5']['t1'], -36), seg('sfx-torch-whoosh.mp3', C['slow'] - 0.2, B['B6']['t1'], -36),
    # campfire crackle at rest
    seg('sfx-fire-loop.mp3', 0, B['B1']['t1'], -33, 0.02), seg('sfx-fire-loop.mp3', C['three'] - 0.3, B['B4']['t1'], -31),
    seg('sfx-fire-loop.mp3', C['tiny'] - 0.6, C['lucky'] - 0.5, -37), seg('sfx-fire-loop.mp3', B['B6']['t0'], C['slow'] - 0.2, -33),
    seg('sfx-fire-loop.mp3', B['B7']['t0'], C['out'] + 0.4, -35, 0.2, 1.0),
    seg('sfx-fire-die.mp3', C['out'] - 0.3, C['out'] + 2.7, -33, 0.05, 1.2, 0.5),
    seg('sfx-footsteps-snow.mp3', B['B2']['t0'] + 0.3, B['B2']['t0'] + 4.5, -33), seg('sfx-sled-drag.mp3', B['B2']['t0'] + 0.3, B['B2']['t0'] + 5, -35),
    seg('sfx-water-steps.mp3', B['B5']['t0'] + 0.5, B['B5']['t0'] + 5.5, -31),
    seg('sfx-sled-drag.mp3', C['slow'] - 0.2, B['B6']['t1'], -30, 0.2, 0.4, 1),
    seg('sfx-crate.mp3', C['crate'] + 0.8, C['crate'] + 3.6, -30, 0.05),
    seg('sfx-twig-weave.mp3', C['weave'], C['weave'] + 1.6, -31, 0.05),
    seg('sfx-shiver-breath.mp3', C['tiny'] - 0.4, C['tiny'] + 2.2, -31, 0.1),
    seg('sfx-fire-big.mp3', C['three'] + 0.3, C['three'] + 3.0, -31, 0.3, 1.0),
    seg('sfx-footsteps-snow.mp3', B['B9']['t0'] + 0.2, B['B9']['t0'] + 2.7, -35),
] + [seg('sfx-log-drop.mp3', s + 0.4, s + 1.4, -29, 0, 0.3) for s in (C['three'] - 0.2, C['three'] + 0.25, C['three'] + 0.7)]
for f, *_ in EV: LUFS.setdefault(f, lufs(f))

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
json.dump({'lufs': I, 'true_peak': tp, 'master_db': master, 'events': EV}, open(os.path.join(P, 'renders/mix-report-cave.json'), 'w'), ensure_ascii=False, indent=1)
