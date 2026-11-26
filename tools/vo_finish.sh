#!/usr/bin/env bash
# เสียงพากย์ขั้นสุดท้าย (ล็อกจังหวะช่อง knowledge, ผู้ใช้ 2026-11-26 "จังหวะเดิม เสียงเดิมไปตลอด"):
#   atempo (ค่าเริ่ม 1.1) แล้ว normalize ความดัง (ค่าเริ่ม -18 LUFS integrated, true peak <= -2 dBTP) แบบ loudnorm 2 รอบ
# ทำหลัง tools/trim_silence.sh และ "ก่อน" tools/words.sh (words ต้องจับเวลาจากไฟล์นี้)
# ที่มา -18: feedback palmaris ข้อ 4 (vo ดิบ -23.8 LUFS ทำให้เพลงดังเกินเมื่อเทียบกับเสียงพูด)
# Use: tools/vo_finish.sh <in.mp3> <out.mp3> [look.json | atempo=1.1] [lufs=-18]
#   with a look.json: atempo / vo_lufs from it (look.py writes the channel_lock values there), so the numbers live in
#   one place (templates/looks/looks.json channel_lock); a look.json without them falls back to 1.1 / -18
set -euo pipefail
in="$1"; out="$2"; tempo="${3:-1.1}"; lufs="${4:--18}"
if [[ "$tempo" == *.json ]]; then
  read -r tempo lufs < <(python3 -c 'import json,sys; d=json.load(open(sys.argv[1])); print(d.get("atempo",1.1), d.get("vo_lufs",-18))' "$tempo")
fi
stats=$(ffmpeg -hide_banner -nostats -i "$in" -af "atempo=${tempo},loudnorm=I=${lufs}:TP=-2:LRA=11:print_format=json" -f null - 2>&1 | sed -n '/^{/,/^}/p')
filt=$(python3 -c '
import json,sys
s=json.loads(sys.argv[1]); t,l=sys.argv[2],sys.argv[3]
g=lambda k: s[k]
print("atempo=%s,loudnorm=I=%s:TP=-2:LRA=11:measured_I=%s:measured_TP=%s:measured_LRA=%s:measured_thresh=%s:offset=%s:linear=true"
      % (t, l, g("input_i"), g("input_tp"), g("input_lra"), g("input_thresh"), g("target_offset")))
' "$stats" "$tempo" "$lufs")
tmp="${out%.*}.tmp.${out##*.}"
ffmpeg -v error -y -i "$in" -af "$filt" -ar 44100 "$tmp" && mv "$tmp" "$out"
ffmpeg -hide_banner -nostats -i "$out" -af ebur128=peak=true -f null - 2>&1 | python3 -c '
import re,sys
o=sys.stdin.read(); i=re.findall(r"I:\s+([-\d.]+) LUFS",o)[-1]; p=re.findall(r"Peak:\s+([-\d.]+) dBFS",o)[-1]
print(f"'"$out"': {i} LUFS integrated, true peak {p} dBFS (target '"$lufs"' LUFS, atempo '"$tempo"')")'
