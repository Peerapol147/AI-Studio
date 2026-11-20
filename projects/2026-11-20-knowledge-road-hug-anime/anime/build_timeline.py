"""วางเสียงต่อบรรทัดลงไทม์ไลน์ + ซับรายก้อน + ซองเสียงขยับปาก -> anime/episode-data.json, assets/audio/vo.wav
ใช้: python3 anime/build_timeline.py <project>   (แก้ช่องว่างระหว่างบรรทัดที่ GAPS)"""
import json, sys, subprocess, numpy as np
proj = sys.argv[1]; FPS = 24
T = json.load(open(f"{proj}/assets/audio/lines-timing.json")); C = json.load(open(f"{proj}/anime/chunks.json"))
ORDER = ["N1","N2","R1","D1","R2","N3","D2","R3","D3","R4","N4","N5","N6"]
GAPS = {"N1":0.45,"N2":0.15,"R1":0.0,"D1":0.05,"R2":0.25,"N3":0.1,"D2":0.03,"R3":1.5,"D3":0.35,"R4":1.9,"N4":0.5,"N5":0.45,"N6":0.9}
t = 0.05; lines = {}; SR = 48000; bleeps = []
for i in ORDER:
    lines[i] = {"start": round(t,3), "end": round(t + T[i]["dur"],3), "v": T[i]["v"], "text": T[i]["text"]}; t += T[i]["dur"] + GAPS[i]
total = round(t, 3)
vo = np.zeros(int(total*SR)+SR, dtype=np.float32); env = {"N": None, "D": None, "R": None}
nfr = int(total*FPS)+2; envs = {v: np.zeros(nfr) for v in "NDR"}
for i in ORDER:
    raw = subprocess.check_output(["ffmpeg","-v","error","-i",f"{proj}/assets/audio/lines/{i}.wav","-f","f32le","-ac","1","-ar",str(SR),"-"])
    a = np.frombuffer(raw, dtype=np.float32).copy(); s0 = int(lines[i]["start"]*SR)
    for b0, b1 in T[i].get("bleep_chars", []):  # คำด่า: เงียบเสียงพูด + เสียงตี๊ด 1 kHz (ผู้ใช้เลือก)
        x0 = max(0.0, T[i]["chars"][b0][1] - 0.06); x1 = T[i]["chars"][b1][2] + 0.06
        bleeps.append([round(lines[i]["start"] + x0, 3), round(lines[i]["start"] + x1, 3), i])
        a0, a1 = int(x0*SR), min(len(a), int(x1*SR)); n = a1 - a0; tt = np.arange(n)/SR
        fade = np.minimum(1, np.minimum(tt, tt[::-1]) / 0.008)
        a[a0:a1] = 0.32 * np.sin(2*np.pi*1000*tt) * fade
    vo[s0:s0+len(a)] += a
    hop = SR//FPS
    for k in range(len(a)//hop):
        fr = int(round(lines[i]["start"]*FPS)) + k
        if fr < nfr: envs[T[i]["v"]][fr] = max(envs[T[i]["v"]][fr], float(np.sqrt(np.mean(a[k*hop:(k+1)*hop]**2))))
for v in envs:
    e = envs[v]; m = np.percentile(e[e>0], 95) if (e>0).any() else 1; envs[v] = np.clip(e/m, 0, 1).round(3).tolist()
subprocess.run(["ffmpeg","-v","error","-y","-f","f32le","-ar",str(SR),"-ac","1","-i","-",f"{proj}/assets/audio/vo.wav"], input=vo[:int(total*SR)].tobytes(), check=True)
# ซับรายก้อน: เวลาจากตัวอักษรตัวแรก/ตัวท้ายของก้อนในบรรทัด
caps = []
for i in ORDER:
    chars = T[i]["chars"]; body = "".join(c[0] for c in chars); pos = 0
    for ch in C[i]:
        k = body.index(ch, pos); k2 = k + len(ch) - 1; pos = k2 + 1
        caps.append({"line": i, "v": T[i]["v"], "text": C.get("_censor", {}).get(ch, ch), "spoken": ch, "t0": round(lines[i]["start"] + chars[k][1], 3), "t1": round(lines[i]["start"] + chars[k2][2], 3)})
# ก้อนติดกัน: ค้างจนก้อนถัดไปเริ่ม (ในบรรทัดเดียวกัน) และอย่างน้อย 0.4 วิ
for a, b in zip(caps, caps[1:]):
    if a["line"] == b["line"]: a["t1"] = b["t0"]
for c in caps: c["t1"] = round(max(c["t1"] + 0.12, c["t0"] + 0.4), 3)
for a, b in zip(caps, caps[1:]): a["t1"] = min(a["t1"], b["t0"])  # never overlap the next speaker
json.dump({"fps": FPS, "duration": total, "lines": lines, "captions": caps, "bleeps": bleeps, "mouth": envs}, open(f"{proj}/anime/episode-data.json","w"), ensure_ascii=False)
for i in ORDER: print(i, lines[i]["start"], lines[i]["end"])
print("total", total, "captions", len(caps))
