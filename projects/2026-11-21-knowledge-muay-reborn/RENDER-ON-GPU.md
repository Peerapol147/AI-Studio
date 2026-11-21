# เรนเดอร์บนเครื่อง Windows (RTX 3070) — "ไอ้ขี้แพ้เป็นมวย" ตอนที่ 1

ได้ 2 ไฟล์: **คลิปยาว 16:9** (~4 นาที) และ **Short 9:16** (~52 วิ) เสียงพากย์+เพลง+เอฟเฟกต์มิกซ์เสร็จแล้ว (อยู่ใน branch) เครื่องนี้แค่วาดภาพ
เวลาโดยประมาณบน RTX 3070: คลิปยาว ~10-20 นาที, Short ~3-5 นาที (คลาวด์ ~17 เท่าช้ากว่า)

## 0. ต้องมี (มีแล้วจากรอบทดสอบ): Node 20+ (เครื่องมี 26), ffmpeg อยู่ใน PATH (เครื่องมี 8.1)
เช็กใน PowerShell:
```powershell
node -v
ffmpeg -version
```

## 1. ดึง branch (ไม่มี git: โหลดเป็น zip)
```powershell
cd C:\Users\PC\AI-Studio\src
Invoke-WebRequest -Uri "https://github.com/peerapol147/ai-studio/archive/refs/heads/claude/ep-2026-11-21-muay-reborn.zip" -OutFile muay-reborn.zip
Expand-Archive muay-reborn.zip -DestinationPath . -Force
cd .\ai-studio-claude-ep-2026-11-21-muay-reborn\projects\2026-11-21-knowledge-muay-reborn\anime
```
(ถ้ามี git: `git fetch origin claude/ep-2026-11-21-muay-reborn` แล้ว `git checkout claude/ep-2026-11-21-muay-reborn` แล้ว `cd projects\2026-11-21-knowledge-muay-reborn\anime`)

## 2. ติดตั้ง (ครั้งแรกครั้งเดียว ในโฟลเดอร์ anime)
```powershell
npm install
npx playwright install chromium
```

## 3. ทดสอบเร็ว 1 ท่อน (ท่อน 1 = cold open ~18 วิ) ดูว่าการ์ดจอทำงาน
```powershell
node render-gpu.js long 1
```
ควรขึ้น `frame 0/430 ...` เร็ว (~0.1 วิ/เฟรม) ไฟล์ออกที่ `..\renders\parts\long-p01.mp4`
ถ้าช้าเท่าคลาวด์ (~2 วิ/เฟรม) = ไม่ได้ใช้การ์ดจอ → บอกห้องวางแผน (ห้ามรันเต็มต่อ)

## 4. เรนเดอร์เต็ม
```powershell
node render-gpu.js long
node render-gpu.js short
```
- ทำทีละท่อน ท่อนที่เสร็จแล้วจะข้าม (ล้มกลางทาง = รันคำสั่งเดิมซ้ำได้เลย)
- อยากเรนเดอร์ท่อนเดียวใหม่: ลบ `..\renders\parts\long-pNN.mp4` แล้วรันใหม่ หรือ `node render-gpu.js long 8`

## 5. ไฟล์ผลลัพธ์
| ไฟล์ | คืออะไร |
|---|---|
| `projects\2026-11-21-knowledge-muay-reborn\renders\muay-reborn-long.mp4` | คลิปยาว 1920x1080 พร้อมเสียง → YouTube |
| `projects\2026-11-21-knowledge-muay-reborn\renders\muay-reborn-short.mp4` | Short 1080x1920 พร้อมเสียง → Shorts/TikTok/Reels |
| `renders\parts\*.mp4` | ท่อนย่อย (ไม่มีเสียง) ลบได้หลังได้ไฟล์ด้านบน |

ชื่อคลิป/คำอธิบาย/เครดิตเพลง: `upload.md` (อย่าลืมเครดิตเพลง CC BY ในคำอธิบาย)

## ถ้ามีปัญหา
| อาการ | ทำอะไร |
|---|---|
| `Cannot find module 'playwright'` | ยังไม่ได้ `npm install` ในโฟลเดอร์ anime |
| `Executable doesn't exist` | `npx playwright install chromium` |
| `'ffmpeg' is not recognized` | ffmpeg ไม่อยู่ใน PATH — เปิด PowerShell ใหม่หลังติดตั้ง |
| ภาพดำ/ว่าง | ส่งภาพหน้าจอ + ข้อความ error ให้ห้องวางแผน |
