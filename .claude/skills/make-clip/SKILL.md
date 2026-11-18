---
name: make-clip
description: Use when the user asks for a new clip or episode ("ทำคลิป", "ทำตอนใหม่", "make a short", "ทำคลิปยาว") for the knowledge or football channel, in Thai and/or English, short (Shorts/TikTok 9:16) or long (YouTube 16:9), or asks to redo, fix or re-render an existing clip in projects/.
---

# Make a clip (AI Studio)

ผู้กำกับ (คุณ) คุมสายพานทั้งหมด ผู้ใช้ได้แค่ไฟล์ MP4 + ปก + ข้อความอัปโหลด แล้วอัปโหลดเอง **ห้ามอัปโหลด/ตั้งเวลาโพสต์**
1 เซสชัน = 1 ตอน (`docs/sessions.md`) ตอนตัวอย่างที่ผ่านแล้ว: `projects/2026-11-17-knowledge-nature/` (วอมแบต) ใช้เป็นมาตรฐานคุณภาพและแม่แบบไฟล์

## 0. เริ่มตอน
- อ่าน `channels/<channel>/channel.md` + `style.md` (ถ้ามี) เสมอ ช่องฟุตบอลยังไม่มี style.md: ขอคลิปตัวอย่างจากผู้ใช้ก่อน (ดูข้อ "เรียนสไตล์")
- branch `claude/ep-<YYYY-MM-DD>-<slug>` แตกจาก `main` (ถ้ายังไม่มี `main` ให้แตกจาก `claude/stoic-cray-6z2ajs`) โฟลเดอร์ `projects/<YYYY-MM-DD>-<channel>-<slug>/`
- หัวข้อที่ผู้ใช้ระบุมาแล้ว → ข้ามขั้น 1 ไปขั้น 2 เลย
- ติดตั้งครั้งเดียวต่อเครื่อง (เครื่องคลาวด์ใหม่ไม่มี): `pip install --user librosa soundfile scipy matplotlib` (ต้องใช้กับ `tools/sound_pass_vo.py`)
- อ่าน `channels/<channel>/results.md` (ผลวิวจริง) ก่อนเลือกหัวข้อ ทิศทางล่าสุดอยู่หัว `style.md` และชนะกฎเก่าในไฟล์เดียวกัน
- ค่าเริ่มต้น: short 15-20 วิ (ช่องความรู้), **ภาษาไทยอย่างเดียว** (ผู้ใช้สั่งเลิกทำอังกฤษ 2026-11-18) ทำอังกฤษเฉพาะเมื่อผู้ใช้สั่งชัดๆ ในตอนนั้น
  ไม่ทำ: `script-en.md`, `vo-en`, `words-en`, `render -en`, ปก -en, `upload-en.md`; ส่วนอื่นในไฟล์นี้ที่พูดถึง en/สองภาษาให้ข้าม
- เช็ก `PIXABAY_API_KEY` (env หรือ `.env`) ถ้าไม่มี บอกผู้ใช้ให้ตั้งใน Environment variables ก่อนขั้น footage

## หัวข้อจากเทรนด์ต่างประเทศ (สไตล์ที่ผู้ใช้ชอบ: ตอน knuckle-crack)
เมื่อผู้ใช้สั่ง "หัวข้อดังจากต่างประเทศ" หรือ "แบบตอนหักนิ้ว": ผู้กำกับหาเอง (researcher ไม่มี Bash)
```bash
curl -s "https://www.youtube.com/results?search_query=why+do+we+<คำ>&sp=EgIYAQ%253D%253D" | grep -oE '"accessibilityText":"[^"]{0,160}views[^"]*"' | head -20
```
(ค้นหาแบบ Shorts อ่านแค่ยอดวิว ห้ามดาวน์โหลดคลิป) เลือกหัวข้อที่มีคลิปหลายตัวหลายล้านวิว + เป็นเรื่องร่างกาย/ชีวิตประจำวัน
มุมเล่า: **"ความเชื่อ vs ความจริง"** (คนเชื่อว่า... → แต่งานวิจัยบอกว่า...) ใช้แค่หัวข้อ เขียนบท/ภาพ/ชื่อเอง
ก่อนเลือก: เช็ก Pixabay **videos** totalHits ของ action หลัก ถ้า 0 ให้วางแผนเป็นภาพนิ่ง push-in + กราฟิกตั้งแต่บท
แม่แบบ: `projects/2026-11-18-knowledge-knuckle-crack/` (branch `claude/ep-2026-11-18-knuckle-crack`) ดึงมาใช้ด้วย
`git fetch origin <branch> && git archive FETCH_HEAD <path> | tar -x`

## 1-7. สายพาน (ใครทำ → ไฟล์ที่ได้)

| ขั้น | ใคร | ผลลัพธ์ | สิ่งที่ต้องสั่งให้ชัด |
|---|---|---|---|
| 1 หัวข้อ | `researcher` | `research-topics.md` (5 หัวข้อ จัดอันดับ) | ห้ามหัวข้อเกร่อ/ซ้ำกับ `projects/*/brief.md`; หลังได้ผล **ผู้กำกับเช็ก footage เอง** (เรียก API เล็กๆ ไม่ใช่อ่านไฟล์ใหญ่) ด้วย Pixabay API (`totalHits` + ดู `tags` ว่าตรงจริง ไม่ใช่ fuzzy match; ข้ามคลิป tag "generated") |
| 2 brief + research | ผู้กำกับ | `brief.md`, `research.md` | ข้อเท็จจริงทุกข้อมีแหล่ง; สิ่งที่เป็นแค่สมมติฐาน ห้ามพูดเป็นความจริง (ใช้เป็นคำถามปิดท้ายแทนได้) |
| 3 บท + สตอรีบอร์ด | ผู้กำกับ + skill `yt-hook-scripter`, `yt-thumbnail-brief` | `script.md`, `script-en.md`, `storyboard.md`, `shots.json`, `thumbnail.md` (ภาพเด่น + ข้อความ ≤4 คำ ต่อภาษา) | ไทย: 220-300 ตัวอักษร (15-20 วิ); hook ตาม style.md (คำถามบนจอตั้งแต่ 0.0 วิ); อังกฤษ **เขียนใหม่** ไม่แปล; โครง hook → คนคิดว่า → "แต่ความจริงคือ" → กลไก → ปิดตลก → **คำถามชวนคอมเมนต์ ≤4 วิ** |
| 4a เสียง | `voice` (ไทย) | `assets/audio/vo-<lang>.mp3`, `words*.json`, `timing*.md`, เพลง, sfx | บอกชื่อไฟล์ที่แต่ละตัวห้ามแตะ; ไทยต้อง `eleven_v3`+; ใช้ voice_id จาก channel.md; เพลง: `tools/music.sh music "<อารมณ์>" <project> 3 30` เลือก 1 (เครดิตลง CREDITS.md อัตโนมัติ); sfx ไม่ต้องทำในขั้นนี้ (editor เลือกจาก skill `sound-effects`); อัดทั้งบทเทคเดียว แล้ว silenceremove + atempo ≤1.12; จับเวลาคำด้วย ElevenLabs `scribe_v1` |
| 4b footage | `footage` (พร้อม 4a) | `assets/footage/` + `MAP.md`, `CREDITS.md` | ขนาด medium ไม่เอาไฟล์ใหญ่; Wikimedia โดน rate-limit ง่าย ขอทีละน้อย; หาไม่ได้ = ทำเป็นกราฟิก; หัวข้อร่างกาย/ใกล้ตัว Pixabay มักไม่มีภาพเฉพาะ เช็ก Wikimedia Commons ตั้งแต่ขั้น 1; วิดีโอใช้ 1080p ขึ้นไป (ครอป 9:16 จาก 720p เหลือ ~405px แตก) |
| 5 motion + ตัดต่อ | `editor` (หลัง 4a เสร็จ) — เริ่มจาก**คัดลอก** `projects/2026-11-17-knowledge-nature/video/` (ยกเว้น `assets/`, `renders/`) มาแก้ ไม่สร้างจากศูนย์ | `video/index.html.tpl` + `build_index.py` (คอมโพสิชันเดียว ตัวแปร `lang`), `renders/<slug>-<lang>.mp4`, ปก `-thumb.jpg` | ให้อ่าน skill `hyperframes`, `motion-broll`, `sound-effects` + style.md "Motion v2"; มิกซ์ด้วย `tools/sound_pass_vo.py` (ดูหัวข้อ "มิกซ์เสียง") ปกทำจากคอมโพสิชัน `video/thumb/` แบบเดียวกับตอนวอมแบต |
| 6 ตรวจ | `reviewer` | `review.md` | |
| 7 ส่งมอบ | ผู้กำกับ + `yt-title-optimizer`, `yt-description-writer` | `upload.md`, `upload-en.md` | ความยาวคลิปจริง, ห้ามชื่อคลิปที่อ้างเกิน research ("ตัวเดียวในโลก"), เครดิตเพลง CC BY + ภาพ (ภาพ CC BY ที่ครอป/ปรับสี เขียนว่า "ครอปและปรับสี"), TikTok: แคปชันสั้น + เครดิตเพลงในคอมเมนต์แรก + ติด label AI |

ส่งไฟล์ให้ผู้ใช้ด้วย SendUserFile (mp4 + ปก) แล้วบอก: สิ่งที่ผ่าน, สิ่งที่ยอมรับไว้, **และว่าไม่มีใครฟังเสียงจริง** ให้ผู้ใช้ฟังก่อนอัปโหลด
commit + push หลังจบแต่ละขั้น (stop hook บังคับ commit ทุกครั้งที่จบการตอบ แม้ agent ยังทำไม่เสร็จ: commit เป็น "wip: ..." ได้) (`*.mp4` และ footage ถูก .gitignore ไว้แล้ว)

## ภาพตรงคำพากย์ (บังคับตั้งแต่ ep 2)
เวลาทุกช็อตมาจากคำพูด ไม่ตั้งด้วยมือ ทำตาม `docs/pipeline.md` หัวข้อ "ภาพตรงจังหวะพากย์":
ผู้กำกับเขียน `shots.json` (ขั้น 3) → footage ใส่ `action_at`/`src` → voice ทำ words ด้วย `bash tools/words.sh` →
`python3 tools/shot_times.py <project> th|en` → editor ใช้ `assets/audio/shots-<lang>.json` เท่านั้น
- cue ห่างกันอย่างน้อย ~5-6 คำไทย / 3 คำอังกฤษ (ติดกันเกินจะได้ช็อต <0.6 วิ)
- วาง `cue` ใน shots.json **หลังได้ words.json** (หรือร่างให้ช็อตละ ~1.2 วิ ตั้งแต่แรก) ไม่งั้นช็อตยาว/สั้นเกิน
- ถ้าเขียน shots.json ใหม่ ต้องบอก footage ให้อ่านใหม่ เพราะการเขียนทับจะลบ `src`/`action_at` เดิม

## มิกซ์เสียง
```bash
python3 tools/sound_pass_vo.py --video renders/<slug>-<lang>-silent.mp4 --voice assets/audio/vo-<lang>.mp3 \
  --cues video/sound/cues-<lang>.json --music assets/audio/<music>.mp3 \
  --manifest .claude/skills/sound-effects/sfx/manifest.json --out renders/sound-<lang> \
  --music-source "<เพลง> by <ศิลปิน> <ลิงก์>" --music-license "CC BY 3.0"
```
cues: list ของ `{"t": วินาที, "type": "appear|scene_cut|...", "desc": "...", "sfx": "kit/pop.ogg", "gain": -8}` (ไฟล์ sfx อ้างจาก `.claude/skills/sound-effects/sfx/`) ตัวอย่าง: `projects/2026-11-17-knowledge-nature/video/sound/cues-th.json`

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
| host ใหม่โดนบล็อก (`CONNECT tunnel failed 403`) | ขอเพิ่ม host ด้วย update_environment ทีละน้อยที่สุด |

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
