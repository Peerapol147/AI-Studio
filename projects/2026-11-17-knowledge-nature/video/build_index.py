#!/usr/bin/env python3
"""Generates index.html (one composition, language = variable "lang": th | en).
Caption chunks come from assets/audio/words.json (th) and words-en.json (en); times are the
first-character / first-word start of each chunk. Run: python3 build_index.py"""
import html, json, pathlib

DUR = 27.94
CAPS = {
 'th': [(0,"เพื่อนๆ รู้ไหมว่า"),(1.04,"มีสัตว์ตัวนึง"),(1.68,"ที่ขี้ออกมา"),(2.26,"เป็นลูกเต๋า"),
  (2.92,"เจ้าตัวนี้คือ"),(3.62,"วอมแบต"),(4.12,"สัตว์ป่าจากออสเตรเลีย"),(5.32,"หลายคนคิดว่า"),
  (6.02,"รูก้นของมัน"),(6.68,"คงเป็นสี่เหลี่ยม"),(7.52,"แต่ความจริงคือ"),(8.56,"รูก้นมันกลม"),
  (9.16,"เหมือนสัตว์ทั่วไปเลย"),(10.24,"นักวิทยาศาสตร์"),(10.92,"เลยเข้าไปดู"),(11.38,"ในลำไส้"),
  (12.10,"แล้วพบว่า"),(12.58,"ผนังลำไส้"),(13.22,"ช่วงท้าย"),(13.86,"มีส่วนแข็ง"),(14.44,"กับส่วนนิ่ม"),
  (14.96,"สลับกัน"),(15.68,"ส่วนแข็ง"),(16.08,"บีบตัวเร็วกว่า"),(17.04,"เลยค่อยๆ"),(17.54,"กดก้อนขี้"),
  (18.18,"จนเกิดมุม"),(18.96,"บวกกับก้อนขี้"),(19.64,"ที่แห้งลงเรื่อยๆ"),(20.68,"พอออกมา"),
  (21.14,"เลยกลายเป็น"),(21.60,"ลูกเต๋าเหลี่ยมเป๊ะ"),(22.48,"ทั้งที่ออกจาก"),(23.02,"รูกลมๆ นั่นเอง"),
  (24.08,"แล้วเพื่อนๆ ว่า"),(25.02,"มันขี้เป็นเหลี่ยม"),(25.72,"ไปเพื่ออะไรกันน้า?"),(26.80,"คอมเมนต์บอกหน่อย!")],
 'en': [(0,"There's an animal"),(0.82,"on this planet"),(1.56,"that poops"),(2.12,"perfect little cubes."),
  (3.32,"Meet the wombat,"),(4.26,"straight out of"),(4.74,"Australia."),(5.48,"So you'd think"),(5.96,"its butt"),
  (6.38,"must be square,"),(7.14,"right?"),(7.54,"Nope."),(7.96,"It's round,"),(8.66,"just like everyone else's."),
  (9.82,"When scientists"),(10.66,"looked inside,"),(11.54,"they found the end"),(12.26,"of its gut"),
  (12.92,"has stiff"),(13.44,"and stretchy sections"),(14.74,"side by side."),(15.70,"The stiff parts"),
  (16.56,"squeeze faster,"),(17.68,"slowly pressing"),(18.46,"corners into"),(19.04,"the poop,"),
  (19.56,"and as it dries"),(20.28,"out on the way,"),(21.14,"it comes out"),(21.72,"as a perfect cube"),
  (22.92,"from a perfectly"),(23.74,"round hole."),(24.70,"So why would"),(25.20,"an animal need"),
  (25.98,"square poop?"),(26.74,"Tell me in the"),(27.22,"comments.")],
}

def caps(lang):
    out = []
    rows = CAPS[lang]
    for i, (s, txt) in enumerate(rows):
        e = rows[i + 1][0] if i + 1 < len(rows) else DUR
        d = round(e - s, 3)
        assert d >= 0.4, (lang, txt, d)
        size = 78 if len(txt) <= 15 else (68 if len(txt) <= 19 else 62)
        out.append(f'  <div id="c{lang}{i}" class="clip cap" data-start="{s}" data-duration="{d}" '
                   f'data-track-index="{20 if lang=="th" else 21}"><span style="font-size:{size}px">{html.escape(txt)}</span></div>')
    return '\n'.join(out)

CAPTIMES = {l: [r[0] for r in v] for l, v in CAPS.items()}

page = pathlib.Path(__file__).with_name('index.html.tpl').read_text()
page = (page.replace('%%DUR%%', str(DUR)).replace('%%CAPS_TH%%', caps('th')).replace('%%CAPS_EN%%', caps('en'))
        .replace('%%CAPTIMES%%', json.dumps(CAPTIMES)))
pathlib.Path(__file__).with_name('index.html').write_text(page)
print('index.html written')
