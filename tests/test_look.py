"""tools/look.py: pick avoids the channel's last 3 looks; check refuses repeats (local projects/ and ep branches)."""
import json, pathlib, shutil, subprocess, sys

ROOT = pathlib.Path(__file__).resolve().parents[1]
TOOL = ROOT / 'tools' / 'look.py'
BASE = {'template': 'brainrot-v3', 'palette': 'sunrise-coral', 'font': 'prompt', 'caption': 'box', 'opening': 'pov',
        'cover': 'card', 'transition': 'slide', 'music_mood': 'lofi', 'voice': 'liam', 'music_file': 'music-a.mp3'}


def repo(tmp_path, git=False):
    r = tmp_path / 'repo'
    (r / 'templates' / 'looks').mkdir(parents=True)
    shutil.copy(ROOT / 'templates' / 'looks' / 'looks.json', r / 'templates' / 'looks' / 'looks.json')
    (r / 'projects').mkdir()
    if git:
        g(r, 'init', '-q', '-b', 'main')
    return r


def g(r, *a):
    subprocess.run(['git', '-C', str(r), '-c', 'user.email=t@t', '-c', 'user.name=t', *a], check=True, capture_output=True)


def ep(r, pid, look=None, html=None):
    d = r / 'projects' / pid
    d.mkdir(parents=True)
    (d / 'brief.md').write_text('x')
    if look is not None:
        (d / 'look.json').write_text(json.dumps(look))
    if html:
        (d / 'video').mkdir()
        (d / 'video' / 'index.html').write_text(html)
    return d


def run(*a):
    return subprocess.run([sys.executable, str(TOOL), *map(str, a)], capture_output=True, text=True)


def test_pick_avoids_last_three_and_passes_check(tmp_path):
    r = repo(tmp_path)
    ep(r, '2026-11-20-knowledge-a', {**BASE, 'palette': 'night-violet', 'opening': 'question'})
    ep(r, '2026-11-21-knowledge-b', {**BASE, 'palette': 'sunrise-coral', 'opening': 'pov', 'music_file': 'music-b.mp3'})
    ep(r, '2026-11-21-knowledge-c', {**BASE, 'palette': 'mint-paper', 'opening': 'number', 'music_file': 'music-c.mp3'})
    new = r / 'projects' / '2026-11-22-knowledge-new'
    res = run('pick', new, '--write', '--no-git')
    assert res.returncode == 0, res.stderr
    look = json.loads((new / 'look.json').read_text())
    assert look['palette'] not in ('night-violet', 'sunrise-coral', 'mint-paper')
    assert look['opening'] == 'midstory'                     # the only opening not used in the last 3
    assert run('pick', new, '--write', '--no-git').returncode != 0   # never overwrites
    res = run('check', new, '--no-git')
    assert res.returncode == 0 and 'look: OK' in res.stdout and 'music_file not set' in res.stdout
    assert run('check', new, '--final', '--no-git').returncode == 1  # final needs the music track
    look['music_file'] = 'music-new.mp3'
    look['cover_text'] = 'แมวกลัวน้ำจริงไหม?'
    (new / 'look.json').write_text(json.dumps(look))
    assert run('check', new, '--final', '--no-git').returncode == 0


def test_same_palette_or_opening_as_previous_fails(tmp_path):
    r = repo(tmp_path)
    ep(r, '2026-11-21-knowledge-b', BASE)
    new = ep(r, '2026-11-22-knowledge-new', {**BASE, 'opening': 'number', 'music_file': 'm2.mp3'})
    res = run('check', new, '--no-git')
    assert res.returncode == 1 and 'palette' in res.stdout and 'ERROR' in res.stdout
    (new / 'look.json').write_text(json.dumps({**BASE, 'palette': 'ocean-teal', 'music_file': 'm2.mp3'}))
    res = run('check', new, '--no-git')
    assert res.returncode == 1 and "opening 'pov'" in res.stdout


def test_legacy_episode_counts_as_v2_look_and_music_from_html(tmp_path):
    r = repo(tmp_path)
    ep(r, '2026-11-21-knowledge-old', None, html='<audio src="assets/music-jamendo-b386828e.mp3"></audio>')
    new = ep(r, '2026-11-22-knowledge-new', {**BASE, 'palette': 'night-violet', 'music_file': 'music-jamendo-b386828e.mp3'})
    res = run('check', new, '--no-git')
    assert res.returncode == 1
    assert 'brainrot-v2 look' in res.stdout and "palette 'night-violet'" in res.stdout and 'music_file' in res.stdout


def test_identical_visual_look_to_third_last_fails_other_channel_ignored(tmp_path):
    r = repo(tmp_path)
    ep(r, '2026-11-19-knowledge-a', BASE)
    ep(r, '2026-11-20-knowledge-b', {**BASE, 'palette': 'mono-yellow', 'opening': 'number', 'music_file': 'b.mp3'})
    ep(r, '2026-11-21-knowledge-c', {**BASE, 'palette': 'ocean-teal', 'opening': 'question', 'music_file': 'c.mp3'})
    ep(r, '2026-11-21-football-z', {**BASE, 'palette': 'retro-cream', 'opening': 'midstory'})
    new = ep(r, '2026-11-22-knowledge-new', {**BASE, 'music_file': 'n.mp3'})
    res = run('check', new, '--no-git')
    assert res.returncode == 1 and 'identical to 2026-11-19-knowledge-a' in res.stdout
    assert 'football' not in res.stdout


def test_episode_only_on_a_git_branch_is_compared(tmp_path):
    r = repo(tmp_path, git=True)
    (r / 'README').write_text('x'); g(r, 'add', '.'); g(r, 'commit', '-qm', 'base')
    g(r, 'checkout', '-qb', 'claude/ep-2026-11-21-b')
    ep(r, '2026-11-21-knowledge-b', {**BASE, 'palette': 'ocean-teal'})
    g(r, 'add', '.'); g(r, 'commit', '-qm', 'ep b')
    g(r, 'checkout', '-q', 'main')
    assert not (r / 'projects' / '2026-11-21-knowledge-b').exists()
    new = ep(r, '2026-11-22-knowledge-new', {**BASE, 'palette': 'ocean-teal', 'opening': 'number', 'music_file': 'z.mp3'})
    res = run('check', new)
    assert res.returncode == 1 and 'claude/ep-2026-11-21-b' in res.stdout and "palette 'ocean-teal'" in res.stdout
    assert run('check', new, '--no-git').returncode == 0     # without git history there is nothing to repeat


def test_unknown_value_fails_voice_id_matches_catalog_name(tmp_path):
    r = repo(tmp_path)
    ep(r, '2026-11-21-knowledge-b', {**BASE, 'voice': 'george'})
    new = ep(r, '2026-11-22-knowledge-new', {**BASE, 'palette': 'neon', 'opening': 'number', 'voice': 'id:JBFqnCBsd6RMkjVDRZzb',
                                              'music_file': 'q.mp3'})
    res = run('check', new, '--no-git')
    assert res.returncode == 1 and "palette: 'neon' not in" in res.stdout
    assert 'WARN  voice' in res.stdout                        # id:JBFq... is George = same voice as last time


def test_cover_text_repeat_or_similar_fails(tmp_path):
    r = repo(tmp_path)
    old = ep(r, '2026-11-20-knowledge-knuckle', None)
    (old / 'thumbnail.md').write_text('# ปก\n- ข้อความ (≤4 คำ): **"กร๊อบ = ข้อเสื่อม?"** ตัวใหญ่\n')
    ep(r, '2026-11-21-knowledge-b', {**BASE, 'palette': 'ocean-teal', 'opening': 'number', 'cover_text': 'ตดในอวกาศ'})
    look = {**BASE, 'palette': 'mono-yellow', 'opening': 'question', 'music_file': 'n.mp3'}
    new = ep(r, '2026-11-22-knowledge-knee', {**look, 'cover_text': 'กร๊อบ = ข้อเสื่อม?'})
    res = run('check', new, '--no-git')
    assert res.returncode == 1 and 'too close to 2026-11-20-knowledge-knuckle' in res.stdout and 'similarity 1.00' in res.stdout
    (new / 'look.json').write_text(json.dumps({**look, 'cover_text': 'เข่ากร๊อบ = ข้อเสื่อม?'}))
    assert run('check', new, '--no-git').returncode == 1         # one word added is still the same cover
    (new / 'look.json').write_text(json.dumps({**look, 'cover_text': 'เข่าลั่นตอนลุก อันตรายไหม?'}))
    assert run('check', new, '--no-git').returncode == 0


def test_music_from_credits_json_and_future_episodes_ignored(tmp_path):
    r = repo(tmp_path)
    old = ep(r, '2026-11-21-knowledge-lore', None)
    (old / 'assets' / 'credits').mkdir(parents=True)
    (old / 'assets' / 'credits' / 'music.json').write_text('{"audio/music-jamendo-a573d9da.mp3": "Dark Space"}')
    ep(r, '2026-11-25-knowledge-future', {**BASE, 'palette': 'ocean-teal'})
    new = ep(r, '2026-11-22-knowledge-new', {**BASE, 'music_file': 'music-jamendo-a573d9da.mp3', 'cover_text': 'x'})
    res = run('check', new, '--no-git')
    assert res.returncode == 1 and 'music_file music-jamendo-a573d9da.mp3 = previous episode 2026-11-21-knowledge-lore' in res.stdout
    assert 'future' not in res.stdout


def test_no_ep_branches_warns_and_final_fails(tmp_path):
    r = repo(tmp_path, git=True)
    new = ep(r, '2026-11-22-knowledge-new', {**BASE, 'cover_text': 'x'})
    res = run('check', new)
    assert res.returncode == 0 and 'WARN  git knows no claude/ep-* branch' in res.stdout
    res = run('check', new, '--final')
    assert res.returncode == 1 and 'ERROR git knows no claude/ep-* branch' in res.stdout


def _thumb(d, line):
    (d / 'thumbnail.md').write_text(f'# ปก\n{line}\n')


def test_cover_repeat_caught_across_all_episodes_and_quoted_format(tmp_path):
    """The real case: knee-crack (11-20) reused the knuckle-crack (11-18) cover ~10 episodes later, and the
    knuckle-crack thumbnail.md writes the text in plain quotes (TH "...") not **bold**."""
    r = repo(tmp_path)
    old = ep(r, '2026-11-18-knowledge-knuckle-crack')
    _thumb(old, '- ข้อความ ≤4 คำ: TH "กร๊อบ = ข้อเสื่อม?" | EN "CRACK = ARTHRITIS?"')
    pals = ['night-violet', 'mint-paper', 'mono-yellow', 'ocean-teal']
    for i in range(4):                                   # 4 newer episodes push the knuckle one out of the last 3
        ep(r, f'2026-11-19-knowledge-filler{i}', {**BASE, 'palette': pals[i], 'cover_text': f'เรื่องที่ {i} ไม่ซ้ำกันเลย',
                                                   'music_file': f'f{i}.mp3'})
    new = ep(r, '2026-11-20-knowledge-knee-crack', {**BASE, 'palette': 'sunrise-coral', 'opening': 'number',
                                                    'cover_text': 'กร๊อบ = ข้อเสื่อม?', 'music_file': 'n.mp3'})
    res = run('check', new, '--no-git')
    assert res.returncode == 1 and '2026-11-18-knowledge-knuckle-crack' in res.stdout and 'cover_text' in res.stdout


def test_cover_text_reader_formats():
    sys.path.insert(0, str(ROOT / 'tools'))
    import look
    assert look._cover_from_thumb('- ข้อความ ≤4 คำ: TH "หาว = ขาดออกซิเจน?" | EN "YAWN"') == 'หาว = ขาดออกซิเจน?'
    assert look._cover_from_thumb('- ข้อความ (≤4 คำ): **แมวกลัวน้ำ?** ตัวใหญ่ + ป้าย "รู้ไหม?"') == 'แมวกลัวน้ำ?'
    assert look._cover_from_thumb('- ข้อความ ≤4 คำ: **"ผีอำ = ผีจริง?"** (ตัวใหญ่)') == 'ผีอำ = ผีจริง?'
    assert look._cover_from_thumb('ข้อยกเว้นจาก skill: skill ห้ามข้อความปกซ้ำชื่อคลิป') is None


def test_music_reused_within_last_three_warns(tmp_path):
    r = repo(tmp_path)
    ep(r, '2026-11-20-knowledge-a', {**BASE, 'palette': 'mint-paper', 'opening': 'question', 'music_file': 'same.mp3'})
    ep(r, '2026-11-21-knowledge-b', {**BASE, 'palette': 'ocean-teal', 'opening': 'number', 'music_file': 'other.mp3'})
    new = ep(r, '2026-11-22-knowledge-new', {**BASE, 'palette': 'night-violet', 'opening': 'pov',
                                             'music_file': 'same.mp3', 'cover_text': 'ใหม่หมด'})
    res = run('check', new, '--no-git')
    assert 'WARN  music_file same.mp3 also used in 2026-11-20-knowledge-a' in res.stdout
