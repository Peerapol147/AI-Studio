"""หั่นเทคต่อเสียงเป็นไฟล์ต่อบรรทัด: assets/audio/lines/<id>.wav + lines-timing.json (เวลาตัวอักษรเทียบต้นไฟล์บรรทัด)
ขอบตัดเลือกช่วงเงียบจริงใกล้ขอบ alignment (silencedetect) กันตัดกลางคำ"""
import json, sys, subprocess, re, os
proj = sys.argv[1]
d = json.load(open(f"{proj}/lines.json")); os.makedirs(f"{proj}/assets/audio/lines", exist_ok=True)
out = {}
groups = {}
for l in d["lines"]:
    groups.setdefault(f"take-{l['v']}" + (f"-{l['take']}" if l.get("take") else ""), []).append(l)
for name, glines in groups.items():
    j = json.load(open(f"{proj}/assets/audio/{name}.json")); a = j["alignment"]
    chars, st, en = a["characters"], a["character_start_times_seconds"], a["character_end_times_seconds"]
    full = "".join(chars); src = f"{proj}/assets/audio/{name}.mp3"
    dur = float(subprocess.check_output(["ffprobe","-v","error","-show_entries","format=duration","-of","csv=p=0",src]))
    sil = subprocess.run(["ffmpeg","-hide_banner","-i",src,"-af","silencedetect=n=-38dB:d=0.12","-f","null","-"],capture_output=True,text=True).stderr
    ss = [float(x) for x in re.findall(r"silence_start: ([\d.]+)", sil)]; se = [float(x) for x in re.findall(r"silence_end: ([\d.]+)", sil)]
    gaps = list(zip(ss, se + [dur]))
    # every segment of the take (old takes also hold lines that were re-recorded later) -> spans; output only this group's lines
    bytext = {l["text"].replace("{", "").replace("}", ""): l for l in glines}
    lines = [bytext.get(seg, {"id": None, "text": seg, "v": None}) for seg in j["text"].split("\n\n")]; pos = 0; spans = []
    for l in lines:
        tx = l["text"].replace("{", "").replace("}", "")
        i = full.index(tx, pos); pos = i + len(tx)
        m = re.match(r"\[[^\]]*\]\s*", tx); k0 = i + (m.end() if m else 0); k1 = pos - 1
        spans.append((k0, k1, l))
    # ขอบระหว่างบรรทัด = ช่วงเงียบที่ยาวที่สุดระหว่างจุดเริ่มบรรทัดนี้ (+0.3) กับจุดเริ่มบรรทัดถัดไปตาม alignment (+0.5)
    # (alignment ของ v3 ยืด "..." ท้ายบรรทัดจนเกินจริง จึงเชื่อช่วงเงียบมากกว่า)
    bounds = []
    for n in range(len(spans) - 1):
        lo = st[spans[n][0]] + 0.3; hi = st[spans[n+1][0]] + 0.5
        c = [(e - s, s, e) for s, e in gaps if s >= lo and e <= hi]
        if not c: sys.exit(f"no gap between {spans[n][2]['id']} and {spans[n+1][2]['id']}")
        bounds.append(max(c)[1:])
    lead = [e for s, e in gaps if s <= 0.01]; first = lead[0] if lead else 0.0
    tail = [s for s, e in gaps if e >= dur - 0.01]; last = tail[0] if tail else dur
    for n, (k0, k1, l) in enumerate(spans):
        if l["id"] is None: continue
        t0 = first if n == 0 else bounds[n-1][1]; t1 = last if n == len(spans) - 1 else bounds[n][0]
        a0 = max(0.0, t0 - 0.04); a1 = min(dur, t1 + 0.08)
        # เวลาตัวอักษร: ยืด/หด alignment ให้พอดีช่วงพูดจริง
        s0, s1 = st[k0], en[k1]; sc = (t1 - t0) / max(0.1, s1 - s0)
        st2 = lambda x: t0 + (x - s0) * sc
        wav = f"{proj}/assets/audio/lines/{l['id']}.wav"
        subprocess.run(["ffmpeg","-v","error","-y","-ss",f"{a0:.3f}","-to",f"{a1:.3f}","-i",src,"-ac","1","-ar","48000",wav],check=True)
        text = l["text"]; m = re.match(r"\[[^\]]*\]\s*", text); body0 = text[m.end() if m else 0:]
        body = body0.replace("{", "").replace("}", ""); bleeps = []; off = 0
        for mm in re.finditer(r"\{([^}]*)\}", body0):
            b0 = mm.start() - off; b1 = b0 + len(mm.group(1)) - 1; off += 2; bleeps.append([b0, b1])
        ct = [[chars[k], round(st2(st[k])-a0,3), round(st2(en[k])-a0,3)] for k in range(k0, k1+1)]
        out[l["id"]] = {"v": l["v"], "text": body, "bleep_chars": bleeps, "dur": round(a1-a0,3), "speech": [round(t0-a0,3), round(t1-a0,3)], "chars": ct}
        print(l["id"], f"{a0:.2f}-{a1:.2f} dur {a1-a0:.2f}")
json.dump(out, open(f"{proj}/assets/audio/lines-timing.json","w"), ensure_ascii=False)
