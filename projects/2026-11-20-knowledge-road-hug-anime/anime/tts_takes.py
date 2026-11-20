"""อัดเสียงละ 1 เทคต่อกลุ่ม (eleven_v3 /with-timestamps): บรรทัดที่มี "take" อยู่เทคแยก take-<V>-<take>
{...} ในบท = คำด่า: ส่งไป TTS โดยตัดวงเล็บออก (ตำแหน่งไว้ทับเสียงตี๊ดตอนมิกซ์)
ใช้: python3 anime/tts_takes.py <project> [take-name ...]"""
import json, sys, subprocess, base64, os
proj = sys.argv[1]; only = sys.argv[2:] or None
d = json.load(open(f"{proj}/lines.json"))
tools = os.path.join(os.path.dirname(os.path.abspath(__file__)), "../../../tools/get.sh")
groups = {}
for l in d["lines"]:
    name = f"take-{l['v']}" + (f"-{l['take']}" if l.get("take") else ""); groups.setdefault(name, []).append(l)
for name, ls in groups.items():
    if only and name not in only: continue
    out = f"{proj}/assets/audio/{name}.json"
    if os.path.exists(out): print("skip", out); continue
    text = "\n\n".join(l["text"].replace("{", "").replace("}", "") for l in ls)
    body = json.dumps({"text": text, "model_id": "eleven_v3"})
    r = subprocess.run(["bash", tools, f"https://api.elevenlabs.io/v1/text-to-speech/{d['voices'][ls[0]['v']]['id']}/with-timestamps?output_format=mp3_44100_128", out,
        "-X", "POST", "-H", "xi-api-key: proxy-injected", "-H", "Content-Type: application/json", "--data-binary", body], env={**os.environ, "GET_MAX_TIME": "180"})
    if r.returncode: sys.exit(f"tts fail {name} rc={r.returncode}")
    j = json.load(open(out))
    open(f"{proj}/assets/audio/{name}.mp3", "wb").write(base64.b64decode(j["audio_base64"]))
    j.pop("audio_base64"); json.dump({"text": text, **j}, open(out, "w"), ensure_ascii=False)
    print(name, "ok", j["alignment"]["character_end_times_seconds"][-1])
