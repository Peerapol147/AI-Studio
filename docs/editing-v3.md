# ตัดต่อ v3 (2026-11-22)

ที่มา: ผลวิจัย `docs/editing-research-2026-11-22.md` (branch `claude/content-strategy`) ข้อ 1-3, ผู้ใช้อนุมัติ 2026-11-22 "แก้ปรับปรุงได้เลย"
ปัญหา: วิวคลิปใหม่ตกเหลือหลักร้อย ยังไม่มีหลักฐานว่าโดนบล็อกเป็นสแปม แต่
(1) ทุกคลิปใช้แม่แบบ brainrot-v2 + เพลง/เสียง AI แบบเดิม ตรงกับตัวอย่างในนโยบาย "เนื้อหาไม่แท้/แม่แบบ" ของ YouTube (เสี่ยงหาเงินไม่ได้ทั้งช่อง)
(2) คลิปแพ้ตั้งแต่ 3 วิแรก/ช่วงกลาง (คลิปที่ปัง: หักนิ้ว 20 วิ Stayed to watch 75.4%, ตดในอวกาศ 34.6 วิ ใน `channels/knowledge/results.md` ของ branch เดียวกัน)

## เปลี่ยนอะไร (กฎ)
| # | กฎ | ใครทำ | ใครเช็ก / เช็กยังไง |
|---|---|---|---|
| 1 | **Hook:** เฟรม 0 = คำถามบนจอ + ภาพที่ทำให้แปลกใจ; พูดหัวข้อจบภายใน 1.5 วิ; ห้ามเปิดด้วยโลโก้/ทักทาย/ปูพื้น; ยังเขียน hook 3 แบบ + เทสต์ปิดเสียง | ผู้กำกับ (บท + `topic` ใน shots.json), editor (เฟรม 0) | `tools/pacing.py` (FAIL ถ้าหัวข้อจบหลัง 1.5 วิ), reviewer ดูเฟรม 0 + เทสต์ปิดเสียง |
| 2 | **ลูป:** ประโยคสุดท้ายอ่านต่อเข้าประโยคแรกได้ (แต่ละประโยคจบในตัว ไม่ใช่ประโยคค้าง); ภาพเฟรมสุดท้ายเข้ากับเฟรมแรก | ผู้กำกับ (บท), editor (แม่แบบทำภาพให้) | reviewer เล่น 2 วิท้ายต่อ 2 วิแรก + อ่านบทต่อกัน; pacing.py เตือนถ้าช็อต loop ใช้ภาพคนละไฟล์กับ hook |
| 3 | **โครงจังหวะ:** เฉลยที่ ~50-60% → หักมุม/ข้อแถม 1 ข้อ → ข้อเท็จจริงน่าส่งต่อ 1 ข้อ → คำถามชวนคอมเมนต์ (≤4 วิ); ตำนาน/ลี้ลับ เล่าเรื่อง 70 / หักมุม 30 | ผู้กำกับ (`beat` ทุกช็อต) | pacing.py: FAIL ถ้าไม่มี reveal/twist/share/cta หรือเรียงผิด, WARN ถ้าเฉลยนอก 50-60%; reviewer ดูว่า beat ตรงเนื้อหาจริง |
| 4 | **จังหวะตัด:** ตัดเร็วเฉพาะ hook/หักมุม; ช่วงอธิบายค้างภาพ 2-3 วิ; ซับ 1-3 คำต่อจังหวะ ไฮไลต์คำสำคัญ | ผู้กำกับ (cue), แม่แบบ v3 (กล้องเร็ว/ช้าตาม beat) | pacing.py: WARN ช็อต explain นอก 2-3 วิ, WARN ถ้า hook+twist ไม่เร็วกว่าช่วงอื่น; shot_times ไม่เตือน explain ถึง 3.0 วิ |
| 5 | **เลิกแม่แบบเดียว:** ทุกตอนเลือกหน้าตา 7 ด้าน จดใน `look.json`; ห้ามสี/โครงเปิดเหมือนตอนก่อน, ห้ามหน้าตาเหมือน 1 ใน 3 ตอนล่าสุดทุกด้าน, ห้ามเพลงพื้นหลังเดิมซ้ำติดกัน | ผู้กำกับ (`look.py pick`), voice (`music_file`), editor (v3) | `tools/look.py check --final` (ERROR = ห้ามไปต่อ), reviewer เทียบเฟรมกับตอนก่อน |
| 6 | **จังหวะลงคลิป (คำแนะนำ ไม่มีหลักฐานว่าลงเยอะแล้วโดนลงโทษ):** วันละ 1-2 คลิป เว้นระยะ ไม่ลง 5-6 คลิปวันเดียว | ผู้กำกับบอกผู้ใช้ตอนส่งมอบ (make-clip ขั้น 7) | - |
| 7 | reviewer มีเช็กลิสต์ข้อ 1-5 (`## เช็กลิสต์ตัดต่อ v3` ใน review.md) | reviewer | - |

## ไฟล์ที่เปลี่ยน
| ไฟล์ | อะไร |
|---|---|
| `templates/looks/looks.json` (ใหม่) | ชุดตัวเลือก: palette 6 (สี + `grade` สำหรับเกรด footage), font 4 (Kanit/Prompt/Noto Sans Thai/Sarabun), caption 4 (stroke/box/pop/underline), opening 4 (question/midstory/pov/number), transition 5 (whip/zoom/match/flash/slide), music_mood 6 (+ คำค้น), voice 2 ที่รู้ id (George/Liam, หรือ `id:<voice_id>` จาก `tools/voices.sh`); `legacy_v2` = หน้าตาของตอนเก่าที่ไม่มี look.json |
| `tools/look.py` (ใหม่) | `pick` เลือกค่าที่ไม่ได้ใช้ใน 3 ตอนล่าสุดของช่อง, `check` เช็กซ้ำ (อ่าน `projects/` + ทุก branch `claude/ep-*` ที่ fetch แล้ว) |
| `tools/pacing.py` (ใหม่) | เช็กโครงจังหวะจากเสียงจริง (ข้อ 1, 3, 4) |
| `tools/shot_times.py` | รับ `beat` ต่อช็อต (ผิดชื่อ = ERROR) คัดลอกไป shots-<lang>.json; ช็อต explain ไม่เตือนจนถึง 3.0 วิ |
| `templates/brainrot-v3/` (ใหม่) | แม่แบบที่อ่าน look.json: สี/ฟอนต์เป็นตัวแปร CSS, ซับ/โครงเปิดเป็น class, ทรานซิชันตาม look, กล้องเร็วเฉพาะ hook/twist, ช็อต loop จบที่เฟรม 0; ข้อมูลตอนอยู่ใน `episode.json`; วิธีใช้ใน `TEMPLATE.md` |
| `templates/brainrot-v2/` | **ไม่แก้** (ตอนเก่า build ได้เหมือนเดิม) |
| `channels/knowledge/style.md` | หัวไฟล์ "ทิศทาง 2026-11-22" ข้อ 1-6 (ชนะกฎเก่า), แก้เช็กลิสต์ช็อตเฉลี่ย ≤1.8 วิ |
| `.claude/skills/make-clip/SKILL.md` | แม่แบบหลัก = v3; ขั้น 3 (โครง, beat, topic, look.json), 4a (เสียง/เพลงตาม look.json), 5 (v3 + pacing.py), 6 (เช็กลิสต์ v3), 7 (คำแนะนำจังหวะลงคลิป); ตาราง "ปัญหาที่เจอแล้ว" +4 แถว |
| `.claude/agents/reviewer.md` | ข้อ 9 เช็กลิสต์ตัดต่อ v3 |
| `.claude/agents/editor.md`, `voice.md`, `docs/pipeline.md` | ใช้ v3 / look.json |
| `tests/test_look.py`, `test_pacing.py`, `test_build_index_v3.py`, `fixtures/v3/` (ใหม่) | 24 เคสใหม่ (รวมรอบ v3.1) |

## วิธีใช้ (ห้องทำคลิป)
```bash
git fetch origin 'refs/heads/claude/ep-*:refs/remotes/origin/claude/ep-*'   # ให้เห็นตอนล่าสุดที่อยู่ใน branch
python3 tools/look.py pick projects/<id> --write      # ขั้น 3: ได้ look.json ที่ต่างจาก 3 ตอนล่าสุด (พิมพ์ตอนที่เทียบให้ดู)
#   แก้ voice / music_mood ให้เข้าแนวเรื่องได้ (ตำนาน → mysterious, อวกาศ → cinematic ฯลฯ) แล้ว:
python3 tools/look.py check projects/<id>             # ต้อง look: OK
# shots.json: "topic": {"th": "..."} + "beat" ทุกช็อต (hook setup explain reveal twist share cta loop), "genre": "legend" ถ้าเป็นตำนาน
# ขั้น 4a voice: เสียงตาม look.json voice, เพลงตาม music_mood → เขียน music_file ลง look.json
python3 tools/look.py check projects/<id> --final     # เพลงไม่ซ้ำตอนก่อน
python3 tools/shot_times.py projects/<id> th
python3 tools/pacing.py projects/<id>                 # ต้อง pacing: OK ก่อนตัดต่อ (WARN = ตัดสินใจเอง/บอก reviewer)
# ขั้น 5 editor: cp -r templates/brainrot-v3 projects/<id>/video → episode.json → python3 build_index.py (อ่าน TEMPLATE.md)
```
ตัวอย่าง shots.json (ตัดมาบางส่วน):
```json
{"lead": 0.08, "topic": {"th": "กลัวน้ำ"},
 "shots": [{"id": "hook", "cue": {"th": "ทำไม"}, "beat": "hook", "media_start": 2.0},
           {"id": "why", "cue": {"th": "หลายคน"}, "beat": "setup"},
           {"id": "fur", "cue": {"th": "ขน"}, "beat": "explain"},
           {"id": "answer", "cue": {"th": "จริงๆ"}, "beat": "reveal"},
           {"id": "bonus", "cue": {"th": "แต่"}, "beat": "twist"},
           {"id": "fwd", "cue": {"th": "ส่งให้"}, "beat": "share"},
           {"id": "ask", "cue": {"th": "เมนต์"}, "beat": "cta"},
           {"id": "loop", "cue": {"th": "สงสัย"}, "beat": "loop"}]}
```
(ข้อความในตัวอย่างเป็นแค่รูปแบบไฟล์ ไม่ใช่บท)

## ตัวเลขในกฎมาจากไหน
1.5 วิ, เฉลย 50-60%, หักมุม/ข้อแถม, ข้อเท็จจริงน่าส่งต่อ, ค้างภาพ 2-3 วิ, ซับ 1-3 คำ, วันละ 1-2 คลิป = ผลวิจัยข้อ 3 + คำสั่งห้อง dev;
เล่าเรื่อง 70 / หักมุม 30 = `docs/story-craft.md` ข้อ 3 (branch `claude/content-strategy`, บทเรียนผีอำ: หักมุมเร็วเกิน = แป้ก);
คำถามคอมเมนต์ ≤4 วิ, เสียงพากย์เริ่ม <0.3 วิ, ซับก้อน ≥0.4 วิ = กฎเดิมใน style.md / make-clip;
ความยาว 20-40 วิ (เพดาน 59) = ห้องวางแผน 2026-11-23 จาก Analytics ชุดที่ 5 (`channels/knowledge/results.md` บน content-strategy);
ความคล้ายข้อความปก ≥0.6 = ค่าตั้งของเครื่องมือ (ตั้งให้ "กร๊อบ = ข้อเสื่อม?" กับ "เข่ากร๊อบ = ข้อเสื่อม?" นับว่าซ้ำ) ไม่ได้มาจากผลวิจัย
"3 ตอนล่าสุด" = คำสั่งห้อง dev; "ห้ามสี/โครงเปิดเหมือนตอนก่อน" เป็นค่าตั้งของเครื่องมือ (เลือก 2 ด้านที่เห็นชัดที่สุดในเฟรม 0) ไม่ได้มาจากผลวิจัย
ป้ายหลักฐานของผลวิจัย: hook/ลูป = ข้อมูล+ทางการ(โฆษณา), เลิกแม่แบบเดียว = ทางการ(นโยบาย), ข้อเท็จจริงน่าส่งต่อ = ทางการ(IG), เฉลย 50-60% = คำอ้าง + ข้อมูลช่องเรา 2 คลิป, ตัดเร็วเฉพาะ hook = อ้อม → วัดผลหลังลงทุกครั้ง (`results.md`)

## รอบแก้ v3.1 (2026-11-23): ผลห้องตรวจ (`docs/review-editing-v3.md` บน `claude/review-editing-v3`) + ห้องวางแผน
| เรื่อง | แก้ |
|---|---|
| 🔴 ซับกล่องบนโทนสว่าง = ขาวบนขาว | `panel_text` ต่อ palette, คำไฮไลต์ในกล่องเป็นป้าย accent; `test_every_palette_keeps_text_readable` เช็ก contrast ≥4.5:1 ทุก palette (retro-cream accent ปรับเป็น #EE5F44) |
| 🟡 เพลงตอนเก่าอ่านไม่ครบ | look.py อ่าน `assets/credits/music.json` ด้วย (ตอนทวีปมืดเจอ "Dark Space" แล้ว) |
| 🟡 ตำนานไม่เช็ก 70/30 | pacing.py WARN ถ้าหักมุมแรกเริ่มก่อน 70% |
| 🟡 กฎใหม่ขัดกฎเก่า | ช็อตค้างภาพ push 8% + drift 1° (ผ่านกฎ Motion เพิ่ม); ข้อยกเว้น v3 เขียนตรงจุดใน style.md (ซับ, ทรานซิชัน, ภาพนิ่ง), make-clip (ฟอนต์/ซับ), reviewer ข้อ 6 |
| 🟡 ทรานซิชันแทบไม่เห็น | เล่นทรานซิชันของ look ทุกครั้งที่เปลี่ยนช่วงเรื่อง (beat) + ใน hook/หักมุม; ภายในช่วงเดียวกัน = ครอสเฟด 0.1 วิ (flash จึงไม่ขึ้นทุกช็อต) |
| 🟡 ลืม fetch แล้วผ่านเงียบ | look.py WARN เมื่อไม่มี branch `claude/ep-*`, `--final` = ERROR |
| ⚪ | แก้ที่มา 70/30; pacing ไม่เตือนลูปหลอกในโปรเจกต์ v3; WARN share มาก่อนหักมุม; build_index WARN ซับก้อนยาวเกิน 12 ตัวอักษร; ไม่เทียบกับตอนที่วันที่ใหม่กว่า; make-clip ให้ push look.json ทันทีหลัง pick |
| ห้องวางแผน: ความยาว | ค่าเริ่มต้น 20-40 วิ, เกิน 40 ต้องมี `long_reason`, เกิน 59 = FAIL, ต่ำกว่า 20 = WARN (pacing.py) |
| ห้องวางแผน: เฟรมแรก 1 วิ ปิดเสียง | style.md ข้อ 8 + reviewer ข้อ 9 (ไม่ผ่าน = ตีกลับ) |
| ห้องวางแผน: ปก/เฟรมแรกห้ามซ้ำ | แกนใหม่ `cover` (stack / card / tilt) + `cover_text` ใน look.json; look.py ERROR ถ้าข้อความคล้ายปก 1 ใน 3 ตอนล่าสุด (อ่านปกเก่าจาก thumbnail.md) |
| ห้องวางแผน: ภาคต่อ | พักกฎ ">5K = ภาคต่อใน 24 ชม." ใน results.md, strategy-notes.md, style.md, make-clip |
ยังไม่แก้: ⚪-4 นับคำซับไทยไม่ได้แม่น (ใช้นับตัวอักษรเตือนแทน), ⚪-6 สองห้องทำพร้อมกันยังพึ่งการ push look.json เร็ว (ไม่มีล็อก)

## ทดสอบแล้ว
- pytest ทั้งชุด 78 เคส (เดิม 54 + ใหม่ 24 หลังรอบแก้ v3.1) ผ่านหมด ไม่มี skip (ติดตั้ง soundfile/librosa ตาม CI แล้วรัน)
- v3.1: snapshot mint-paper + ซับกล่อง + ปก card และ retro-cream + ซับป้าย + ปก tilt อ่านออกทุกก้อน
- เรนเดอร์ทดสอบ 8 วิ (ภาพสังเคราะห์ ไม่มีเนื้อหาจริง, draft 15fps ย่อเหลือ 540x960) 2 หน้าตา:
  A = sunrise-coral / Prompt / ซับกล่อง / POV / slide, B = ocean-teal / Noto Sans Thai / ซับป้ายเด้ง / ตัวเลข / flash
  `hyperframes check` ผ่าน (0 error; มีแต่ WARN ซับอยู่จอสั้นเพราะเดโมบีบ 8 วิ), เฟรมสุดท้าย = เฟรม 0 ทั้งสองแบบ
- ยังไม่ได้ลองกับตอนจริง (footage/เสียงจริง): ตอนแรกที่ใช้ v3 ให้ editor จดสิ่งที่ติดลงตาราง "ปัญหาที่เจอแล้ว" ใน make-clip

## ยังไม่ทำ / ข้อจำกัด
- แม่แบบ v3 มีแค่โครง (ช็อต ซับ หัวข้อ ทรานซิชัน ลูป) กราฟิกเฉพาะตอน editor ยังต้องทำเอง (ช่อง `#g-<id>` + `function episode(t)`)
- look.py รู้จักตอนจาก `projects/` และ branch `claude/ep-*` ที่ fetch แล้วเท่านั้น; ลำดับตอนวันเดียวกันใช้เวลา commit ล่าสุดของโฟลเดอร์
- เสียงพากย์มีแค่ 2 ตัวที่รู้ id; ตัวอื่นต้องหาด้วย `tools/voices.sh` และฟังภาษาไทยก่อน
- ช่องฟุตบอลยังไม่มี style.md: look.py ใช้ได้ (แยกช่องจากชื่อโฟลเดอร์) แต่กฎโครงจังหวะเขียนไว้ใน style.md ของช่องความรู้
