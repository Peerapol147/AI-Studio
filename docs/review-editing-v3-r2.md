# ผลตรวจอิสระรอบ 2: ตัดต่อ v3.1 (commit `65fc0ec` บน `claude/dev-editing-v3`)

วันที่ 2026-11-23 · ตรวจ `git diff 2596620..65fc0ec` (16 ไฟล์) จากโค้ดจริง ไม่ได้ใช้สรุปใน `docs/editing-v3.md` เป็นหลักฐาน
เกณฑ์: ผลตรวจรอบ 1 (`docs/review-editing-v3.md` บน `claude/review-editing-v3`), คำขอเพิ่มของห้องวางแผน 2026-11-23 4 ข้อ,
`channels/knowledge/results.md` หัวข้อ "Analytics ชุดที่ 5" + "หน้าช่อง (ภาพปก, 2026-11-23)" และ `docs/story-craft.md` บน `claude/content-strategy`

## คำตัดสิน: **ผ่านแบบมีเงื่อนไข**

ปัญหารอบ 1 แก้ครบทุกข้อที่เป็น 🔴/🟡 และแก้ได้จริงในโค้ด (ซับกล่องอ่านออกแล้วทุกโทน, เพลงตอนเก่าอ่านได้, 70/30, ทรานซิชันเห็นจริง, เตือนเมื่อไม่ fetch)
คำขอเพิ่ม 4 ข้อมีครบในกฎและเครื่องมือ เทสต์ 78 เคสผ่าน ไม่มี skip ตอนเก่าไม่โดนแตะ
แต่มี **🔴 2 ข้อที่ต้องแก้ก่อนใช้**:
1. เครื่องเช็ก "ปกห้ามซ้ำ" **จับเคสต้นเรื่องเองไม่ได้**: ถ้าวันนี้ใส่ปก "กร๊อบ = ข้อเสื่อม?" ซ้ำกับหักนิ้ว `look.py check --final` ยัง **ผ่าน** (ยืนยันด้วยการรันจริง)
2. ปกแบบ `card` คู่กับเปิดแบบ `midstory` บนโทนมืด 4 โทน = **ตัวขาวบนแถบเหลือง/ฟ้าอ่อน** (contrast 1.27-1.44) เฟรม 0 อ่านยาก ขัดกฎ "เข้าใจใน 1 วิแบบปิดเสียง" (ยืนยันด้วยภาพ)

## ตารางผลตรวจรอบ 1

| ข้อ | ผล | หลักฐาน |
|---|---|---|
| 🔴-1 ซับ box บนโทนสว่าง ขาวบนขาว | **แก้แล้ว** | `looks.json` เพิ่ม `panel_text` ทุก palette (mint-paper `#0F2A22` บน `#FFFFFF`, retro-cream `#2B1B12` บน `#FFF8EC`); `index.html.tpl:48` ใช้ `color:var(--paneltext)`, คำไฮไลต์เป็นป้าย ink บน accent `:49`; เทสต์ `test_every_palette_keeps_text_readable`; ผมเปิด 72 ชุด (6 palette × 4 opening × 3 cover, วนครบ 24 คู่ palette × caption) ใน Chromium อ่าน `getComputedStyle` ของซับทุกก้อน: **ไม่มีคู่ไหนต่ำกว่า 3:1** (ที่ไม่มีขอบตัวอักษร) |
| 🟡-1 เพลงตอนเก่าอ่านไม่ครบ | **แก้แล้ว** | `look.py:68-74,128-129,146-147` fallback ไป `assets/credits/music.json`; รันจริง: lore-dark-continent ได้ `music_file=music-jamendo-a573d9da.mp3` (รอบ 1 = None) (เหลือ ⚪-1 ตอนที่มีหลายเพลง) |
| 🟡-2 ตำนานไม่เช็ก 70/30 | **แก้แล้ว** | `pacing.py:40,126-128` WARN ถ้าหักมุมแรก < 70%; ที่มาอ้าง `docs/story-craft.md` + เทสต์ใน `test_pacing.py` |
| 🟡-3 กฎใหม่ขัดกฎเก่า | **แก้แล้ว (เหลือเล็กน้อย ⚪-4)** | push ช้า 8% + หมุน 1° `index.html.tpl:117` (ถึงเกณฑ์ 8-15%); ข้อยกเว้น v3 เขียนตรงจุด: style.md:87 (ซับ), :119 (เช็กลิสต์), :136-137 (motion 2 ชั้น/ทรานซิชัน); make-clip:85 + reviewer.md:18 (ฟอนต์ `video/fonts/`); flash ไม่ได้เล่นทุกช็อตแล้ว (`:94`) |
| 🟡-4 แกนทรานซิชันแทบไม่เห็น | **แก้แล้ว** | `index.html.tpl:94` `kind(s,prev)` เล่นทรานซิชันของ look ทุกครั้งที่ beat เปลี่ยน + ใน hook/twist; ในช่วงเดียวกัน = ครอสเฟด (จากโครงตัวอย่าง hook→setup→explain→reveal→twist→share→cta→loop ≈ 6-7 ครั้งต่อคลิป) |
| 🟡-5 ลืม fetch แล้วผ่านเงียบ | **แก้แล้ว (บางส่วน)** | `look.py:152,205-208,283-284` ไม่มี ref `claude/ep-*` เลย = WARN, `--final` = ERROR; แต่ fetch ไว้นานแล้วไม่อัปเดต ยังไม่เตือน (ข้อเสนอ "ตอนล่าสุดเก่ากว่า N วัน" ไม่ได้ทำ, ไม่มีเหตุผลเขียนไว้) → ⚪-3 |
| ⚪-1 ที่มา 70/30 ผิด | แก้แล้ว | `docs/editing-v3.md:63` อ้าง `docs/story-craft.md` ข้อ 3 |
| ⚪-2 WARN ลูปหลอกใน v3 | แก้แล้ว | `pacing.py:162-163` ข้ามเมื่อมี `video/episode.json` |
| ⚪-3 twist ก่อน share / share ก่อนจบ | แก้บางส่วน | `pacing.py:143-144` WARN share ก่อน twist; "share ที่ 10%" ยังผ่านถ้าไม่มี twist ก่อน (ยอมรับได้ เพราะ FAIL ถ้าไม่มี twist หลัง reveal อยู่แล้ว) |
| ⚪-4 ซับ 1-3 คำ ไม่มีเครื่องเช็ก | แก้แบบประมาณ | `build_index.py:160-161` WARN ถ้าก้อน > 12 ตัวอักษร; เขียนเหตุผลไว้ (นับคำไทยไม่แม่น) `docs/editing-v3.md` "ยังไม่แก้" |
| ⚪-5 เทียบกับตอนที่วันที่ใหม่กว่า | แก้แล้ว | `look.py:103,162` `until=` วันที่ของโปรเจกต์ (ตอนวันเดียวกันยังนับ ถูกต้อง) |
| ⚪-6 สองห้องทำพร้อมกัน | แก้ด้วยกฎ | make-clip:53 "commit + push look.json ทันที ... fetch ก่อน check --final"; ไม่มีกลไกในเครื่องมือ (เขียนไว้ใน "ยังไม่แก้") |

## ตารางคำขอเพิ่มของห้องวางแผน (2026-11-23)

| ข้อ | ผล | หลักฐาน |
|---|---|---|
| 1 ความยาว 20-40 วิ, ยาวกว่าต้องมีเหตุผล, เพดาน 59 | **ผ่าน** | `pacing.py:39,114-122` FAIL > 59 วิ, FAIL > 40 วิถ้าไม่มี `long_reason`, WARN < 20 วิ; style.md ข้อ 7 (:25-26), make-clip:18,53, reviewer.md:25; ที่มาตรง results.md (content-strategy): "2 คลิปที่ปังยาว 20/35 วิ", "54-59 วิไม่ได้ดีกว่า" (ดู ⚪-4, ⚪-5 เรื่องข้อความเก่าที่ยังค้าง) |
| 2 เฟรมแรกเข้าใจใน 1 วิไม่เปิดเสียง (จุดเช็ก reviewer) | **ผ่าน** | reviewer.md:24 "เทสต์ปิดเสียง (สำคัญสุด) ... ต้องบอกได้ภายใน 1 วิ ... ถ้าไม่ = ไม่ผ่าน"; style.md ข้อ 8; make-clip:53 (แต่แม่แบบเองสร้างเฟรม 0 ที่อ่านยากได้ → 🔴-2) |
| 3 ปก/เฟรมแรกห้ามซ้ำ: หลายแบบจัดวาง + เตือนข้อความซ้ำ/คล้าย | **ผ่านแบบมีเงื่อนไข** | มีแกน `cover` (stack/card/tilt) `looks.json` + `index.html.tpl:33-39` + อยู่ใน `visual_axes`; `cover_text` + `similarity()` `look.py:82-100,224-228`; **แต่เคสตัวอย่างในคำขอเองไม่ถูกจับ (🔴-1) และ card+midstory อ่านยาก (🔴-2)** |
| 4 พักกฎ ">5K = ภาคต่อใน 24 ชม." ทุกที่ | **ผ่าน (ใน branch dev)** | ข้อความตรงตามคำขอ: results.md:11 (ขีดฆ่า + พักไว้), style.md:30 ข้อ 10, strategy-notes.md:41, make-clip:18,114; `git grep` ใน dev ไม่เหลือที่ใช้กฎนี้แบบ active; ตัวเลข ~1.2K = 1,267 / 1,291 ตรง results.md; ยังค้างบน branch content-strategy 2 จุด (⚪-6) |

### ผลรัน look.py กับประวัติจริง
หลัง `git fetch origin 'refs/heads/claude/ep-*:refs/remotes/origin/claude/ep-*'` (21 branch):
```
$ python3 tools/look.py pick projects/2026-11-23-knowledge-test
  2026-11-22-knowledge-lore-dark-continent [...]: ... music_file=music-jamendo-a573d9da.mp3, cover_text=โลกฮันเตอร์ = จุดนี้
  2026-11-22-knowledge-naga-fireballs [...]: ... music_file=music-jamendo-1195819.mp3, cover_text=ลูกไฟนี้ ใครจุด?
  2026-11-22-knowledge-space-toilet [...]: ... music_file=music-jamendo-34a821bb.mp3, cover_text=ปวดอึในอวกาศ?
→ palette=mono-yellow, font=noto, caption=pop, opening=pov, cover=tilt, transition=match, music_mood=cinematic, voice=liam
```
ลำดับและเพลงถูก ช่อง football แยกถูก แต่ปกที่อ่านได้จากประวัติทั้งช่อง (สคริปต์เรียก `look.history`):
`knuckle-crack` (หักนิ้ว) = **None**, yawn = None, genz-old = None, energy-left = None, muay-reborn = None, elder-thirst = None, nature = None, road-hug-anime = None

## ปัญหาใหม่ เรียงตามความรุนแรง

### 🔴 ต้องแก้ก่อนใช้

**🔴-1 เช็ก "ปกห้ามซ้ำ" ไม่จับเคสต้นเรื่อง (เข่ากร๊อบ = หักนิ้ว)**
- ไฟล์: `tools/look.py:224-228` เทียบ `cover_text` กับ `rec` = แค่ 3 ตอนล่าสุด (`RECENT = 3`, `:37`); `tools/look.py:36` `COVER_RE` อ่านเฉพาะข้อความที่เป็นตัวหนา `**...**` ในบรรทัด "ข้อความ"
- อาการ (รันจริง): ตั้ง `cover_text` = "กร๊อบ = ข้อเสื่อม?" ใน `projects/2026-11-23-knowledge-test` → `look.py check --final` = `look: OK` exit 0
  สาเหตุ 2 ชั้น: (ก) หักนิ้ว (18 พ.ย.) ไม่อยู่ใน 3 ตอนล่าสุด และตอนเข่ากร๊อบจริง (20 พ.ย.) ก็ห่างจากหักนิ้ว ~7 ตอน หน้าต่าง 3 ตอนจึงจับเคสนี้ไม่ได้แม้ตอนนั้น
  (ข) `thumbnail.md` ของหักนิ้วเขียนว่า `- ข้อความ ≤4 คำ: TH "กร๊อบ = ข้อเสื่อม?" | EN "..."` (เครื่องหมายคำพูด ไม่ใช่ตัวหนา) → อ่านได้ None; รูปแบบเดียวกันใน yawn, genz-old, energy-left; elder-thirst ใช้ `cover.json`
  ทดสอบเพิ่ม: "ตดในอวกาศ?" (ปกคลิปปัง 19 พ.ย.) โดน ERROR ก็เพราะบังเอิญคล้าย "ปวดอึในอวกาศ?" ของตอนล่าสุด ไม่ใช่เพราะเทียบกับตดในอวกาศเอง
- คำขอบอก "ซ้ำหรือคล้าย**ตอนก่อนของช่อง**" (ไม่ได้จำกัด 3 ตอน) และภาคต่อมักใช้ปกของตอนต้นฉบับที่เก่ากว่า 3 ตอน
- แก้: เทียบ `cover_text` กับ **ทุกตอนของช่อง** (การเทียบข้อความถูก ไม่ต้องจำกัด 3 ตอน; หน้าต่าง 3 ตอนคงไว้เฉพาะแกนหน้าตา); ขยาย `COVER_RE` ให้รับ `"..."` หลัง `TH` / หลัง `:` และอ่าน `cover.json` (ถ้ามีข้อความ); เพิ่มเทสต์ที่ใช้รูปแบบ `thumbnail.md` ของหักนิ้วจริง และเคส "ตอนเก่ากว่า 3 ตอน ปกเหมือนกัน = ERROR"

**🔴-2 ปก `card` + เปิด `midstory` บนโทนมืด = ตัวขาวบนแถบสีอ่อน อ่านยาก**
- ไฟล์: `templates/brainrot-v3/index.html.tpl:27` (`.op-midstory #title .tl{...color:var(--ink);background:var(--accent)...}`) ถูก `:35` (`.cv-card #title .tl{-webkit-text-stroke:0;color:var(--paneltext)...}`) ทับเฉพาะสีตัวอักษร (specificity เท่ากัน อันหลังชนะ) แต่พื้น `background:var(--accent)` จาก midstory ยังอยู่
- อาการ (Chromium, `getComputedStyle` + ภาพ): night-violet ขาว `#FFFFFF` บนเหลือง `#FFE14D` = 1.30:1, sunrise-coral 1.44, mono-yellow 1.27, ocean-teal 1.38 ไม่มีขอบตัวอักษร; ภาพที่ได้คือหัวข้อขาวบนแถบเหลืองในการ์ดม่วง (mint-paper / retro-cream ไม่เป็น เพราะ panel_text เข้ม) — 72 ชุดอื่นผ่าน
- โอกาสเกิด: `look.py pick` เลือกแกนอิสระกัน → midstory (1/4) × card (1/3) × โทนมืด (4/6) ≈ 5.6% ต่อตอน และนี่คือเฟรม 0 = ปก; เทสต์ contrast ตอนนี้เช็กแค่คู่สีต่อ palette ไม่ได้เช็กการผสม opening × cover จึงไม่จับ
- แก้: เพิ่มกฎ `.op-midstory.cv-card #title .tl{color:var(--ink)}` (หรือให้ card ล้าง background ของ midstory) แล้วเพิ่มเทสต์ที่ build ทุก palette × opening × cover แล้วเช็กคู่ (สีตัวอักษร, พื้นที่อยู่จริง) ≥ 4.5:1 เมื่อไม่มีขอบตัวอักษร

### 🟡 ควรแก้
(ไม่มี)

### ⚪ เล็กน้อย

- **⚪-1** `look.py:74` `_music_from_credits` เอาไฟล์เพลงแรกตามตัวอักษร: ตอนที่มีหลายเพลง (muay-reborn มี 3 เพลงใน credits) จะเทียบแค่เพลงเดียว → ควรคืนทุกไฟล์แล้วเช็กว่าไม่มีไฟล์ไหนซ้ำ
- **⚪-2** ความคล้าย ≥0.6 กับข้อความปกสั้น (≤4 คำ) เตือนข้ามหัวข้อได้: "ทำไมเราหาว?" กับ "ทำไมเราจาม?" = 0.67, "แมวกลัวน้ำ?" กับ "หมากลัวน้ำ?" = 0.67 → ERROR ทั้งที่คนละเรื่อง (ค่าตั้งเขียนชัดใน `docs/editing-v3.md:66` แล้ว) ถ้าเจอบ่อยให้ลด ERROR เป็น WARN เมื่อ 0.6-0.8 หรือตัดคำโครงซ้ำ ("ทำไม", "=") ก่อนเทียบ
- **⚪-3** (ต่อจาก 🟡-5 รอบ 1) fetch ไว้แล้วแต่เก่า (ห้องอื่น push ตอนใหม่หลัง fetch) ยังผ่านเงียบ; อย่างน้อยเขียนใน make-clip ว่า `check --final` ต้อง fetch ก่อนทุกครั้ง (ตอนนี้เขียนไว้แล้วที่ :53) หรือให้ look.py บอกวันที่ของตอนล่าสุดที่เห็นเทียบกับวันนี้
- **⚪-4** ข้อความความยาวเก่ายังค้าง: `reviewer.md:16` "≤60 วิ" (เพดานใหม่ 59), `style.md:53` "หักมุมเดียว 15-25 วิ" (ต่ำกว่าค่าเริ่มต้น 20, pacing จะ WARN), `style.md:54` "41-60 วิ: ทำได้เฉพาะการทดลอง" — หัวข้อ :52 บอก "แทนที่แล้ว" แต่ 2 บรรทัดนี้อยู่ใต้หัวข้อนั้นโดยไม่ได้ขีดฆ่า; make-clip:18 และ style.md:119 อ้าง "ทิศทาง 2026-11-22 ข้อ 7" แต่ข้อ 7 อยู่ใต้หัวข้อ "เพิ่ม 2026-11-23"; CLAUDE.md:7 ยังเขียน short ≤60 วิ (ไม่ใช่ไฟล์ที่ห้อง dev ควรแก้เอง แจ้งไว้)
- **⚪-5** `pacing.py:114-122` ใช้เกณฑ์ 20-40 วิ / 59 วิ กับทุกโปรเจกต์ รวมช่อง football แต่ข้อมูลที่มาเป็นของช่องความรู้เท่านั้น → ถ้าตั้งใจใช้ทั้ง 2 ช่องให้เขียนใน `channels/football/channel.md`; ถ้าไม่ ให้ใช้เฉพาะ `-knowledge-`
- **⚪-6** กฎภาคต่อยัง active บน branch `claude/content-strategy` 2 จุด (นอกขอบเขต dev): `docs/story-craft.md:102` ("สูตรไหน >5K ใน 48 ชม. → ภาคต่อใน 24 ชม.") และ `channels/knowledge/results.md:93` → แจ้งห้องวางแผน; และ results.md บน dev แก้บรรทัด 11 ขณะที่ content-strategy มีไฟล์นี้ยาวกว่ามาก ตอน merge ให้ใช้ฉบับ content-strategy + ขีดฆ่าบรรทัด 11
- **⚪-7** `index.html.tpl:37-38` `.cv-tilt #title .tl:nth-of-type(odd/even)` นับ `div` ทุกตัวใน #title รวม kicker (pov/number) → ลำดับเอียงสลับกันตามว่ามี kicker ไหม ไม่กระทบการอ่าน

## สิ่งที่ตรวจแล้วไม่พบปัญหา
- ซับทุกแบบ × ทุกโทน (24 คู่) อ่านออก; ปก stack/tilt ทุกโทนทุกโครงเปิด อ่านออก (ผ่าน `getComputedStyle` 72 ชุด, ภาพตัวอย่าง night-violet midstory stack ปกติ)
- `build_index.py:57` `setdefault('cover','stack')` ทำให้ look.json เก่าที่ไม่มีแกน cover ยัง build ได้; `legacy_v2` มี `cover: stack` → ตอนเก่านับเป็น stack ถูกต้อง
- `look.py` `_refs` ถูก pop ก่อนเรียงประวัติ ไม่ปนเป็นตอน; `--no-git` ไม่เตือน fetch (ตั้งใจ) 
- `pacing.py`: ลำดับเช็กความยาว (>59 FAIL ก่อน, >40 ไม่มีเหตุผล FAIL, <20 WARN) ถูก; WARN 70/30 ใช้ twist แรก
- ตัวเลขใหม่มีที่มาหรือบอกว่าเป็นค่าตั้ง: 20/40/59 วิ, ~1.2K, 46.5-58.3%, 75.4% ตรง results.md (content-strategy); 70% = กฎ 70/30 (story-craft); 0.6 ความคล้าย = ค่าตั้งเครื่องมือ (`look.py:30-31`, `editing-v3.md:66`); 8% push = เกณฑ์ 8-15% ใน style.md; 12 ตัวอักษร = เกณฑ์ขนาดฟอนต์เดิมใน build_index
- ไม่มี key/secret ใน diff (grep `api_key|secret|password|sk-|Bearer|xi-api` ในบรรทัดที่เพิ่ม = ไม่พบ); ไม่มี `lib.publish`/Publora; ไม่มีไฟล์ skill superpowers; `templates/brainrot-v2/` ไม่ถูกแตะ

## วิธีที่ใช้ตรวจ (ทำซ้ำได้)
- `pip install --user pytest numpy soundfile scipy matplotlib librosa && python3 -m pytest -q -rs tests` → `78 passed in 34.85s`, 0 skipped
- GitHub Actions `tests` run 126 (65fc0ec, job `smoke`): **ยังรันไม่จบตอนตรวจ** (ค้างที่ขั้นติดตั้ง ffmpeg ตั้งแต่ 20:16 UTC) ห้อง dev ต้องเช็กว่าเขียวก่อน merge; ผลรันเองในเครื่องตรวจผ่านครบ
- `git fetch origin 'refs/heads/claude/ep-*:refs/remotes/origin/claude/ep-*'` → `python3 tools/look.py pick projects/2026-11-23-knowledge-test`, แล้ว `--write` + ตั้ง `cover_text` 4 แบบ + `check --final` (ลบโฟลเดอร์ทดสอบแล้ว)
- 🔴-2: สร้างโปรเจกต์ทดสอบจาก `tests/fixtures/v3` ด้วย `project()`/`build()` ใน `tests/test_build_index_v3.py` ครบ 6 palette × 4 opening × 3 cover (caption วนครบ 4) → เปิด index.html ใน Chromium (แทน GSAP ด้วย stub) อ่าน `getComputedStyle` + ถ่ายภาพเฟรม 0 ความละเอียดต่ำ ไม่ได้เรนเดอร์ MP4
- ไม่ได้แก้ไฟล์ใดใน branch dev, ไม่ merge, ไม่ทำคลิป, ไม่อัปโหลด
