# ตั้งค่าระบบติดตามสถิติ YouTube

ช่อง: `@vision6498` · ตัวเก็บข้อมูล: `tools/yt_stats.py` · สเปก: `docs/superpowers/specs/2026-11-28-youtube-analytics-design.md`

## ผู้ใช้ทำครั้งเดียว (ทำแล้ว 2026-11-28)
1. สร้าง Google Cloud project และเปิด YouTube Data API v3
2. สร้าง API key (Public data) จำกัด API restrictions = YouTube Data API v3, Application restrictions = None
3. ใส่ key ในหน้าแก้ไข environment → ข้อมูลลับของเครือข่าย (Network secrets):
   ประเภท Bearer, เว็บไซต์ `www.googleapis.com`, ส่วนหัวกำหนดเอง ชื่อ `x-goog-api-key` คำนำหน้าว่าง ค่า = key
   (proxy แนบ key ให้ทุกคำขอไป host นี้ ไม่ต้องมีตัวแปร env และไม่มี key ในไฟล์ใดๆ)
4. ถ้า key เคยหลุดในแชต ให้ Rotate key ใน Google Cloud แล้วแก้ค่าในข้อ 3

## ใช้งาน
```bash
python3 tools/yt_stats.py collect @vision6498 --projects projects > /tmp/snap.json
python3 tools/yt_stats.py eligibility < /tmp/snap.json
```
- ห้ามเก็บ snapshot หรือตัวเลขช่องใน repo (public): เขียนลงฐานข้อมูลของแดชบอร์ดเท่านั้น
- exit 2 = ไม่พบช่อง/ไม่มีคลิป, exit 3 = API ปฏิเสธ (อ่านเหตุผลใน stderr; 403 ที่ไม่ใช่โควตา = key ไม่ถึง Google หรือ header ผิด)

## ทางสำรอง
ถ้า scheduled task เขียนฐานข้อมูลของแดชบอร์ดไม่ได้ ให้ผู้ใช้เปิดเซสชันใหม่แล้วสั่ง "เก็บสถิติ YouTube" เซสชันนั้นจะรัน collect แล้วเขียนลงฐานข้อมูลเอง
