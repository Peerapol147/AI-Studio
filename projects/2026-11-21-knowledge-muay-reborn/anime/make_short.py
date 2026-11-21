"""Short 9:16 cut list (timeline seconds) -> episode-data.json["short"] + assets/audio/final-mix-short.m4a (segments of the long mix, 40 ms fades)
ใช้: python3 anime/make_short.py <project>"""
import json, sys, subprocess
proj = sys.argv[1]; p = f"{proj}/anime/episode-data.json"; D = json.load(open(p))
L = lambda i: D["lines"][i]; M = lambda n: D["marks"][n]
seg = [(0.0, L("B01")["end"] + 0.25),                      # hook: guard + gang + "ทุกคนคิดว่ามันขี้แพ้..." + "มึงจะทำอะไร ห๊ะ!?"
       (M("stomp")["start"], D["parts"]["8"][0]),           # stomp the sketchbook -> flashback -> "พอแล้ว." -> wai -> stance
       (D["parts"]["8"][0], M("crash")["end"]),             # the fight (3 mae mai)
       (M("pile")["start"], L("X01")["end"] + 0.3),        # pile + "ทำไมไอ้ขี้แพ้...เป็นมวยวะ!?"
       (L("N26")["start"] - 0.1, D["duration"])]            # comment question
seg = [[round(a, 3), round(b, 3)] for a, b in seg]
D["short"] = {"segments": seg, "length": round(sum(b - a for a, b in seg), 2)}; json.dump(D, open(p, "w"), ensure_ascii=False)
fc, ins = [], []
for k, (a, b) in enumerate(seg):
    ins += ["-ss", str(a), "-t", str(b - a), "-i", f"{proj}/assets/audio/final-mix.wav"]; fc.append(f"[{k}:a]afade=t=in:d=0.04,afade=t=out:st={b - a - 0.04:.3f}:d=0.04[s{k}]")
fc.append("".join(f"[s{k}]" for k in range(len(seg))) + f"concat=n={len(seg)}:v=0:a=1,loudnorm=I=-14:TP=-1.5[a]")
subprocess.run(["ffmpeg", "-v", "error", "-y", *ins, "-filter_complex", ";".join(fc), "-map", "[a]", "-c:a", "aac", "-b:a", "256k", f"{proj}/assets/audio/final-mix-short.m4a"], check=True)
print("short", D["short"])
