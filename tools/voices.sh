#!/usr/bin/env bash
# รายชื่อเสียงใน ElevenLabs: voice_id <tab> ชื่อ <tab> ภาษา
set -eo pipefail
GET_MAX_TIME="${GET_MAX_TIME:-30}" bash "$(dirname "$0")/get.sh" "${ELEVENLABS_BASE:-https://api.elevenlabs.io}/v1/voices" - \
  -H "xi-api-key: ${ELEVENLABS_API_KEY:-proxy-injected}" |
  python3 -c 'import json,sys;[print(v["voice_id"],v["name"],(v.get("labels") or {}).get("language",""),sep="\t") for v in json.load(sys.stdin)["voices"]]'
