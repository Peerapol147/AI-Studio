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


# ---- Task 2: match + classify ----
import yt_stats


def mkproj(tmp_path, name, title, fmt='short'):
    d = tmp_path / name; d.mkdir()
    (d / 'upload.md').write_text(f'# อัปโหลด: x\n\n**ชื่อคลิป (เลือก 1)**\n1. {title}  ← แนะนำ\n2. ชื่ออื่น\n', encoding='utf-8')
    (d / 'brief.md').write_text(f'# Brief\n- ช่อง: knowledge | รูปแบบ: {fmt} 9:16\n', encoding='utf-8')
    return d


def test_match_by_title_in_upload_md(tmp_path):
    mkproj(tmp_path, '2026-11-17-knowledge-nature', 'สัตว์ที่ขี้ออกมาเป็นลูกเต๋า 🎲 รูก้นมันไม่ได้เหลี่ยมนะ!')
    vids = [{'id': 'a', 'title': 'สัตว์ที่ขี้ออกมาเป็นลูกเต๋า รูก้นมันไม่ได้เหลี่ยมนะ #shorts'}]
    assert yt_stats.match_projects(vids, tmp_path) == {'a': '2026-11-17-knowledge-nature'}


def test_no_match_returns_none(tmp_path):
    mkproj(tmp_path, '2026-11-17-knowledge-nature', 'วอมแบต')
    assert yt_stats.match_projects([{'id': 'a', 'title': 'อะไรก็ไม่รู้'}], tmp_path) == {'a': None}


def test_channel_from_folder_name():
    assert yt_stats.classify({'duration_s': 600}, '2026-11-17-knowledge-nature', None)['channel'] == 'knowledge'
    assert yt_stats.classify({'duration_s': 600}, '2026-11-17-football-x', None)['channel'] == 'football'
    assert yt_stats.classify({'duration_s': 600}, None, None)['channel'] == 'knowledge'


def test_unmatched_football_title_goes_to_football():
    assert yt_stats.classify({'duration_s': 30, 'title': 'ฟุตบอลโลกเริ่มยังไง'}, None, None)['channel'] == 'football'
    assert yt_stats.classify({'duration_s': 30, 'title': 'Premier League ทำไมแพง'}, None, None)['channel'] == 'football'


def test_format_short_when_duration_le_60_and_no_project():
    assert yt_stats.classify({'duration_s': 60}, None, None)['format'] == 'short'
    assert yt_stats.classify({'duration_s': 61}, None, None)['format'] == 'long'


def test_format_from_brief_when_project_matched(tmp_path):
    d = mkproj(tmp_path, '2026-11-17-knowledge-x', 'ยาว', fmt='long')
    assert yt_stats.classify({'duration_s': 30}, d.name, tmp_path)['format'] == 'long'


# ---- Task 3: eligibility ----
import datetime as dt

NOW = dt.datetime(2026, 12, 1, tzinfo=dt.timezone.utc)


def vids(n, age_days=30, channel='knowledge', fmt='short'):
    p = (NOW - dt.timedelta(days=age_days)).strftime('%Y-%m-%dT%H:%M:%SZ')
    return [{'id': f'x{i}', 'published_at': p, 'channel': channel, 'format': fmt} for i in range(n)]


def test_nine_videos_not_eligible():
    g = yt_stats.eligible_groups(vids(9), NOW)['knowledge/short']
    assert g['n'] == 9 and g['eligible'] is False and 'ยังสรุปไม่ได้' in g['reason']


def test_ten_videos_eligible():
    assert yt_stats.eligible_groups(vids(10), NOW)['knowledge/short']['eligible'] is True


def test_young_videos_not_counted():
    g = yt_stats.eligible_groups(vids(10) + vids(5, age_days=3), NOW)['knowledge/short']
    assert g['n'] == 10 and g['eligible'] is True
    assert yt_stats.eligible_groups(vids(9) + vids(5, age_days=3), NOW)['knowledge/short']['eligible'] is False


def test_groups_are_separate():
    g = yt_stats.eligible_groups(vids(10) + vids(4, fmt='long'), NOW)
    assert g['knowledge/short']['eligible'] and not g['knowledge/long']['eligible']


# ---- Task 6: dashboard files (rows) ----
def snap(day, views, ids=('a', 'b')):
    return {'taken_at': f'{day}T01:00:00Z', 'channel': {}, 'videos': [
        {'id': i, 'title': i, 'published_at': '2026-11-01T00:00:00Z', 'duration_s': 30, 'views': views, 'likes': 1,
         'comments': None, 'project': None, 'channel': 'knowledge', 'format': 'short'} for i in ids]}


def test_dashboard_files_adds_snapshot_date_and_history():
    videos, history = yt_stats.dashboard_files(snap('2026-12-01', 10), [])
    assert videos[0]['snapshot_date'] == '2026-12-01' and 'taken_at' not in videos[0]
    assert history == [{'date': '2026-12-01', 'video_id': i, 'views': 10, 'likes': 1, 'comments': None} for i in ('a', 'b')]


def test_dashboard_files_appends_new_day_and_keeps_old():
    _, h1 = yt_stats.dashboard_files(snap('2026-12-01', 10), [])
    _, h2 = yt_stats.dashboard_files(snap('2026-12-02', 15), h1)
    assert [r['date'] for r in h2] == ['2026-12-01'] * 2 + ['2026-12-02'] * 2


def test_dashboard_files_rerun_same_day_replaces_not_duplicates():
    _, h1 = yt_stats.dashboard_files(snap('2026-12-01', 10), [])
    _, h2 = yt_stats.dashboard_files(snap('2026-12-01', 12), h1)
    assert len(h2) == 2 and all(r['views'] == 12 for r in h2)


def test_dashboard_files_cli_writes_files(tmp_path):
    (tmp_path / 's.json').write_text(json.dumps(snap('2026-12-01', 10)))
    r = subprocess.run([sys.executable, str(TOOL), 'dashboard-files', '--out', str(tmp_path / 'o')],
                       input=(tmp_path / 's.json').read_text(), capture_output=True, text=True)
    assert r.returncode == 0, r.stderr
    assert len(json.loads((tmp_path / 'o' / 'videos.json').read_text())) == 2
    assert len(json.loads((tmp_path / 'o' / 'history.json').read_text())) == 2


# ---- hourly tracking of one video ----
def run_track(srv, vid, hist=None, out=None):
    import os
    env = {**os.environ, 'YT_BASE': srv.url}; env.pop('YOUTUBE_API_KEY', None)
    a = [sys.executable, str(TOOL), 'track', vid, '--out', str(out)]
    if hist:
        a += ['--history', str(hist)]
    return subprocess.run(a, capture_output=True, text=True, env=env)


def test_track_appends_row(srv, tmp_path):
    out = tmp_path / 'h.json'
    r = run_track(srv, 'v004', out=out)
    assert r.returncode == 0, r.stderr
    rows = json.loads(out.read_text())
    assert len(rows) == 1 and rows[0]['video_id'] == 'v004' and rows[0]['views'] == 40 and rows[0]['ts'].endswith('Z')
    r = run_track(srv, 'v004', hist=out, out=out)
    assert len(json.loads(out.read_text())) == 2


def test_track_unknown_video_exits_2_and_keeps_history(srv, tmp_path):
    out = tmp_path / 'h.json'
    out.write_text('[]')
    r = run_track(srv, 'nope', hist=out, out=out)
    assert r.returncode == 2 and 'ไม่พบคลิป' in r.stderr and json.loads(out.read_text()) == []
