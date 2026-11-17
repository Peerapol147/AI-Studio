#!/usr/bin/env python3
"""Lock every footage cut to a spoken word.

The storyboard names, for each shot, the word it cuts in on ("cue") and optionally the word
the shot's action should land on ("hit", e.g. the moment someone lifts the glass).
This tool finds those words in the ElevenLabs word timestamps and writes exact times.

Usage:
  python3 tools/shot_times.py <project-dir> <lang>        # th | en
Reads : <project>/shots.json, <project>/assets/audio/words[-en].json
Writes: <project>/assets/audio/shots-<lang>.json  and prints a check table.

shots.json:
{
  "lead": 0.08,                       # cut this many seconds BEFORE the cue word starts (2-3 frames reads as "on the word")
  "end": "auto",                      # last shot ends at the audio end
  "shots": [
    {"id": "grandma", "src": "assets/footage/x.mp4",
     "cue": {"th": "คนแก่", "en": "older"},          # word (or short phrase) the cut lands on
     "hit": {"th": "หิวน้ำ", "en": "thirsty"},        # optional: word the action/punch-in lands on
     "action_at": 2.4}                                # optional: seconds into the source clip where the action happens
  ]
}
Cue words are searched in order, each after the previous cue, so a repeated word picks the
right occurrence. Spaces and punctuation are ignored when matching (Thai timestamps are per character).

Checks: shot length 0.6-2.7 s (style.md), cue found, hit inside its shot, media_start >= 0.
"""
import json, pathlib, re, sys

STRIP = re.compile(r"[\s.,!?…'\"“”‘’\-–—:;()]+")


def norm(s):
    return STRIP.sub("", s).lower()


def char_stream(words):
    """Flatten the transcript into (char, start) pairs, without spaces/punctuation."""
    out = []
    for w in words:
        if w.get("type") != "word":
            continue
        chars = w.get("characters") or [{"text": c, "start": w["start"]} for c in w["text"]]
        if not w.get("characters") and len(w["text"]) > 1:   # English: spread start over the word, first char exact
            chars = [{"text": c, "start": w["start"]} for c in w["text"]]
        for c in chars:
            for ch in c["text"]:
                if norm(ch):
                    out.append((ch.lower(), c["start"]))
    return out


def find(stream, text, frm):
    s = "".join(c for c, _ in stream)
    key = norm(text)
    i = s.find(key, frm)
    if i < 0:
        return None, frm
    return stream[i][1], i + len(key)


def main(proj, lang):
    proj = pathlib.Path(proj)
    cfg = json.loads((proj / "shots.json").read_text())
    wfile = proj / "assets/audio" / ("words.json" if lang == "th" else f"words-{lang}.json")
    words = json.loads(wfile.read_text())
    dur = words.get("audio_duration_secs") or max(w["end"] for w in words["words"])
    stream = char_stream(words["words"])
    lead = cfg.get("lead", 0.08)
    pos, out, errs = 0, [], []
    for sh in cfg["shots"]:
        cue = sh["cue"].get(lang) if isinstance(sh["cue"], dict) else sh["cue"]
        if cue is None:
            errs.append(f"{sh['id']}: no cue for {lang}")
            continue
        t, pos2 = find(stream, cue, pos)
        if t is None:
            errs.append(f"{sh['id']}: cue '{cue}' not found after char {pos}")
            continue
        pos = pos2
        row = {"id": sh["id"], "src": sh.get("src"), "cue": cue, "word_at": round(t, 3),
               "start": round(max(0.0, t - lead), 3) if out else 0.0}
        hit = sh.get("hit", {})
        hit = hit.get(lang) if isinstance(hit, dict) else hit
        if hit:
            ht, _ = find(stream, hit, pos - len(norm(cue)))
            if ht is None:
                errs.append(f"{sh['id']}: hit '{hit}' not found")
            else:
                row["hit"], row["hit_at"] = hit, round(ht, 3)
        out.append(row)
    for i, r in enumerate(out):
        r["end"] = out[i + 1]["start"] if i + 1 < len(out) else round(dur, 3)
        r["dur"] = round(r["end"] - r["start"], 3)
        src = next(s for s in cfg["shots"] if s["id"] == r["id"])
        if "hit_at" in r and not (r["start"] <= r["hit_at"] < r["end"]):
            errs.append(f"{r['id']}: hit '{r['hit']}' at {r['hit_at']} is outside the shot {r['start']}-{r['end']}")
        if "action_at" in src:
            anchor = r.get("hit_at", r["word_at"])
            r["media_start"] = round(src["action_at"] - (anchor - r["start"]), 3)
            if r["media_start"] < 0:
                errs.append(f"{r['id']}: action_at {src['action_at']} too early in the source (media_start {r['media_start']})")
        if not 0.6 <= r["dur"] <= 2.7 and not src.get("long_ok"):
            errs.append(f"{r['id']}: {r['dur']}s (style.md wants 0.6-2.7 s; set long_ok for a diagram/end shot)")
    dst = proj / "assets/audio" / f"shots-{lang}.json"
    dst.write_text(json.dumps({"lang": lang, "lead": lead, "duration": round(dur, 3), "shots": out},
                              ensure_ascii=False, indent=1))
    print(f"{'id':<14}{'cue':<22}{'word':>7}{'start':>8}{'dur':>7}{'hit@':>8}{'media':>7}")
    for r in out:
        print(f"{r['id']:<14}{r['cue'][:20]:<22}{r['word_at']:>7.2f}{r['start']:>8.2f}{r['dur']:>7.2f}"
              f"{r.get('hit_at', float('nan')):>8.2f}{r.get('media_start', float('nan')):>7.2f}")
    avg = sum(r["dur"] for r in out) / max(1, len(out))
    print(f"{len(out)} shots, avg {avg:.2f}s -> {dst}")
    for e in errs:
        print("WARN", e)
    return 1 if any("not found" in e for e in errs) else 0


if __name__ == "__main__":
    sys.exit(main(*sys.argv[1:3]))
