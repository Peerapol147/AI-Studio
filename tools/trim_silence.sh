#!/usr/bin/env bash
# ตัดช่วงเงียบหัวท้ายและช่วงเงียบยาวผิดปกติกลางเสียงพากย์ (ffmpeg silenceremove ไม่ต้องลงอะไรเพิ่ม)
# ทำ "ก่อน" tools/words.sh เสมอ ไม่งั้นเวลาคำจะเพี้ยน
# Use: tools/trim_silence.sh <in.mp3> <out.mp3> [max_gap_sec=0.6] [threshold_dB=-40]
set -euo pipefail
in="$1"; out="$2"; gap="${3:-0.6}"; th="${4:--40}"
ffmpeg -v error -y -i "$in" -af "silenceremove=start_periods=1:start_threshold=${th}dB:start_silence=0.1:stop_periods=-1:stop_threshold=${th}dB:stop_duration=${gap}:stop_silence=0.25" "$out"
python3 - "$in" "$out" <<'PY'
import subprocess,sys
d=lambda f: float(subprocess.check_output(["ffprobe","-v","error","-show_entries","format=duration","-of","csv=p=0",f]))
a,b=d(sys.argv[1]),d(sys.argv[2]); print(f"{a:.2f}s -> {b:.2f}s (ตัด {a-b:.2f}s)")
PY
