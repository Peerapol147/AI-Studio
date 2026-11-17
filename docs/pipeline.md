> ขั้นตอนละเอียดและบทเรียนล่าสุดอยู่ใน skill `make-clip` (`.claude/skills/make-clip/SKILL.md`) ถ้าขัดกัน ให้ยึด skill

# สายพานผลิตคลิป

ผู้กำกับ (ตัวคุมงานหลัก) เดินตามลำดับนี้ งานที่ไม่ขึ้นต่อกันให้สั่ง agent พร้อมกัน

| ขั้น | ใครทำ | ผลลัพธ์ใน `projects/<id>/` |
|---|---|---|
| 1. หัวข้อ + brief | ผู้กำกับ | `brief.md`: ช่อง, ภาษา, รูปแบบ short/long, มุมเล่า, คนดู, hook |
| 2. หาข้อมูล | `researcher` | `research.md`: ข้อเท็จจริงพร้อมลิงก์แหล่งที่มา |
| 3. บท + สตอรีบอร์ด + จังหวะ | ผู้กำกับ + skill `yt-hook-scripter` (hook 3 วิ short / 30 วิ long) | `script.md` (บทพากย์แยกฉาก), `storyboard.md` (ฉาก, เวลา, ภาพ, motion, เสียง) |
| 4. footage และเสียง (พร้อมกัน) | `footage` + `voice` | `assets/footage/`, `assets/CREDITS.md`, `assets/audio/` |
| 5. motion + ตัดต่อ + ซับ + ภาพปก | `editor` (ภาพปกตาม `thumbnail.md` ที่ผู้กำกับเขียนด้วย skill `yt-thumbnail-brief` ตอนขั้น 3) | โปรเจกต์ HyperFrames ใน `video/`, ไฟล์ `renders/*.mp4` |
| 6. ตรวจ | `reviewer` | `review.md`: ผ่าน หรือรายการที่ต้องแก้ (วนกลับไปขั้นที่เกี่ยวข้อง สูงสุด 2 รอบ) |
| 7. ส่งมอบ | ผู้กำกับ + skills `yt-title-optimizer`, `yt-description-writer` | `upload.md` (ไทย) + `upload-en.md` (อังกฤษ) แต่ละไฟล์แยก YouTube / TikTok: ชื่อคลิป 3 ตัวเลือก (แนะนำ 1), คำอธิบายพร้อม chapter (long) และเครดิต, แฮชแท็ก; TikTok: แคปชันสั้น ≤150 ตัวอักษร + แฮชแท็ก 3-5 |

คลิปทั้งไทยและอังกฤษ: ทำบทไทยก่อน แล้วเขียนบทอังกฤษใหม่ให้เป็นธรรมชาติ (ไม่แปลตรงตัว) ใช้ภาพชุดเดิม
เรนเดอร์แยก `renders/<slug>-th.mp4` และ `renders/<slug>-en.mp4`

short กับ long จากหัวข้อเดียวกัน: ทำ long ก่อน แล้วตัด short จากช่วงที่แรงที่สุด พร้อม hook ใหม่ใน 2 วินาทีแรก

วางแผนรายสัปดาห์: สั่ง "วางแผนสัปดาห์หน้า ช่อง..." ผู้กำกับใช้ skill `yt-content-planner` (ข้ามส่วน community post ถ้าผู้ใช้ไม่ขอ) แล้วเขียน `plans/<YYYY-Www>-<channel>.md`
