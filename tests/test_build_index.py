"""templates/brainrot-v2/build_index.py builds index.html from a fresh checkout (no project folder around it)."""
import pathlib, re, shutil, subprocess, sys

ROOT = pathlib.Path(__file__).resolve().parents[1]
FIX = ROOT / 'tests' / 'fixtures' / 'brainrot'
SCRIPT = ROOT / 'templates' / 'brainrot-v2' / 'build_index.py'


def _check(page):
    assert '%%' not in page
    assert len(re.findall(r'class="clip cap"', page)) == 32
    for icon in ('smartphone', 'bed', 'message-circle', 'moon'):
        assert f'<symbol id="ic-{icon}"' in page
    assert page.count('<video ') == 8


def test_build_from_template_dir(tmp_path):
    out = tmp_path / 'index.html'
    r = subprocess.run([sys.executable, str(SCRIPT), '--audio', str(FIX), '--out', str(out)],
                       cwd=tmp_path, capture_output=True, text=True)
    assert r.returncode == 0, r.stderr
    _check(out.read_text())


def test_build_from_copied_project_layout(tmp_path):
    """Same script copied to <repo>/projects/<x>/video/ (how the editor uses it) finds the repo root too."""
    repo = tmp_path / 'some-other-clone'
    shutil.copytree(ROOT / 'assets' / 'vendor' / 'lucide', repo / 'assets' / 'vendor' / 'lucide')
    video = repo / 'projects' / 'x' / 'video'
    video.mkdir(parents=True)
    for f in ('build_index.py', 'index.html.tpl'):
        shutil.copy(ROOT / 'templates' / 'brainrot-v2' / f, video / f)
    shutil.copytree(FIX, repo / 'projects' / 'x' / 'assets' / 'audio')
    r = subprocess.run([sys.executable, 'build_index.py'], cwd=video, capture_output=True, text=True)
    assert r.returncode == 0, r.stderr
    _check((video / 'index.html').read_text())


def _project(tmp_path):
    """A real project layout run through tools/shot_times.py, so shots-th.json carries its "inputs"."""
    import json
    repo = tmp_path / 'repo'
    shutil.copytree(ROOT / 'assets' / 'vendor' / 'lucide', repo / 'assets' / 'vendor' / 'lucide')
    proj = repo / 'projects' / 'x'
    video = proj / 'video'
    video.mkdir(parents=True)
    for f in ('build_index.py', 'index.html.tpl'):
        shutil.copy(ROOT / 'templates' / 'brainrot-v2' / f, video / f)
    (proj / 'assets' / 'audio').mkdir(parents=True)
    shutil.copy(FIX / 'words.json', proj / 'assets' / 'audio' / 'words.json')
    old = json.loads((FIX / 'shots-th.json').read_text())
    shots = [{'id': s['id'], 'cue': {'th': s['cue']}, **({'hit': {'th': s['hit']}} if s.get('hit') else {}),
              **({'media_start': s['media_start']} if 'media_start' in s else {}), 'long_ok': True}
             for s in old['shots']]
    (proj / 'shots.json').write_text(json.dumps({'lead': old['lead'], 'shots': shots}, ensure_ascii=False))
    r = subprocess.run([sys.executable, str(ROOT / 'tools' / 'shot_times.py'), str(proj), 'th'], capture_output=True, text=True)
    assert r.returncode == 0, r.stderr
    return proj, video


def test_fresh_timeline_builds_same_page(tmp_path):
    proj, video = _project(tmp_path)
    r = subprocess.run([sys.executable, 'build_index.py'], cwd=video, capture_output=True, text=True)
    assert r.returncode == 0, r.stderr
    assert (video / 'index.html').read_text() == (ROOT / 'templates' / 'brainrot-v2' / 'index.html').read_text()


def test_stale_timeline_refused(tmp_path):
    proj, video = _project(tmp_path)
    (proj / 'footage.json').write_text('{"loop": {"src": "assets/footage/new.mp4"}}')   # edited after shot_times ran
    r = subprocess.run([sys.executable, 'build_index.py'], cwd=video, capture_output=True, text=True)
    assert r.returncode != 0 and 'stale' in r.stderr and 'footage.json' in r.stderr
    assert not (video / 'index.html').exists()


def test_missing_timeline_message(tmp_path):
    proj, video = _project(tmp_path)
    (proj / 'assets' / 'audio' / 'shots-th.json').unlink()
    r = subprocess.run([sys.executable, 'build_index.py'], cwd=video, capture_output=True, text=True)
    assert r.returncode != 0 and 'run python3 tools/shot_times.py' in r.stderr
