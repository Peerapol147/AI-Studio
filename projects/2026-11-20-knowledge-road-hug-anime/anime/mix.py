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
TEN, LOV = f"{proj}/assets/audio/tense-a.mp3", f"{proj}/assets/audio/love.mp3"
TOFF, LOFF = 27.0, 0.9  # tense track builds to its peak right where the argument peaks (~clip 24 s)
n5 = S["S20_warmWide"]["t0"]; lp = S["S22_loop"]["t0"]
# (file, track offset, clip start, clip end, gain dB, fade-in, fade-out, ducked?)
SEG = [(TEN, TOFF, 0.0, m0, -19, 0.0, 0.12, 1),            # fiery: hook -> shouting peak, cut dead at the silent beat
       (LOV, LOFF, l0, l1, -15, 0.3, 0.0, 0),              # in-love: "กูขอโทษ" -> slow-mo hug, cut dead on "เอ้า!"
       (LOV, LOFF + (l1 - l0) + 0.6, n5, lp, -22, 0.5, 0.4, 1),  # soft warm tail under the wrap-up
       (TEN, TOFF, lp, dur, -19, 0.0, 0.0, 1)]             # loop shot = same music as frame 0 for a seamless loop
inputs = ["-i", vid, "-i", f"{proj}/assets/audio/vo.wav", "-f", "lavfi", "-t", str(dur), "-i", "anoisesrc=color=brown:amplitude=0.5:seed=3"]
for f, off, c0, c1, g, fi, fo, dk in SEG: inputs += ["-ss", str(off), "-t", str(c1 - c0 + 0.05), "-i", f]
OFF = 3 + len(SEG)
for t, f, g in cues: inputs += ["-i", f"{SFX}/{f}"]
fc = ["[1:a]asplit=2[vo][sc]", "[2:a]lowpass=f=500,highpass=f=60,volume=-30dB,afade=t=in:d=0.3[amb]"]
dk_l, raw_l = [], []
for k, (f, off, c0, c1, g, fi, fo, dk) in enumerate(SEG):
    ch = f"[{3+k}:a]aresample=48000,aformat=channel_layouts=stereo,volume={g}dB" + (f",afade=t=in:d={fi}" if fi else "") + (f",afade=t=out:st={max(0, c1-c0-fo)}:d={fo}" if fo else "") + f",adelay={int(c0*1000)}|{int(c0*1000)}[m{k}]"
    fc.append(ch); (dk_l if dk else raw_l).append(f"[m{k}]")
fc.append(f"{''.join(dk_l)}amix=inputs={len(dk_l)}:normalize=0:duration=longest[md]")
fc.append("[md][sc]sidechaincompress=threshold=0.03:ratio=6:attack=20:release=300[mduck]")
mixin = "[vo][mduck][amb]" + "".join(raw_l)
for k, (t, f, g) in enumerate(cues):
    fc.append(f"[{OFF+k}:a]volume={g}dB,adelay={int(t*1000)}|{int(t*1000)}[s{k}]"); mixin += f"[s{k}]"
fc.append(f"{mixin}amix=inputs={3+len(raw_l)+len(cues)}:normalize=0:duration=first,atrim=0:{dur},loudnorm=I=-16:TP=-5:LRA=11[a]")
subprocess.run(["ffmpeg", "-v", "error", "-y", *inputs, "-filter_complex", ";".join(fc), "-map", "0:v", "-map", "[a]", "-c:v", "copy", "-c:a", "aac", "-b:a", "192k", "-ar", "48000", "-t", str(dur), out], check=True)
print("mixed", out)
