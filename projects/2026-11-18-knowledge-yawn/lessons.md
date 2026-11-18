# บทเรียนตอน yawn (ข้อเสนอแก้ไฟล์ร่วม ยังไม่ได้แก้เอง)
1. make-clip: แม่แบบ knuckle-crack อยู่คนละ branch และ editor ต้องคัดลอกจาก scratchpad → ควร merge `projects/2026-11-18-knowledge-knuckle-crack/video/` เข้า branch หลัก หรือย้ายเป็น `templates/short-explainer/`
2. กราฟิก "เปรียบเทียบเท่ากัน" (แท่งก่อน/หลัง) ต้อง morph เสร็จ *ก่อน* คำที่ hit ~0.1 วิ ไม่ใช่เริ่มตรงคำ (reviewer จับได้ว่าเฟรมตรงคำยังสื่อว่า "น้อยลง") → เพิ่มใน style.md "Motion v2": state สุดท้ายของ morph ต้องเห็นแล้วที่ word_at
3. editor ตัดซับไทยเกิน 3 คำ 3 ก้อน → ให้ build_index.py เช็ก/แตกก้อน >3 คำอัตโนมัติ (นับจาก words.json)
4. reviewer เรียกหาเครดิตฟอนต์ Kanit (OFL): ตอนก่อนไม่ได้ใส่ → เพิ่มบรรทัดฟอนต์ใน `tools/music.sh` หรือแม่แบบ CREDITS.md ให้มีทุกตอน
5. footage: Pixabay มีคลิป "คนหาว" จริงแค่ 1 คลิป (44647) ช็อตที่สองต้องใช้ช่วงหาวที่สองของคลิปเดิมกลับซ้ายขวา; สัตว์หาวมีเยอะ → หัวข้อร่างกาย: เช็กจำนวนคลิป *ที่ action จริง* (ไม่ใช่ totalHits) ตอนขั้น 1
6. เพลง: คำค้น `tools/music.sh` แบบหลายคำ ("playful curious light") ได้ 0 ผล ใช้ 1-2 คำ
7. upload*.md: เขียนร่างก่อนเรนเดอร์ด้วย placeholder แล้วเติม — ควรมี grep `DUR|SFX|TODO` เป็นขั้นบังคับใน make-clip ขั้น 7 (ตอนนี้ทำแล้ว ไม่เหลือ)
8. `.env` สร้างใหม่ในเซสชันนี้ (ไม่ commit, check-ignore ผ่าน) → ย้ำ: ตั้ง PIXABAY_API_KEY ใน Environment variables จะไม่ต้องทำซ้ำ
