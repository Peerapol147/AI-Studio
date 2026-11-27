"""tools/timing.py: timing.md line times come from words.json (caffeine-ranking 2026-11-27: hand-estimated starts were wrong)."""
import json, pathlib, subprocess, sys

ROOT = pathlib.Path(__file__).resolve().parents[1]


def words(*items):
    return {'audio_duration_secs': 10.0, 'words': [{'type': 'word', 'text': t, 'start': s, 'end': e} for t, s, e in items]}


def run(proj, *a):
    return subprocess.run([sys.executable, str(ROOT / 'tools' / 'timing.py'), str(proj), *a], capture_output=True, text=True)


def test_times_from_words_json_misspelled_word_and_gap(tmp_path):
    aud = tmp_path / 'assets' / 'audio'
    aud.mkdir(parents=True)
    # transcript: "ทำไม ท้องร้อง" / "เพราะ ลม" / scribe wrote "Trick" for ทริก / long pause before the last line
    (aud / 'words.json').write_text(json.dumps(words(('ทำไม', 0.06, 0.4), ('ท้องร้อง', 0.42, 1.1), ('เพราะ', 1.3, 1.6),
                                                     ('ลม', 1.62, 1.9), ('Trick', 2.0, 2.5), ('นี้', 2.52, 2.8),
                                                     ('ลองดู', 4.0, 4.6)), ensure_ascii=False))
    (tmp_path / 'script-vo-th.txt').write_text('ทำไมท้องร้อง?\nเพราะลม\nทริกนี้\nลองดู\n')
    r = run(tmp_path)
    assert r.returncode == 0, r.stdout
    md = (aud / 'timing.md').read_text()
    assert '| 1 | ทำไมท้องร้อง? | 0.06 | 1.10 | 1.04 |  |' in md
    assert '| 2 | เพราะลม | 1.30 | 1.90 | 0.60 |  |' in md
    row3 = next(l for l in md.splitlines() if l.startswith('| 3 |'))
    assert '≈' in row3 and ' 2.52 ' in row3                          # ทริก not in the transcript: matched only "นี้"
    assert '| 4 | ลองดู | 4.00 | 4.60 |' in md and '2.80-4.00' in md   # gap > 0.4 s listed
    assert 'ห้ามประมาณเอง' in md


def test_one_line_script_split_at_spaces_and_missing_inputs(tmp_path):
    aud = tmp_path / 'assets' / 'audio'
    aud.mkdir(parents=True)
    assert run(tmp_path).returncode == 1                              # no words.json
    (aud / 'words.json').write_text(json.dumps(words(('ทำไม', 0.0, 0.3), ('ปวด', 0.5, 0.8)), ensure_ascii=False))
    assert run(tmp_path).returncode == 1                              # no script
    (aud / 'vo-th-tts.txt').write_text('ทำไม ปวด')
    r = run(tmp_path)
    assert r.returncode == 0 and '| 2 | ปวด | 0.50 | 0.80 |' in (aud / 'timing.md').read_text()
