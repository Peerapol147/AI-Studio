#!/usr/bin/env bash
# ค้นและดาวน์โหลด footage ฟรีจาก Pixabay (ภาพ/วิดีโอ) พร้อมบันทึกเครดิต (assets/credits/footage.json -> CREDITS.md)
# ใช้: tools/footage.sh <photo|video> "<คำค้น ภาษาอังกฤษ>" <project-dir> [จำนวน=5] [vertical|horizontal]
# ทุกคำขอผ่าน tools/get.sh: API หมดเวลา 30 วิ, ดาวน์โหลดไฟล์ละ 120 วิ; 403/429/5xx = exit 75 (เปลี่ยนแหล่ง ห้ามรอ)
# รันซ้ำได้: ไฟล์ที่มีอยู่แล้วไม่โหลดซ้ำ เครดิตไม่ซ้ำ
set -euo pipefail
here="$(cd "$(dirname "$0")/.." && pwd)"
[ -z "${PIXABAY_API_KEY:-}" ] && [ -f "$here/.env" ] && . "$here/.env"
: "${PIXABAY_API_KEY:?ตั้ง PIXABAY_API_KEY ใน environment variables หรือ .env}"
kind="$1"; q="$2"; proj="$3"; n="${4:-5}"; orient="${5:-}"
mkdir -p "$proj/assets/footage"
base="${PIXABAY_BASE:-https://pixabay.com}"
if [ "$kind" = video ]; then url="$base/api/videos/"; else url="$base/api/"; fi
extra=(); [ -n "$orient" ] && [ "$kind" != video ] && extra=(--data-urlencode "orientation=$orient")
json=$(GET_MAX_TIME=30 bash "$here/tools/get.sh" "$url" - -G --data-urlencode "key=$PIXABAY_API_KEY" --data-urlencode "q=$q" \
  --data-urlencode "per_page=$((n<3?3:n))" --data-urlencode "safesearch=true" "${extra[@]}")
PIXABAY_JSON="$json" python3 - "$kind" "$n" "$proj" "$here" <<'PY'
import json,sys,subprocess,os
kind,n,proj,here=sys.argv[1],int(sys.argv[2]),sys.argv[3],sys.argv[4]
d=json.loads(os.environ["PIXABAY_JSON"]); rc=0
for h in d.get("hits",[])[:n]:
    if kind=="video":
        v=h["videos"]; src=(v.get("medium") or {}).get("url") or v["small"]["url"]; ext="mp4"
    else:
        src=h.get("largeImageURL") or h["webformatURL"]; ext=src.rsplit(".",1)[-1]
    name=f"pixabay-{h['id']}.{ext}"; out=os.path.join(proj,"assets","footage",name)
    if not os.path.exists(out):
        r=subprocess.run(["bash",os.path.join(here,"tools","get.sh"),src,out],env={**os.environ,"GET_MAX_TIME":"120"}).returncode
        if r==75: rc=75; break                     # source blocked: stop, keep what we have
        if r: rc=rc or 1; continue
    subprocess.run([sys.executable,os.path.join(here,"tools","credits.py"),"add",proj,"footage",f"footage/{name}",
                    f"- {name}: {h.get('user','')} via Pixabay {h['pageURL']}"],check=True,stdout=subprocess.DEVNULL)
    print(out)
sys.exit(rc)
PY
