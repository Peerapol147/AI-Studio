# AI Studio

ทีม AI agent สำหรับทำคลิปอัตโนมัติ สำหรับ 2 ช่อง (ความรู้ทั่วไป, ฟุตบอล) ภาษาไทยและอังกฤษ
ทั้งคลิปสั้น (YouTube Shorts / TikTok, 9:16) และคลิปยาว (YouTube, 16:9)

## ติดตั้งแล้ว
- **HyperFrames** (HeyGen, Apache-2.0): แปลง HTML + แอนิเมชันเป็น MP4 ใช้ทำ motion และตัดต่อ
  skills อยู่ใน `.claude/skills/` (ติดตั้งด้วย `npx skills add heygen-com/hyperframes --agent claude-code`)
- ต้องมี Node.js 22+ และ FFmpeg

## ของที่มีให้ใช้
- `assets/fonts/`: ฟอนต์ไทยฟรี Kanit, Prompt, Sarabun, Noto Sans Thai (OFL) + `fonts.css`
- `tools/tts.sh`, `tools/voices.sh`: เสียงพากย์ ElevenLabs
- `tools/footage.sh`: ภาพ/วิดีโอ Pixabay
- `tools/music.sh`: เพลงประกอบ CC0/CC BY

## ทีม
ผู้กำกับ · นักหาข้อมูล · ฝ่าย footage · ฝ่ายเสียง · ฝ่าย motion/ตัดต่อ · ผู้ตรวจ

## ห้าม
ห้ามใส่ API key หรือรหัสผ่านใน repo นี้

| ตำแหน่ง | ไฟล์ | หน้าที่ |
|---|---|---|
| ผู้กำกับ | `CLAUDE.md` (ตัวคุมงานหลัก) | หัวข้อ บท สตอรีบอร์ด จังหวะ คุมคิว ส่งมอบ |
| นักหาข้อมูล | `.claude/agents/researcher.md` | ข้อมูลพร้อมแหล่งที่มา |
| ฝ่าย footage | `.claude/agents/footage.md` | ภาพ/วิดีโอฟรีจาก Pixabay, Wikimedia, NASA |
| ฝ่ายเสียง | `.claude/agents/voice.md` | พากย์ (ElevenLabs), เพลงฟรี CC (Openverse/Jamendo), เสียงเอฟเฟกต์ (HyperFrames) |
| ฝ่าย motion/ตัดต่อ | `.claude/agents/editor.md` | HyperFrames, ซับ, ภาพปก, เรนเดอร์ MP4 |
| ผู้ตรวจ | `.claude/agents/reviewer.md` | ตรวจก่อนส่ง |

ขั้นตอนทั้งหมด: `docs/pipeline.md`

## วิธีสั่งงาน
เปิด Claude Code ใน repo นี้ แล้วพิมพ์ เช่น
> ทำคลิป short ช่องฟุตบอล ภาษาไทยและอังกฤษ เรื่อง "ทำไมทีมที่ครองบอลมากกว่ามักไม่ชนะ"

หรือ `ช่องความรู้ คิดหัวข้อมา 5 อัน` แล้วเลือก
