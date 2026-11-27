# dev v3.7 (2026-11-28): กล้องตามจังหวะตัด, หัวข้อเฟรม 0, เครื่องมือจากตอน itch

ห้อง dev (ลูกของห้องวางแผน Creative #4) branch `claude/dev-pending-rules-2` ต่อจาก 643253b (style.md feedback ผู้ใช้ยังอยู่ ไม่ได้แตะ)
ยังไม่ merge เข้า stoic-cray (รอห้องตรวจ)

| ข้อ | commit | ทำอะไร | ไฟล์ |
|---|---|---|---|
| 1 กล้อง | `f47faa7` | ทุกช็อตขยับตามความยาวจริงของช็อต (เดิมเร็วเฉพาะ hook/twist ที่เหลือ push 8% แบบ smootherstep ที่นิ่งทั้งต้นและท้ายช็อต) | `templates/brainrot-v3/build_index.py` (`camera()`), `index.html.tpl`, `TEMPLATE.md`, style.md Motion, editing-v3.md |
| 2 หัวข้อเฟรม 0 | `9420139` | pov ไม่ชิดซ้ายแล้ว (กลางจอเหมือน opening อื่น), tilt บรรทัด 1.26 (ไม่มีแถบไฮไลต์), แถบ pov ถึง ~Y 790 → หัวข้อ itch 65 → 83-88 px กลางจอ; เทสต์ FAIL ทุกคู่ opening×cover ที่เล็กกว่า 72/60 px **บนจอจริง** หรือไม่อยู่กลาง | `build_index.py` `title()`, `index.html.tpl`, `tests/browser/title_fit.js`, `tests/test_title_fit_v3.py`, `tests/test_build_index_v3.py`, style.md ตารางตำแหน่ง |
| 3 .hyperframes | `ef77ecf` | `.hyperframes/` ใน .gitignore ของรีโป + brainrot-v2/v3; เลิก track cache ของแม่แบบ v2 (ไม่แตะ projects/ ตอนอื่น) | `.gitignore`, `templates/brainrot-v{2,3}/.gitignore` |
| 4 ภาพนิ่ง action_at | `cdc8a9a` | src ภาพนิ่ง (.jpg/.png/.webp/.gif/.avif) → ข้าม action_at พร้อม INFO ไม่ ERROR; footage.md: ภาพนิ่งเขียนแค่ src | `tools/shot_times.py`, `.claude/agents/footage.md`, `tests/test_shot_times.py` |
| 5 จับเวลาบท | `564e3ff` | 12-13 → **11.9 ตัวอักษร/วิ** (20-40 วิ ≈ 240-475 ตัว); เช็กลิสต์ reviewer 15 → 11.9; "15 ตัว/วิ" ของคลิปตัวอย่างระบุว่าเป็นของเขา | `channels/knowledge/style.md`, `.claude/skills/make-clip/SKILL.md` ขั้น 3 |
| 6 + 8b footage_search | `19c109d` | ล็อกไฟล์ทั้งคำสั่ง `search`: ตัวที่สองขึ้น `WAIT ... (parallel search = 429)` แล้วรอคิว (`FOOTAGE_LOCK_WAIT` 600 วิ, เกิน = exit 3); note ใน SEARCH.json = บรรทัด `BLOCKED 429 ...` ของ get.sh (+ จำนวนครั้ง) แทนบรรทัดท้ายของ body ข้อผิดพลาด, แถว skipped บอกเหตุ, `_blocked_why` | `tools/footage_search.py`, footage.md, make-clip ตารางปัญหา, `tests/test_footage_search.py` |
| 7 sound_pass_vo mono | `f20b3dc` | vo mono ถูกก๊อปเป็นสเตอริโอก่อนวัด = +3 LU → WARN ผิด; ตอนนี้เช็ก -18 จากไฟล์ mono เอง ส่วนระยะเพลงใต้เสียงยังเทียบในมิกซ์สเตอริโอ | `tools/sound_pass_vo.py`, `tests/test_sound_pass_vo.py` |
| 8a คอมเมนต์ | `f4c1a8a` | "frame 0 = cover" → หัวข้อเฟรม 0 = cover_text, ปกที่อัปแยก (cover.html) | `build_index.py`, `index.html.tpl` |

## ข้อ 1 กล้อง: กฎใหม่
`camera(d, beat, i)` จากความยาวช็อตจริง d (สอดคล้อง style.md ข้อ 4 "จังหวะตัดแล้วแต่คลิป": ตัดถี่ = กล้องเร็วเอง)
- push 10-17% ยิ่งช็อตสั้นยิ่งเร็ว: 1 วิ ≈ 10%/วิ, 2 วิ ≈ 6.5%/วิ, 4 วิ ≈ 4.3%/วิ
- ออกตัวแรง 2.2 เท่าของความเร็วเฉลี่ยตรงจุดตัด (จังหวะ "ตึก" ตามคัต) แล้วผ่อน แต่ไม่ต่ำกว่า 40% จนคัตถัดไป
- แพนขึ้น/ลง 24 px + หมุน ±0.6° สลับทิศทีละช็อต + ส่าย sin/cos 10 px ที่ไม่หยุดพร้อมกัน (แบบ brainrot v2 7b088c8)
- hook/twist push ×1.3 ส่าย 14 px; scale เริ่ม 1.04 (1.06 เร็ว) ไม่เห็นขอบภาพ (เดิม hold เริ่ม 1.0 + หมุน = มุมภาพโผล่ เห็นในแถบภาพด้านล่าง); เพดาน 1.22
- ช็อตแรก (hook ภาพนิ่ง) และ loop คงเดิม (เฟรมสุดท้าย = เฟรม 0)

วัดเทียบ (timeline ตอน itch 21 ช็อต 37 วิ ใส่ภาพทดสอบทุกช็อต ซ่อนหัวข้อ/ซับ วัดค่าเฉลี่ย |Δluma| ต่อเฟรมที่ 30 fps ไม่นับ ±0.15 วิรอบคัต):

| | ก่อน (v3.6) | หลัง (v3.7) |
|---|---|---|
| เฟรมเกือบนิ่ง (< 0.6) | 47 | **0** |
| ค่ากลาง / เปอร์เซ็นไทล์ 10 | 1.73 / 0.78 | 1.98 / 1.17 |
| ช็อตสั้น < 1.5 วิ เฉลี่ย / ต่ำสุด | 2.71 / 1.23 | 2.60 / 1.49 |
| ช็อตยาว ≥ 2 วิ เฉลี่ย / ต่ำสุด | 1.55 / 0.59 | 2.07 / 1.19 |

ช็อตสั้นยังเคลื่อนมากกว่าช็อตยาว (2.60 เทียบ 2.07) ช็อตสั้นเฉลี่ยใกล้ของเดิมเพราะ push 8% ตายตัวเดิมเร็วอยู่แล้วบนคัตต่ำกว่า 1 วิ; สิ่งที่เปลี่ยนคือไม่มีจุดนิ่งตรงคัตอีก และช็อต 2-3 วิไม่ช้าแล้ว
ตัวตรวจ `tools/contact_sheet.py` (DIFF 0.005) ไม่เจอเฟรมนิ่ง > 0.5 วิทั้งสองแบบ: เกณฑ์ของมันหยาบเกินจะจับอาการ "ช้าตรงคัต"

| ช็อต | beat | วิ | ก่อน เฉลี่ย / ต่ำสุด | หลัง เฉลี่ย / ต่ำสุด |
|---|---|---|---|---|
| hook | hook | 2.14 | 0.94 / 0.74 | 0.94 / 0.74 |
| hook_in | hook | 1.36 | 2.64 / 1.19 | 3.1 / 1.63 |
| mosquito | setup | 1.16 | 2.88 / 1.32 | 2.65 / 1.59 |
| mast | setup | 2.68 | 1.2 / 0.33 | 1.84 / 1.17 |
| nerve | explain | 2.24 | 1.51 / 0.39 | 2.0 / 0.85 |
| signal | explain | 1.08 | 2.97 / 1.55 | 2.69 / 1.54 |
| spine | explain | 0.88 | 3.63 / 2.25 | 3.12 / 1.96 |
| brain_cmd | explain | 1.4 | 2.28 / 0.67 | 2.41 / 1.34 |
| scratch2 | explain | 1.96 | 1.63 / 0.45 | 2.15 / 1.38 |
| pain_cover | explain | 2.08 | 1.56 / 0.44 | 1.9 / 1.13 |
| temp | explain | 1.34 | 2.36 / 0.7 | 2.47 / 1.52 |
| mouse | explain | 2.12 | 1.52 / 0.42 | 1.99 / 1.08 |
| serotonin | reveal | 2.74 | 1.22 / 0.33 | 1.93 / 1.15 |
| serotonin2 | reveal | 1.62 | 1.96 / 0.54 | 2.18 / 1.1 |
| boost | twist | 2.3 | 1.84 / 1.22 | 2.24 / 1.06 |
| cycle | twist | 2.04 | 1.98 / 1.31 | 2.65 / 1.73 |
| contagious | share | 2.16 | 1.57 / 0.44 | 2.09 / 1.26 |
| watch | share | 1.28 | 2.5 / 1.21 | 2.36 / 1.26 |
| follow | share | 2.06 | 1.55 / 0.42 | 2.02 / 1.26 |
| cta | cta | 1.48 | 2.33 / 0.89 | 2.53 / 1.2 |
| loop | loop | 0.88 | 2.02 / 1.74 | 2.02 / 1.74 |

![กราฟการเคลื่อนไหว](review-assets/v3.7/camera-motion-before-after.png)
เส้นเทา (ก่อน) เริ่มจากเกือบ 0 ทุกคัตแล้วค่อยเร่ง = เห็นเป็นภาพค้างตรงจุดตัด; เส้นแดง (หลัง) พุ่งตรงคัตแล้วผ่อน
- ภาพเคลื่อนไหวก่อน/หลัง 4.5-10.5 วิ: `review-assets/v3.7/camera-before-after-4.5-10.5s.gif`
- แถบ 8 เฟรมของช็อต hold 2.68 วิ: `review-assets/v3.7/camera-hold-shot-strip.jpg` (แถวบนเห็นมุมภาพโผล่ซ้ายบนในเฟรมแรก)
- วิธีเรนเดอร์ตัวอย่าง: Playwright seek `window.__timelines.main` ทีละ 1/30 วิ (gsap จาก npm เพราะ proxy บล็อก jsdelivr) ไม่ใช่ `hyperframes render`; ไม่ได้ใช้ footage จริงของตอน itch (assets ไม่อยู่ใน git)

## ข้อ 2 หัวข้อเฟรม 0
![ก่อน/หลัง](review-assets/v3.7/frame0-itch-before-after.png)
- **ข้อเท็จจริงที่เจอ:** แม่แบบเดิมให้หัวข้อ itch 3 บรรทัด **65 px** CSS (ไม่ใช่ ~30) ผ่านเกณฑ์เดิม 60 px สำหรับ 3 บรรทัด แต่ดูเล็กเพราะ (1) pov ชิดซ้าย ใช้ความกว้างแค่ ~390 จาก 960 px
  (2) ความสูงถูกจำกัด: บรรทัด 1.42 + ช่องว่าง tilt 30 px + kicker ในแถบ Y 250-750. เลข ~30 px น่าจะมาจากการดูภาพตัวอย่างย่อครึ่ง ฟอนต์ Sarabun เองไม่ได้เล็กกว่าฟอนต์อื่น (วัด ก สูง 0.59 em เทียบ Kanit 0.55)
- หลังแก้: itch = 83/83/88 px กลางจอ ทุกคู่ opening×cover ของหัวข้อ itch: 65-100 px (card ยังเล็กสุด 65-69 เพราะขอบการ์ด)
- เทสต์: `test_frame0_title_every_opening_cover_itch_regression` (ไม่ใช้เบราว์เซอร์: ทั้ง 12 คู่ ≥ 60 px, pov/tilt ≥ 80, ไม่มี left-align) + `title_fit.js` (4 ฟอนต์ × 3 ปก × 4 เปิด × 5 หัวข้อ: ขนาด**บนจอ**ที่เฟรม 0 = font-size × transform ≥ 72/60, ทุกบรรทัดและ kicker อยู่กลาง X 540 ±40, หมึกสระบนไม่ทับบรรทัดบน)
- midstory+tilt คง line-height 1.42 (ลองแล้ว 1.26 สระบน Sarabun แตะแถบบรรทัดบน)

## เทสต์
`python3 -m pytest -q tests`: **117 passed, 0 skipped** (ฐาน 110 passed 1 skipped; skipped เดิม = sound_pass_vo ที่ข้ามเมื่อไม่มี librosa ห้องนี้ติดตั้ง librosa แล้วรันจริงทั้ง 2 เทสต์; +6 เทสต์ใหม่)
เทสต์ใหม่: ข้อ 1 `test_camera_speed_follows_real_shot_length`, ข้อ 2 (ด้านบน), ข้อ 4 `test_still_image_action_at_skipped_not_error`, ข้อ 6/8b `test_searches_run_one_at_a_time` + `test_blocked_note_shows_the_429_not_the_error_body`, ข้อ 7 `test_mono_voice_at_minus_18_is_not_warned` (โค้ดเดิม: รายงาน -15.0 + WARN; ใหม่: -18 ไม่ WARN)

## ที่ทำไม่ได้ / ข้อสังเกต
- หัวข้อไม่ถึง 116 px แบบที่ editor แก้มือในตอน itch: 3 บรรทัด + kicker ในแถบ ~Y 250-790 ได้ ~85 px; ใหญ่กว่านี้ต้องย้ายหัวข้อลงต่ำกว่า Y 800 (ชนกฎตำแหน่ง style.md) หรือเลิก stroke/kicker ควรให้ผู้ใช้ตัดสินถ้ายังเล็ก
- ไม่ได้ยกเกณฑ์ขั้นต่ำเกิน 72/60 (cover card 3 บรรทัดได้ 65 px จะ FAIL ทันที)
- การเปลี่ยนจาก crossfade 0.1 วิ (match) ระหว่างช็อตในช่วงเดียวกัน ยังเหมือนเดิม; v2 ใช้คัตแข็ง/whip เกือบทุกคัต + zoom punch ตรงคำ อาจเป็นอีกส่วนของความรู้สึก "เรียงจังหวะ" ไม่ได้แตะเพราะนอกขอบเขตข้อ 1 (เสนอให้ห้องวางแผนตัดสิน)
- ไม่ได้เรนเดอร์ด้วย hyperframes CLI / footage จริง (ตัวอย่างใช้ภาพทดสอบ); ห้องทำตอนถัดไปควรดู contact sheet ของคลิปจริง
- ไฟล์ `.hyperframes/` ที่ track อยู่ใน projects/2026-11-17-knowledge-nature ไม่ได้ลบ (ห้ามแตะ projects/ ตอนอื่น) .gitignore ใหม่ไม่มีผลกับไฟล์ที่ track แล้ว
