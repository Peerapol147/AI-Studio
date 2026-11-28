# YouTube Analytics Tracker Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** เก็บสถิติสาธารณะของทุกคลิปในช่อง `@vision6498` รายวัน แสดงบนแดชบอร์ดส่วนตัว และสรุป insight รายสัปดาห์ที่ย้อนเข้าสายพานทำคลิป (ระยะ 1 ตามสเปก)

**Architecture:** `tools/yt_stats.py` ดึงข้อมูลจาก YouTube Data API v3 แล้วพิมพ์ JSON (ไม่แตะ DB) เซสชันที่ตั้งเวลาไว้เขียน JSON ลง Artifact DB ด้วย ArtifactData แดชบอร์ดเป็น Artifact ส่วนตัวอ่านจาก DB ระยะ 2 (OAuth/retention) อยู่นอกแผนนี้

**Tech Stack:** Python 3.13 stdlib + pytest (ตามแบบ `tools/*.py`, `tests/test_*.py`), ส่ง request ผ่าน `tools/get.sh`, HTML/JS เดี่ยวสำหรับ Artifact

**Spec:** `docs/superpowers/specs/2026-11-28-youtube-analytics-design.md`

## Global Constraints

- repo เป็น public: ห้ามใส่ API key/token/สถิติช่องใน repo (handle `@vision6498` ใส่ได้)
- ห้ามอัปโหลด ตั้งเวลาโพสต์ หรือตอบคอมเมนต์
- API key อ่านจาก env `YOUTUBE_API_KEY` เท่านั้น ส่งผ่าน header `x-goog-api-key` ไม่ใส่ใน URL
- base URL override ได้ด้วย `YT_BASE` (เพื่อทดสอบ) เหมือนแบบ `PIXABAY_BASE`
- เกณฑ์ insight: ≥10 คลิปต่อกลุ่ม และคลิปแต่ละตัวอายุ ≥7 วัน ไม่ถึง = "ยังสรุปไม่ได้" แสดงเฉพาะตัวเลขดิบ
- แดชบอร์ดส่วนตัวของเจ้าของเท่านั้น
- ข้อความที่ผู้ใช้เห็นเป็นภาษาไทย
- ไฟล์ร่วม (`docs/`, `tools/`, `.claude/skills/make-clip`) แก้ได้เพราะผู้ใช้สั่งฟีเจอร์นี้ แต่ต้องแจ้งผู้ใช้

## Review Focus

1. handle ไม่พบ / ช่องไม่มีคลิป → exit ≠ 0 พร้อมข้อความไทย ห้ามพิมพ์ JSON ว่างเงียบๆ
2. คลิปที่ซ่อนไลก์/ปิดคอมเมนต์ (ไม่มี `likeCount`/`commentCount`) → เก็บเป็น `null` ไม่ใช่ 0
3. ช่องมีคลิป >50 (ต้อง paginate ทั้ง playlist และ `videos.list` ทีละ 50)
4. โควตาหมด/key ผิด (HTTP 403/400) → ล้มดังๆ พร้อมสาเหตุ ห้ามเขียน snapshot ว่าง
5. ชื่อคลิปภาษาไทย/อีโมจิ ต้องไม่เพี้ยนตอนจับคู่กับ `upload.md`

## File Structure

- `tools/yt_stats.py` — คำสั่ง `collect` (พิมพ์ JSON) และฟังก์ชันล้วนสำหรับจัดรูป/จับคู่/ตัดสินว่าสรุปได้หรือไม่
- `tests/test_yt_stats.py` — ทดสอบด้วยเซิร์ฟเวอร์จำลอง (`YT_BASE`) ไม่ยิงเน็ตจริง
- `docs/analytics-setup.md` — ขั้นตอนสร้าง API key + ตั้ง scheduled task
- `docs/analytics-learnings.md` — บทเรียนที่ผู้ใช้อนุมัติแล้ว (เริ่มว่าง)
- `analytics/dashboard.html` — แดชบอร์ด (ไม่มีสถิติ ไม่มี key)

---

### Task 1: ตัวเก็บสถิติ `collect`

**Files:**
- Create: `tools/yt_stats.py`
- Test: `tests/test_yt_stats.py`

**Interfaces:**
- Produces: `fetch_snapshot(handle: str, base: str, key: str) -> dict` คืน `{"channel": {"id","handle","title","subscribers"}, "taken_at": ISO8601 UTC, "videos": [{"id","title","published_at","duration_s": int,"views": int,"likes": int|None,"comments": int|None}]}`
- Produces: CLI `python3 tools/yt_stats.py collect @vision6498` พิมพ์ JSON ข้างต้นออก stdout; exit 2 เมื่อไม่พบช่อง/ไม่มีคลิป, exit 3 เมื่อ API ตอบ 4xx

- [ ] **Step 1: เขียนเทสต์ที่ล้ม** — `test_fetch_snapshot_paginates` (เซิร์ฟเวอร์จำลองให้ 120 คลิป ผล `len(videos) == 120`), `test_missing_likes_is_none` (คลิปไม่มี `likeCount` → `likes is None`), `test_duration_parsed` (`PT1M5S` → `65`), `test_unknown_handle_exits_2`, `test_quota_error_exits_3_and_prints_reason` (ตอบ 403 `quotaExceeded` → stderr มีคำว่า `quotaExceeded`), `test_key_sent_in_header_not_url`
- [ ] **Step 2: รันให้เห็นว่าล้ม** — `python3 -m pytest tests/test_yt_stats.py -v` คาด FAIL (module ไม่มี)
- [ ] **Step 3: เขียน `fetch_snapshot` และ CLI `collect`** — ใช้ `channels.list?forHandle=` → uploads playlist → `playlistItems.list` (50/หน้า) → `videos.list?part=snippet,statistics,contentDetails` (50 id/ครั้ง) ส่งทุก request ผ่าน `tools/get.sh` พร้อม header `x-goog-api-key`
- [ ] **Step 4: รันให้ผ่าน** — คำสั่งเดิม คาด PASS ทั้งหมด
- [ ] **Step 5: Commit** — `git add tools/yt_stats.py tests/test_yt_stats.py && git commit -m "feat: collect public YouTube stats snapshot"`

### Task 2: จับคู่คลิปกับโฟลเดอร์ project และจัดกลุ่มรูปแบบ

**Files:**
- Modify: `tools/yt_stats.py`
- Test: `tests/test_yt_stats.py`

**Interfaces:**
- Consumes: `fetch_snapshot` จาก Task 1
- Produces: `match_projects(videos: list[dict], projects_dir: Path) -> dict[str, str|None]` (video id → ชื่อโฟลเดอร์ project หรือ `None`) และ `classify(video: dict, project: str|None) -> {"format": "short"|"long", "channel": "knowledge"|"football"|"unknown"}`
- Produces: CLI `python3 tools/yt_stats.py collect ... --projects projects` เพิ่มฟิลด์ `project`, `format`, `channel` ในแต่ละคลิป

- [ ] **Step 1: เขียนเทสต์ที่ล้ม** — `test_match_by_title_in_upload_md` (ชื่อไทยตรงกับบรรทัดชื่อใน `upload.md` ของ fixture → ได้ชื่อโฟลเดอร์), `test_no_match_returns_none`, `test_channel_from_folder_name` (`2026-11-17-knowledge-nature` → `knowledge`), `test_format_short_when_duration_le_60_and_no_project`, `test_format_from_brief_when_project_matched`
- [ ] **Step 2: รันให้เห็นว่าล้ม**
- [ ] **Step 3: เขียน `match_projects` / `classify`** — เทียบชื่อแบบ NFC-normalize + ตัดช่องว่าง/อีโมจิ; รูปแบบ: ถ้าจับคู่ได้ใช้ `brief.md` ของ project (หา `short`/`long`) ถ้าไม่ได้ ใช้ `duration_s ≤ 60`
- [ ] **Step 4: รันให้ผ่าน**
- [ ] **Step 5: Commit**

### Task 3: ตัดสินว่ากลุ่มไหนสรุปได้

**Files:**
- Modify: `tools/yt_stats.py`
- Test: `tests/test_yt_stats.py`

**Interfaces:**
- Consumes: รายการคลิปที่มี `format`, `channel`, `published_at`
- Produces: `eligible_groups(videos: list[dict], now: datetime, min_videos: int = 10, min_age_days: int = 7) -> dict[str, {"n": int, "eligible": bool, "reason": str}]` คีย์เป็น `"<channel>/<format>"`; CLI `python3 tools/yt_stats.py eligibility < snapshot.json`

- [ ] **Step 1: เขียนเทสต์ที่ล้ม** — `test_nine_videos_not_eligible` (9 คลิป → `eligible False`, reason มี "ยังสรุปไม่ได้"), `test_ten_videos_eligible`, `test_young_videos_not_counted` (คลิปอายุ <7 วันไม่นับใน n), `test_groups_are_separate` (short กับ long นับแยก)
- [ ] **Step 2: รันให้เห็นว่าล้ม**
- [ ] **Step 3: เขียน `eligible_groups`**
- [ ] **Step 4: รันให้ผ่าน**
- [ ] **Step 5: Commit**

### Task 4: คู่มือตั้งค่า (key + scheduled task)

**Files:**
- Create: `docs/analytics-setup.md`, `docs/analytics-learnings.md`

**Interfaces:**
- Produces: ขั้นตอนที่ผู้ใช้ทำเอง (สร้าง Google Cloud project, เปิด YouTube Data API v3, สร้าง API key จำกัดเฉพาะ API นี้) และขั้นตอนที่ผู้ช่วยทำ (เรียก `request_credential` host `www.googleapis.com` header `x-goog-api-key`; ตรวจว่า environment อนุญาตโฮสต์ ถ้าไม่ให้ขอผ่าน `update_environment`)

- [ ] **Step 1:** เขียน `docs/analytics-setup.md` เป็นภาษาไทย ทีละข้อที่ผู้ใช้ทำตามได้ภายใน ~10 นาที และบอกชัดว่า key ใส่ผ่านฟอร์ม ไม่ส่งในแชต
- [ ] **Step 2:** สร้าง `docs/analytics-learnings.md` ว่าง มีหัวข้อ "บทเรียนที่ผู้ใช้อนุมัติแล้ว" และกฎว่าห้ามใส่ตัวเลขช่อง
- [ ] **Step 3: ตรวจ** — `grep -riE "AIza|api[_-]?key *[:=] *['\"]?[A-Za-z0-9]{20}" docs/analytics-*.md` ต้องไม่พบอะไร
- [ ] **Step 4: Commit**

### Task 5: แดชบอร์ด

**Files:**
- Create: `analytics/dashboard.html`

**Interfaces:**
- Consumes: คอลเลกชัน DB `videos` (doc id = video id: title, channel, format, project, published_at), `snapshots` (doc id = `<video id>_<YYYY-MM-DD>`: views, likes, comments, taken_at), `insights` (doc id = `<YYYY-Www>`: text, groups, created_at)

- [ ] **Step 1:** โหลด skills `artifact-design`, `artifact-capabilities` และ `dataviz` ก่อนเขียน; ประกาศความสามารถ `db`
- [ ] **Step 2:** หน้า: การ์ดภาพรวม (คลิป/วิว/ไลก์รวม), ตัวกรอง channel/format, ตารางคลิปเรียงได้, กราฟวิวตามเวลาของคลิปที่เลือก, กล่องสรุป insight ล่าสุดที่แสดงขนาดตัวอย่าง; ข้อความไทย; รองรับมือถือ; null แสดงเป็น "–"
- [ ] **Step 3: ตรวจ** — เปิดหน้าด้วย Playwright (ติดตั้งแล้ว) กับข้อมูลตัวอย่างใน DB จำลอง ถ่ายภาพ 390px และ 1280px ไม่มี scroll แนวนอนและไม่มี error ใน console
- [ ] **Step 4:** เผยแพร่เป็น Artifact ส่วนตัว (ไม่แชร์) แล้ว Commit เฉพาะไฟล์ HTML ที่ไม่มีข้อมูลจริง

### Task 6: รันอัตโนมัติและ insight รายสัปดาห์

**Interfaces:**
- Consumes: CLI `collect --projects projects`, `eligibility`, Artifact DB จาก Task 5

- [ ] **Step 1:** หลังผู้ใช้ตั้ง key แล้ว รัน `python3 tools/yt_stats.py collect @vision6498 --projects projects` จริงหนึ่งครั้ง เขียน `videos` + `snapshots` ลง DB ด้วย ArtifactData แบบ batch ตรวจว่าแดชบอร์ดแสดงตัวเลขตรงกับหน้า YouTube จริง 2 คลิป
- [ ] **Step 2:** `create_trigger` รายวัน (เซสชันใหม่ต่อครั้ง, เวลานอกช่วง 6–9 โมงเช้าแปซิฟิก) ที่ prompt ครบในตัว: รัน collect → เขียน DB → ถ้าล้ม แจ้งสาเหตุ
- [ ] **Step 3:** `create_trigger` รายสัปดาห์: รัน `eligibility` แล้วใช้ skill `reality-check` เขียน insight ลง `insights`; กลุ่มที่ไม่ผ่านเกณฑ์แสดง "ยังสรุปไม่ได้" เท่านั้น
- [ ] **Step 4:** ยืนยันว่าเซสชันที่ตั้งเวลาเขียน DB ได้จริงด้วย `fire_trigger` หนึ่งครั้ง ถ้าไม่ได้ ให้บันทึกทางสำรอง ("ผู้ใช้สั่งเซสชันเก็บข้อมูลเอง") ใน `docs/analytics-setup.md` และแจ้งผู้ใช้
- [ ] **Step 5:** เพิ่มบรรทัดใน `make-clip` ให้อ่าน `docs/analytics-learnings.md` ตอนเลือกหัวข้อ แล้วแจ้งผู้ใช้ว่าแก้ไฟล์ร่วมนี้ Commit
