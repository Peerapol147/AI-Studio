# ตรวจการแก้กฎจังหวะตัด (2026-11-25)

ห้องตรวจอิสระ ตรวจ `claude/dev-cut-rule-2026-11-25` (edb67b1) เทียบ `claude/stoic-cray-6z2ajs` (bc334f5)
- 9178fde: style.md ข้อ 4, editor.md, editing-v3.md (จังหวะตัด "แล้วแต่คลิป")
- edb67b1: pacing.py ลด 2 คำเตือน (explain นอก 2-3 วิ, hook+twist ไม่เร็วกว่า) จาก WARN เป็น INFO

## ผล: ❌ ไม่ผ่าน (ยังไม่ควรรวม)

ตัว diff ถูกต้อง แต่ยังมี 3 ไฟล์ที่ห้องลูกอ่านทุกตอน และยังสั่งกฎเก่า "ตัดเร็วเฉพาะ hook/หักมุม, explain ค้าง 2-3 วิ" อยู่
ถ้ารวมตอนนี้ ผู้กำกับ (make-clip) กับ reviewer จะได้คำสั่งตรงข้ามกับ style.md ข้อ 4 ใหม่ แก้ 3 จุด 🔴 ด้านล่างแล้วรวมได้

## 1. ขอบเขต diff ✅
`git diff --stat bc334f5..edb67b1`: เปลี่ยน 4 ไฟล์ตามที่แจ้งเท่านั้น (+14/-8) ไม่มี `projects/` หรือไฟล์อื่นปน

## 2. ถ้อยคำกฎ

กฎใหม่ใน style.md ข้อ 4 / editor.md / editing-v3.md ข้อ 4 ไม่ขัดกันเอง และไม่ไปแตะกฎ v3 ข้ออื่น
(hook 1.5 วิ, เฟรม 0, ลูป, ซับ 1-3 คำ, ความยาว 20-40 วิ, look.py, ห้ามเฟรมนิ่ง >0.5 วิ ยังอยู่ครบ)
บรรทัดที่ลบออก ("แทนกฎ ช็อตเฉลี่ย ~1.4 วิ ... ด้านล่าง") ทำให้กฎเก่า style.md:100 (เฉลี่ย 1.4 วิ/ช็อต) ไม่ถูกยกเลิกแล้ว ซึ่งตรงกับเจตนาใหม่ จึงไม่ขัด

ที่ยังอ้างกฎเก่าและยังไม่ได้แก้:

### 🔴 ต้องแก้ก่อนรวม
1. `.claude/skills/make-clip/SKILL.md:33` "เปลี่ยน: ตัดเร็วเฉพาะ hook/หักมุม (ไม่ใช่ ~1.4 วิทั้งคลิป)"
   ข้อนี้ตรงข้ามกับเจตนาใหม่โดยตรง และเป็น skill ที่ผู้กำกับโหลดทุกตอน จึงจะดึงกลับไปตัดช้าแบบเดิม
   แก้เป็น "จังหวะตัดแล้วแต่คลิป (style.md ข้อ 4)"
2. `.claude/agents/reviewer.md:30` เช็กลิสต์ v3 "ช่วง hook/หักมุมตัดเร็วกว่าช่วงอื่น ...; ช็อต explain ค้าง 2-3 วิ"
   reviewer จะติคลิปที่ตัดถี่ทั้งคลิป (เช่น palmaris-test 1.35 วิ ที่ผู้ใช้ชอบ) แก้ให้ตรวจแค่ว่าจังหวะเข้ากับเนื้อหา
   มี `"pace"` ใน shots.json และไม่มีเฟรมนิ่งเกิน 0.5 วิ
3. `channels/knowledge/style.md:126` เช็กลิสต์ท้ายไฟล์ "รูปแบบ A: ... ตัดเร็วเฉพาะ hook/หักมุม ช่วง explain ค้างภาพ 2-3 วิ (`tools/pacing.py` ผ่าน)"
   ไฟล์เดียวกันขัดกับข้อ 4 ที่เพิ่งแก้ ควรแก้เป็น "จังหวะตามข้อ 4 (แล้วแต่คลิป, จด `pace`)"

### 🟡 ควรแก้
4. `docs/editing-v3.md:14` คอลัมน์ "เช็กด้วย" ยังเขียนว่า "pacing.py: WARN ช็อต explain นอก 2-3 วิ, WARN ถ้า hook+twist ไม่เร็วกว่า"
   แต่ตอนนี้เป็น INFO แล้ว ควรแก้เป็น "pacing.py: INFO (ข้อมูลประกอบ)"
5. `tools/pacing.py:24-25` docstring ยังจัด 2 ข้อนี้ไว้ใต้ "WARN (exit 0, reviewer decides)"
   และ `tools/pacing.py:154,161-162` ข้อความ INFO ยังสั่งกฎเก่า ("hold the picture 2-3 s", "cut fast only in the hook and the twist")
   ห้องลูกที่อ่านผลอาจเข้าใจว่าเป็นคำสั่ง ควรเปลี่ยนเป็นข้อความบอกสถานะเฉยๆ เช่น `explain shot X is 1.30 s` / `hook+twist avg 1.42 s vs rest 1.25 s`
6. ไม่มีเทสต์กันถอยกลับ: `tests/test_pacing.py:52-60` เช็กแค่ว่ามีข้อความ ไม่ได้เช็ก prefix
   ควรเพิ่ม assert ว่ามี `INFO explain shot` และไม่มี `WARN explain shot` / `WARN hook+twist`
7. แม่แบบยังผูกการขยับกล้องไว้กับ beat: `templates/brainrot-v3/index.html.tpl:89-91,98-102`, `TEMPLATE.md:25`, `build_index.py:15`
   ช็อต hook/twist ได้กล้องเร็วกับทรานซิชันของ look ส่วนช็อตอื่นได้แค่ push ช้า 8% และ match 0.1 วิ
   ถ้าตัดถี่ ~1.4 วิทั้งคลิป ช่วง setup/explain จะยังได้ motion แบบ "ค้างภาพ" ซึ่งอาจยังไม่ได้ "motion สวยแบบเมื่อก่อน" ตามที่ผู้ใช้ขอ
   (การแก้นี้ไม่ได้ทำให้แย่ลง แต่ยังไม่ได้แก้ต้นเหตุ) ควรเปิดงานแยก: เลือกโหมดกล้องจาก `pace` ไม่ใช่จาก beat

### ⚪ เล็กน้อย
8. `channels/knowledge/style.md:19` "`tools/pacing.py` WARN เรื่องความยาวช็อต = ข้อมูลประกอบ" ตอนนี้ pacing เป็น INFO แล้ว
   คำว่า WARN ในประโยคนี้จึงหมายถึง `shot_times.py` เท่านั้น (0.6-2.7 / explain 3.0 วิ) ควรเขียนให้ชัด
9. ช่อง `"pace"` ใน shots.json ยังไม่มีเครื่องมือไหนอ่าน ถ้าอยากให้ reviewer เห็น ให้ pacing.py พิมพ์ออกมาด้วย
10. `docs/editing-v3.md:62` ("ค้างภาพ 2-3 วิ" ในหัวข้อที่มาของตัวเลข), `tests/README.md:9` ("explain holds 2-3 s"),
    `tools/shot_times.py:192` (คอมเมนต์ "explain shots hold 2-3 s") เป็นประวัติหรือคำอธิบาย ไม่ใช่คำสั่ง ควรติดป้าย "เดิม" ไว้

## 3. pacing.py ✅
- นอกจาก 2 ข้อนี้ เช็กอื่นทุกตัวยังเป็น WARN/FAIL เหมือนเดิม (voice, topic, beat, ความยาว, legend, reveal, twist, share, cta, loop source)
- exit code ยังเป็น `1 if fails else 0` เหมือนเดิม และ 2 ข้อที่ลดลงมาเดิมก็เป็น WARN ซึ่งไม่มีผลต่อ exit code อยู่แล้ว
- เทสต์ `tests/test_pacing.py` + `tests/test_shot_times.py` ผ่าน 38/38 ทั้งก่อนและหลังแก้
- ทั้งโฟลเดอร์ `tests/` (pytest): ก่อนแก้ 87 passed, 1 skipped / หลังแก้ 87 passed, 1 skipped ไม่มีอะไรพังเพิ่ม

## 4. รันจริง (ก่อน = bc334f5, หลัง = edb67b1)
ไม่มีโปรเจกต์ที่มี shots.json บน branch นี้ จึงดึงไฟล์ข้อความของ 7 ตอนจาก branch `claude/ep-*` มารันใน scratchpad (ไม่ได้ commit ไฟล์เหล่านั้น)

| โปรเจกต์ | exit ก่อน/หลัง | สิ่งที่เปลี่ยน |
|---|---|---|
| 2026-11-22 lore-dark-continent, naga-fireballs, space-toilet | 1 / 1 | ไม่มี (เป็นตอนก่อน v3 ที่ไม่มี beat/topic, FAIL เหมือนกันทุกบรรทัด) |
| 2026-11-24 brain-freeze | 0 / 0 | WARN explain 2 ช็อต → INFO |
| 2026-11-24 solar-storm | 0 / 0 | WARN explain 3 ช็อต → INFO |
| 2026-11-24 stomach-growl | 0 / 0 | WARN explain 1 ช็อต → INFO |
| 2026-11-25 palmaris-test (ตัดถี่ 1.35 วิ) | 0 / 0 | WARN explain 4 ช็อต + WARN hook+twist → INFO ทั้งหมด |

ไม่มี WARN หรือ FAIL อื่นหายหรือเพิ่ม ผลลัพธ์ตรงตามเจตนา
