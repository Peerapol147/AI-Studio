---
name: make-clip
description: Use when the user asks for a new clip or episode ("ทำคลิป", "ทำตอนใหม่", "make a short", "ทำคลิปยาว") for the knowledge or football channel, in Thai and/or English, short (Shorts/TikTok 9:16) or long (YouTube 16:9), or asks to redo, fix or re-render an existing clip in projects/.
---

# Make a clip (AI Studio)

ผู้กำกับ (คุณ) คุมสายพานทั้งหมด ผู้ใช้ได้แค่ไฟล์ MP4 + ปก + ข้อความอัปโหลด แล้วอัปโหลดเอง **ห้ามอัปโหลด/ตั้งเวลาโพสต์**
1 เซสชัน = 1 ตอน (`docs/sessions.md`) **แม่แบบตัดต่อหลัก: `templates/brainrot-v2/`** (ดูหัวข้อ "หัวข้อจากเทรนด์ต่างประเทศ")
`projects/2026-11-17-knowledge-nature/` (วอมแบต) เหลือเป็นตัวอย่างโครงไฟล์เอกสาร (brief/research/upload) เท่านั้น ห้ามคัดลอก `video/` ของวอมแบตมาตัดต่อ

## 0. เริ่มตอน
- อ่าน `channels/<channel>/channel.md` + `style.md` (ถ้ามี) เสมอ ช่องฟุตบอลยังไม่มี style.md: ขอคลิปตัวอย่างจากผู้ใช้ก่อน (ดูข้อ "เรียนสไตล์")
- branch `claude/ep-<YYYY-MM-DD>-<slug>` แตกจาก `main` (ถ้ายังไม่มี `main` ให้แตกจาก `claude/stoic-cray-6z2ajs`) โฟลเดอร์ `projects/<YYYY-MM-DD>-<channel>-<slug>/`
- หัวข้อที่ผู้ใช้ระบุมาแล้ว → ข้ามขั้น 1 ไปขั้น 2 เลย
- ติดตั้งครั้งเดียวต่อเครื่อง (เครื่องคลาวด์ใหม่ไม่มี): `pip install --user librosa soundfile scipy matplotlib` (ต้องใช้กับ `tools/sound_pass_vo.py`)
- อ่าน `channels/<channel>/results.md` (ผลวิวจริง) ก่อนเลือกหัวข้อ ทิศทางล่าสุดอยู่หัว `style.md` และชนะกฎเก่าในไฟล์เดียวกัน
- ค่าเริ่มต้น: short ความยาวตามเนื้อหา ≤40 วิ เน้นคุณภาพ (ช่องความรู้ ดูทิศทาง 2026-11-19 ใน style.md), **ภาษาไทยอย่างเดียว** (ผู้ใช้สั่งเลิกทำอังกฤษ 2026-11-18) ทำอังกฤษเฉพาะเมื่อผู้ใช้สั่งชัดๆ ในตอนนั้น
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
**แม่แบบตัดต่อหลัก (ผู้ใช้อนุมัติ 2026-11-19 "ตัดต่อดีมาก โคตรชอบ"): Brainrot v2** = branch `claude/ep-2026-11-19-brainrot` commit `7b088c8`
คัดลอก **`templates/brainrot-v2/`** (อยู่ใน branch หลักแล้ว ไม่ต้อง fetch) ไปเป็น `<project>/video/` แล้วแก้ (ต้นฉบับ: commit `7b088c8` ใน branch ตอน brainrot)
คงไว้: จังหวะช็อต ~1.4 วิ, ทรานซิชัน, kinetic type, กราฟิก vendor, เสียงพากย์พาวนกลับ hook; เปลี่ยน: ภาพ เนื้อหา สี/ไอคอนตามหัวข้อ
ห้ามใช้ v3 (`4044191`) เป็นแม่แบบตัดต่อ (บท v3 ดี แต่ตัดต่อ v2 ดีกว่า)
แม่แบบเก่า (ใช้เมื่อหัวข้อเป็นแผนภาพกลไก 2D): `projects/2026-11-18-knowledge-knuckle-crack/` (branch `claude/ep-2026-11-18-knuckle-crack`)
`git fetch origin <branch> && git archive FETCH_HEAD <path> | tar -x`

## ล้มเร็ว ห้ามรอเงียบ (กฎตายตัว ผู้ใช้สั่ง หลังตอนแมวเสีย ~44 นาที)
- ดึงเว็บ/API ทุกครั้งผ่าน `bash tools/get.sh <url> [out|-] [curl options]` (หมดเวลา 20 วิ, 429/403/5xx/หมดเวลา = exit 75, 4xx อื่น = exit 1; ล้มแล้วไม่ทับไฟล์เดิม) สคริปต์ tts/words/footage/music เรียกผ่านตัวนี้อยู่แล้ว
- เจอ 429 / rate limit / retry-after / บล็อก **ครั้งเดียว = เลิกแหล่งนั้นทันที** ห้าม `sleep` ห้ามรอ retry-after ห้ามลองซ้ำ
- ลำดับสำรอง: Pixabay → Openverse → NASA → ทำเป็น motion graphic
- งานส่วนไหนติดเกิน 5 นาที: หยุด เขียนสถานะลงไฟล์ แล้วตอบกลับผู้กำกับทันที (ติดอะไร ลองอะไรแล้ว เหลืออะไร) อย่าเงียบ
- **ผู้กำกับ:** agent ที่รันเบื้องหลังเกิน 15 นาทีโดยไม่มีข่าว ให้ส่งข้อความถามสถานะ (SendMessage) หรือหยุดแล้วสั่งใหม่ และ**บอกผู้ใช้ทันที**ว่าติดอะไร ห้ามรอเงียบ
- สั่ง agent ทุกครั้งต้องมีบรรทัด: "เจอ rate limit/บล็อก = เปลี่ยนแหล่งทันที ติดเกิน 5 นาที = ตอบกลับ"

## 1-7. สายพาน (ใครทำ → ไฟล์ที่ได้)
**บทพูด: อ่าน style.md หัวข้อ "บทพูดแบบที่ผู้ใช้ต้องการ" ก่อนเขียนทุกครั้ง** (ภาษาพูดเต็มประโยค อธิบายศัพท์ทันที ความเข้าใจมาก่อนความยาว ห้ามตัดคำเชื่อมเพื่อให้สั้น)

| ขั้น | ใคร | ผลลัพธ์ | สิ่งที่ต้องสั่งให้ชัด |
|---|---|---|---|
| 1 หัวข้อ | `researcher` | `research-topics.md` (5 หัวข้อ จัดอันดับ) | ห้ามหัวข้อเกร่อ/ซ้ำกับ `projects/*/brief.md`; หลังได้ผล **ผู้กำกับเช็ก footage เอง** (เรียก API เล็กๆ ไม่ใช่อ่านไฟล์ใหญ่) ด้วย Pixabay API (`totalHits` + ดู `tags` ว่าตรงจริง ไม่ใช่ fuzzy match; ข้ามคลิป tag "generated") |
| 2 brief + research | ผู้กำกับ | `brief.md`, `research.md` | ข้อเท็จจริงทุกข้อมีแหล่ง; สิ่งที่เป็นแค่สมมติฐาน ห้ามพูดเป็นความจริง (ใช้เป็นคำถามปิดท้ายแทนได้) |
| 3 บท + สตอรีบอร์ด | ผู้กำกับ + skill `yt-hook-scripter`, `yt-thumbnail-brief` | `script.md`, `script-en.md`, `storyboard.md`, `shots.json`, `thumbnail.md` (ภาพเด่น + ข้อความ ≤4 คำ ต่อภาษา) | ไทย: ความยาวตาม style.md (≤40 วิ ≈ ≤500 ตัวอักษร ที่ ~12-13 ตัว/วิ); hook 3 แบบ เลือก 1 ตาม style.md (คำถามบนจอตั้งแต่ 0.0 วิ); อังกฤษ **เขียนใหม่** ไม่แปล; โครง hook → คนคิดว่า → "แต่ความจริงคือ" → กลไก → ปิดตลก → **คำถามชวนคอมเมนต์ ≤4 วิ** |
| 4a เสียง | `voice` (ไทย) | `assets/audio/vo-<lang>.mp3`, `words*.json`, `timing*.md`, เพลง, sfx | บอกชื่อไฟล์ที่แต่ละตัวห้ามแตะ; ไทยต้อง `eleven_v3`+; ใช้ voice_id จาก channel.md; เพลง: `tools/music.sh music "<อารมณ์>" <project> 3 30` เลือก 1 (เครดิตลง CREDITS.md อัตโนมัติ); sfx ไม่ต้องทำในขั้นนี้ (editor เลือกจาก skill `sound-effects`); อัดทั้งบทเทคเดียว แล้ว silenceremove + atempo ≤1.12; จับเวลาคำด้วย ElevenLabs `scribe_v1` |
| 4b footage | `footage` (พร้อม 4a) | `assets/footage/` + `MAP.md`, `CREDITS.md` | ขนาด medium ไม่เอาไฟล์ใหญ่; Wikimedia โดน rate-limit ง่าย ขอทีละน้อย; หาไม่ได้ = ทำเป็นกราฟิก; หัวข้อร่างกาย/ใกล้ตัว Pixabay มักไม่มีภาพเฉพาะ เช็ก Wikimedia Commons ตั้งแต่ขั้น 1; วิดีโอใช้ 1080p ขึ้นไป (ครอป 9:16 จาก 720p เหลือ ~405px แตก) |
| 5 motion + ตัดต่อ (ก่อนเริ่ม: **ผู้กำกับเลือกช่วง hook เอง** จาก contact sheet ของคลิปเต็ม แล้วใส่ `media_start` ใน shots.json — เคยต้องเรนเดอร์ใหม่ทั้งคลิปเพราะเฟรม 0 เห็นแต่หัวลูกแมวมุดแก้ว) | `editor` (หลัง 4a เสร็จ) — เริ่มจาก**คัดลอก** `templates/brainrot-v2/` (Brainrot v2) ไปเป็น `<project>/video/` มาแก้ ไม่สร้างจากศูนย์; หัวข้อที่เป็นแผนภาพกลไก 2D ใช้ knuckle-crack แทน (ดูหัวข้อด้านบน) | `video/index.html.tpl` + `build_index.py` (คอมโพสิชันเดียว; `python3 build_index.py` หา repo root เอง, `--audio`/`--out` ถ้าวางไว้ที่อื่น), `renders/<slug>-<lang>.mp4`, ปก `-thumb.jpg` | ให้อ่าน skill `hyperframes`, `motion-broll`, `sound-effects` + style.md "Motion v2"; มิกซ์ด้วย `tools/sound_pass_vo.py` (ดูหัวข้อ "มิกซ์เสียง") ปกทำจากคอมโพสิชัน `video/thumb/` ที่มากับแม่แบบ |
| 6 ตรวจ | `reviewer` | `review.md` (ต้องมีหัวข้อ "ฟังก่อนอัปโหลด") | ทุกครั้ง: ให้ส่ง**รายการ timestamp เสียงที่ผู้ใช้ต้องฟังจริง** 3-7 จุด (เริ่มจาก "Check these 5 with headphones" ใน `renders/sound-<lang>/SOUND.md` + คำอ่านยาก/ชื่อเฉพาะ/ตัวเลขในพากย์ + จุดเพลงดังชนพากย์) พร้อมเหตุผลสั้นๆ ต่อจุด |
| 7 ส่งมอบ | ผู้กำกับ + `yt-title-optimizer`, `yt-description-writer` | `upload.md`, `upload-en.md` | ความยาวคลิปจริง, ส่งรายการ "ฟังก่อนอัปโหลด" จาก review.md ให้ผู้ใช้ทุกครั้ง, ห้ามชื่อคลิปที่อ้างเกิน research ("ตัวเดียวในโลก"), เครดิตเพลง CC BY + ภาพ (ภาพ CC BY ที่ครอป/ปรับสี เขียนว่า "ครอปและปรับสี"), TikTok: แคปชันสั้น + เครดิตเพลงในคอมเมนต์แรก + ติด label AI; **FB Reels: ชื่อ/แคปชัน/แฮชแท็กแยกอีกหัวข้อ** (MP4 ไฟล์เดียวกันทุกแพลตฟอร์ม ผู้ใช้อัปเอง) |

ส่งไฟล์ให้ผู้ใช้ด้วย SendUserFile (mp4 + ปก) แล้วบอก: สิ่งที่ผ่าน, สิ่งที่ยอมรับไว้, **และว่าไม่มีใครฟังเสียงจริง** พร้อมรายการ timestamp "ฟังก่อนอัปโหลด" จาก review.md (เวลา + ต้องฟังอะไร) ให้ผู้ใช้ฟังก่อนอัปโหลด
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
cues: list ของ `{"t": วินาที, "type": "appear|scene_cut|...", "desc": "...", "sfx": "kit/pop.ogg", "gain": -8}` (ไฟล์ sfx อ้างจาก `.claude/skills/sound-effects/sfx/`) ตัวอย่าง: `templates/brainrot-v2/sound/cues-th.json` (สร้างด้วย `sound/make_cues.py`)

## มาตรฐาน motion (ผู้ใช้เคยบอกว่า "แปลกๆ" กับเวอร์ชันแรก)
- กราฟิกเป็น **รูปร่างเดียวที่ morph ต่อเนื่อง** (ขนาด มุม สี) ด้วย spring ไม่โผล่/หายกระตุก ไม่ใช้ "ขีดฆ่าแล้วใส่ไอคอนใหม่"
- ทุกการเปลี่ยนลงตรงคำพูด; ภาพนิ่งมี Ken Burns ช้าๆ
- ฉากแผนภาพ: แผนภาพอยู่บน ~60% ของจอ, ซับใต้แผนภาพ, ส่วนล่างไม่ว่าง (เช่น แถบขั้นตอน)
- ซับ 1-3 คำ (อังกฤษ 1-4) **ทุกก้อน ≥0.4 วิ**, ขาวขอบดำ, ~60-62% ความสูง, Kanit 700 จาก `assets/fonts/`, ข้อความต้องตรงเสียงที่อ่านจริง (ดูจาก words.json ไม่ใช่บท)
- เสียง: -16 LUFS, true peak < -4 dBFS วัดจากไฟล์ MP4 จริง

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
| Wikimedia API 429 (retry-after 600) | **429 ครั้งเดียว = ข้ามทันที ห้ามรอ** ใช้ Openverse images API ตั้งแต่แรก: `https://api.openverse.org/v1/images/?q=<คำ>&license=cc0,by,by-sa,pdm` (ได้ Wikimedia/Flickr/iNaturalist พร้อม creator/license) |
| ภาพนิ่ง Pixabay API กว้าง ≤1280 px | editor ทำ "การ์ดภาพ" บนพื้นเบลอของภาพเดียวกัน + push-in/parallax (ได้ผลดี) ไม่ขยายเต็มจอให้แตก |
| agent ของโปรเจกต์ไม่โหลด (เซสชันเริ่มที่ /home/user ไม่ใช่ในรีโป) | ใช้ agent `general-purpose` แล้วสั่งให้อ่าน `.claude/agents/<role>.md` ก่อนเริ่ม (ระบุ model ตามตำแหน่ง) |
| `tools/music.sh` คำค้นยาวได้ 0 ผล | ใช้ 1-2 คำ (เช่น "playful", "funny") |
| scribe ถอดชื่อต่างประเทศเป็นอังกฤษ ("เตอร์กิชแวน"→"Turkish Van") | cue ใช้คำตามที่ถอดได้; ซับเขียนไทยตามบท |
| host ใหม่โดนบล็อก (`CONNECT tunnel failed 403`) | ขอเพิ่ม host ด้วย update_environment ทีละน้อยที่สุด |

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
