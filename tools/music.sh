#!/usr/bin/env bash
# ค้นและดาวน์โหลดเพลงประกอบฟรีจาก Openverse (Jamendo, Wikimedia)
# เสียงเอฟเฟกต์: ใช้ชุดที่แถมกับ HyperFrames (skill media-use, --type sfx) เพราะ Freesound บล็อกการดาวน์โหลดอัตโนมัติ
# เฉพาะไลเซนส์ CC0 และ CC BY (ใช้ในคลิปที่สร้างรายได้ได้ ต้องใส่เครดิต) ไม่เอา NC/ND/SA
# ใช้: tools/music.sh music "<คำค้น ภาษาอังกฤษ>" <project-dir> [จำนวน=3] [ความยาวขั้นต่ำ วินาที=0]
set -euo pipefail
kind="$1"; q="$2"; proj="$3"; n="${4:-3}"; minsec="${5:-0}"
mkdir -p "$proj/assets/audio"
json=$(curl -sfS -G https://api.openverse.org/v1/audio/ --data-urlencode "q=$q" \
  --data "license=cc0,by" --data "page_size=20" --data category=music)
OV_JSON="$json" python3 - "$kind" "$n" "$proj" "$minsec" <<'PY'
import json,os,sys,subprocess
kind,n,proj,minsec=sys.argv[1],int(sys.argv[2]),sys.argv[3],float(sys.argv[4])
d=json.loads(os.environ["OV_JSON"]); got=0
cred=open(os.path.join(proj,"assets","CREDITS.md"),"a",encoding="utf-8")
for r in d.get("results",[]):
    if got>=n: break
    if (r.get("duration") or 0)/1000 < minsec: continue
    ext=(r.get("filetype") or "mp3").lower(); ext="mp3" if ext.startswith("mp3") else ext
    out=os.path.join(proj,"assets","audio",f"{kind}-{r['source']}-{r['id'][:8]}.{ext}")
    if subprocess.run(["curl","-sfSL",r["url"],"-o",out]).returncode: continue
    lic=f"CC {r['license'].upper()} {r.get('license_version') or ''}".strip()
    cred.write(f"- {os.path.basename(out)}: \"{r['title']}\" by {r.get('creator') or 'unknown'} ({lic}) {r.get('foreign_landing_url','')}\n")
    print(out, round((r.get('duration') or 0)/1000), "s", r['title']); got+=1
PY
