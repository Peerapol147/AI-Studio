> ขั้นตอนละเอียดและบทเรียนล่าสุดอยู่ใน skill `make-clip` (`.claude/skills/make-clip/SKILL.md`) ถ้าขัดกัน ให้ยึด skill

# สายพานผลิตคลิป

ผู้กำกับ (ตัวคุมงานหลัก) เดินตามลำดับนี้ งานที่ไม่ขึ้นต่อกันให้สั่ง agent พร้อมกัน

| ขั้น | ใครทำ | ผลลัพธ์ใน `projects/<id>/` |
|---|---|---|
| 1. หัวข้อ + brief | ผู้กำกับ | `brief.md`: ช่อง, ภาษา, รูปแบบ short/long, มุมเล่า, คนดู, hook |
| 2. หาข้อมูล | `researcher` | `research.md`: ข้อเท็จจริงพร้อมลิงก์แหล่งที่มา |
| 3. บท + สตอรีบอร์ด + จังหวะ | ผู้กำกับ + skill `yt-hook-scripter` (hook 3 วิ short / 30 วิ long) | `script.md` (บทพากย์แยกฉาก), `storyboard.md` (ฉาก, ภาพ, **คำที่ตัดเข้า**, motion, เสียง), `shots.json` (ช็อตละ 1 แถว: คำที่ตัดเข้า + คำที่ action ลง ทั้ง th/en) |
| 4. footage และเสียง (พร้อมกัน) | `footage` + `voice` | `assets/footage/` (+ `action_at` ใน `shots.json`), `assets/CREDITS.md`, `assets/audio/` (vo + `words*.json` จาก `tools/words.sh`) |
| 5. motion + ตัดต่อ + ซับ + ภาพปก | `editor` (ภาพปกตาม `thumbnail.md` ที่ผู้กำกับเขียนด้วย skill `yt-thumbnail-brief` ตอนขั้น 3) | โปรเจกต์ HyperFrames ใน `video/`, ไฟล์ `renders/*.mp4` |
| 6. ตรวจ | `reviewer` | `review.md`: ผ่าน หรือรายการที่ต้องแก้ (วนกลับไปขั้นที่เกี่ยวข้อง สูงสุด 2 รอบ) |
| 7. ส่งมอบ | ผู้กำกับ + skills `yt-title-optimizer`, `yt-description-writer` | `upload.md` (ไทย) + `upload-en.md` (อังกฤษ) แต่ละไฟล์แยก YouTube / TikTok: ชื่อคลิป 3 ตัวเลือก (แนะนำ 1), คำอธิบายพร้อม chapter (long) และเครดิต, แฮชแท็ก; TikTok: แคปชันสั้น ≤150 ตัวอักษร + แฮชแท็ก 3-5 |

คลิปทั้งไทยและอังกฤษ: ทำบทไทยก่อน แล้วเขียนบทอังกฤษใหม่ให้เป็นธรรมชาติ (ไม่แปลตรงตัว) ใช้ภาพชุดเดิม
เรนเดอร์แยก `renders/<slug>-th.mp4` และ `renders/<slug>-en.mp4`

short กับ long จากหัวข้อเดียวกัน: ทำ long ก่อน แล้วตัด short จากช่วงที่แรงที่สุด พร้อม hook ใหม่ใน 2 วินาทีแรก

วางแผนรายสัปดาห์: สั่ง "วางแผนสัปดาห์หน้า ช่อง..." ผู้กำกับใช้ skill `yt-content-planner` (ข้ามส่วน community post ถ้าผู้ใช้ไม่ขอ) แล้วเขียน `plans/<YYYY-Www>-<channel>.md`

## ภาพตรงจังหวะพากย์ (เริ่ม ep 2 ตามที่ผู้ใช้ขอ)
ห้ามตั้งเวลาช็อตด้วยมือหรือตามความยาวฉาก ทุกช็อตผูกกับคำพูด:
1. ผู้กำกับเขียน `shots.json` ตอนขั้น 3: ช็อตละ 1 แถว `cue` = คำที่ภาพนี้ตัดเข้า (ภาพต้องแสดงสิ่งที่คำนั้นพูดถึงตรงๆ),
   `hit` = คำที่ action ในช็อตต้องลงพอดี (ยกแก้ว ล้ม หันหน้า ตัวเลขเด้ง) ไม่บังคับ
2. footage ดูคลิปจริงแล้วใส่ `action_at` (วินาทีในไฟล์ที่ action เกิด) และ `src`
3. voice ทำ `words.json` / `words-en.json` ด้วย `tools/words.sh`
4. `python3 tools/shot_times.py <project> th|en` → `assets/audio/shots-<lang>.json` (start, end, hit_at, media_start)
   ตัดก่อนคำ 0.08 วิ (2-3 เฟรม ตาเห็นว่า "ตรงคำ") และเลือกช่วงในคลิปให้ action ลงตรง `hit`
5. editor อ่าน shots-<lang>.json เท่านั้น ห้ามแก้เวลาเอง ถ้าช็อตสั้น/ยาวเกิน (tool เตือน) ให้แก้ `cue` ใน shots.json แล้วรันใหม่
6. reviewer เปิดเฟรมที่ `word_at + 0.1` ของทุกช็อต: ภาพต้องตรงกับคำ และเฟรม `hit_at` ต้องเห็น action
