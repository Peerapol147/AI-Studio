"""tools/cover_check.py: cover A/B separate from frame 0 (palmaris feedback 7-8): <= 2 lines, no repeated word,
no overlap / edge, readable at 200 px, not like an earlier cover; tools/cover_shot.js measures templates/brainrot-v3/cover.html."""
import json, pathlib, shutil, subprocess, sys

import pytest

ROOT = pathlib.Path(__file__).resolve().parents[1]
TOOL = ROOT / 'tools' / 'cover_check.py'
PIL = pytest.importorskip('PIL')
from PIL import Image, ImageDraw  # noqa: E402

sys.path.insert(0, str(ROOT / 'tools'))
import cover_check  # noqa: E402

GOOD = [{'id': 'a', 'lines': ['ร่างกายเรา', 'มี*อะไหล่*!?']}, {'id': 'b', 'lines': ['หมอ*ตัด*เส้นนี้', 'ไปใช้ได้!?']}]


def repo(tmp_path):
    r = tmp_path / 'repo'
    (r / 'templates' / 'looks').mkdir(parents=True)
    shutil.copy(ROOT / 'templates' / 'looks' / 'looks.json', r / 'templates' / 'looks' / 'looks.json')
    (r / 'channels' / 'knowledge').mkdir(parents=True)
    return r


def ep(r, pid, look):
    d = r / 'projects' / pid
    d.mkdir(parents=True)
    (d / 'look.json').write_text(json.dumps(look, ensure_ascii=False))
    return d


def shot(d, vid, items, light=True):
    """A fake cover-<id>.jpg + .json: dark text boxes on a light field (or grey on grey when light=False)."""
    (d / 'covers').mkdir(exist_ok=True)
    im = Image.new('RGB', (1080, 1920), (240, 240, 240) if light else (120, 120, 120))
    dr = ImageDraw.Draw(im)
    for i in items:
        if i['kind'] == 'text':
            for k in range(0, int(i['w']), 40):                # stripes = letters
                dr.rectangle([i['x'] + k, i['y'], i['x'] + k + 18, i['y'] + i['h']], fill=(10, 10, 10) if light else (128, 128, 128))
    im.save(d / 'covers' / f'cover-{vid}.jpg')
    (d / 'covers' / f'cover-{vid}.json').write_text(json.dumps({'w': 1080, 'h': 1920, 'items': items}))


def T(text, x, y, w=700, h=160, fs=170):
    return {'kind': 'text', 'text': text, 'x': x, 'y': y, 'w': w, 'h': h, 'font_px': fs, 'overflow': False}


def run(*a):
    return subprocess.run([sys.executable, str(TOOL), *map(str, a)], capture_output=True, text=True)


def test_repeated_word():
    assert cover_check.repeated(['ร่างกายมี', 'ร่างกายสำรอง']) == 'ร่างกาย'
    assert cover_check.repeated(['เส้นนี้', 'ตัดเส้นนี้ได้']) == 'เส้นนี้'
    assert cover_check.repeated(['why why', 'not']) == 'why'
    for ok in (['หมอตัดเส้นนี้', 'ไปใช้ได้!?'], ['ร่างกายเรา', 'มีอะไหล่!?'], ['ร้องไห้ในอวกาศ', 'น้ำตาไปไหน?']):
        assert cover_check.repeated(ok) is None, ok


def test_good_ab_passes_and_writes_200px_and_compare(tmp_path):
    r = repo(tmp_path)
    d = ep(r, '2026-11-27-knowledge-x', {'cover_text': 'ร่างกายมีอะไหล่สำรอง', 'covers': GOOD})
    for c in GOOD:
        shot(d, c['id'], [T(c['lines'][0].replace('*', ''), 190, 290), T(c['lines'][1].replace('*', ''), 190, 510)])
    res = run(d, '--final', '--no-git')
    assert res.returncode == 0, res.stdout
    assert (d / 'covers' / 'cover-a-200.png').exists() and (d / 'covers' / 'compare.png').exists()
    assert Image.open(d / 'covers' / 'cover-a-200.png').width == 200


def test_text_rules(tmp_path):
    r = repo(tmp_path)
    bad = [{'id': 'a', 'lines': ['ข้อมือ', 'มีเส้นนี้', 'ไหม?']}, {'id': 'b', 'lines': ['ข้อมือ', 'มีเส้นนี้', 'ไหม?']}]
    d = ep(r, '2026-11-27-knowledge-x', {'covers': bad})
    res = run(d, '--no-git')
    assert res.returncode == 1 and '3 lines (max 2' in res.stdout and 'say the same thing' in res.stdout
    assert 'WARN  cover a: cover-a.jpg' in res.stdout                 # images not made yet: WARN until --final
    assert 'missing' in run(d, '--final', '--no-git').stdout
    (d / 'look.json').write_text(json.dumps({'covers': GOOD[:1]}))
    assert 'need 2 variants' in run(d, '--no-git').stdout


def test_similar_to_earlier_episode_cover_or_frame0(tmp_path):
    r = repo(tmp_path)
    ep(r, '2026-11-20-knowledge-old', {'cover_text': 'กร๊อบ = ข้อเสื่อม?',
                                       'covers': [{'id': 'a', 'lines': ['หมอตัดเส้นนี้', 'ไปใช้ได้!?']}]})
    d = ep(r, '2026-11-27-knowledge-x', {'covers': [{'id': 'a', 'lines': ['กร๊อบ =', 'ข้อเสื่อม?']},
                                                     {'id': 'b', 'lines': ['หมอตัดเส้นนี้', 'ไปใช้ได้!?']}]})
    res = run(d, '--no-git')
    assert res.returncode == 1
    assert "cover a 'กร๊อบ = ข้อเสื่อม?' too close to 2026-11-20-knowledge-old" in res.stdout
    assert 'cover b' in res.stdout and 'too close' in res.stdout


def test_layout_overlap_edge_small_and_low_contrast(tmp_path):
    r = repo(tmp_path)
    d = ep(r, '2026-11-27-knowledge-x', {'covers': GOOD})
    shot(d, 'a', [T('l1', 190, 290), T('l2', 190, 400), {'kind': 'badge', 'text': 'ลองทำตาม', 'x': 10, 'y': 140, 'w': 300, 'h': 70}])
    shot(d, 'b', [T('tiny', 190, 290, fs=40), T('l2', 190, 600)], light=False)
    out = run(d, '--no-git').stdout
    assert "cover a: the image says 'l1 / l2' but look.json covers says 'ร่างกายเรา / มี*อะไหล่*!?'" in out
    assert "text 'l1' overlaps text 'l2'" in out
    assert "badge 'ลองทำตาม' touches/leaves the edge" in out
    assert "text 'tiny' is 7.4 px at 200 px wide" in out
    assert "cover b: text 'l2' has low contrast" in out


def test_ctr_log(tmp_path):
    r = repo(tmp_path)
    d = ep(r, '2026-11-27-knowledge-x', {'covers': GOOD})
    assert run('log', d, '--variant', 'b', '--ctr', '12.5', '--impressions', '900').returncode == 0
    t = (r / 'channels' / 'knowledge' / 'cover-ctr.md').read_text()
    assert '| 2026-11-27-knowledge-x | b | หมอ*ตัด*เส้นนี้ / ไปใช้ได้!? | 12.5 | 900 |' in t


def _node_ok():
    if not shutil.which('node'):
        return False
    return subprocess.run(['node', '-e', "require('playwright')"], capture_output=True).returncode == 0


@pytest.mark.skipif(not _node_ok(), reason='node + playwright not installed')
def test_template_cover_shot_measures_and_passes(tmp_path):
    r = repo(tmp_path)
    d = ep(r, '2026-11-27-knowledge-x', {'palette': 'mint-paper', 'font': 'sarabun', 'covers': GOOD})
    shutil.copytree(ROOT / 'templates' / 'brainrot-v3', d / 'video', ignore=shutil.ignore_patterns('vendor', 'node_modules'))
    res = subprocess.run(['node', str(ROOT / 'tools' / 'cover_shot.js'), str(d / 'video' / 'cover.html'), str(d / 'covers'), 'a,b'],
                         capture_output=True, text=True, timeout=120)
    assert res.returncode == 0, res.stderr
    geo = json.loads((d / 'covers' / 'cover-a.json').read_text())
    lines = [i for i in geo['items'] if i['kind'] == 'text']
    assert [i['text'] for i in lines] == ['ร่างกายเรา', 'มีอะไหล่!?']
    assert lines[0]['y'] + lines[0]['h'] <= lines[1]['y'] + 5           # ink boxes, not the tall Thai line boxes
    res = run(d, '--final', '--no-git')
    assert res.returncode == 0, res.stdout
    assert geo['look']['palette'] == 'mint-paper'
    b = json.loads((d / 'covers' / 'cover-b.json').read_text())
    assert [i['text'] for i in b['items'] if i['kind'] == 'text'] == ['หมอตัดเส้นนี้', 'ไปใช้ได้!?']
    # palette from look.json reaches the image: mint-paper variant a is a light field (sunrise-coral default is dark)
    px = Image.open(d / 'covers' / 'cover-a.jpg').convert('L').getpixel((540, 1500))
    assert px > 150, px
    # look.json text changed but the image not re-shot -> ERROR (review 2026-11-26)
    lk = json.loads((d / 'look.json').read_text())
    lk['covers'][1]['lines'] = ['เส้นเอ็นสำรอง', 'ในข้อมือ!?']
    (d / 'look.json').write_text(json.dumps(lk, ensure_ascii=False))
    res = run(d, '--no-git')
    assert res.returncode == 1 and 'cover b: the image says' in res.stdout


@pytest.mark.skipif(not _node_ok(), reason='node + playwright not installed')
def test_template_default_is_a_placeholder_not_an_old_cover(tmp_path):
    html = (ROOT / 'templates' / 'brainrot-v3' / 'cover.html').read_text()
    assert 'อะไหล่' not in html and 'ตัดเส้นนี้' not in html            # no palmaris cover baked into the template
    r = repo(tmp_path)
    d = ep(r, '2026-11-27-knowledge-x', {'palette': 'mint-paper'})        # no "covers" in look.json
    shutil.copytree(ROOT / 'templates' / 'brainrot-v3', d / 'video', ignore=shutil.ignore_patterns('vendor', 'node_modules'))
    res = subprocess.run(['node', str(ROOT / 'tools' / 'cover_shot.js'), str(d / 'video' / 'cover.html'), str(d / 'covers'), 'a'],
                         capture_output=True, text=True, timeout=120)
    assert res.returncode != 0 and 'no "covers" entry' in res.stderr
