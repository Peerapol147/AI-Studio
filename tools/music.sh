#!/usr/bin/env bash
# ค้นและดาวน์โหลดเพลงประกอบฟรีจาก Openverse (Jamendo, Wikimedia)
# เสียงเอฟเฟกต์: ใช้ชุดที่แถมกับ HyperFrames (skill media-use, --type sfx) เพราะ Freesound บล็อกการดาวน์โหลดอัตโนมัติ
# เฉพาะไลเซนส์ CC0 และ CC BY (ใช้ในคลิปที่สร้างรายได้ได้ ต้องใส่เครดิต) ไม่เอา NC/ND/SA
# ใช้: tools/music.sh music "<คำค้น ภาษาอังกฤษ>" <project-dir> [จำนวน=3] [ความยาวขั้นต่ำ วินาที=0]
# ทุกคำขอผ่าน tools/get.sh (API 30 วิ, ไฟล์ละ 120 วิ; 403/429/5xx = exit 75) เครดิต -> assets/credits/music.json -> CREDITS.md
set -euo pipefail
here="$(cd "$(dirname "$0")/.." && pwd)"
kind="$1"; q="$2"; proj="$3"; n="${4:-3}"; minsec="${5:-0}"
mkdir -p "$proj/assets/audio"
json=$(GET_MAX_TIME=30 bash "$here/tools/get.sh" "${OPENVERSE_BASE:-https://api.openverse.org}/v1/audio/" - -G --data-urlencode "q=$q" \
  --data "license=cc0,by" --data "page_size=20" --data category=music)
OV_JSON="$json" python3 - "$kind" "$n" "$proj" "$minsec" "$here" <<'PY'
import json,os,sys,subprocess
kind,n,proj,minsec,here=sys.argv[1],int(sys.argv[2]),sys.argv[3],float(sys.argv[4]),sys.argv[5]
d=json.loads(os.environ["OV_JSON"]); got=0; rc=0
for r in d.get("results",[]):
    if got>=n: break
    if (r.get("duration") or 0)/1000 < minsec: continue
    ext=(r.get("filetype") or "mp3").lower(); ext="mp3" if ext.startswith("mp3") else ext
    name=f"{kind}-{r['source']}-{r['id'][:8]}.{ext}"; out=os.path.join(proj,"assets","audio",name)
    if not os.path.exists(out):
        x=subprocess.run(["bash",os.path.join(here,"tools","get.sh"),r["url"],out],env={**os.environ,"GET_MAX_TIME":"120"}).returncode
        if x==75: rc=75; break
        if x: continue
    lic=f"CC {r['license'].upper()} {r.get('license_version') or ''}".strip()
    subprocess.run([sys.executable,os.path.join(here,"tools","credits.py"),"add",proj,"music",f"audio/{name}",
                    f"- {name}: \"{r['title']}\" by {r.get('creator') or 'unknown'} ({lic}) {r.get('foreign_landing_url','')}"],
                   check=True,stdout=subprocess.DEVNULL)
    print(out, round((r.get('duration') or 0)/1000), "s", r['title']); got+=1
sys.exit(rc)
PY
