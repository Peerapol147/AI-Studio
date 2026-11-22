"""templates/brainrot-v3/build_index.py: one template, two looks from look.json; refuses a missing look/beat."""
import json, os, pathlib, re, shutil, subprocess, sys

ROOT = pathlib.Path(__file__).resolve().parents[1]
FIX = ROOT / 'tests' / 'fixtures' / 'v3'
V3 = ROOT / 'templates' / 'brainrot-v3'
LOOK_A = {'palette': 'sunrise-coral', 'font': 'prompt', 'caption': 'box', 'opening': 'pov', 'transition': 'slide',
          'music_mood': 'lofi', 'voice': 'liam', 'music_file': 'music-a.mp3'}
LOOK_B = {'palette': 'ocean-teal', 'font': 'noto', 'caption': 'pop', 'opening': 'number', 'transition': 'flash',
          'music_mood': 'cinematic', 'voice': 'george', 'music_file': None}


def project(tmp_path, look, shots=None, episode=None):
    proj = tmp_path / 'projects' / '2026-11-22-knowledge-x'
    video = proj / 'video'
    video.mkdir(parents=True)
    for f in ('build_index.py', 'index.html.tpl'):
        shutil.copy(V3 / f, video / f)
    ep = json.loads((FIX / 'episode.json').read_text())
    ep.update(episode or {})
    (video / 'episode.json').write_text(json.dumps(ep, ensure_ascii=False))
    (proj / 'assets' / 'audio').mkdir(parents=True)
    shutil.copy(FIX / 'words.json', proj / 'assets' / 'audio' / 'words.json')
    (proj / 'shots.json').write_text(shots if shots is not None else (FIX / 'shots.json').read_text())
    if look is not None:
        (proj / 'look.json').write_text(json.dumps(look))
    r = subprocess.run([sys.executable, str(ROOT / 'tools' / 'shot_times.py'), str(proj), 'th'], capture_output=True, text=True)
    assert r.returncode == 0, r.stderr
    return proj, video


def build(video):
    env = {**os.environ, 'AI_STUDIO_ROOT': str(ROOT)}
    return subprocess.run([sys.executable, 'build_index.py'], cwd=video, capture_output=True, text=True, env=env)


def test_two_looks_differ(tmp_path):
    pages = []
    for name, look in (('a', LOOK_A), ('b', LOOK_B)):
        proj, video = project(tmp_path / name, look, episode={'kicker': '86%'} if look['opening'] == 'number' else None)
        r = build(video)
        assert r.returncode == 0, r.stderr
        pages.append((video / 'index.html').read_text())
    a, b = pages
    for p in pages:
        assert '%%' not in p and p.count('class="clip cap"') == 11 and p.count('<video ') == 6
    assert 'cap-box op-pov' in a and "--accent:#FFD23F" in a and "--font:'Prompt'" in a and 'music-a.mp3' in a
    assert 'cap-pop op-number' in b and "--accent:#5CF2E3" in b and "--font:'Noto Sans Thai'" in b
    assert 'class="kick num">86%<' in b and 'no music_file' in b
    assert '"transition": "slide"' in a and '"transition": "flash"' in b
    # loop shot replays the hook plate and ends on the hook in-point (1.0 s) = frame 0
    loop = re.search(r'<video id="v-loop"[^>]*data-start="([\d.]+)"[^>]*data-media-start="([-\d.]+)"', a)
    assert loop and abs(float(loop.group(2)) - (1.0 - (8.0 - float(loop.group(1))))) < 1e-6
    assert 'id="g-share"' in a                                  # graphic slot for the editor


def test_missing_look_and_bad_axis_refused(tmp_path):
    proj, video = project(tmp_path / 'a', None)
    r = build(video)
    assert r.returncode != 0 and 'tools/look.py pick' in r.stderr
    (proj / 'look.json').write_text(json.dumps({**LOOK_A, 'caption': 'comic'}))
    r = build(video)
    assert r.returncode != 0 and "caption='comic'" in r.stderr


def test_shot_without_beat_and_number_without_kicker_refused(tmp_path):
    shots = json.loads((FIX / 'shots.json').read_text())
    del shots['shots'][2]['beat']
    proj, video = project(tmp_path / 'a', LOOK_A, shots=json.dumps(shots, ensure_ascii=False))
    r = build(video)
    assert r.returncode != 0 and 'shot explain: beat None' in r.stderr
    proj, video = project(tmp_path / 'b', LOOK_B, episode={'kicker': None})
    r = build(video)
    assert r.returncode != 0 and 'kicker' in r.stderr
