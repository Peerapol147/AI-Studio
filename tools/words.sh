#!/usr/bin/env bash
# Word/character timestamps for a voiceover (ElevenLabs Speech-to-Text scribe_v1; proxy adds the key).
# Use: tools/words.sh <audio.mp3> <out.json> <tha|eng>
# Thai comes back per character; tools/shot_times.py and caption builders read either form.
set -euo pipefail
audio="$1"; out="$2"; lang="${3:-tha}"
curl -sfS -X POST "https://api.elevenlabs.io/v1/speech-to-text" \
  -H "xi-api-key: ${ELEVENLABS_API_KEY:-proxy-injected}" \
  -F model_id=scribe_v1 -F language_code="$lang" -F timestamps_granularity=character \
  -F file=@"$audio" -o "$out"
python3 -c 'import json,sys;d=json.load(open(sys.argv[1]));print(sys.argv[1], len(d["words"]), "tokens,", d.get("audio_duration_secs"), "s")' "$out"
