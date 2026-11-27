import json, sys
sys.path.insert(0, '/home/user/AI-Studio/tests')
from test_look import repo, ep, run, BASE
def test_natural(tmp_path):
    r = repo(tmp_path)
    ep(r, '2026-11-20-knowledge-a', {**BASE, 'palette': 'mint-paper', 'opening': 'question', 'cover_palette': 'ocean-teal'})
    hits=0
    for i in range(40):
        new = r / 'projects' / f'2026-11-22-knowledge-n{i}'
        run('pick', new, '--write', '--no-git')
        look = json.loads((new / 'look.json').read_text())
        look.update(music_file='m.mp3', cover_text=f'ข้อความทดสอบ{i}')
        (new / 'look.json').write_text(json.dumps(look))
        res = run('check', new, '--no-git')
        if 'previous episode 2026-11-20-knowledge-a cover' in res.stdout: hits+=1
        (new / 'look.json').unlink(); new.rmdir()
    print('HITS', hits, '/40')
