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
- ค่าเริ่มต้นถ้าผู้ใช้ไม่บอก: short 20-30 วิ, ไทย+อังกฤษ (ผู้ใช้ต้องการ final 2 ภาษาเสมอ)
- เช็ก `PIXABAY_API_KEY` (env หรือ `.env`) ถ้าไม่มี บอกผู้ใช้ให้ตั้งใน Environment variables ก่อนขั้น footage

## 1-7. สายพาน (ใครทำ → ไฟล์ที่ได้)

| ขั้น | ใคร | ผลลัพธ์ | สิ่งที่ต้องสั่งให้ชัด |
|---|---|---|---|
| 1 หัวข้อ | `researcher` | `research-topics.md` (5 หัวข้อ จัดอันดับ) | ห้ามหัวข้อเกร่อ/ซ้ำกับ `projects/*/brief.md`; หลังได้ผล **ผู้กำกับเช็ก footage เอง** (เรียก API เล็กๆ ไม่ใช่อ่านไฟล์ใหญ่) ด้วย Pixabay API (`totalHits` + ดู `tags` ว่าตรงจริง ไม่ใช่ fuzzy match; ข้ามคลิป tag "generated") |
| 2 brief + research | ผู้กำกับ | `brief.md`, `research.md` | ข้อเท็จจริงทุกข้อมีแหล่ง; สิ่งที่เป็นแค่สมมติฐาน ห้ามพูดเป็นความจริง (ใช้เป็นคำถามปิดท้ายแทนได้) |
| 3 บท + สตอรีบอร์ด | ผู้กำกับ + skill `yt-hook-scripter`, `yt-thumbnail-brief` | `script.md`, `script-en.md`, `storyboard.md`, `thumbnail.md` (ภาพเด่น + ข้อความ ≤4 คำ ต่อภาษา) | ไทย: 380-450 ตัวอักษร (≈27 วิ); อังกฤษ **เขียนใหม่** ไม่แปล; โครง hook → คนคิดว่า → "แต่ความจริงคือ" → กลไก → ปิดตลก → **คำถามชวนคอมเมนต์ ≤4 วิ** |
| 4a เสียง | `voice` ×2 (ไทย, อังกฤษ) รันพร้อมกัน | `assets/audio/vo-<lang>.mp3`, `words*.json`, `timing*.md`, เพลง, sfx | บอกชื่อไฟล์ที่แต่ละตัวห้ามแตะ; ไทยต้อง `eleven_v3`+; ใช้ voice_id จาก channel.md; เพลง: `tools/music.sh music "<อารมณ์>" <project> 3 30` เลือก 1 (เครดิตลง CREDITS.md อัตโนมัติ); sfx ไม่ต้องทำในขั้นนี้ (editor เลือกจาก skill `sound-effects`); อัดทั้งบทเทคเดียว แล้ว silenceremove + atempo ≤1.12; จับเวลาคำด้วย ElevenLabs `scribe_v1` |
| 4b footage | `footage` (พร้อม 4a) | `assets/footage/` + `MAP.md`, `CREDITS.md` | ขนาด medium ไม่เอาไฟล์ใหญ่; Wikimedia โดน rate-limit ง่าย ขอทีละน้อย; หาไม่ได้ = ทำเป็นกราฟิก |
| 5 motion + ตัดต่อ | `editor` (หลัง 4a เสร็จทั้งสองภาษา) — เริ่มจาก**คัดลอก** `projects/2026-11-17-knowledge-nature/video/` (ยกเว้น `assets/`, `renders/`) มาแก้ ไม่สร้างจากศูนย์ | `video/index.html.tpl` + `build_index.py` (คอมโพสิชันเดียว ตัวแปร `lang`), `renders/<slug>-<lang>.mp4`, ปก `-thumb.jpg` | ให้อ่าน skill `hyperframes`, `motion-broll`, `sound-effects` + style.md "Motion v2"; มิกซ์ด้วย `tools/sound_pass_vo.py` (ดูหัวข้อ "มิกซ์เสียง") ปกทำจากคอมโพสิชัน `video/thumb/` แบบเดียวกับตอนวอมแบต |
| 6 ตรวจ | `reviewer` | `review.md` | ตรวจทั้งสองภาษาในรอบเดียว |
| 7 ส่งมอบ | ผู้กำกับ + `yt-title-optimizer`, `yt-description-writer` | `upload.md`, `upload-en.md` | ความยาวคลิปจริง, ห้ามชื่อคลิปที่อ้างเกิน research ("ตัวเดียวในโลก"), เครดิตเพลง CC BY + ภาพ, TikTok: แคปชันสั้น + เครดิตเพลงในคอมเมนต์แรก + ติด label AI |

ส่งไฟล์ให้ผู้ใช้ด้วย SendUserFile (mp4 ทั้งสองภาษา + ปก) แล้วบอก: สิ่งที่ผ่าน, สิ่งที่ยอมรับไว้, **และว่าไม่มีใครฟังเสียงจริง** ให้ผู้ใช้ฟังก่อนอัปโหลด
commit + push หลังจบแต่ละขั้น (`*.mp4` และ footage ถูก .gitignore ไว้แล้ว)

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
| host ใหม่โดนบล็อก (`CONNECT tunnel failed 403`) | ขอเพิ่ม host ด้วย update_environment ทีละน้อยที่สุด |

## ประหยัด token
agent ทุกตัว: สั่งให้ตอบ ≤120 คำ, ส่งรายละเอียดเป็นไฟล์; ผู้กำกับไม่อ่านไฟล์ใหญ่เอง; รัน voice + footage พร้อมกัน; เรนเดอร์ใหม่เฉพาะปัญหาจริงจาก reviewer (กฎสไตล์ที่ผู้กำกับตั้งเองปรับได้ ถ้าผลดีอยู่แล้ว บอกผู้ใช้)
