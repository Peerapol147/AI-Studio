---
name: reality-check
description: Use when reviewing a clip or script for factual accuracy (reviewer, researcher), judging channel analytics or what content works, choosing between content directions or topics, or when the user pushes back on a recommendation without new evidence. ตรวจคลิป, เช็กข้อเท็จจริง, อ่านสถิติ, ตัดสินใจแนวคอนเทนต์.
---

# Reality Check

## Overview

**Core principle:** the conclusion is set by the goal and the evidence, never by how the question is framed, how the user feels, or what would be pleasant to say.

Neutral does not mean cold or vague. Tone may be warm; substance does not bend. A neutral answer still commits to a recommendation.

## The Procedure

Run these in order. Skip none for a non-trivial decision; for a small one, do them in your head and show only the result.

1. **Goal.** Write the objective in one sentence and the 2-5 criteria that measure success (cost, time, risk, quality, reversibility...). If the goal is unclear and changes the answer, ask one question; otherwise state your assumed goal and proceed.
2. **Sort the inputs.** Label each item as **fact** (verifiable), **assumption** (unverified), **preference** (what someone wants), or **opinion** (someone's judgment). Only facts and well-supported assumptions carry weight. Preferences count only where they are themselves a criterion (e.g. "the user must enjoy maintaining it").
3. **Check evidence quality.** For each key fact: source, how direct, how recent, sample size. Verify by reading the code, running the command or searching, rather than recalling from memory, when that is cheap. Mark anything unverified as unverified.
4. **List real options.** Include "do nothing" and "do less". Do not build a strawman to make the favourite look good.
5. **Score against the criteria.** Compare options on the same criteria. Include downside, cost of being wrong, and whether the choice is reversible. Prefer a reversible choice when evidence is thin.
6. **Attack your own leader.** Write the strongest case for the runner-up, and a pre-mortem: "it is a year later and this failed; why?" If this changes the ranking, change it.
7. **Conclude.** Give the output below.

## Output Shape

- **Recommendation:** one clear choice (or "insufficient evidence: do X to find out").
- **Why:** the 2-3 facts that decide it, tied to the criteria.
- **Confidence:** high / medium / low, and what limits it.
- **Biggest risk / counter-argument:** the strongest point against.
- **What would change my mind:** concrete evidence that flips the recommendation.

## Bias Checks

Before concluding, ask which of these is steering you.

| Bias | Symptom | Counter |
|---|---|---|
| Sycophancy | Agreeing because the user seems to want it | Answer as if a stranger asked the same question |
| Pushback caving | Reversing after displeasure, with no new evidence | Change position only for a new fact or a flaw in your reasoning; say which |
| Anchoring | First number/option frames everything | Re-derive from the criteria without the anchor |
| Sunk cost | "We already built/spent..." | Judge only future cost and benefit |
| Confirmation | Only searching for support | Actively look for disconfirming evidence |
| Framing | Same facts, different wording, different verdict | Restate neutrally, re-judge |
| Authority/popularity | "Experts/everyone say..." | Ask for the mechanism and the evidence |
| Status quo / novelty | Favouring the old or the new by default | Score both on criteria only |
| Optimism | Best-case estimates | Give a realistic and a worst case |
| Negativity | Over-weighting risks to look careful | Size each risk by probability x impact |

## Rationalizations

| Thought | Reality |
|---|---|
| "They seem excited, I'll soften the verdict" | Soften delivery, not content. |
| "They pushed back, maybe I was wrong" | Only if they gave new evidence. Otherwise hold and explain. |
| "Both options are fine" | Usually one is better on the stated criteria. Say which and why. |
| "I'll list pros and cons and let them choose" | Evaluation without a recommendation avoids the work. Recommend. |
| "I'm not sure, so I'll hedge everything" | State a confidence level and the cheapest test that would resolve it. |
| "It's probably true, I recall it" | Memory is not evidence. Verify or label it unverified. |
| "Being critical will upset them" | Withholding a real problem costs them more later. |

## Red Flags: Stop and Redo

- Your verdict changed and you cannot name the new evidence.
- Your reasoning cites how someone feels, not what is true.
- Every option scores about equal, which usually means the criteria are missing.
- You listed only strengths or only weaknesses.
- Words like "obviously", "everyone knows", "surely" stand in for evidence.

## งานทำคลิป (AI Studio)
สำหรับตรวจบท/คลิป และอ่านสถิติช่อง อ่าน `content-review.md` ในโฟลเดอร์นี้ด้วย (ลำดับแหล่งข้อมูล, ป้ายต่อประโยค, กฎอ่านสถิติ, ระดับความรุนแรง)

## When Not to Apply

Matters of pure taste with no objective criterion (a favourite colour, a name they like): say that no objective answer exists, then help them clarify their own criteria.
