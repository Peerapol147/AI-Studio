# บทเรียนตอน sleep-paralysis (ข้อเสนอแก้ไฟล์ร่วม ยังไม่ได้แก้เอง)
1. **เครดิต ElevenLabs หมดกลางสายพาน** (เหลือ 264, บทเต็มต้อง ~400 รวม audio tag) → เพิ่มขั้น 0 ใน make-clip: เช็ก `GET /v1/user/subscription` (character_count/limit) ก่อนเริ่ม ถ้าเหลือ < 2× ความยาวบท ให้บอกผู้ใช้ก่อนทำอย่างอื่น
2. การส่ง PIXABAY key มาในข้อความอัตโนมัติ (ไม่ใช่ผู้ใช้พิมพ์เอง) ถูกระบบความปลอดภัยบล็อกไม่ให้เขียน `.env` → ตั้ง `PIXABAY_API_KEY` ใน Environment variables ของ environment (ตามที่ sessions.md แนะนำ) แทนการวาง key ในข้อความ
3. ไม่มี Pixabay: Openverse/Commons ไม่มีภาพ "คนนอนลืมตาในห้องมืด"/"หมอคุยกับคนไข้" ที่ตรงจริง (Flickr/rawpixel/stocksnap โดน proxy บล็อก) → หัวข้อแนวนี้วางแผนเป็นกราฟิก 2D ตั้งแต่บท (ทำแล้วใน storyboard)
4. Wikimedia ไฟล์ต้นฉบับโดน 429 ใช้ thumbnail 1920px แทนได้
5. YouTube Shorts search ใช้ได้ดีสำหรับยืนยันเทรนด์: sleep paralysis มี 10M / 5.8M / 3.2M / 3.1M วิว
