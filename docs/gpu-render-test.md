# ทดสอบเรนเดอร์ด้วยการ์ดจอบนคอมผู้ใช้ (RTX 3070, Windows)

ผู้ใช้ copy ข้อความในกรอบด้านล่างไปวางในแอป Claude (Claude Code) บนคอม ที่เปิดโฟลเดอร์ AI-Studio ไว้

```
ช่วยทดสอบว่าการ์ดจอ RTX 3070 ของเครื่องนี้ช่วยเรนเดอร์คลิปได้เร็วขึ้นแค่ไหน ทำทีละขั้น และอธิบายผมเป็นภาษาไทยง่ายๆ ไม่ใช้ศัพท์เทคนิค

ข้อห้าม: ห้าม push อะไรขึ้น GitHub, ห้ามแก้ไฟล์ใน repo ถาวร (ถ้าต้องแก้ ให้คัดลอกไปไว้ไฟล์ใหม่ชื่อ render-gpu.js ในโฟลเดอร์เดียวกัน), ห้ามใส่ API key ใดๆ

1. เช็กว่ามี git, Node.js (18 ขึ้นไป), ffmpeg ไหม ถ้าไม่มีให้บอกผมว่าต้องลงอะไร และลงให้ถ้าผมอนุญาต (winget ได้)
2. ถ้าโฟลเดอร์นี้ยังไม่ใช่ repo ให้ clone https://github.com/Peerapol147/AI-Studio มาไว้ที่นี่ จากนั้น git fetch origin แล้ว checkout branch claude/ep-2026-11-20-road-hug-anime
3. เข้าโฟลเดอร์ projects/2026-11-20-knowledge-road-hug-anime/anime แล้วรัน npm i และ npm i playwright แล้ว npx playwright install chromium
4. อ่าน README.md กับ render.js ในโฟลเดอร์นั้นก่อน render.js ตอนนี้บังคับใช้การ์ดจอจำลอง (swiftshader) เพราะเครื่องคลาวด์ไม่มีการ์ดจอ
5. รอบ A (ไม่ใช้การ์ดจอ): รัน node render.js video testA.mp4 24 0 5 แล้วจับเวลา
6. สร้าง render-gpu.js (คัดลอกจาก render.js) เปลี่ยนเฉพาะ args ของ chromium.launch ให้ใช้การ์ดจอจริงบน Windows เช่น ['--use-angle=d3d11', '--enable-gpu', '--ignore-gpu-blocklist', '--enable-unsafe-webgpu'] และถ้า headless ไม่ยอมใช้การ์ดจอ ให้ลอง headless: false หรือ channel: 'chrome' ยืนยันว่าใช้การ์ดจอจริงโดยเปิด chrome://gpu หรือเช็ก WebGL renderer ในหน้าเว็บ (ต้องเห็น NVIDIA ไม่ใช่ SwiftShader)
7. ถ้ายังไม่เห็น NVIDIA: บอกผมให้ไปที่ Windows Settings > System > Display > Graphics เพิ่มไฟล์ chrome.exe ของ Playwright (บอก path ให้ผม) แล้วตั้งเป็น High performance (NVIDIA)
8. รอบ B (ใช้การ์ดจอ): รัน node render-gpu.js video testB.mp4 24 0 5 แล้วจับเวลา
9. ดึงภาพจาก testA กับ testB ที่วินาทีที่ 2 มาเทียบกันว่าภาพเหมือนกัน (ไม่เพี้ยน ไม่ดำ)
10. สรุปให้ผมเป็นตาราง: รอบ A กี่วินาที, รอบ B กี่วินาที, เร็วขึ้นกี่เท่า, ภาพเหมือนกันไหม, ถ้าทำทั้งคลิป 44 วิจะใช้เวลาประมาณเท่าไร
```

ผลที่คาด: เครื่องคลาวด์ ~0.7-1 วิ/เฟรม (5 วิ = 120 เฟรม ≈ 1.5-2 นาที) — ถ้าการ์ดจอทำงานควรเร็วขึ้นหลายเท่า
บันทึกผลจริงลง `docs/strategy-notes.md` เมื่อผู้ใช้ส่งผลกลับมา
