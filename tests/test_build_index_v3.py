"""templates/brainrot-v3/build_index.py: one template, two looks from look.json; refuses a missing look/beat."""
import json, os, pathlib, re, shutil, subprocess, sys

ROOT = pathlib.Path(__file__).resolve().parents[1]
FIX = ROOT / 'tests' / 'fixtures' / 'v3'
V3 = ROOT / 'templates' / 'brainrot-v3'
LOOK_A = {'palette': 'sunrise-coral', 'font': 'prompt', 'caption': 'box', 'opening': 'pov', 'transition': 'slide',
          'music_mood': 'lofi', 'voice': 'liam', 'music_file': 'music-a.mp3'}
LOOK_B = {'palette': 'ocean-teal', 'font': 'noto', 'caption': 'pop', 'opening': 'number', 'transition': 'flash',
          'music_mood': 'cinematic', 'voice': 'george', 'music_file': None}


def project(tmp_path, look, shots=None, episode=None):
    proj = tmp_path / 'projects' / '2026-11-22-knowledge-x'
    video = proj / 'video'
    video.mkdir(parents=True)
    for f in ('build_index.py', 'index.html.tpl'):
        shutil.copy(V3 / f, video / f)
    ep = json.loads((FIX / 'episode.json').read_text())
    ep.update(episode or {})
    (video / 'episode.json').write_text(json.dumps(ep, ensure_ascii=False))
    (proj / 'assets' / 'audio').mkdir(parents=True)
    shutil.copy(FIX / 'words.json', proj / 'assets' / 'audio' / 'words.json')
    (proj / 'shots.json').write_text(shots if shots is not None else (FIX / 'shots.json').read_text())
    if look is not None:
        (proj / 'look.json').write_text(json.dumps(look))
    r = subprocess.run([sys.executable, str(ROOT / 'tools' / 'shot_times.py'), str(proj), 'th'], capture_output=True, text=True)
    assert r.returncode == 0, r.stderr
    return proj, video


def build(video):
    env = {**os.environ, 'AI_STUDIO_ROOT': str(ROOT)}
    return subprocess.run([sys.executable, 'build_index.py'], cwd=video, capture_output=True, text=True, env=env)


def test_two_looks_differ(tmp_path):
    pages = []
    for name, look in (('a', LOOK_A), ('b', LOOK_B)):
        proj, video = project(tmp_path / name, look, episode={'kicker': '86%'} if look['opening'] == 'number' else None)
        r = build(video)
        assert r.returncode == 0, r.stderr
        pages.append((video / 'index.html').read_text())
    a, b = pages
    for p in pages:
        assert '%%' not in p and p.count('class="clip cap"') == 11 and p.count('<video ') == 6
    assert 'cap-box op-pov' in a and "--accent:#FFD23F" in a and "--font:'Prompt'" in a and 'music-a.mp3' in a
    assert 'cap-pop op-number' in b and "--accent:#5CF2E3" in b and "--font:'Noto Sans Thai'" in b
    assert re.search(r'class="kick num" style="font-size:\d+px">86%<', b) and 'no music_file' in b
    assert '"transition": "slide"' in a and '"transition": "flash"' in b
    # loop shot replays the hook plate and ends on the hook in-point (1.0 s) = frame 0
    loop = re.search(r'<video id="v-loop"[^>]*data-start="([\d.]+)"[^>]*data-media-start="([-\d.]+)"', a)
    assert loop and abs(float(loop.group(2)) - (1.0 - (8.0 - float(loop.group(1))))) < 1e-6
    assert 'id="g-share"' in a                                  # graphic slot for the editor


def test_missing_look_and_bad_axis_refused(tmp_path):
    proj, video = project(tmp_path / 'a', None)
    r = build(video)
    assert r.returncode != 0 and 'tools/look.py pick' in r.stderr
    (proj / 'look.json').write_text(json.dumps({**LOOK_A, 'caption': 'comic'}))
    r = build(video)
    assert r.returncode != 0 and "caption='comic'" in r.stderr


def test_shot_without_beat_and_number_without_kicker_refused(tmp_path):
    shots = json.loads((FIX / 'shots.json').read_text())
    del shots['shots'][2]['beat']
    proj, video = project(tmp_path / 'a', LOOK_A, shots=json.dumps(shots, ensure_ascii=False))
    r = build(video)
    assert r.returncode != 0 and 'shot explain: beat None' in r.stderr
    proj, video = project(tmp_path / 'b', LOOK_B, episode={'kicker': None})
    r = build(video)
    assert r.returncode != 0 and 'kicker' in r.stderr


def _lum(h):
    c = [int(h[i:i + 2], 16) / 255 for i in (1, 3, 5)]
    c = [x / 12.92 if x <= 0.03928 else ((x + 0.055) / 1.055) ** 2.4 for x in c]
    return 0.2126 * c[0] + 0.7152 * c[1] + 0.0722 * c[2]


def contrast(a, b):
    la, lb = sorted((_lum(a), _lum(b)), reverse=True)
    return (la + 0.05) / (lb + 0.05)


def test_every_palette_keeps_text_readable():
    """Text drawn on a flat colour in the template (box/card captions and titles, accent chips) >= 4.5:1 (WCAG AA).
    Caught: mint-paper / retro-cream + box caption was white on white."""
    cat = json.loads((ROOT / 'templates' / 'looks' / 'looks.json').read_text())
    bad = []
    for name, p in cat['palette'].items():
        pairs = {'box/card text on panel': (p['panel_text'], p['panel']),
                 'chip text (ink) on accent': (p['ink'], p['accent'])}
        for what, (fg, bg) in pairs.items():
            if contrast(fg, bg) < 4.5:
                bad.append(f'{name}: {what} {fg} on {bg} = {contrast(fg, bg):.2f}')
    assert not bad, bad
    tpl = (V3 / 'index.html.tpl').read_text()
    assert 'color:var(--paneltext)' in tpl and 'color:var(--text)}' not in tpl.split('.cap-box .cap span{')[1].split('\n')[0]


def test_cover_layout_class(tmp_path):
    proj, video = project(tmp_path, {**LOOK_A, 'cover': 'tilt'})
    assert build(video).returncode == 0
    page = (video / 'index.html').read_text()
    assert 'op-pov cv-tilt' in page and '--paneltext:' in page


def _effective_title_colours(p, opening, cover):
    """(fg, bg) pairs a viewer sees for the frame-0 title in index.html.tpl, per opening x cover.
    Lines stroked with ink (stroke cover/default) are readable on any plate, so only flat-colour pairs are listed."""
    pairs = []
    if opening == 'midstory':
        pairs.append(('title line ink on accent plate', p['ink'], p['accent']))
        if cover == 'card':
            pairs.append(('highlight accent on ink', p['accent'], p['ink']))
    elif cover == 'card':
        pairs.append(('title line panel_text on panel', p['panel_text'], p['panel']))
        pairs.append(('highlight ink on accent', p['ink'], p['accent']))
    return pairs


def test_every_opening_cover_palette_title_readable():
    """Caught (review v3.1): midstory + card drew white panel_text on the yellow accent plate (1.3-1.4:1)."""
    cat = json.loads((ROOT / 'templates' / 'looks' / 'looks.json').read_text())
    opts = lambda ax: [k for k in cat[ax] if not k.startswith('_')]
    bad = []
    for pal in opts('palette'):
        p = cat['palette'][pal]
        for op in opts('opening'):
            for cv in opts('cover'):
                for what, fg, bg in _effective_title_colours(p, op, cv):
                    if contrast(fg, bg) < 4.5:
                        bad.append(f'{pal}/{op}/{cv}: {what} = {contrast(fg, bg):.2f}')
    assert not bad, bad
    tpl = (V3 / 'index.html.tpl').read_text()
    # the template really applies those colours for midstory + card (rule after .cv-card, so it wins)
    assert '.op-midstory.cv-card #title .tl{color:var(--ink)}' in tpl
    assert tpl.index('.op-midstory.cv-card #title em') > tpl.index('.cv-card #title em')
    assert 'color:var(--accent);background:var(--ink)' in tpl.split('.op-midstory.cv-card #title em')[1].split('}')[0]


def test_cover_text_must_match_frame0_title(tmp_path):
    proj, video = project(tmp_path / 'a', {**LOOK_A, 'cover_text': 'ข้อความอื่น'})
    r = build(video)
    assert r.returncode != 0 and 'cover_text' in r.stderr
    proj, video = project(tmp_path / 'b', {**LOOK_A, 'cover_text': 'ตัวอย่าง หน้าตาใหม่?'})
    assert build(video).returncode == 0


def test_caption_shown_vs_transcribed_alias(tmp_path):
    """stomach-growl: scribe spelled โครกคราก as คร่ำคร่าก -> caption "shown|heard" shows the script word, times it by the transcript."""
    ep = json.loads((FIX / 'episode.json').read_text())
    caps = list(ep['caps'])
    caps[1] = 'สะกดตามบท|หน้าตาใหม่'
    proj, video = project(tmp_path / 'a', LOOK_A, episode={'caps': caps})
    r = build(video)
    assert r.returncode == 0, r.stderr
    page = (video / 'index.html').read_text()
    assert 'สะกดตามบท' in page and 'หน้าตาใหม่</span>' not in page and '|' not in re.findall(r'class="clip cap"[^>]*><span[^>]*>([^<]*)', page)[1]
    caps[1] = 'สะกดตามบท'                                   # without the alias it is not in words.json -> refused, hint shown
    proj, video = project(tmp_path / 'b', LOOK_A, episode={'caps': caps})
    r = build(video)
    assert r.returncode != 0 and 'shown|as transcribed' in r.stderr


def test_title_size_from_width_not_letter_count():
    """1.9 x 880/n overflowed (stomach-growl). Template CSS keeps Thai stacked marks clear of the line above."""
    tpl = (V3 / 'index.html.tpl').read_text()
    lh = float(re.search(r'#title \.tl\{[^}]*line-height:([\d.]+)', tpl).group(1))
    assert lh >= 1.35
    assert '#title .tl em{display:inline-block;line-height:1.12;padding-top:.38em;padding-bottom:.24em}' in tpl
    src = (V3 / 'build_index.py').read_text()
    assert '880 / max(1, n) * 1.9' not in src and 'def line_ems' in src


def test_title_min_size_every_look_and_refuse_too_long(tmp_path):
    """review v3.3: number + card squeezed the question to 31 px. Two-line Thai titles must stay >= 72 px in every
    opening x cover; a title that cannot fit is refused with advice, never shrunk silently."""
    cat = json.loads((ROOT / 'templates' / 'looks' / 'looks.json').read_text())
    opts = lambda ax: [k for k in cat[ax] if not k.startswith('_')]
    i = 0
    for op in opts('opening'):
        for cv in opts('cover'):
            i += 1
            proj, video = project(tmp_path / f'p{i}', {**LOOK_A, 'opening': op, 'cover': cv},
                                  episode={'title': ['*ท้องร้อง*', 'ทั้งที่เพิ่งกินข้าว?'], 'kicker': '70%' if op == 'number' else 'POV: x'})
            r = build(video)
            assert r.returncode == 0, (op, cv, r.stderr)
            sizes = [int(x) for x in re.findall(r'class="tl" style="font-size:(\d+)px"', (video / 'index.html').read_text())]
            assert min(sizes) >= 72, (op, cv, sizes)
    proj, video = project(tmp_path / 'long', {**LOOK_A, 'opening': 'number', 'cover': 'card'},
                          episode={'title': ['ทั้งที่เพิ่งกินข้าวเสร็จไปเมื่อกี้', 'ทำไมท้องยังร้องโครกครากดังลั่น', 'ทั้งห้องประชุมได้ยินหมด?'], 'kicker': '70%'})
    r = build(video)
    assert r.returncode != 0 and 'min 60 px' in r.stderr and 'shorten' in r.stderr


def test_caption_alias_malformed_refused(tmp_path):
    for bad in ('หน้าตาใหม่|', '|หน้าตาใหม่', 'a|b|c'):
        ep = json.loads((FIX / 'episode.json').read_text())
        caps = list(ep['caps']); caps[1] = bad
        proj, video = project(tmp_path / str(abs(hash(bad))), LOOK_A, episode={'caps': caps})
        r = build(video)
        assert r.returncode != 0 and 'exactly "shown|as transcribed"' in r.stderr, (bad, r.stderr)


def test_frame0_title_every_opening_cover_itch_regression(tmp_path):
    """itch 2026-11-27: pov + tilt + sarabun built a 3-line title at 65 px, left-aligned top (editor had to hand-fix 116 px
    centred). Every opening x cover must build the itch title >= 60 px (3 lines; 72 for 2) and pov/tilt now >= 80 px;
    no opening may left-align the title. Browser check of the size on screen + centring: tests/test_title_fit_v3.py."""
    cat = json.loads((ROOT / 'templates' / 'looks' / 'looks.json').read_text())
    opts = lambda ax: [k for k in cat[ax] if not k.startswith('_')]
    itch = ['เวลาเกาแก้คัน', 'เรากำลังทำให้', 'ตัวเอง*เจ็บ*นะ']
    got, i = {}, 0
    for op in opts('opening'):
        for cv in opts('cover'):
            i += 1
            proj, video = project(tmp_path / f'p{i}', {**LOOK_A, 'font': 'sarabun', 'opening': op, 'cover': cv},
                                  episode={'title': itch, 'kicker': '70%' if op == 'number' else 'POV: โดนยุงกัด'})
            r = build(video)
            assert r.returncode == 0, (op, cv, r.stderr)
            got[op, cv] = [int(x) for x in re.findall(r'class="tl" style="font-size:(\d+)px"', (video / 'index.html').read_text())]
            assert len(got[op, cv]) == 3 and min(got[op, cv]) >= 60, (op, cv, got[op, cv])
    assert min(got['pov', 'tilt']) >= 80, got['pov', 'tilt']          # was 65
    tpl = (V3 / 'index.html.tpl').read_text()
    assert 'align-items:flex-start' not in tpl and 'text-align:left' not in tpl
