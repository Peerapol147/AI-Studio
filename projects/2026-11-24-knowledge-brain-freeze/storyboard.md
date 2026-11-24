# Storyboard: brain-freeze (v3, look: sunrise-coral / sarabun / pop / midstory+stack / slide)
ช็อตละแถวตาม `shots.json` (cue = คำที่ตัดเข้า, เวลาจริงจาก `tools/shot_times.py`) ซับ 1-3 คำ ไฮไลต์คำสำคัญ

| # | id | beat | คำที่ตัดเข้า | ภาพ | motion | เสียง |
|---|---|---|---|---|---|---|
| 1 | hook | hook | ไอติม | footage: คนกัดไอติมแล้วกุมหน้าผาก (ช่วงหน้าเหยเก = เฟรม 0) + หัวข้อ "ไอติมทำ *สมองแข็ง* จริงหรอ?" | push เร็ว + ส่าย (แม่แบบ) | เพลงเข้า, sfx frost/crack เบาๆ |
| 2 | freeze | hook | แข็ง | graphic: สมอง (path SVG) มีเกล็ดน้ำแข็งลามคลุม สีฟ้า | spring morph สี accent→ฟ้า | sfx ice crack |
| 3 | eatfast | setup | กินเร็ว | footage: กินไอติมคำโต | ค้างภาพ push ช้า | - |
| 4 | ouch | setup | จี๊ด | footage: คนกุมหน้าผาก + กราฟิกจี๊ดแดงที่หน้าผาก | ค้างภาพ | sfx zap |
| 5 | truth | reveal | ความจริง | graphic: สมองตัวเดิม น้ำแข็งแตกร่วงหมด ป้าย "ไม่ได้แข็ง" | morph กลับสีปกติ (สลาย) | sfx shatter/pop |
| 6 | nopain | reveal | ตัวสมอง | graphic: สมองเดิม + ป้าย "สมองไม่มีตัวรับความเจ็บ" ไอคอน ⚡ ขีดฆ่า→เปลี่ยนเป็นวงเทา | ค้าง | - |
| 7 | palate | explain | เพดานปาก | graphic: หัวด้านข้าง (outline เส้นเดียว) สมองตัวเดิมย่อเข้าไปในหัว เพดานปากเรืองฟ้า + ไอติมแตะ | กล้องซูมที่ปาก | sfx whoosh เย็น |
| 8 | nerve | explain | เส้นประสาท | graphic: เส้นประสาทสว่างวิ่งจากเพดานปากขึ้นหน้าผาก (พัลส์ 2 รอบ) | กล้องแพนขึ้นตามพัลส์ | sfx tick ต่อพัลส์ |
| 9 | confused | explain | งง | graphic: หน้าผากแดงกระพริบ "จี๊ด!" + "?" เด้งบนสมอง | ค้าง | sfx boing เบา |
| 10 | study | twist | งานวิจัย | graphic: 2 ไอคอน "กินเร็ว" (ไอติม+เส้นความเร็ว) vs "กินช้า" (เต่า) ฝั่งเร็วมีจี๊ดแดงใหญ่กว่า ไม่มีตัวเลข | ตัดเร็ว | sfx whoosh |
| 11 | gulp | twist | เสี่ยง | footage: กินของเย็นรวดเร็ว | ตัดเร็ว | - |
| 12 | tongue | share | ลิ้น | graphic: หัวด้านข้างเดิม ลิ้นยกดันเพดานปาก สีฟ้า→ส้ม | morph | sfx pop |
| 13 | doctor | share | หาหมอ | graphic การ์ด "ปวดบ่อย/ปวดแรง → หาหมอ" ไอคอน stethoscope (lucide) | เด้ง | - |
| 14 | ask | cta | กี่วิ | graphic: นาฬิกาจับเวลาวิ่ง 1..2..3 + ไอคอน message-circle | ตัวเลขเด้ง | sfx tick |
| 15 | loop | loop | เม้น | plate ของ hook จบที่เฟรม 0 | แม่แบบทำให้ | - |
หมายเหตุ: graphic ใช้ `var(--accent)` ฯลฯ ตาม look; "สมอง" เป็นรูปร่างเดียว morph ต่อเนื่องช็อต 2→5→6→7 (มาตรฐาน motion)
