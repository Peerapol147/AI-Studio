"""timeline.json (ลำดับบรรทัด + ช่วงเงียบ) -> anime/episode-data.json + assets/audio/vo.wav
episode-data: lines{id:{start,end,v,text,part}}, marks{name:{start,end}}, parts{n:[t0,t1]}, subs[{t0,t1,text,v}], mouth{v:[env per frame]}
ใช้: python3 anime/build_timeline.py <project>"""
import json, sys, subprocess, re, numpy as np
proj = sys.argv[1]; FPS = 24; SR = 48000; GAP = 0.35
seq = json.load(open(f"{proj}/anime/timeline.json")).split()
T = json.load(open(f"{proj}/assets/audio/lines-timing.json")); L = {l["id"]: l for l in json.load(open(f"{proj}/lines.json"))["lines"]}
t = 0.0; lines = {}; marks = {}; parts = {}; cur = None; order = []
for tok in seq:
    if tok.startswith("#"):
        if cur: parts[cur][1] = round(t, 3)
        cur = tok[1:]; parts[cur] = [round(t, 3), None]; continue
    if tok.startswith("~"):
        d, _, name = tok[1:].partition(":"); marks[name] = {"start": round(t, 3), "end": round(t + float(d), 3)}; t += float(d); continue
    m = re.match(r"([A-Z]\d\d)(?:\+([\d.]+))?(?::(\w+))?$", tok); i, g, mk = m.group(1), float(m.group(2)) if m.group(2) else GAP, m.group(3)
    key = i if i not in lines else f"{i}b"
    lines[key] = {"id": i, "start": round(t, 3), "end": round(t + T[i]["dur"], 3), "v": T[i]["v"], "text": T[i]["text"], "part": cur}; order.append(key)
    t += T[i]["dur"]
    if mk: marks[mk] = {"start": round(t, 3), "end": round(t + g, 3)}
    t += g
parts[cur][1] = round(t, 3); total = round(t + 0.2, 3)
vo = np.zeros(int(total * SR) + SR, dtype=np.float32); nfr = int(total * FPS) + 2; envs = {}
for k in order:
    l = lines[k]; raw = subprocess.check_output(["ffmpeg", "-v", "error", "-i", f"{proj}/assets/audio/lines/{l['id']}.wav", "-f", "f32le", "-ac", "1", "-ar", str(SR), "-"])
    a = np.frombuffer(raw, dtype=np.float32); s0 = int(l["start"] * SR); vo[s0:s0 + len(a)] += a
    e = envs.setdefault(l["v"], np.zeros(nfr)); hop = SR // FPS
    for j in range(len(a) // hop):
        fr = int(round(l["start"] * FPS)) + j
        if fr < nfr: e[fr] = max(e[fr], float(np.sqrt(np.mean(a[j * hop:(j + 1) * hop] ** 2))))
for v in envs:
    e = envs[v]; m = np.percentile(e[e > 0], 95) if (e > 0).any() else 1; envs[v] = np.clip(e / m, 0, 1).round(3).tolist()
subprocess.run(["ffmpeg", "-v", "error", "-y", "-f", "f32le", "-ar", str(SR), "-ac", "1", "-i", "-", f"{proj}/assets/audio/vo.wav"], input=vo[:int(total * SR)].tobytes(), check=True)
# subtitles: whole line, long lines split at a space near the middle (time split by characters), min 0.8 s
subs = []
for k in order:
    l = lines[k]; tx = l["text"]; d = l["end"] - l["start"]
    if len(tx) > 34 and " " in tx:
        sp = [m.start() for m in re.finditer(" ", tx)]; c = min(sp, key=lambda x: abs(x - len(tx) / 2)); parts_ = [tx[:c], tx[c + 1:]]
    else: parts_ = [tx]
    tt = l["start"]; n = sum(len(p) for p in parts_)
    for p in parts_:
        dd = d * len(p) / n; subs.append({"t0": round(tt, 3), "t1": round(tt + dd, 3), "text": p, "v": l["v"], "line": k}); tt += dd
for a, b in zip(subs, subs[1:]): a["t1"] = round(min(max(a["t1"] + 0.25, a["t0"] + 0.8), b["t0"]), 3)
json.dump({"fps": FPS, "duration": total, "lines": lines, "marks": marks, "parts": parts, "subs": subs, "mouth": envs}, open(f"{proj}/anime/episode-data.json", "w"), ensure_ascii=False)
for p, (a, b) in parts.items(): print(f"part {p}: {a:7.2f} - {b:7.2f} ({b - a:5.1f}s)")
print("total", total)
