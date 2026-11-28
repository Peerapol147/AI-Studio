#!/usr/bin/env python3
"""สถิติสาธารณะของทุกคลิปในช่อง YouTube (YouTube Data API v3) -> JSON ออก stdout. ไม่เขียน DB ไม่เก็บ key.

  python3 tools/yt_stats.py collect @vision6498
      {"channel": {id, handle, title, subscribers}, "taken_at": ISO8601 UTC,
       "videos": [{id, title, published_at, duration_s, views, likes|null, comments|null}]}
      exit 2 = ไม่พบช่อง / ไม่มีคลิป, exit 3 = API ปฏิเสธ (key ผิด, โควตาหมด ฯลฯ; เหตุผลอยู่ stderr)

Key: ถ้ามี env YOUTUBE_API_KEY จะส่งใน header x-goog-api-key (ไม่ใส่ใน URL); ถ้าไม่มี พึ่ง proxy ของ environment ที่แนบให้
Base URL override ด้วย YT_BASE (ใช้ในเทสต์). ทุก request ผ่าน tools/get.sh (ล้มเร็ว ไม่รอ)
"""
import argparse, datetime, json, os, pathlib, re, subprocess, sys, urllib.parse

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


def main(argv=None):
    ap = argparse.ArgumentParser()
    sub = ap.add_subparsers(dest='cmd', required=True)
    c = sub.add_parser('collect'); c.add_argument('handle')
    a = ap.parse_args(argv)
    try:
        snap = fetch_snapshot(a.handle, os.environ.get('YT_BASE', DEFAULT_BASE))
    except LookupError as e:
        print(str(e), file=sys.stderr); return 2
    except ApiError as e:
        print(f'YouTube API ปฏิเสธ: {e}', file=sys.stderr); return 3
    print(json.dumps(snap, ensure_ascii=False))
    return 0


if __name__ == '__main__':
    sys.exit(main())
