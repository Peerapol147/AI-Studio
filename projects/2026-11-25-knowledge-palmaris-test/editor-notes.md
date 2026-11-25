# editor-notes: palmaris-test (ลองทำตาม #1)

ผลลัพธ์: `renders/palmaris-test-th.mp4` (31.2 วิ, 1080x1920 30fps), ปก `renders/palmaris-test-th-thumb.jpg` (= เฟรม 0, 174 KB),
เสียง `renders/sound-th/SOUND.md` (-16.3 LUFS, true peak -5.2 dBFS วัดจาก MP4; mono เท่ากัน)
pacing: OK (WARN เฉลย 26% = ตั้งใจตาม brief; WARN explain rare 1.88 / none 1.76 วิ มาจากเวลาเสียง ห้ามแก้เอง)
`npm run check`: ผ่าน 0 error; WARN ที่เหลือ = ซับ line_unread (ซับ 1-3 คำตามกฎ v3 ตั้งใจ), ป้ายซีรีส์อยู่ขอบบน safe zone ของ Reels/Shorts (brief สั่งโซน Y 240-700), ป้าย "กล้ามเนื้อเล็กๆ" ชิดซ้าย TikTok

## โครงไฟล์ (กราฟิกตอนนี้)
- `video/episode/episode.js` + `episode.css`: กราฟิกทั้งหมด (rig แขน/มือ flat vector, ตัวเลข 3-2-1, 0/1/2, ป้าย) สีจาก `var(--accent)` ฯลฯ เท่านั้น
- `video/index.html.tpl` (สำเนาในโปรเจกต์): เพิ่มแค่ลิงก์ episode.css/js, `#epi` overlay, ป้าย `#badge` "ลองทำตาม #1", และ `episode(t)` เรียก `window.EPI`
- `video/prep_assets.sh`: ทำ plate grip (การ์ด 756x1344 บนพื้นเบลอของตัวเอง, เกรดขาวดำคอนทราสต์สูงตาม palette) + คัดลอก vo/เพลง
- `video/sound/cues-th.json`: sfx 21 จุด (pop ตรง สาม/สอง/หนึ่ง และ ศูนย์/หนึ่ง/สอง, whoosh ทุกจุดเปลี่ยนช่วง)

## ช่วงเวลา slot ผู้ใช้ (จาก shots-th.json)
| slot | ช็อต | เริ่ม-จบ (วิ) | ภาพตอนนี้ |
|---|---|---|---|
| A | hook | 0.00-1.52 | ข้อมือท่าทดสอบ เส้นเอ็นเหลือง + วง (= ปก/เฟรม 0) |
| B | pinch | 1.52-4.26 | นิ้วโป้งเคลื่อนไปแตะนิ้วก้อย (spring เริ่ม 2.62 "ประกบ") |
| B | flex | 4.26-5.90 | งอข้อมือ ("งอ" 4.34) เส้นเอ็นนูนขึ้น |
| C | count | 5.90-8.26 | ท่าค้าง + 3/2/1 (5.98/6.84/7.62) — ตัวเลขอยู่ใน overlay ไม่หายเมื่อเปลี่ยนเป็นคลิป |
| A | loop | 30.30-31.17 | เล่นภาพ hook ถอยกลับ จบ = เฟรม 0 |

## เปลี่ยนเป็นคลิปผู้ใช้
1. ทำ plate: `ffmpeg -i <คลิปผู้ใช้> -vf "fps=30,scale=1080:1920:force_original_aspect_ratio=increase,crop=1080:1920,hue=s=0,eq=contrast=1.35:brightness=0.03,curves=preset=increase_contrast" -an -c:v libx264 -crf 16 -pix_fmt yuv420p -g 6 video/assets/user-hand.mp4`
   (เกรดเดียวกับ grip; ถ้าคลิปเป็น 720p ให้ทำการ์ดบนพื้นเบลอแบบ `prep_assets.sh` แทนการขยาย; ห้าม commit คลิปดิบ — `video/assets/` ถูก ignore)
2. ผู้กำกับใส่ใน `footage.json` (ไม่ใช่ editor: shots.json/assets/audio ห้ามแตะ) เช่น
   `"hook": {"src": "assets/footage/user-hand.mp4", "action_at": <วิที่เห็นเส้นชัดสุด>}`, `"pinch": {..., "action_at": <วิที่นิ้วเริ่มเคลื่อน>}`, `"flex"`, `"count"`
   แล้ว `python3 tools/shot_times.py <project> th` → ได้ `media_start` ต่อช็อตใน shots-th.json
   **hook ต้องได้ media_start ≥ 0.87 วิ** (ความยาวช็อต loop) ไม่งั้น build หยุด เพราะช็อต loop เล่นคลิป hook จบที่ media_start ของ hook = เฟรม 0
3. `video/episode.json` `plates`: เปลี่ยน `"hook"`, `"pinch"`, `"flex"`, `"count"` จาก `"graphic"` เป็น `"assets/user-hand.mp4"` (loop ใช้ plate ของ hook เอง ไม่ต้องแก้)
4. `python3 build_index.py` — กราฟิกมือของช็อตนั้นหายเอง (สร้างเฉพาะช่องที่ยังเป็น graphic); ตัวเลข 3-2-1 และป้ายซีรีส์ยังอยู่
   ช็อต hook/loop ที่เป็นคลิปจะมีวงเหลือง overlay แทน: ตั้งตำแหน่งให้ตรงเส้นเอ็นในคลิปที่ `USER_RING` ใน `video/episode/episode.js` (x, y, r หน่วยพิกเซลของเฟรม 1080x1920)
5. snapshot เฟรม 0 + 30.9 วิ (ต้องเหมือนกัน), render, `tools/sound_pass_vo.py` ใหม่ (cues เดิมใช้ได้), ปกใหม่จากเฟรม 0
ทดสอบแล้ว: build ด้วย pinch/flex/count = คลิป (ใช้ grip แทน) ภาพขึ้นถูก ตัวเลข 3-2-1 ยังอยู่ ไม่มี error

## ปัญหาแม่แบบ (templates/brainrot-v3 — ไม่ได้แก้ templates/)
1. **`video/fonts/` ของแม่แบบไม่มีไฟล์ Sarabun** (fonts.css อ้าง `sarabun-*.woff2` แต่ไม่มีไฟล์) → look font sarabun จะตกไปฟอนต์ระบบ แก้ในตอนนี้ด้วยการคัดลอก `assets/fonts/*` ทับ
2. **ซับ `pop`: แถบไฮไลต์ไม่มีขอบบน** สระบน+วรรณยุกต์ซ้อน (นี้ ก้ โป้ ...) อยู่เหนือแถบเป็นสีหมึกบนพื้นมืด = หายไป ("เส้นนี้" เหลือ "เส้นนี") แก้ในตอนด้วย `#root.cap-pop .cap em{line-height:1.12;padding:.3em 18px .16em}` (episode.css) — ควรย้ายเข้าแม่แบบ + เทสต์เบราว์เซอร์แบบหัวข้อ v3.3
3. Sarabun + เส้นขอบหนา (หัวข้อ .15em / ซับ 10px) ทำให้หัวกลมของอักษรไทยเหลือจุดเทาเล็กๆ ในรู (อ่านได้ ไม่แก้)
4. CSS ตอนที่โหลดด้วย `<link>` แพ้ `<style>` ในแม่แบบ (`#title{top}` ต้องเขียน `#root #title`) — ช่อง EPISODE CSS ในแม่แบบอยู่ใน `<style>` เดียวกันจึงไม่เจอถ้าเขียนในนั้น
5. แม่แบบไม่มี `.gitignore` ใน `video/` → `.hyperframes/artifacts` (snapshot PNG ~30MB) หลุดเข้า commit `99c5f34` ของ branch นี้ ลบออกแล้วใน commit ถัดไป + เพิ่ม `video/.gitignore` (ประวัติยังมีไฟล์อยู่)

## ยอมรับไว้
- มือกราฟิกเป็น flat vector แบบแคปซูล (ไม่ใช่มือสมจริง) ท่าประกบนิ้วอ่านเป็น "นิ้วโป้งพาดไปแตะนิ้วก้อย" ชัดในช็อต pinch; รอบสองแทนด้วยคลิปผู้ใช้
- ช็อต fix เป็นแผนภาพข้อศอกนามธรรม (ไม่มีเลือด/แผล), ball เป็นซิลลูเอตแคปซูล ท่าตามสวิงท้ายดูแขนพับหน้าอก
- ภาพ grip 720x1280 ขยายแค่ 1.05x เป็นการ์ด (ไม่แตก) มือในคลิปค่อนข้างมืดตามเกรดขาวดำ
- ซับ Y 1100-1300 ทับท่อนแขนในช็อตมือ (ไม่ทับวง/เส้นเอ็นที่ข้อมือ ยกเว้นขอบล่างวงในช่วง hook 0.5-1.5 วิ)
