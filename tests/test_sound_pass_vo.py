"""tools/sound_pass_vo.py mixes a tiny synthetic clip and writes its report from a checkout at another path."""
import json, pathlib, shutil, subprocess, sys

import pytest

np = pytest.importorskip('numpy')
sf = pytest.importorskip('soundfile')
pytest.importorskip('librosa')
pytest.importorskip('scipy')
pytest.importorskip('matplotlib')
ROOT = pathlib.Path(__file__).resolve().parents[1]
SR = 48000


def test_mix_and_report_from_other_checkout(tmp_path):
    if not shutil.which('ffmpeg'):
        pytest.skip('ffmpeg not installed')
    # a copy of just the pieces the tool needs, under a different path than the real clone
    clone = tmp_path / 'Some Other Clone'
    (clone / 'tools').mkdir(parents=True)
    for f in ('sound_pass_vo.py', 'get.sh'):
        shutil.copy(ROOT / 'tools' / f, clone / 'tools')
    skill = ROOT / '.claude' / 'skills' / 'sound-effects'
    shutil.copytree(skill / 'scripts', clone / '.claude' / 'skills' / 'sound-effects' / 'scripts')
    shutil.copytree(skill / 'sfx', clone / '.claude' / 'skills' / 'sound-effects' / 'sfx')

    w = tmp_path / 'in'; w.mkdir()
    t = np.arange(SR * 8) / SR
    music = 0.1 * np.sin(2 * np.pi * 220 * t)
    n = int(0.05 * SR); k = np.arange(n)
    for b in np.arange(0, 8, 0.5):                     # 120 BPM kick drum
        i = int(b * SR); music[i:i + n] += 0.6 * np.sin(2 * np.pi * 60 * k / SR) * np.exp(-k / (0.01 * SR))
    sf.write(w / 'music.wav', music.astype('float32'), SR)
    sf.write(w / 'voice.wav', (0.3 * np.sin(2 * np.pi * 440 * np.arange(int(SR * 2.5)) / SR)).astype('float32'), SR)
    (w / 'cues.json').write_text(json.dumps([{'t': 1.0, 'type': 'scene_cut', 'desc': 'cut'},
                                             {'t': 2.0, 'type': 'appear', 'desc': 'pop'}]))
    subprocess.run(['ffmpeg', '-v', 'error', '-y', '-f', 'lavfi', '-i', 'color=c=black:s=160x284:r=30:d=3',
                    '-pix_fmt', 'yuv420p', str(w / 'silent.mp4')], check=True)
    out = tmp_path / 'out'
    r = subprocess.run([sys.executable, str(clone / 'tools' / 'sound_pass_vo.py'), '--video', str(w / 'silent.mp4'),
                        '--cues', str(w / 'cues.json'), '--music', str(w / 'music.wav'), '--voice', str(w / 'voice.wav'),
                        '--manifest', str(clone / '.claude/skills/sound-effects/sfx/manifest.json'), '--out', str(out)],
                       cwd=tmp_path, capture_output=True, text=True, timeout=300)
    assert r.returncode == 0, r.stderr[-2000:]
    for f in ('after.mp4', 'SOUND.md', 'CREDITS.txt', 'report.html'):
        assert (out / f).stat().st_size > 0, f
    assert 'FINAL after.mp4' in (out / 'SOUND.md').read_text()
    rep = (out / 'SOUND.md').read_text()
    assert 'music bed -24 dB, ducked 8 dB' in rep               # palmaris feedback 4 defaults
    assert 'Voice loudness' in rep and 'WARN voice is' in rep    # the synthetic voice is ~-13 LUFS, not -18



def test_mono_voice_at_minus_18_is_not_warned(tmp_path):
    """itch 2026-11-27: a mono VO normalized to -18 LUFS (vo_finish.sh) was reported as -15 ("WARN voice is -15"):
    the tool doubled it to stereo before measuring (+3 LU). The file check now measures the mono file itself."""
    if not shutil.which('ffmpeg'):
        pytest.skip('ffmpeg not installed')
    clone = tmp_path / 'c'
    (clone / 'tools').mkdir(parents=True)
    for f in ('sound_pass_vo.py', 'get.sh'):
        shutil.copy(ROOT / 'tools' / f, clone / 'tools')
    skill = ROOT / '.claude' / 'skills' / 'sound-effects'
    shutil.copytree(skill / 'scripts', clone / '.claude' / 'skills' / 'sound-effects' / 'scripts')
    shutil.copytree(skill / 'sfx', clone / '.claude' / 'skills' / 'sound-effects' / 'sfx')
    w = tmp_path / 'in'; w.mkdir()
    t = np.arange(SR * 6) / SR
    music = 0.1 * np.sin(2 * np.pi * 220 * t)
    n = int(0.05 * SR); k = np.arange(n)
    for b in np.arange(0, 6, 0.5):
        i = int(b * SR); music[i:i + n] += 0.6 * np.sin(2 * np.pi * 60 * k / SR) * np.exp(-k / (0.01 * SR))
    sf.write(w / 'music.wav', music.astype('float32'), SR)
    sf.write(w / 'raw.wav', (0.3 * np.sin(2 * np.pi * 440 * np.arange(int(SR * 2.5)) / SR)).astype('float32'), SR)
    subprocess.run(['ffmpeg', '-v', 'error', '-y', '-i', str(w / 'raw.wav'), '-af', 'loudnorm=I=-18:TP=-1.5:LRA=11',
                    '-ac', '1', '-ar', str(SR), str(w / 'voice.wav')], check=True)
    o = subprocess.run(['ffmpeg', '-nostats', '-i', str(w / 'voice.wav'), '-af', 'ebur128', '-f', 'null', '-'],
                       capture_output=True, text=True).stderr
    import re
    assert sf.info(str(w / 'voice.wav')).channels == 1 and abs(float(re.findall(r'I:\s+([-\d.]+) LUFS', o)[-1]) + 18) < 1
    (w / 'cues.json').write_text(json.dumps([{'t': 1.0, 'type': 'scene_cut', 'desc': 'cut'}]))
    subprocess.run(['ffmpeg', '-v', 'error', '-y', '-f', 'lavfi', '-i', 'color=c=black:s=160x284:r=30:d=3',
                    '-pix_fmt', 'yuv420p', str(w / 'silent.mp4')], check=True)
    out = tmp_path / 'out'
    r = subprocess.run([sys.executable, str(clone / 'tools' / 'sound_pass_vo.py'), '--video', str(w / 'silent.mp4'),
                        '--cues', str(w / 'cues.json'), '--music', str(w / 'music.wav'), '--voice', str(w / 'voice.wav'),
                        '--manifest', str(clone / '.claude/skills/sound-effects/sfx/manifest.json'), '--out', str(out)],
                       cwd=tmp_path, capture_output=True, text=True, timeout=300)
    assert r.returncode == 0, r.stderr[-2000:]
    rep = (out / 'SOUND.md').read_text()
    m = re.search(r'Voice loudness ([-\d.]+) LUFS \(mono file', rep)
    assert m and abs(float(m.group(1)) + 18) < 1, rep
    assert 'WARN voice is' not in rep
    mix = re.search(r'in the stereo mix ([-\d.]+) LUFS', rep)
    assert mix and 2 < float(mix.group(1)) - float(m.group(1)) < 4          # dual mono = +3 LU in the mix


def test_no_mixkit_anywhere_in_the_sound_kit(tmp_path):
    """review v3.7 Y4 (planning room): no Mixkit for music or sound effects (licence cannot be verified). The manifest has
    no Mixkit entry, every default-kit sound is a bundled CC0 file, and the mix refuses a Mixkit track/swap."""
    import re
    man = json.loads((ROOT / '.claude/skills/sound-effects/sfx/manifest.json').read_text())
    entries = man['bundled'] + man['runtime'] + man['default_kit']
    assert not [e for e in entries if 'mixkit' in json.dumps(e).lower()]
    for e in man['default_kit']:
        assert e['file'] and (ROOT / '.claude/skills/sound-effects/sfx' / e['file']).exists() and 'CC0' in e['license'], e
    for f in ('tools/sound_pass_vo.py', '.claude/skills/sound-effects/scripts/sound_pass.py'):
        src = (ROOT / f).read_text()
        assert "'Mixkit' in l and 'Free License'" not in src and 'Mixkit is not allowed' in src
    if not shutil.which('ffmpeg'):
        return
    w = tmp_path / 'in'; w.mkdir()
    sf.write(w / 'm.wav', (0.1 * np.sin(2 * np.pi * 220 * np.arange(SR * 3) / SR)).astype('float32'), SR)
    (w / 'cues.json').write_text('[]')
    subprocess.run(['ffmpeg', '-v', 'error', '-y', '-f', 'lavfi', '-i', 'color=c=black:s=64x112:r=30:d=2', '-pix_fmt', 'yuv420p',
                    str(w / 's.mp4')], check=True)
    r = subprocess.run([sys.executable, str(ROOT / 'tools' / 'sound_pass_vo.py'), '--video', str(w / 's.mp4'), '--cues',
                        str(w / 'cues.json'), '--music', str(w / 'm.wav'), '--voice', str(w / 'm.wav'), '--manifest',
                        str(ROOT / '.claude/skills/sound-effects/sfx/manifest.json'), '--out', str(tmp_path / 'o'),
                        '--music-license', 'Mixkit Stock Music Free License'], capture_output=True, text=True, timeout=120)
    assert r.returncode != 0 and 'Mixkit is not allowed' in r.stderr
