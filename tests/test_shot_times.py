"""tools/shot_times.py: good run, media_start priority, and the 4 hard errors (exit 1, nothing written)."""
import json, pathlib, subprocess, sys

import pytest

ROOT = pathlib.Path(__file__).resolve().parents[1]
TOOL = ROOT / 'tools' / 'shot_times.py'

# synthetic transcript: one word per second, "w0 w1 ... w9"
WORDS = {'audio_duration_secs': 10.0,
         'words': [{'type': 'word', 'text': f'w{i}x', 'start': float(i), 'end': i + 0.5} for i in range(10)]}


def run(tmp_path, shots):
    (tmp_path / 'assets' / 'audio').mkdir(parents=True, exist_ok=True)
    (tmp_path / 'assets' / 'audio' / 'words.json').write_text(json.dumps(WORDS))
    (tmp_path / 'shots.json').write_text(json.dumps({'lead': 0.08, 'shots': shots}))
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
])
def test_errors_fail_and_write_nothing(tmp_path, name, mutate, msg):
    shots = good()
    mutate(shots)
    r, res = run(tmp_path, shots)
    assert r.returncode != 0
    assert msg in r.stderr
    assert res is None, 'shots-th.json must not be written when there are errors'
