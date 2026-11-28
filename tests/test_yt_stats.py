"""tools/yt_stats.py: public YouTube stats snapshot (mock server only, no real API)."""
import http.server, json, pathlib, subprocess, sys, threading
from urllib.parse import urlparse, parse_qs

import pytest

ROOT = pathlib.Path(__file__).resolve().parents[1]
TOOL = ROOT / 'tools' / 'yt_stats.py'
sys.path.insert(0, str(ROOT / 'tools'))


def make_videos(n):
    out = []
    for i in range(n):
        s = {'viewCount': str(i * 10)}
        if i != 3:
            s.update({'likeCount': str(i), 'commentCount': '2'})
        out.append({'id': f'v{i:03d}', 'snippet': {'title': f'คลิป {i} 🐨', 'publishedAt': '2026-11-01T00:00:00Z'},
                    'statistics': s, 'contentDetails': {'duration': 'PT1M5S' if i == 0 else 'PT10M'}})
    return out


class H(http.server.BaseHTTPRequestHandler):
    def log_message(self, *a):
        pass

    def do_GET(self):
        u = urlparse(self.path); q = parse_qs(u.query); srv = self.server
        srv.log.append((self.path, self.headers.get('x-goog-api-key')))
        if srv.mode == 'quota':
            return self._send(403, {'error': {'errors': [{'reason': 'quotaExceeded'}]}})
        if u.path == '/channels':
            if q.get('forHandle', [''])[0] != '@ok':
                return self._send(200, {'pageInfo': {'totalResults': 0}})
            return self._send(200, {'items': [{'id': 'UC1', 'snippet': {'title': 'T'},
                'statistics': {'subscriberCount': '5'}, 'contentDetails': {'relatedPlaylists': {'uploads': 'UU1'}}}]})
        if u.path == '/playlistItems':
            start = int(q.get('pageToken', ['0'])[0])
            chunk = srv.videos[start:start + 50]
            body = {'items': [{'contentDetails': {'videoId': v['id']}} for v in chunk]}
            if start + 50 < len(srv.videos):
                body['nextPageToken'] = str(start + 50)
            return self._send(200, body)
        if u.path == '/videos':
            ids = q['id'][0].split(',')
            assert len(ids) <= 50
            return self._send(200, {'items': [v for v in srv.videos if v['id'] in ids]})
        return self._send(404, {})

    def _send(self, code, obj):
        b = json.dumps(obj).encode()
        self.send_response(code); self.send_header('Content-Type', 'application/json')
        self.send_header('Content-Length', str(len(b))); self.end_headers(); self.wfile.write(b)


@pytest.fixture
def srv():
    s = http.server.ThreadingHTTPServer(('127.0.0.1', 0), H)
    s.log, s.mode, s.videos = [], 'ok', make_videos(120)
    s.url = f'http://127.0.0.1:{s.server_port}'
    threading.Thread(target=s.serve_forever, daemon=True).start()
    yield s
    s.shutdown()


def run(srv, handle='@ok', key=None):
    import os
    env = {**os.environ, 'YT_BASE': srv.url}
    env.pop('YOUTUBE_API_KEY', None)
    if key:
        env['YOUTUBE_API_KEY'] = key
    return subprocess.run([sys.executable, str(TOOL), 'collect', handle], capture_output=True, text=True, env=env)


def test_fetch_snapshot_paginates(srv):
    r = run(srv)
    assert r.returncode == 0, r.stderr
    d = json.loads(r.stdout)
    assert len(d['videos']) == 120
    assert d['channel'] == {'id': 'UC1', 'handle': '@ok', 'title': 'T', 'subscribers': 5}


def test_missing_likes_is_none(srv):
    v = {x['id']: x for x in json.loads(run(srv).stdout)['videos']}
    assert v['v003']['likes'] is None and v['v003']['comments'] is None
    assert v['v004']['likes'] == 4


def test_duration_parsed(srv):
    v = {x['id']: x for x in json.loads(run(srv).stdout)['videos']}
    assert v['v000']['duration_s'] == 65 and v['v001']['duration_s'] == 600


def test_thai_title_kept(srv):
    v = {x['id']: x for x in json.loads(run(srv).stdout)['videos']}
    assert v['v001']['title'] == 'คลิป 1 🐨'


def test_unknown_handle_exits_2(srv):
    r = run(srv, '@nope')
    assert r.returncode == 2 and r.stdout.strip() == '' and 'ไม่พบช่อง' in r.stderr


def test_channel_without_videos_exits_2(srv):
    srv.videos = []
    r = run(srv)
    assert r.returncode == 2 and 'ไม่มีคลิป' in r.stderr


def test_quota_error_exits_3_and_prints_reason(srv):
    srv.mode = 'quota'
    r = run(srv)
    assert r.returncode == 3 and 'quotaExceeded' in r.stderr and r.stdout.strip() == ''


def test_key_sent_in_header_not_url(srv):
    assert run(srv, key='SECRETKEY').returncode == 0
    assert all(k == 'SECRETKEY' for _, k in srv.log)
    assert all('SECRETKEY' not in p and 'key=' not in p for p, _ in srv.log)


def test_no_key_env_sends_no_header(srv):
    run(srv)
    assert all(k is None for _, k in srv.log)
