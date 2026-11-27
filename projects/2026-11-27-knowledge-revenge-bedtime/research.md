# Research: นอนดึกเพราะ "เสียดายเวลา" (Revenge Bedtime Procrastination)
วันที่ค้นข้อมูล: 2026-11-27

## ข้อจำกัดของการค้นรอบนี้ (อ่านก่อน)
- WebFetch เข้าเว็บ frontiersin.org, sleepfoundation.org, health.clevelandclinic.org, health.harvard.edu ไม่ได้ (โดเมนไม่อยู่ใน allowlist ของเซสชัน) จึงอ่านหน้าเต็มไม่ได้ ข้อมูลทั้งหมดมาจากผลค้น (WebSearch) ที่สรุปเนื้อหา + ชื่อ/URL ของแหล่ง ไม่ได้อ่านต้นฉบับเต็ม
- เพราะอ่านต้นฉบับเต็มไม่ได้ ข้อที่ต้องการถ้อยคำเป๊ะ (เช่น นิยามของ Kroese) ให้ผู้ตรวจเปิดลิงก์เช็กซ้ำก่อนส่งถ้าทำได้
- ไม่มี Bash ใน agent นี้ จึงใช้ `tools/get.sh` ไม่ได้ ใช้ WebSearch/WebFetch ตรง

## ข้อเท็จจริง (เรียงตามลำดับเล่า)

### 1. ชื่อ "Revenge Bedtime Procrastination" และต้นทาง
- เป็นคำแปลจากจีน 报复性熬夜 (bàofùxìng áoyè) ประมาณ "นอนดึกเพื่อแก้แค้น/ชดเชย" ผูกกับวัฒนธรรมงานหนักแบบ "996" (9 โมง-3 ทุ่ม 6 วัน/สัปดาห์) — ป้าย ⚠️ (แหล่งรอง ไม่ได้อ่านต้นฉบับเต็ม)
  - แหล่ง: Lifehacker Australia / Saatva / Spokesman-Review / Discover Magazine (ผ่านผลค้น) https://www.discovermagazine.com/revenge-bedtime-procrastination-is-a-thing-why-are-we-doing-it-42379 , https://www.spokesman.com/stories/2021/may/09/water-cooler-losing-sleep-over-revenge-bedtime-pro/ , https://www.saatva.com/blog/revenge-bedtime-procrastination/
- ทวีตของ Daphne K. Lee (นักข่าว) ลง 28 มิ.ย. 2020 เป็นตัวทำให้คำอังกฤษแพร่ — ป้าย ⚠️ (วันที่มาจากทวีตที่ฝังใน Lifehacker AU แหล่งรองเดียว; หลายแหล่งยืนยันว่า Lee เป็นผู้ทำให้ดังแต่วันที่ยืนยันแหล่งเดียว)
  - https://www.lifehacker.com.au/?p=934674 , https://www.saatva.com/blog/revenge-bedtime-procrastination/
- **ปีที่คำจีนเริ่มแพร่: แหล่งขัดกัน ยังไม่ยืนยัน** Wikipedia บอก Weibo ปี 2014 (Wikipedia ห้ามใช้เป็นหลักฐาน และแหล่งอื่นไม่รองรับ); Psychology Today ผูกกับช่วงโควิดในจีน → "ราว 2018-2020" ในบรีฟ **ไม่มีแหล่งยืนยัน = ❌ ห้ามพูดปีของคำจีน** พูดได้แค่ "คำนี้มาจากภาษาจีน และแพร่ในโซเชียลช่วงปี 2020" (ส่วน 2020 = ⚠️ ตามข้างบน)
  - https://www.psychologytoday.com/us/blog/sleepless-in-america/202106/what-is-revenge-bedtime-procrastination

### 2. งานวิจัย Kroese et al. 2014 — ✅ (ตัวงานมีอยู่จริง ยืนยันหลายแหล่ง) / ถ้อยคำละเอียด ⚠️ ตรวจต้นฉบับ
- Kroese, De Ridder, Evers, Adriaanse (2014) "Bedtime procrastination: introducing a new area of procrastination" Frontiers in Psychology 5:611, doi 10.3389/fpsyg.2014.00611 (ทีม Utrecht University)
  - https://research-portal.uu.nl/en/publications/bedtime-procrastination-introducing-a-new-area-of-procrastination/ , https://pubmed.ncbi.nlm.nih.gov/24994989/ , https://www.frontiersin.org/journals/psychology/articles/10.3389/fpsyg.2014.00611/pdf
- นิยาม (ตามที่รายงานผ่านงานตามหลัง/Scientific American): ไปนอนช้ากว่าที่ตั้งใจ โดยไม่มีเหตุภายนอกบังคับ (ทั้งที่รู้ว่าอาจเสียผล) — https://www.scientificamerican.com/article/it-goes-by-the-name-bedtime-procrastination-and-you-can-probably-guess-what-it-is/ , https://www.frontiersin.org/articles/10.3389/fpsyg.2018.00077/pdf
- ผลหลัก: คนที่คุมตัวเอง (self-regulation) ได้น้อยกว่า รายงานว่าผัดเข้านอนมากกว่า และการผัดเข้านอนที่รายงานเอง "ทำนาย" การนอนไม่พอโดยทั่วไป แม้ควบคุมตัวแปรประชากรและ self-regulation แล้ว (สหสัมพันธ์จากแบบสอบถาม) — ผู้เขียนบอกเองว่าข้อมูลสรุปเหตุ-ผลไม่ได้
  - ถ้อยคำปลอดภัยสำหรับบท: "งานวิจัยจากเนเธอร์แลนด์พบว่า คนที่ผัดเวลาเข้านอนมักจะนอนไม่พอ" (ห้าม: "ทำให้นอนไม่พอ/พิสูจน์ว่า")
  - กลุ่มตัวอย่าง: มีรายงานผ่านผลค้นว่า study 1 เป็นแบบสอบถามออนไลน์ MTurk และมีงานคู่ (BPS digest) ผู้ใหญ่ชาวดัตช์กว่า 2,000 คน ไดอารี่ 7 วัน แต่ **ตัวเลขนี้ไม่ได้ยืนยันกับต้นฉบับ = ⚠️ อย่าขึ้นจอ** https://www.bps.org.uk/research-digest/psychologists-investigate-major-ignored-reason-our-lack-sleep-bedtime

### 3. ไม่ใช่โรค/ซินโดรมทางการแพทย์
- Psychology Today เขียนตรงว่า revenge bedtime procrastination "is not a clinical diagnosis" — https://psychologytoday.com/au/blog/urban-survival/202303/questions-to-identify-revenge-bedtime-procrastination
- Dr. Michael Breus (นักจิตวิทยาการนอน) ไม่ปฏิเสธว่าพฤติกรรมมีจริง แต่เตือนไม่ให้เรียกเป็น psychological disorder/condition และให้แยกจากโรคนอนไม่หลับ — https://www.yahoo.com/now/revenge-bedtime-procrastination-sleep-doctor-220200123.html
- Sleep Foundation: sleep procrastination ยังเป็นแนวคิดที่เพิ่งเกิดในวิทยาการการนอน งานวิจัยยังอยู่ช่วงต้น และแนะนำให้พบแพทย์ถ้าปัญหานอนต่อเนื่อง (ไม่ได้เขียนคำว่า "ไม่ใช่การวินิจฉัย" ตรงๆ ในผลค้นที่เห็น) — https://www.sleepfoundation.org/sleep-hygiene/revenge-bedtime-procrastination
- สรุป: ไม่พบแหล่งใดที่จัดเป็นโรค/อยู่ในเกณฑ์วินิจฉัย; ไม่ได้เปิดดูเกณฑ์ DSM/ICD โดยตรง → ป้าย ✅ สำหรับประโยค "เป็นพฤติกรรมที่มีชื่อเรียก ไม่ใช่การวินิจฉัยทางการแพทย์" (2 แหล่ง: Psychology Today + Breus) แต่ ⚠️ สำหรับประโยค "ไม่อยู่ในเกณฑ์วินิจฉัยใดเลย" (ไม่ได้ตรวจเกณฑ์) → ใช้ถ้อยคำแรก
- Scientific American: ผู้เชี่ยวชาญบางคนเห็นว่า "revenge" version ไม่เกี่ยวกับการผัดเวลาจริงๆ — แปลว่านิยามยังถกเถียง

### 4. คำอธิบาย: กลางวันไม่มีเวลาของตัวเอง
- Cleveland Clinic (Dr. Alicia Roth, sleep psychologist): คนใช้ช่วงก่อนนอนทำสิ่งที่อยากทำ แลกกับการนอนที่ดี; มักทำเพื่อหาความสุขเล็กๆ หลังวันที่หนัก/เหนื่อย — https://newsroom.clevelandclinic.org/2023/12/18/what-is-revenge-bedtime-procrastination , https://health.clevelandclinic.org/revenge-bedtime-procrastination/
- Harvard Health: คนที่ทำเป็น "ขัดขืน" แรงกดดันเช่นงานไม่หยุดหรือภาระครอบครัว — https://www.health.harvard.edu/sleep/when-your-brain-takes-revenge-at-bedtime
- Nauts et al. 2019 (Behavioral Sleep Medicine 17(6):753-762, สัมภาษณ์ 17 คนที่เลื่อนนอนบ่อย ไม่มีโรคนอนที่วินิจฉัย/ไม่ทำกะ): พบ 3 ธีม คือ deliberate (เจตนาเลื่อน เพราะรู้สึกว่า "สมควรได้เวลาของตัวเอง"), mindless (เพลินจนลืมเวลา), strategic delay (เชื่อว่าเลื่อนแล้วหลับเร็วขึ้น; ผู้เขียนชี้ว่าอาจเป็นสัญญาณนอนไม่หลับที่ยังไม่ได้วินิจฉัย) — ป้าย ✅ ว่ามีงานนี้ (หลายแหล่ง) แต่เป็นงานสัมภาษณ์เล็ก ต้องพูดว่า "งานวิจัยหนึ่งที่สัมภาษณ์คน 17 คน"
  - https://research.vu.nl/en/publications/the-explanations-people-give-for-going-to-bed-late-a-qualitative-/ , https://research-portal.uu.nl/en/publications/the-explanations-people-give-for-going-to-bed-late-a-qualitative-/ , DOI 10.1080/15402002.2018.1491850
- Self-control ตอนเหนื่อย: Kamphorst, Nauts, De Ridder, Anderson 2018 "Too depleted to turn in" (Frontiers in Psychology) สำรวจออนไลน์ MTurk พบว่าคนที่บอกว่าวันนั้นพยายามต้านความอยากมากกว่า มักผัดเวลาเข้านอนมากกว่า (สหสัมพันธ์) — ⚠️ ชิ้นเดียว; ตัวเลขตัวอย่างไม่ตรงกันในผลค้น (218 กับ 245) ห้ามพูดตัวเลข
  - **ระวัง ego depletion เป็นทฤษฎีที่ถูกโต้แย้ง:** ผู้เขียนเองระบุว่าไม่ต้องการมองข้ามคำอธิบายอื่นหรือลดทอนข้อโต้แย้งต่อแนวคิด "กล้ามเนื้อแห่งแรงใจ" ไม่ควรพูดเป็นข้อเท็จจริงว่า "แรงใจหมดแบตตอนเย็น" → พูดแบบ "งานวิจัยหนึ่งพบว่า วันที่ต้องอดทนต้านใจมาก คนมักเลื่อนนอนมากกว่า"
  - https://frontiersin.org/articles/10.3389/fpsyg.2018.00252/full , https://pmc.ncbi.nlm.nih.gov/articles/PMC5890113 (PMC อาจถูกบล็อก ใช้ Frontiers/ศูนย์วิจัย UU)
- "พบบ่อยในคนทำงานชั่วโมงยาว/นักเรียน": **ไม่พบแหล่งคุณภาพสูงที่วัดว่ากลุ่มใดพบบ่อยที่สุด** Sleep Foundation ระบุว่ายังไม่แน่ชัดว่าใครได้รับผลมากสุด → ❌ ห้ามพูดว่า "พบบ่อยในคนกลุ่มนี้"; พูดได้แค่ว่าชื่อมาจากบริบทงานหนักในจีน (ข้อ 1)

### 5. "ยังไม่ง่วง" = จริงๆ ไม่อยากเลิกทำสิ่งที่ทำ/ไม่อยากให้วันจบ
- ธีม "deliberate" ของ Nauts 2019 รองรับครึ่งหนึ่ง: คนเลื่อนนอนเพราะรู้สึกว่าสมควรได้เวลาตัวเอง และ "mindless" คือเพลินจนลืมเวลา — ป้าย ⚠️ (งานสัมภาษณ์ 17 คน)
- **ไม่พบงานวิจัยที่ทดสอบตรงๆ ว่า "ความรู้สึกยังไม่ง่วง" แท้จริงคือ "ไม่อยากให้วันจบ"** ประโยคนี้เป็นการตีความ ไม่ใช่ข้อค้นพบ → ❌ ห้ามพูดเป็นข้อเท็จจริง ใช้เป็น "คำถามชวนคิด" ได้เท่านั้น เช่น "บางทีที่ยังไม่ง่วง อาจเป็นเพราะเรายังไม่ได้ใช้วันนี้เพื่อตัวเองเลย" (ใส่ "บางที/อาจ" และอิงงานสัมภาษณ์)

### 6. ตัวเลขโพล (ห้ามขึ้นจอถ้าป้าย ⚠️; ตัวเลขบนจอต้อง ✅)
- โพล Talker Research (รับจ้างโดย Avocado Green Mattress) ชาวอเมริกัน 2,000 คน เผยแพร่ ม.ค. 2026: 96% บอกว่าตั้งใจนอนดึกเพื่อเวลาส่วนตัวแม้รู้ว่าเสียการนอน; ค่าเฉลี่ย 3.5 คืน/สัปดาห์; 63% บอกว่ากลางคืนเป็นเวลาเดียวที่มีให้ตัวเอง; ชั่วโมงนอนที่เสียต่อปี แหล่งสองแห่งรายงานไม่ตรงกัน (AOL ~332 ชม., iHeart ~322 ชม.) — ป้าย ⚠️ (โพลเชิงพาณิชย์ รายงานผ่านสื่อ ยังไม่ได้อ่านรายงานต้นฉบับ ตัวเลขชั่วโมงขัดกัน)
  - https://talkerresearch.com/sleep-thieves-americans-lose-hundreds-of-hours-a-year-to-late-night-scrolling/ , https://www.aol.com/articles/revenge-bedtime-procrastination-could-costing-180915324.html , https://993thefox.iheart.com/content/2026-01-13-americans-lose-over-300-hours-of-sleep-a-year-to-this/
  - ถ้าจะใช้ในบท: "โพลของบริษัทที่นอนในสหรัฐฯ ปี 2026 ที่สำรวจ 2,000 คน พบว่า 63% บอกว่ากลางคืนเป็นเวลาเดียวที่เป็นของตัวเอง" (พูดเป็นเสียงได้ แต่ไม่ขึ้นเป็นกราฟิกตัวเลข) แนะนำ **ข้ามตัวเลขโพล** เพราะ short สั้นและเป็นโพลสปอนเซอร์
- โพล Sleepopolis (พ่อแม่ 95.33%) ไม่พบขนาดตัวอย่าง/ปี = ❌ ห้ามใช้
- โพล "78% ของ 2,000 คนยอมรับ revenge sleep procrastination" (Sleep Review/Yahoo) ไม่พบผู้สำรวจ/ปีชัด = ❌ ห้ามใช้

### 7. ทริก (คำแนะนำผู้เชี่ยวชาญ = ⚠️ ไม่ใช่ผลทดลอง)
| ทริก | ใครแนะนำ | ป้าย | ลิงก์ |
|---|---|---|---|
| ตั้งเวลาเตือน/นาฬิกาปลุกให้วางอุปกรณ์ + เข้านอนเวลาสม่ำเสมอ | Dr. Alicia Roth (Cleveland Clinic) ผ่าน NPR/ผลค้น | ⚠️ ความเห็นผู้เชี่ยวชาญ | https://www.npr.org/2022/06/14/1105122521/stop-revenge-bedtime-procrastination-get-better-sleep , https://health.clevelandclinic.org/revenge-bedtime-procrastination/ |
| จำกัดเวลาพักผ่อนช่วงเย็นราว 30 นาที ใช้ปลุก/ตัวตั้งเวลาปิดทีวี | Dr. Jennifer Martin (นักวิจัยการนอน) | ⚠️ | ผลค้นอ้างจาก NPR เดียวกัน |
| จัดเวลาสนุก/พัก/จัดการความเครียดช่วงกลางวัน (ตีกรอบเวลาก่อนนอน + จัดการความเครียดกลางวัน) | Henry Ford Health, GoodRx, Nike (บทความ) | ⚠️ | https://www.henryford.com/blog/2025/09/revenge-bedtime-procrastination , https://www.goodrx.com/well-being/sleep/revenge-bedtime-procrastination |
| กิจวัตรผ่อนคลายก่อนนอน (อาบน้ำอุ่น เปลี่ยนชุดนอน อ่านหนังสือ ปลอดหน้าจอ) | NPR (Whitehurst), Cleveland Clinic | ⚠️ | https://www.npr.org/2022/06/14/1105122521/stop-revenge-bedtime-procrastination-get-better-sleep |
- ทริกที่เหมาะเป็น "ข้อน่าส่งต่อ": **"จองเวลาของตัวเองไว้ตอนเย็นหรือระหว่างวันก่อน (เช่น 30 นาที) จะได้ไม่ต้องไปเอาจากเวลานอน"** ไม่ซ้ำกับตอนเก่า (ไม่ใช่จด to-do) — ป้าย ⚠️ พูดว่า "ผู้เชี่ยวชาญแนะนำว่า..."
- ผู้เชี่ยวชาญ/Cleveland Clinic: ถ้าไม่ดีขึ้นให้ปรึกษาแพทย์ปฐมภูมิ → ใส่ประโยค "ถ้าเป็นบ่อยจนกระทบชีวิต หรือนอนไม่หลับจริงๆ ลองปรึกษาแพทย์" (ต้องมีในบทตามกฎสุขภาพ)

### 8. ผลเสียของการนอนน้อย (ไม่ขู่เกินจริง)
- CDC: ราว 35% ของผู้ใหญ่สหรัฐฯ รายงานว่านอนไม่ถึง 7 ชม. (ข้อมูลปี 2020 จาก CDC indicator; self-report) และการนอนไม่พอสัมพันธ์กับความเสี่ยงโรคหลายอย่าง — https://www.cdc.gov/cdi/indicator-definitions/sleep.html , https://www.cdc.gov/sleep/
- ผลระยะสั้นที่พบบ่อย: สมาธิลดและขี้ลืม (ผลค้นอ้างสำรวจ CDC 2011 ผ่านสื่อ ข้อมูลเก่า) — ป้าย ⚠️ สำหรับตัวเลข ✅ สำหรับประโยคทั่วไป
  - ประโยคปลอดภัย: **"นอนไม่พอ ตื่นมาก็เพลีย สมาธิก็ลดลง"** (CDC + Sleep Foundation) ห้ามใส่เปอร์เซ็นต์/โรค
  - ข้อควรระวัง: ไม่ได้เปิดหน้า CDC ต้นฉบับเต็ม เห็นเพียงสรุปจากผลค้น

## ประเด็นน่าสนใจสำหรับ hook
1. "ตี 2 แล้ว ยังไม่ง่วง? ... หรือจริงๆ ไม่อยากให้วันนี้จบ" (คำถามชวนคิด ไม่ใช่ข้อเท็จจริง ใช้ได้ ตามที่ผู้ใช้กำหนดคำเปิด "ฮั่นแน่ ยังไม่นอนกันอีกหรอ")
2. นอนดึกแบบนี้มีชื่อเรียก และชื่อมาจากภาษาจีน แปลว่า "นอนดึกเพื่อแก้แค้น" (ข้อ 1 ⚠️ สำหรับรายละเอียดต้นทาง ✅ สำหรับว่ามีชื่อเรียก)
3. "ไม่ใช่โรค แต่เป็นพฤติกรรมที่มีชื่อเรียก" (ข้อ 3 ✅)
4. นักวิจัยดัตช์ตั้งชื่อ "ผัดเวลาเข้านอน" ตั้งแต่ปี 2014 ก่อนคำว่า revenge จะดังในโซเชียล (ข้อ 2 ✅)
5. งานสัมภาษณ์หนึ่งพบว่าบางคนเลื่อนนอนเพราะรู้สึกว่า "สมควรได้เวลาของตัวเองบ้าง" (ข้อ 4 ✅ ว่ามีงาน / ⚠️ ขนาดเล็ก)

## หักมุมที่ใช้ได้ (เลือก 1)
- **หักมุม A (แนะนำ) ⚠️:** "ที่ว่ายังไม่ง่วง บางทีไม่ใช่ว่าร่างกายไม่ล้า แต่เพราะทั้งวันยังไม่มีเวลาเป็นของตัวเองเลย" — อิงธีม "deliberate" ของ Nauts 2019 + คำอธิบายผู้เชี่ยวชาญ Cleveland Clinic ต้องใช้คำ "บางที/ผู้เชี่ยวชาญมองว่า" ห้ามพูดเป็นข้อค้นพบ
- **หักมุม B ⚠️:** ผู้เขียนงานสัมภาษณ์เองชี้ว่า "นอนดึกเพราะเชื่อว่าจะหลับเร็วขึ้น" อาจเป็นสัญญาณนอนไม่หลับ ไม่ใช่ revenge — ใช้ถ้าอยากหักมุมแบบ "แยกให้ออก" แต่ยาวเกินสำหรับ short 25-40 วิ

## ข้อน่าส่งต่อ (1-2)
1. ทริก "จองเวลาส่วนตัว 30 นาทีไว้ตอนเย็น แล้วตั้งปลุกบอกเวลาเลิก" (⚠️ ผู้เชี่ยวชาญแนะนำ: Martin / Roth / Henry Ford)
2. "ไม่ใช่โรค แต่เป็นพฤติกรรมที่มีชื่อ — ถ้ามันเป็นบ่อยจริงๆ ไม่ได้แปลว่าคุณขี้เกียจ แต่อาจเป็นสัญญาณว่าตารางกลางวันไม่เหลือที่ให้ตัวเอง" (ตีความ ใช้ "อาจ" ตามที่ Cleveland Clinic บอกว่าอาจเป็นสัญญาณว่ากิจวัตรไม่ตอบโจทย์)

## ห้ามพูด
- "เป็นโรค/ซินโดรม/อาการ" (ต้องพูด "ไม่ใช่โรค")
- "งานวิจัยพิสูจน์ว่านอนดึกเพราะเสียดายเวลา" / "ทำให้นอนไม่พอ" (สหสัมพันธ์ ไม่ใช่เหตุ-ผล)
- ปีเกิดของคำจีน (2014 / 2018 / 2020) ว่าเป็นข้อเท็จจริง — แหล่งขัดกัน; 2020 ใช้ได้เฉพาะ "แพร่ในภาษาอังกฤษปี 2020 จากทวีตของ Daphne K. Lee" (⚠️)
- "พบบ่อยที่สุดในคนทำงานหนัก/นักเรียน" ไม่พบแหล่งวัด
- "แรงใจ/สมองหมดแบตตอนเย็น" เป็นข้อเท็จจริง (ego depletion ถกเถียง)
- "ยังไม่ง่วง แปลว่าไม่อยากให้วันจบ" เป็นข้อเท็จจริง (ไม่พบงานทดสอบตรง)
- ตัวเลขโพล (96%, 63%, 300+ ชม./ปี, 78%, 95%) ขึ้นเป็นกราฟิก; ตัวเลขชั่วโมงขัดกัน (332 vs 322)
- ตัวเลข 2,000 คนของงานดัตช์ หรือ N ของ Kamphorst (218/245) ยังไม่ยืนยัน
- ตัวเลข % ผลเสียนอนน้อย (23%/29%/19% ปี 2011 ข้อมูลเก่า) และรายการโรคเรื้อรังจากการนอนน้อย (ขู่เกิน)
- คำแนะนำการแพทย์เกินแหล่ง (ยา, melatonin, ปริมาณชั่วโมงนอนที่ "ต้องได้")

## ภาพที่ควรใช้ (คำค้นอังกฤษสำหรับฝ่าย footage; ห้ามโลโก้แอปบนจอ)
- person on phone in dark bedroom at night
- scrolling smartphone in bed night face lit by screen
- laptop open in dark room late night
- digital clock 2am bedroom
- alarm clock 1:00 night
- empty bed made at night
- tired person morning yawning alarm clock
- person rubbing eyes at desk morning sleepy
- night city window lights apartment
- woman lying awake in bed looking at ceiling
- hand turning off lamp bedside
- calendar time block planner evening relax (สำหรับข้อน่าส่งต่อ)
- warm bath / reading book before bed (กิจวัตรก่อนนอน)
- ภาพสมอง/นาฬิกา/สมดุลเวลา เป็นกราฟิก (ทำเอง ไม่ต้องค้น footage)

## แหล่งที่ใช้ (รวม)
- Kroese et al. 2014: https://research-portal.uu.nl/en/publications/bedtime-procrastination-introducing-a-new-area-of-procrastination/ , https://pubmed.ncbi.nlm.nih.gov/24994989/ , https://www.frontiersin.org/journals/psychology/articles/10.3389/fpsyg.2014.00611/pdf
- BPS digest: https://www.bps.org.uk/research-digest/psychologists-investigate-major-ignored-reason-our-lack-sleep-bedtime
- Kamphorst et al. 2018: https://frontiersin.org/articles/10.3389/fpsyg.2018.00252/full
- Nauts et al. 2019: https://research.vu.nl/en/publications/the-explanations-people-give-for-going-to-bed-late-a-qualitative-/
- Scientific American: https://www.scientificamerican.com/article/it-goes-by-the-name-bedtime-procrastination-and-you-can-probably-guess-what-it-is/
- Cleveland Clinic: https://health.clevelandclinic.org/revenge-bedtime-procrastination/ , https://newsroom.clevelandclinic.org/2023/12/18/what-is-revenge-bedtime-procrastination
- Sleep Foundation: https://www.sleepfoundation.org/sleep-hygiene/revenge-bedtime-procrastination
- Harvard Health: https://www.health.harvard.edu/sleep/when-your-brain-takes-revenge-at-bedtime
- Psychology Today: https://psychologytoday.com/au/blog/urban-survival/202303/questions-to-identify-revenge-bedtime-procrastination , https://www.psychologytoday.com/us/blog/sleepless-in-america/202106/what-is-revenge-bedtime-procrastination
- NPR: https://www.npr.org/2022/06/14/1105122521/stop-revenge-bedtime-procrastination-get-better-sleep
- CDC: https://www.cdc.gov/cdi/indicator-definitions/sleep.html
- Talker Research โพล: https://talkerresearch.com/sleep-thieves-americans-lose-hundreds-of-hours-a-year-to-late-night-scrolling/
