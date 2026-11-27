#!/usr/bin/env python3
"""Write assets/audio/timing[-<lang>].md from the REAL word timestamps (words.json), never by estimate.

caffeine-ranking 2026-11-27: the voice agent typed line start times by hand (estimated) and they were wrong, so the
editor set picture beats on the wrong words. This tool aligns every script line with the transcript and prints start /
end / length per line.

  python3 tools/timing.py <project> [th|en] [--script FILE] [--out FILE]
    script: --script, else <project>/script-vo-<lang>.txt, else assets/audio/vo-<lang>-tts.txt (the text sent to TTS)
            one line per row; a one-line script is split at spaces (Thai phrases)
    words : assets/audio/words.json (th) / words-<lang>.json
    out   : assets/audio/timing.md (th) / timing-<lang>.md

Alignment: the script and the transcript are compared character by character (spaces / punctuation ignored, difflib),
so a word the transcriber spelled differently (Trick / ทริก) still gets the times of its neighbours. A row whose
letters matched < 60 % is marked "≈ check by ear". Gaps > 0.4 s between rows are listed (style.md: no silence > 0.4 s).
Exit 1 when the words file or the script is missing / empty.
"""
import argparse, difflib, json, pathlib, re, subprocess, sys

STRIP = re.compile(r"[\s.,!?…'\"“”‘’\-–—:;()*]+")
GAP = 0.4


def norm(s):
    return STRIP.sub('', s).lower()


def stream(words):
    """[(char, start, end)] of the transcript without spaces/punctuation."""
    out = []
    for w in words:
        if w.get('type', 'word') != 'word':
            continue
        chars = w.get('characters') or [{'text': c, 'start': w['start'], 'end': w['end']} for c in w['text']]
        for c in chars:
            for ch in c['text']:
                if norm(ch):
                    out.append((ch.lower(), float(c.get('start', w['start'])), float(c.get('end', w['end']))))
    return out


def rows_of(text):
    lines = [ln.strip() for ln in text.splitlines() if norm(ln)]
    if len(lines) == 1:
        lines = [p for p in re.split(r'\s+', lines[0]) if norm(p)]
    return lines


def align(lines, st):
    """-> [(line, start, end, matched share)]"""
    script = ''.join(norm(ln) for ln in lines)
    heard = ''.join(c for c, _, _ in st)
    m = {}
    for a, b, n in difflib.SequenceMatcher(None, script, heard, autojunk=False).get_matching_blocks():
        for k in range(n):
            m[a + k] = b + k
    out, pos = [], 0
    for ln in lines:
        n = len(norm(ln))
        idx = [m[i] for i in range(pos, pos + n) if i in m]
        share = len(idx) / max(1, n)
        if idx:
            s, e = st[min(idx)][1], st[max(idx)][2]
        else:                                    # nothing matched: between the neighbours, filled in below
            s = e = None
        out.append([ln, s, e, share])
        pos += n
    for i, r in enumerate(out):                  # unmatched rows: from the previous end to the next start
        if r[1] is None:
            prev = next((x[2] for x in reversed(out[:i]) if x[2] is not None), 0.0)
            nxt = next((x[1] for x in out[i + 1:] if x[1] is not None), st[-1][2] if st else prev)
            r[1], r[2] = prev, nxt
    return out


def main(argv=None):
    ap = argparse.ArgumentParser(description=__doc__.split('\n')[0])
    ap.add_argument('project', type=pathlib.Path)
    ap.add_argument('lang', nargs='?', default='th')
    ap.add_argument('--script', type=pathlib.Path)
    ap.add_argument('--out', type=pathlib.Path)
    a = ap.parse_args(argv)
    proj, lang = a.project, a.lang
    aud = proj / 'assets' / 'audio'
    wf = aud / ('words.json' if lang == 'th' else f'words-{lang}.json')
    sf = a.script or next((f for f in (proj / f'script-vo-{lang}.txt', aud / f'vo-{lang}-tts.txt') if f.exists()), None)
    if not wf.exists():
        print(f'ERROR {wf} missing: run tools/words.sh on the FINAL voice file first')
        return 1
    if not sf or not sf.exists():
        print(f'ERROR no script text: pass --script, or keep script-vo-{lang}.txt / assets/audio/vo-{lang}-tts.txt')
        return 1
    wd = json.loads(wf.read_text())
    st = stream(wd.get('words', []))
    lines = rows_of(sf.read_text())
    if not st or not lines:
        print(f'ERROR empty {"transcript" if not st else "script"}')
        return 1
    vo = aud / f'vo-{lang}.mp3'
    dur = wd.get('audio_duration_secs')
    if vo.exists():
        r = subprocess.run(['ffprobe', '-v', 'error', '-show_entries', 'format=duration', '-of', 'csv=p=0', str(vo)],
                           capture_output=True, text=True)
        try:
            dur = float(r.stdout)
        except ValueError:
            pass
    rows = align(lines, st)
    out = [f'# timing {vo.name if vo.exists() else wf.name}' + (f' ({dur:.2f} วิ)' if dur else ''),
           f'เวลาจาก `{wf.name}` ด้วย `python3 tools/timing.py` (ห้ามประมาณเอง; แก้บท/อัดใหม่ = รันใหม่)', '',
           '| # | ข้อความ | เริ่ม (วิ) | จบ (วิ) | ยาว | หมายเหตุ |', '|---|---|---|---|---|---|']
    for i, (ln, s, e, share) in enumerate(rows, 1):
        note = '' if share >= 0.6 else f'≈ ถอดตรงบท {share:.0%} ฟังเช็ก'
        out.append(f'| {i} | {ln.replace("|", "/")} | {s:.2f} | {e:.2f} | {e - s:.2f} | {note} |')
    gaps = [(rows[i][2], rows[i + 1][1]) for i in range(len(rows) - 1) if rows[i + 1][1] - rows[i][2] > GAP]
    out += ['', f'ช่วงเงียบ > {GAP} วิ: ' + (', '.join(f'{a:.2f}-{b:.2f}' for a, b in gaps) or 'ไม่มี')]
    dst = a.out or aud / ('timing.md' if lang == 'th' else f'timing-{lang}.md')
    dst.write_text('\n'.join(out) + '\n')
    print('\n'.join(out))
    print(f'-> {dst}')
    return 0


if __name__ == '__main__':
    sys.exit(main())
