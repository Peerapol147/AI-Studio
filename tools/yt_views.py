# ค้น YouTube Shorts อ่านแค่ยอดวิว (ไม่ดาวน์โหลด): python3 -I tools/yt_views.py "คำค้น" ["คำค้น2" ...]
# ไทย: hl=th gl=TH; อังกฤษใช้ curl ... &hl=en&gl=US | grep accessibilityText (ดู HANDOFF-planning.md)
import sys,re,urllib.parse,subprocess
for q in sys.argv[1:]:
    u="https://www.youtube.com/results?search_query="+urllib.parse.quote(q)+"&sp=EgIYAQ%253D%253D&hl=th&gl=TH"
    h=subprocess.run(["curl","-s","-A","Mozilla/5.0","-H","Accept-Language: th-TH",u],capture_output=True,text=True).stdout
    print("==",q)
    for t in re.findall(r'"accessibilityText":"([^"]{0,400}?) - เล่นวิดีโอสั้น"',h)[:8]:
        m=re.search(r'(.*), การดู (.*?) ครั้ง',t)
        if m: print(f"  {m.group(2):>10} | {m.group(1)[:60]}")
