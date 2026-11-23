"""ชั้นเสียงเพิ่มของฉากสู้ (เวอร์ชัน fable): สายฟ้า (zap) ตอนออกอาวุธเร็ว, ตึ้มต่ำตอนโดน, เสียงดูดเข้าก่อนจระเข้ฟาดหาง, เสียงแตกประกายช่วงภาพช้า
วางทับ final-mix-v1.m4a (มิกซ์เดิม: พากย์+เพลง+sfx) เพราะ stem เดิม (vo.wav, เพลง) ไม่อยู่ใน repo — ไม่อัดเสียงใหม่ ไม่เปลี่ยนเวลา
เอฟเฟกต์ทุกตัวจบก่อนบรรทัดพูดถัดไป (N21, N22, N23) จึงไม่ทับเสียงพากย์
-> assets/audio/final-mix.wav + final-mix.m4a (วัด LUFS/peak ท้ายสคริปต์)  ใช้: python3 anime/add_fx.py <project>  แล้ว  python3 anime/make_short.py <project>"""
import json, sys, subprocess
proj = sys.argv[1]; D = json.load(open(f"{proj}/anime/episode-data.json")); dur = D["duration"]
SFX = f"{proj}/../../.claude/skills/sound-effects/sfx"; A = f"{proj}/assets/audio"
L = lambda i: D["lines"][i]["start"]; M = lambda n: D["marks"][n]["start"]
ZAP, BOOM, CRK0, CRK1, IMP = "transition/fs-856168-cyberpunk-glitch-hologram-tran.ogg", "impact/kenney-sci-lowfrequency-explosion-000.ogg", "glitch/kenney-sci-computernoise-000.ogg", "glitch/kenney-sci-computernoise-001.ogg", "impact/fs-177242-cinematic-impact.ogg"
T1, N1, HIT = M("teep"), M("naka"), M("spinhit")
# (time, file, gain dB, playback rate, max length s, reverse?, must end before)
cues = [
    (T1 + 0.28, ZAP, -8, 1.3, 0.45, 0, L("N21")), (T1 + 0.62, BOOM, -7, 1.0, 0.42, 0, L("N21")), (T1 + 0.62, CRK0, -13, 1.2, 0.3, 0, L("N21")),
    (N1 + 0.02, ZAP, -9, 1.45, 0.4, 0, L("N22")), (N1 + 0.32, CRK1, -12, 1.1, 0.35, 0, L("N22")), (N1 + 0.5, ZAP, -11, 0.9, 0.6, 0, L("N22")),
    (HIT - 0.7, IMP, -7, 1.0, 0.7, 1, HIT + 0.01),                                         # reversed impact = suck-in toward the heel
    (HIT, ZAP, -5, 0.8, 0.9, 0, L("N23")), (HIT, BOOM, -6, 0.85, 0.9, 0, L("N23")), (HIT + 0.3, CRK0, -12, 1.0, 0.6, 0, L("N23")), (HIT + 0.58, ZAP, -12, 1.6, 0.35, 0, L("N23")),
    (M("stance") - 0.05, ZAP, -14, 1.2, 0.5, 0, 1e9),                                      # a spark when the stance locks in
]
inputs, fc, mixin = ["-i", f"{A}/final-mix-v1.m4a"], ["[0:a]aresample=48000,aformat=channel_layouts=stereo[base]"], "[base]"
for k, (t, f, g, rate, ln, rev, lim) in enumerate(cues):
    ln = max(0.12, min(ln, lim - t - 0.03)); inputs += ["-i", f"{SFX}/{f}"]
    ch = f"[{k+1}:a]aresample=48000,asetrate={int(48000*rate)},aresample=48000,aformat=channel_layouts=stereo,atrim=0:{ln:.3f}," + ("areverse," if rev else "") + f"afade=t=in:d=0.004,afade=t=out:st={ln-0.08:.3f}:d=0.08,volume={g}dB,adelay={int(t*1000)}|{int(t*1000)}[s{k}]"
    fc.append(ch); mixin += f"[s{k}]"
fc.append(f"{mixin}amix=inputs={len(cues)+1}:normalize=0:duration=first,alimiter=limit=0.58:level=false[a]")
out = f"{A}/final-mix.wav"
subprocess.run(["ffmpeg", "-v", "error", "-y", *inputs, "-filter_complex", ";".join(fc), "-map", "[a]", "-ar", "48000", "-c:a", "pcm_s16le", "-t", str(dur), out], check=True)
subprocess.run(["ffmpeg", "-v", "error", "-y", "-i", out, "-c:a", "aac", "-b:a", "256k", f"{A}/final-mix.m4a"], check=True)
for f in ("final-mix-v1.m4a", "final-mix.m4a"):
    r = subprocess.run(["ffmpeg", "-hide_banner", "-i", f"{A}/{f}", "-af", "ebur128=peak=true", "-f", "null", "-"], capture_output=True, text=True).stderr
    print(f, [l.strip() for l in r.splitlines()[-12:] if "I:" in l or "Peak:" in l])
