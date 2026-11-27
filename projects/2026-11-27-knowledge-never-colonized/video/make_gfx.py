#!/usr/bin/env python3
"""Episode graphics (never-colonized): writes gfx.html (inserted by build_index.py at <!--EPISODE_GFX-->).
Map shapes = ../assets/graphics/maps.json (Natural Earth via world-atlas, public domain; borders = present day).
Every colour is a palette variable (look.json retro-cream), so the look can change without editing this file.
Map copies share one set of <path> defs (<use href>) so each scene can hold its own copy (hook/loop, guess/def/cta)."""
import json, pathlib, re

HERE = pathlib.Path(__file__).resolve().parent
M = json.loads((HERE.parent / 'assets' / 'graphics' / 'maps.json').read_text())
out = []
defs = []
for m, pre in (('sea', 's'), ('zoom', 'z'), ('world', 'w')):
    for k, d in M[m]['countries'].items():
        defs.append(f'<path id="{pre}-{k}" d="{d}"/>')
defs.append(f'<path id="w-land" d="{M["world"]["land"]}"/>')
c = M['zoom']['malay_north_clip']
defs.append(f'<clipPath id="mclip"><rect x="{c["x"]:.1f}" y="{c["y"]:.1f}" width="{c["w"]:.1f}" height="{c["h"]:.1f}"/></clipPath>')
defs.append('<clipPath id="mrest"><path d="M-2000,-2000H3000V%.1fH-2000Z M%.1f,%.1fH3000V3000H-2000V%.1fH%.1fZ"/></clipPath>'
            % (c['y'], c['x'], c['y'] + c['h'], c['y'] + c['h'], c['x']))
defs.append('<pattern id="hatch" patternUnits="userSpaceOnUse" width="16" height="16" patternTransform="rotate(45)">'
            '<rect width="16" height="16" fill="var(--accent)" fill-opacity=".12"/><rect width="6" height="16" fill="var(--accent)" fill-opacity=".85"/></pattern>')
defs.append('<filter id="glow" x="-30%" y="-30%" width="160%" height="160%"><feGaussianBlur stdDeviation="14"/></filter>')
out.append('<svg width="0" height="0" style="position:absolute" aria-hidden="true"><defs>' + ''.join(defs) + '</defs></svg>')

GRID = ('<div class="mgrid"></div>')


def u(pre, k, cls, extra=''):
    return f'<use href="#{pre}-{k}" class="{cls}"{extra}/>'


def pill(cls, txt, x, y, extra=''):
    return f'<div class="mlbl {cls}" style="left:{x}px;top:{y}px"{extra}><span>{txt}</span></div>'


# ---------- SEA map (hook + loop): neighbours muted, coloniser labels, Thailand glowing ----------
def sea(sid):
    bgc = ['cn', 'in', 'bd', 'id', 'ph', 'tl', 'bn', 'sg']
    col = ['mm', 'my', 'la', 'kh', 'vn']
    s = [f'<svg class="msvg" viewBox="0 0 1080 1150" width="1080" height="1150">']
    s += [u('s', k, 'lb') for k in bgc] + [u('s', k, 'lc') for k in col]
    s.append(f'<use href="#s-th" class="thg" id="{sid}-glow" filter="url(#glow)"/>')
    s.append(u('s', 'th', 'th'))
    s.append('</svg>')
    labels = [pill('uk', 'อังกฤษ', 150, 300), pill('uk', 'อังกฤษ', 352, 712),
              pill('fr', 'ฝรั่งเศส', 352, 262), pill('fr', 'ฝรั่งเศส', 436, 470), pill('fr', 'ฝรั่งเศส', 458, 372)]
    lab = ''.join(l.replace('class="mlbl', f'id="{sid}-l{i}" class="mlbl') for i, l in enumerate(labels))
    return (f'<div id="gx-{sid}" class="gfill mapbg">{GRID}<div class="mapw" id="{sid}-w">' + ''.join(s) + lab +
            '</div></div>')


out.append(sea('hook'))
out.append(sea('loop'))


# ---------- WORLD map (guess / guess_def / cta) ----------
P = M['world']['pins']
NAMES = {'th': 'ไทย', 'bt': 'ภูฏาน', 'np': 'เนปาล', 'ir': 'อิหร่าน', 'jp': 'ญี่ปุ่น'}
LBL_OFF = {'th': (34, -20), 'bt': (30, -96), 'np': (-180, -24), 'ir': (20, 30), 'jp': (-40, 34)}


def world(sid, mode):
    s = ['<svg class="msvg" viewBox="0 0 1080 700" width="1080" height="700">', '<use href="#w-land" class="lb"/>']
    for k in ('np', 'ir', 'jp'):
        s.append(u('w', k, 'lw' if mode == 'cta' else 'lb', f' id="{sid}-c{k}"'))
    s.append('<use href="#w-th" class="thg" filter="url(#glow)"/>' + u('w', 'th', 'th'))
    s.append('</svg>')
    pins = []
    keys = ['th'] + (['np', 'ir', 'jp'] if mode == 'cta' else [])
    for k in keys:
        x, y = P[k]
        pins.append(f'<div class="pin{" pth" if k == "th" else ""}" id="{sid}-p{k}" style="left:{x - 36:.0f}px;top:{y - 84:.0f}px">'
                    '<svg viewBox="0 0 24 24"><path class="pb" d="M20 10c0 4.99-5.54 10.19-7.4 11.8a1 1 0 0 1-1.2 0C9.54 20.19 4 14.99 4 10a8 8 0 0 1 16 0"/>'
                    '<circle class="pc" cx="12" cy="10" r="3"/></svg></div>')
        if mode == 'cta' or k == 'th':
            dx, dy = LBL_OFF[k]
            pins.append(pill('nm', NAMES[k], round(x + dx), round(y + dy), f' id="{sid}-n{k}"'))
    body = ''.join(s) + ''.join(pins)
    if mode == 'cta':
        body += ('<div class="qpin" id="cta-q6" style="left:820px;top:470px"><span>?</span></div>')
    q = ''
    if mode in ('guess', 'def'):
        q = '<div class="qrow">' + ''.join(f'<div class="qb" id="{sid}-q{i}"><span>?</span></div>' for i in range(3)) + '</div>'
    extra = ''
    if mode == 'def':
        extra = ('<div class="dim"></div><div class="defcard" id="defcard"><div class="d1">นับเฉพาะ</div>'
                 '<div class="d2">ไม่เคยเป็นอาณานิคม</div><div class="d3">ของ<em id="def-hl">ชาติตะวันตก</em></div></div>')
    if mode == 'cta':
        extra = '<div class="ctaq" id="ctaq"><span>ควรติดอีกไหม?</span></div>'
    return (f'<div id="gx-{sid}" class="gfill mapbg">{GRID}<div class="mapw wmap" id="{sid}-w">{body}</div>{q}{extra}</div>')


out.append(world('guess', 'guess'))
out.append(world('guess_def', 'def'))
out.append(world('cta', 'cta'))


# ---------- ZOOM map (r1c + tw in the #ep layer; tw_malay slot copy) ----------
HEAD = {'aw': 'M306,420 L262,388 L262,452Z', 'as': 'M520,866 L488,910 L552,910Z', 'ae': 'M586,330 L630,298 L630,362Z'}
CRACK = 'M520,190 L486,262 L512,318 L470,388 L498,452 L462,520 L488,590 L452,660 L470,742'


def zoom(sid, slot):
    s = ['<svg class="msvg" viewBox="0 0 1080 1150" width="1080" height="1150" overflow="visible">']
    s += [u('z', k, 'lb') for k in ('cn', 'in', 'bd', 'id', 'ph', 'tl', 'bn', 'sg')]
    s += [u('z', 'mm', 'luk'), f'<g clip-path="url(#mrest)">{u("z", "my", "luk")}</g>']
    s += [u('z', 'kh', 'lfr'), u('z', 'vn', 'lfr')]
    # base countries never move (Thailand stays whole); the 1893 / 1909 areas are hatch overlays (approximate, present-day
    # borders) that appear on Thailand's edge and then fade away toward France / Britain (review 2026-11-27 red 1-2)
    s.append(u('z', 'la', 'lfr') + f'<g clip-path="url(#mclip)">{u("z", "my", "luk")}</g>')
    s.append(f'<g id="{sid}-th"><use href="#z-th" class="thg" filter="url(#glow)" id="{sid}-glow"/>{u("z", "th", "th", f" id=\"{sid}-thf\"")}</g>')
    s.append(f'<g id="{sid}-la" class="piece">{u("z", "la", "hat")}</g>')
    s.append(f'<g id="{sid}-mn" class="piece"><g clip-path="url(#mclip)">{u("z", "my", "hat")}</g></g>')
    if not slot:
        # push arrows: British from the west (Burma) and the south (Malaya), French from the east (Indochina); tips stop at the border
        for aid, d in (('aw', 'M120,420 L292,420'), ('as', 'M520,1010 L520,880'), ('ae', 'M860,330 L600,330')):
            s.append(f'<g id="{sid}-{aid}" class="arr"><path class="ash" d="{d}" pathLength="1"/>'
                     f'<path class="ahd" id="{sid}-{aid}h" d="{HEAD[aid]}"/></g>')
    s.append('</svg>')
    lab = [pill('uk', 'อังกฤษ', 96, 560, f' id="{sid}-luk1"'), pill('uk', 'อังกฤษ', 590, 1020, f' id="{sid}-luk2"'),
           pill('fr', 'ฝรั่งเศส', 668, 190, f' id="{sid}-lfr"')]
    return f'<div class="mapw zmapw" id="{sid}-w">' + ''.join(s) + ''.join(lab) + '</div>'


out.append('<div id="gx-tw_malay" class="gfill mapbg">' + GRID + zoom('tm', True) +
           '<div class="approx" id="approx"><span>พื้นที่โดยประมาณ</span></div></div>')
# arrow heads drawn in HTML space by JS? no: marker-free heads as separate paths, positioned by JS along the shaft
EP = ['<div id="ep">',
      '<div class="g" id="zmap">' + GRID + zoom('zm', False) + '<div class="approx" id="approx2"><span>พื้นที่โดยประมาณ</span></div></div>',
      '<div class="g" id="rshade"></div>',
      '<div class="g" id="rank"><div id="rk-num"><span id="rk-n">4</span></div><div id="rk-name" class="out">เนปาล</div></div>',
      '<div class="g chip" id="chipA"><span id="chipA-t"></span></div>',
      '<div class="g chip" id="chipB"><span id="chipB-t"></span></div>',
      '<div class="g" id="stamp"><svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.4" stroke-linecap="round" stroke-linejoin="round"><use href="#ic-circle-check"/></svg><span id="stamp-t"></span></div>',
      '<div class="g" id="bigtop"><span id="bigtop-t">คานอำนาจ</span></div>',
      '<div class="g" id="bigq"><span>?</span></div>',
      '<div class="g" id="tai"><div id="tai1" class="out">ไท</div><div id="tai2" class="out">=</div><div id="tai3" class="out">อิสระ</div></div>',
      '</div>']
out += EP
(HERE / 'gfx.html').write_text('\n'.join(out) + '\n')
print('gfx.html', len('\n'.join(out)) // 1024, 'KB')
