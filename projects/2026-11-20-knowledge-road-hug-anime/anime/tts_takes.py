"""อัดเสียงละ 1 เทค (eleven_v3 /with-timestamps) แล้วหั่นเป็นไฟล์ต่อบรรทัดจาก alignment
ใช้: python3 anime/tts_takes.py <project>  (อ่าน lines.json, เขียน assets/audio/take-<V>.json/.mp3)"""
import json, sys, subprocess, base64, os
proj = sys.argv[1]; only = sys.argv[2:] or None
d = json.load(open(f"{proj}/lines.json"))
tools = os.path.join(os.path.dirname(os.path.abspath(__file__)), "../../../tools/get.sh")
for v, meta in d["voices"].items():
    if only and v not in only: continue
    out = f"{proj}/assets/audio/take-{v}.json"
    if os.path.exists(out): print("skip", out); continue
    text = "\n\n".join(l["text"] for l in d["lines"] if l["v"] == v)
    body = json.dumps({"text": text, "model_id": "eleven_v3"})
    r = subprocess.run(["bash", tools, f"https://api.elevenlabs.io/v1/text-to-speech/{meta['id']}/with-timestamps?output_format=mp3_44100_128", out,
        "-X", "POST", "-H", "xi-api-key: proxy-injected", "-H", "Content-Type: application/json", "--data-binary", body], env={**os.environ, "GET_MAX_TIME": "180"})
    if r.returncode: sys.exit(f"tts fail {v} rc={r.returncode}")
    j = json.load(open(out))
    open(f"{proj}/assets/audio/take-{v}.mp3", "wb").write(base64.b64decode(j["audio_base64"]))
    j.pop("audio_base64"); json.dump({"text": text, **j}, open(out, "w"), ensure_ascii=False)
    print(v, "ok", j["alignment"]["character_end_times_seconds"][-1])
