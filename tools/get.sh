#!/usr/bin/env bash
# ดึง URL แบบ "ล้มเร็ว": ห้ามรอ rate limit. ทุกสคริปต์ที่ออกเน็ต (TTS, ถอดเสียง, footage, เพลง, SFX) เรียกผ่านไฟล์นี้
# ใช้: bash tools/get.sh <url> [out-file|-] [curl options เพิ่ม เช่น -X POST -H ... -d ... -F ...]
#   ไม่ใส่ out-file หรือใส่ "-" = พิมพ์ body ออก stdout
#   เวลารวมสูงสุด GET_MAX_TIME วินาที (ค่าเริ่ม 20; TTS/ถอดเสียงตั้งยาวกว่าเอง)
# exit 0  = 2xx, body อยู่ใน out-file/stdout (เขียนไฟล์แบบ atomic: ได้ไฟล์ใหม่ทั้งไฟล์ หรือไฟล์เดิมไม่ถูกแตะ)
# exit 75 = 403/429/5xx/หมดเวลา/ต่อไม่ได้ -> เปลี่ยนแหล่งทันที ห้าม sleep แล้วลองใหม่
#           (รวม 4xx ที่ body บอก quota_exceeded / detected_unusual_activity เช่น ElevenLabs 401 = โควตาหมด/โดนบล็อก)
# exit 1  = HTTP อื่นที่ไม่ใช่ 2xx (400/401/404...) = คำขอผิด ไม่ใช่โดนบล็อก: ห้ามลองซ้ำ URL เดิม แก้คำขอหรือข้ามไฟล์
# ไม่ว่ากรณีไหนที่ไม่ใช่ 2xx: ไม่เขียนทับ out-file เดิม
set -uo pipefail
url="${1:?ใช้: bash tools/get.sh <url> [out-file|-] [curl options]}"; out="${2:--}"; shift; [ $# -gt 0 ] && shift
if [ "$out" = - ]; then tmp=$(mktemp); else mkdir -p "$(dirname "$out")"; tmp=$(mktemp "$(dirname "$out")/.get.XXXXXX"); fi
trap 'rm -f "$tmp"' EXIT
show=$(printf %s "$url" | sed -E 's/([?&](key|api_key|token)=)[^&]*/\1***/g')   # never print a key
code=$(curl -sS -L --connect-timeout 10 --max-time "${GET_MAX_TIME:-20}" -o "$tmp" -w '%{http_code}' "$@" "$url" 2>"$tmp.err"); rc=$?
err=$(head -c 300 "$tmp.err" 2>/dev/null); rm -f "$tmp.err"
if [ $rc -ne 0 ]; then
  echo "BLOCKED curl-exit-$rc (${err:-network}) $show -> เปลี่ยนแหล่ง ห้ามรอ" >&2; exit 75
fi
case "$code" in 4??) grep -qE 'quota_exceeded|detected_unusual_activity' "$tmp" && code="$code-quota" ;; esac
case "$code" in
  2??)
    if [ "$out" = - ]; then cat "$tmp"; else chmod 644 "$tmp"; mv -f "$tmp" "$out"; fi
    exit 0 ;;
  403|429|5??|*-quota)
    echo "BLOCKED $code $show -> เปลี่ยนแหล่ง (Openverse/Pixabay/กราฟิก) ห้ามรอ: $(head -c 200 "$tmp")" >&2; exit 75 ;;
  *)
    echo "HTTP $code $show (คำขอผิด ไม่ได้โดนบล็อก): $(head -c 300 "$tmp")" >&2; exit 1 ;;
esac
