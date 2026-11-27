# แผนที่กราฟิก (ผู้กำกับเตรียมให้ editor)
`maps.json` สร้างด้วย `gen.mjs` (node, world-atlas@2 + topojson-client + d3-geo; ข้อมูล Natural Earth = สาธารณสมบัติ) เขตแดน = ปัจจุบัน
- `sea`: SEA ทั้งภูมิภาค (lon 91-127, lat -10..28) กล่อง 1080x1150 Mercator — path ต่อประเทศ (th mm la kh vn my sg id ph bn tl + cn in bd เป็นพื้นหลัง)
- `zoom`: รอบไทย (lon 95-110, lat 0.5-23) กล่อง 1080x1150 — ใช้ r1c/tw/tw_malay; `la` ≈ ฝั่งซ้ายโขง (ลาวปัจจุบัน, research: "ส่วนใหญ่คือลาวปัจจุบัน"); `malay_north_clip` = สี่เหลี่ยมตัด `my` เหนือ ~4°N ≈ ไทรบุรี/ปะลิส/กลันตัน/ตรังกานู (โดยประมาณ → ต้องมีป้าย "แผนที่ปัจจุบันโดยประมาณ")
- `world`: เอเชีย (lon 40-148, lat 0-48) กล่อง 1080x700 — `land` ทุกประเทศรวม, `countries` th bt np ir jp, `pins` จุดกลางประเทศ
ไม่ต้องเครดิต (Natural Earth public domain) แต่จดใน CREDITS ได้
