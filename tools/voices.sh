#!/usr/bin/env bash
# รายชื่อเสียงใน ElevenLabs: voice_id <tab> ชื่อ <tab> ภาษา
curl -sfS -H "xi-api-key: ${ELEVENLABS_API_KEY:-proxy-injected}" https://api.elevenlabs.io/v1/voices |
  python3 -c 'import json,sys;[print(v["voice_id"],v["name"],(v.get("labels") or {}).get("language",""),sep="\t") for v in json.load(sys.stdin)["voices"]]'
