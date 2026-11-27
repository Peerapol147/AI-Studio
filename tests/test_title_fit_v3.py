"""brainrot-v3 frame-0 title: lines fit their box and Thai stacked marks (สระบน + วรรณยุกต์) never touch the line above.
Caught (stomach-growl 2026-11-23): "ทั้งที่เพิ่งกินข้าว?" under "*ท้องร้อง*" - the tone marks rose into the orange plate,
and on a card cover the line ran past the card. Needs node + playwright + chromium (skipped where missing, e.g. CI)."""
import json, os, shutil, subprocess, sys
import pytest
from test_build_index_v3 import FIX, ROOT, V3, project, build

JS = ROOT / 'tests' / 'browser' / 'title_fit.js'
TITLES = [["*ท้องร้อง*", "ทั้งที่เพิ่งกินข้าว?"], ["ทั้งที่เพิ่ง", "*ปู่ย่าน้ำผึ้ง*ทั้งปี?"], ["กร๊อบ =", "*ข้อเสื่อม*?"], ["ทำไม", "*ปู่ย่า*ชอบ", "นั่งยองๆ?"],
          ["เวลาเกาแก้คัน", "เรากำลังทำให้", "ตัวเอง*เจ็บ*นะ"]]   # itch 2026-11-27: pov + tilt + sarabun came out 65 px, left-aligned


def _node_ok():
    if not shutil.which('node'):
        return False
    r = subprocess.run(['node', '-e', "require('playwright')"], capture_output=True, text=True, env=_env())
    return r.returncode == 0


def _env():
    env = dict(os.environ)
    g = subprocess.run(['npm', 'root', '-g'], capture_output=True, text=True) if shutil.which('npm') else None
    if g and g.returncode == 0:
        env['NODE_PATH'] = g.stdout.strip() + os.pathsep + env.get('NODE_PATH', '')
    return env


@pytest.mark.skipif(not _node_ok(), reason='node + playwright not installed')
def test_title_lines_fit_and_marks_clear_line_above(tmp_path):
    cat = json.loads((ROOT / 'templates' / 'looks' / 'looks.json').read_text())
    opts = lambda ax: [k for k in cat[ax] if not k.startswith('_')]
    pages = []
    i = 0
    for font in opts('font'):
        for cover in opts('cover'):
            for opening in opts('opening'):
                for t in TITLES:
                    i += 1
                    look = {'palette': 'sunrise-coral', 'font': font, 'caption': 'stroke', 'opening': opening,
                            'cover': cover, 'transition': 'flash', 'music_mood': 'lofi', 'voice': 'liam', 'music_file': None}
                    proj, video = project(tmp_path / f'p{i}', look, episode={'title': t, 'kicker': '86%' if opening == 'number' else 'POV: เพิ่งกินข้าว'})
                    shutil.copytree(V3 / 'fonts', video / 'fonts')
                    r = build(video)
                    assert r.returncode == 0, r.stderr
                    pages.append((f'{font}/{cover}/{opening}/{t}', str(video / 'index.html')))
    r = subprocess.run(['node', str(JS), *[p for _, p in pages]], capture_output=True, text=True, env=_env(), timeout=600)
    assert r.returncode == 0, r.stderr
    res = json.loads(r.stdout)
    bad = [f'{name}: {pr}' for (name, _), x in zip(pages, res) for pr in x['problems']]
    assert not bad, '\n'.join(bad[:30]) + f'\n... {len(bad)} problems'
