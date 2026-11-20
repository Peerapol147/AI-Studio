# anime engine (p5.js 2 + p5.brush 3 → MP4) — ใช้ซ้ำได้

การ์ตูน 2D วาดด้วยโค้ด เรนเดอร์ทีละเฟรมแบบ deterministic ด้วย Playwright/Chromium (swiftshader WebGL) ที่ห้องคลาวด์มีอยู่แล้ว
ไม่ใช้ภาพถ่าย/footage เลย ราว 0.7-1 วิต่อเฟรม 1080x1920 (44 วิ @24fps ≈ 15-20 นาที)

## ไฟล์
| ไฟล์ | หน้าที่ |
|---|---|
| `engine/lib.js` | `A.*` สแต็ก affine ของเราเอง (น้ำหนักเส้นคุมได้), `poly/ell/limb/rect` = เติมทึบ (`brush.wash`) + เส้นหมึกแปรง `pen`, `wc` = สีน้ำ, `grad` = ไล่สีท้องฟ้า, `camera`, `spring/ease` |
| `engine/characters.js` | `CH.person` (ด้านข้าง: เท้าแตะพื้นเสมอ, แขน/ขา/ก้าวเดิน/เอียงตัว/อารมณ์/ปาก), `CH.face` (ระยะใกล้: ตาโต คิ้วโกรธ/เศร้า ปากตะโกน/ยิ้ม แว่น เหงื่อ แก้มแดง), รถเก๋งด้านข้าง/ด้านหลัง, มอเตอร์ไซค์ (ไม่มีทะเบียน ไม่มีโลโก้), FX: เครื่องหมายโกรธ เส้นตะโกน ประกาย |
| `engine/scenery.js` | ฉากสีน้ำ: `SC.side` (ไหล่ทางด่วน), `SC.pov` (มองผ่านกระจกหน้ารถ), `SC.interior` (กรอบในรถ), `SC.wide` (ทางยกระดับเหนือเมือง), `SC.close` (พื้นหลังช็อตใกล้) อารมณ์ `dusk/tense/warm` |
| `engine/player.js` | เล่นรายการช็อต: ฉากหลังวาดครั้งเดียวต่อ `bgKey` ลง framebuffer ใหญ่กว่าจอ 16% (กล้องไม่หลุดฉาก), เส้นหมึก "เดือด" ทุก 2 เฟรม, `window.renderFrame(t)` |
| `episode.js` | **เฉพาะตอน**: รายการช็อต (เวลาผูกกับคำพูดจาก `episode-data.json`), ท่าทาง, overlay DOM (หัวเรื่อง hook, ซับสีตามผู้พูด, ป้ายชื่อ, ป้าย "ตี๊ด!", คอมเมนต์, คำถามปิดท้าย) |
| `index.html` | หน้าเว็บ: canvas + overlay, ฟอนต์ Kanit จาก `assets/fonts/` |
| `render.js` | `node render.js video out.mp4 24` (ไม่มีเสียง) / `node render.js stills <dir> t1,t2,...` |
| `sheet.sh` | contact sheet: `bash sheet.sh out.jpg t1,t2,...` (ตรวจด้วย sheet ไม่ใช่เฟรมเดี่ยว) |
| `tts_takes.py` → `split_takes.py` → `build_timeline.py` | อัด ElevenLabs v3 /with-timestamps **เทคเดียวต่อเสียง** → หั่นตามช่วงเงียบ → วางไทม์ไลน์ + ซับรายก้อน + ซองเสียงขยับปาก + เสียงตี๊ดทับ `{คำด่า}` |
| `shot_times.js`, `mix.py` | ส่งออกเวลาช็อต → มิกซ์ VO + เพลง (duck) + เสียงรถสังเคราะห์ + sfx CC0, -16 LUFS |

## ใช้กับตอนใหม่
1. คัดลอกโฟลเดอร์ `anime/` (ไม่เอา `node_modules`, `test`) แล้ว `npm i p5@2 p5.brush@3`
2. เขียน `lines.json` (เสียง + บท) และ `chunks.json` (ซับ 1-3 คำ) → รัน 3 สคริปต์เสียง
3. เขียน `episode.js` ใหม่ (ใช้ `CH.*`/`SC.*` เดิม) → contact sheet → `render.js video` → `node shot_times.js` → `mix.py`

## กฎวาด (playbook ห้อง STUDIO ANIME)
ห้ามของลอย (ทุกอย่างวางบนพื้น `GROUND`/`VG`), ตัดแข็ง (ไม่ dissolve), กล้อง push ได้ไม่เกิน 16% ของ framebuffer, ล็อกความยาวจากเสียงก่อนวาด,
ตัวละครขยับแบบ on twos (`tq`), ฟอนต์ `assets/fonts` และซับอยู่ Y 1100-1300 ตาม style.md
ข้อควรรู้: `A.reset()` ไม่ล้างสแต็ก (ใช้ใน push/pop ได้), วาด native p5 เฉพาะใน bg (ลำดับชั้นกับ brush), node fetch ไม่ผ่าน proxy (ไฟล์โหลดผ่าน `serve.js` ในเครื่อง)
