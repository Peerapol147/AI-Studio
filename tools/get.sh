#!/usr/bin/env bash
# ดึง URL แบบ "ล้มเร็ว": ห้ามรอ rate limit
# ใช้: bash tools/get.sh <url> [out-file]   (ไม่ใส่ out-file = พิมพ์ออก stdout)
# 429/403/5xx หรือเกิน 20 วิ = exit 75 พร้อมบอกเหตุ ให้เปลี่ยนแหล่งทันที ห้าม sleep แล้วลองใหม่
url="$1"; out="${2:-/dev/stdout}"
code=$(curl -sS -L --max-time 20 -o "$out" -w '%{http_code}' "$url" 2>/dev/null) || code=timeout
case "$code" in
  2*) exit 0 ;;
  *) echo "BLOCKED $code $url -> เปลี่ยนแหล่ง (Openverse/Pixabay/กราฟิก) ห้ามรอ" >&2; exit 75 ;;
esac
