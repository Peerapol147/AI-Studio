#!/usr/bin/env python3
"""Footage proxies for the render (video/assets/footage/, gitignored; never commit video files).
For each footage shot in ../assets/audio/shots-th.json: crop the source to a 9:16 window (centre per shot below),
scale to 1080x1920, bake one blue-black/teal grade + soft vignette (ffmpeg, not CSS filters), keep the source
timeline from 0 so the page can use data-media-start = media_start unchanged.
media_start comes from shots-th.json, or from media_start_overrides.json (with a reason) when the frames say so.
Run: python3 prep_footage.py [--force]"""
import json, pathlib, subprocess, sys

HERE = pathlib.Path(__file__).resolve().parent
PROJ = HERE.parent
OUT = HERE / 'assets' / 'footage'

# per shot: crop centre (0-1 of the source width), exposure (eq gamma), saturation kept, extra (blur for soft/CG plates)
LOOK = {
    'surround':  dict(cx=0.30, gam=1.05, bri=0.00),
    'darkcont':  dict(cx=0.50, gam=1.00, bri=-0.02),
    'quote':     dict(cx=0.74, gam=0.80, bri=-0.10),   # daylight savanna: pull it down into dusk
    'attempts':  dict(cx=0.76, gam=1.10, bri=0.02, blur=1.2),  # CG ship: soften so it reads as a plate
    'five':      dict(cx=0.50, gam=1.25, bri=0.04),
    'c1_reward': dict(cx=0.62, gam=0.95, bri=-0.04),
    'c1_count':  dict(cx=0.50, gam=0.92, bri=-0.05),
    'c2_reward': dict(cx=0.45, gam=1.10, bri=0.00),
    'c2_weapon': dict(cx=0.84, gam=0.88, bri=-0.06),
    'c3_reward': dict(cx=0.30, gam=1.00, bri=-0.02),
    'c3_count':  dict(cx=0.50, gam=0.82, bri=-0.08),   # pale misty marsh
    'c4_reward': dict(cx=0.36, gam=1.05, bri=0.00),    # b/w ink: the tint gives it the colour
    'c4_gas':    dict(cx=0.40, gam=1.20, bri=0.03),
    'c5_dead':   dict(cx=0.50, gam=1.00, bri=-0.03),
    'again':     dict(cx=0.24, gam=0.80, bri=-0.10),   # bright fog: darken
}
# blue-black / teal: partial desaturation through a cool channel mix, cool shadows, slightly warm-neutral highs
GRADE = ("colorchannelmixer=rr=0.55:rg=0.30:rb=0.15:gr=0.18:gg=0.66:gb=0.16:br=0.16:bg=0.36:bb=0.62,"
         "colorbalance=rs=-0.10:gs=0.00:bs=0.12:rm=-0.06:gm=0.02:bm=0.07:rh=-0.02:gh=0.01:bh=0.03,"
         "eq=contrast=1.08:saturation=1.15:gamma={gam}:brightness={bri},"
         "vignette=angle=0.55")


def probe(src):
    r = subprocess.run(['ffprobe', '-v', 'error', '-select_streams', 'v:0', '-show_entries', 'stream=width,height',
                        '-of', 'csv=p=0', str(src)], capture_output=True, text=True, check=True)
    w, h = r.stdout.strip().split(',')[:2]
    return int(w), int(h)


def plan():
    shots = json.loads((PROJ / 'assets' / 'audio' / 'shots-th.json').read_text())['shots']
    ov_f = HERE / 'media_start_overrides.json'
    ov = json.loads(ov_f.read_text()) if ov_f.exists() else {}
    out = []
    for s in shots:
        if not s.get('src'):
            continue
        ms = s['media_start']
        if s['id'] in ov:
            ms = float(ov[s['id']]['media_start'])
        out.append(dict(id=s['id'], src=PROJ / s['src'], start=s['start'], end=s['end'], dur=s['dur'],
                        media_start=round(ms, 3), hit=s.get('hit_at'), proxy=f"assets/footage/{s['id']}.mp4"))
    return out


def build(force=False):
    OUT.mkdir(parents=True, exist_ok=True)
    for f in plan():
        dst = HERE / f['proxy']
        lk = LOOK[f['id']]
        stamp = dst.with_suffix('.json')
        key = json.dumps([str(f['src']), f['media_start'], f['dur'], lk, GRADE])
        if not force and dst.exists() and stamp.exists() and stamp.read_text() == key:
            continue
        w, h = probe(f['src'])
        cw = int(round(h * 9 / 16 / 2) * 2)
        x = int(min(max(lk['cx'] * w - cw / 2, 0), w - cw)) // 2 * 2
        vf = f"crop={cw}:{h}:{x}:0,scale=1080:1920:flags=lanczos,"
        if lk.get('blur'):
            vf += f"gblur=sigma={lk['blur']},"
        vf += GRADE.format(gam=lk['gam'], bri=lk['bri']) + ",fps=30,format=yuv420p"
        t = f['media_start'] + f['dur'] + 0.6
        subprocess.run(['ffmpeg', '-v', 'error', '-y', '-i', str(f['src']), '-t', f'{t:.2f}', '-an', '-vf', vf,
                        '-c:v', 'libx264', '-preset', 'medium', '-crf', '19', '-g', '15', '-movflags', '+faststart',
                        str(dst)], check=True)
        stamp.write_text(key)
        print('proxy', f['id'], f'{t:.2f}s')


if __name__ == '__main__':
    build('--force' in sys.argv)
