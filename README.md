# Examen Civique Skill

A Claude skill for preparing the **French civic exam** (*examen civique*) required to apply for a multi-year residence permit (*carte de séjour pluriannuelle*, CSP). Built from a real cram session that passed the exam with 39/40 after ~5 hours of study spread over the 2 days before exam day.

## Who this is for

People who need to pass the *examen civique* for the CSP but find the existing French-only prep apps unusable because their French isn't strong enough to study from administrative French sources. This skill lets you drill the official content while interacting in any language Claude supports.

Specifically:
- You hold a 1-year *titre de séjour temporaire* and need to pass to apply for your first *carte de séjour pluriannuelle*

You do NOT need this skill if:
- You're over 65 (exempt from the civic exam)
- You're renewing an existing CSP (not required again)
- You hold a *talent passeport* or other titre dispensed from integration conditions
- You're applying for a *carte de résident* (10-year card) or *naturalisation* — those use a different, harder question pool that this skill does not cover

## What it does

Runs a structured drilling session over the ~170 official knowledge questions, grouped by the 5 official themes. For each batch:

1. Presents 10 multiple-choice questions (official stems + community-verified answers + plausible distractors)
2. Grades your answers carefully
3. Explains misses with concept-level reasoning, not just "the answer is X"
4. Glosses unfamiliar French vocabulary
5. Tracks misses across the session
6. At theme boundaries, produces a consolidated review block (date tables, geography tables, institutional structure, etc.)
7. Optionally runs a 40-question mock exam at exam pace

Supports configurable scaffolding (heavy / medium / light) and any language Claude can handle for interaction. Question stems remain in French — that's the language of the actual exam.

## How to use it

### Option 1: Paste into Claude chat (easiest)

1. Go to [`dist/skill-bundle.md`](dist/skill-bundle.md) → click "Raw"
2. Press Ctrl+A then Ctrl+C (Cmd on Mac) to copy the whole thing
3. Open a new chat at [claude.ai](https://claude.ai)
4. Paste it as your first message
5. Tell Claude: "Let's start studying for the examen civique"

That's it. Claude reads the bundle, asks you a few setup questions, then begins drilling.

### Option 2: Claude Projects (Pro/Max plan)

1. Clone or download this repo
2. Create a new Claude Project
3. Add `SKILL.md`, `references/questions.md`, and `references/scenarios.md` as Project knowledge
4. Start a chat in the Project and say "Let's start studying"

### Option 3: Claude Code or custom integration

Use this repo as a skill folder. See your tool's documentation for skill loading.

## Languages

The skill works in any language Claude supports. Question stems remain in French — that's the language of the actual exam, and the answers you'll select are French phrases. Explanations, vocabulary glosses, and interaction happen in whatever language you choose at setup. Claude translates on the fly.

## What's in the repo

```
examen-civique-skill/
├── README.md                   # this file
├── LICENSE                     # MIT
├── SKILL.md                    # the skill itself — method, protocol, layouts
├── references/
│   ├── questions.md            # 170 official questions + answers + 1-line notes
│   └── scenarios.md            # mises-en-situation guidance
└── dist/
    └── skill-bundle.md         # auto-generated single-file bundle, paste-ready
```

## Honest caveats

- **The Ministry publishes only question stems**, not answers or multiple-choice options. The answers in this repo are community-verified through a passing attempt; the multiple-choice distractors were written by Claude. Treat as study material, not a Ministry release.
- **The 12 *mises en situation* on the real exam are unpublished.** This skill simulates plausible ones based on the rules tested in the published material, but cannot reproduce the actual exam questions.
- **The exam content changes occasionally.** This repo reflects the official CSP list as of May 2026. Check the official source at [formation-civique.interieur.gouv.fr](https://formation-civique.interieur.gouv.fr/examen-civique/) before your exam.
- **Pass threshold is 32/40 (80%).** This skill optimizes for passing, not for getting every question right.

## Background

The author passed the CSP examen civique on 2026-05-19, scoring 39/40 (98%), after approximately 5 hours of study spread over the 2 days before exam day. The approach was a single Claude-driven drilling session because the standard French prep apps online are written in administrative French that's too complex for someone whose French isn't already at B1+. The exam content itself is not actually complicated — it's basic civic knowledge — but the existing study tools assume French fluency that learners don't yet have. This skill closes that gap.

If it helps you pass, great. If you find mistakes in the question bank or want to contribute, open an issue or PR.

## License

MIT.

## Not affiliated with

The French Ministry of the Interior, Anthropic, or anyone else. This is an independent, community-built study tool.
