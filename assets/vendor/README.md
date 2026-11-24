# assets/vendor: ไลบรารีลอยๆ ใช้ในฉาก HyperFrames (ฝังไฟล์ ไม่ต้องพึ่ง CDN ตอนเรนเดอร์)

| ไฟล์ | ใช้ทำอะไร | ไลเซนส์ |
|---|---|---|
| `rough.js` (roughjs 4.6.6) | เส้นวาดมือ/สเก็ตช์ ลูกศร วงล้อมคำ | MIT |
| `flubber.min.js` (0.4.2) | morph รูปทรง SVG ไปอีกรูป (`flubber.interpolate`) | MIT |
| `d3-path.min.js` + `d3-shape.min.js` (3.x) | เส้นกราฟ พื้นที่ โดนัท (`d3.line/area/arc/pie`) โหลด d3-path ก่อน | ISC |
| `lucide/*.svg` (lucide-static 1.75.0) | ไอคอนมินิมอลที่เลือกไว้ ~70 อัน ใช้ `currentColor` ปรับสี/ความหนาเส้นได้ | ISC |

GSAP อยู่ใน HyperFrames อยู่แล้ว ไม่ต้องเพิ่ม ฟอนต์ไทยอยู่ที่ `assets/fonts/` (Geist ไม่มีตัวไทย อย่าใช้กับซับ)
ข้อความไลเซนส์เต็ม: `LICENSES.md` (rough, flubber, d3) และ `lucide/LICENSE`
ต้องการไอคอนอื่น: `npm pack lucide-static@1.75.0` ในโฟลเดอร์ชั่วคราว แตกไฟล์ แล้วคัดลอก `package/icons/<ชื่อ>.svg` มาเพิ่ม (raw.githubusercontent มัก 403 ในเครื่องคลาวด์)
`smartphone`, `bed`, `message-circle` เพิ่มทีหลังสำหรับแม่แบบ `templates/brainrot-v2/` (lucide-static 1.75.0 เวอร์ชันเดียวกัน ไลเซนส์ ISC ตาม `lucide/LICENSE`)
