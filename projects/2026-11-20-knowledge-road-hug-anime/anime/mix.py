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
    (cap("กูขอโทษ") - 0.05, "ding/fs-349504-triangle-open-04.ogg", -10), (S["S18_hug"]["t0"] + 0.2, "ding/fs-571513-soft-notifications-bell-ding-d.ogg", -12), (S["S19_povHug"]["t0"], "impact/kenney-impact-impactsoft-heavy-000.ogg", -9), (S["S19_povHug"]["t0"] - 0.05, "glitch/fs-339521-vhs-rewind-forward-and-eject.ogg", -14),
    (S["S20_warmWide"]["t0"] + 0.6, "kit/pop.ogg", -12), (S["S20_warmWide"]["t0"] + 1.1, "kit/pop.ogg", -12), (S["S20_warmWide"]["t0"] + 1.6, "kit/pop.ogg", -12),
    (S["S21_question"]["t0"], "kit/pop.ogg", -11), (S["S22_loop"]["t0"], "kit/impact.ogg", -12),
]
m0, m1 = S["S14_silence"]["t0"], S["S19_povHug"]["t0"]  # main music out from the tense beat until "เอ้า!"
l0, l1 = S["S16b_loveSorry"]["t0"], S["S19_povHug"]["t0"]  # love scene: slowed dreamy copy of the track, cut dead on "เอ้า!"
inputs = ["-i", vid, "-i", f"{proj}/assets/audio/vo.wav", "-ss", "4", "-i", f"{proj}/assets/audio/music-jamendo-e54690db.mp3",
          "-f", "lavfi", "-t", str(dur), "-i", "anoisesrc=color=brown:amplitude=0.5:seed=3", "-ss", "40", "-i", f"{proj}/assets/audio/music-jamendo-e54690db.mp3"]
LOVE = 4
for t, f, g in cues: inputs += ["-i", f"{SFX}/{f}"]
OFF = 5
fc = [f"[2:a]atrim=0:{dur},asetpts=PTS-STARTPTS,volume=-21dB,volume='if(between(t,{m0},{m1}),0.08,1)':eval=frame,afade=t=out:st={dur-1.2}:d=1.2[mus]",
      "[1:a]asplit=2[vo][sc]", "[mus][sc]sidechaincompress=threshold=0.03:ratio=6:attack=20:release=300[mduck]",
      f"[3:a]lowpass=f=500,highpass=f=60,volume=-30dB,afade=t=in:d=0.3[amb]",
      f"[{LOVE}:a]asetrate=44100*0.82,aresample=48000,lowpass=f=2600,aecho=0.8:0.7:120|260:0.35|0.25,atrim=0:{l1-l0},asetpts=PTS-STARTPTS,volume=-15dB,afade=t=in:d=0.25,adelay={int(l0*1000)}|{int(l0*1000)}[love]"]
mixin = "[vo][mduck][amb][love]"
for k, (t, f, g) in enumerate(cues):
    fc.append(f"[{OFF+k}:a]volume={g}dB,adelay={int(t*1000)}|{int(t*1000)}[s{k}]"); mixin += f"[s{k}]"
fc.append(f"{mixin}amix=inputs={4+len(cues)}:normalize=0:duration=first,atrim=0:{dur},loudnorm=I=-16:TP=-4:LRA=11[a]")
subprocess.run(["ffmpeg", "-v", "error", "-y", *inputs, "-filter_complex", ";".join(fc), "-map", "0:v", "-map", "[a]", "-c:v", "copy", "-c:a", "aac", "-b:a", "192k", "-ar", "48000", "-t", str(dur), out], check=True)
print("mixed", out)
