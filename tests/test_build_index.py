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
