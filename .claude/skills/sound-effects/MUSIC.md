# Music (AI Studio)

**Mixkit is not used** (planning room 2026-11-28: its licence cannot be verified for this channel). The Mixkit track
list that was here was removed.

Music for an episode is **only** the track in the project's `look.json` `"music_file"`:

1. The voice step searches by the look's `music_mood` with `tools/music.sh music "<mood in English>" <project>`
   (Openverse -> Jamendo / Wikimedia, CC0 or CC BY only, never NC/ND) and writes the credit into `assets/CREDITS.md`.
2. Openverse answers 429: download a known track straight from Jamendo with
   `bash tools/get.sh "https://prod-1.storage.jamendo.com/?trackid=<id>&format=mp31" assets/audio/music-jamendo-<id>.mp3`,
   only after the track page (`https://www.jamendo.com/track/<id>`) or an earlier credit shows CC BY / CC BY-SA / CC0;
   add the credit with `tools/credits.py add`.
3. No verified licence = no track: the director asks the user. The editor never picks another track.

Pass the track to the mix with `--music assets/audio/<music_file>` and its source and licence from `assets/CREDITS.md`:

    --music-source '"<title>" by <artist>, Jamendo <link>' --music-license "CC BY 4.0"

The mix scripts (`scripts/sound_pass.py`, `tools/sound_pass_vo.py`) refuse a Mixkit track, licence or sound.
