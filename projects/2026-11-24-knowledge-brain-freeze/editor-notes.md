# editor notes: brain-freeze (brainrot-v3.3, 2026-11-24)

## ปัญหาแม่แบบ v3.3 (ไม่ได้แก้ `templates/`; แก้/เติมเฉพาะในสำเนา `video/`)
| # | อาการ | ทำในสำเนา | ควรแก้ในแม่แบบ |
|---|---|---|---|
| 1 | ยังไม่มีช่อง overlay ที่อยู่ "ระหว่างช็อต" (stomach-growl ข้อ 4): งานนี้ต้องให้สมองตัวเดียว morph ข้าม 8 ช็อต graphic แต่ `#g-<id>` อยู่ในแต่ละ scene แยกกัน ถ้าวาดในช่องของแต่ละช็อต ทรานซิชัน slide จะเลื่อนสมองออกแล้วสมองตัวใหม่เลื่อนเข้า (ไม่ต่อเนื่อง) | `#eg` วางใน `#scenes` ต่อท้าย `%%SCENES%%` แล้วตั้ง `z-index` = ช็อตปัจจุบัน+1 ทุกเฟรม (DOM อยู่หลัง = ทับช็อตปัจจุบัน แต่ช็อตถัดไปที่ z สูงกว่าเลื่อนมาทับได้); เข้าจาก footage = คัดลอก opacity/transform ของ scene; graphic→graphic = อยู่นิ่ง พื้นหลังเลื่อนใต้สมอง | ช่อง overlay มาตรฐานที่ผูกกับชุดช็อต (`data-shots="a,b,c"`) + helper `SH[id]`, `win()` |
| 2 | `TEMPLATE.md` ข้อ 2 ยังชี้ `prep_assets.sh` ของ v2 (stomach-growl ข้อ 7) และ `media-use resolve --type grade` ใน 0.9.61 ให้ preset (`warm-daylight`) เป็น payload `data-color-grading` ไม่ได้ให้ไฟล์ .cube | เขียน `video/prep_assets.py` เอง เกรดด้วย ffmpeg chain เดียวทุก plate (colorbalance อุ่น + eq) อ่านสี ink ของการ์ดจาก looks.json | prep_assets ใน v3 ที่อ่าน `grade` จาก look.json |
| 3 | ไม่มีตัวแปรสี "เย็น/ฟ้า" ใน palette (sunrise-coral มีแต่โทนอุ่น) | ใช้ `var(--text)` (ขาว) = น้ำแข็ง/เย็น, `var(--accent2)` = อุ่น, `var(--accent)` = จุดสนใจ/จี๊ด ผสมด้วย `color-mix()` | อาจเพิ่ม `cool` ต่อ palette ถ้าเรื่องเย็น/ร้อนเจอบ่อย |
| 4 | `hyperframes check` WARN ที่คาดไว้: `line_unread` 21 (ซับ 1-3 คำตามจังหวะพูด), `outside_safe_zone` (ซับ Y ~1190 และแถบชิป Y 1300-1410 ตามเกณฑ์ TikTok/Shorts ของ CLI ที่เข้มกว่า style.md; ทุกอย่างอยู่เหนือ Y 1536), `composition_heavy_overlay_count_high` (34 = radial-gradient ของ `.sc` + `.vig` ในแม่แบบ 17 ช็อต) | ไม่แก้ (เช็กเรนเดอร์แล้วว่าไม่มีเฟรมดำ) | `.vig` ใช้ภาพเดียวนอก scene แทน 17 ชุด |
| 5 | ช่องว่างหัวข้อ 3 บรรทัด (`ไอติมทำ / *สมองแข็ง* / จริงหรอ?`) ได้แค่ 83 px | ใช้ 2 บรรทัด `["ไอติมทำ*สมองแข็ง*","จริงหรอ?"]` ได้ 104/118 px (cover_text ตรงหลังตัดช่องว่าง, build ผ่าน) | - |

## การตัดสินใจเรื่องภาพ
- hook / loop (pixabay-481425.jpg 1280x960): การ์ดภาพครอป x 190-1090 y 40-960 กว้าง 960 ที่ Y 560-1541 บนพื้นเบลอ+มืดของภาพเดียวกัน; ตา ~Y 760 (ใต้หัวข้อที่จบ ~Y 700), ปาก+ช้อนไอติม ~Y 1020-1150 เฟรม 0 เห็นหน้า + ไอติมชัด; ช็อต loop ใช้ภาพเดียวกัน push ถอยกลับ scale 1.0 = เฟรม 0
- eatfast (334213): เด็กเดินขวาข้ามเฟรมในช่วง media_start 2.92-4.0 → ครอป 810x1440 แพนตาม x 650→1300
- ouch (44637): ครอป 810x1440 x 875, media_start 3.42 = มือแตะแก้มแล้ว
- gulp (2588541.jpg 1280x852): การ์ดครอป x 470-1280 (ไอติม+ปาก) Y 330-1340
- สมอง = 96 จุดชุดเดียว: เรียบ ↔ เหลี่ยมน้ำแข็ง (lerp จุดต่อจุด), วงหลังสมอง morph เป็นหัวด้านข้าง (resample ตามความยาวเส้น) ที่ "ตัวการ" 10.82; ไม่ใช้ flubber เพราะจุดเท่ากันอยู่แล้ว
- ทุกการเปลี่ยนตรงคำใน words.json: แข็ง 0.96, สมอง/แข็ง 4.74/5.10, ความจริง 6.14 (น้ำแข็งแตก), ไม่ได้แข็ง 7.58, ตัวสมอง 8.68, เจ็บ 9.34, ตัวการ 10.82, เพดานปาก 11.64, พอโดน/เย็น 12.82/13.10, เส้นประสาท 13.66, ส่ง/สัญญาณ 14.30/14.82, งง 15.66, เจ็บที่หน้าผาก 16.40, งานวิจัย 18.26, กินช้า 20.80, เท่าตัว 21.38, ลิ้น 23.70 (hit_at), อุ่น 24.84, ปวด(บ่อย) 25.70, แรง 26.66, หาหมอ 27.16, ปกติ 28.20, กี่วิ 28.84, นับแล้ว 29.36
- twist ไม่มีตัวเลข/×2/ชื่อวารสาร: study = ไอคอนเอกสาร+แว่นขยาย+"งานวิจัย"; slow = กินเร็ว (โคน+เส้นความเร็ว+ฟ้าผ่าใหญ่ที่ขยายตอน "เท่าตัว") vs กินช้า (เต่า+ฟ้าผ่าเล็ก)
- ask: เลข 1-2-3 บนนาฬิกาจับเวลาเป็นแค่การนับ (ไม่ใช่ข้อมูลวิจัย)
- registry: ค้น "stopwatch timer counting", "shape morph spring", "ice frost freeze overlay", "nerve signal pulse along path" ได้ count-up / spring-pop / frost (ฉากเต็มจอ) / offset-path-traveler ไม่ตรงงาน "สมองตัวเดียวข้ามช็อต" → วาดเอง
- ไอคอน lucide ใหม่ใน `assets/vendor/lucide/`: snowflake, ice-cream-cone, file-text, turtle, stethoscope (lucide-static 1.75.0 ISC จาก npm pack)
- เสียง: คลังไม่มีเสียงน้ำแข็งแตก → `ding/kenney-interface-glass-*` แทน "แข็ง", `impactsoft` แทนแตก; จี๊ด = `glitch-002`

## สถานะ
- pacing: OK (WARN reveal 20% = การทดลองที่ตั้งใจ ไม่แก้; ไม่มี WARN loop เพราะ loop ใช้ plate เดียวกับ hook)
- `npm run check`: 0 error; WARN ตามข้อ 4 (line_unread 21, safe-zone, heavy overlay) + duplicate_media (hook กับ loop ใช้ hook.jpg เดียวกันโดยตั้งใจ)
- `renders/brain-freeze-th.mp4` 30.40 วิ 1080x1920 30fps h264/aac; -16.3 LUFS, true peak -5.2 dBFS (วัดจาก MP4 ด้วย ebur128; mono -16.3)
- blackdetect: ไม่มีเฟรมดำ; ดูเฟรมทุก 5 วิ + snapshot ทุกช็อตที่ word_at+0.1 แล้ว
- ปก `renders/brain-freeze-th-thumb.jpg` = snapshot --at 0 (1080x1920, 282 KB); หัวข้อ Y ~295-700, ตา ~Y 760, ไอติม/ช้อน ~Y 1020-1150
- เฉลยจริง: "ความจริง" 6.14 วิ = 20% ของ 30.40 วิ (น้ำแข็งแตกตรงคำนี้)
- ลูป: 2 วิท้าย (นาฬิกา 1-2-3 → ภาพ hook push ถอยกลับ + หัวข้อเด้งกลับ 0.3 วิท้าย) ต่อ 2 วิแรกพอดี เฟรมท้าย = ภาพเฟรม 0
- เสียง: `video/sound/cues-th.json` 33 cue, รายงาน `renders/sound-th/SOUND.md`; ตัดภาพไม่ตรงจังหวะเพลง >140 ms ที่ 19.40/20.72/22.46/28.12 วิ (เวลาช็อตล็อกจากเสียงพากย์ ไม่ขยับ)
- render log มี 404 non-blocking 2 ครั้ง (ไม่กระทบภาพ ตรวจเฟรมแล้ว)
- ไม่ติด rate limit/บล็อก
- ไอคอน lucide 5 ตัว (file-text ice-cream-cone snowflake stethoscope turtle) อยู่ใน `video/icons/` ของตอนนี้ (ผู้กำกับย้ายออกจาก `assets/vendor/` ร่วม ตามกฎไฟล์ร่วม); build_index สำเนานี้หา icons/ เป็นที่สำรอง — แม่แบบควรมีช่องไอคอนต่อตอน
