# สถานะ: กำลังอัดเสียง (2026-11-28)
ผู้ใช้เชื่อม ElevenLabs คีย์ใหม่ (เก็บเป็น network secret ของ environment ไม่อยู่ใน repo) โควตา 0/10,000 → ทำต่อขั้น 4a
(เดิม: หยุดรอเพราะคีย์เก่าเหลือ 370 ตัว)

## เสร็จแล้ว
- brief.md, research.md (✅/⚠️), script.md + script-vo-th.txt (ล็อก ผ่านขั้นเกลา), storyboard.md, shots.json, look.json (check --final OK), thumbnail.md, upload.md (ร่าง เครดิตภาพยังต้องเติม)
- footage 10/10 (report exit 0) — ไฟล์ footage/เพลง .gitignore ไว้ เครื่องใหม่ต้องโหลดใหม่จาก Pixabay id ใน assets/CREDITS.md:
  hook/loop 885563.jpg, human 222664.jpg, cat 5534007.jpg, cold 253979.mp4, ape 388020.mp4, mouse 139660.mp4, music 161062.mp4, concert 29322.mp4, cta 65390.mp4
  เพลง: Jamendo track 1195826 "Metamorphosis" (zero-project, CC BY 3.0) → assets/audio/music-jamendo-34466c22.mp3 (`tools/music.sh music "cinematic" <project> 4 40` หรือโหลดตรง prod-1.storage.jamendo.com/?trackid=1195826&format=mp31)
- ปก A/B: covers/cover-a.jpg (หลัก), cover-b.jpg — cover_check --final OK (video/cover.html)
- video/ = คัดลอก templates/brainrot-v3 แล้ว (ยังไม่ได้ทำ episode.json/กราฟิก)

## หมายเหตุให้ editor/reviewer
- cat = ภาพนิ่งแมวขู่ (ไม่ใช่ขนพองชัด ไม่มีใน Pixabay) → ครอปให้เห็นตัว + กราฟิกเส้นขอบพองออกตรง "ใหญ่"; reviewer เช็กสวัสดิภาพสัตว์ (ท่าขู่ ไม่ถูกแกล้ง) ถ้าไม่ผ่าน → ทำเงาแมวพองเป็นกราฟิก
- ape = กอริลลาตากฝน (tags ไม่ใช่ AI) ดูเฟรมให้แน่ว่าไม่ใช่ภาพ AI
- mouse = หนูป่า (rat) ในภาษาไทยคือ "หนู" ได้ งานวิจัยใช้หนูเมาส์ ป้ายบนจอเขียน "ในหนู" ไม่ระบุพันธุ์

## ทำต่อ (เมื่อมีโควตา ≥ ~600 ตัวอักษร เผื่ออัดซ้ำ)
voice: อัดเทคเดียว George eleven_v3 → trim_silence 0.5 → vo_finish (atempo 1.1, -18 LUFS) → words.sh → shot_times.py → editor → contact sheet ทุก 0.25 วิ → reviewer → DELIVERY.md
ทางเลือกถ้าผู้ใช้อัดเอง: ส่ง script-vo-th.txt + จังหวะ (script.md ตาราง beat; เป้า ~33-37 วิ ~12.5 ตัว/วิ) แล้วใช้ไฟล์ผู้ใช้เข้า trim_silence → vo_finish → words.sh ตามเดิม
