# Review v2: wombat-th.mp4 + wombat-en.mp4 — ต้องแก้ 2 ข้อ (FIXES NEEDED)

## ผ่าน
- ffprobe: TH 27.87s / EN 27.97s, 1080x1920 30fps, AAC 48k stereo. silencedetect (-35dB, 0.3s) and blackdetect: nothing found in either file.
- Loudness (ebur128/loudnorm): TH -16.2 LUFS, TP -5.0 dBTP; EN -16.3 LUFS, TP -5.1 dBTP. Both within target (≈-16, peak < -4).
- VO starts at TH 0.00s / EN 0.12s. No gap between words over 0.4s (words.json, words-en.json).
- Facts in script.md and script-en.md match research.md. Spot-checked online: Yang et al. 2021, Soft Matter 17:475-488; cubes form in the last ~17% of the gut; anus round on CT; stiff/soft wall regions; feces dry along the way. The "why" is asked as a question, not stated as fact.
- Caption sync: checked 12 TH chunks against pauses in vo-th.mp3 (2.92, 5.32, 7.52, 10.24, 12.10, 13.86, 15.68, 17.04, 18.96, 20.68, 24.08, 26.80) and 10 EN chunks against vo-en.mp3 pauses (1.56, 3.32, 5.48, 7.54, 9.82, 15.70, 21.14, 24.70, 26.74). All land within ±0.08s. Exact-time frames show the correct chunk on screen. Every chunk is ≥0.4s (build_index.py asserts this).
- Frames every 1.5s plus around every detected scene change (TH 10.2/24.0, EN 9.8/24.6): all crossfades, no blank frames, no pop-in/pop-out, no cropped text. The diagram is one continuous shape that morphs round → squeeze → dry → cube, with motion blur on the drop (meets Motion v2). Captions sit at y≈1190 (62%) and are clear of the diagram and the step strip. The v1 problem of the caption covering the exit is fixed.
- Thai has no floating or overlapping vowels/tone marks in captions or thumbnail. Kanit font (OFL) is credited. Both thumbnails exist (1080x1920) and read clearly.
- The English is natural, not a literal translation of the Thai.
- CREDITS.md covers every file in assets/ and every SFX (all CC0; matches renders/work/sp-*/CREDITS.txt). Music is CC BY 3.0, credited in full in both upload.md and upload-en-draft.md, plus a TikTok first-comment line. No logos, live broadcast footage or copyrighted music.

## Fixes
1. **TH scene 9 (ending question), 24.08–27.87s: about 3.8s, over the 3s limit in style.md.** The EN version is fine (24.70–27.64 = 2.94s). The slow part is the drawn-out "แล้วเพื่อนๆ ว่า... ...กันน้า?". Re-record or tighten scene 9 to ≤3s (e.g. "แล้วเพื่อนๆ คิดว่ามันขี้เหลี่ยมไปทำไม? คอมเมนต์บอกหน่อย!"), cut the end straight after the last word, then re-time captions and SFX for scene 9 and re-render TH. Agents: voice → editor (build_index.py CAPS th + cues-th.json).
2. **upload.md is out of date and has a fact not in research.md.** (a) The header says "24 วิ"; the actual length is 28s. (b) Title option 3, "สัตว์เดียวในโลกที่ขี้เป็นลูกเต๋า", claims wombats are the only animal that does this, and research.md doesn't say that. Remove this title, or add a source to research.md first. Agent: writer.

Note (not blocking): the footage part (0–10.2s) averages about 2.0s per shot, a little over the 1.8s guide. 10.2–24.1s is one continuous diagram shot, which Motion v2 allows.
