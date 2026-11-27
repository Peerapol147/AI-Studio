#!/usr/bin/env python3
"""Footage search over many sources + coverage report (palmaris feedback 2, 2026-11-26).

The user: "ทำไมหาฟุตไม่ได้ เกิดจากอะไร ทำไมไม่บอก" / "หาฟุตมาให้ได้". The footage agent searched a few Pixabay video
words, no stills, gave up, and nobody told the user. The director then found 9 files with 35 video + 13 still words.

  python3 tools/footage_search.py search <project> <shot id> "<term>" ["<term>" ...] [--kinds video,photo]
          [--sources pixabay,pexels,openverse,nasa,wikimedia] [--per 6]
      every term x source x kind -> candidates appended to <project>/assets/footage/SEARCH.json (no download).
      Thai terms are sent as-is (Pixabay gets lang=th); write both Thai and English terms.
  python3 tools/footage_search.py report <project> [--min-terms 10]
      per shot that needs footage (shots.json, minus shots with "footage": false): terms tried, languages, kinds,
      sources, and whether footage.json has a file. exit 1 when a searched shot has < min terms / only one language /
      only one kind / only one source; exit 2 (and writes assets/footage/ALERT.md) when < 50 % of the shots got a file:
      the director must tell the user right away with the choices (graphic, hand-drawn rig, user films it), never silently.

Rate limits: a 429 is retried at most twice (3 s, then 9 s; never a long retry-after; FOOTAGE_BACKOFF is clamped in code
to <= 12 s of waiting) and then that source is logged as BLOCKED in SEARCH.json "_blocked" and skipped for every shot
for BLOCK_MIN (10) minutes, so the whole footage step waits at most ~12 s per source (the "fail fast, never wait
silently" rule still holds). Every request goes through tools/get.sh. Keys: PIXABAY_API_KEY, PEXELS_API_KEY (env or
.env; a source without its key is skipped and logged). Base URLs can be overridden (PIXABAY_BASE, PEXELS_BASE,
OPENVERSE_BASE, NASA_BASE, WIKIMEDIA_BASE) for tests.

ONE AT A TIME (itch 2026-11-27: searches run in parallel = 429 from every source): `search` takes an exclusive lock
(FOOTAGE_LOCK, default <tmp>/ai-studio-footage-search.lock) for the whole call. A second search started meanwhile prints
"WAIT ... (parallel search = 429)" and queues behind it for up to FOOTAGE_LOCK_WAIT s (default 600), then exits 3.
Do not start footage_search in parallel (no `&`, no several agents at once): run the shots one command after another.
"""
import argparse, contextlib, fcntl, json, os, pathlib, re, subprocess, sys, tempfile, time, urllib.parse

ROOT = pathlib.Path(__file__).resolve().parents[1]
GET = ROOT / 'tools' / 'get.sh'
MAX_WAIT = 12          # s of sleeping per source per run, hard ceiling (review 2026-11-26): env cannot raise it
BLOCK_MIN = 10         # min: a source BLOCKED in SEARCH.json within this time is skipped for every shot, no retry


def _backoff(raw):
    """FOOTAGE_BACKOFF ("3,9"; tests "0,0") clamped: at most 2 waits, each <= 9 s, total <= MAX_WAIT."""
    out, total = [], 0.0
    for x in (raw or '3,9').split(',')[:2]:
        try:
            w = min(max(float(x), 0.0), 9.0)
        except ValueError:
            continue
        w = min(w, MAX_WAIT - total)
        out.append(w); total += w
    return tuple(out)


BACKOFF = _backoff(os.environ.get('FOOTAGE_BACKOFF'))
UA = 'AI-Studio-footage-search/1.0 (stock footage lookup)'
THAI = re.compile(r'[฀-๿]')
SOURCES = ('pixabay', 'pexels', 'openverse', 'nasa', 'wikimedia')


def _env_key(name):
    if os.environ.get(name):
        return os.environ[name]
    f = ROOT / '.env'
    if f.exists():
        m = re.search(rf'^\s*(?:export\s+)?{name}=["\']?([^"\'\n]+)', f.read_text(), re.M)
        if m:
            return m.group(1).strip()
    return None


def fetch(url, headers=(), sleep=time.sleep):
    """(status, data|None, note). status: ok | blocked | error. 429 -> retried with BACKOFF, then blocked."""
    args = ['bash', str(GET), url, '-']
    for h in headers:
        args += ['-H', h]
    for k, wait in enumerate((0,) + BACKOFF):
        if wait:
            sleep(wait)
        r = subprocess.run(args, capture_output=True, text=True, env={**os.environ, 'GET_MAX_TIME': '30'})
        if r.returncode == 0:
            try:
                return 'ok', json.loads(r.stdout), f'tries={k + 1}'
            except ValueError:
                return 'error', None, 'not JSON'
        # get.sh's own "BLOCKED 429 <url>" / "HTTP 404 <url>" line, not the last line of a multi-line error body
        # (review: SEARCH.json notes showed a fragment of the server's HTML instead of the 429)
        lines = r.stderr.strip().splitlines()
        msg = next((ln for ln in lines if ln.startswith(('BLOCKED', 'HTTP '))), lines[-1] if lines else f'exit {r.returncode}')[:200]
        if r.returncode == 75 and 'BLOCKED 429' in r.stderr and k < len(BACKOFF):
            continue
        if r.returncode == 75 and k:
            msg = f'{msg} (after {k + 1} tries)'
        return ('blocked' if r.returncode == 75 else 'error'), None, msg
    return 'blocked', None, 'still 429 after backoff'


def q(base, path, **params):
    return f'{base}{path}?{urllib.parse.urlencode({k: v for k, v in params.items() if v is not None})}'


def search_one(src, kind, term, per):
    """-> (status, [candidate], note, url). Candidate: {source, kind, id, url, preview, page, creator, license, w, h, dur}."""
    th = bool(THAI.search(term))
    if src == 'pixabay':
        key = _env_key('PIXABAY_API_KEY')
        if not key:
            return 'skipped', [], 'no PIXABAY_API_KEY', None
        base = os.environ.get('PIXABAY_BASE', 'https://pixabay.com')
        url = q(base, '/api/videos/' if kind == 'video' else '/api/', key=key, q=term, per_page=max(3, per),
                safesearch='true', lang='th' if th else None)
        st, d, note = fetch(url)
        out = []
        for h in (d or {}).get('hits', [])[:per]:
            if kind == 'video':
                v = h.get('videos') or {}
                big = v.get('large') or v.get('medium') or {}
                out.append(dict(id=f"pixabay-{h['id']}", url=(v.get('medium') or big).get('url'), preview=big.get('thumbnail'),
                                w=big.get('width'), h=big.get('height'), dur=h.get('duration')))
            else:
                out.append(dict(id=f"pixabay-{h['id']}", url=h.get('largeImageURL') or h.get('webformatURL'),
                                preview=h.get('previewURL'), w=h.get('imageWidth'), h=h.get('imageHeight')))
            out[-1].update(page=h.get('pageURL'), creator=h.get('user'), license='Pixabay Content License', tags=h.get('tags'))
        return st, out, note, url.replace(key, '***')
    if src == 'pexels':
        key = _env_key('PEXELS_API_KEY')
        if not key:
            return 'skipped', [], 'no PEXELS_API_KEY', None
        base = os.environ.get('PEXELS_BASE', 'https://api.pexels.com')
        url = q(base, '/videos/search' if kind == 'video' else '/v1/search', query=term, per_page=per,
                locale='th-TH' if th else None)
        st, d, note = fetch(url, headers=[f'Authorization: {key}'])
        out = []
        for h in (d or {}).get('videos' if kind == 'video' else 'photos', [])[:per]:
            if kind == 'video':
                files = sorted(h.get('video_files') or [], key=lambda f: -(f.get('height') or 0))
                f = next((f for f in files if (f.get('height') or 0) <= 1920), files[0] if files else {})
                out.append(dict(id=f"pexels-{h['id']}", url=f.get('link'), preview=h.get('image'), w=h.get('width'),
                                h=h.get('height'), dur=h.get('duration'), creator=(h.get('user') or {}).get('name')))
            else:
                out.append(dict(id=f"pexels-{h['id']}", url=(h.get('src') or {}).get('large2x') or (h.get('src') or {}).get('original'),
                                preview=(h.get('src') or {}).get('medium'), w=h.get('width'), h=h.get('height'),
                                creator=h.get('photographer')))
            out[-1].update(page=h.get('url'), license='Pexels License')
        return st, out, note, url
    if src == 'openverse':
        if kind == 'video':
            return 'skipped', [], 'openverse has no video', None
        base = os.environ.get('OPENVERSE_BASE', 'https://api.openverse.org')
        url = q(base, '/v1/images/', q=term, license='cc0,by,by-sa,pdm', page_size=per)
        st, d, note = fetch(url)
        out = [dict(id=f"openverse-{h['id'][:8]}", url=h.get('url'), preview=h.get('thumbnail'), w=h.get('width'),
                    h=h.get('height'), page=h.get('foreign_landing_url'), creator=h.get('creator'),
                    license=f"{h.get('license', '').upper()} {h.get('license_version') or ''}".strip(), via=h.get('source'))
               for h in (d or {}).get('results', [])[:per]]
        return st, out, note, url
    if src == 'nasa':
        base = os.environ.get('NASA_BASE', 'https://images-api.nasa.gov')
        url = q(base, '/search', q=term, media_type='video' if kind == 'video' else 'image')
        st, d, note = fetch(url)
        out = []
        for it in ((d or {}).get('collection') or {}).get('items', [])[:per]:
            md = (it.get('data') or [{}])[0]
            out.append(dict(id=f"nasa-{md.get('nasa_id')}", url=it.get('href'), preview=((it.get('links') or [{}])[0]).get('href'),
                            page=f"https://images.nasa.gov/details/{md.get('nasa_id')}", creator=md.get('center') or 'NASA',
                            license='NASA media (public domain, no endorsement)', title=md.get('title')))
        return st, out, note, url
    if src == 'wikimedia':
        base = os.environ.get('WIKIMEDIA_BASE', 'https://commons.wikimedia.org')
        ftype = 'filetype:video' if kind == 'video' else 'filetype:bitmap'
        url = q(base, '/w/api.php', action='query', format='json', generator='search', gsrnamespace=6,
                gsrsearch=f'{term} {ftype}', gsrlimit=per, prop='imageinfo', iiprop='url|size|extmetadata', iiurlwidth=640)
        st, d, note = fetch(url, headers=[f'User-Agent: {UA}'])
        out = []
        for p in sorted(((d or {}).get('query') or {}).get('pages', {}).values(), key=lambda p: p.get('index', 0))[:per]:
            ii = (p.get('imageinfo') or [{}])[0]
            em = ii.get('extmetadata') or {}
            lic = (em.get('LicenseShortName') or {}).get('value', '')
            if not lic or re.search(r'\bN[CD]\b|-N[CD]', lic, re.I) or not re.search(r'CC0|CC BY|Public domain|PD', lic, re.I):
                continue
            out.append(dict(id=f"wikimedia-{p.get('pageid')}", url=ii.get('url'), preview=ii.get('thumburl'), w=ii.get('width'),
                            h=ii.get('height'), page=ii.get('descriptionurl'), license=lic or '?',
                            creator=re.sub('<[^>]+>', '', (em.get('Artist') or {}).get('value', ''))[:80]))
        return st, out, note, url
    raise SystemExit(f'unknown source {src}')


def search(project, shot, terms, kinds, sources, per, sleep=time.sleep):
    f = project / 'assets' / 'footage' / 'SEARCH.json'
    f.parent.mkdir(parents=True, exist_ok=True)
    db = json.loads(f.read_text()) if f.exists() else {}
    entry = db.setdefault(shot, {'tried': [], 'candidates': []})
    # a source BLOCKED in the last BLOCK_MIN minutes (any shot) is skipped right away: "skip for the whole run" holds
    # across the one-shot-per-call CLI, so 15 shots do not each wait out the backoff again
    now = time.time()
    blocks = db.setdefault('_blocked', {})
    blocked = {src for src, t in blocks.items() if now - t < BLOCK_MIN * 60}
    why = db.setdefault('_blocked_why', {})
    seen = {c['id'] + c['kind'] for c in entry['candidates']}
    for term in terms:
        for src in sources:
            for kind in kinds:
                if src in blocked:
                    entry['tried'].append(dict(q=term, source=src, kind=kind, status='skipped',
                                               note=f"blocked earlier this run: {why.get(src, 'BLOCKED')}"[:240]))
                    continue
                st, cands, note, _ = search_one(src, kind, term, per)
                entry['tried'].append(dict(q=term, lang='th' if THAI.search(term) else 'en', source=src, kind=kind,
                                           status=st, hits=len(cands), note=note))
                if st == 'blocked':
                    blocked.add(src)
                    blocks[src] = time.time()
                    why[src] = note
                    print(f'BLOCKED {src}: {note} -> skipped for the rest of this run', file=sys.stderr)
                for c in cands:
                    c.update(source=src, kind=kind, q=term)
                    if c['id'] + kind not in seen and c.get('url'):
                        seen.add(c['id'] + kind)
                        entry['candidates'].append(c)
                print(f'{shot}: {src:9s} {kind:5s} {term!r}: {st} {len(cands)}')
    f.write_text(json.dumps(db, ensure_ascii=False, indent=1) + '\n')
    print(f'{shot}: {len(entry["candidates"])} candidates in {f}')
    return entry


def report(project, min_terms=10):
    shots = json.loads((project / 'shots.json').read_text()).get('shots', [])
    need = [s['id'] for s in shots if s.get('footage', True) is not False]
    fj = project / 'footage.json'
    found = json.loads(fj.read_text()) if fj.exists() else {}
    sf = project / 'assets' / 'footage' / 'SEARCH.json'
    db = json.loads(sf.read_text()) if sf.exists() else {}
    errs, rows = [], []
    for sid in need:
        tried = [t for t in (db.get(sid) or {}).get('tried', []) if t.get('status') != 'skipped']
        terms = {t['q'] for t in (db.get(sid) or {}).get('tried', [])}
        langs = {('th' if THAI.search(t) else 'en') for t in terms}
        kinds = {t['kind'] for t in tried}
        srcs = {t['source'] for t in tried if t.get('status') == 'ok'}   # a blocked/error source did not answer
        has = bool((found.get(sid) or {}).get('src'))
        rows.append(f'| {sid} | {"✅ " + found[sid]["src"] if has else "❌"} | {len(terms)} | {",".join(sorted(langs))} | '
                    f'{",".join(sorted(kinds))} | {",".join(sorted(srcs))} |')
        if has:
            continue
        probs = []
        if len(terms) < min_terms:
            probs.append(f'{len(terms)} terms (< {min_terms})')
        if langs != {'th', 'en'}:
            probs.append('Thai and English terms both needed')
        if kinds != {'video', 'photo'}:
            probs.append('search videos and stills')
        if len(srcs) < 2:
            probs.append('only one source answered (try pexels/openverse/nasa/wikimedia)')
        if probs:
            errs.append(f'shot {sid} has no file and was not searched enough: ' + '; '.join(probs))
    got = sum(1 for sid in need if (found.get(sid) or {}).get('src'))
    cov = got / len(need) if need else 1.0
    table = '\n'.join(['| ช็อต | ไฟล์ | คำ | ภาษา | ชนิด | แหล่ง |', '|---|---|---|---|---|---|'] + rows)
    print(table)
    print(f'coverage: {got}/{len(need)} shots have footage ({cov:.0%})')
    for e in errs:
        print('ERROR', e)
    if cov < 0.5:
        alert = project / 'assets' / 'footage' / 'ALERT.md'
        alert.parent.mkdir(parents=True, exist_ok=True)
        alert.write_text(f'''# Footage ไม่ถึงครึ่ง: ต้องแจ้งผู้ใช้ทันที (feedback palmaris ข้อ 2)
ได้ footage {got}/{len(need)} ช็อต ({cov:.0%}) หลังค้นตามตารางด้านล่าง

{table}

ทางเลือกที่ต้องเสนอผู้ใช้ (ให้เลือก ห้ามเลือกเองเงียบๆ):
1. ทำช็อตที่ขาดเป็นกราฟิก/แผนภาพ motion (ตามแม่แบบ v3)
2. มือ/ร่างกายวาดด้วย SVG rig (`templates/brainrot-v3/compositions/components/hand-rig/`) สำหรับท่าทาง/ทำตาม
3. ผู้ใช้ถ่ายเอง (บอกช็อตที่ต้องการ: มุม ท่า ความยาว แนวตั้ง 1080x1920)
4. ค้นต่อด้วยคำ/แหล่งที่ยังไม่ได้ลอง (บอกว่าลองอะไรไปแล้ว)
''')
        print(f'ALERT footage < 50 %: tell the user NOW with the choices in {alert} (do not continue silently)')
        return 2
    return 1 if errs else 0


@contextlib.contextmanager
def one_at_a_time():
    """Exclusive lock so footage searches never run in parallel (parallel = every source answers 429)."""
    path = pathlib.Path(os.environ.get('FOOTAGE_LOCK') or pathlib.Path(tempfile.gettempdir()) / 'ai-studio-footage-search.lock')
    wait = float(os.environ.get('FOOTAGE_LOCK_WAIT', '600'))
    with open(path, 'a+') as fh:
        try:
            fcntl.flock(fh, fcntl.LOCK_EX | fcntl.LOCK_NB)
        except BlockingIOError:
            fh.seek(0)
            other = fh.read().strip() or '?'
            print(f'WAIT another footage_search is running ({other}): searches run one at a time (parallel search = 429 '
                  f'from every source); queued up to {wait:.0f} s', file=sys.stderr)
            t0 = time.time()
            while True:
                try:
                    fcntl.flock(fh, fcntl.LOCK_EX | fcntl.LOCK_NB)
                    break
                except BlockingIOError:
                    if time.time() - t0 >= wait:
                        print(f'ERROR still locked after {wait:.0f} s: wait for the other search to finish, then rerun '
                              '(never run footage_search in parallel)', file=sys.stderr)
                        raise SystemExit(3)
                    time.sleep(0.5)
            print(f'WAIT done after {time.time() - t0:.0f} s', file=sys.stderr)
        fh.seek(0); fh.truncate(); fh.write(f'pid {os.getpid()} {" ".join(sys.argv[1:4])}'); fh.flush()
        try:
            yield
        finally:
            fh.seek(0); fh.truncate(); fh.flush()
            fcntl.flock(fh, fcntl.LOCK_UN)


def main(argv=None):
    ap = argparse.ArgumentParser(description=__doc__.split('\n')[0])
    sub = ap.add_subparsers(dest='cmd', required=True)
    s = sub.add_parser('search'); s.add_argument('project', type=pathlib.Path); s.add_argument('shot')
    s.add_argument('terms', nargs='+'); s.add_argument('--kinds', default='video,photo')
    s.add_argument('--sources', default=','.join(SOURCES)); s.add_argument('--per', type=int, default=6)
    r = sub.add_parser('report'); r.add_argument('project', type=pathlib.Path); r.add_argument('--min-terms', type=int, default=10)
    a = ap.parse_args(argv)
    if a.cmd == 'search':
        with one_at_a_time():
            search(a.project, a.shot, a.terms, a.kinds.split(','), a.sources.split(','), a.per)
        return 0
    return report(a.project, a.min_terms)


if __name__ == '__main__':
    sys.exit(main())
