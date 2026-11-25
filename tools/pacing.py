#!/usr/bin/env python3
"""Check the story pacing of a short (editing v3) from the real voice timing.

  python3 tools/pacing.py <project> [th|en]

Reads <project>/shots.json (director: "topic", optional "genre", a "beat" per shot),
assets/audio/shots-<lang>.json (tools/shot_times.py; refused if stale) and assets/audio/words[-en].json.

shots.json additions:
  "topic": {"th": "<last words of the topic in the hook line>"}   # must be spoken by 1.5 s
  "genre": "legend"                                              # optional: legend/mystery = story 70 / twist 30
  "long_reason": "..."                                           # required when the clip is longer than 40 s
  each shot: "beat": hook | setup | explain | reveal | twist | share | cta | loop

FAIL (exit 1):
  - shots-<lang>.json missing or stale, a shot without "beat", first shot not "hook", last shot not "loop"
  - "topic" missing / not found in the voice, or the topic finishes after 1.5 s
  - no "reveal" (legend: no "twist"), no "twist" after the reveal, no "share" shot before the "cta", no "cta"
  - clip longer than 59 s, or longer than 40 s without "long_reason" (default length 20-40 s)
WARN (exit 0, reviewer decides):
  - voice starts after 0.3 s; reveal starts outside 50-60 % of the clip; clip shorter than 20 s
  - legend: the first twist starts before 70 % of the clip (story 70 / twist 30)
  - the "share" shot comes before the twist
  - an "explain" shot shorter than 2 s or longer than 3 s (explain holds the picture 2-3 s)
  - hook+twist shots are not cut faster (shorter average) than the other shots
  - cta longer than 4 s; last shot plays a different source than the first (check the loop by eye; skipped for
    brainrot-v3 projects, whose loop shot always replays the hook plate)
Printed for the reviewer: % position of reveal/twist/share/cta and average shot length per beat.
Numbers come from docs/editing-research-2026-11-22.md and docs/story-craft.md (70/30) on branch claude/content-strategy,
channels/knowledge/style.md, and the planning room's length rule (2026-11-23: 20-40 s default, the two hits were 20 and
35 s, 54-59 s clips did not do better; the user's ceiling is 59 s).
"""
import hashlib, json, pathlib, re, sys

STRIP = re.compile(r"[\s.,!?…'\"“”‘’\-–—:;()*]+")
TOPIC_BY, VOICE_BY, CTA_MAX = 1.5, 0.3, 4.0
REVEAL_AT = (0.50, 0.60)
HOLD = (2.0, 3.0)
LEN_DEFAULT, LEN_MAX = (20.0, 40.0), 59.0
LEGEND_TWIST = 0.70


def norm(s):
    return STRIP.sub('', s).lower()


def text_for(v, lang):
    return v.get(lang) if isinstance(v, dict) else v


def phrase_end(words, phrase):
    """End time of the first spoken occurrence of phrase (spaces/punctuation ignored), or None."""
    ch = []
    for w in words:
        if w.get('type', 'word') != 'word':
            continue
        for c in norm(w['text']):
            ch.append((c, w['end']))
    flat = ''.join(c for c, _ in ch)
    p = norm(phrase or '')
    i = flat.find(p) if p else -1
    return None if i < 0 else ch[i + len(p) - 1][1]


def main(proj, lang='th'):
    proj = pathlib.Path(proj)
    aud = proj / 'assets' / 'audio'
    fails, warns = [], []
    sf = aud / f'shots-{lang}.json'
    if not sf.exists():
        print(f'FAIL {sf} missing: run python3 tools/shot_times.py {proj} {lang}')
        return 1
    tl = json.loads(sf.read_text())
    for name, want in (tl.get('inputs') or {}).items():
        p = proj / name
        if (hashlib.sha256(p.read_bytes()).hexdigest() if p.exists() else None) != want:
            print(f'FAIL {sf} is stale ({name} changed): rerun tools/shot_times.py')
            return 1
    plan = json.loads((proj / 'shots.json').read_text())
    words = [w for w in json.loads((aud / ('words.json' if lang == 'th' else f'words-{lang}.json')).read_text())['words']
             if w.get('type', 'word') == 'word']
    shots, dur = tl['shots'], tl['duration']
    legend = plan.get('genre') == 'legend'

    # hook: voice + topic
    if words and words[0]['start'] > VOICE_BY:
        warns.append(f'voice starts at {words[0]["start"]:.2f} s (style.md: < {VOICE_BY} s)')
    topic = text_for(plan.get('topic'), lang)
    if not topic:
        fails.append('shots.json has no "topic" (the words that finish saying what the clip is about)')
    else:
        te = phrase_end(words, topic)
        if te is None:
            fails.append(f'topic {topic!r} not found in the voice')
        elif te > TOPIC_BY:
            fails.append(f'topic {topic!r} ends at {te:.2f} s: say it within {TOPIC_BY} s (shorten the hook line)')
        else:
            print(f'topic {topic!r} said by {te:.2f} s')

    # beats
    missing = [s['id'] for s in shots if not s.get('beat')]
    if missing:
        fails.append(f'shots without "beat" in shots.json: {", ".join(missing)} (then rerun shot_times)')
    if shots and shots[0].get('beat') != 'hook':
        fails.append(f'first shot {shots[0]["id"]} must be beat "hook"')
    if shots and shots[-1].get('beat') != 'loop':
        fails.append(f'last shot {shots[-1]["id"]} must be beat "loop" (its picture leads back into frame 0)')
    first = {}
    for s in shots:
        first.setdefault(s.get('beat'), s)
    pos = {b: round(s['start'] / dur, 3) for b, s in first.items() if b}
    rev, cta, share = first.get('reveal'), first.get('cta'), first.get('share')
    twist_after = [s for s in shots if s.get('beat') == 'twist' and (rev is None or s['start'] > rev['start'])]
    if dur > LEN_MAX:
        fails.append(f'clip is {dur:.1f} s: over the {LEN_MAX:.0f} s ceiling')
    elif dur > LEN_DEFAULT[1] and not plan.get('long_reason'):
        fails.append(f'clip is {dur:.1f} s: default is {LEN_DEFAULT[0]:.0f}-{LEN_DEFAULT[1]:.0f} s; cut a point, '
                     f'or write why it must be longer in shots.json "long_reason"')
    elif dur < LEN_DEFAULT[0]:
        warns.append(f'clip is {dur:.1f} s (default {LEN_DEFAULT[0]:.0f}-{LEN_DEFAULT[1]:.0f} s)')
    if legend:
        if not first.get('twist'):
            fails.append('legend: no "twist" shot (story 70 / twist 30)')
        else:
            print(f'legend: twist starts at {pos["twist"]:.0%} (rule: story 70 / twist 30)')
            if pos['twist'] < LEGEND_TWIST:
                warns.append(f'legend: twist starts at {pos["twist"]:.0%}, before {LEGEND_TWIST:.0%} '
                             f'(story 70 / twist 30: an early twist flopped, docs/story-craft.md)')
    else:
        if rev is None:
            fails.append('no "reveal" shot (answer the question at ~50-60 % of the clip)')
        elif not REVEAL_AT[0] <= pos['reveal'] <= REVEAL_AT[1]:
            warns.append(f'reveal starts at {pos["reveal"]:.0%} of the clip (rule: ~50-60 %)')
        if rev is not None and not twist_after:
            fails.append('no "twist" shot after the reveal (one twist / bonus fact follows the answer)')
    if share is None:
        fails.append('no "share" shot (one fact worth sending to a friend, before the end)')
    if cta is None:
        fails.append('no "cta" shot (comment question)')
    elif share is not None and share['start'] > cta['start']:
        fails.append('"share" must come before the "cta"')
    tw = first.get('twist')
    if share is not None and tw is not None and share['start'] < tw['start']:
        warns.append('"share" comes before the twist (order: reveal -> twist -> share -> cta)')
    if cta is not None:
        cta_len = sum(s['dur'] for s in shots if s.get('beat') == 'cta')
        if cta_len > CTA_MAX:
            warns.append(f'cta lasts {cta_len:.1f} s (style.md: <= {CTA_MAX:.0f} s)')

    # cut speed: INFO only (style.md ข้อ 4, ผู้ใช้ 2026-11-25: จังหวะตัดแล้วแต่คลิป)
    infos = []
    for s in shots:
        if s.get('beat') == 'explain' and not HOLD[0] <= s['dur'] <= HOLD[1]:
            infos.append(f'explain shot {s["id"]} is {s["dur"]:.2f} s (hold the picture {HOLD[0]:.0f}-{HOLD[1]:.0f} s)')
    by = {}
    for s in shots:
        by.setdefault(s.get('beat'), []).append(s['dur'])
    fast = [d for b in ('hook', 'twist') for d in by.get(b, [])]
    rest = [d for b, ds in by.items() if b not in ('hook', 'twist', 'loop', 'cta', None) for d in ds]
    if fast and rest and sum(fast) / len(fast) >= sum(rest) / len(rest):
        infos.append(f'hook+twist shots avg {sum(fast) / len(fast):.2f} s are not faster than the rest '
                     f'({sum(rest) / len(rest):.2f} s): cut fast only in the hook and the twist')
    v3 = (proj / 'video' / 'episode.json').exists()
    if shots and not v3 and shots[0].get('src') != shots[-1].get('src'):
        warns.append('last shot plays another source than the first: play end -> start and check the loop by eye')

    print(f'duration {dur:.2f} s, {len(shots)} shots')
    print('  beat      first at   shots  avg s')
    for b in ('hook', 'setup', 'explain', 'reveal', 'twist', 'share', 'cta', 'loop'):
        if b in by:
            print(f'  {b:<9}{pos.get(b, 0):>8.0%}{len(by[b]):>8}{sum(by[b]) / len(by[b]):>7.2f}')
    for i in infos:
        print('INFO', i, '(pace is per clip: style.md 4)')
    for w in warns:
        print('WARN', w)
    for f in fails:
        print('FAIL', f)
    print('pacing: FAIL' if fails else 'pacing: OK')
    return 1 if fails else 0


if __name__ == '__main__':
    if len(sys.argv) not in (2, 3):
        sys.exit('usage: python3 tools/pacing.py <project> [th|en]')
    sys.exit(main(*sys.argv[1:]))
