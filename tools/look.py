#!/usr/bin/env python3
"""Per-episode look (editing v3): pick one and check it does not repeat the channel's last 3 episodes.

  python3 tools/look.py pick  <project> [--write] [--set axis=value ...]
  python3 tools/look.py check <project> [--final] [--no-git]

<project> = projects/<YYYY-MM-DD>-<channel>-<slug>. Catalog: templates/looks/looks.json.
look.json = {"template": "brainrot-v3", "palette": .., "font": .., "caption": .., "opening": .., "cover": ..,
             "transition": .., "music_mood": .., "voice": "<catalog key>|id:<elevenlabs voice_id>",
             "music_file": "<file in assets/audio>|null", "cover_text": "<frame-0 / cover text>", "why": ".."}

History = the other projects of the same channel, from projects/ in this checkout AND from every
episode branch git knows (refs/remotes/origin/claude/ep-*, refs/heads/claude/ep-*; run
`git fetch origin 'refs/heads/claude/ep-*:refs/remotes/origin/claude/ep-*'` first). Episodes without
look.json count as the brainrot-v2 look (looks.json "legacy_v2"); their music file is read from
video/index.html, else assets/credits/music.json; their cover text from thumbnail.md (the bold text on the
"ข้อความ" line). Order = date in the id, then the last commit that touched it; episodes dated after <project>
are ignored.

check, exit 1 (ERROR) when:
  - look.json missing / not JSON / an axis missing or not in the catalog
  - palette or opening is the same as the previous episode
  - all visual axes (palette, font, caption, opening, cover, transition) equal one of the last 3 episodes
  - music_file is the same file as the previous episode (no same background music back to back)
  - cover_text equal or similar (character-pair overlap >= 0.6) to the cover text of one of the last 3 episodes
  - --final and music_file or cover_text is empty, or no claude/ep-* branch is known to git (history not fetched)
WARN (exit 0): any other axis equal to the previous episode; music_file / cover_text not set yet; no ep branches.
These thresholds are tool settings (dev brief: "differs from the last 3"; planning room 2026-11-23: cover text
must not repeat), not research numbers.
"""
import argparse, hashlib, json, pathlib, re, subprocess, sys

ROOT = pathlib.Path(__file__).resolve().parents[1]
ID_RE = re.compile(r'^(\d{4}-\d{2}-\d{2})-([a-z]+)-(.+)$')
MUSIC_RE = re.compile(r'assets/(music[^"\'/\s]*\.mp3)')
COVER_RE = re.compile(r'ข้อความ[^\n]*?\*\*"?([^*"]+)"?\*\*')
RECENT = 3
SIMILAR = 0.6


def catalog(root):
    return json.loads((root / 'templates' / 'looks' / 'looks.json').read_text())


def options(cat, axis):
    return [k for k in cat[axis] if not k.startswith('_')]


def voice_key(cat, v):
    """Normalise a voice to its ElevenLabs id so 'george' and 'id:JBFq...' compare equal."""
    if isinstance(v, str) and v.startswith('id:'):
        return v[3:]
    if isinstance(v, str) and v in cat['voice'] and not v.startswith('_'):
        return cat['voice'][v]['id']
    return v


def _git(root, *args):
    r = subprocess.run(['git', '-C', str(root), *args], capture_output=True, text=True)
    return r.stdout if r.returncode == 0 else None


def _music_from_html(text):
    m = MUSIC_RE.search(text or '')
    return m.group(1) if m else None


def _music_from_credits(text):
    """assets/credits/music.json (tools/music.sh): {"audio/music-x.mp3": "credit line"} -> first music file."""
    try:
        keys = [k for k in json.loads(text or '{}') if 'music' in pathlib.Path(k).name]
    except ValueError:
        return None
    return pathlib.Path(sorted(keys)[0]).name if keys else None


def _cover_from_thumb(text):
    m = COVER_RE.search(text or '')
    return m.group(1).strip() if m else None


def _norm(s):
    return re.sub(r'[\s*?!.,:;"\'“”‘’=\-–—()]+', '', (s or '').lower())


def similarity(a, b):
    """Dice overlap of character pairs after removing spaces/punctuation (1.0 = same text)."""
    a, b = _norm(a), _norm(b)
    if not a or not b:
        return 0.0
    if a == b:
        return 1.0
    pa = [a[i:i + 2] for i in range(len(a) - 1)] or [a]
    pb = [b[i:i + 2] for i in range(len(b) - 1)] or [b]
    common, rest = 0, list(pb)
    for x in pa:
        if x in rest:
            rest.remove(x)
            common += 1
    return 2 * common / (len(pa) + len(pb))


def history(root, channel, exclude, use_git=True, until='9999-99-99'):
    """{project id: {"look": dict|None, "music_file": str|None, "ts": int, "src": str}} for one channel."""
    found = {}

    def add(pid, look, music, ts, src, cover=None):
        old = found.get(pid)
        if old is None or (old['look'] is None and look is not None) or (
                (old['look'] is None) == (look is None) and ts > old['ts']):
            found[pid] = {'look': look, 'music_file': music, 'ts': ts, 'src': src, 'cover_text': cover}

    def keep(pid):
        m = ID_RE.match(pid)
        return m and m.group(2) == channel and pid != exclude and m.group(1) <= until

    for d in sorted((root / 'projects').glob('*/')):
        pid = d.name
        if not keep(pid):
            continue
        look = None
        if (d / 'look.json').exists():
            try:
                look = json.loads((d / 'look.json').read_text())
            except ValueError:
                look = None
        rd = lambda rel: (d / rel).read_text() if (d / rel).exists() else None
        music = ((look or {}).get('music_file') or _music_from_html(rd('video/index.html'))
                 or _music_from_credits(rd('assets/credits/music.json')))
        cover = (look or {}).get('cover_text') or _cover_from_thumb(rd('thumbnail.md'))
        ts = int((_git(root, 'log', '-1', '--format=%ct', '--', f'projects/{pid}') or '0').strip() or 0)
        add(pid, look, music, ts, 'projects/', cover)
    if use_git:
        refs = _git(root, 'for-each-ref', '--format=%(refname)', 'refs/remotes/origin/claude/ep-*',
                    'refs/heads/claude/ep-*') or ''
        for ref in refs.split():
            names = _git(root, 'ls-tree', '--name-only', f'{ref}:projects') or ''
            for pid in names.split():
                if not keep(pid):
                    continue
                raw = _git(root, 'show', f'{ref}:projects/{pid}/look.json')
                try:
                    look = json.loads(raw) if raw else None
                except ValueError:
                    look = None
                show = lambda rel: _git(root, 'show', f'{ref}:projects/{pid}/{rel}')
                music = ((look or {}).get('music_file') or _music_from_html(show('video/index.html'))
                         or _music_from_credits(show('assets/credits/music.json')))
                cover = (look or {}).get('cover_text') or _cover_from_thumb(show('thumbnail.md'))
                ts = int((_git(root, 'log', '-1', '--format=%ct', ref, '--', f'projects/{pid}') or '0').strip() or 0)
                add(pid, look, music, ts, ref.replace('refs/remotes/', '').replace('refs/heads/', ''), cover)
    found['_refs'] = len(refs.split()) if use_git else None
    return found


def recent(root, project, use_git=True):
    pid = project.name
    m = ID_RE.match(pid)
    if not m:
        raise SystemExit(f'{pid}: project folder must be <YYYY-MM-DD>-<channel>-<slug>')
    cat = catalog(root)
    h = history(root, m.group(2), pid, use_git, until=m.group(1))
    refs = h.pop('_refs', None)
    order = sorted(h, key=lambda p: (ID_RE.match(p).group(1), h[p]['ts'], p))
    out = []
    for p in order[-RECENT:][::-1]:                       # newest first
        e = h[p]
        look = dict(e['look']) if e['look'] else {k: v for k, v in cat['legacy_v2'].items() if not k.startswith('_')}
        look['music_file'] = look.get('music_file') or e['music_file']
        look['cover_text'] = look.get('cover_text') or e['cover_text']
        out.append({'id': p, 'src': e['src'], 'legacy': e['look'] is None, 'look': look})
    return cat, out, refs


def validate(cat, look):
    errs = []
    for axis in cat['axes']:
        v = look.get(axis)
        if v is None:
            errs.append(f'{axis}: missing (choose one of {", ".join(options(cat, axis))})')
        elif axis == 'voice' and isinstance(v, str) and v.startswith('id:') and len(v) > 3:
            continue
        elif v not in options(cat, axis):
            errs.append(f'{axis}: {v!r} not in templates/looks/looks.json ({", ".join(options(cat, axis))})')
    return errs


def same(cat, axis, a, b):
    if axis == 'voice':
        return a is not None and voice_key(cat, a) == voice_key(cat, b)
    return a is not None and a == b


def check(root, project, final=False, use_git=True):
    errs, warns = [], []
    f = project / 'look.json'
    if not f.exists():
        return [f'{f} missing: run python3 tools/look.py pick {project} --write'], [], []
    try:
        look = json.loads(f.read_text())
    except ValueError as e:
        return [f'{f}: not JSON ({e})'], [], []
    cat, rec, refs = recent(root, project, use_git)
    errs += validate(cat, look)
    if refs == 0:
        (errs if final else warns).append(
            "git knows no claude/ep-* branch: run git fetch origin 'refs/heads/claude/ep-*:refs/remotes/origin/claude/ep-*' "
            "so the latest episodes are compared")
    if rec:
        prev = rec[0]
        for axis in ('palette', 'opening'):
            if same(cat, axis, look.get(axis), prev['look'].get(axis)):
                errs.append(f'{axis} {look.get(axis)!r} = previous episode {prev["id"]}: change it')
        for axis in cat['axes']:
            if axis not in ('palette', 'opening') and same(cat, axis, look.get(axis), prev['look'].get(axis)):
                warns.append(f'{axis} {look.get(axis)!r} = previous episode {prev["id"]}')
        mf = look.get('music_file')
        if mf and prev['look'].get('music_file') and pathlib.Path(mf).name == pathlib.Path(prev['look']['music_file']).name:
            errs.append(f'music_file {mf} = previous episode {prev["id"]}: pick another track')
    for r in rec:
        if all(same(cat, a, look.get(a), r['look'].get(a)) for a in cat['visual_axes']):
            errs.append(f'visual look (palette/font/caption/opening/transition) identical to {r["id"]}')
    ct = look.get('cover_text')
    for r in rec:
        old = r['look'].get('cover_text')
        if ct and old and similarity(ct, old) >= SIMILAR:
            errs.append(f'cover_text {ct!r} too close to {r["id"]} cover {old!r} '
                        f'(similarity {similarity(ct, old):.2f} >= {SIMILAR}): write a new frame-0/cover line')
    if not look.get('music_file'):
        (errs if final else warns).append('music_file not set (voice step writes the chosen track into look.json)')
    if not ct:
        (errs if final else warns).append('cover_text not set (the frame-0 / cover text, = episode.json title)')
    return errs, warns, rec


def pick(root, project, pins, use_git=True):
    cat, rec, refs = recent(root, project, use_git)
    look = {'template': 'brainrot-v3'}
    for axis in cat['axes']:
        if axis in pins:
            look[axis] = pins[axis]
            continue
        used = [r['look'].get(axis) for r in rec]                     # newest first
        opts = options(cat, axis)
        h = lambda o: hashlib.sha256(f'{project.name}|{axis}|{o}'.encode()).hexdigest()

        def age(o):          # not used in the last 3 = best; else the one used longest ago
            ids = [voice_key(cat, u) for u in used] if axis == 'voice' else used
            key = voice_key(cat, o) if axis == 'voice' else o
            return ids.index(key) if key in ids else RECENT + 1
        look[axis] = sorted(opts, key=lambda o: (-age(o), h(o)))[0]
    look['music_file'] = None
    look['cover_text'] = None
    look['why'] = 'เลือกอัตโนมัติด้วย tools/look.py pick (ต่างจาก 3 ตอนล่าสุด) แก้ได้: เสียงพากย์/อารมณ์เพลงให้เลือกตามแนวเรื่อง'
    return look, rec, refs


def _print_recent(rec):
    if not rec:
        print('history: no earlier episode of this channel found (fetch the ep branches?)')
    for r in rec:
        lk = r['look']
        tag = ' (no look.json = brainrot-v2 look)' if r['legacy'] else ''
        print(f'  {r["id"]} [{r["src"]}]{tag}: ' + ', '.join(f'{a}={lk.get(a)}' for a in
              ('palette', 'font', 'caption', 'opening', 'cover', 'transition', 'music_mood', 'voice', 'music_file',
               'cover_text')))


def main(argv=None):
    ap = argparse.ArgumentParser(description=__doc__.split('\n')[0])
    sub = ap.add_subparsers(dest='cmd', required=True)
    p1 = sub.add_parser('pick'); p1.add_argument('project', type=pathlib.Path)
    p1.add_argument('--write', action='store_true'); p1.add_argument('--set', action='append', default=[])
    p1.add_argument('--no-git', action='store_true')
    p2 = sub.add_parser('check'); p2.add_argument('project', type=pathlib.Path)
    p2.add_argument('--final', action='store_true'); p2.add_argument('--no-git', action='store_true')
    a = ap.parse_args(argv)
    project = a.project.resolve()
    root = project.parents[1] if project.parent.name == 'projects' else ROOT
    if a.cmd == 'pick':
        pins = dict(s.split('=', 1) for s in a.set)
        look, rec, refs = pick(root, project, pins, not a.no_git)
        if refs == 0:
            print("WARN git knows no claude/ep-* branch: fetch them first or the newest episodes are missing")
        print('last episodes (newest first):'); _print_recent(rec)
        print(json.dumps(look, ensure_ascii=False, indent=2))
        if a.write:
            if (project / 'look.json').exists():
                raise SystemExit(f'{project / "look.json"} exists: edit it, or delete it first')
            project.mkdir(parents=True, exist_ok=True)
            (project / 'look.json').write_text(json.dumps(look, ensure_ascii=False, indent=2) + '\n')
            print('wrote', project / 'look.json')
        return 0
    errs, warns, rec = check(root, project, a.final, not a.no_git)
    print('compared with (newest first):'); _print_recent(rec)
    for w in warns:
        print('WARN ', w)
    for e in errs:
        print('ERROR', e)
    print('look: FAIL' if errs else 'look: OK')
    return 1 if errs else 0


if __name__ == '__main__':
    sys.exit(main())
