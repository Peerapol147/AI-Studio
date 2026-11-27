"""tools/contact_sheet.py: a frame every 0.25 s on sheets, still spans > 0.5 s found, and review.md must note every sheet."""
import json, pathlib, shutil, subprocess, sys

import pytest

ROOT = pathlib.Path(__file__).resolve().parents[1]
TOOL = ROOT / 'tools' / 'contact_sheet.py'
pytest.importorskip('PIL')


def run(*a):
    return subprocess.run([sys.executable, str(TOOL), *map(str, a)], capture_output=True, text=True, timeout=120)


@pytest.mark.skipif(not shutil.which('ffmpeg'), reason='ffmpeg not installed')
def test_sheets_still_span_and_verify(tmp_path):
    v = tmp_path / 'clip.mp4'
    # 12 s: 0-5 s moving test pattern, 5-7 s one still colour, 7-12 s moving again
    subprocess.run(['ffmpeg', '-v', 'error', '-y', '-f', 'lavfi', '-i', 'testsrc2=s=108x192:r=30:d=5',
                    '-f', 'lavfi', '-i', 'color=c=blue:s=108x192:r=30:d=2', '-f', 'lavfi', '-i', 'testsrc2=s=108x192:r=30:d=5',
                    '-filter_complex', '[0][1][2]concat=n=3:v=1', '-pix_fmt', 'yuv420p', str(v)], check=True)
    proj = tmp_path / 'projects' / '2026-11-27-knowledge-x'
    out = proj / 'renders' / 'frames-th'
    r = run('make', v, out)
    assert r.returncode == 0, r.stderr
    fj = json.loads((out / 'frames.json').read_text())
    assert len(fj['times']) == 48 and fj['times'][1] == 0.25            # every 0.25 s
    assert [s['file'] for s in fj['sheets']] == ['sheet-01.jpg', 'sheet-02.jpg']
    assert len(fj['still_spans']) == 1 and 4.75 <= fj['still_spans'][0][0] <= 5.25 and fj['still_spans'][0][1] >= 6.5
    assert 'sheet-02.jpg' in (out / 'INDEX.md').read_text()

    assert run('verify', proj).returncode == 1                          # no review.md yet
    (proj / 'review.md').write_text('# review\n## ตรวจภาพทุกเฟรม (0.25 วิ)\n- sheet-01.jpg (0-9.75s): ผ่าน\n## อื่น\n- sheet-02.jpg ok\n')
    r = run('verify', proj)
    assert r.returncode == 1 and 'sheet-02.jpg not reviewed' in r.stdout   # a mention outside the section does not count
    (proj / 'review.md').write_text('# review\n## ตรวจภาพทุกเฟรม\n- sheet-01.jpg (0-9.75s): ผ่าน\n- sheet-02.jpg:\n')
    assert 'sheet-02.jpg: no note' in run('verify', proj).stdout
    (proj / 'review.md').write_text('# review\n## ตรวจภาพทุกเฟรม\n- sheet-01.jpg (0-9.75s): ผ่าน\n'
                                    '- sheet-02.jpg (10-11.75s): 5.0-7.0s ภาพนิ่งสีฟ้า 2 วิ = ตีกลับ\n')
    r = run('verify', proj)
    assert r.returncode == 0 and '2 sheets reviewed' in r.stdout


@pytest.mark.skipif(not shutil.which('ffmpeg'), reason='ffmpeg not installed')
def test_main_picture_held_warns_even_if_small_things_move(tmp_path):
    """caffeine-ranking 2026-11-27: one gauge picture stayed ~7 s and passed because small bubbles moved in it.
    7 s of colour bars + a small moving box + a moving caption-band box -> WARN main picture held 0-7 s; the next
    2.5 s shots (moving pattern, then a still) are new pictures under 3 s -> no WARN for them."""
    pytest.importorskip('numpy')
    v = tmp_path / 'clip.mp4'
    subprocess.run(['ffmpeg', '-v', 'error', '-y',
                    '-f', 'lavfi', '-i', 'smptehdbars=s=216x384:r=30:d=7',
                    '-f', 'lavfi', '-i', 'color=c=white:s=14x14:r=30:d=7',
                    '-f', 'lavfi', '-i', 'color=c=yellow:s=120x40:r=30:d=7',
                    '-f', 'lavfi', '-i', 'testsrc2=s=216x384:r=30:d=2.5',
                    '-f', 'lavfi', '-i', 'mandelbrot=s=216x384:r=30', '-t', '9.5',
                    '-filter_complex', "[0][1]overlay=x='20+t*20':y='60+10*sin(t*6)'[a];[a][2]overlay=x='mod(t*90,100)':y=235[b];"
                                       "[4]trim=duration=2.5,setpts=PTS-STARTPTS[m];[b][3][m]concat=n=3:v=1",
                    '-pix_fmt', 'yuv420p', str(v)], check=True)
    out = tmp_path / 'p' / 'renders' / 'frames-th'
    r = run('make', v, out)
    assert r.returncode == 0, r.stderr
    fj = json.loads((out / 'frames.json').read_text())
    assert fj['still_spans'] == [] or all(a >= 9.0 for a, _ in fj['still_spans'])   # small things move: not "still"
    holds = fj['main_holds']
    assert len(holds) == 1 and holds[0][0] == 0.0 and 6.75 <= holds[0][1] <= 7.5, holds
    assert 'WARN 0.00-' in (out / 'INDEX.md').read_text()
    (tmp_path / 'p' / 'review.md').write_text('## ตรวจภาพทุกเฟรม\n- sheet-01.jpg: เกจค้าง 7 วิ ตีกลับ\n')
    r = run('verify', tmp_path / 'p')
    assert 'WARN main picture held 0.00-' in r.stdout and r.returncode == 0          # WARN only, reviewer decides
