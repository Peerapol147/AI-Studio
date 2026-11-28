# Runbook งานตั้งเวลาของระบบสถิติ

ใช้โดย scheduled task 2 ตัว (เซสชันใหม่ทุกครั้ง) prompt ของ task สั้น ตรรกะอยู่ที่นี่เพื่อให้แก้ผ่าน git ได้
แดชบอร์ด: https://claude.ai/artifact/YTviqdYDggwK4UzvTBCiB2 (ส่วนตัว) · ช่อง: `@vision6498`
กฎร่วม: ห้ามใส่ key หรือตัวเลขสถิติลง repo ห้ามอัปโหลดหรือตั้งเวลาโพสต์วิดีโอ ห้ามแก้ `channels/`, `.claude/agents/`, `docs/analytics-learnings.md` เอง

## เตรียมเครื่อง (ทุกครั้ง)
1. ต้องมี repo `peerapol147/ai-studio` ในเซสชัน ถ้าไม่มีให้ `add_repo` แล้ว clone
2. ใช้โค้ดจาก branch `claude/focused-pascal-oejlo6` (จนกว่าผู้ใช้จะ merge เข้า branch หลัก) `git fetch origin claude/focused-pascal-oejlo6 && git checkout claude/focused-pascal-oejlo6`
3. ไฟล์ชั่วคราวเขียนในโฟลเดอร์ scratchpad ของเซสชัน ไม่ใช่ใน repo

## รายวัน: เก็บสถิติ
1. `python3 tools/yt_stats.py collect @vision6498 --projects projects > snap.json` ถ้า exit ≠ 0 ให้หยุดและรายงานเหตุผลจาก stderr (exit 3 + 403 ที่ไม่ใช่ quota = key ไม่ถึง Google) ห้ามเขียนอะไรลงแดชบอร์ด
2. อ่านเอกสาร `datasets/history` (ArtifactData get) เอา id จาก `source.url` (`/_blob/<id>`) แล้ว `Artifact read` ด้วย `path=<id>` เพื่อโหลดประวัติเดิม
3. `python3 tools/yt_stats.py dashboard-files --out out --history <ไฟล์ประวัติเดิม> < snap.json`
4. อัปโหลด `out/videos.json` และ `out/history.json` ด้วย `Artifact` publish `asset: true` (ไฟล์ละหนึ่งครั้ง) จดลิงก์ `/_blob/<id>` ใหม่
5. `ArtifactData update` เอกสาร `datasets/videos` และ `datasets/history` (get ก่อนเพื่อได้ version แล้วส่ง `if_version`): ตั้ง `source.url`, `source.name` เป็นไฟล์ใหม่ และ `updated` เป็น `{at: <เวลาตอนนี้ UTC ISO>, by: "scheduled task"}`
6. ลบ asset เก่าของสองไฟล์ (`Artifact delete` ด้วย `path=<id เก่า>`) หลังแน่ใจว่าเอกสารชี้ไฟล์ใหม่แล้ว
7. รายงานสั้นๆ: จำนวนคลิป จำนวนวันในประวัติ

## รายสัปดาห์: insight
1. โหลดไฟล์ของ `datasets/videos` (ขั้น 2 ข้างบน) แล้วรัน `python3 tools/yt_stats.py eligibility < snap.json` (snap รูปแบบ collect; หรือรัน collect ใหม่)
2. อ่าน skill `reality-check` (กฎอ่านสถิติ) แล้วเขียน insight ภาษาไทยต่อกลุ่ม `<ช่อง> · <รูปแบบ>`:
   - กลุ่มที่ไม่ผ่านเกณฑ์ (ต้อง ≥10 คลิปอายุ ≥7 วัน): เขียนแค่ "ยังสรุปไม่ได้: ..." ห้ามอ้างว่าแบบไหนดีกว่า
   - กลุ่มที่ผ่าน: ใช้มัธยฐานคู่กับค่าเฉลี่ย (ระวังคลิปฮิตไม่กี่ตัวดึงค่าเฉลี่ย) ระบุขนาดกลุ่มย่อยทุกครั้ง บอกตัวแปรที่ไม่ได้คุม (หัวข้อ วันที่ลง) และเสนอเป็นข้อทดลองครั้งต่อไป ไม่ใช่ข้อสรุป
   - ห้ามแต่งตัวเลข ทุกตัวต้องมาจากไฟล์
3. ไฟล์ `insights.json` เป็นแถว `{week: "YYYY-Www", group, n, eligible: "พอสรุปได้"|"ยังไม่พอ", text}` ต่อท้ายแถวเก่า (โหลดเก่าจาก `datasets/insights`) อัปโหลดแล้วอัปเดต `datasets/insights` ตามขั้น 4-6 ของรายวัน
4. ถ้ามีบทเรียนที่ผ่านเกณฑ์และไม่มีตัวเลขช่อง ให้เสนอผู้ใช้ในรายงานว่าจะเพิ่มลง `docs/analytics-learnings.md` ไหม ห้ามเขียนเอง

## ทุก 3 ชั่วโมง: ติดตามคลิปเดียว (รายชั่วโมง)
คลิป: "ประเทศ ไหนไม่เคย เป็นเมืองขึ้น บ้างนะ?" id `jhCNtyZyjfA` เริ่ม 2026-11-28 เก็บถึง 2026-12-05 (UTC)
1. เตรียมเครื่องตามหัวข้อบน ถ้าเวลาตอนนี้ (UTC) เลย 2026-12-05T17:00:00Z แล้ว ให้ปิดงานนี้เอง (`list_triggers` หา "ติดตามคลิปรายชั่วโมง" แล้ว `update_trigger enabled=false`) และหยุด
2. อ่านเอกสาร `datasets/hourly` เอา id จาก `source.url` แล้ว `Artifact read path=<id>` เพื่อโหลดประวัติเดิม
3. `python3 tools/yt_stats.py track jhCNtyZyjfA --history <ประวัติเดิม> --out new-hourly.json` ถ้า exit ≠ 0 ให้หยุดและรายงานเหตุผล ห้ามเขียนอะไรลงแดชบอร์ด
4. อัปโหลด `new-hourly.json` (`Artifact` publish `asset: true` ชื่อไฟล์ `hourly.json`) แล้ว `ArtifactData update datasets/hourly` ตั้ง `source.url`, `source.name` และ `updated` ตามขั้น 5 ของรายวัน จากนั้นลบ asset เก่า
5. รายงานบรรทัดเดียว: จำนวนรอบที่เก็บแล้ว และวิวล่าสุด
