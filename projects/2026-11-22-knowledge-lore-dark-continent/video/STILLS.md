# ใส่ภาพนิ่ง S1-S11 แล้วเรนเดอร์ใหม่

1. วางไฟล์ที่ `projects/2026-11-22-knowledge-lore-dark-continent/assets/stills/` ตั้งชื่อตามรหัส: `S1.png` `S2.jpg` ... (`.png` `.jpg` `.jpeg` `.webp`)
   รหัส/ฉาก/คำพากย์: `../shotlist-stills.md` ใส่แค่บางภาพก็ได้ ช่องที่ไม่มีไฟล์ใช้กราฟิกเดิมอัตโนมัติ
2. คำสั่งเดียว (จาก root ของ repo):
   ```bash
   bash projects/2026-11-22-knowledge-lore-dark-continent/video/rerender.sh
   ```
   ได้ `renders/lore-dark-continent-th.mp4` ใหม่ (build → render → มิกซ์เสียง -16 LUFS → พิมพ์ความยาว/LUFS/TP) ใช้เวลาประมาณเท่าการเรนเดอร์ครั้งแรก

## ระบบทำอะไรให้
- `build_index.py` คัดลอก `assets/stills/S#.*` ไป `video/assets/stills/` (ทั้งสองโฟลเดอร์อยู่ใน .gitignore ห้าม commit ภาพ) แล้วใส่ `<img>` ลงหน้า
- ภาพอยู่ในการ์ดเอียง ±2° กว้าง ≤660 px (≤61% ของจอ) push-in 10% วงกลมเหลืองทับ ป้ายชื่อแดง + เครดิต "HUNTER×HUNTER © Yoshihiro Togashi / Shueisha" ใต้การ์ด โชว์ ≤2 วิ ไม่เกินช็อต
- S6-S9, S11 อยู่ในหน้าต่างของการ์ดแดง (ด้าน "เจอ") แทนกราฟิกภัยพิบัติ แล้วกลับเป็นกราฟิกในช็อตถัดไป
- ตำแหน่งการ์ด/ป้าย/วงกลมแต่ละภาพ: `SCFG` ใน `index.html.tpl` (เช่น S3 `circ:[0.7,0.45]` = จุดวงกลมบนภาพ 0-1) ปรับได้ถ้าวงกลมไม่ตรงหน้าตัวละคร แล้วรันคำสั่งเดิม

## ตรวจหลังเรนเดอร์
ดูเฟรมที่ภาพขึ้น: `ffmpeg -ss <เวลา> -i renders/lore-dark-continent-th.mp4 -frames:v 1 /tmp/x.png`
เวลา: S1 0.54, S2 5.8, S3 7.2/8.3, S4 10.8, S5 18.9, S6 21.3, S7 28.1, S8 32.7, S9 37.6, S10 50.1, S11 45.9
ห้ามย้ายภาพไปโฟลเดอร์อื่นที่ไม่อยู่ใน .gitignore (เช็ก: `git check-ignore -v <ไฟล์>`)
