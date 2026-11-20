"""มิกซ์เสียง: vo.wav (มีเสียงตี๊ดแล้ว) + เพลง CC BY (duck ใต้เสียงพูด, เงียบช่วงนิ่งก่อนขอโทษ) + เสียงรถ/ลม (สังเคราะห์) + sfx CC0
ใช้: python3 anime/mix.py <project> <silent.mp4> <out.mp4>"""
import json, sys, subprocess
proj, vid, out = sys.argv[1:4]
D = json.load(open(f"{proj}/anime/episode-data.json")); S = {s["id"]: s for s in json.load(open(f"{proj}/anime/shots.json"))}
dur = D["duration"]; SFX = f"{proj}/../../.claude/skills/sound-effects/sfx"
cap = lambda t: next(c["t0"] for c in D["captions"] if c.get("spoken", c["text"]) == t)
cues = [  # (time, file, gain dB)
    (0.0, "kit/impact.ogg", -9), (S["S02_wide"]["t0"], "whoosh/fs-683101-quick-woosh.ogg", -14),
    (S["S08_rightLane"]["t0"] + 0.5, "whoosh/fs-264777-swoosh.ogg", -5), (S["S14_silence"]["t0"] + 0.25, "whoosh/fs-264777-swoosh.ogg", -5),
    (D["lines"]["R3"]["start"], "riser/fs-685256-riser-sound-effect-short-wav.ogg", -17),
    (cap("กูขอโทษ") - 0.05, "ding/fs-349504-triangle-open-04.ogg", -12), (S["S18_hug"]["t0"] + 0.3, "ding/fs-571513-soft-notifications-bell-ding-d.ogg", -10),
    (S["S20_warmWide"]["t0"] + 0.6, "kit/pop.ogg", -12), (S["S20_warmWide"]["t0"] + 1.1, "kit/pop.ogg", -12), (S["S20_warmWide"]["t0"] + 1.6, "kit/pop.ogg", -12),
    (S["S21_question"]["t0"], "kit/pop.ogg", -11), (S["S22_loop"]["t0"], "kit/impact.ogg", -12),
]
m0, m1 = S["S14_silence"]["t0"], S["S15_driverSoft"]["t0"] + 1.0  # music drops out for the tense beat
inputs = ["-i", vid, "-i", f"{proj}/assets/audio/vo.wav", "-ss", "4", "-i", f"{proj}/assets/audio/music-jamendo-e54690db.mp3",
          "-f", "lavfi", "-t", str(dur), "-i", "anoisesrc=color=brown:amplitude=0.5:seed=3"]
for t, f, g in cues: inputs += ["-i", f"{SFX}/{f}"]
fc = [f"[2:a]atrim=0:{dur},asetpts=PTS-STARTPTS,volume=-21dB,volume='if(between(t,{m0},{m1}),0.08,1)':eval=frame,afade=t=out:st={dur-1.2}:d=1.2[mus]",
      "[1:a]asplit=2[vo][sc]", "[mus][sc]sidechaincompress=threshold=0.03:ratio=6:attack=20:release=300[mduck]",
      f"[3:a]lowpass=f=500,highpass=f=60,volume=-30dB,afade=t=in:d=0.3[amb]"]
mixin = "[vo][mduck][amb]"
for k, (t, f, g) in enumerate(cues):
    fc.append(f"[{4+k}:a]volume={g}dB,adelay={int(t*1000)}|{int(t*1000)}[s{k}]"); mixin += f"[s{k}]"
fc.append(f"{mixin}amix=inputs={3+len(cues)}:normalize=0:duration=first,atrim=0:{dur},loudnorm=I=-16:TP=-4:LRA=11[a]")
subprocess.run(["ffmpeg", "-v", "error", "-y", *inputs, "-filter_complex", ";".join(fc), "-map", "0:v", "-map", "[a]", "-c:v", "copy", "-c:a", "aac", "-b:a", "192k", "-ar", "48000", "-t", str(dur), out], check=True)
print("mixed", out)
