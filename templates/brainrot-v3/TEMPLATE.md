# Brainrot v3 (editing v3, 2026-11-22): แม่แบบเดียว หน้าตาเปลี่ยนตาม `look.json`

ใช้แทน brainrot-v2 สำหรับตอนใหม่ทุกตอน (v2 ยังอยู่ ตอนเก่าไม่พัง) สรุปกฎทั้งหมด: `docs/editing-v3.md`

## ไฟล์ที่ต้องมีก่อน build
| ไฟล์ | ใครเขียน | คืออะไร |
|---|---|---|
| `projects/<x>/look.json` | ผู้กำกับ ขั้น 3 (`python3 tools/look.py pick <project> --write` แล้วแก้) | palette / font / caption / opening / cover / transition (+ music_mood, voice, music_file สำหรับขั้นเสียง, cover_text = ข้อความเฟรม 0) ค่าจาก `templates/looks/looks.json` |
| `projects/<x>/shots.json` | ผู้กำกับ | เหมือนเดิม + `"topic"` + `"beat"` ทุกช็อต (hook setup explain reveal twist share cta loop) |
| `assets/audio/shots-th.json` | `tools/shot_times.py` | เวลาช็อต (ห้ามแก้มือ) |
| `video/episode.json` | editor | `title` (= คำพูด hook คำต่อคำ, `*คำ*` = สี accent; สั้น ~≤12 ตัวไทยต่อบรรทัด 1-3 บรรทัด ยาวกว่านี้ build อาจหยุดเพราะตัวจะเล็กกว่า 72/60 px), `kicker` (POV: … หรือ ตัวเลขจาก research.md), `caps` (1-3 คำ; ถ้า words.json สะกดต่างจากบท เขียน `"คำในบท|คำที่ถอดได้"` เช่น `"*โครกคราก*|คร่ำคร่าก"`: จอแสดงซ้าย หาเวลาด้วยขวา), `plates` (ช็อต → `assets/x.mp4` / `.jpg` / `"graphic"`), `vo`, `icons` (lucide ไม่บังคับ) |

## ขั้นตอน (editor)
1. `cp -r templates/brainrot-v3 projects/<x>/video`
2. ทำ plate ทุกช็อตลง `video/assets/` ด้วย ffmpeg (1080x1920 30fps) เกรดสีทั้งคลิปชุดเดียวตาม `grade` ของ palette ใน looks.json
   (`hyperframes media-use resolve --type grade --intent "<grade>"`) ดูตัวอย่างคำสั่ง ffmpeg ใน `templates/brainrot-v2/prep_assets.sh`
   คัดลอก vo + เพลง (`look.json` `music_file`) ไป `video/assets/`
3. เขียน `episode.json` แล้ว `python3 build_index.py`
4. กราฟิกเฉพาะตอน: ใส่ใน `index.html.tpl` ตรง `EPISODE CSS` / `EPISODE GRAPHICS` / `function episode(t)` (ช็อต `"graphic"` มีช่อง `#g-<id>` ให้วาด)
   ใช้สีจากตัวแปร `var(--accent)` ฯลฯ ห้ามฝังสี hex ใหม่ (ไม่งั้นหน้าตาไม่เปลี่ยนตาม look)
5. `npm run check` → snapshot → render → `tools/sound_pass_vo.py` (make-clip "มิกซ์เสียง")
6. เฟรม 0 ยังต้องเข้าใจใน 1 วิแบบปิดเสียง (ฟีด Shorts) แต่**ปกที่อัปทำแยก 2 แบบ** (style.md 9a, ผู้ใช้ 2026-11-26 "ปกชีพ ไม่น่ากด"):
   แก้ `cover.html` (COVERS a/b ≤2 บรรทัด + ภาพเด่นใน `#art`) → `node ../../../tools/cover_shot.js cover.html ../covers a,b` → `python3 tools/cover_check.py <project> --final` → ดู `covers/compare.png`

## สิ่งที่แม่แบบทำให้เอง
- จังหวะ: ช็อต beat `hook`/`twist` = กล้องเร็ว (push 1.04→1.12 + ส่าย); ช็อตอื่น = ค้างภาพ (push ช้า 8% + หมุน 1° ไม่ตัด); ทรานซิชันของ look เล่นทุกครั้งที่เปลี่ยนช่วงเรื่อง และใน hook/หักมุม ช็อตอื่นในช่วงเดียวกัน = ครอสเฟด 0.1 วิ
- เฟรม 0: หัวข้อ hook เต็มตั้งแต่เฟรมแรก (ไม่มี fade) หายใจ 1.0↔1.04 หายตอนจบช่วง hook แล้วเด้งกลับ 0.3 วิสุดท้าย
- ลูป: ช็อตสุดท้าย (beat `loop`) เล่น plate ของ hook ให้จบที่ `media_start` ของ hook = เฟรม 0 (ต้องตั้ง `media_start` ของ hook ≥ ความยาวช็อต loop)
- ซับ 4 แบบ (`stroke` `box` `pop` `underline`) ก้อนละ ≥0.4 วิ ไฮไลต์ `*คำสำคัญ*`, เปิด 4 แบบ (`question` `midstory` `pov` `number`) × จัดวางเฟรม 0 3 แบบ (`stack` `card` `tilt`), ทรานซิชัน 5 แบบ (`whip` `zoom` `match` `flash` `slide`)

ทดสอบ: `tests/test_build_index_v3.py` (fixture `tests/fixtures/v3/`)
