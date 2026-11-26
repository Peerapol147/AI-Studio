"""templates/brainrot-v3/compositions/components/hand-rig: the SVG hand the user approved (palmaris feedback 6) draws
every demo pose without errors, returns on-screen anchor points, and is seek-safe (same state = same markup)."""
import json, pathlib, shutil, subprocess

import pytest

ROOT = pathlib.Path(__file__).resolve().parents[1]
RIG = ROOT / 'templates' / 'brainrot-v3' / 'compositions' / 'components' / 'hand-rig'


def _node_ok():
    return bool(shutil.which('node')) and subprocess.run(['node', '-e', "require('playwright')"], capture_output=True).returncode == 0


def test_files_and_readme():
    for f in ('hand.js', 'hand-rig.css', 'demo.html', 'README.md'):
        assert (RIG / f).exists(), f
    readme = (RIG / 'README.md').read_text()
    assert 'ลองทำตาม' in readme and 'draw(' in readme and 'ไม่ผ่าน' in readme
    js = (RIG / 'hand.js').read_text()
    assert 'Math.random' not in js and 'Date.now' not in js        # seek-safe: deterministic only


@pytest.mark.skipif(not _node_ok(), reason='node + playwright not installed')
def test_poses_render(tmp_path):
    r = subprocess.run(['node', str(ROOT / 'tests' / 'browser' / 'hand_rig.js'), str(RIG / 'demo.html'), str(tmp_path)],
                       capture_output=True, text=True, timeout=120)
    assert r.returncode == 0, r.stderr
    for p in json.loads(r.stdout.strip().splitlines()[-1]):
        assert p['errs'] == [], p
        assert p['paths'] > 20 and p['same'], p
        for k in ('wrist', 'thumbTip', 'pinkyTip'):
            pt = p['rig'][k]
            assert 0 <= pt['x'] <= 1080 and 0 <= pt['y'] <= 1920, (p['pose'], k, pt)
        assert (tmp_path / f'hand-{p["pose"]}.png').stat().st_size > 10000
