"""หั่นเทคต่อเสียงเป็นไฟล์ต่อบรรทัด โดยใช้เวลาตัวอักษรจาก ElevenLabs scribe (เชื่อถือกว่า alignment ของ TTS v3
ที่เคยตัดบรรทัด "กล้า... แกคุยกับกระจกเหรอ" เหลือแค่ "กล้า")
ใช้: python3 anime/split_scribe.py <project>  -> assets/audio/lines/<id>.wav + lines-timing.json (+ scribe-<take>.json แคชไว้)
ตรวจ: บรรทัดที่ข้อความถอดได้ตรงกับบท <70% จะพิมพ์ WARN"""
import json, sys, subprocess, re, os, difflib
proj = sys.argv[1]
d = json.load(open(f"{proj}/lines.json")); os.makedirs(f"{proj}/assets/audio/lines", exist_ok=True)
strip = lambda s: re.sub(r"\[[^\]]*\]\s*", "", s).replace("{", "").replace("}", "")
norm = lambda s: re.sub(r"[\s\.\,\!\?\…\"'“”]", "", s)
groups = {}
for l in d["lines"]: groups.setdefault(f"take-{l['v']}" + (f"-{l['take']}" if l.get("take") else ""), []).append(l)
out = {}
for name, ls in groups.items():
    src = f"{proj}/assets/audio/{name}.mp3"; cache = f"{proj}/assets/audio/scribe-{name}.json"
    if not os.path.exists(cache):
        r = subprocess.run(["curl", "-s", "-m", "120", "https://api.elevenlabs.io/v1/speech-to-text", "-H", "xi-api-key: proxy-injected",
                            "-F", "model_id=scribe_v1", "-F", "language_code=tha", "-F", f"file=@{src}"], capture_output=True, text=True)
        j = json.loads(r.stdout); assert "words" in j, r.stdout[:300]; json.dump(j, open(cache, "w"), ensure_ascii=False)
    j = json.load(open(cache))
    sc = []  # scribe chars with times (spaces dropped)
    for w in j["words"]:
        if w["type"] != "word": continue
        t = norm(w["text"]); n = max(1, len(t))
        for k, ch in enumerate(t): sc.append((ch, w["start"] + (w["end"] - w["start"]) * k / n, w["start"] + (w["end"] - w["start"]) * (k + 1) / n))
    dur = float(subprocess.check_output(["ffprobe", "-v", "error", "-show_entries", "format=duration", "-of", "csv=p=0", src]))
    # script chars, with the line index each belongs to
    script = [];
    for li, l in enumerate(ls):
        for ch in norm(strip(l["text"])): script.append((ch, li))
    sm = difflib.SequenceMatcher(None, [c for c, _ in script], [c[0] for c in sc], autojunk=False)
    m = {}  # script idx -> scribe idx
    for a, b, size in sm.get_matching_blocks():
        for k in range(size): m[a + k] = b + k
    sil = subprocess.run(["ffmpeg", "-hide_banner", "-i", src, "-af", "silencedetect=n=-40dB:d=0.08", "-f", "null", "-"], capture_output=True, text=True).stderr
    ss = [float(x) for x in re.findall(r"silence_start: ([\d.]+)", sil)]; se = [float(x) for x in re.findall(r"silence_end: ([\d.]+)", sil)]
    gaps = list(zip(ss, se + [dur]))
    spans = []
    for li, l in enumerate(ls):
        idx = [k for k, (c, i) in enumerate(script) if i == li]; hit = [m[k] for k in idx if k in m]
        ratio = len(hit) / max(1, len(idx))
        if ratio < 0.7: print(f"WARN {l['id']} match {ratio:.0%}")
        spans.append((sc[min(hit)][1] if hit else None, sc[max(hit)][2] if hit else None, l, ratio))
    for n, (s0, s1, l, ratio) in enumerate(spans):
        # boundaries: the silence that straddles the gap between this line's end and the next line's start
        prev_end = spans[n - 1][1] if n else 0.0; next_start = spans[n + 1][0] if n + 1 < len(spans) else dur
        def pick(lo, hi, side):
            c = [(e - s, s, e) for s, e in gaps if e >= lo - 0.05 and s <= hi + 0.05]
            if not c: return (lo + hi) / 2
            g = max(c); return max(lo - 0.05, g[1]) if side == "end" else min(hi + 0.05, g[2])
        t0 = 0.0 if n == 0 else pick(prev_end, s0, "start"); t1 = dur if n + 1 == len(spans) else pick(s1, next_start, "end")
        a0 = max(0.0, t0 - 0.05); a1 = min(dur, t1 + 0.08)
        wav = f"{proj}/assets/audio/lines/{l['id']}.wav"
        subprocess.run(["ffmpeg", "-v", "error", "-y", "-ss", f"{a0:.3f}", "-to", f"{a1:.3f}", "-i", src, "-af", "silenceremove=start_periods=1:start_threshold=-45dB,areverse,silenceremove=start_periods=1:start_threshold=-45dB,areverse", "-ac", "1", "-ar", "48000", wav], check=True)
        ld = float(subprocess.check_output(["ffprobe", "-v", "error", "-show_entries", "format=duration", "-of", "csv=p=0", wav]))
        out[l["id"]] = {"v": l["v"], "text": strip(l["text"]), "dur": round(ld, 3), "match": round(ratio, 2)}
        print(l["id"], f"{a0:.2f}-{a1:.2f} dur {ld:.2f} match {ratio:.0%}")
json.dump(out, open(f"{proj}/assets/audio/lines-timing.json", "w"), ensure_ascii=False, indent=0)
