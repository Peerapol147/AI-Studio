# ผลตรวจอิสระเฉพาะจุด: ตัดต่อ v3.2 (commit `73c0e79` เทียบ `65fc0ec`) 2026-11-23
ห้องตรวจไม่ได้แก้โค้ด ไม่ได้ push

## สรุป: ✅ ผ่าน (ไม่มี 🔴 ไม่มี 🟡) ทุกข้อจากผลตรวจ v3.1 แก้ถูกแล้ว เหลือ ⚪ เล็กน้อย

## 1. ตรวจ diff ทีละข้อ
- 🔴 midstory+card ✅ `templates/brainrot-v3/index.html.tpl:38-39` ตัว ink บนป้าย accent, คำไฮไลต์ accent บน ink ไม่มีขอบ; กฎอยู่หลัง `.cv-card` และเจาะจงกว่า จึงชนะ ยืนยันด้วยเรนเดอร์เอง (ข้อ 3)
- 🟡1 ✅ `tools/look.py:176-177,242-245` เทียบกับทุกตอนก่อนหน้าของช่อง
- 🟡2 ✅ `tools/look.py:80-90` อ่านได้ทั้งตัวหนาและในเครื่องหมายคำพูด; ประวัติจริงอ่านปกได้ **16/20** ตอนช่องความรู้ (เดิม 12/20)
- 🟡3 ✅ `templates/brainrot-v3/build_index.py:65-76` หยุดเมื่อ cover_text ≠ title (มีเทสต์)
- 🟡4 ✅ `index.html.tpl:56` เส้นใต้หนา 18px ใต้ตัวอักษร ไม่โดนขอบดำทับ เห็นชัดในเรนเดอร์
- 🟡5 ✅ `tools/look.py:233-237` เพลงซ้ำใน 3 ตอนล่าสุด = WARN (rec[1:] ถูก; rec[0] ยังเป็น ERROR)
- 🟡6 ✅ make-clip:34 · ⚪1 ✅ look.py:240 + editing-v3.md:15 · ⚪5 ✅ pipeline.md:13
- ไม่พบ bug ใหม่; จุดเรียก `recent()` อีกที่ (pick) แก้รับ 4 ค่าแล้ว

## 2. เทสต์ (คำสั่งเดียวกับ CI ติดตั้งแพ็กเกจตาม CI)
`python -m pytest -q -rs tests` → **83 passed in 33s** ไม่มี skip/fail (v3.1 = 78, +5)

## 3. เรนเดอร์ทดสอบเอง (8 วิ, fixture + ภาพสังเคราะห์ ขาว/เหลือง/ดำ/แถบสี, hyperframes 0.9.61, 15fps)
| | หน้าตา | ผล |
|---|---|---|
| A | night-violet / kanit / box / **midstory / card** / flash | ✅ เฟรม 0 ตัวดำบนป้ายเหลือง "ใหม่" เหลืองบนดำ อ่านออก |
| B | mono-yellow / prompt / stroke / **midstory / card** / whip | ✅ อ่านออก |
| D | ocean-teal / noto / **underline** / **midstory / card** / slide | ✅ ปกอ่านออก; เส้นใต้สีฟ้าเขียวเห็นชัด |
| C | sunrise-coral / sarabun / **underline** / pov / stack / zoom | ✅ เส้นใต้สีเหลืองเห็นชัดบนพื้นมืด |
log ยังมี `404` แบบ non-blocking 1 ครั้ง (เหมือน v3.1) ⚪

## 4. `tools/look.py check` กับประวัติจริง (fetch branch claude/ep-* 21 ตัว)
- โปรเจกต์ทดสอบ 2026-11-24 cover_text "กร๊อบ = ข้อเสื่อม?" → `look: FAIL` exit 1 **จับได้ทั้ง** เข่ากร๊อบ (11-20) และหักนิ้ว (11-18) ✅
- อ่านปกได้ 16/20 ตอนความรู้ (+ ฟุตบอล 1/1); 4 ตอนที่อ่านไม่ได้: elder-thirst, nature (ระบบปกเก่า `cover.json` ไม่มีบรรทัด "ข้อความ"), road-hug-anime, muay-reborn (อนิเมะ ไม่มี thumbnail.md) ⚪

## 5. ความปลอดภัย
ไม่มี key/secret/token/password, ไม่มี publish/upload ใหม่, ไม่มี superpowers ใน diff ✅

## ⚪ เล็กน้อย (แก้เมื่อสะดวก)
1. `tools/look.py` ไม่อ่าน `cover.json` ของระบบปกเก่า (`th.lines`) → ตอน elder-thirst, nature ไม่ถูกเทียบ (2/20)
2. `build_index.py:70-74` เทียบกับ `episode.json` title อย่างเดียว ถ้าทำเวอร์ชันอังกฤษด้วย `--episode <ไฟล์ en>` ขณะ cover_text เป็นไทย บิลด์จะหยุด (v3 ยังไม่มีทางทำอังกฤษที่เขียนไว้ แต่ควรตัดสินใจก่อนตอนอังกฤษแรก เช่น `cover_text_en`)
3. `index.html.tpl:39` กล่องดำหลังคำไฮไลต์ใน midstory+card สูงเกินป้ายเหลืองเล็กน้อย (ความสวย ไม่กระทบการอ่าน)
4. `index.html.tpl:56` แถบเส้นใต้ไม่มีขอบมืด → อาจกลืนถ้าภาพพื้นหลังสีเดียวกับ accent (เช่น เหลืองบนเหลือง)
5. `docs/editing-v3.md:82` (ตาราง v3.1) ยังเขียน "1 ใน 3 ตอนล่าสุด" ตาราง v3.2 แก้แล้ว แต่อาจทำให้คนอ่านสับสน
