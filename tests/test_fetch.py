"""tools/get.sh and every script that goes online (tts, words, voices, footage, music) against a local mock.
No real API is called: the base URLs are pointed at tests/conftest.py's server."""
import json, os, pathlib, subprocess

import pytest

ROOT = pathlib.Path(__file__).resolve().parents[1]
T = ROOT / 'tools'


def sh(*args, env=None, **kw):
    e = {**os.environ, 'NO_PROXY': '127.0.0.1,localhost', 'no_proxy': '127.0.0.1,localhost', **(env or {})}
    return subprocess.run(['bash', *map(str, args)], capture_output=True, text=True, env=e, timeout=60, **kw)


def test_200_to_stdout(mock_http):
    r = sh(T / 'get.sh', f'{mock_http.url}/v1/voices')
    assert r.returncode == 0, r.stderr
    assert json.loads(r.stdout)['voices'][0]['voice_id'] == 'v1'
    assert 'BLOCKED' not in r.stderr


@pytest.mark.parametrize('code,rc', [(429, 75), (403, 75), (500, 75), (503, 75), (404, 1), (400, 1)])
def test_error_keeps_existing_file(mock_http, tmp_path, code, rc):
    f = tmp_path / 'good.json'
    f.write_bytes(b'GOOD\x00bytes')
    r = sh(T / 'get.sh', f'{mock_http.url}/fail{code}/x', f)
    assert r.returncode == rc
    assert f.read_bytes() == b'GOOD\x00bytes'
    assert [p.name for p in tmp_path.iterdir()] == ['good.json'], 'no temp file left behind'


def test_200_replaces_file(mock_http, tmp_path):
    f = tmp_path / 'v.json'
    f.write_text('OLD')
    assert sh(T / 'get.sh', f'{mock_http.url}/v1/voices', f).returncode == 0
    assert json.loads(f.read_text())['voices']


def test_timeout_and_refused_are_75(mock_http, tmp_path):
    assert sh(T / 'get.sh', f'{mock_http.url}/slow', env={'GET_MAX_TIME': '1'}).returncode == 75
    assert sh(T / 'get.sh', 'http://127.0.0.1:9/nothing').returncode == 75


def test_key_never_printed(mock_http):
    r = sh(T / 'get.sh', f'{mock_http.url}/fail429/api/?key=SECRET123&q=cat')
    assert r.returncode == 75 and 'SECRET123' not in r.stderr and 'key=***' in r.stderr


def test_tts_words_voices(mock_http, tmp_path):
    env = {'ELEVENLABS_BASE': mock_http.url}
    (tmp_path / 't.txt').write_text('สวัสดี "ครับ"', encoding='utf-8')
    r = sh(T / 'tts.sh', 'v1', tmp_path / 't.txt', tmp_path / 'vo.mp3', env=env)
    assert r.returncode == 0, r.stderr
    assert (tmp_path / 'vo.mp3').read_bytes() == b'ID3fake-mp3'
    m, path, ct = mock_http.log[-1]
    assert m == 'POST' and path.startswith('/v1/text-to-speech/v1') and ct == 'application/json'
    r = sh(T / 'words.sh', tmp_path / 'vo.mp3', tmp_path / 'words.json', 'tha', env=env)
    assert r.returncode == 0, r.stderr
    assert mock_http.log[-1][2].startswith('multipart/form-data')
    r = sh(T / 'voices.sh', env=env)
    assert r.returncode == 0 and r.stdout.startswith('v1\tA\tth'), r.stderr


def test_tts_blocked_keeps_old_voice(mock_http, tmp_path):
    (tmp_path / 't.txt').write_text('x')
    (tmp_path / 'vo.mp3').write_bytes(b'OLD-VOICE')
    r = sh(T / 'tts.sh', 'v1', tmp_path / 't.txt', tmp_path / 'vo.mp3', env={'ELEVENLABS_BASE': f'{mock_http.url}/fail429'})
    assert r.returncode == 75
    assert (tmp_path / 'vo.mp3').read_bytes() == b'OLD-VOICE'
    (tmp_path / 'words.json').write_text('{"words": []}')
    r = sh(T / 'words.sh', tmp_path / 'vo.mp3', tmp_path / 'words.json', 'tha', env={'ELEVENLABS_BASE': f'{mock_http.url}/fail503'})
    assert r.returncode == 75 and (tmp_path / 'words.json').read_text() == '{"words": []}'


def credits(proj):
    return (proj / 'assets' / 'CREDITS.md').read_text(encoding='utf-8')


def test_footage_and_music_rerun_no_duplicate_credits(mock_http, tmp_path):
    proj = tmp_path / 'p'
    proj.mkdir()
    (proj / 'assets').mkdir()
    (proj / 'assets' / 'CREDITS.md').write_text('# Credits\nเขียนเอง: ฟอนต์ Kanit (OFL)\n', encoding='utf-8')
    env = {'PIXABAY_BASE': mock_http.url, 'PIXABAY_API_KEY': 'dummy', 'OPENVERSE_BASE': mock_http.url}
    for _ in range(2):
        r = sh(T / 'footage.sh', 'video', 'cat', proj, 2, env=env)
        assert r.returncode == 0, r.stderr
        r = sh(T / 'music.sh', 'music', 'calm', proj, 2, env=env)
        assert r.returncode == 0, r.stderr
    c = credits(proj)
    for name in ('pixabay-1.mp4', 'pixabay-2.mp4', 'music-jamendo-abcdefgh.mp3'):
        assert c.count(f'- {name}:') == 1, c
    assert 'เขียนเอง: ฟอนต์ Kanit (OFL)' in c
    assert (proj / 'assets' / 'footage' / 'pixabay-1.mp4').read_bytes().startswith(b'MEDIA')


def test_footage_api_blocked_is_75(mock_http, tmp_path):
    r = sh(T / 'footage.sh', 'video', 'cat', tmp_path, 2,
           env={'PIXABAY_BASE': f'{mock_http.url}/fail429', 'PIXABAY_API_KEY': 'SECRET9'})
    assert r.returncode == 75 and 'SECRET9' not in r.stderr


def test_download_blocked_stops_without_partial_file(mock_http, tmp_path):
    mock_http.prefix = 'fail429-'
    r = sh(T / 'music.sh', 'music', 'calm', tmp_path, 2, env={'OPENVERSE_BASE': mock_http.url})
    assert r.returncode == 75
    assert list((tmp_path / 'assets' / 'audio').iterdir()) == []
    assert not (tmp_path / 'assets' / 'CREDITS.md').exists()


def test_200_file_is_world_readable(mock_http, tmp_path):
    f = tmp_path / 'v.json'
    assert sh(T / 'get.sh', f'{mock_http.url}/v1/voices', f).returncode == 0
    assert f.stat().st_mode & 0o777 == 0o644


def test_quota_body_is_blocked_75(mock_http, tmp_path):
    f = tmp_path / 'vo.mp3'
    f.write_bytes(b'OLD')
    r = sh(T / 'get.sh', f'{mock_http.url}/quota/v1/text-to-speech/x', f, '-X', 'POST')
    assert r.returncode == 75 and 'BLOCKED 401-quota' in r.stderr and f.read_bytes() == b'OLD'


def py_credits(*x):
    return subprocess.run(['python3', str(T / 'credits.py'), *map(str, x)], capture_output=True, text=True)


def test_credits_kept_when_media_not_on_disk(tmp_path):
    """footage/ and *.mp3 are gitignored: a fresh clone has the credit JSON but no media. Nothing may vanish."""
    a = tmp_path / 'assets'
    (a / 'credits').mkdir(parents=True)
    (a / 'credits' / 'footage.json').write_text(json.dumps({'footage/pixabay-1.jpg': '- pixabay-1.jpg: u1 via Pixabay'}))
    (a / 'credits' / 'music.json').write_text(json.dumps({'audio/music-x.mp3': '- music-x.mp3: "Song" by c (CC BY 4.0)'}))
    assert not (a / 'footage').exists()
    r = py_credits('build', tmp_path)
    assert r.returncode == 0 and r.stdout.startswith('2 credits'), r.stdout
    c = (a / 'CREDITS.md').read_text(encoding='utf-8')
    assert '- pixabay-1.jpg: u1' in c and '- music-x.mp3:' in c


def test_footage_rerun_on_fresh_clone_keeps_credits(mock_http, tmp_path):
    proj = tmp_path / 'p'
    env = {'PIXABAY_BASE': mock_http.url, 'PIXABAY_API_KEY': 'dummy', 'OPENVERSE_BASE': mock_http.url}
    assert sh(T / 'footage.sh', 'video', 'cat', proj, 2, env=env).returncode == 0
    assert sh(T / 'music.sh', 'music', 'calm', proj, 2, env=env).returncode == 0
    for d in ('footage', 'audio'):                              # what a fresh clone looks like
        for f in (proj / 'assets' / d).iterdir():
            f.unlink()
    mock_http.prefix = 'fail429-'                               # and this time the source is blocked
    assert sh(T / 'music.sh', 'music', 'calm', proj, 2, env=env).returncode == 75
    assert py_credits('build', proj).returncode == 0
    c = credits(proj)
    for name in ('pixabay-1.mp4', 'pixabay-2.mp4', 'music-jamendo-abcdefgh.mp3'):
        assert c.count(f'- {name}:') == 1, c


def test_credits_remove_and_legacy_migration(tmp_path):
    a = tmp_path / 'assets'
    a.mkdir()
    (a / 'CREDITS.md').write_text('# Credits\n- pixabay-7.mp4: old line via Pixabay\nเพลง: ใส่เอง\n', encoding='utf-8')
    assert py_credits('add', tmp_path, 'footage', 'footage/pixabay-7.mp4', '- pixabay-7.mp4: u7 via Pixabay https://p/7').returncode == 0
    assert py_credits('add', tmp_path, 'music', 'audio/music-a.mp3', '- music-a.mp3: not chosen').returncode == 0
    c = (a / 'CREDITS.md').read_text(encoding='utf-8')
    assert c.count('pixabay-7.mp4') == 1 and 'u7 via Pixabay' in c and 'music-a.mp3' in c and 'เพลง: ใส่เอง' in c
    assert py_credits('remove', tmp_path, 'audio/music-a.mp3').returncode == 0
    c = (a / 'CREDITS.md').read_text(encoding='utf-8')
    assert 'music-a.mp3' not in c and 'u7 via Pixabay' in c
    assert py_credits('remove', tmp_path, 'audio/nope.mp3').returncode != 0
