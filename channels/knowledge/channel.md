# ช่องความรู้ทั่วไป

**สไตล์คลิปสั้น: อ่าน `style.md` ก่อนเสมอ**

- คนดู: คนทั่วไปที่อยากรู้เรื่องน่าสนใจแบบเข้าใจง่าย
- น้ำเสียง: เล่าสนุก ชัด ไม่วิชาการเกินไป ทุกข้อเท็จจริงต้องมีแหล่งที่มา
- ภาพ: motion explainer, แผนที่, ชาร์ต, footage Pixabay / Wikimedia Commons / NASA
- **เสียงพากย์ล็อกทุกตอน (ผู้ใช้ 2026-11-26: "อยากให้ใช้จังหวะเดิม เสียงเดิมไปตลอด")**: ไทย = George `JBFqnCBsd6RMkjVDRZzb`, `eleven_v3`,
  อัดทั้งบทเทคเดียว → `bash tools/trim_silence.sh in.mp3 out.mp3 0.5` (ช่วงเงียบ ~0.5 วิ) → atempo **1.1** → normalize **-18 LUFS** → ค่อยทำ words
  ค่าอยู่ใน `templates/looks/looks.json` `channel_lock.knowledge`; `tools/look.py` ไม่สุ่มเสียงของช่องนี้ และ ERROR ถ้า look.json ใช้เสียง/โมเดล/atempo อื่น
  **แก้/ทำตอนเก่าใหม่** (ก่อน 2026-11-26 ที่ใช้ Liam หรือ look.json ไม่มี tts_model/atempo/vo_lufs): `look.py check --final` จะ ERROR
  ทางเลือก: (ก) ต้องอัดเสียงใหม่อยู่แล้ว → แก้ look.json เป็นค่าล็อก แล้วอัด George ใหม่; (ข) แก้แค่ภาพ/ปก ไม่แตะเสียง → รัน `check` ไม่ใส่ `--final` แล้วจดเหตุผลใน review.md ว่าคงเสียงเดิมเพราะอะไร
  (ตอนท้องร้อง/เส้นเอ็นข้อมือได้ Liam เพราะ look.py เคยสุ่มแกน voice ไม่ใช่เพราะเปลี่ยน key)
- เสียงพากย์: อังกฤษ = George `JBFqnCBsd6RMkjVDRZzb` (eleven_v3, tags [excited]/[playful]/[curious]; whole-script one take, silenceremove 0.15s -40dB + atempo 1.1 ได้ ~2.9 คำ/วิ; ทดสอบเทียบ Liam `TX3LPaxmHKxFdv7VOQHJ` และ eleven_v4 แล้ว George v3 กระชับสุด)
- สไตล์ HyperFrames: (เลือก frame preset หรือ style-sampling แล้วจดไว้ตรงนี้)
