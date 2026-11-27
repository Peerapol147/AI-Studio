# smoke tests (python only, no API keys, no clip render)

    pip install pytest numpy soundfile scipy matplotlib librosa   # + ffmpeg
    python3 -m pytest -q tests

- `test_build_index.py`: `templates/brainrot-v2/build_index.py` builds index.html from a fresh checkout (fixture in `fixtures/brainrot/`)
- `test_build_index_v3.py`: `templates/brainrot-v3/build_index.py` builds two different looks from look.json (fixture `fixtures/v3/`), refuses a missing look / unknown value / shot without beat; every palette keeps flat-colour text >= 4.5:1 contrast; the itch 3-line title builds >= 60 px in every opening x cover (pov/tilt >= 80 px), never left-aligned; `test_title_fit_v3.py` (browser) also checks the size ON SCREEN at frame 0 and that every line + kicker is centred
- `test_look.py`: `tools/look.py` pick avoids the channel's last 3 looks; check fails on same palette/opening/music as the previous episode, an identical look or a similar cover text; reads ep branches from git (music also from credits/music.json, covers from thumbnail.md)
- `test_look.py` (cont.): knowledge voice locked to George / eleven_v3 / atempo 1.1 (looks.json channel_lock): pick never rotates it, check ERRORs on another voice and does not WARN on the same voice; unlocked channels still rotate
- `test_vo_finish.py`: `tools/vo_finish.sh` atempo 1.1 + loudnorm to -18 LUFS
- `test_cover_check.py`: `tools/cover_check.py` cover A/B (<= 2 lines, repeated word, A = B, similar to earlier covers/frame 0, overlap / edge / 200 px size / contrast, CTR log) and `tools/cover_shot.js` on `templates/brainrot-v3/cover.html` (browser part skipped without node + playwright)
- `test_footage_search.py`: `tools/footage_search.py` searches Pixabay/Pexels/Openverse/NASA/Wikimedia (mock server), retries a 429 twice then skips the source (note = "BLOCKED 429 ..."), runs one search at a time (lock: a second one WAITs, exit 3 after FOOTAGE_LOCK_WAIT), drops non-free Wikimedia files, `report` demands >= 10 terms (th + en, video + photo, >= 2 sources) and writes ALERT.md under 50 % coverage
- `test_contact_sheet.py`: `tools/contact_sheet.py` a frame every 0.25 s on sheets, a held frame > 0.5 s found (a slow push-in is not), `verify` needs a note per sheet under "## ตรวจภาพทุกเฟรม" in review.md
- `test_hand_rig.py`: `templates/brainrot-v3/compositions/components/hand-rig` (palmaris hand.js) draws the rest/test/flex demo poses without page errors, returns on-screen anchors, same state = same markup (browser part skipped without node + playwright)
- `test_pacing.py`: `tools/pacing.py` topic by 1.5 s, reveal 50-60 %, twist/share/cta present, explain 2-3 s / hook+twist speed = INFO only (style.md 4), length 20-40 s (long_reason, 59 s ceiling), legend twist >= 70 %; `beat` in shot_times
- `test_shot_times.py`: `tools/shot_times.py` good run, media_start priority, footage.json merge by id, the hard errors (empty shots/cue, NaN/Infinity, duplicate id) and stale-timeline deletion
- `test_fetch.py`: `tools/get.sh` (200/403/429/5xx/4xx/timeout, never overwrites a good file, key masked) and tts/words/voices/footage/music + `tools/credits.py` against a local mock server (`conftest.py`); no real API is called
- `test_sound_pass_vo.py`: `tools/sound_pass_vo.py` mixes synthetic sine/kick audio and writes report.html from a clone at another path

Fixtures stay tiny and self-made: no footage, music, logos or keys (the repo is public).
