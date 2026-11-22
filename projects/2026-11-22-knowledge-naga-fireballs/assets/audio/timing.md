# Timing (th)
- vo-th.mp3: 53.29 s, ElevenLabs George eleven_v3 one take (raw 67.32 s)
- Process: trim_silence.sh (gap 0.2, -35dB) 67.32 -> 59.69 s, then atempo 1.12 -> 53.29 s (words.json ลงเวลาจาก vo-th.mp3 นี้)
- เริ่มเสียงที่ ~0.0 s; silencedetect -40dB เหลือช่วงเงียบ 3 จุด (11.04, 29.10, 41.62) ยาว 0.40 s พอดี ไม่เกินสาระสำคัญ
- ไฟล์: assets/audio/vo-th.mp3, words.json, shots-th.json, vo-th-raw.mp3 (ดิบ)

## เพลง
- assets/audio/music-jamendo-d3803fc4.mp3 "Beautiful Mystery" โดย ccMixter, 260 s, CC BY 3.0, https://www.jamendo.com/track/1230878 (เครดิตอยู่ใน CREDITS.md)
- เลือกเพราะจังหวะกระแทกน้อยสุดในสามตัว (วัดจาก energy; ไม่ได้ฟังจริง editor ควรเช็คหู) ยาวกว่าคลิป ดัก volume ใต้เสียงพากย์

## scribe ถอดต่างจากบท (ให้ซับตามบท vo-th.txt)
- "เมนต์" -> scribe "เม้น"
- ตัวอักษรไทยถูกถอดเป็นราย char ข้อความรวมตรงกับบท ยกเว้นข้างบน และไม่มีเครื่องหมายวรรค

## cue ที่แก้ใน shots.json (เฉพาะ cue.th)
- s5_orb ลูกไฟ -> อมชมพู (8.80 s)
- s8_vanish พุ่งขึ้น -> ฟ้า (16.08 s)
- t6_tracer ไม่แก้ (ทหาร 38.84)
- t7_angry ไม่พอใจ -> ในพื้นที่ (42.16 s)
- c1_ask คิดว่าไง -> พญานาค (50.36 s)
- c2_comment เมนต์ -> เม้น (52.58 s)

## WARN ที่เหลือ (ยาวเกิน 2.7 s)
- t6_tracer 3.32 s (มี hit "ยิง" 40.2 s อยู่ข้างใน), t7_angry 3.38 s ตัดแบ่งไม่ได้ถ้าไม่เพิ่มช็อต ใช้ long_ok

## คำอ่านยาก (ดูจากถอดเสียง scribe)
- ดาวดึงส์ ถอดได้ "ดาวดึงส์" ถูก, อมชมพู ถูก, ลบหลู่ ถูก, ก๊าซ ถูก, เม้น (เมนต์) ถูกเสียง
- ไม่ได้ฟังด้วยหู ใช้ถอดเสียงอย่างเดียว
