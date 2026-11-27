"""tools/pacing.py (editing v3 story beats) on a synthetic 20 s voice, through tools/shot_times.py."""
import json, pathlib, subprocess, sys

ROOT = pathlib.Path(__file__).resolve().parents[1]
WORDS = {'audio_duration_secs': 20.0,
         'words': [{'type': 'word', 'text': f'w{i}x', 'start': float(i), 'end': i + 0.5} for i in range(20)]}
# cue word index -> beat; lead 0 so a shot starts on its word
GOOD = [(0, 'hook'), (1, 'hook'), (2, 'setup'), (4, 'explain'), (6, 'explain'), (8, 'explain'), (10, 'reveal'),
        (12, 'twist'), (13, 'twist'), (14, 'share'), (16, 'cta'), (18, 'loop')]


def run(tmp_path, beats=GOOD, topic='w0xw1x', genre=None, src_loop='a.mp4', extra=None):
    (tmp_path / 'assets' / 'audio').mkdir(parents=True, exist_ok=True)
    (tmp_path / 'assets' / 'audio' / 'words.json').write_text(json.dumps(WORDS))
    shots = [{'id': f's{i}', 'cue': {'th': f'w{i}x'}, **({'beat': b} if b else {}), 'long_ok': True,
              'src': 'a.mp4' if n == 0 else (src_loop if n == len(beats) - 1 else f'{i}.mp4')}
             for n, (i, b) in enumerate(beats)]
    plan = {'lead': 0, 'shots': shots, **({'topic': {'th': topic}} if topic else {}), **({'genre': genre} if genre else {}), **(extra or {})}
    (tmp_path / 'shots.json').write_text(json.dumps(plan))
    r = subprocess.run([sys.executable, str(ROOT / 'tools' / 'shot_times.py'), str(tmp_path), 'th'], capture_output=True, text=True)
    if r.returncode:
        return r
    return subprocess.run([sys.executable, str(ROOT / 'tools' / 'pacing.py'), str(tmp_path)], capture_output=True, text=True)


def test_good_structure(tmp_path):
    r = run(tmp_path)
    assert r.returncode == 0, r.stdout + r.stderr
    assert 'pacing: OK' in r.stdout and 'WARN' not in r.stdout
    assert "said by 1.50 s" in r.stdout


def test_topic_after_1_5_s_fails(tmp_path):
    r = run(tmp_path, topic='w0xw1xw2x')
    assert r.returncode == 1 and 'ends at 2.50 s' in r.stdout
    r = run(tmp_path, topic=None)
    assert r.returncode == 1 and 'no "topic"' in r.stdout


def test_missing_share_cta_twist_and_beats_fail(tmp_path):
    beats = [b if b[1] != 'share' else (b[0], 'explain') for b in GOOD]
    r = run(tmp_path, beats)
    assert r.returncode == 1 and 'no "share"' in r.stdout
    beats = [b if b[1] != 'twist' else (b[0], 'explain') for b in GOOD]
    r = run(tmp_path, beats)
    assert r.returncode == 1 and 'no "twist" shot after the reveal' in r.stdout
    beats = GOOD[:-1] + [(18, None)]
    r = run(tmp_path, beats)
    assert r.returncode == 1 and 'without "beat"' in r.stdout and 'must be beat "loop"' in r.stdout


def test_late_reveal_short_explain_slow_hook_warn(tmp_path):
    beats = [(0, 'hook'), (4, 'setup'), (5, 'explain'), (8, 'explain'), (13, 'explain'), (14, 'reveal'),
             (15, 'twist'), (17, 'share'), (18, 'cta'), (19, 'loop')]
    r = run(tmp_path, beats, topic='w0x')
    assert r.returncode == 0, r.stdout
    assert 'reveal starts at 70%' in r.stdout
    assert 'explain shot s13 is 1.00 s' in r.stdout and 'explain shot s8 is 5.00 s' in r.stdout
    assert 'explain shot s5' not in r.stdout
    assert 'not faster than the rest' in r.stdout


def test_cut_pace_is_info_not_warn(tmp_path):
    # style.md 4 (user 2026-11-25): cut pace depends on the clip -> never WARN/FAIL
    beats = [(0, 'hook'), (1, 'hook'), (2, 'setup'), (4, 'explain'), (5, 'explain'), (6, 'explain'), (7, 'explain'),
             (8, 'explain'), (10, 'reveal'), (12, 'twist'), (14, 'share'), (16, 'cta'), (18, 'loop')]
    r = run(tmp_path, beats)
    assert r.returncode == 0, r.stdout
    assert 'INFO explain shot s4 is 1.00 s' in r.stdout
    assert not any(l.startswith('WARN') and ('explain shot' in l or 'not faster' in l) for l in r.stdout.splitlines())


def test_loop_source_differs_warns(tmp_path):
    r = run(tmp_path, src_loop='other.mp4')
    assert r.returncode == 0 and 'check the loop by eye' in r.stdout


def test_legend_needs_twist_not_reveal(tmp_path):
    beats = [b if b[1] != 'reveal' else (b[0], 'explain') for b in GOOD]
    r = run(tmp_path, beats, genre='legend')
    assert r.returncode == 0, r.stdout
    assert 'legend: twist starts at 60%' in r.stdout and 'before 70%' in r.stdout


def test_unknown_beat_is_a_shot_times_error_and_stale_refused(tmp_path):
    r = run(tmp_path, GOOD[:-1] + [(18, 'outro')])
    assert r.returncode == 1 and "beat 'outro' must be one of" in r.stderr
    r = run(tmp_path)
    assert r.returncode == 0
    (tmp_path / 'shots.json').write_text((tmp_path / 'shots.json').read_text().replace('"lead": 0', '"lead": 0.08'))
    r = subprocess.run([sys.executable, str(ROOT / 'tools' / 'pacing.py'), str(tmp_path)], capture_output=True, text=True)
    assert r.returncode == 1 and 'stale' in r.stdout


def test_explain_up_to_3_s_needs_no_long_ok(tmp_path):
    (tmp_path / 'assets' / 'audio').mkdir(parents=True)
    (tmp_path / 'assets' / 'audio' / 'words.json').write_text(json.dumps(WORDS))
    shots = [{'id': 'a', 'cue': {'th': 'w0x'}, 'beat': 'hook'}, {'id': 'b', 'cue': {'th': 'w1x'}, 'beat': 'explain'},
             {'id': 'c', 'cue': {'th': 'w4x'}, 'beat': 'setup'}, {'id': 'd', 'cue': {'th': 'w5x'}, 'long_ok': True}]
    (tmp_path / 'shots.json').write_text(json.dumps({'lead': 0, 'shots': shots}))
    r = subprocess.run([sys.executable, str(ROOT / 'tools' / 'shot_times.py'), str(tmp_path), 'th'], capture_output=True, text=True)
    assert r.returncode == 0 and 'WARN b:' not in r.stdout
    assert json.loads((tmp_path / 'assets' / 'audio' / 'shots-th.json').read_text())['shots'][1]['beat'] == 'explain'


def _long(tmp_path, n, reason=None):
    """n-second voice, shots spread over it with the GOOD beat order."""
    words = {'audio_duration_secs': float(n),
             'words': [{'type': 'word', 'text': f'w{i}x', 'start': float(i), 'end': i + 0.5} for i in range(n)]}
    (tmp_path / 'assets' / 'audio').mkdir(parents=True, exist_ok=True)
    (tmp_path / 'assets' / 'audio' / 'words.json').write_text(json.dumps(words))
    at = [0, 1, 3, 6, 9, int(n * .55), int(n * .6), int(n * .7), int(n * .8), n - 2]
    beats = ['hook', 'hook', 'setup', 'explain', 'explain', 'reveal', 'twist', 'share', 'cta', 'loop']
    shots = [{'id': f's{i}', 'cue': {'th': f'w{i}x'}, 'beat': b, 'long_ok': True, 'src': 'a.mp4'} for i, b in zip(at, beats)]
    plan = {'lead': 0, 'topic': {'th': 'w0x'}, 'shots': shots, **({'long_reason': reason} if reason else {})}
    (tmp_path / 'shots.json').write_text(json.dumps(plan))
    r = subprocess.run([sys.executable, str(ROOT / 'tools' / 'shot_times.py'), str(tmp_path), 'th'], capture_output=True, text=True)
    assert r.returncode == 0, r.stderr
    return subprocess.run([sys.executable, str(ROOT / 'tools' / 'pacing.py'), str(tmp_path)], capture_output=True, text=True)


def test_length_default_20_to_40_s(tmp_path):
    r = _long(tmp_path / 'a', 45)
    assert r.returncode == 1 and 'default is 20-40 s' in r.stdout
    r = _long(tmp_path / 'b', 45, reason='two-layer twist needs the extra step')
    assert r.returncode == 0, r.stdout
    r = _long(tmp_path / 'c', 62, reason='x')
    assert r.returncode == 1 and 'over the 59 s ceiling' in r.stdout
    r = _long(tmp_path / 'd', 19)
    assert r.returncode == 0 and 'clip is 19.0 s (default 20-40 s)' in r.stdout


def test_share_before_twist_warns_and_v3_loop_not_flagged(tmp_path):
    beats = [(0, 'hook'), (1, 'hook'), (2, 'setup'), (4, 'explain'), (6, 'explain'), (8, 'explain'), (10, 'reveal'),
             (12, 'share'), (14, 'twist'), (16, 'cta'), (18, 'loop')]
    (tmp_path / 'video').mkdir()
    (tmp_path / 'video' / 'episode.json').write_text('{}')
    r = run(tmp_path, beats, src_loop='other.mp4')
    assert r.returncode == 0 and '"share" comes before the twist' in r.stdout
    assert 'check the loop by eye' not in r.stdout


def test_topic_exception_turns_late_topic_into_info(tmp_path):
    """never-colonized 2026-11-27: the user approved a hook that names the topic after 1.5 s because frame 0 shows it
    on screen. "topic_exception" with a reason -> INFO; an empty/short reason is still a FAIL; not found = FAIL."""
    why = 'เฟรม 0 ขึ้นหัวข้อบนจอ ผู้ใช้อนุมัติ 2026-11-27'
    r = run(tmp_path, topic='w0xw1xw2x', extra={'topic_exception': why})
    assert r.returncode == 0, r.stdout
    assert 'INFO topic' in r.stdout and 'ends at 2.50 s' in r.stdout and why in r.stdout and 'pacing: OK' in r.stdout
    r = run(tmp_path, topic='w0xw1xw2x', extra={'topic_exception': 'ok'})
    assert r.returncode == 1 and 'topic_exception' in r.stdout
    r = run(tmp_path, topic='nope', extra={'topic_exception': why})
    assert r.returncode == 1 and 'not found in the voice' in r.stdout
    r = run(tmp_path, topic='w0xw1xw2x')
    assert r.returncode == 1 and '"topic_exception"' in r.stdout          # the FAIL names the way out
