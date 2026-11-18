# EDIT-NOTES: night-overthinking (TH short, 1080x1920, 30 fps, 23.13 s)

## Files
- Video: `renders/night-overthinking-th.mp4` (with sound), `renders/night-overthinking-th-silent.mp4`
- Cover: `renders/night-overthinking-th-thumb.jpg` (1080x1920, ~100 KB) from `video/thumb/index.html` (rendered with hyperframes, frame taken with ffmpeg)
- Build: `bash prep_assets.sh` (9:16 crops of the footage + music trimmed from 2.5 s) -> `python3 build_index.py` -> `npx hyperframes render`
  -> `ffmpeg -an` = silent -> `python3 sound/make_cues.py` -> `tools/sound_pass_vo.py` (command below)
- Colour grade for each footage clip: `grades.json` -> `data-color-grading` on each `<video>` (the hyperframes media-treatment format; checked with `--dry-run`, lint ok). No CSS filters.

## Timing (from shots-th.json only)
Each footage clip is one timed `<video>` with `data-media-start` = media_start; its window is [start, end+0.12).
Cuts are crossfades of 0.10-0.12 s at `start`, with a soft scale-in (zoom 1.07->1, or a 1.03 match). No whips and no bright flashes.
Accent punch-ins land on hit_at: small 3.42 ("ใหญ่"), brain 5.58 ("ไวขึ้น"), brake 7.82 ("น้อยลง").
Captions: 26 chunks of 1-3 words, each starting on the first character of its phrase in words.json, all >= 0.4 s (assert in build_index.py).
They sit at y=1152 (60%) in Kanit 700, colour #F3EBDD, outline 16 px #0A1022 plus a navy shadow. Highlighted words are amber #FFB366: ดึก, ใหญ่, เบรก, วน, เบาลง, จด, ผู้เชี่ยวชาญ, กี่โมง.

## Motion (one shape = the thought bubble, a polar path of 120 points that morphs with springs throughout the clip)
- 0.0: hook footage (graded: shadows pushed to blue, candle light kept warm) with no fade-in. Big title "ทำไมยิ่งดึก / ยิ่งคิดมาก?" (Kanit 900) breathes 1.0<->1.04, plus a 03:00 pill and soft screen light on the face. First cut at 0.84.
- small: the bubble springs in, then swells big on "ใหญ่". It holds a worry knot (an amber line that keeps drawing itself).
- tired/room/sleep/morning/write: the bubble follows over the footage at a smaller size. At morning it shrinks and warms to gold ("เบาลง"). At write it sinks into the pen tip ("ลงกระดาษ").
- brain/brake: the bubble morphs into a soft brain outline (gyri, cerebellum, stem). The emotion spot glows amber and its pulse doubles in speed on "ไวขึ้น". The camera moves to the front of the brain, where the "ส่วนเบรก" label and gauge appear. The glow dims and the gauge drops on "น้อยลง". No anatomy terms are used.
- loop: head profile, with the bubble orbiting it on "วน" along a dashed orbit line. clock: the bubble grows big on "เรื่องใหญ่" beside a 03:00 clock (second hand ticks).
- phone_down: a glowing phone flips face down on "วาง...มือถือ" (lands at 17.32). The screen light goes out and the lamp gets brighter.
- help: the bubble turns darker and heavier and sinks on "กระทบ". help2: the bubble morphs into a cream card "คุยกับผู้เชี่ยวชาญ" / "สายด่วนสุขภาพจิต 1323".
- ask: the card morphs into a comment bubble with a tail, "ตอนนี้กี่โมงแล้ว?". The clock walks (minute hand moves, second hand ticks every 0.5 s). The background is the hook footage, dimmed, so the clip loops back to its start.
- Every shot has at least 2 layers: camera push/drift/rotate ±1° + dust/stars/bubble. Frame diff every 0.25 s: min 0.57, no static run.

## Sound (sound_pass_vo.py, measured on the MP4)
`--music video/assets/music-bed.mp3 --music-db -9 --duck-db 9` (the music starts 2.5 s into the track; no cue is a scene_cut/reveal, so the music offset stays 0)
6 soft cues: quiet whoosh 3.42, soft impact 5.58, swoosh 10.44, very quiet triangle 13.86 (-24), soft tap 17.32, plop 20.70 (-22)
Result: -16.3 LUFS integrated, true peak -5.2 dBFS, mono -16.3 / -5.2, LRA 1.5. No silence >= 0.4 s at -45 dB. Details: `renders/sound-th/SOUND.md`, `CREDITS.txt`
Nobody has listened to the audio yet. Check these 5 points: 3.42, 5.58, 10.44, 13.86, 17.32 s

## Accepted / notes
- The landscape footage is cropped to 9:16 (cover); write is scaled 1.3x so the pen tip sits above the captions, so it is a little soft.
- The scroll caption sits over the phone screen. It is readable because of the outline.
- hook/tired/sleep are three different people (see MAP.md).
- check: no errors. Remaining warnings: safe-zone (the caption/label box edge touches TikTok's right margin, but the text itself is inside the frame), line_unread for the help2 card (1.13 s, tied to the voice), and the file is long (one composition, as in the template).
- The template's English parts were removed (TH only).

## Revision 1 (after review.md)
- Hotline pill "สายด่วนสุขภาพจิต 1323" (#hot): it starts inside the help2 card and slides out of it with a spring at the start of the ask shot (20.62). It stays until the end at y≈860-940, x≈160-920, in a soft warm colour (#2A2230 at 0.88, faint amber outline). The ask bubble moved up to cy 585 and the clock to y 290 so nothing overlaps.
- sleep→morning: a 0.55 s "dawn" crossfade (the sleep video now extends to end+0.6). Luma 13.4-14.4 s goes 28→35→45→56→68→78→87, with the largest single-frame jump 13.2.
- New render and mix: -16.3 LUFS, TP -5.2 dBFS. Lowest diff every 0.27 s: 1.27. The cover was not changed.
