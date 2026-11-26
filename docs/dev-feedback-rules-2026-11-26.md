# ห้อง dev: แปลง feedback ตอน palmaris เป็นกฎ/เครื่องมือในแม่แบบกลาง (2026-11-26)

ที่มา: `projects/2026-11-25-knowledge-palmaris-test/feedback.md` (branch `claude/ep-2026-11-25-palmaris-test`)
branch: `claude/dev-feedback-rules-2026-11-26` แตกจาก `claude/stoic-cray-6z2ajs` @ `7341c6e` (ยังไม่ merge: รอห้องตรวจอิสระ แล้วห้องวางแผน fast-forward)
ไม่แตะ `projects/` ของตอนไหนเลย, ไม่แตะ feedback ข้อ 10 (reverse-any-video)

## ทำอะไร (1 commit ต่อข้อ)
| ข้อ | commit | ทำอะไร | ไฟล์ |
|---|---|---|---|
| 1 ล็อกเสียง (feedback 9) | `3701619` | `looks.json` มี `channel_lock.knowledge` = voice george, tts_model eleven_v3, atempo 1.1, vo_lufs -18; `look.py pick` ไม่สุ่มด้านที่ล็อก (เขียนค่าล็อกลง look.json), `check` ERROR ถ้าต่าง (ค่าไม่ใช่แกนที่ไม่ได้ใส่ = WARN, `--final` = ERROR) และ**ไม่นับเสียงซ้ำเป็นข้อผิด/WARN**; กฎไม่ซ้ำด้านอื่น (สี ฟอนต์ ซับ โครงเปิด ปก ทรานซิชัน เพลง ข้อความปก) เหมือนเดิมทุกข้อ (มีเทสต์ยืนยัน); ช่องที่ไม่ล็อก (football) ยังหมุนเสียง; `tools/vo_finish.sh` ใหม่ = atempo + loudnorm 2 รอบ | `templates/looks/looks.json`, `tools/look.py`, `tools/vo_finish.sh`, `channels/knowledge/channel.md`, `style.md` ข้อ 5, `.claude/agents/voice.md`, make-clip 4a, `docs/editing-v3.md` |
| 2 มิกซ์ (feedback 4) | `5c0b0ab` | `sound_pass_vo.py` ค่าเริ่มต้น `--music-db -24` `--duck-db 8`; วัด LUFS พากย์/เพลงลง SOUND.md + `WARN` ถ้าพากย์ไม่ใกล้ -18 (±2) หรือเพลงต่ำกว่าพูด < 12 LU; ขั้นตอน normalize พากย์ -18 LUFS ก่อน words (`vo_finish.sh`) | `tools/sound_pass_vo.py`, make-clip "มิกซ์เสียง", editor, reviewer |
| 3 ปก (feedback 7-8) | `1574733` | เฟรม 0 กฎเดิม (เข้าใจใน 1 วิ ปิดเสียง); ปกที่อัป = แยก 2 แบบ A/B แนว curiosity ทุกตอน (`look.json` `"covers"`); แม่แบบ `templates/brainrot-v3/cover.html` (`?v=a/b`, `data-cover=text/badge/art`); `tools/cover_shot.js` ถ่ายภาพ + วัดกรอบหมึกตัวอักษรจริง; `tools/cover_check.py`: ≤2 บรรทัด, คำซ้ำ (token หรือคำไทย ≥3 ตัวอักษรซ้ำ), A = B, คล้ายปก/เฟรม 0 ทุกตอนก่อน (≥0.6), ทับกัน/ชนขอบ 40 px/ล้น, ขนาดตัวอักษรที่ย่อ 200 px (≥9 px), contrast ที่ 200 px, ทำ `covers/compare.png` เทียบปกเก่า (อ่านจาก projects/*/covers และ branch ep); `cover_check.py log` จด CTR → `channels/knowledge/cover-ctr.md` | `tools/cover_check.py`, `tools/cover_shot.js`, `templates/brainrot-v3/cover.html`, `channels/knowledge/cover-ctr.md`, style.md ข้อ 9a, make-clip 3/5/7, editor, reviewer, `docs/pipeline.md`, TEMPLATE.md |
| 4 Hook (feedback 3) | `6833121` | hook ต้องมีอย่างน้อย 1: เดิมพัน / คำแปลก / ขัดกับที่เชื่อ; ตัวอย่างชนะ/แพ้; ทดสอบ "ตอบมี/ไม่มีแล้วจบ = ไม่ผ่าน"; hook 3 แบบจดว่าใช้ข้อไหน | style.md ข้อ 1, make-clip ขั้น 3, `yt-hook-scripter/SKILL.md` (กฎโปรเจกต์), reviewer |
| 5 Footage (feedback 2) | `2103dd6` | `tools/footage_search.py search`: Pixabay/Pexels/Openverse/NASA/Wikimedia × video/photo ต่อคำ, คำไทยส่ง `lang=th`, ข้ามไฟล์ Wikimedia ที่ไม่ใช่ CC/PD, จด `assets/footage/SEARCH.json`; 429 ลองซ้ำ 2 ครั้ง (3, 9 วิ) แล้วข้ามแหล่งนั้นทั้งรอบ; `report`: ช็อตที่ไม่มีไฟล์ต้องค้น ≥10 คำ ไทย+อังกฤษ วิดีโอ+ภาพนิ่ง ≥2 แหล่ง (exit 1), ได้ < 50% ของช็อต = exit 2 + `ALERT.md` (ทางเลือก กราฟิก / มือ rig / ผู้ใช้ถ่ายเอง / ค้นต่อ) ผู้กำกับต้องแจ้งผู้ใช้ทันที; ช็อตกราฟิกตามแผนใส่ `"footage": false` | `tools/footage_search.py`, `.claude/agents/footage.md`, make-clip 4b + ล้มเร็ว + ปัญหาที่เจอ, voice/researcher (ลำดับสำรอง) |
| 6 ตรวจทุกเฟรม (feedback 1) | `89b142a` | `tools/contact_sheet.py make`: เฟรมทุก 0.25 วิ แผ่นละ 10 วิ เวลาใต้เฟรม กรอบแดง = ภาพนิ่ง >0.5 วิ (วัดสัดส่วนพิกเซลที่เปลี่ยน; push-in ช้าไม่ถูกนับ), INDEX.md; `verify`: review.md ต้องมี `## ตรวจภาพทุกเฟรม` บรรทัดละแผ่นพร้อมโน้ต; reviewer **ไม่ทำตามคำสั่งให้ข้ามด้านภาพ**; ผู้กำกับต้องดูทุกแผ่นเองก่อนส่ง | `tools/contact_sheet.py`, reviewer, editor, make-clip (ก่อนส่ง + ขั้น 6), TEMPLATE.md |
| 7 มือ SVG rig (feedback 6) | `3a31c7e` | `templates/brainrot-v3/compositions/components/hand-rig/`: `hand.js` (คัดลอกไม่แก้จาก palmaris), `hand-rig.css` (สีผิวจาก palette), `demo.html?pose=rest|test|flex`, README (API, ตาราง state, กติกา, สิ่งที่ไม่ผ่าน) | คอมโพเนนต์, style.md Motion, editor, make-clip, TEMPLATE.md |

## เทสต์
`python3 -m pytest tests/ -q` → **106 passed, 0 skipped** (ก่อนเริ่ม 88 passed, 1 skipped: ติดตั้ง librosa/soundfile แล้ว `test_sound_pass_vo` จึงรันจริง)
เทสต์ใหม่/เพิ่ม: `test_look.py` (+3: ล็อก George/โมเดล/atempo, ช่องไม่ล็อกยังเตือนเสียงซ้ำ + หมุนเสียง), `test_vo_finish.py`, `test_sound_pass_vo.py` (ค่ามิกซ์ + WARN),
`test_cover_check.py` (7 รวมถ่ายแม่แบบ cover.html จริงด้วย playwright), `test_footage_search.py` (3, mock server ไม่เรียก API จริง), `test_contact_sheet.py`, `test_hand_rig.py` (2)
ดูภาพจริงด้วยตาแล้ว: ปกแม่แบบ A/B + compare.png, contact sheet (ภาพนิ่งกรอบแดงถูกช่วง), มือ 3 ท่า

## ข้อที่ทำไม่ได้ / ข้อควรรู้
- **Pexels ยังใช้ไม่ได้:** ไม่มี `PEXELS_API_KEY` ใน environment (api.pexels.com ต่อได้ ตอบ 401) tool ข้ามและจดว่า skipped; ถ้าผู้ใช้อยากได้ ให้สมัคร key ฟรีแล้วใส่ env/`.env` (ห้าม commit)
- **Openverse / Wikimedia ตอบ 429 จากเครื่องนี้ตอนทดสอบ (2026-11-26)** = ตรงกับที่ palmaris เจอ backoff 3+9 วิช่วยได้แค่ rate limit สั้นๆ ถ้ายังโดน แหล่งอื่นยังทำงาน (NASA 200, Pixabay ใช้ key ที่มีอยู่)
- **ขัดกับกฎเดิม "429 ครั้งเดียว = เลิกทันที ห้าม sleep" (ผู้ใช้สั่งหลังตอนแมว):** brief นี้ขอ retry backoff จึงทำเป็นข้อยกเว้นเฉพาะ `footage_search.py` จำกัดรอรวม ≤12 วิต่อแหล่ง ไม่รอ retry-after ยาว แล้วข้ามแหล่งทั้งรอบ เขียนข้อยกเว้นไว้ในกฎล้มเร็วของ make-clip/footage.md; ห้องวางแผนตัดสินใจได้ว่าจะคงไว้ไหม
- **วัด CTR อัตโนมัติไม่ได้:** ไม่มีสิทธิ์ YouTube Studio/Analytics ผู้ใช้ต้องอ่าน CTR แล้วผู้กำกับจดด้วย `cover_check.py log`; A/B จริงต้องใช้ "Test & compare" ของ YouTube (ผู้ใช้อัปเอง) หรือสลับปกกลางทาง
- เช็ก "ย่อ 200 px แล้วยังอ่านออก" เป็นตัวเลขแทน (ขนาดตัวอักษร + contrast ในกรอบข้อความ) ไม่ใช่ OCR; ยังต้องให้คนดู `compare.png`
- เช็กคำซ้ำภาษาไทยจับคำ ≥3 ตัวอักษร (เช่น "ร่างกาย", "เส้นนี้"); คำ 2 ตัวอักษรซ้ำ (เช่น "ผี" ใน "ผีอำ = ผีจริง?") ไม่จับ เพื่อกัน false positive
- ปกเก่าก่อนวันนี้ไม่มีไฟล์ภาพใน git (`renders/` ถูก ignore) `compare.png` จะมีปกเก่าเมื่อตอนต่อไป commit `covers/*.jpg` ตามกฎใหม่; ตอนนี้ tool WARN ให้เทียบกับหน้าช่องด้วยตา
- look.json ของตอนเก่าที่ใช้ Liam ไม่ได้แก้ (ห้ามแตะ projects/) ถ้ารัน `look.py check` กับตอนเก่าจะ ERROR เรื่องเสียง ซึ่งถูกต้องตามกฎใหม่ แต่ไม่กระทบตอนใหม่ (history อ่านแค่ palette/opening/เพลง/ปก)
- `hand.js` รองรับแค่มือขวาด้านฝ่ามือ (เขียนไว้ใน README)
