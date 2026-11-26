"""tools/vo_finish.sh: locked knowledge voice pace (atempo 1.1) + loudness -18 LUFS (palmaris feedback 4 and 9)."""
import pathlib, re, shutil, subprocess

import pytest

ROOT = pathlib.Path(__file__).resolve().parents[1]


def _dur(f):
    return float(subprocess.check_output(['ffprobe', '-v', 'error', '-show_entries', 'format=duration', '-of', 'csv=p=0', str(f)]))


def test_atempo_and_normalize(tmp_path):
    if not shutil.which('ffmpeg'):
        pytest.skip('ffmpeg not installed')
    raw = tmp_path / 'raw.mp3'
    # quiet "voice" like the palmaris raw take (~-24 LUFS): a tone with gaps
    subprocess.run(['ffmpeg', '-v', 'error', '-y', '-f', 'lavfi', '-i',
                    'aevalsrc=0.05*sin(2*PI*220*t)*(0.6+0.4*sin(2*PI*3*t))*lt(mod(t\\,1)\\,0.8):d=5:s=44100',
                    str(raw)], check=True)
    out = tmp_path / 'vo-th.mp3'
    r = subprocess.run(['bash', str(ROOT / 'tools' / 'vo_finish.sh'), str(raw), str(out)], capture_output=True, text=True)
    assert r.returncode == 0, r.stderr
    lufs = float(re.search(r'([-\d.]+) LUFS integrated', r.stdout).group(1))
    assert abs(lufs - -18) <= 1.0, r.stdout
    assert abs(_dur(out) - _dur(raw) / 1.1) < 0.1
