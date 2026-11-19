#!/usr/bin/env python3
"""เครดิตแยกตามขั้น แล้วรวมเป็น assets/CREDITS.md ทีเดียว (รันซ้ำกี่รอบก็ไม่มีเครดิตซ้ำ)

แต่ละขั้นเขียนของตัวเองที่ assets/credits/<stage>.json = {"<path จาก assets/>": "<บรรทัดเครดิต>"}
  footage.sh -> footage, music.sh -> music  (ขั้นอื่นเพิ่มเองด้วยคำสั่ง add)
CREDITS.md = ส่วนที่คนเขียนเอง (เก็บไว้ตามเดิม) + บล็อกอัตโนมัติระหว่าง marker ที่สร้างใหม่ทุกครั้ง
  - ไฟล์ที่ถูกลบจาก assets/ แล้ว ไม่ขึ้นในบล็อก
  - บรรทัด "- <ชื่อไฟล์>: ..." แบบเก่า (ต่อท้ายโดยสคริปต์รุ่นก่อน) นอกบล็อก ถูกย้ายเข้าบล็อกแทน ไม่ซ้ำ

ใช้:
  python3 tools/credits.py add <project> <stage> <path-from-assets> "<line>"
  python3 tools/credits.py build <project>
"""
import json, pathlib, re, sys

START = "<!-- auto-credits:start (tools/credits.py; ห้ามแก้ในบล็อกนี้ แก้ที่ assets/credits/<stage>.json) -->"
END = "<!-- auto-credits:end -->"


def _stage_file(proj, stage):
    if not re.fullmatch(r"[a-z0-9_-]+", stage):
        raise SystemExit(f"stage ต้องเป็น a-z0-9_- : {stage!r}")
    return pathlib.Path(proj) / "assets" / "credits" / f"{stage}.json"


def add(proj, stage, rel, line):
    f = _stage_file(proj, stage)
    f.parent.mkdir(parents=True, exist_ok=True)
    d = json.loads(f.read_text(encoding="utf-8")) if f.exists() else {}
    d[rel] = line.strip()
    f.write_text(json.dumps(d, ensure_ascii=False, indent=1, sort_keys=True), encoding="utf-8")


def build(proj):
    proj = pathlib.Path(proj)
    assets = proj / "assets"
    entries = {}                                   # rel path -> (stage, line)
    for f in sorted((assets / "credits").glob("*.json")):
        for rel, line in json.loads(f.read_text(encoding="utf-8")).items():
            if (assets / rel).exists():
                entries[rel] = (f.stem, line)
    md = assets / "CREDITS.md"
    old = md.read_text(encoding="utf-8") if md.exists() else "# Credits\n"
    if START in old and END in old:
        head, rest = old.split(START, 1)
        tail = rest.split(END, 1)[1]
    else:
        head, tail = old, ""
    names = {pathlib.PurePosixPath(r).name for r in entries}
    legacy = re.compile(r"^- (\S+?):")             # "- pixabay-123.mp4: ..." from the old append-only scripts

    def keep(text):
        return "\n".join(l for l in text.split("\n") if not ((m := legacy.match(l)) and m.group(1) in names))
    head, tail = keep(head).rstrip("\n"), keep(tail).strip("\n")
    block = [START]
    for stage in sorted({s for s, _ in entries.values()}):
        block += ["", f"## {stage}"] + [entries[r][1] for r in sorted(entries) if entries[r][0] == stage]
    block += ["", END]
    md.write_text(head + "\n\n" + "\n".join(block) + "\n" + (("\n" + tail + "\n") if tail else ""), encoding="utf-8")
    return len(entries)


if __name__ == "__main__":
    a = sys.argv[1:]
    if a[:1] == ["add"] and len(a) == 5:
        add(*a[1:]); print(f"{build(a[1])} credits -> {a[1]}/assets/CREDITS.md")
    elif a[:1] == ["build"] and len(a) == 2:
        print(f"{build(a[1])} credits -> {a[1]}/assets/CREDITS.md")
    else:
        sys.exit(__doc__)
