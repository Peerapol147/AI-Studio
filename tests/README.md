# smoke tests (python only, no API keys, no clip render)

    pip install pytest numpy soundfile scipy matplotlib librosa   # + ffmpeg
    python3 -m pytest -q tests

- `test_build_index.py`: `templates/brainrot-v2/build_index.py` builds index.html from a fresh checkout (fixture in `fixtures/brainrot/`)
- `test_build_index_v3.py`: `templates/brainrot-v3/build_index.py` builds two different looks from look.json (fixture `fixtures/v3/`), refuses a missing look / unknown value / shot without beat
- `test_look.py`: `tools/look.py` pick avoids the channel's last 3 looks; check fails on same palette/opening/music as the previous episode or an identical look, reads ep branches from git
- `test_pacing.py`: `tools/pacing.py` topic by 1.5 s, reveal 50-60 %, twist/share/cta present, explain holds 2-3 s; `beat` in shot_times
- `test_shot_times.py`: `tools/shot_times.py` good run, media_start priority, footage.json merge by id, the hard errors (empty shots/cue, NaN/Infinity, duplicate id) and stale-timeline deletion
- `test_fetch.py`: `tools/get.sh` (200/403/429/5xx/4xx/timeout, never overwrites a good file, key masked) and tts/words/voices/footage/music + `tools/credits.py` against a local mock server (`conftest.py`); no real API is called
- `test_sound_pass_vo.py`: `tools/sound_pass_vo.py` mixes synthetic sine/kick audio and writes report.html from a clone at another path

Fixtures stay tiny and self-made: no footage, music, logos or keys (the repo is public).
