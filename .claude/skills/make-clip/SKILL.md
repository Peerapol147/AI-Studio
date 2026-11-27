---
name: make-clip
description: Use when the user asks for a new clip or episode ("ทำคลิป", "ทำตอนใหม่", "make a short", "ทำคลิปยาว") for the knowledge or football channel, in Thai and/or English, short (Shorts/TikTok 9:16) or long (YouTube 16:9), or asks to redo, fix or re-render an existing clip in projects/.
---

# Make a clip (AI Studio)

ผู้กำกับ (คุณ) คุมสายพานทั้งหมด ผู้ใช้ได้แค่ไฟล์ MP4 + ปก + ข้อความอัปโหลด แล้วอัปโหลดเอง **ห้ามอัปโหลด/ตั้งเวลาโพสต์**
1 เซสชัน = 1 ตอน (`docs/sessions.md`) **แม่แบบตัดต่อหลัก (ตั้งแต่ 2026-11-22): `templates/brainrot-v3/` + `look.json` ต่อตอน** (กฎทั้งหมด `docs/editing-v3.md`; v2 เหลือไว้ให้ตอนเก่าเท่านั้น)
`projects/2026-11-17-knowledge-nature/` (วอมแบต) เหลือเป็นตัวอย่างโครงไฟล์เอกสาร (brief/research/upload) เท่านั้น ห้ามคัดลอก `video/` ของวอมแบตมาตัดต่อ

## 0. เริ่มตอน
- อ่าน `channels/<channel>/channel.md` + `style.md` (ถ้ามี) เสมอ ช่องฟุตบอลยังไม่มี style.md: ขอคลิปตัวอย่างจากผู้ใช้ก่อน (ดูข้อ "เรียนสไตล์")
- branch `claude/ep-<YYYY-MM-DD>-<slug>` แตกจาก `main` (ถ้ายังไม่มี `main` ให้แตกจาก `claude/stoic-cray-6z2ajs`) โฟลเดอร์ `projects/<YYYY-MM-DD>-<channel>-<slug>/`
- หัวข้อที่ผู้ใช้ระบุมาแล้ว → ข้ามขั้น 1 ไปขั้น 2 เลย
- ติดตั้งครั้งเดียวต่อเครื่อง (เครื่องคลาวด์ใหม่ไม่มี): `pip install --user librosa soundfile scipy matplotlib` (ต้องใช้กับ `tools/sound_pass_vo.py`)
- อ่าน `channels/<channel>/results.md` (ผลวิวจริง) ก่อนเลือกหัวข้อ ทิศทางล่าสุดอยู่หัว `style.md` และชนะกฎเก่าในไฟล์เดียวกัน
- ค่าเริ่มต้น: short **20-40 วิ** (ยาวกว่าต้องมี `long_reason` ใน shots.json, เพดาน 59 วิ; style.md ทิศทาง 2026-11-22 ข้อ 7), ภาคต่อหัวข้อเดิม: พักไว้ (2026-11-23): ภาคต่อหัวข้อเดิมได้ ~1.2K ทั้ง 2 ครั้ง (เข่าดังกร๊อบ, ปวดอึในอวกาศ) → ทำหัวข้อใหม่แนวเดียวกันแทน, **ภาษาไทยอย่างเดียว** (ผู้ใช้สั่งเลิกทำอังกฤษ 2026-11-18) ทำอังกฤษเฉพาะเมื่อผู้ใช้สั่งชัดๆ ในตอนนั้น
  ไม่ทำ: `script-en.md`, `vo-en`, `words-en`, `render -en`, ปก -en, `upload-en.md`; ส่วนอื่นในไฟล์นี้ที่พูดถึง en/สองภาษาให้ข้าม
- เช็ก `PIXABAY_API_KEY` (env หรือ `.env`) ถ้าไม่มี บอกผู้ใช้ให้ตั้งใน Environment variables ก่อนขั้น footage

## หัวข้อจากเทรนด์ต่างประเทศ (สไตล์ที่ผู้ใช้ชอบ: ตอน knuckle-crack)
เมื่อผู้ใช้สั่ง "หัวข้อดังจากต่างประเทศ" หรือ "แบบตอนหักนิ้ว": ผู้กำกับหาเอง (researcher ไม่มี Bash)
```bash
curl -s "https://www.youtube.com/results?search_query=why+do+we+<คำ>&sp=EgIYAQ%253D%253D" | grep -oE '"accessibilityText":"[^"]{0,160}views[^"]*"' | head -20
```
ค้นไทยด้วย: `...results?search_query=<คำไทย URL-encode>&sp=EgIYAQ%253D%253D&hl=th&gl=TH` แล้ว grep `"accessibilityText":"[^"]*เล่นวิดีโอสั้น"` (รูปแบบ "การดู X ครั้ง")
(ค้นหาแบบ Shorts อ่านแค่ยอดวิว ห้ามดาวน์โหลดคลิป) เกณฑ์ผ่านและกลุ่มหัวข้อ: style.md ทิศทาง 2026-11-19 (ไทย ≥100K หรือต่างประเทศ ≥1M, ≥2 คลิปจากคนละช่อง) จดผลค้นใน brief.md
มุมเล่า: **"ความเชื่อ vs ความจริง"** (คนเชื่อว่า... → แต่งานวิจัยบอกว่า...) ใช้แค่หัวข้อ เขียนบท/ภาพ/ชื่อเอง
ก่อนเลือก: เช็ก Pixabay **videos** totalHits ของ action หลัก ถ้า 0 ให้วางแผนเป็นภาพนิ่ง push-in + กราฟิกตั้งแต่บท
**(แทนที่แล้ว 2026-11-22 ด้วย Brainrot v3 + look.json — ข้อความในย่อหน้านี้เป็นประวัติ: ใช้เอาจังหวะ/motion มาเป็นแนว ไม่ใช้เป็นแม่แบบตอนใหม่)** แม่แบบเดิม (ผู้ใช้อนุมัติ 2026-11-19 "ตัดต่อดีมาก โคตรชอบ"): Brainrot v2 = branch `claude/ep-2026-11-19-brainrot` commit `7b088c8`
คัดลอก **`templates/brainrot-v2/`** (อยู่ใน branch หลักแล้ว ไม่ต้อง fetch) ไปเป็น `<project>/video/` แล้วแก้ (ต้นฉบับ: commit `7b088c8` ใน branch ตอน brainrot)
v3 คงไว้: kinetic type, กราฟิก vendor, spring motion, เสียงพากย์พาวนกลับ hook; เปลี่ยน: จังหวะตัดแล้วแต่คลิป (style.md ข้อ 4, ผู้ใช้ 2026-11-25 — ตัดถี่ ~1.3-1.5 วิทั้งคลิปได้ถ้าเนื้อหา/ภาพเอื้อ), สี/ฟอนต์/ซับ/โครงเปิด/ทรานซิชัน/เพลง/เสียงตาม look.json
ประวัติ (ไม่เกี่ยวกับแม่แบบ `brainrot-v3`): ดราฟต์รอบที่ 3 ของตอน brainrot (commit `4044191`) อย่าเอามาเป็นแม่แบบ (บทดี แต่ตัดต่อ v2 ดีกว่า) — แม่แบบหลักตอนนี้คือ `templates/brainrot-v3/`
แม่แบบเก่า (ใช้เมื่อหัวข้อเป็นแผนภาพกลไก 2D): `projects/2026-11-18-knowledge-knuckle-crack/` (branch `claude/ep-2026-11-18-knuckle-crack`)
`git fetch origin <branch> && git archive FETCH_HEAD <path> | tar -x`

## ล้มเร็ว ห้ามรอเงียบ (กฎตายตัว ผู้ใช้สั่ง หลังตอนแมวเสีย ~44 นาที)
- ดึงเว็บ/API ทุกครั้งผ่าน `bash tools/get.sh <url> [out|-] [curl options]` (หมดเวลา 20 วิ, 429/403/5xx/หมดเวลา = exit 75, 4xx อื่น = exit 1 = ห้ามลองซ้ำ URL เดิม แก้คำขอหรือข้ามไฟล์; ล้มแล้วไม่ทับไฟล์เดิม) สคริปต์ tts/words/footage/music เรียกผ่านตัวนี้อยู่แล้ว
- เจอ 429 / rate limit / retry-after / บล็อก **ครั้งเดียว = เลิกแหล่งนั้นทันที** ห้าม `sleep` ห้ามรอ retry-after ห้ามลองซ้ำ
  (ยกเว้นเดียว: `tools/footage_search.py` ลอง 429 ซ้ำได้ 2 ครั้ง รอ 3 และ 9 วิ (เพดาน 12 วิในโค้ด) แล้วข้ามแหล่งนั้นทุกช็อต 10 นาที + จดใน SEARCH.json; ห้องวางแผน 2026-11-26 หลัง footage ตอน palmaris ได้น้อยเพราะยอมแพ้เร็ว)
- ลำดับสำรอง (footage): Pixabay → Pexels → Openverse → NASA → Wikimedia → Smithsonian (ภาพนิ่ง CC0 สัตว์/ธรรมชาติ/ประวัติศาสตร์) ผ่าน `tools/footage_search.py`; ได้ไม่ถึงครึ่งของช็อต = แจ้งผู้ใช้ทันทีพร้อมทางเลือก (กราฟิก / มือ SVG rig / ผู้ใช้ถ่ายเอง) ห้ามทำกราฟิกแทนเงียบๆ
- งานส่วนไหนติดเกิน 5 นาที: หยุด เขียนสถานะลงไฟล์ แล้วตอบกลับผู้กำกับทันที (ติดอะไร ลองอะไรแล้ว เหลืออะไร) อย่าเงียบ
- **ผู้กำกับ:** agent ที่รันเบื้องหลังเกิน 15 นาทีโดยไม่มีข่าว ให้ส่งข้อความถามสถานะ (SendMessage) หรือหยุดแล้วสั่งใหม่ และ**บอกผู้ใช้ทันที**ว่าติดอะไร ห้ามรอเงียบ
- สั่ง agent ทุกครั้งต้องมีบรรทัด: "เจอ rate limit/บล็อก = เปลี่ยนแหล่งทันที ติดเกิน 5 นาที = ตอบกลับ"

## 1-7. สายพาน (ใครทำ → ไฟล์ที่ได้)
**บทพูด: อ่าน style.md หัวข้อ "บทพูดแบบที่ผู้ใช้ต้องการ" ก่อนเขียนทุกครั้ง** (ภาษาพูดเต็มประโยค อธิบายศัพท์ทันที ความเข้าใจมาก่อนความยาว ห้ามตัดคำเชื่อมเพื่อให้สั้น)

| ขั้น | ใคร | ผลลัพธ์ | สิ่งที่ต้องสั่งให้ชัด |
|---|---|---|---|
| 1 หัวข้อ | `researcher` | `research-topics.md` (5 หัวข้อ จัดอันดับ) | ห้ามหัวข้อเกร่อ/ซ้ำกับ `projects/*/brief.md`; หลังได้ผล **ผู้กำกับเช็ก footage เอง** (เรียก API เล็กๆ ไม่ใช่อ่านไฟล์ใหญ่) ด้วย Pixabay API (`totalHits` + ดู `tags` ว่าตรงจริง ไม่ใช่ fuzzy match; ข้ามคลิป tag "generated") |
| 2 brief + research | ผู้กำกับ | `brief.md`, `research.md` | ข้อเท็จจริงทุกข้อมีแหล่ง; สิ่งที่เป็นแค่สมมติฐาน ห้ามพูดเป็นความจริง (ใช้เป็นคำถามปิดท้ายแทนได้) |
| 3 บท + สตอรีบอร์ด + หน้าตา | ผู้กำกับ + skill `yt-hook-scripter`, `yt-thumbnail-brief` | `script.md`, `script-en.md`, `storyboard.md`, `shots.json` (มี `topic` + `beat` ทุกช็อต), `look.json`, `thumbnail.md` (ปก A/B: ภาพเด่น + ข้อความ ≤2 บรรทัดต่อแบบ แนว curiosity แยกจากเฟรม 0; จดลง `look.json` `"covers"`) | ไทย: ความยาว 20-40 วิ (≈ 240-475 ตัวอักษร ที่ ~11.9 ตัว/วิ: George atempo 1.1 + ตัดเงียบ, style.md "จับเวลา"); hook 3 แบบ เลือก 1 ตาม style.md (คำถามบนจอตั้งแต่ 0.0 วิ); **ทุกแบบต้องมีเดิมพัน/คำแปลก/ขัดกับที่เชื่อ ไม่ใช่คำถามลอยๆ** (style.md ข้อ 1: "ร่างกายเรามีอะไหล่สำรองด้วยนะ" ชนะ "ข้อมือมีเส้นนี้ไหม?") จดใน script.md ว่าแต่ละแบบใช้ข้อไหน; อังกฤษ **เขียนใหม่** ไม่แปล; โครง (v3, style.md ทิศทาง 2026-11-22): hook (หัวข้อจบใน 1.5 วิ ไม่ทักทาย/โลโก้/ปูพื้น) → คนคิดว่า → **เฉลยที่ ~50-60%** → **หักมุม/ข้อแถม 1 ข้อ** → **ข้อเท็จจริงน่าส่งต่อ 1 ข้อ** → **คำถามชวนคอมเมนต์ ≤4 วิ**; ตำนาน/ลี้ลับ เล่าเรื่อง 70 / หักมุม 30; **ประโยคสุดท้ายอ่านต่อเข้าประโยคแรกได้ลื่น** (แต่ละประโยคจบในตัว); shots.json: `"topic": {"th": "<คำท้ายของหัวข้อ>"}` + `"beat"` ทุกช็อต (hook setup explain reveal twist share cta loop) + `"pace"` (จังหวะตัดแล้วแต่คลิป style.md ข้อ 4: เขียนเหตุผลสั้นๆ เช่น "ตัดถี่ 1.4 วิ ภาพจริงเยอะ"); **หน้าตา:** `python3 tools/look.py pick <project> --write` (เลือกต่างจาก 3 ตอนล่าสุดของช่อง อ่านจาก projects/ + branch `claude/ep-*` ที่ fetch แล้ว: `git fetch origin 'refs/heads/claude/ep-*:refs/remotes/origin/claude/ep-*'`) แก้อารมณ์เพลงให้เข้าแนวเรื่อง (เสียงพากย์ช่อง knowledge ล็อก ห้ามแก้) ใส่ `"cover_text"` (ข้อความเฟรม 0 ห้ามคล้ายตอนก่อน; ปกที่อัปแยกเป็น `"covers"` A/B) แล้ว `python3 tools/look.py check <project>` ต้องผ่าน แล้ว **commit + push look.json ทันที** (ห้องที่ทำตอนพร้อมกันจะได้เห็น; fetch branch ep ใหม่ก่อน `check --final`); เฟรม 0 ต้องเข้าใจได้ภายใน 1 วิโดยไม่เปิดเสียง; โครงเปิด `number` ใช้ตัวเลขจาก research.md เท่านั้น **ขั้นเกลาภาษาพูด (style.md) บังคับก่อนล็อกบท และก่อนทำ shots.json / cover_text / ข้อความบนจอ** แล้วนับตัวอักษรใหม่ จดตาราง ก่อน→หลัง ใน script.md |
| 4a เสียง | `voice` (ไทย) | `assets/audio/vo-<lang>.mp3`, `words*.json`, `timing*.md`, เพลง, sfx | บอกชื่อไฟล์ที่แต่ละตัวห้ามแตะ; ไทยต้อง `eleven_v3`+; ใช้ voice_id ตาม `look.json` `voice` (ชื่อใน `templates/looks/looks.json` หรือ `id:<voice_id>`; ไม่มีค่อยใช้ channel.md); **ช่อง knowledge ล็อก George + eleven_v3 + atempo 1.1 + -18 LUFS ทุกตอน** (ผู้ใช้ 2026-11-26; `looks.json` `channel_lock`, `look.py` ไม่สุ่มเสียงช่องนี้) ลำดับ: เทคเดียว → `trim_silence.sh ... 0.5` → `tools/vo_finish.sh` (atempo + normalize) → words; เพลง: `tools/music.sh music "<query ของ music_mood ใน looks.json>" <project> 3 30` เลือก 1 แล้ว**เขียนชื่อไฟล์ลง `look.json` `music_file`** และรัน `python3 tools/look.py check <project> --final` (ห้ามเพลงเดียวกับตอนก่อน) (เครดิตลง CREDITS.md อัตโนมัติ); sfx ไม่ต้องทำในขั้นนี้ (editor เลือกจาก skill `sound-effects`); อัดทั้งบทเทคเดียว แล้ว silenceremove + atempo (knowledge = 1.1 ตายตัว, ช่องอื่น ≤1.12) + normalize -18 LUFS; จับเวลาคำด้วย ElevenLabs `scribe_v1` |
| 4b footage | `footage` (พร้อม 4a) | `assets/footage/` + `MAP.md`, `CREDITS.md`, `SEARCH.json` | **ทุกช็อตค้น ≥10 คำ ไทย+อังกฤษ วิดีโอ+ภาพนิ่ง หลายแหล่ง ด้วย `tools/footage_search.py search`** แล้ว `footage_search.py report` (exit 1 = ค้นไม่ครบ สั่งค้นต่อ; **exit 2 = ได้ไม่ถึงครึ่งของช็อต → ผู้กำกับต้องบอกผู้ใช้ทันทีพร้อมทางเลือกใน `assets/footage/ALERT.md`: กราฟิก / มือ SVG rig / ผู้ใช้ถ่ายเอง / ค้นต่อ ห้ามรับแล้วทำกราฟิกเงียบๆ** ผู้ใช้ 2026-11-26 "ทำไมไม่บอก"); ช็อตที่วางแผนเป็นกราฟิกตั้งแต่ต้นใส่ `"footage": false` ใน shots.json; ขนาด medium ไม่เอาไฟล์ใหญ่; Wikimedia โดน rate-limit ง่าย ขอทีละน้อย; หาไม่ได้ = ทำเป็นกราฟิก; หัวข้อร่างกาย/ใกล้ตัว Pixabay มักไม่มีภาพเฉพาะ เช็ก Wikimedia Commons ตั้งแต่ขั้น 1; วิดีโอใช้ 1080p ขึ้นไป (ครอป 9:16 จาก 720p เหลือ ~405px แตก) |
| 5 motion + ตัดต่อ (ก่อนเริ่ม: **ผู้กำกับเลือกช่วง hook เอง** จาก contact sheet ของคลิปเต็ม แล้วใส่ `media_start` ใน shots.json — เคยต้องเรนเดอร์ใหม่ทั้งคลิปเพราะเฟรม 0 เห็นแต่หัวลูกแมวมุดแก้ว) | `editor` (หลัง 4a เสร็จ) — เริ่มจาก**คัดลอก** `templates/brainrot-v3/` ไปเป็น `<project>/video/` (อ่าน `TEMPLATE.md` ในนั้น: `episode.json` + `look.json` → `build_index.py`; กราฟิกเฉพาะตอนใช้สี `var(--accent)` ฯลฯ ห้ามฝังสีของ v2) ไม่สร้างจากศูนย์; ก่อนเรนเดอร์ `python3 tools/pacing.py <project>` ต้องผ่าน; หัวข้อที่เป็นแผนภาพกลไก 2D ใช้ knuckle-crack แทน (ดูหัวข้อด้านบน) | `video/index.html.tpl` + `build_index.py` (คอมโพสิชันเดียว; `python3 build_index.py` หา repo root เอง, `--audio`/`--out` ถ้าวางไว้ที่อื่น), `renders/<slug>-<lang>.mp4`, ปก `-thumb.jpg` | ให้อ่าน skill `hyperframes`, `motion-broll`, `sound-effects` + style.md "Motion v2"; มิกซ์ด้วย `tools/sound_pass_vo.py` (ดูหัวข้อ "มิกซ์เสียง") ปก (thumbnail ที่อัป) **แยกจากเฟรม 0** ทำ 2 แบบ (A/B) ทุกตอน: `look.json` `"covers"` + `video/cover.html` (แม่แบบใน `templates/brainrot-v3/cover.html`) → `node tools/cover_shot.js video/cover.html <project>/covers a,b` → `python3 tools/cover_check.py <project> --final` ต้องผ่าน แล้วดู `covers/compare.png` (ย่อ 200 px เทียบปกเก่า) ก่อนส่ง; commit `covers/*.jpg` + `.json` (style.md ข้อ 9a; เฟรม 0 ยังต้องเข้าใจใน 1 วิปิดเสียง) |
| 6 ตรวจ | `reviewer` | `review.md` (ต้องมีหัวข้อ "ฟังก่อนอัปโหลด" + "เช็กลิสต์ตัดต่อ v3" + "ตรวจภาพทุกเฟรม" ครบทุกแผ่นของ `tools/contact_sheet.py`) | ทุกครั้ง: เช็กลิสต์ v3 ใน `.claude/agents/reviewer.md` (รัน `tools/look.py check --final`, `tools/pacing.py`, เล่นท้ายต่อหัว, เทสต์ปิดเสียงเฟรม 0); ให้ส่ง**รายการ timestamp เสียงที่ผู้ใช้ต้องฟังจริง** 3-7 จุด (เริ่มจาก "Check these 5 with headphones" ใน `renders/sound-<lang>/SOUND.md` + คำอ่านยาก/ชื่อเฉพาะ/ตัวเลขในพากย์ + จุดเพลงดังชนพากย์) พร้อมเหตุผลสั้นๆ ต่อจุด |
| 7 ส่งมอบ | ผู้กำกับ + `yt-title-optimizer`, `yt-description-writer` | `upload.md`, `upload-en.md` | ความยาวคลิปจริง, ส่งรายการ "ฟังก่อนอัปโหลด" จาก review.md ให้ผู้ใช้ทุกครั้ง, ห้ามชื่อคลิปที่อ้างเกิน research ("ตัวเดียวในโลก"), เครดิตเพลง CC BY + ภาพ (ภาพ CC BY ที่ครอป/ปรับสี เขียนว่า "ครอปและปรับสี"), TikTok: แคปชันสั้น + เครดิตเพลงในคอมเมนต์แรก + ติด label AI; **FB Reels: ชื่อ/แคปชัน/แฮชแท็กแยกอีกหัวข้อ** (MP4 ไฟล์เดียวกันทุกแพลตฟอร์ม ผู้ใช้อัปเอง); **บอกผู้ใช้ทุกครั้ง (คำแนะนำ ไม่มีหลักฐานว่าลงเยอะแล้วโดนลงโทษ): ลงวันละ 1-2 คลิป เว้นระยะ ไม่ลง 5-6 คลิปวันเดียว** เพื่อดูผลแต่ละคลิปแยกกันได้ |

**ก่อนส่งผู้ใช้ (กฎตายตัว feedback palmaris ข้อ 1 "Motion มันห่วยแตก"):** ผู้กำกับเปิดดู contact sheet **ทุกแผ่น** ใน `renders/frames-<lang>/` เอง (`python3 tools/contact_sheet.py make ...` ถ้ายังไม่มี; เฟรมทุก 0.25 วิ ไม่ใช่ 14 เฟรม)
และ `python3 tools/contact_sheet.py verify <project>` ต้อง `frames: OK` (reviewer จดทุกแผ่นใน review.md); **ห้ามสั่ง reviewer ข้าม/ผ่อนด้านภาพ กราฟิก หรือ motion** แม้จะรีบ
ส่งไฟล์ให้ผู้ใช้ด้วย SendUserFile (mp4 + ปก A และ B + บอกว่าใช้แบบไหนเป็นตัวหลัก และให้จด CTR หลัง 48 ชม.: `tools/cover_check.py log`) แล้วบอก: สิ่งที่ผ่าน, สิ่งที่ยอมรับไว้, **และว่าไม่มีใครฟังเสียงจริง** พร้อมรายการ timestamp "ฟังก่อนอัปโหลด" จาก review.md (เวลา + ต้องฟังอะไร) ให้ผู้ใช้ฟังก่อนอัปโหลด
commit + push หลังจบแต่ละขั้น (stop hook บังคับ commit ทุกครั้งที่จบการตอบ แม้ agent ยังทำไม่เสร็จ: commit เป็น "wip: ..." ได้) (`*.mp4` และ footage ถูก .gitignore ไว้แล้ว)

## ภาพตรงคำพากย์ (บังคับตั้งแต่ ep 2)
เวลาทุกช็อตมาจากคำพูด ไม่ตั้งด้วยมือ ทำตาม `docs/pipeline.md` หัวข้อ "ภาพตรงจังหวะพากย์":
ผู้กำกับเขียน `shots.json` (ขั้น 3) → footage เขียน `footage.json` (`src`/`action_at` ต่อ id) → voice ทำ words ด้วย `bash tools/words.sh` →
`python3 tools/shot_times.py <project> th|en` → editor ใช้ `assets/audio/shots-<lang>.json` เท่านั้น
- cue ห่างกันอย่างน้อย ~5-6 คำไทย / 3 คำอังกฤษ (ติดกันเกินจะได้ช็อต <0.6 วิ)
- วาง `cue` ใน shots.json **หลังได้ words.json** (หรือร่างให้ช็อตละ ~1.2 วิ ตั้งแต่แรก) ไม่งั้นช็อตยาว/สั้นเกิน
- เขียน shots.json ใหม่/แก้ cue ได้เลย ข้อมูล footage อยู่ใน `footage.json` (รวมด้วย id) ห้ามเปลี่ยน id ช็อตที่ footage ทำไปแล้ว (tool เตือน id ที่ไม่ตรง)
- shot_times ล้ม (exit 1) = ไม่มี shots-<lang>.json ห้ามตัดต่อต่อ แก้แล้วรันใหม่ (build_index ปฏิเสธ timeline เก่าที่ไม่ตรงไฟล์ปัจจุบันเอง)

## มิกซ์เสียง
```bash
python3 tools/sound_pass_vo.py --video renders/<slug>-<lang>-silent.mp4 --voice assets/audio/vo-<lang>.mp3 \
  --cues video/sound/cues-<lang>.json --music assets/audio/<music>.mp3 \
  --manifest .claude/skills/sound-effects/sfx/manifest.json --out renders/sound-<lang> \
  --music-source "<เพลง> by <ศิลปิน> <ลิงก์>" --music-license "CC BY 3.0"
```
**ค่ามาตรฐานมิกซ์ (ผู้ใช้ 2026-11-26 "เพลงก็ดังเกิน", feedback palmaris ข้อ 4):** เพลง `--music-db -24`, duck `--duck-db 8` (= ค่าเริ่มต้นของสคริปต์แล้ว ไม่ต้องใส่),
เสียงพากย์ต้องผ่าน `tools/vo_finish.sh` (-18 LUFS) **ก่อน** words และก่อนมิกซ์ → เพลงต่ำกว่าเสียงพูด ~20 LU; SOUND.md ขึ้น `WARN` ถ้าพากย์ไม่ใกล้ -18 หรือเพลงต่ำกว่าพูดไม่ถึง 12 LU = แก้ก่อนส่ง
cues: list ของ `{"t": วินาที, "type": "appear|scene_cut|...", "desc": "...", "sfx": "kit/pop.ogg", "gain": -8}` (ไฟล์ sfx อ้างจาก `.claude/skills/sound-effects/sfx/`) ตัวอย่าง: `templates/brainrot-v2/sound/cues-th.json` (สร้างด้วย `sound/make_cues.py`)

## มาตรฐาน motion (ผู้ใช้เคยบอกว่า "แปลกๆ" กับเวอร์ชันแรก)
- **ซีรีส์ "ลองทำตามเดี๋ยวนี้" / ท่ามือ:** ใช้มือ SVG rig `templates/brainrot-v3/compositions/components/hand-rig/` (README ในนั้น; ผู้ใช้ 2026-11-25 "การวาดแบบนี้ค่อยเข้าท่าหน่อย") ห้ามมือการ์ตูนขาวแบน มือ 3D หุ่นนิ่ง หรือเส้นชี้ลอยๆ (ผู้ใช้ตีตกทั้งหมด); ช็อตท่ามือใน shots.json ใส่ `"footage": false` ได้ (ไม่นับใน footage report) แต่ต้องตัดสินจากผลค้นจริงหรือแผนตั้งแต่บท
- กราฟิกเป็น **รูปร่างเดียวที่ morph ต่อเนื่อง** (ขนาด มุม สี) ด้วย spring ไม่โผล่/หายกระตุก ไม่ใช้ "ขีดฆ่าแล้วใส่ไอคอนใหม่"
- ทุกการเปลี่ยนลงตรงคำพูด; ภาพนิ่งมี Ken Burns ช้าๆ
- ฉากแผนภาพ: แผนภาพอยู่บน ~60% ของจอ, ซับใต้แผนภาพ, ส่วนล่างไม่ว่าง (เช่น แถบขั้นตอน)
- ซับ 1-3 คำ (อังกฤษ 1-4) **ทุกก้อน ≥0.4 วิ**, ขาวขอบดำ, ~60-62% ความสูง, Kanit 700 จาก `assets/fonts/` (v3: ฟอนต์/แบบซับตาม look.json ใน `video/fonts/`), ข้อความต้องตรงเสียงที่อ่านจริง (ดูจาก words.json ไม่ใช่บท)
- เสียง: -16 LUFS, true peak < -4 dBFS วัดจากไฟล์ MP4 จริง; พากย์ดิบ normalize -18 LUFS ก่อนมิกซ์, เพลง -24 dB duck 8 dB (หัวข้อ "มิกซ์เสียง")

## เรียนสไตล์จากคลิปตัวอย่าง
ห้ามดาวน์โหลดจาก YouTube เอง ขอให้ผู้ใช้ส่งไฟล์ (อัดหน้าจอได้) แล้ว: ffmpeg contact sheet ทุก 1 วิ, `select='gt(scene,0.3)'` นับจุดตัด, ถอดเสียงด้วย ElevenLabs `scribe_v1` (ภาษาไทยได้) วัดความเร็วพูด/ความยาวบท, ดูซับ (ตำแหน่ง ขนาด กี่คำ) → เขียน `channels/<channel>/style.md` เรียนแค่รูปแบบ ไม่ลอกเนื้อหา

## ปัญหาที่เจอแล้ว (อย่าเสียเวลาซ้ำ)
| อาการ | ทางแก้ |
|---|---|
| Freesound ดาวน์โหลดไม่ได้ (403) | ใช้ sfx ใน skill `sound-effects` / HyperFrames; ห้ามพยายามเลี่ยงการบล็อก |
| raw.githubusercontent / github raw 403 | ดึงผ่าน npm (`@fontsource/*`) หรือ `npx skills add` |
| ภาษาไทยไม่ออกเสียง | `eleven_multilingual_v2` ไม่รองรับไทย ใช้ `eleven_v3`/`v4` |
| เสียงยาวเกิน | silenceremove ก่อน แล้ว atempo ≤1.12 ไม่ตัดบททิ้งโดยไม่บอก |
| skill `sound-effects` ตัด/ทับเสียงพากย์ | ใช้ `tools/sound_pass_vo.py --voice ... --duck-db ...` |
| node fetch ไม่ผ่าน proxy | ใช้ curl ในสคริปต์ |
| pubmed / pmc / plos / jamendo.com (หน้าไลเซนส์) โดนบล็อก | ยืนยันจากบทคัดย่อ/แหล่งรอง และบอกผู้ใช้; ขอเพิ่ม host เฉพาะเมื่อผู้ใช้ตกลง |
| scribe ถอดคำควบกล้ำผิด ("กร๊อบ"→"ก๊อบ") cue หาไม่เจอ | ใช้คำข้างเคียงเป็น cue หรือสะกดตามที่ถอด; ซับแก้กลับเป็นคำที่ถูก |
| footage ได้น้อยแล้วไม่มีใครบอกผู้ใช้ (palmaris: ค้นไม่กี่คำ ไม่ค้นภาพนิ่ง) | `tools/footage_search.py` ≥10 คำ/ช็อต หลายแหล่ง + `report` (ไม่ถึงครึ่ง = ALERT.md แจ้งผู้ใช้ทันที) |
| Wikimedia API 429 (retry-after 600) | **429: `footage_search.py` ลองซ้ำ 2 ครั้ง (3, 9 วิ) แล้วข้ามทั้งรอบ ห้ามรอ retry-after** ใช้ Openverse images API ตั้งแต่แรก: `https://api.openverse.org/v1/images/?q=<คำ>&license=cc0,by,by-sa,pdm` (ได้ Wikimedia/Flickr/iNaturalist พร้อม creator/license) |
| footage_search ขนาน (itch 2026-11-27: 429 ทุกแหล่ง) | **ค้นทีละคำสั่ง ห้ามขนาน**: `footage_search.py search` ล็อกไฟล์ ตัวที่สองขึ้น `WAIT` รอคิว (เกิน `FOOTAGE_LOCK_WAIT` 600 วิ exit 3); note ใน SEARCH.json บอก `BLOCKED 429 ...` ของแหล่งที่โดน |
| ภาพนิ่ง Pixabay API กว้าง ≤1280 px | editor ทำ "การ์ดภาพ" บนพื้นเบลอของภาพเดียวกัน + push-in/parallax (ได้ผลดี) ไม่ขยายเต็มจอให้แตก |
| agent ของโปรเจกต์ไม่โหลด (เซสชันเริ่มที่ /home/user ไม่ใช่ในรีโป) | ใช้ agent `general-purpose` แล้วสั่งให้อ่าน `.claude/agents/<role>.md` ก่อนเริ่ม (ระบุ model ตามตำแหน่ง) |
| `tools/music.sh` คำค้นยาวได้ 0 ผล | ใช้ 1-2 คำ (เช่น "playful", "funny") |
| scribe ถอดชื่อต่างประเทศเป็นอังกฤษ ("เตอร์กิชแวน"→"Turkish Van") | cue ใช้คำตามที่ถอดได้; ซับเขียนไทยตามบท |
| host ใหม่โดนบล็อก (`CONNECT tunnel failed 403`) | ขอเพิ่ม host ด้วย update_environment ทีละน้อยที่สุด |
| ทุกคลิปหน้าตาเดียวกัน (brainrot-v2 + เพลง/เสียง AI เดิม) ตรงตัวอย่างนโยบาย "เนื้อหาไม่แท้/แม่แบบ" ของ YouTube (2026-11-22) | `templates/brainrot-v3/` + `look.json` ต่อตอน; `tools/look.py check` (ตอนเก่าไม่มี look.json นับเป็นหน้าตา v2) |
| ใช้เพลงพื้นหลังเดิมซ้ำติดกัน | `look.json` `music_file` + `tools/look.py check --final` (อ่านเพลงตอนก่อนจาก look.json หรือ `video/index.html`) |
| คลิปแพ้ 3 วิแรก / หลุดกลางคลิป | hook พูดหัวข้อจบใน 1.5 วิ + เฉลย ~50-60% + หักมุม; เช็กด้วย `tools/pacing.py` |
| `look.py` ไม่เห็นตอนล่าสุด (ตอนอยู่ใน branch `claude/ep-*` ไม่ได้ merge) | `git fetch origin 'refs/heads/claude/ep-*:refs/remotes/origin/claude/ep-*'` ก่อนรัน (ไม่ fetch = WARN, `--final` = ERROR) |
| ข้อความปกซ้ำตอนก่อน (เข่ากร๊อบ = หักนิ้ว "กร๊อบ = ข้อเสื่อม?") | `look.json` `cover_text` + `tools/look.py check` (อ่านปกตอนเก่าจาก thumbnail.md) |
| ซับกล่องมองไม่เห็นบนโทนสว่าง (ตัวขาวบนกล่องขาว, พบโดยห้องตรวจ v3) | แก้แล้ว: ใช้ `panel_text` ต่อ palette + เทสต์ contrast ทุก palette |
| ผู้กำกับดู contact sheet 14 เฟรมแล้วปล่อย + สั่ง reviewer ไม่ติกราฟิก → ผู้ใช้: "Motion มันห่วยแตก" (palmaris) | `tools/contact_sheet.py make` (ทุก 0.25 วิ) ผู้กำกับ+reviewer ดูทุกแผ่น, `verify` ก่อนส่ง; ห้ามสั่งข้ามด้านภาพ |
| แก้ตอนเก่า (ก่อน 2026-11-26) แล้ว `look.py check --final` ERROR เรื่องเสียง | ตอนเก่าไม่มีค่าล็อก/ใช้ Liam: อัดใหม่ = ใส่ค่าล็อกแล้วอัด George; ไม่แตะเสียง = check ไม่ใส่ --final + จดเหตุผล (channel.md) |
| ปกชีพ ไม่น่ากด (CTR สูงสุด 11%), ปก 3 บรรทัดล้น/คำซ้ำ/ทับกัน (palmaris 2026-11-25) | ปกแยกจากเฟรม 0 ทำ A/B: `templates/brainrot-v3/cover.html` + `tools/cover_shot.js` + `tools/cover_check.py` (style.md 9a) |
| ภาคต่อหัวข้อเดิมไม่ปังซ้ำ (0/2) | พักไว้ (2026-11-23): ภาคต่อหัวข้อเดิมได้ ~1.2K ทั้ง 2 ครั้ง (เข่าดังกร๊อบ, ปวดอึในอวกาศ) → ทำหัวข้อใหม่แนวเดียวกันแทน |

## เครื่องมือเสริม (เพิ่ม 2026-11-19)
- ตัดความเงียบเสียงพากย์: `bash tools/trim_silence.sh in.mp3 out.mp3` ทำ **ก่อน** `tools/words.sh` เสมอ (ไม่งั้นเวลาคำเพี้ยน)
- ฉากอธิบาย (editor): ไลบรารีฝังไฟล์ใน `assets/vendor/` ดู README ในโฟลเดอร์: `rough.js` เส้นวาดมือ, `flubber` morph รูปทรง, `d3-path`+`d3-shape` กราฟ/โดนัท, `lucide/*.svg` ไอคอน (ใช้ `currentColor`) ใช้เมื่อช่วยให้เข้าใจเนื้อหา ไม่ใส่เพื่อโชว์
- ฟอนต์ไทยใช้ `assets/fonts/` เท่านั้น (Geist ไม่มีตัวไทย)

## ประหยัด token โดยไม่กระทบคุณภาพ (ตั้งค่า 2026-11-18)
**โมเดลต่อตำแหน่ง** (frontmatter ใน `.claude/agents/`): researcher, footage, voice = `sonnet` | editor, reviewer = `opus` | ผู้กำกับ = โมเดลของเซสชัน
ถ้าผู้ใช้บอกว่าข้อมูล/ภาพแย่ลง ให้เปลี่ยนตำแหน่งนั้นกลับเป็น `opus` แล้วบันทึกเหตุผลที่นี่

**caveman (ถ้าเปิดอยู่) ใช้กับข้อความแชตถึงผู้ใช้เท่านั้น** ต่อไปนี้เขียนเต็มตามปกติเสมอ ห้ามย่อ:
prompt ที่สั่ง agent ย่อย (ต้องมีกฎ style.md, ข้อห้าม, ชื่อไฟล์ครบ), บทพากย์, ซับ, ข้อความบนจอ, upload.md, research.md, review.md, lessons.md

**ลด token ที่ไม่แตะคุณภาพ:**
- ภาษาไทยอย่างเดียว (ค่าเริ่มต้น)
- คัดลอกแม่แบบโปรเจกต์ก่อนหน้า ไม่สร้าง motion จากศูนย์
- agent ตอบกลับ ≤120 คำ รายละเอียดเขียนเป็นไฟล์; ผู้กำกับไม่อ่านไฟล์ใหญ่ (words.json, ภาพ, log) เอง ให้ agent สรุป
- voice + footage รันพร้อมกัน; สั่งงานครบในครั้งเดียว ไม่ส่งงานกลับไปมา
- เรนเดอร์ใหม่เฉพาะปัญหาจริงจาก reviewer; ข้อ nice-to-have รวบไว้ทำตอนหน้า
- เซสชันละ 1 ตอน จบแล้วปิด (ประวัติแชตยาว = ทุกคำสั่งแพงขึ้น)

**ห้ามประหยัดตรงนี้:** การตรวจของ reviewer, การเช็กเฟรมของ editor, การหาแหล่งยืนยันข้อเท็จจริง

## หลังลงคลิป
อ่านสถิติตาม `.claude/skills/reality-check/content-review.md` ข้อ 3 (ห้ามสรุปจาก <3 คลิป / <48 ชม.)

เมื่อผู้ใช้ส่งภาพ Analytics: จด Stayed to watch %, ดูเฉลี่ย, ไลก์ ลง `channels/<channel>/results.md` แล้วปรับหัว `style.md` ถ้าเห็นแนวโน้มจาก ≥3 คลิป
