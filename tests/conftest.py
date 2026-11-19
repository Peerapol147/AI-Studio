"""Local mock HTTP server: no real API is ever called by the tests.

Paths: /fail<code>/...  -> that status + small body (any method)
       /slow/...        -> sleeps 3 s
       /v1/text-to-speech/<voice> (POST json)   -> fake mp3 bytes
       /v1/speech-to-text (POST multipart)      -> fake words json
       /v1/voices, /api/, /api/videos/, /v1/audio/ -> fake listings pointing at /files/<name>
       /files/<name>     -> bytes; /files/fail429-<name> -> 429
Every request is recorded in server.log as (method, path, content-type).
"""
import http.server, json, threading, time

import pytest


class Handler(http.server.BaseHTTPRequestHandler):
    def log_message(self, *a):
        pass

    def _send(self, code, body, ctype='application/json'):
        b = body if isinstance(body, bytes) else body.encode()
        self.send_response(code)
        self.send_header('Content-Type', ctype)
        self.send_header('Content-Length', str(len(b)))
        self.end_headers()
        self.wfile.write(b)

    def _go(self):
        n = int(self.headers.get('Content-Length') or 0)
        self.rfile.read(n) if n else b''
        p = self.path.split('?')[0]
        self.server.log.append((self.command, self.path, self.headers.get('Content-Type') or ''))
        base = f'http://127.0.0.1:{self.server.server_port}'
        if p.startswith('/fail'):
            code = int(p[5:8])
            return self._send(code, json.dumps({'error': code}))
        if p.startswith('/slow'):
            time.sleep(3)
            return self._send(200, 'late')
        if p.startswith('/v1/text-to-speech/') and self.command == 'POST':
            return self._send(200, b'ID3fake-mp3', 'audio/mpeg')
        if p == '/v1/speech-to-text' and self.command == 'POST':
            return self._send(200, json.dumps({'audio_duration_secs': 1.0,
                                               'words': [{'type': 'word', 'text': 'hi', 'start': 0, 'end': 0.5}]}))
        if p == '/v1/voices':
            return self._send(200, json.dumps({'voices': [{'voice_id': 'v1', 'name': 'A', 'labels': {'language': 'th'}}]}))
        if p in ('/api/', '/api/videos/'):
            hits = [{'id': i, 'user': f'u{i}', 'pageURL': f'https://pixabay.example/{i}',
                     'videos': {'medium': {'url': f'{base}/files/{self.server.prefix}v{i}.mp4'}},
                     'largeImageURL': f'{base}/files/{self.server.prefix}p{i}.jpg'} for i in (1, 2)]
            return self._send(200, json.dumps({'hits': hits}))
        if p == '/v1/audio/':
            res = [{'id': f'abcdefgh{i}', 'source': 'jamendo', 'title': f'Song {i}', 'creator': 'c', 'license': 'by',
                    'license_version': '4.0', 'duration': 60000, 'filetype': 'mp3',
                    'url': f'{base}/files/{self.server.prefix}m{i}.mp3', 'foreign_landing_url': f'https://ov.example/{i}'}
                   for i in (1, 2)]
            return self._send(200, json.dumps({'results': res}))
        if p.startswith('/files/'):
            if p.startswith('/files/fail429-'):
                return self._send(429, 'slow down')
            return self._send(200, b'MEDIA' + p.encode(), 'application/octet-stream')
        return self._send(404, 'not found')

    do_GET = do_POST = _go


@pytest.fixture
def mock_http():
    srv = http.server.ThreadingHTTPServer(('127.0.0.1', 0), Handler)
    srv.log, srv.prefix = [], ''
    srv.url = f'http://127.0.0.1:{srv.server_port}'
    t = threading.Thread(target=srv.serve_forever, daemon=True)
    t.start()
    yield srv
    srv.shutdown()
