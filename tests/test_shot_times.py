"""tools/shot_times.py: good run, media_start priority, and the 4 hard errors (exit 1, nothing written)."""
import json, pathlib, subprocess, sys

import pytest

ROOT = pathlib.Path(__file__).resolve().parents[1]
TOOL = ROOT / 'tools' / 'shot_times.py'

# synthetic transcript: one word per second, "w0 w1 ... w9"
WORDS = {'audio_duration_secs': 10.0,
         'words': [{'type': 'word', 'text': f'w{i}x', 'start': float(i), 'end': i + 0.5} for i in range(10)]}


def run(tmp_path, shots, raw=None, footage=None):
    (tmp_path / 'assets' / 'audio').mkdir(parents=True, exist_ok=True)
    (tmp_path / 'assets' / 'audio' / 'words.json').write_text(json.dumps(WORDS))
    (tmp_path / 'shots.json').write_text(raw if raw is not None else json.dumps({'lead': 0.08, 'shots': shots}))
    if footage is not None:
        (tmp_path / 'footage.json').write_text(json.dumps(footage))
    r = subprocess.run([sys.executable, str(TOOL), str(tmp_path), 'th'], capture_output=True, text=True)
    out = tmp_path / 'assets' / 'audio' / 'shots-th.json'
    return r, (json.loads(out.read_text()) if out.exists() else None)


def shot(i, **kw):
    return {'id': f's{i}', 'cue': {'th': f'w{i}x'}, **kw}


def good():
    return [shot(0), shot(2, hit={'th': 'w3x'}, action_at=5.0), shot(4), shot(6), shot(8, long_ok=True)]


def test_ok(tmp_path):
    r, res = run(tmp_path, good())
    assert r.returncode == 0, r.stderr
    s = {x['id']: x for x in res['shots']}
    assert s['s0']['start'] == 0.0 and s['s2']['start'] == 1.92 and s['s2']['hit_at'] == 3.0
    assert s['s2']['media_start'] == 3.92          # action_at 5.0 - (hit 3.0 - start 1.92)
    assert 'media_start' not in s['s4']


def test_explicit_media_start_wins_over_action_at(tmp_path):
    shots = good()
    shots[1]['media_start'] = 1.25                 # director's pick from the contact sheet
    r, res = run(tmp_path, shots)
    assert r.returncode == 0, r.stderr
    assert res['shots'][1]['media_start'] == 1.25


def test_long_shot_is_only_a_warning(tmp_path):
    shots = [shot(0), shot(5), shot(8)]            # s0 = 0-4.92 s, no long_ok
    r, res = run(tmp_path, shots)
    assert r.returncode == 0 and 'WARN s0' in r.stdout and res is not None


@pytest.mark.parametrize('name,mutate,msg', [
    ('cue_missing', lambda s: s[2].update(cue={'th': 'nothere'}), "cue 'nothere' not found"),
    ('hit_outside_shot', lambda s: s[1].update(hit={'th': 'w5x'}), 'outside the shot'),
    ('hit_not_found', lambda s: s[1].update(hit={'th': 'zzz'}), "hit 'zzz' not found"),
    ('media_start_negative', lambda s: s[1].update(action_at=0.2), 'too early in the source'),
    ('explicit_media_start_negative', lambda s: s[1].update(media_start=-0.5), 'is negative'),
    ('cue_only_punctuation_last', lambda s: s.append({'id': 'bang', 'cue': {'th': '!'}}), "bang: cue '!' is only"),
    ('cue_only_punctuation_first', lambda s: s[0].update(cue={'th': '!'}), "s0: cue '!' is only"),
    ('cue_missing_lang', lambda s: s[0].update(cue={'en': 'w0x'}), 's0: no cue for th'),
    ('hit_only_punctuation', lambda s: s[1].update(hit={'th': '...'}), 's2: hit'),
    ('media_start_nan_string', lambda s: s[1].update(media_start='NaN'), 'not a finite number'),
    ('media_start_number_string', lambda s: s[1].update(media_start='2.0'), 'not a finite number'),
    ('media_start_bool', lambda s: s[1].update(media_start=True), 'not a finite number'),
    ('action_at_string', lambda s: s[1].update(action_at='Infinity'), 'not a finite number'),
    ('duplicate_id', lambda s: s[3].update(id='s2', media_start=-1), 'duplicate id'),
    ('missing_id', lambda s: s[3].pop('id'), 'missing "id"'),
])
def test_errors_fail_and_write_nothing(tmp_path, name, mutate, msg):
    shots = good()
    mutate(shots)
    r, res = run(tmp_path, shots)
    assert r.returncode != 0
    assert msg in r.stderr
    assert res is None, 'shots-th.json must not be written when there are errors'


@pytest.mark.parametrize('lit', ['NaN', 'Infinity', '-Infinity'])
def test_json_nan_infinity_literals_rejected(tmp_path, lit):
    raw = '{"shots": [{"id": "a", "cue": "w0x"}, {"id": "b", "cue": "w2x", "media_start": %s}]}' % lit
    r, res = run(tmp_path, None, raw=raw)
    assert r.returncode == 1 and 'not a finite number' in r.stderr and res is None


def test_lead_must_be_number(tmp_path):
    r, res = run(tmp_path, None, raw='{"lead": NaN, "shots": [{"id": "a", "cue": "w0x"}]}')
    assert r.returncode == 1 and 'lead' in r.stderr and res is None


def test_empty_shots_rejected(tmp_path):
    r, res = run(tmp_path, [])
    assert r.returncode == 1 and 'no shots' in r.stderr and res is None


def test_media_start_zero_and_minus_zero(tmp_path):
    shots = good()
    shots[1]['media_start'] = 0
    shots[2]['action_at'] = 0.08                   # = word_at - start -> exactly 0, must not print -0.0
    r, res = run(tmp_path, shots)
    assert r.returncode == 0, r.stderr
    assert res['shots'][1]['media_start'] == 0 and '-0.0' not in (tmp_path / 'assets/audio/shots-th.json').read_text()


def test_failed_rerun_deletes_stale_timeline(tmp_path):
    r, res = run(tmp_path, good())
    assert r.returncode == 0 and res is not None
    bad = good()
    bad[2]['cue'] = {'th': 'nothere'}
    r, res = run(tmp_path, bad)                    # same directory, second run fails
    assert r.returncode == 1 and res is None, 'old shots-th.json must not survive a failed run'
    assert 'old copy deleted' in r.stderr


def test_footage_json_survives_shots_rewrite(tmp_path):
    foot = {'s2': {'src': 'assets/footage/glass.mp4', 'action_at': 5.0}}
    r, res = run(tmp_path, [shot(0), shot(2, hit={'th': 'w3x'}), shot(4)], footage=foot)
    assert r.returncode == 0, r.stderr
    s2 = res['shots'][1]
    assert s2['src'] == 'assets/footage/glass.mp4' and s2['media_start'] == 3.92
    # director rewrites shots.json (new cue for s2, no src/action_at in it) -> footage data still applies
    r, res = run(tmp_path, [shot(0), {'id': 's2', 'cue': {'th': 'w3x'}}, shot(5)], footage=foot)
    assert r.returncode == 0, r.stderr
    s2 = res['shots'][1]
    assert s2['src'] == 'assets/footage/glass.mp4' and s2['word_at'] == 3.0 and s2['media_start'] == 5.0 - 0.08


def test_footage_json_unknown_id_and_conflict_warn(tmp_path):
    shots = good()
    shots[1]['src'] = 'assets/footage/old.mp4'
    r, res = run(tmp_path, shots, footage={'s2': {'src': 'assets/footage/new.mp4'}, 'ghost': {'src': 'x.mp4'}})
    assert r.returncode == 0, r.stderr
    assert res['shots'][1]['src'] == 'assets/footage/new.mp4'
    assert "WARN footage.json has 'ghost'" in r.stdout and 'differs from footage.json' in r.stdout


def test_english_and_repeated_cue(tmp_path):
    (tmp_path / 'assets' / 'audio').mkdir(parents=True)
    words = {'words': [{'type': 'word', 'text': t, 'start': float(i), 'end': i + 0.5}
                       for i, t in enumerate(['Hello,', 'water', 'again', 'water', 'thirsty.'])]}
    (tmp_path / 'assets' / 'audio' / 'words-en.json').write_text(json.dumps(words))
    (tmp_path / 'shots.json').write_text(json.dumps({'shots': [
        {'id': 'a', 'cue': {'en': 'hello'}}, {'id': 'b', 'cue': {'en': 'water'}},
        {'id': 'c', 'cue': {'en': 'water'}, 'hit': {'en': 'thirsty'}}]}))
    r = subprocess.run([sys.executable, str(TOOL), str(tmp_path), 'en'], capture_output=True, text=True)
    assert r.returncode == 0, r.stderr
    s = json.loads((tmp_path / 'assets' / 'audio' / 'shots-en.json').read_text())['shots']
    assert [x['word_at'] for x in s] == [0.0, 1.0, 3.0] and s[2]['hit_at'] == 4.0
