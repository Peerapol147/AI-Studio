#!/usr/bin/env python3
"""Lock every footage cut to a spoken word.

The storyboard names, for each shot, the word it cuts in on ("cue") and optionally the word
the shot's action should land on ("hit", e.g. the moment someone lifts the glass).
This tool finds those words in the ElevenLabs word timestamps and writes exact times.

Usage:
  python3 tools/shot_times.py <project-dir> <lang>        # th | en
Reads : <project>/shots.json            (director: id, cue, hit, media_start, long_ok, lead)
        <project>/footage.json          (optional, footage agent: src, action_at per shot id)
        <project>/assets/audio/words[-<lang>].json
Writes: <project>/assets/audio/shots-<lang>.json  and prints a check table.

shots.json (owned by the director; rewrite it freely, footage data lives in footage.json):
{
  "lead": 0.08,                       # cut this many seconds BEFORE the cue word starts (2-3 frames reads as "on the word")
  "shots": [
    {"id": "grandma",
     "cue": {"th": "คนแก่", "en": "older"},          # word (or short phrase) the cut lands on
     "hit": {"th": "หิวน้ำ", "en": "thirsty"},        # optional: word the action/punch-in lands on
     "media_start": 2.0}                              # optional: director's hand pick of the source in-point
  ]
}
footage.json (owned by the footage agent; merged into the shots by "id"):
{"grandma": {"src": "assets/footage/x.mp4", "action_at": 2.4}}
  action_at = seconds into the source clip where the action happens.
  Old projects that keep "src"/"action_at" inside shots.json still work; for a shot listed in
  footage.json, footage.json wins (WARN if the two disagree).

media_start priority (highest first):
  1. "media_start" written in shots.json (the director picked the frame, e.g. the hook from a contact sheet)
     -> copied as is; action_at is ignored for that shot.
  2. "action_at" -> media_start = action_at - (hit_at or word_at - start), so the action lands on the word.
  3. neither -> no media_start (the editor plays the plate from 0).
  A still image (src .jpg/.jpeg/.png/.webp/.gif/.avif) has no in-point: its action_at (often 0) is skipped with an INFO
  line, never an ERROR (itch 2026-11-27: "action_at": 0 on mosquito.jpg gave "too early in the source").
Cue words are searched in order, each after the previous cue, so a repeated word picks the
right occurrence. Spaces and punctuation are ignored when matching (Thai timestamps are per character).

Errors (exit 1; an old shots-<lang>.json is DELETED so nothing downstream can use a stale timeline):
  no shots, duplicate or missing id, cue missing/empty/not found, hit empty/not found/outside its shot,
  lead/media_start/action_at not a finite number, media_start < 0.
  unknown "beat" (allowed: hook setup explain reveal twist share cta loop; see tools/pacing.py).
Warning only (exit 0): shot length outside 0.6-2.7 s (style.md; 0.6-3.0 s for beat "explain") without "long_ok";
  footage.json ids not in shots.json.
Optional "beat" per shot (editing v3) is copied to shots-<lang>.json for tools/pacing.py.

shots-<lang>.json carries "inputs" (sha256 of shots.json, footage.json and the words file). build_index.py
refuses a timeline whose inputs changed since it was written: rerun this tool after editing any of them.
"""
import hashlib, json, math, pathlib, re, sys

BEATS = ("hook", "setup", "explain", "reveal", "twist", "share", "cta", "loop")
STILL = (".jpg", ".jpeg", ".png", ".webp", ".gif", ".avif")
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


def finite(v):
    """A real JSON number (not a string, bool, NaN or Infinity)."""
    return isinstance(v, (int, float)) and not isinstance(v, bool) and math.isfinite(v)


def sha(p):
    return hashlib.sha256(p.read_bytes()).hexdigest() if p.exists() else None


def inputs_of(proj, lang):
    """Files a timeline depends on -> sha256 (None = file absent). build_index.py checks the same dict."""
    wname = "words.json" if lang == "th" else f"words-{lang}.json"
    return {n: sha(proj / n) for n in ("shots.json", "footage.json", f"assets/audio/{wname}")}


def text_for(v, lang):
    return v.get(lang) if isinstance(v, dict) else v


def main(proj, lang):
    proj = pathlib.Path(proj)
    dst = proj / "assets/audio" / f"shots-{lang}.json"
    cfg = json.loads((proj / "shots.json").read_text())
    ffile = proj / "footage.json"
    foot = json.loads(ffile.read_text()) if ffile.exists() else {}
    wfile = proj / "assets/audio" / ("words.json" if lang == "th" else f"words-{lang}.json")
    words = json.loads(wfile.read_text())
    dur = words.get("audio_duration_secs") or max(w["end"] for w in words["words"])
    stream = char_stream(words["words"])
    errs, warns = [], []
    lead = cfg.get("lead", 0.08)
    if not finite(lead) or lead < 0:
        errs.append(f"lead {lead!r} must be a number >= 0")
        lead = 0.08
    shots = cfg.get("shots")
    if not isinstance(shots, list) or not shots:
        errs.append('shots.json has no shots: add at least one {"id": ..., "cue": {...}}')
        shots = []
    ids = [sh.get("id") if isinstance(sh, dict) else None for sh in shots]
    for i, sid in enumerate(ids):
        if not sid:
            errs.append(f"shot #{i + 1}: missing \"id\"")
        elif ids.index(sid) != i:
            errs.append(f"{sid}: duplicate id (shot #{ids.index(sid) + 1} and #{i + 1}); every shot needs its own id")
    for fid in foot:
        if fid not in ids:
            warns.append(f"footage.json has '{fid}' but shots.json has no such id (renamed? footage unused)")

    infos = []
    pos, out = 0, []                       # out: (row, merged source dict)
    for i, sh in enumerate(shots):
        if not isinstance(sh, dict) or not sh.get("id"):
            continue
        sid = sh["id"]
        f = foot.get(sid, {})
        src = {k: sh[k] for k in ("src", "action_at") if k in sh}
        for k in ("src", "action_at"):
            if k in f:
                if k in src and src[k] != f[k]:
                    warns.append(f"{sid}: {k} in shots.json ({src[k]!r}) differs from footage.json ({f[k]!r}); using footage.json")
                src[k] = f[k]
        cue = text_for(sh.get("cue"), lang)
        if not isinstance(cue, str) or not cue.strip():
            errs.append(f"{sid}: no cue for {lang}")
            continue
        if not norm(cue):
            errs.append(f"{sid}: cue {cue!r} is only spaces/punctuation; use a spoken word")
            continue
        t, pos2 = find(stream, cue, pos)
        if t is None:
            errs.append(f"{sid}: cue '{cue}' not found after char {pos}")
            continue
        row = {"id": sid, "src": src.get("src"), "cue": cue, "word_at": round(t, 3),
               "start": round(max(0.0, t - lead), 3) if out else 0.0}
        if sh.get("beat") is not None:                  # editing v3 story beat, read by tools/pacing.py
            if sh["beat"] not in BEATS:
                errs.append(f"{sid}: beat {sh['beat']!r} must be one of {', '.join(BEATS)}")
            row["beat"] = sh["beat"]
        hit = text_for(sh.get("hit"), lang)
        if hit is not None and hit != "":
            if not isinstance(hit, str) or not norm(hit):
                errs.append(f"{sid}: hit {hit!r} is empty after removing spaces/punctuation")
            else:
                ht, _ = find(stream, hit, pos2 - len(norm(cue)))     # from the cue word itself onward
                if ht is None:
                    errs.append(f"{sid}: hit '{hit}' not found at or after its cue '{cue}'")
                else:
                    row["hit"], row["hit_at"] = hit, round(ht, 3)
        pos = pos2
        out.append((row, {**sh, **src}))
    for i, (r, src) in enumerate(out):
        r["end"] = out[i + 1][0]["start"] if i + 1 < len(out) else round(dur, 3)
        r["dur"] = round(r["end"] - r["start"], 3)
        if "hit_at" in r and not (r["start"] <= r["hit_at"] < r["end"]):
            errs.append(f"{r['id']}: hit '{r['hit']}' at {r['hit_at']} is outside the shot {r['start']}-{r['end']}")
        if src.get("media_start") is not None:          # director's explicit pick wins over action_at
            if not finite(src["media_start"]):
                errs.append(f"{r['id']}: media_start {src['media_start']!r} is not a finite number")
                continue
            r["media_start"] = round(float(src["media_start"]), 3) + 0.0
            if r["media_start"] < 0:
                errs.append(f"{r['id']}: media_start {r['media_start']} in shots.json is negative")
        elif src.get("action_at") is not None and str(src.get("src") or "").lower().endswith(STILL):
            infos.append(f"{r['id']}: action_at {src['action_at']!r} skipped (still image {src['src']}: no in-point)")
        elif src.get("action_at") is not None:
            if not finite(src["action_at"]):
                errs.append(f"{r['id']}: action_at {src['action_at']!r} is not a finite number")
                continue
            anchor = r.get("hit_at", r["word_at"])
            r["media_start"] = round(src["action_at"] - (anchor - r["start"]), 3) + 0.0
            if r["media_start"] < 0:
                errs.append(f"{r['id']}: action_at {src['action_at']} too early in the source (media_start {r['media_start']})")
        top = 3.0 if src.get("beat") == "explain" else 2.7   # explain shots hold 2-3 s (editing v3)
        if not 0.6 <= r["dur"] <= top and not src.get("long_ok"):
            warns.append(f"{r['id']}: {r['dur']}s (style.md wants 0.6-{top} s; set long_ok for a diagram/end shot)")
    rows = [r for r, _ in out]
    print(f"{'id':<14}{'cue':<22}{'word':>7}{'start':>8}{'dur':>7}{'hit@':>8}{'media':>7}")
    for r in rows:
        print(f"{r['id']:<14}{r['cue'][:20]:<22}{r['word_at']:>7.2f}{r['start']:>8.2f}{r['dur']:>7.2f}"
              f"{r.get('hit_at', float('nan')):>8.2f}{r.get('media_start', float('nan')):>7.2f}")
    for m in infos:
        print("INFO", m)
    for w in warns:
        print("WARN", w)
    if errs:
        for e in errs:
            print("ERROR", e, file=sys.stderr)
        stale = dst.exists()
        dst.unlink(missing_ok=True)
        print(f"{len(errs)} error(s): {dst} NOT written" + (" (old copy deleted so no step uses a stale timeline)" if stale else "")
              + ". Fix shots.json/footage.json and rerun.", file=sys.stderr)
        return 1
    avg = sum(r["dur"] for r in rows) / len(rows)
    dst.write_text(json.dumps({"lang": lang, "lead": lead, "duration": round(dur, 3), "inputs": inputs_of(proj, lang),
                               "shots": rows}, ensure_ascii=False, indent=1, allow_nan=False))
    print(f"{len(rows)} shots, avg {avg:.2f}s -> {dst}")
    return 0


if __name__ == "__main__":
    if len(sys.argv) != 3:
        sys.exit("usage: python3 tools/shot_times.py <project-dir> <th|en>")
    sys.exit(main(*sys.argv[1:3]))
