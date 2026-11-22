# ผลตรวจอิสระ: ตัดต่อ v3 (branch `claude/dev-editing-v3`)

วันที่ 2026-11-22 · ตรวจ `git diff 7e91754..claude/dev-editing-v3` (ac45fd6, e940342, ef3b0e4, 2596620) จากโค้ดจริง ไม่ได้ใช้สรุปใน `docs/editing-v3.md` เป็นหลักฐาน
เกณฑ์: คำสั่งที่ผู้ใช้อนุมัติ 7 ข้อ + เงื่อนไข, ผลวิจัย `docs/editing-research-2026-11-22.md` ข้อ 1-3 และ `channels/knowledge/results.md` (branch `claude/content-strategy`)

## คำตัดสิน: **ผ่านแบบมีเงื่อนไข**

ทำครบทั้ง 7 ข้อ เครื่องมือรันได้จริงกับประวัติจริง เทสต์ 71 เคสผ่าน (ไม่มี skip) CI ผ่านทั้ง 4 commit ตอนเก่าไม่โดนแตะ
แต่มี **🔴 1 ข้อที่ต้องแก้ก่อนใช้**: ถ้าสุ่มได้โทนสว่าง (`mint-paper`, `retro-cream`) คู่กับซับแบบ `box` ซับจะเป็นตัวขาวบนกล่องขาว อ่านไม่ได้ทั้งคลิป (ยืนยันด้วยภาพ)
และมี 🟡 หลายข้อที่ทำให้กฎใหม่ขัดกับกฎเก่าที่ยังอยู่ หรือเครื่องมือเช็กได้ไม่ครบตามที่กฎเขียน

## ตารางรายข้อ

| ข้อ | ผล | หลักฐาน |
|---|---|---|
| 1 Hook (เฟรม 0 คำถาม + ภาพแปลกใจ, หัวข้อจบ ≤1.5 วิ, ไม่ทักทาย, hook 3 แบบ + ปิดเสียง) | ผ่าน | `tools/pacing.py:29,79-89` FAIL ถ้าหัวข้อจบหลัง 1.5 วิ; แม่แบบแสดงหัวข้อเต็มตั้งแต่เฟรม 0 `templates/brainrot-v3/index.html.tpl:115-121`; reviewer ดูเฟรม 0 + เทสต์ปิดเสียง + hook 3 แบบ `.claude/agents/reviewer.md:30-31`; "ภาพแปลกใจ" ตรวจด้วยตาเท่านั้น (ยอมรับได้) |
| 2 ลูป (ประโยคท้ายต่อประโยคแรก, เฟรมท้ายเข้ากับเฟรมแรก) | ผ่าน | ช็อต `loop` เล่นภาพ hook และจบที่ `media_start` ของ hook `build_index.py:128-137` + สเกล 1.06→1.0 `index.html.tpl:106`; เทสต์ `test_two_looks_differ` เช็กเลขเฟรม; ส่วนบท = reviewer อ่านต่อกัน `reviewer.md:32-33`; style.md:9-10 คงกฎ "ห้ามประโยคค้าง" ไว้ ไม่ขัด |
| 3 โครงจังหวะ (เฉลย 50-60%, หักมุม 1, ข้อเท็จจริงน่าส่งต่อ, คำถามปิด, ตำนาน 70/30) | ผ่าน (มีช่องโหว่ 🟡-2) | `pacing.py:103-126` FAIL ถ้าไม่มี reveal/twist หลังเฉลย/share/cta หรือ share หลัง cta, WARN ถ้าเฉลยนอก 50-60%; **แต่แนวตำนานไม่เช็กตำแหน่งหักมุม 70/30 เลย** |
| 4 จังหวะตัด (เร็วเฉพาะ hook/หักมุม, explain ค้าง 2-3 วิ, ซับ 1-3 คำ + ไฮไลต์) | ผ่าน (มีข้อขัดกฎเก่า 🟡-3) | `pacing.py:129-139` WARN; `shot_times.py` รับ `beat` และขยายเพดาน explain เป็น 3.0 วิ; แม่แบบ: กล้องเร็วเฉพาะ hook/twist `index.html.tpl:107-110`; ไฮไลต์ `*คำ*` ทุกแบบซับ; จำนวนคำต่อก้อนไม่มีเครื่องมือเช็ก (reviewer ดูเอง) |
| 5 เลิกแม่แบบเดียว (ชุดตัวเลือก, จดลง look.json, เตือนซ้ำ 3 ตอนล่าสุด, ตอนเก่าไม่พัง, เพลงไม่ซ้ำติดกัน) | **ผ่านแบบมีเงื่อนไข** | `templates/looks/looks.json` ครบ 7 ด้าน; `tools/look.py pick/check` อ่าน `projects/` + `claude/ep-*` ได้จริง (ผลรันด้านล่าง); ตอนเก่านับเป็นหน้าตา v2; **แต่ 🔴-1 ซับมองไม่เห็น, 🟡-1 อ่านเพลงตอนเก่าไม่ครบ, 🟡-4 แกนทรานซิชันแทบไม่เห็นในคลิป** |
| 6 make-clip ขั้น 7 แนะนำวันละ 1-2 คลิป (เป็นคำแนะนำ) | ผ่าน | `.claude/skills/make-clip/SKILL.md` แถวขั้น 7: "บอกผู้ใช้ทุกครั้ง (คำแนะนำ ไม่มีหลักฐานว่าลงเยอะแล้วโดนลงโทษ): ลงวันละ 1-2 คลิป"; style.md:18-19 เขียนแบบเดียวกัน |
| 7 reviewer.md เช็กลิสต์ 1-5 + ตาราง "ปัญหาที่เจอแล้ว" | ผ่าน | `reviewer.md:29-40` (ข้อ 9 ครบ Hook/ลูป/โครงจังหวะ/จังหวะตัด/หน้าตาไม่ซ้ำ พร้อมคำสั่ง); make-clip ตารางปัญหา +4 แถว |
| เงื่อนไข: ไม่มี key/secret | ผ่าน | grep `api_key|secret|token|password|sk-` ใน diff: เจอแค่คำว่า token ในคอมเมนต์ของ component HyperFrames (ไม่ใช่ค่าจริง) |
| เงื่อนไข: ไม่แก้ส่วน publish | ผ่าน | diff ไม่มี `lib.publish` / Publora / ไฟล์ publish |
| เงื่อนไข: ไม่ commit skill superpowers | ผ่าน | `git diff --name-only` ไม่มี brainstorming / writing-plans / verification-before-completion |
| เงื่อนไข: เทสต์เดิม 54 + CI ผ่าน | ผ่าน | `python3 -m pytest -q -rs tests` → `71 passed in 29.57s` ไม่มี skip; GitHub Actions `tests` run 106-109 (ac45fd6, e940342, ef3b0e4, 2596620) = success ทั้งหมด |
| เงื่อนไข: เครื่องมือใหม่มีเทสต์ | ผ่าน | `tests/test_look.py` 6 เคส (รวมตอนที่อยู่แค่ใน branch), `test_pacing.py` 8, `test_build_index_v3.py` 3 (แต่ไม่มีเทสต์ความคมชัดสีซับ จึงหลุด 🔴-1) |
| เงื่อนไข: ตัวเลขมีที่มา | ผ่าน (อ้างผิดที่ 1 จุด ⚪-1) | 1.5 วิ / 50-60% / 2-3 วิ / 1-3 คำ / 1-2 คลิป = ผลวิจัยข้อ 3; ≤4 วิ, <0.3 วิ, ≥0.4 วิ = style.md/make-clip เดิม; "3 ตอนล่าสุด" = คำสั่ง; เกณฑ์ palette/opening ห้ามซ้ำ เขียนชัดว่าเป็นค่าตั้งของเครื่องมือ (`look.py:25`); ค่าแอนิเมชัน (push 1.04-1.12, 0.12 วิ ฯลฯ) เป็นค่าการทำงานของแม่แบบ ไม่ใช่กฎ แต่ค่า push ช้า 5% ขัดกฎเก่า (🟡-3) |
| เงื่อนไข: brainrot-v2 ไม่ถูกแตะ | ผ่าน | `git diff --stat` ไม่มีไฟล์ใน `templates/brainrot-v2/`; เทสต์ v2 เดิมผ่าน |

### ผลรัน look.py กับประวัติจริง
หลัง `git fetch origin 'refs/heads/claude/ep-*:refs/remotes/origin/claude/ep-*'` (20 branch):
```
$ python3 tools/look.py pick projects/2026-11-22-knowledge-test
last episodes (newest first):
  2026-11-22-knowledge-lore-dark-continent [origin/claude/ep-2026-11-22-lore-dark-continent] (no look.json = brainrot-v2 look): ... music_file=None
  2026-11-22-knowledge-naga-fireballs [...]: ... music_file=music-jamendo-1195819.mp3
  2026-11-22-knowledge-space-toilet [...]: ... music_file=music-jamendo-34a821bb.mp3
→ palette=mono-yellow, font=noto, caption=underline, opening=pov, transition=slide, music_mood=upbeat, voice=liam
```
ลำดับถูก (lore 19:53 > naga 16:53 > space-toilet 14:26 UTC) ช่อง football แยกถูก (เทียบกับ messi-ronaldo)
แต่ `music_file` ของตอนล่าสุด (lore) = None ทั้งที่ตอนนั้นใช้เพลง "Dark Space" (ดู 🟡-1)

## ปัญหา เรียงตามความรุนแรง

### 🔴 ต้องแก้ก่อนใช้

**🔴-1 ซับแบบ `box` บนโทนสว่างเป็นตัวขาวบนกล่องขาว อ่านไม่ได้**
- ไฟล์: `templates/looks/looks.json:8` (mint-paper `text #FFFFFF`, `panel #FFFFFF`), `:11` (retro-cream `text #FFF8EC`, `panel #FFF8EC`); `templates/brainrot-v3/index.html.tpl:41` (`.cap-box .cap span{background:var(--panel);...;color:var(--text)}`)
- อาการ: build fixture ด้วย look `mint-paper + box` แล้วเปิดใน Chromium ที่เวลาซับ "ช่วงอธิบาย": สีตัวอักษร `rgb(255,255,255)` พื้นกล่อง `rgb(255,255,255)` ภาพที่ได้คือกล่องขาวเปล่า (retro-cream ก็เหมือนกัน `rgb(255,248,236)` ทั้งคู่); `night-violet + box` อ่านได้ปกติ
  เฉพาะคำที่ไฮไลต์ `*...*` (สี accent) ที่ยังเห็น ซับที่เหลือหายทั้งคลิป
- โอกาสเกิด: `look.py pick` สุ่มได้คู่นี้ได้ (2 ใน 6 โทน × 1 ใน 4 แบบซับ ≈ 8% ต่อตอน) และ `look.py check` / `build_index.py` / `hyperframes check` ไม่จับ
- แก้: ใน `.cap-box` ใช้สีตัวอักษรที่ตัดกับ panel (เช่น `color:var(--ink)` เมื่อ panel สว่าง หรือเพิ่มฟิลด์ `cap_text` ต่อ palette) แล้วเพิ่มเทสต์ที่วนทุก palette × caption คำนวณ contrast ratio ระหว่างสีตัวอักษรกับพื้น (≥4.5:1) ให้ fail ถ้าต่ำ

### 🟡 ควรแก้

**🟡-1 look.py อ่านเพลงของตอนเก่าไม่ครบ → เช็ก "เพลงห้ามซ้ำติดกัน" หลุดได้ในตอน v3 ตอนแรก**
- ไฟล์: `tools/look.py:31,86-87,103-104` อ่านเพลงจาก `<audio ... src="assets/music...">` ใน `video/index.html` เท่านั้น
- อาการ: ตอนล่าสุด `lore-dark-continent` ใส่เพลงตอนมิกซ์ (`video/rerender.sh` `--music assets/audio/music-jamendo-a573d9da.mp3`) ไม่มีใน index.html → `music_file=None` → ตอนถัดไปเลือก "Dark Space" ซ้ำได้โดย `check --final` ผ่าน
- แก้: fallback อ่าน `assets/credits/music.json` (คีย์ = ชื่อไฟล์เพลง มีในทุกตอนที่ใช้ `tools/music.sh`) ก่อนหรือหลัง index.html; เพิ่มเทสต์ตอนเก่าที่มีเพลงแค่ใน music.json

**🟡-2 แนวตำนาน/ลี้ลับ: ไม่มีการเช็ก "เล่าเรื่อง 70 / หักมุม 30" จริง**
- ไฟล์: `tools/pacing.py:105-109` เมื่อ `genre=legend` แค่เช็กว่ามี twist แล้วพิมพ์ % ออกมา ไม่ FAIL/WARN ถ้าหักมุมมาเร็ว
- อาการ: หักมุมที่ 30% ของคลิปก็ได้ `pacing: OK` ทั้งที่ `docs/story-craft.md:29` (branch content-strategy) บอกว่า "หักมุมเร็วเกิน = แป้ก" (บทเรียนผีอำ 781 วิว) และ reviewer.md:34 บอกให้ดู "หักมุมช่วง 30% ท้าย"
- แก้: WARN ถ้าช็อต twist แรกเริ่มก่อน 70% ของความยาว (ตัวเลขจากกฎ 70/30 เอง ไม่ต้องแต่งเพิ่ม) + เทสต์

**🟡-3 กฎใหม่ขัดกับกฎเก่าที่ยังอยู่ (reviewer อาจตีตกคลิป v3 ที่ทำถูก)**
- `channels/knowledge/style.md:129-130` ("Motion เพิ่ม"): ทุกช็อต motion ≥2 ชั้น (กล้อง + องค์ประกอบ); ภาพนิ่งต้อง push-in 8-15% + parallax หรือ drift หมุน ("Ken Burns 3% ไม่พอ")
  ↔ แม่แบบ v3 ช็อตค้างภาพ push 1.00→1.05 (5%) "ไม่ส่าย" `index.html.tpl:109-110`; style.md:15 อธิบายแค่ว่าไม่ขัด "ห้ามเฟรมนิ่งเกิน 0.5 วิ" แต่ไม่พูดถึง 8-15% / 2 ชั้น
- `style.md:133` "ไม่ตัดแข็งทุกช็อต" ↔ ทรานซิชัน `flash` = ตัดแข็ง + แฟลชทุกช็อต (`index.html.tpl:86` ใช้ flash กับทุก beat)
- `style.md:82` และเช็กลิสต์ `style.md:113` "ซับขาวขอบดำ ไม่มีกล่องพื้นหลัง" ↔ ซับ `box`/`pop`
- `make-clip/SKILL.md:85` "ซับ ... ขาวขอบดำ, Kanit 700 จาก `assets/fonts/`" และ `reviewer.md:18` (ข้อ 6) "ฟอนต์จาก `assets/fonts/`" ↔ v3 มี 4 ฟอนต์ใน `video/fonts/`
- หัว style.md บอก "v3 ชนะกฎเก่าเมื่อขัดกัน" แต่ reviewer.md ข้อ 6-7 และเช็กลิสต์ style.md:113 ยังเป็นเกณฑ์ตรวจตรงๆ → reviewer ต้องเดาเอง
- แก้: เขียนข้อยกเว้นตรงจุด (เช่น style.md:129-130 "ยกเว้นช็อต beat ค้างภาพของ v3", :82/:113 "หรือแบบซับตาม look.json", make-clip:85 + reviewer:18 "หรือฟอนต์ตาม look.json ใน `video/fonts/`") หรือปรับ push ช้าของ v3 ให้ถึง 8% ถ้าจะคงกฎ Motion เพิ่ม; ให้ `flash` ใช้เฉพาะ hook/twist เหมือนทรานซิชันอื่น

**🟡-4 แกน "ทรานซิชัน" แทบไม่ปรากฏในคลิป ทั้งที่ look.py นับเป็นความต่างทางภาพ**
- ไฟล์: `templates/brainrot-v3/index.html.tpl:86-87` ช็อตแรก `k='none'`, ช็อตที่ไม่ใช่ hook/twist ได้ `match` (ครอสเฟด 0.1 วิ) เสมอ ยกเว้น look เป็น flash/match
- อาการ: look ที่ต่างกันแค่ whip/zoom/slide เห็นความต่างเฉพาะช็อต twist (มัก 1-2 ช็อต) และ hook ช็อตที่ 2 ขึ้นไป แต่ `look.py` (`visual_axes` ใน looks.json:4) นับแกนนี้เป็น 1 ใน 5 ด้านที่ทำให้ "หน้าตาไม่ซ้ำ"
- แก้: ใช้ทรานซิชันของ look กับทุกการเปลี่ยน beat (เช่น setup→explain, explain→reveal) ไม่ใช่แค่ hook/twist หรือเอา transition ออกจาก `visual_axes`

**🟡-5 ถ้าลืม fetch branch ตอน `look.py` ผ่านเงียบๆ โดยเทียบกับตอนเก่ามาก**
- ไฟล์: `tools/look.py:90-106,197-199` เตือนเฉพาะเมื่อไม่มีประวัติเลย
- อาการ: `look.py pick ... --no-git` (เทียบเท่าไม่ได้ fetch) ได้ประวัติเป็น `2026-11-17-knowledge-elder-thirst`, `nature` (ตอน 5 วันก่อน) แทน 3 ตอนวันนี้ → `check` ผ่านทั้งที่ไม่ได้เทียบกับตอนล่าสุดจริง
- แก้: WARN (หรือ ERROR ใน `--final`) เมื่อไม่มี ref `refs/remotes/origin/claude/ep-*` เลย หรือเมื่อตอนล่าสุดที่เจอเก่ากว่าวันที่ของโปรเจกต์เกิน N วัน; หรือให้ look.py รัน fetch เอง

### ⚪ เล็กน้อย

- **⚪-1** `docs/editing-v3.md:63` อ้างว่า "เล่าเรื่อง 70 / หักมุม 30 … = กฎเดิมใน style.md / make-clip" แต่ไม่มีใน style.md/make-clip ที่ 7e91754 ที่มาจริงคือ `docs/story-craft.md:29` และ `docs/HANDOFF-planning.md:27` (branch content-strategy) → แก้ที่มาให้ถูก
- **⚪-2** `pacing.py:140-141` WARN "ลูปคนละไฟล์" เทียบ `src` จาก footage.json แต่แม่แบบ v3 ใช้ภาพ hook ในช็อต loop เสมอไม่ว่า src จะเป็นอะไร → WARN หลอกได้ ควรอ่าน `plates` ใน episode.json หรือเขียนใน TEMPLATE.md ว่าให้ตั้ง src ของ loop = hook
- **⚪-3** `pacing.py` ไม่เช็กว่า twist มาก่อน share/cta และไม่เช็กว่า share อยู่ "ก่อนจบ" (แค่ก่อน cta) — share ที่ 10% ก็ผ่าน
- **⚪-4** ซับ "1-3 คำต่อจังหวะ" ไม่มีเครื่องมือเช็ก (`build_index.py:148-161` เช็กแค่ ≥0.4 วิ) อาจเพิ่ม WARN เมื่อก้อนยาวเกิน ~12 ตัวอักษรไทย (ใช้เกณฑ์ขนาดฟอนต์ที่มีอยู่แล้วที่ `build_index.py:157`)
- **⚪-5** `look.py:117` เรียงประวัติรวมตอนที่วันที่ใหม่กว่าโปรเจกต์ที่กำลังเช็กด้วย (ถ้าเช็กโปรเจกต์เก่าย้อนหลังจะเทียบกับตอนในอนาคต) ไม่กระทบงานปกติ
- **⚪-6** สองห้องทำตอนพร้อมกันวันเดียวกัน ต่างฝ่ายไม่เห็น look.json ของอีกฝ่ายจนกว่าจะ push → อาจเลือกชุดเดียวกัน ควรเขียนใน make-clip ให้ push look.json ทันทีหลัง pick และ fetch ก่อน check --final

## สิ่งที่ตรวจแล้วไม่พบปัญหา
- `tools/shot_times.py`: `beat` อยู่ใน `{**sh, **src}` จึงใช้ได้ทั้งเช็ก 3.0 วิของ explain และคัดลอกไป shots-<lang>.json; beat ผิดชื่อ = ERROR และลบไฟล์เก่า; เปลี่ยน beat ทำให้ hash ของ shots.json เปลี่ยน → pacing/build ปฏิเสธไฟล์เก่า
- `look.py`: เทียบเสียง `george` กับ `id:JBFq…` ได้ถูก, แยกช่องถูก, ตอนเดียวกันที่อยู่หลาย branch ไม่ซ้ำ, ห้ามเขียนทับ look.json ที่มีอยู่
- ลูปภาพ: วิดีโอ loop จบที่ `media_start` ของ hook, หัวข้อเด้งกลับ 0.3 วิสุดท้าย, ซับก้อนสุดท้ายหายก่อนรอยต่อ; ถ้า `media_start` ของ hook สั้นกว่าช็อต loop จะหยุดพร้อมบอกวิธีแก้
- เปิดแบบ pov/number/midstory และซับ stroke/pop/underline บนทุกโทน: สีตัวอักษรตัดกับพื้นได้ (ปัญหามีแค่ box + โทนสว่าง)

## วิธีที่ใช้ตรวจ (ทำซ้ำได้)
- `pip install --user pytest numpy soundfile scipy matplotlib librosa && python3 -m pytest -q -rs tests` → 71 passed, 0 skipped
- `git fetch origin 'refs/heads/claude/ep-*:refs/remotes/origin/claude/ep-*'` แล้ว `python3 tools/look.py pick projects/2026-11-22-knowledge-test` (และ `--no-git`, และ `...-football-test`)
- 🔴-1: สร้างโปรเจกต์ทดสอบจาก `tests/fixtures/v3` ด้วยฟังก์ชันใน `tests/test_build_index_v3.py` 3 look (mint-paper/retro-cream/night-violet + box) → `build_index.py` → เปิดใน Chromium (Playwright, แทน GSAP ด้วย stub ที่ seek เวลา) อ่าน `getComputedStyle` ของซับและถ่ายภาพ ไม่ได้เรนเดอร์ MP4
- ไม่ได้แก้ไฟล์ใดใน branch dev, ไม่ merge, ไม่ทำคลิป, ไม่อัปโหลด
