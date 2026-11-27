"""tools/footage_search.py: many terms x 5 sources x video/photo into SEARCH.json, 429 retried twice then the source
is skipped, report demands >= 10 terms (Thai + English, video + photo, >= 2 sources) and raises ALERT.md under 50 %."""
import http.server, json, pathlib, re, subprocess, sys, threading

import pytest

ROOT = pathlib.Path(__file__).resolve().parents[1]
TOOL = ROOT / 'tools' / 'footage_search.py'


class H(http.server.BaseHTTPRequestHandler):
    def log_message(self, *a):
        pass

    def do_GET(self):
        p = self.path.split('?')[0]
        self.server.log.append((self.path, self.headers.get('User-Agent'), self.headers.get('Authorization')))
        if p.startswith('/nasa429'):
            self.server.n429 += 1
            return self._send(429, {'e': 'slow down'})
        if p == '/openaccess/api/v1.0/search':
            def row(i, meta, media):
                return {'id': f'r{i}', 'title': f'Tiger {i}', 'content': {'descriptiveNonRepeating': {
                    'record_link': f'http://n2t.net/ark:/65665/rec{i}', 'data_source': 'NMNH - Mammals',
                    'metadata_usage': {'access': meta}, 'online_media': {'media': [{'type': 'Images', 'idsId': f'ark:/65665/m{i}',
                        'usage': {'access': media}, 'content': f'https://ids.si.edu/ids/deliveryService/id/ark:/65665/m{i}',
                        'thumbnail': f'https://ids.si.edu/t{i}', 'resources': [{'label': 'High-resolution JPEG', 'url': f'https://ids.si.edu/ids/download?id=M{i}.jpg'}]}]}}}}
            return self._send(200, {'response': {'rows': [row(1, 'CC0', 'CC0'), row(2, 'CC0', 'Usage conditions apply'),
                                                          row(3, 'Usage conditions apply', 'CC0'), row(4, 'CC0', 'CC0')]}})
        if p.startswith('/html429'):                                 # multi-line error page body
            return self._raw(429, b'<html>\n<body>\nToo Many Requests\n</body>\n</html>\n')
        body = {'/api/videos/': {'hits': [{'id': 1, 'user': 'u', 'pageURL': 'https://px/1', 'duration': 9,
                                           'videos': {'medium': {'url': 'https://cdn/v1.mp4', 'width': 1920, 'height': 1080}}}]},
                '/api/': {'hits': [{'id': 2, 'user': 'u', 'pageURL': 'https://px/2', 'largeImageURL': 'https://cdn/p2.jpg'}]},
                '/videos/search': {'videos': [{'id': 3, 'url': 'https://pexels/3', 'user': {'name': 'p'},
                                               'video_files': [{'link': 'https://cdn/v3.mp4', 'height': 1920}]}]},
                '/v1/search': {'photos': [{'id': 4, 'url': 'https://pexels/4', 'photographer': 'p', 'src': {'large2x': 'https://cdn/p4.jpg'}}]},
                '/v1/images/': {'results': [{'id': 'abcdef123', 'url': 'https://cdn/o.jpg', 'creator': 'c', 'license': 'by',
                                             'license_version': '4.0', 'foreign_landing_url': 'https://ov/1', 'source': 'flickr'}]},
                '/w/api.php': {'query': {'pages': {'7': {'pageid': 7, 'index': 1, 'imageinfo': [
                    {'url': 'https://up/w.jpg', 'descriptionurl': 'https://c/w', 'extmetadata': {'LicenseShortName': {'value': 'CC BY-SA 4.0'}}}]},
                    '8': {'pageid': 8, 'index': 2, 'imageinfo': [{'url': 'https://up/x.jpg', 'extmetadata': {'LicenseShortName': {'value': 'All rights reserved'}}}]},
                    '9': {'pageid': 9, 'index': 3, 'imageinfo': [{'url': 'https://up/n.jpg', 'extmetadata': {'LicenseShortName': {'value': 'CC BY-NC-SA 2.0'}}}]}}}},
                }.get(p)
        return self._send(200 if body else 404, body or {'e': 'nf'})

    def _raw(self, code, b):
        self.send_response(code); self.send_header('Content-Length', str(len(b))); self.end_headers(); self.wfile.write(b)

    def _send(self, code, obj):
        b = json.dumps(obj).encode()
        self.send_response(code); self.send_header('Content-Type', 'application/json')
        self.send_header('Content-Length', str(len(b))); self.end_headers(); self.wfile.write(b)


@pytest.fixture
def srv():
    s = http.server.ThreadingHTTPServer(('127.0.0.1', 0), H)
    s.log, s.n429 = [], 0
    s.url = f'http://127.0.0.1:{s.server_port}'
    threading.Thread(target=s.serve_forever, daemon=True).start()
    yield s
    s.shutdown()


def run(*a, env=None):
    import os
    return subprocess.run([sys.executable, str(TOOL), *map(str, a)], capture_output=True, text=True,
                          env={**os.environ, 'FOOTAGE_BACKOFF': '0,0', **(env or {})}, timeout=120)


def project(tmp_path, ids=('wrist', 'graft', 'fix', 'title')):
    p = tmp_path / 'projects' / '2026-11-27-knowledge-x'
    p.mkdir(parents=True)
    shots = [{'id': i, 'cue': {'th': 'x'}, 'beat': 'setup'} for i in ids]
    shots[-1]['footage'] = False                                    # a planned graphic shot does not count
    (p / 'shots.json').write_text(json.dumps({'shots': shots}))
    return p


def test_search_all_sources_429_backoff_and_report(srv, tmp_path):
    p = project(tmp_path)
    env = {'PIXABAY_BASE': srv.url, 'PIXABAY_API_KEY': 'K1', 'PEXELS_BASE': srv.url, 'PEXELS_API_KEY': 'K2',
           'OPENVERSE_BASE': srv.url, 'NASA_BASE': srv.url + '/nasa429', 'WIKIMEDIA_BASE': srv.url, 'SI_BASE': srv.url}
    r = run('search', p, 'wrist', 'ข้อมือ', 'wrist tendon', env=env)
    assert r.returncode == 0, r.stderr
    assert srv.n429 == 3 and 'BLOCKED nasa' in r.stderr              # 1 try + 2 backoff retries, then skipped
    db = json.loads((p / 'assets' / 'footage' / 'SEARCH.json').read_text())['wrist']
    ids = {c['id'] for c in db['candidates']}
    assert {'pixabay-1', 'pixabay-2', 'pexels-3', 'pexels-4', 'openverse-abcdef12', 'wikimedia-7'} <= ids
    assert 'wikimedia-8' not in ids and 'wikimedia-9' not in ids     # all-rights-reserved and NC (no monetising) dropped
    nasa = [t for t in db['tried'] if t['source'] == 'nasa']
    assert nasa[0]['status'] == 'blocked' and all(t['status'] == 'skipped' for t in nasa[1:])
    assert any('lang=th' in u for u, _, _ in srv.log)                 # Thai term sent to Pixabay in Thai
    assert any(ua and 'AI-Studio' in ua for _, ua, _ in srv.log)      # Wikimedia gets a User-Agent
    assert ('K2' in [a for _, _, a in srv.log])                       # Pexels key in the Authorization header
    assert 'K1' not in (p / 'assets' / 'footage' / 'SEARCH.json').read_text()

    # report: 1 of 3 footage shots has a file -> < 50 % -> exit 2 + ALERT.md; wrist searched with only 2 terms
    (p / 'footage.json').write_text(json.dumps({'graft': {'src': 'assets/footage/pixabay-1.mp4', 'action_at': 1}}))
    r = run('report', p)
    assert r.returncode == 2 and 'coverage: 1/3' in r.stdout
    assert 'shot wrist has no file and was not searched enough: 2 terms answered by a source (< 10' in r.stdout
    assert 'shot fix' in r.stdout and 'title' not in r.stdout.split('coverage')[1]
    alert = (p / 'assets' / 'footage' / 'ALERT.md').read_text()
    assert 'แจ้งผู้ใช้ทันที' in alert and 'ผู้ใช้ถ่ายเอง' in alert and 'hand-rig' in alert


def test_report_ok_when_half_found_and_rest_searched_enough(srv, tmp_path):
    p = project(tmp_path, ids=('a', 'b', 'g'))
    env = {'PIXABAY_BASE': srv.url, 'PIXABAY_API_KEY': 'K1', 'OPENVERSE_BASE': srv.url}
    terms = ['ข้อมือ', 'เส้นเอ็น', 'มือ', 'ฝ่ามือ', 'ศัลยแพทย์', 'wrist', 'tendon', 'palm', 'hand close up', 'surgeon']
    assert run('search', p, 'b', *terms, '--sources', 'pixabay,openverse', env=env).returncode == 0
    (p / 'footage.json').write_text(json.dumps({'a': {'src': 'assets/footage/x.mp4'}}))
    r = run('report', p)
    assert r.returncode == 0, r.stdout
    assert not (p / 'assets' / 'footage' / 'ALERT.md').exists()


def test_missing_key_source_is_skipped_not_fatal(srv, tmp_path):
    p = project(tmp_path)
    r = run('search', p, 'wrist', 'wrist', '--sources', 'pexels', env={'PEXELS_API_KEY': ''})
    assert r.returncode == 0
    t = json.loads((p / 'assets' / 'footage' / 'SEARCH.json').read_text())['wrist']['tried']
    assert {x['status'] for x in t} == {'skipped'} and 'no PEXELS_API_KEY' in t[0]['note']


def test_blocked_source_skipped_for_the_next_shots_too(srv, tmp_path):
    """review 2026-11-26: the CLI takes one shot per call, so the block must outlive the call (no 12 s wait per shot)."""
    p = project(tmp_path)
    env = {'NASA_BASE': srv.url + '/nasa429'}
    assert run('search', p, 'wrist', 'wrist', '--sources', 'nasa', '--kinds', 'photo', env=env).returncode == 0
    assert srv.n429 == 3
    r = run('search', p, 'graft', 'tendon graft', '--sources', 'nasa', '--kinds', 'photo', env=env)
    assert r.returncode == 0 and srv.n429 == 3                        # not asked again
    t = json.loads((p / 'assets' / 'footage' / 'SEARCH.json').read_text())['graft']['tried']
    assert t[0]['status'] == 'skipped' and 'blocked' in t[0]['note']


def test_backoff_is_clamped_in_code():
    sys.path.insert(0, str(ROOT / 'tools'))
    import footage_search as fs
    assert fs._backoff('3,9') == (3.0, 9.0)
    assert fs._backoff('60,600') == (9.0, 3.0) and sum(fs._backoff('60,600')) <= fs.MAX_WAIT
    assert fs._backoff('5,5,5,5') == (5.0, 5.0)
    assert fs._backoff('0,0') == (0.0, 0.0)


def test_blocked_source_does_not_count_as_answered(srv, tmp_path):
    p = project(tmp_path, ids=('a', 'b', 'g'))
    env = {'PIXABAY_BASE': srv.url, 'PIXABAY_API_KEY': 'K1', 'NASA_BASE': srv.url + '/nasa429'}
    terms = [f'คำ{i}' for i in range(5)] + [f'word{i}' for i in range(5)]
    assert run('search', p, 'b', *terms, '--sources', 'pixabay,nasa', env=env).returncode == 0
    (p / 'footage.json').write_text(json.dumps({'a': {'src': 'assets/footage/x.mp4'}}))
    r = run('report', p)
    assert r.returncode == 1 and 'only one source answered' in r.stdout


def test_blocked_note_shows_the_429_not_the_error_body(srv, tmp_path):
    """review: SEARCH.json note was the last line of the server's HTML ("</html>"), not "BLOCKED 429"."""
    p = project(tmp_path)
    env = {'NASA_BASE': srv.url + '/html429'}
    r = run('search', p, 'wrist', 'wrist', 'hand', '--sources', 'nasa', '--kinds', 'photo', env=env)
    assert r.returncode == 0, r.stderr
    db = json.loads((p / 'assets' / 'footage' / 'SEARCH.json').read_text())
    t = db['wrist']['tried']
    assert t[0]['status'] == 'blocked' and t[0]['note'].startswith('BLOCKED 429') and '(after 3 tries)' in t[0]['note']
    assert t[1]['status'] == 'skipped' and 'BLOCKED 429' in t[1]['note']
    assert db['_blocked_why']['nasa'].startswith('BLOCKED 429')


def test_searches_run_one_at_a_time(srv, tmp_path):
    """itch 2026-11-27: parallel searches = 429 from every source. A second search waits for the lock (queue), and
    gives up with exit 3 when the first one does not finish within FOOTAGE_LOCK_WAIT."""
    import fcntl, time
    p = project(tmp_path)
    lock = tmp_path / 'fs.lock'
    env = {'FOOTAGE_LOCK': str(lock), 'OPENVERSE_BASE': srv.url}
    with open(lock, 'a+') as fh:
        fcntl.flock(fh, fcntl.LOCK_EX)                              # another search holds the lock
        r = run('search', p, 'wrist', 'wrist', '--sources', 'openverse', env={**env, 'FOOTAGE_LOCK_WAIT': '1'})
        assert r.returncode == 3 and 'WAIT another footage_search is running' in r.stderr and 'parallel' in r.stderr
        assert not (p / 'assets' / 'footage' / 'SEARCH.json').exists()
        threading.Timer(1.0, lambda: fcntl.flock(fh, fcntl.LOCK_UN)).start()   # first search finishes after 1 s
        t0 = time.time()
        r = run('search', p, 'wrist', 'wrist', '--sources', 'openverse', env={**env, 'FOOTAGE_LOCK_WAIT': '20'})
    assert r.returncode == 0, r.stderr
    assert 'WAIT done' in r.stderr and time.time() - t0 >= 0.9
    assert json.loads((p / 'assets' / 'footage' / 'SEARCH.json').read_text())['wrist']['candidates']
    r = run('search', p, 'wrist', 'hand', '--sources', 'openverse', env=env)  # free lock: no WAIT
    assert r.returncode == 0 and 'WAIT' not in r.stderr


def test_smithsonian_cc0_stills_only(srv, tmp_path):
    """Smithsonian Open Access (key = proxy network secret on api.si.edu, header X-Api-Key): CC0 record AND CC0 media
    only, stills only, English terms only; credit = museum + record link."""
    p = project(tmp_path)
    r = run('search', p, 'wrist', 'tiger', 'เสือ', '--sources', 'smithsonian', env={'SI_BASE': srv.url, 'SI_API_KEY': ''})
    assert r.returncode == 0, r.stderr
    db = json.loads((p / 'assets' / 'footage' / 'SEARCH.json').read_text())['wrist']
    ids = [c['id'] for c in db['candidates']]
    assert ids == ['smithsonian-m1', 'smithsonian-m4']                 # m2 media restricted, m3 record restricted
    c = db['candidates'][0]
    assert c['url'] == 'https://ids.si.edu/ids/download?id=M1.jpg' and c['license'].startswith('CC0')
    assert c['page'] == 'http://n2t.net/ark:/65665/rec1' and c['creator'] == 'NMNH - Mammals' and c['kind'] == 'photo'
    st = {(t['q'], t['kind']): (t['status'], t['note']) for t in db['tried']}
    assert st[('tiger', 'video')][0] == 'skipped' and st[('เสือ', 'photo')] == ('skipped', 'smithsonian: English terms only')
    hdr = [h for path, _, _ in srv.log if path.startswith('/openaccess') for h in [path]]
    assert hdr and 'online_media_type%3AImages' in hdr[0] and 'media_usage%3A%22CC0%22' in hdr[0]   # review Y2
    src = (ROOT / 'tools' / 'footage_search.py').read_text()
    assert 'proxy-injected' in src and not re.search(r'X-Api-Key: [0-9A-Za-z]{20,}', src)   # never a real key in code


def test_report_does_not_count_blocked_or_skipped_searches(srv, tmp_path):
    """caffeine-ranking 2026-11-27: 10 terms all sent to sources that answered 429 / were skipped passed as
    "searched enough". Only terms a source answered count."""
    p = project(tmp_path, ids=('a', 'b', 'g'))
    terms = [f'คำ{i}' for i in range(5)] + [f'word{i}' for i in range(5)]
    env = {'NASA_BASE': srv.url + '/nasa429', 'PEXELS_API_KEY': ''}
    assert run('search', p, 'b', *terms, '--sources', 'nasa,pexels', env=env).returncode == 0
    (p / 'footage.json').write_text(json.dumps({'a': {'src': 'assets/footage/x.mp4'}}))
    r = run('report', p)
    assert r.returncode == 1 and 'shot b has no file and was not searched enough: 0 terms answered' in r.stdout
