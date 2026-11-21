"""เสียงทั้งเรื่อง (ไม่ต้องมีวิดีโอ): vo.wav + เพลง CC BY ต่อท่อน (duck ใต้เสียงพูด) + sfx CC0 ตามจังหวะใน episode-data.json
-> assets/audio/final-mix.wav (-16 LUFS, true peak -2 dBTP) ใช้คู่กับวิดีโอที่เรนเดอร์บนเครื่องผู้ใช้ (mux ใน RENDER-ON-GPU.md)
ใช้: python3 anime/mix.py <project>"""
import json, sys, subprocess
proj = sys.argv[1]
D = json.load(open(f"{proj}/anime/episode-data.json")); dur = D["duration"]
SFX = f"{proj}/../../.claude/skills/sound-effects/sfx"; A = f"{proj}/assets/audio"
L = lambda i: D["lines"][i]; Mk = lambda n: D["marks"][n]; PT = D["parts"]
SAD, SUS5, SUS8, BAT = f"{A}/music-jamendo-5193aa1b.mp3", f"{A}/music-jamendo-6f65e2ab.mp3", f"{A}/music-jamendo-f37c6e0b.mp3", f"{A}/music-jamendo-0be997f0.mp3"
# (file, track offset, clip start, clip end, gain dB, fade in, fade out, duck under voice?)
SEG = [
    (SUS5, 22.0, 0.0, Mk("title")["start"], -19, 0.0, 0.15, 1),                       # cold open: rising tension, cut on the title hit
    (SAD, 4.0, PT["2"][0], PT["2"][1] + 1.5, -21, 1.2, 2.0, 1),                        # the forgotten champion
    (SUS8, 0.0, Mk("jolt")["start"], PT["3"][1], -25, 0.4, 0.8, 1),                      # wake up in someone else's body
    (SAD, 60.0, Mk("openbook")["start"], Mk("doorbang")["start"], -21, 1.0, 0.1, 1),     # the sketchbook
    (SUS8, 5.0, PT["5"][0], L("N17")["start"], -21, 0.0, 1.0, 1),                        # bully #1 + #2
    (SAD, 100.0, L("N17")["start"], PT["6"][1], -22, 0.8, 0.6, 1),                        # night training
    (SUS5, 0.0, Mk("grab")["start"], Mk("bangs")["start"], -20, 0.3, 0.05, 1),          # the line is crossed (cut dead before "พอแล้ว")
    (SUS5, 40.0, Mk("wai")["start"], PT["8"][0], -18, 0.2, 0.1, 1),                      # wai -> stance
    (BAT, 8.0, PT["8"][0], Mk("crash")["end"], -17, 0.0, 0.6, 1),                         # the fight
    (SAD, 120.0, L("S17")["start"], L("N24")["start"], -22, 0.8, 0.5, 1),                # aftermath
    (SUS8, 30.0, L("N24")["start"], dur, -21, 0.5, 1.5, 1),                              # the watcher + outro
]
s = lambda n: n  # sfx path helper
cues = [  # (time, file, gain dB)
    (0.02, "kit/impact.ogg", -8), (Mk("freeze")["start"], "impact/fs-222517-dramatic-hit.ogg", -8), (Mk("rewind")["start"], "glitch/fs-339521-vhs-rewind-forward-and-eject.ogg", -10),
    (Mk("title")["start"], "impact/fs-177242-cinematic-impact.ogg", -6),
    (Mk("bell")["start"], "ding/kenney-interface-bong-001.ogg", -8), (Mk("bell")["start"] + 0.25, "ding/kenney-interface-bong-001.ogg", -10),
    (Mk("jolt")["start"], "pop/fs-824189-pop-in-sfx.ogg", -8), (Mk("run")["start"], "whoosh/fs-683101-quick-woosh.ogg", -10), (Mk("mirror")["start"] + 0.7, "riser/fs-396161-scary-hits-risers-001.ogg", -14),
    (Mk("openbook")["start"], "transition/fs-850347-swipe-various.ogg", -10), (Mk("lastpage")["start"] - 0.4, "transition/fs-850347-swipe-various.ogg", -10),
    (Mk("doorbang")["start"], "impact/kenney-impact-impactpunch-heavy-001.ogg", -5),
    (L("B02")["start"] - 0.05, "impact/kenney-impact-impactpunch-heavy-000.ogg", -6), (Mk("flick")["start"] + 0.35, "click/kenney-interface-click-001.ogg", -2),
    (Mk("dump")["start"] + 0.3, "pop/kenney-interface-drop-001.ogg", -8), (Mk("dump")["start"] + 0.45, "pop/kenney-interface-drop-002.ogg", -8), (Mk("dump")["start"] + 0.6, "pop/kenney-interface-drop-003.ogg", -8),
    (Mk("calendar")["start"], "tick/fs384187.ogg", -8),
    (Mk("grab")["start"] + 0.2, "whoosh/fs-169867-swoosh.ogg", -10), (L("B06")["start"] + 0.42, "impact/kenney-impact-impactsoft-heavy-000.ogg", -6), (L("B06")["start"] + 0.9, "impact/kenney-impact-impactsoft-heavy-001.ogg", -8),
    (Mk("stomp")["start"] + 0.45, "impact/kenney-impact-impactpunch-heavy-001.ogg", -5),
    (Mk("flashback")["start"], "riser/fs-464250-echo-chromatic-riser-wav.ogg", -14), (Mk("bangs")["start"] + 0.45, "impact/fs-347561-micheal-bay-hit.ogg", -8),
    (Mk("wai")["start"] + 0.2, "ding/fs-349504-triangle-open-04.ogg", -10), (Mk("stance")["start"], "kit/impact.ogg", -8),
    # fight
    (L("J02")["start"], "whoosh/fs-683101-quick-woosh.ogg", -12), (Mk("teep")["start"] + 0.35, "whoosh/fs-127197-fast-simple-chop-5-aif.ogg", -8),
    (Mk("teep")["start"] + 0.62, "impact/kenney-impact-impactpunch-heavy-000.ogg", -3), (Mk("teep")["start"] + 1.4, "impact/kenney-impact-impactsoft-heavy-001.ogg", -6),
    (Mk("naka")["start"], "whoosh/fs-169867-swoosh.ogg", -8), (Mk("naka")["start"] + 0.32, "impact/kenney-impact-impactsoft-heavy-000.ogg", -6),
    (Mk("naka")["start"] + 0.5, "whoosh/fs-264777-swoosh.ogg", -9), (Mk("naka")["start"] + 1.3, "impact/kenney-impact-impactpunch-heavy-001.ogg", -4),
    (L("B08")["start"], "riser/fs-685256-riser-sound-effect-short-wav.ogg", -12), (Mk("spin")["start"], "whoosh/fs-264777-swoosh.ogg", -6),
    (Mk("spinhit")["start"], "impact/fs-347561-micheal-bay-hit.ogg", -3), (Mk("spinhit")["end"] + 0.6, "impact/kenney-sci-lowfrequency-explosion-000.ogg", -10),
    (Mk("crash")["start"] + 0.2, "impact/kenney-impact-impactsoft-heavy-001.ogg", -6),
    (Mk("pile")["start"] + 0.1, "impact/kenney-impact-impactsoft-heavy-000.ogg", -8),
    (Mk("window")["start"], "riser/fs-396160-scary-hits-risers-002.ogg", -12), (L("N25")["start"], "impact/fs-222517-dramatic-hit.ogg", -9),
    (L("N26")["start"], "pop/fs-824189-pop-in-sfx.ogg", -10),
]
for nm in ("teep", "naka", "spinhit"):  # move-name card hit
    pass
inputs = ["-i", f"{A}/vo.wav"]
for f, off, c0, c1, g, fi, fo, dk in SEG: inputs += ["-ss", str(off), "-t", str(c1 - c0 + 0.05), "-i", f]
OFF = 1 + len(SEG)
for t, f, g in cues: inputs += ["-i", f"{SFX}/{f}"]
fc = ["[0:a]aresample=48000,aformat=channel_layouts=stereo,asplit=2[vo][sc]"]
dk_l, raw_l = [], []
for k, (f, off, c0, c1, g, fi, fo, dk) in enumerate(SEG):
    ch = f"[{1+k}:a]aresample=48000,aformat=channel_layouts=stereo,volume={g}dB" + (f",afade=t=in:d={fi}" if fi else "") + (f",afade=t=out:st={max(0, c1-c0-fo):.3f}:d={fo}" if fo else "") + f",adelay={int(c0*1000)}|{int(c0*1000)}[m{k}]"
    fc.append(ch); (dk_l if dk else raw_l).append(f"[m{k}]")
fc.append(f"{''.join(dk_l)}amix=inputs={len(dk_l)}:normalize=0:duration=longest[md]")
fc.append("[md][sc]sidechaincompress=threshold=0.03:ratio=5:attack=20:release=350[mduck]")
mixin = "[vo][mduck]" + "".join(raw_l)
for k, (t, f, g) in enumerate(cues):
    fc.append(f"[{OFF+k}:a]aresample=48000,aformat=channel_layouts=stereo,volume={g}dB,adelay={int(t*1000)}|{int(t*1000)}[s{k}]"); mixin += f"[s{k}]"
fc.append(f"{mixin}amix=inputs={2+len(raw_l)+len(cues)}:normalize=0:duration=first,apad,atrim=0:{dur},loudnorm=I=-16:TP=-2:LRA=11[a]")
out = f"{A}/final-mix.wav"
subprocess.run(["ffmpeg", "-v", "error", "-y", *inputs, "-filter_complex", ";".join(fc), "-map", "[a]", "-ar", "48000", "-c:a", "pcm_s16le", out], check=True)
r = subprocess.run(["ffmpeg", "-hide_banner", "-i", out, "-af", "ebur128=peak=true", "-f", "null", "-"], capture_output=True, text=True).stderr
print("mixed", out, [l.strip() for l in r.splitlines()[-12:] if "I:" in l or "Peak:" in l])
