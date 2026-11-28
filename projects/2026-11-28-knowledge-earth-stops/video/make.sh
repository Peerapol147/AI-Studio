#!/usr/bin/env bash
# index.html.tpl = template base + this episode's CSS / layers / motion (ep/), then build_index.py
set -e; cd "$(dirname "$0")"
python3 - <<'PY'
b=open('index.html.base').read()
css=open('ep/ep.css').read(); html=open('ep/ep.html').read(); cap=open('ep/cap.html').read(); js=open('ep/state.js').read()+'\n'+open('ep/ep.js').read()

b=b.replace("/* ---- EPISODE CSS (editor adds the episode's own graphics styles here) ---- */","/* ---- EPISODE CSS ---- */\n"+css,1)
b=b.replace("<!-- EPISODE GRAPHICS: editor adds the episode's own layers here (charts, icons, cards); fill #g-<shot id> slots -->","<!-- EPISODE GRAPHICS -->\n"+html,1)
b=b.replace('<div id="tshade"></div>',cap+'<div id="tshade"></div>',1)
b=b.replace("function episode(t){}",js,1)
open('index.html.tpl','w').write(b)
PY
python3 build_index.py 2>&1 | grep -v "^WARN caption"
