# Handoff: ห้องวางแผน Creative (อัปเดต 2026-11-19)

อ่านไฟล์นี้ไฟล์เดียวพอเริ่มงาน รายละเอียดเพิ่มเติมดู `docs/strategy-notes.md` (อ่านเฉพาะส่วนที่ต้องใช้) และ `channels/knowledge/results.md`

## บทบาทห้องนี้
- วางแผน content + creative จากสถิติ ไม่ทำคลิปเอง ไม่เรนเดอร์
- ทำคลิป = เปิดห้องแยกทุกครั้ง (`create_session`, repo Peerapol147/AI-Studio, revision `claude/stoic-cray-6z2ajs`, model claude-opus-5-5) พร้อม brief สั้น ผู้ใช้สั่งชัด: "แยกเซสชันทุกครั้ง"
- แก้กฎ (style.md, make-clip, results.md) = เขียนบน branch `claude/content-strategy` → ผู้ใช้อนุมัติ → `send_message` ให้ห้องหลัก `session_016zMkaT6ty2y1hbUUTjbnt7` ตรวจ+รวม (fast-forward) → `git rebase origin/claude/stoic-cray-6z2ajs` หลังรวม
- ผู้ใช้ส่งภาพ Analytics → จดลง results.md (commit+push branch นี้) สรุปแนวโน้มมีตัวเลข ตามกฎ skill `reality-check` (content-review.md ข้อ 3: ห้ามสรุปจาก <3 คลิป/<48 ชม., เทียบคลิปอายุเท่ากัน, บอกตัวแปรปน, ความมั่นใจ, อะไรจะเปลี่ยนใจ)
- ตอบไทย กระชับ ตารางตัวเลข ไม่เดา ไม่เอนตามผู้ใช้ (ผู้ใช้ขอเอง) แต่ไม่เทศนาซ้ำเรื่องที่ผู้ใช้ตัดสินแล้ว

## สถานะช่อง (knowledge, Shorts ไทยอย่างเดียว)
- 28 วัน 7.6K วิว, ผู้ติดตาม 15, ฟีด Shorts 95%, ผู้ชมใหม่ 99%, ชาย 25-34
- อันดับ: วอมแบต 2.9K (แปลก+ขำ+เล่าต่อได้) > เดินลงเขา/ผู้สูงอายุ/หักนิ้ว ~1.3-1.5K; ทุกคลิปหยุดที่ 1.2-3K
- Stayed to watch มีข้อมูลแค่ 2 คลิป (52.5%, 62.2%) เป้า ≥70%
- รอ Analytics 48 ชม.: แมวกลัวน้ำ (27.1 วิ, กฎใหม่ตอนแรก), Brainrot v3 (35.3 วิ, ทดลองความยาว), ตดในอวกาศ (ห้อง `session_016zMkaTBbFRWL5XF9dqCANQ` ทำข้ามคืน)

## กฎที่รวมเข้า main แล้ว (ผู้ใช้อนุมัติ)
- หัวข้อผ่านเมื่อ: Shorts ไทย ≥100K หรือต่างประเทศ ≥1M และ ≥2 คลิปจากคนละช่อง; กลุ่มที่ไทยปัง: แมว, อวกาศ/ร่างกายในอวกาศ, ร่างกายน่าทึ่ง, ความเชื่อโบราณ; พักความเชื่อสุขภาพ (~1K)
- ความยาว ≤40 วิ เน้นคุณภาพ สั้นด้วยการลดประเด็น (1 ความเชื่อ+1 หลักฐาน+1 ทริก) ไม่ตัดคำ
- บทพูดภาษาพูดเต็มประโยค อธิบายศัพท์ทันที คำที่คนไทยพูดจริง (style.md "บทพูดแบบที่ผู้ใช้ต้องการ")
- hook 3 แบบ เลือกด้วยเทสต์ปิดเสียง 1 วิ; เฟรม 0 เห็นหน้า/ตา + สิ่งที่ถาม
- แม่แบบตัดต่อหลัก `templates/brainrot-v2/` (ผู้ใช้ "โคตรชอบ": ช็อต ~1.4 วิ, พากย์พาวนกลับ hook)
- safe zone 1080×1920 สำหรับ YT/TikTok/FB-IG; ล้มเร็ว (tools/get.sh); upload.md แยก 3 แพลตฟอร์ม
- วัดที่ 48 ชม.: >5K ทำภาคต่อ, <1.5K ทบทวน (พักแนวเมื่อต่ำ 2 คลิปติด)

## ข้อจำกัดเงิน (สำคัญ)
- ผู้ใช้งบจำกัด (เงินจริง) ห้องทำคลิปตอนแมว ~$20 เทียบ API, เป้า ≤$10-20/คลิป
- ElevenLabs = free tier (10K ตัวอักษร/เดือน, ไม่มีสิทธิ์เชิงพาณิชย์) ผู้ใช้เลือกใช้ฟรีต่อ (ตัดสินแล้ว ไม่ต้องพูดซ้ำ) จะอัปเกรดเมื่อเปิดหารายได้ → เตือนก่อนสมัคร YPP; เช็กโควตา: `curl -s -H "xi-api-key: dummy" https://api.elevenlabs.io/v1/user/subscription`
- brief ทุกตอน: ล็อกบทก่อนอัด อัดเทคเดียว

## ค้างอยู่ / รอผู้ใช้
- ข้อเสนอ 5 (ใช้ของใหม่: เป้าต้นทุน, ช็อต ≤1.8 วิ ด้วยกราฟิก vendor) ยังไม่อนุมัติ
- แถบคำถามค้างจอทั้งคลิป: เลื่อนไปหลังวัดผลหัวข้อใหม่ 3 คลิป
- อนิเมะ 2D (ห้อง STUDIO ANIME 2d บนเครื่องผู้ใช้, playbook ใน strategy-notes): เสนอเป็นซีรีส์ทดลอง ≤45 วิ หัวข้อผ่านเกณฑ์ ยังไม่ตัดสิน; ส่งข้อความหาห้องนั้นไม่ได้ (ต้องให้ผู้ใช้อนุญาต)
- ลงคลิปเดิมใน TikTok/FB (ผู้ใช้ทำเอง)

## เครื่องมือ/skill (ทั้ง 20 skill อยู่ใน `.claude/skills/` ห้องนี้เรียกได้ทุกตัว)
ค้นยอดวิว: `python3 -I tools/yt_views.py "คำค้นไทย"`; อังกฤษ: `curl -s -A "Mozilla/5.0" "https://www.youtube.com/results?search_query=<q>&sp=EgIYAQ%253D%253D&hl=en&gl=US" | grep -oE '"accessibilityText":"[^"]{0,110}views[^"]*"'`

**วางแผน/วิเคราะห์ (ใช้เอง)**
| skill | ใช้ทำ |
|---|---|
| reality-check | ทุกการวิเคราะห์สถิติ/เลือกแนว (content-review.md: ลำดับแหล่ง, ป้าย ✅⚠️❌, กฎอ่านสถิติ, ระดับ 🔴🟡⚪) |
| yt-content-planner | แผนลงคลิปรายสัปดาห์ ซีรีส์ |
| yt-hook-scripter | ร่าง hook 3 วิแรก (ใส่ใน brief) |
| yt-title-optimizer / yt-thumbnail-brief / yt-description-writer | ชื่อ ปก คำอธิบาย (ห้ามขั้น publish) |
| caveman | ตอบแชตสั้น (ห้ามใช้กับ brief/บท) |

**สายพานทำคลิป (ห้องทำคลิปใช้ ห้องนี้ต้องรู้เพื่อเขียน brief ให้ถูก ห้ามทำเอง)**
| skill/agent | หน้าที่ในสายพาน |
|---|---|
| make-clip | ขั้นตอนหลัก 0-7 (หัวข้อ → brief+research → บท+สตอรีบอร์ด → เสียง+footage → ตัดต่อ → ตรวจ → ส่งมอบ) + กฎประหยัด token + ตารางปัญหาที่เจอแล้ว อ่านก่อนเขียน brief ทุกครั้ง; ลำดับละเอียด `docs/pipeline.md` |
| agents: researcher, footage, voice, editor, reviewer | `.claude/agents/` ผู้กำกับในห้องทำคลิปเรียกใช้ |
| hyperframes, hyperframes-cli | เรนเดอร์ HTML → MP4 |
| hyperframes-registry | บล็อกสำเร็จรูป ~450 ตัว (ทรานซิชัน kinetic type glitch ชาร์ต) ดูว่ามีอะไรให้เสนอใน creative |
| media-use | หาเพลง/เสียง/ภาพ/เสียงพากย์ |
| sound-effects | ใส่ SFX + มิกซ์ -16 LUFS |
| motion-broll | กราฟิกรูปทรงเดียว morph ต่อเนื่อง (กฎ Motion v2) |
| explainer-engaging, style-sampling | สไตล์ explainer ต่อเนื่อง / สไตล์สำเร็จรูป (ใช้เมื่อเสนอสไตล์ใหม่) |
| reverse-any-video, remotion-to-hyperframes, figma, slideshow | งานเฉพาะทาง แทบไม่ได้ใช้ |
| แม่แบบ `templates/brainrot-v2/` | ตัดต่อหลักที่ผู้ใช้ชอบ |
| tools/: tts.sh words.sh trim_silence.sh footage.sh music.sh get.sh shot_times.py sound_pass_vo.py | เครื่องมือสายพาน |

**brief ที่ดี (สั้นแต่ครบ):** หัวข้อ + ผลค้นเกณฑ์ (ยอดวิว+ช่อง) + มุมความเชื่อ vs ความจริง + เฟรม 0 + ข้อห้ามลิขสิทธิ์ + โควตาเสียง (ล็อกบท อัดเทคเดียว) + ทำจบเองหรือรอผู้ใช้ — ดูตัวอย่าง brief ตอนตดในอวกาศใน strategy-notes / ห้อง `session_016zMkaTBbFRWL5XF9dqCANQ`
