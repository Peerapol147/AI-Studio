# smoke tests (python only, no API keys, no clip render)

    pip install pytest numpy soundfile scipy matplotlib librosa   # + ffmpeg
    python3 -m pytest -q tests

- `test_build_index.py`: `templates/brainrot-v2/build_index.py` builds index.html from a fresh checkout (fixture in `fixtures/brainrot/`)
- `test_shot_times.py`: `tools/shot_times.py` good run, media_start priority, and the hard errors
- `test_sound_pass_vo.py`: `tools/sound_pass_vo.py` mixes synthetic sine/kick audio and writes report.html from a clone at another path

Fixtures stay tiny and self-made: no footage, music, logos or keys (the repo is public).
