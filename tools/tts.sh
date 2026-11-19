#!/usr/bin/env bash
# พากย์เสียงด้วย ElevenLabs. key ถูกแนบโดย proxy ของ environment (ไม่เก็บใน repo)
# ใช้: tools/tts.sh <voice_id> <text-file> <out.mp3> [model]
# ภาษาไทยต้องใช้ eleven_v3 หรือใหม่กว่า (eleven_multilingual_v2 ไม่รองรับไทย)
set -euo pipefail
voice="$1"; text_file="$2"; out="$3"; model="${4:-eleven_v3}"
body=$(python3 -c 'import json,sys;print(json.dumps({"text":open(sys.argv[1],encoding="utf-8").read(),"model_id":sys.argv[2]}))' "$text_file" "$model")
# ผ่าน get.sh: หมดเวลา 180 วิ, 403/429/5xx = exit 75, ล้มแล้วไม่เขียนทับ out เดิม
GET_MAX_TIME="${GET_MAX_TIME:-180}" bash "$(dirname "$0")/get.sh" \
  "${ELEVENLABS_BASE:-https://api.elevenlabs.io}/v1/text-to-speech/$voice?output_format=mp3_44100_128" "$out" \
  -X POST -H "xi-api-key: ${ELEVENLABS_API_KEY:-proxy-injected}" -H 'Content-Type: application/json' --data-binary "$body"
echo "$out"
