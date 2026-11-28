#!/usr/bin/env python3
"""สถิติสาธารณะของทุกคลิปในช่อง YouTube (YouTube Data API v3) -> JSON ออก stdout. ไม่เขียน DB ไม่เก็บ key.

  python3 tools/yt_stats.py collect @vision6498 [--projects projects]
      --projects เพิ่มฟิลด์ project (ชื่อโฟลเดอร์|null), channel (knowledge|football; จับคู่ไม่ได้ = knowledge เว้นแต่ชื่อมีคำฟุตบอล), format (short|long)
      {"channel": {id, handle, title, subscribers}, "taken_at": ISO8601 UTC,
       "videos": [{id, title, published_at, duration_s, views, likes|null, comments|null}]}
  python3 tools/yt_stats.py eligibility < snapshot.json   (snapshot ต้องมี channel/format: ใช้ --projects ตอน collect)
      กลุ่ม "<channel>/<format>" -> {n, eligible, reason}; ต้องมี >=10 คลิปอายุ >=7 วันถึงสรุปได้
  python3 tools/yt_stats.py dashboard-files --out DIR [--history old-history.json] < snapshot.json
      เขียน DIR/videos.json และ DIR/history.json (ประวัติเดิม + วันนี้ แทนที่วันเดียวกัน) สำหรับอัปโหลดเข้าแดชบอร์ด
      exit 2 = ไม่พบช่อง / ไม่มีคลิป, exit 3 = API ปฏิเสธ (key ผิด, โควตาหมด ฯลฯ; เหตุผลอยู่ stderr)

Key: ถ้ามี env YOUTUBE_API_KEY จะส่งใน header x-goog-api-key (ไม่ใส่ใน URL); ถ้าไม่มี พึ่ง proxy ของ environment ที่แนบให้
Base URL override ด้วย YT_BASE (ใช้ในเทสต์). ทุก request ผ่าน tools/get.sh (ล้มเร็ว ไม่รอ)
"""
import argparse, datetime, json, os, pathlib, re, subprocess, sys, unicodedata, urllib.parse

ROOT = pathlib.Path(__file__).resolve().parents[1]
GET = ROOT / 'tools' / 'get.sh'
DEFAULT_BASE = 'https://www.googleapis.com/youtube/v3'


class ApiError(Exception):
    pass


def _call(base, path, params):
    url = f"{base}/{path}?{urllib.parse.urlencode(params, safe=',@')}"
    extra = []
    if os.environ.get('YOUTUBE_API_KEY'):
        extra = ['-H', f"x-goog-api-key: {os.environ['YOUTUBE_API_KEY']}"]
    r = subprocess.run(['bash', str(GET), url, '-', *extra], capture_output=True, text=True)
    if r.returncode != 0:
        raise ApiError((r.stderr or 'API error').strip())
    return json.loads(r.stdout)


def parse_duration(iso):
    m = re.fullmatch(r'P(?:(\d+)D)?T?(?:(\d+)H)?(?:(\d+)M)?(?:(\d+)S)?', iso or '')
    d, h, mi, s = (int(x or 0) for x in m.groups()) if m else (0, 0, 0, 0)
    return ((d * 24 + h) * 60 + mi) * 60 + s


def _int_or_none(v):
    return int(v) if v is not None else None


def fetch_snapshot(handle, base, key=None):
    ch = _call(base, 'channels', {'part': 'id,snippet,statistics,contentDetails', 'forHandle': handle})
    if not ch.get('items'):
        raise LookupError(f'ไม่พบช่อง {handle}')
    c = ch['items'][0]
    uploads = c['contentDetails']['relatedPlaylists']['uploads']
    ids, token = [], None
    while True:
        p = {'part': 'contentDetails', 'playlistId': uploads, 'maxResults': 50}
        if token:
            p['pageToken'] = token
        page = _call(base, 'playlistItems', p)
        ids += [i['contentDetails']['videoId'] for i in page.get('items', [])]
        token = page.get('nextPageToken')
        if not token:
            break
    if not ids:
        raise LookupError(f'ช่อง {handle} ไม่มีคลิป')
    videos = []
    for i in range(0, len(ids), 50):
        r = _call(base, 'videos', {'part': 'snippet,statistics,contentDetails', 'id': ','.join(ids[i:i + 50])})
        for v in r.get('items', []):
            st = v.get('statistics', {})
            videos.append({'id': v['id'], 'title': v['snippet']['title'], 'published_at': v['snippet']['publishedAt'],
                           'duration_s': parse_duration(v['contentDetails'].get('duration')),
                           'views': int(st.get('viewCount', 0)), 'likes': _int_or_none(st.get('likeCount')),
                           'comments': _int_or_none(st.get('commentCount'))})
    return {'channel': {'id': c['id'], 'handle': handle, 'title': c['snippet']['title'],
                        'subscribers': int(c.get('statistics', {}).get('subscriberCount', 0))},
            'taken_at': datetime.datetime.now(datetime.timezone.utc).strftime('%Y-%m-%dT%H:%M:%SZ'),
            'videos': videos}


def _norm(t):
    t = re.sub(r'#\S+', '', unicodedata.normalize('NFC', t or ''))
    return ''.join(ch for ch in t.lower() if unicodedata.category(ch)[0] in 'LMN')


def _project_titles(d):
    f = d / 'upload.md'
    if not f.exists():
        return set()
    out = set()
    for line in f.read_text(encoding='utf-8').splitlines():
        m = re.match(r'\s*\d+\.\s+(.*?)(?:\s+←.*)?$', line)
        if m:
            out.add(_norm(m.group(1)))
    out.discard('')
    return out


def match_projects(videos, projects_dir):
    """video id -> ชื่อโฟลเดอร์ project (จับคู่ชื่อคลิปกับรายการชื่อใน upload.md) หรือ None"""
    projects_dir = pathlib.Path(projects_dir)
    titles = {d.name: _project_titles(d) for d in sorted(projects_dir.iterdir()) if d.is_dir()}
    res = {}
    for v in videos:
        n = _norm(v['title'])
        res[v['id']] = next((name for name, ts in titles.items() if n and n in ts), None)
    return res


def classify(video, project, projects_dir):
    """channel จากชื่อโฟลเดอร์; format จาก brief.md ของ project ถ้าจับคู่ได้ ไม่งั้นดูความยาว (<=60 วิ = short)"""
    m = re.match(r'\d{4}-\d{2}-\d{2}-(knowledge|football)-', project or '')
    fmt = None
    if project and projects_dir:
        b = pathlib.Path(projects_dir) / project / 'brief.md'
        if b.exists():
            mm = re.search(r'รูปแบบ:\s*(short|long)', b.read_text(encoding='utf-8'))
            fmt = mm.group(1) if mm else None
    # ทุกคลิปในช่องเป็นของเรา (ผู้ใช้ยืนยัน 2026-11-28): จับคู่โฟลเดอร์ไม่ได้ = ความรู้ เว้นแต่ชื่อพูดถึงฟุตบอล
    football = re.search(r'ฟุตบอล|football|premier league|พรีเมียร์ลีก|ลาลีกา|บุนเดสลีกา|แข้ง', video.get('title', ''), re.I)
    return {'channel': m.group(1) if m else ('football' if football else 'knowledge'),
            'format': fmt or ('short' if video['duration_s'] <= 60 else 'long')}


def eligible_groups(videos, now, min_videos=10, min_age_days=7):
    """กลุ่ม '<channel>/<format>' -> {n, eligible, reason}; นับเฉพาะคลิปอายุ >= min_age_days, ต้องมี >= min_videos ถึงสรุปได้"""
    counts, total = {}, {}
    for v in videos:
        k = f"{v['channel']}/{v['format']}"
        total[k] = total.get(k, 0) + 1
        age = (now - datetime.datetime.fromisoformat(v['published_at'].replace('Z', '+00:00'))).days
        if age >= min_age_days:
            counts[k] = counts.get(k, 0) + 1
    out = {}
    for k in total:
        n = counts.get(k, 0)
        ok = n >= min_videos
        out[k] = {'n': n, 'eligible': ok,
                  'reason': 'ตัวอย่างพอสรุปได้' if ok else
                  f'ยังสรุปไม่ได้: มี {n} คลิปที่อายุ ≥{min_age_days} วัน ต้องมีอย่างน้อย {min_videos}'}
    return out


VIDEO_COLS = ('id', 'title', 'published_at', 'duration_s', 'views', 'likes', 'comments', 'project', 'channel', 'format')


def dashboard_files(snap, history):
    """snapshot (collect --projects) + ประวัติเดิม -> (videos rows, history rows) สำหรับไฟล์ของแดชบอร์ด
    ประวัติของวันเดียวกันถูกแทนที่ (รันซ้ำวันเดียวกันไม่ซ้ำแถว) วันเก่าเก็บไว้"""
    day = snap['taken_at'][:10]
    videos = [{**{k: v.get(k) for k in VIDEO_COLS}, 'snapshot_date': day} for v in snap['videos']]
    kept = [r for r in history if r['date'] != day]
    today = [{'date': day, 'video_id': v['id'], 'views': v['views'], 'likes': v['likes'], 'comments': v['comments']}
             for v in snap['videos']]
    return videos, kept + today


def main(argv=None):
    ap = argparse.ArgumentParser()
    sub = ap.add_subparsers(dest='cmd', required=True)
    c = sub.add_parser('collect'); c.add_argument('handle'); c.add_argument('--projects')
    sub.add_parser('eligibility')
    d = sub.add_parser('dashboard-files'); d.add_argument('--out', required=True); d.add_argument('--history')
    a = ap.parse_args(argv)
    if a.cmd == 'dashboard-files':
        snap = json.load(sys.stdin)
        hist = json.loads(pathlib.Path(a.history).read_text(encoding='utf-8')) if a.history else []
        videos, history = dashboard_files(snap, hist)
        out = pathlib.Path(a.out); out.mkdir(parents=True, exist_ok=True)
        (out / 'videos.json').write_text(json.dumps(videos, ensure_ascii=False), encoding='utf-8')
        (out / 'history.json').write_text(json.dumps(history, ensure_ascii=False), encoding='utf-8')
        print(f'videos.json {len(videos)} แถว, history.json {len(history)} แถว -> {out}')
        return 0
    if a.cmd == 'eligibility':
        snap = json.load(sys.stdin)
        now = datetime.datetime.now(datetime.timezone.utc)
        print(json.dumps(eligible_groups(snap['videos'], now), ensure_ascii=False))
        return 0
    try:
        snap = fetch_snapshot(a.handle, os.environ.get('YT_BASE', DEFAULT_BASE))
    except LookupError as e:
        print(str(e), file=sys.stderr); return 2
    except ApiError as e:
        print(f'YouTube API ปฏิเสธ: {e}', file=sys.stderr); return 3
    if a.projects:
        m = match_projects(snap['videos'], a.projects)
        for v in snap['videos']:
            v['project'] = m[v['id']]
            v.update(classify(v, v['project'], a.projects))
    print(json.dumps(snap, ensure_ascii=False))
    return 0


if __name__ == '__main__':
    sys.exit(main())
