#!/usr/bin/env bash
# ค้นและดาวน์โหลด footage ฟรีจาก Pixabay (ภาพ/วิดีโอ) พร้อมบันทึกเครดิต
# ใช้: tools/footage.sh <photo|video> "<คำค้น ภาษาอังกฤษ>" <project-dir> [จำนวน=5] [vertical|horizontal]
set -euo pipefail
here="$(cd "$(dirname "$0")/.." && pwd)"
[ -z "${PIXABAY_API_KEY:-}" ] && [ -f "$here/.env" ] && . "$here/.env"
: "${PIXABAY_API_KEY:?ตั้ง PIXABAY_API_KEY ใน environment variables หรือ .env}"
kind="$1"; q="$2"; proj="$3"; n="${4:-5}"; orient="${5:-}"
mkdir -p "$proj/assets/footage"
if [ "$kind" = video ]; then url="https://pixabay.com/api/videos/"; else url="https://pixabay.com/api/"; fi
extra=""; [ -n "$orient" ] && [ "$kind" != video ] && extra="&orientation=$orient"
json=$(curl -sfS -G "$url" --data-urlencode "key=$PIXABAY_API_KEY" --data-urlencode "q=$q" \
  --data-urlencode "per_page=$((n<3?3:n))" --data-urlencode "safesearch=true" ${extra:+--data "${extra#&}"})
PIXABAY_JSON="$json" python3 - "$kind" "$n" "$proj" <<'PY'
import json,sys,subprocess,os
kind,n,proj=sys.argv[1],int(sys.argv[2]),sys.argv[3]
d=json.loads(os.environ["PIXABAY_JSON"])
cred=open(os.path.join(proj,"assets","CREDITS.md"),"a",encoding="utf-8")
for h in d["hits"][:n]:
    if kind=="video":
        v=h["videos"]; src=(v.get("medium") or {}).get("url") or v["small"]["url"]; ext="mp4"
    else:
        src=h.get("largeImageURL") or h["webformatURL"]; ext=src.rsplit(".",1)[-1]
    out=os.path.join(proj,"assets","footage",f"pixabay-{h['id']}.{ext}")
    subprocess.run(["curl","-sfSL",src,"-o",out],check=True)
    cred.write(f"- {os.path.basename(out)}: {h.get('user','')} via Pixabay {h['pageURL']}\n")
    print(out)
PY
