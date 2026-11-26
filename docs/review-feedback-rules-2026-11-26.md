# ห้องตรวจอิสระ: branch `claude/dev-feedback-rules-2026-11-26` @3e0e04c (2026-11-26)

ห้องวางแผน Creative #4 (`session_016zMkaSyNJ1q5w5ZvoFEJXS`) ส่งมาตรวจ ห้องนี้ตรวจและรายงานเท่านั้น ไม่ได้แก้โค้ดหรือเอกสารของ dev
ฐาน `claude/stoic-cray-6z2ajs` @7341c6e, 7 commit + รายงาน dev (`docs/dev-feedback-rules-2026-11-26.md`)
ที่มา: `projects/2026-11-25-knowledge-palmaris-test/feedback.md` (branch `claude/ep-2026-11-25-palmaris-test`)

## สรุป
**รวมได้หลังแก้ 🔴 1 ข้อ** (ปก: ข้อความที่เช็กกับข้อความในภาพเป็นคนละแหล่ง) ส่วนอื่นทำงานจริงตามที่อ้าง
เทสต์ผ่าน ไม่แตะ projects/ ไม่มีความลับ ล็อกเสียงโดนแค่ช่อง knowledge กฎหน้าตาด้านอื่นยังบังคับเหมือนเดิม

| # | หัวข้อ | ผล |
|---|---|---|
| 1 | diff ไม่แตะ projects/ ไม่มีไฟล์ใหญ่/ความลับ | ✅ |
| 2 | เทสต์ทั้งหมด | ✅ 106 passed (หลังติดตั้ง dependency ที่ขาด) |
| 3 | look.py ล็อกเฉพาะ knowledge + ตอนเก่า ก่อน/หลัง | ✅ ตอนที่ถูกกระทบมีแค่เรื่องเสียง |
| 4 | กฎขัดกัน | 🟡 ยังมีคำว่า "เฟรม 0 = ปก" ค้าง 3 จุด; ข้อยกเว้น 429 เขียนไว้ชัด แต่ในโค้ดยังไม่ได้จำกัดเวลารอจริง |
| 5 | เครื่องมือใหม่รันได้จริง | ✅ ทุกตัว / 🔴 cover_check ไม่เทียบข้อความในภาพ |
| 6 | ความเสี่ยงนโยบาย (inauthentic content) | ⚪ ความเห็นด้านล่าง |

## 1. diff `7341c6e..3e0e04c` ✅
- 36 ไฟล์, +1727/−37 ไม่มีไฟล์ใต้ `projects/` ไม่มีไบนารี ไฟล์ใหญ่สุดคือ `tools/cover_check.py` 279 บรรทัด
- ไม่มี key/token: grep `api_key|secret|token|passw` และสตริงยาว ≥32 ตัว เจอแต่ชื่อตัวแปร env (`PIXABAY_API_KEY`, `PEXELS_API_KEY`), ค่าปลอมในเทสต์ (`'K1'`, `'K2'`) และชื่อฟังก์ชันเทสต์; `.env` อยู่ใน `.gitignore` แล้ว
- `footage_search.py` ใส่ key Pixabay ใน URL แต่ `tools/get.sh:15` ปิด `key=` เป็น `***` ก่อนพิมพ์ และ `search_one` แทน key ด้วย `***` ใน URL ที่คืนค่า ลองรันจริงแล้ว `SEARCH.json` ไม่มี `key=` (0 จุด)

## 2. เทสต์ ✅
| | ผล |
|---|---|
| ฐาน 7341c6e | 88 passed, 1 skipped |
| HEAD 3e0e04c (env เดิม) | 105 passed, 1 skipped (`test_sound_pass_vo` ข้าม: ไม่มี `soundfile`) |
| HEAD หลัง `pip install soundfile librosa` | `test_sound_pass_vo` **FAIL**: `ModuleNotFoundError: matplotlib` (env ปัญหา ไม่ใช่โค้ด) |
| HEAD หลังเพิ่ม `matplotlib scipy` | test_sound_pass_vo passed → รวม **106 passed** ตรงกับที่ dev อ้าง |

- ⚪ `tests/test_sound_pass_vo.py:5-7` ใช้ `importorskip` แค่ numpy/soundfile/librosa ถ้าเครื่องมี soundfile แต่ไม่มี matplotlib/scipy เทสต์จะ FAIL แทนที่จะ skip (ปัญหานี้มีมาก่อน แต่ตอนนี้มี assert ใหม่อยู่ในเทสต์นี้ จึงเจอบ่อยขึ้น) ควรเพิ่ม `importorskip('matplotlib')`, `('scipy')`

## 3. look.py ล็อกเสียง ✅
**ตรวจโค้ด** (`tools/look.py:60-62, 229-238, 249, 276-300`): `channel_lock(cat, <channel จากชื่อโฟลเดอร์>)` ทำงานเฉพาะช่องที่มีใน `looks.json channel_lock` (ตอนนี้มีแค่ `knowledge`)
แกนที่ล็อกจะไม่ถูกเตือนว่าซ้ำกับตอนก่อน (`axis not in lock`) ส่วนกฎ ERROR palette/opening ซ้ำตอนก่อน และ cover_text คล้ายตอนเก่า ไม่ได้แก้ ชื่อโฟลเดอร์ผิดรูปแบบหยุดที่ `recent()` ก่อนถึง `ID_RE...group(2)` จึงไม่ crash

**pick จริง** (ใน worktree ของ HEAD):
- `2026-11-27-football-x` → voice `liam` (หมุนตามเดิม), ไม่มี tts_model/atempo/vo_lufs ✅
- `2026-11-27-knowledge-y` → voice `george`, `eleven_v3`, 1.1, −18 ส่วนแกนอื่นหมุนตามเดิม ✅

**`look.py check` บนตอนจริง ก่อน/หลัง** (fetch `refs/heads/claude/ep-*` ได้ 25 branch, มี look.json 4 ตอน + 2 ตอนใน checkout ที่ไม่มี look.json):
| ตอน | ฐาน | HEAD | HEAD `--final` | เหตุที่เปลี่ยน |
|---|---|---|---|---|
| 2026-11-24 brain-freeze | OK (WARN voice ซ้ำ) | OK (WARN tts_model/atempo/vo_lufs ไม่ได้ตั้ง) | FAIL | ฟิลด์ล็อกไม่มีในตอนเก่า |
| 2026-11-24 solar-storm | OK | OK | FAIL | ฟิลด์ล็อก |
| 2026-11-24 stomach-growl | OK (WARN cover) | **FAIL** voice liam | FAIL | เสียงล็อก |
| 2026-11-25 palmaris-test | OK (WARN cover) | **FAIL** voice liam | FAIL | เสียงล็อก |
| 2026-11-17 elder-thirst / nature | FAIL (ไม่มี look.json) | FAIL เหมือนเดิม | เหมือนเดิม | ไม่เปลี่ยน |

→ **ทุก ERROR/WARN ใหม่มาจากด้านเสียง (voice, tts_model, atempo, vo_lufs) เท่านั้น** ไม่มีตอนไหนพังเพราะเหตุอื่น
WARN "voice = previous episode" หายไปตามที่ออกแบบ (แกนที่ล็อก) WARN cover ซ้ำยังขึ้นเหมือนเดิม
- ⚪ ถ้าจะทำตอนเก่าใหม่ (make-clip รองรับ "redo/fix existing clip") `--final` จะ FAIL จนกว่าจะแก้ look.json (dev เขียนไว้ในรายงานแล้ว) ควรเพิ่มใน make-clip หรือ channel.md ว่า "ทำตอนเก่าใหม่ = อัดเสียง George ใหม่ หรือรันแบบไม่ใส่ --final แล้วจดเหตุผล" ไม่งั้นผู้กำกับอาจงงตอนแก้งานเก่า

## 4. กฎขัดกัน 🟡
**ปก = เฟรม 0:** เปลี่ยนแล้วใน editor.md, reviewer.md, make-clip, TEMPLATE.md, pipeline.md, style.md 9a แต่ยังค้าง:
- 🟡 `channels/knowledge/style.md:45` ข้อ 9 "ข้อความเฟรม 0 **(= ปก)** จดใน look.json cover_text" อยู่ใต้ 9a ซึ่งบอกว่าปกแยกจากเฟรม 0 อ่านแล้วขัดกัน ควรเป็น "ข้อความเฟรม 0 (ไม่ใช่ปกที่อัป ดู 9a)"
- 🟡 `templates/looks/looks.json:159` แกน `cover._doc` "การจัดวางข้อความเฟรม 0 (= ปก)" และ `looks.json:2` `_doc` "cover_text = ข้อความเฟรม 0/ปก"
- ⚪ `tools/look.py:270` ข้อความ WARN "the frame-0 / cover text" (ส่วน `look.py:10` แก้เป็น `<frame-0 text>` แล้ว)
- `docs/editing-v3.md:111` เป็นบันทึกประวัติ ไม่ต้องแก้

**สุ่มเสียง / ข้ามด้านภาพ:** ไม่เจอคำสั่งเก่าที่ขัด (`channel.md:8-11`, `style.md:27`, `editing-v3.md:15,38`, voice.md แก้หมดแล้ว; "ห้ามสั่งข้ามด้านภาพ" มีใน reviewer/make-clip)
- ⚪ `.claude/agents/voice.md:15` ยังบอก "ทำทีละฉาก บันทึก vo-<ภาษา>-<ฉาก>.mp3" แต่บรรทัด 18 บอกว่าช่อง knowledge "อัดทั้งบทเทคเดียว" ควรเขียนว่า "ช่องอื่น: ทีละฉาก"
- ⚪ `tools/vo_finish.sh` ใช้ค่าเริ่ม 1.1 / −18 ที่เขียนไว้ในสคริปต์ ไม่ได้อ่านจาก look.json (voice.md:20 เขียนว่า "ตาม look.json") ถ้าวันหน้าแก้ channel_lock แล้วไม่แก้สคริปต์ ค่าจะไม่ตรงกัน

**429 ครั้งเดียว = เลิก:** กฎเดิมยังอยู่ครบใน make-clip:40, footage/voice/researcher.md:9, get.sh:7 ข้อยกเว้นเขียนเป็น "ยกเว้นเดียว: tools/footage_search.py" ทั้งใน make-clip:41 และ footage.md:10 ชัดเจน
และไม่ได้เพิ่มข้อยกเว้นให้ voice/researcher จึงไม่ทำให้กฎล้มเร็วข้ออื่นอ่อนลง ✅ แต่การจำกัดเวลารอในโค้ดยังไม่จริงทั้งหมด:
- 🟡 `tools/footage_search.py:160` ตัวแปร `blocked = set()` อยู่ใน `search()` ซึ่งเรียกครั้งละ 1 ช็อต (CLI รับ `<shot id>` เดียว) แหล่งที่โดน 429 จึงถูกลองใหม่พร้อม backoff 12 วิ **ทุกช็อต** ถ้ามี 15 ช็อตจะรอรวม ~3 นาทีต่อแหล่ง ขัดกับที่เอกสารเขียนว่า "เลิกแหล่งนั้นทั้งรอบ" แก้ได้โดยอ่านสถานะ `blocked` ล่าสุดของแหล่งจาก SEARCH.json (เช่น ภายใน 10 นาที) แล้วข้ามเลย
- 🟡 `tools/footage_search.py:27` อ่าน `FOOTAGE_BACKOFF` จาก env โดยไม่มีเพดาน ตั้ง `"60,600"` ได้ ทำให้คำว่า "≤12 วิ" ไม่ได้ถูกบังคับในโค้ด ควร clamp (เช่น `min(x, 9)` และผลรวม ≤12)
- ⚪ คำขอที่หมดเวลา (curl timeout 30 วิ) ไม่ถูกลองซ้ำ จึงไม่ทำให้รอนานขึ้น ✅ แต่ "≤12 วิ" นับแค่เวลา sleep ไม่รวมเวลาที่คำขอวิ่ง

## 5. เครื่องมือใหม่
**cover_shot.js + cover_check.py** ✅ รันจริง: แม่แบบ `cover.html` → `cover-a/b.jpg` + `.json` → check ผ่าน; ลองกรณีผิด: 3 บรรทัด, คำซ้ำ "ร่างกาย", คล้ายปก palmaris (0.72), บรรทัดยาวชนขอบ ทุกกรณีขึ้น ERROR ถูกต้อง; `compare.png` / `-200.png` ออกมาจริง ดูด้วยตาแล้วอ่านได้
- 🔴 **ข้อความที่เช็กกับข้อความในภาพเป็นคนละแหล่ง:** กฎข้อความ (≤2 บรรทัด, คำซ้ำ, คล้ายปกเก่า) เช็กจาก `look.json "covers"` แต่ภาพที่อัปจริงสร้างจาก `const COVERS` ใน `cover.html` (`templates/brainrot-v3/cover.html:38-41`) `cover_check.py` (`tools/cover_check.py:217-224`) อ่าน `cover-<id>.json` เฉพาะ layout ไม่ได้เทียบว่า `items[kind=text].text` ตรงกับ `lines` ของ look.json
  ลองแล้ว: look.json = "หมอตัดเส้นนี้ / ไปใช้ได้!?" แต่ภาพยังเป็นค่าเริ่มของแม่แบบ "ร่างกายเรา / มีอะไหล่!?" → `cover: OK exit 0`
  และ**ค่าเริ่มของแม่แบบคือปก palmaris** (ถ้าใส่ลง look.json จะ ERROR คล้าย 0.72) ตอนถัดไปที่ลืมแก้ COVERS จะได้ปกซ้ำ palmaris โดยที่เครื่องมือบอกผ่าน ซึ่งเป็นปัญหาเดียวกับที่ feedback 7-8 สั่งให้กัน
  แก้: ใน check เทียบ `[i.text for i in items if kind=='text']` กับ `lines` (ตัด `*` และช่องว่าง) ไม่ตรง = ERROR และ/หรือให้ cover.html อ่าน lines จาก look.json แทนการเขียนซ้ำ + เปลี่ยนค่าเริ่มแม่แบบเป็นข้อความกลาง (เช่น "แก้ข้อความ / ใน look.json")

**contact_sheet.py** ✅ วิดีโอทดสอบ (testsrc 6 วิ + สีทึบ 6 วิ): ได้ 2 แผ่น, INDEX.md บอกช่วงภาพนิ่ง `6.00-11.75s` ถูกต้อง; `verify`: ไม่มีหัวข้อ = FAIL, ขาดแผ่น = FAIL, มีชื่อแผ่นแต่ไม่มีโน้ต = FAIL, ครบ = OK ✅ ใช้เวลา <1 วิ
- ⚪ `verify` เช็กได้แค่ว่ามีชื่อแผ่นและมีโน้ต พิสูจน์ไม่ได้ว่ามีคนเปิดดูจริง (ข้อจำกัดของวิธีนี้ รับได้)

**footage_search.py** ✅ รันจริง (Pixabay มี key ใน env, ไม่มี Pexels):
Pixabay ok 6/6, Pexels skipped (no key), **Openverse 429 → backoff → BLOCKED แล้วข้ามคำที่เหลือ** (ข้อความบอกชัด), NASA ok 0, Wikimedia ok 6/6; ใช้เวลา 23 วิ, exit 0
`report` (2 ช็อตไม่มีไฟล์, 1 ช็อต `footage:false`) → ตาราง + ERROR คำไม่ถึง 10 + `ALERT.md` + **exit 2** ✅ ช็อต `footage:false` ไม่ถูกนับ ✅
- ⚪ `tools/footage_search.py:198` ใน `srcs` นับแหล่งสถานะ `blocked`/`error` ว่า "ตอบแล้ว" ด้วย (กรองออกแค่ `skipped`) เช่น Pixabay ok + Openverse 429 ก็ผ่านเกณฑ์ "≥2 แหล่ง" ได้ ควรนับเฉพาะ `ok`
- ⚪ `tools/footage_search.py:146` regex `CC BY` ยอม `CC BY-NC`/`CC BY-ND` ด้วย (Commons ไม่รับ NC/ND อยู่แล้ว ความเสี่ยงต่ำ แต่ใส่ `(?!-N[CD])` ได้)

**sound_pass_vo.py ค่าเริ่มใหม่** ✅ อาร์กิวเมนต์เดิมยังรับได้ครบ ค่าที่ส่งเองยังชนะค่าเริ่ม; มีบรรทัด `Voice loudness` / `WARN` ใน SOUND.md; เทสต์ผ่าน (ข้อ 2) `re` import ไว้แล้ว และไฟล์ชั่วคราว `_vo.wav/_bed.wav` ถูกลบใน `finally`
**vo_finish.sh** ✅ sine −20 dB 5 วิ → −18.5 LUFS, 4.57 วิ (= 5/1.1) exit 0

**hand-rig demo** ✅ เปิด `demo.html?pose=rest|test|flex` ที่ 1080x1920 ด้วย playwright ไม่มี pageerror/console error, SVG 281 node, ภาพ 3 ท่าถูกต้อง (ท่า test = นิ้วโป้งแตะนิ้วก้อย ข้อมืองอ) ต้องเปิดที่ viewport 1080 เท่านั้น ถ้าเล็กกว่านี้ภาพจะถูกตัด (เป็นแม่แบบ 9:16 รับได้)

## 6. ความเสี่ยงนโยบาย (inauthentic / repetitive content) ⚪ ความเห็น
- ช่องเดียวใช้ผู้บรรยายเสียงเดียวทุกตอนเป็นเรื่องปกติของช่องคน (เหมือนเจ้าของช่องพูดเอง) เสียงไม่ใช่ตัวที่ทำให้ดูเป็นงานผลิตซ้ำ สิ่งที่แพลตฟอร์มมองคือ**เนื้อหา/โครงซ้ำ ทำจำนวนมาก ไม่มีคุณค่าเพิ่ม**
- ด้านอื่นยังกันไว้: palette/opening ERROR ถ้าซ้ำตอนก่อน, แกนอื่น WARN, cover_text คล้ายตอนเก่า = ERROR ทุกตอน, เพลงซ้ำใน 3 ตอน = ERROR, ปกใหม่ A/B ต้องไม่คล้ายปกเก่า (ข้อ 5: ต้องแก้ 🔴 ก่อนจึงจะกันได้จริง) **ส่วนนี้ยังพอ**
- จุดที่ความเหมือนสะสมขึ้นพร้อมกัน: เสียงเดียว + จังหวะ atempo เดียว + ซีรีส์ "ลองทำตาม" ใช้มือ rig ตัวเดียวกัน + ปกจากแม่แบบเดียว (A ทึบ / B สีอ่อน ตายตัวใน `cover.html`) ข้อเสนอ:
  1. ให้ "cover" A/B ใช้แกน palette/cover ของ look.json แทน 2 สไตล์ที่เขียนตายตัว (ตอนนี้ `vb` เหมือนกันทุกตอน)
  2. ตัวยืนยันความเป็นของแท้ที่แรงที่สุดยังเป็น research.md + บทที่เขียนใหม่ทุกตอน (CLAUDE.md) ควรรักษาไว้ ไม่ใช้บทแม่แบบ
  3. ห้องวางแผนติดตามว่าซีรีส์มือ rig มีหลายท่า/หลายเรื่อง ไม่ใช่ท่าเดิมเปลี่ยนแค่คำ
- ไม่ใช่เหตุให้บล็อกการรวม

## รายการแก้
| ระดับ | ไฟล์:บรรทัด | เรื่อง |
|---|---|---|
| 🔴 | `tools/cover_check.py:217-224`, `templates/brainrot-v3/cover.html:38-41` | ข้อความในภาพปก ≠ look.json "covers" แต่ยังผ่าน + ค่าเริ่มแม่แบบ = ปก palmaris |
| 🟡 | `tools/footage_search.py:160` | แหล่งที่ BLOCKED ถูกลองใหม่ (รอ 12 วิ) ทุกช็อต ไม่ใช่ "ทั้งรอบ" |
| 🟡 | `tools/footage_search.py:27` | `FOOTAGE_BACKOFF` ไม่มีเพดาน คำว่า ≤12 วิไม่ได้ถูกบังคับในโค้ด |
| 🟡 | `channels/knowledge/style.md:45`, `templates/looks/looks.json:2,159` | ยังเขียนว่า "เฟรม 0 (= ปก)" ขัดกับ 9a |
| ⚪ | `tools/look.py:270` | ข้อความ WARN "frame-0 / cover text" |
| ⚪ | `.claude/agents/voice.md:15` | "ทีละฉาก" ขัดกับ "เทคเดียว" ของช่อง knowledge (บรรทัด 18) |
| ⚪ | `tools/vo_finish.sh:8` | ค่า 1.1/−18 เขียนตายตัว ไม่อ่าน look.json |
| ⚪ | `tools/footage_search.py:198` | นับแหล่ง blocked/error เป็น "ตอบแล้ว" |
| ⚪ | `tools/footage_search.py:146` | regex license ยอม CC BY-NC/ND |
| ⚪ | `tests/test_sound_pass_vo.py:5-7` | ขาด importorskip matplotlib/scipy (FAIL แทน skip) |
| ⚪ | make-clip / channel.md | วิธีทำตอนเก่าใหม่หลังล็อกเสียง (`--final` FAIL) |

## วิธีตรวจ (ทำซ้ำได้)
- `git worktree` 2 ชุด (7341c6e / 3e0e04c) + `git archive` ดึง `projects/` ของ 4 ตอนจาก `origin/claude/ep-*` ลงทั้งสองชุด แล้วรัน `look.py check [--final]`
- cover: คัดลอก `cover.html` + `fonts/` ลง `projects/<x>/video/` → `node ../../../tools/cover_shot.js cover.html ../covers a,b` → `cover_check.py --final` แล้วแก้ look.json / COVERS เพื่อลองกรณีผิด
- contact sheet: `ffmpeg testsrc + color concat` → make → verify (4 กรณี)
- footage: โปรเจกต์ปลอม 3 ช็อต, search 2 คำ (ไทย/อังกฤษ) เรียก API จริง → report
- hand-rig: playwright 1080x1920 ท่า 3 แบบ ดูภาพด้วยตาแล้ว

---

# รอบ 2: `3e0e04c..defa014` (2026-11-26)
3 commit: a95bf1a ปก, df0b62b footage, defa014 เอกสาร/⚪ — 18 ไฟล์ +193/−37, **ไม่แตะ projects/** ✅

## สรุปรอบ 2: **รวมได้** ✅ (🔴 ปิดแล้ว, 🟡 ปิดครบ 3 ข้อ, เหลือ ⚪ 2 ข้อ ไม่บล็อก)

| ข้อรอบ 1 | ผลรอบ 2 |
|---|---|
| 🔴 ภาพปก ≠ look.json | ✅ ปิด: `cover_shot.js` อ่าน `look.json "covers"` + palette/font แล้วส่งเข้า `window.__COVER`; `cover.html` ไม่มีข้อความจริงอีก (ค่าเริ่ม = "แก้ข้อความ / ใน look.json"); `cover_check.py:229-233` ERROR ถ้าข้อความในภาพ ≠ look.json |
| 🟡 blocked แค่ 1 ช็อต | ✅ ปิด: `SEARCH.json "_blocked"` ข้ามแหล่งนั้นทุกช็อต 10 นาที |
| 🟡 backoff ไม่มีเพดาน | ✅ ปิด: `_backoff()` clamp ≤2 ครั้ง, ครั้งละ ≤9 วิ, รวม ≤12 วิ |
| 🟡 "เฟรม 0 = ปก" ค้าง | ✅ ปิดในกฎ/เอกสารที่ใช้งาน (style.md:45, looks.json:2,159, make-clip, TEMPLATE.md, look.py:270) |
| ⚪ ทั้ง 7 ข้อ | ✅ ปิด 6 ข้อ (voice.md เทคเดียว/ทีละฉาก, vo_finish อ่าน look.json, srcs นับเฉพาะ ok, ตัด NC/ND, importorskip, ทำตอนเก่าใหม่ใน make-clip+channel.md); `verify` พิสูจน์การดูไม่ได้ = ข้อจำกัดที่รับได้ |

## ตรวจซ้ำ
- **เทสต์:** `pytest tests/` → **111 passed, 0 skipped** ตรงกับที่ dev อ้าง (env นี้ติดตั้ง soundfile/librosa/matplotlib/scipy แล้ว)
- **ปก: ลองกรณี look.json ≠ ภาพอีกครั้ง** (worktree defa014 + ประวัติ palmaris):
  1. look.json a="หมอตัดเส้นนี้/ไป*ใช้*ได้!?" b="เส้นเอ็นที่/14% ไม่มี", font sarabun → `cover_shot.js` → `cover_check --final` **OK** ภาพใช้ข้อความ, palette (mono-yellow), Sarabun ตาม look จริง (ดู compare.png ด้วยตาแล้ว)
  2. แก้ look.json a เป็น "ร่างกายเรา/มีอะไหล่!?" โดยไม่ถ่ายใหม่ → **ERROR** "the image says 'หมอตัดเส้นนี้ / ไปใช้ได้!?' but look.json covers says ..." + ERROR คล้ายปก palmaris 0.72 → exit 1 ✅
  3. แก้ cover-b.json ให้เป็นข้อความ placeholder "แก้ข้อความ" → **ERROR** cover b ✅
  4. `cover_shot.js ... c` (ไม่มี variant c ใน look.json) → "look.json has no covers entry for id c" exit 1 ✅
- **footage:** `FOOTAGE_BACKOFF=60,600` → (9.0, 3.0) รวม 12 ✅; `x,5,9` → (5.0,) ✅
  API จริง 2 ช็อตต่อกัน: ช็อต s1 Wikimedia ตอบ 429 → backoff → BLOCKED (14 วิ); ช็อต s2 **ไม่เรียก Wikimedia เลย ใช้ 1 วิ** ✅ `_blocked` ถูกจดไว้
- **vo_finish.sh + look.json:** `{"atempo":1.05,"vo_lufs":-20}` → −20.5 LUFS, atempo 1.05 ✅; look.json ที่ไม่มีค่าล็อก (football) → fallback 1.1/−18 ✅
- **grep ทั้ง repo "เฟรม 0 = ปก"** (md/json/py/js/html/sh ยกเว้น projects/): เหลือแค่
  - `docs/editing-v3.md:106,111`, `docs/dev-feedback-rules-2026-11-26.md:41` = บันทึกประวัติ/รายการแก้ ไม่ต้องแก้
  - `style.md:95` "ทำเฟรม 0.0 วิให้ดูเหมือนปก" ต่อท้ายว่า "ปกที่อัปทำแยก A/B ดูข้อ 9a" ไม่ขัดกัน

## เหลือ ⚪ (ไม่บล็อก)
| ไฟล์:บรรทัด | เรื่อง |
|---|---|
| `templates/brainrot-v3/build_index.py:70,73` | คอมเมนต์และข้อความ SystemExit ยังเขียน "frame 0 = (the) cover" ส่วนตรรกะถูก (cover_text = title เฟรม 0) แค่คำอาจทำให้เข้าใจผิด ควรเป็น "frame 0 = cover_text" |
| `tools/footage_search.py` `fetch()` (`msg = ...splitlines()[-1]`) | note ใน SEARCH.json/stderr เก็บบรรทัดสุดท้ายของ body (เช่น "If you are unsure how to get the access you need, contact bo") ทำให้ไม่เห็น "BLOCKED 429 <url>" ควรใช้บรรทัดแรกของ stderr (การลองซ้ำไม่กระทบ เพราะเช็ก `'BLOCKED 429' in r.stderr` ทั้งก้อน) |
