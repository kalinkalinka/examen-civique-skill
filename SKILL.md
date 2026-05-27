---
name: examen-civique-skill
description: Drilling skill for the French civic exam (examen civique) for the multi-year residence permit (carte de séjour pluriannuelle, CSP). Runs structured 10-question batches over 200 banked knowledge questions: official CSP question stems plus natural variations on the same testable concepts, with concept-level explanations of misses, vocabulary glosses, theme-level consolidation, and an optional mock exam that can generate plausible unpublished scenario questions from guidance patterns. Multilingual interaction (language chosen by the user at setup); question stems remain in French.
version: 0.1.0
author: kalinkalinka
license: MIT
source: https://github.com/kalinkalinka/examen-civique-skill
---

# Examen Civique Skill

A Claude skill that turns the official French civic exam question pool into a structured, multilingual drilling session.

## When to use this skill

Load this skill when the user signals they want to prepare for, study for, or pass the *examen civique* / French civic exam / *carte de séjour pluriannuelle* civic component. Trigger phrases include:

- "examen civique"
- "civic exam" (in any language, referring to France)
- "CSP" + "exam" / "test" / "study" / "prepare"
- "carte de séjour pluriannuelle" + exam-related context
- Any direct ask like "help me study for the French civic exam"

Do NOT load this skill for the *carte de résident* (CR) or *naturalisation* exam pools — those have additional questions not in this skill's bank.

## What this skill does

Runs a study session over 200 banked CSP knowledge questions across 5 themes. The bank is based on the official published question stems, plus natural variations on the same testable concepts. It also includes guidance for generating plausible unpublished *mises en situation* scenarios in mock exam mode.

1. **Full walkthrough** — go through every theme in order, 10 questions per batch, grading + explanation as you go
2. **Drill weak spots** — re-quiz only questions the user missed earlier in the current session
3. **Mock exam** — 40 random questions, exam-paced (no per-question feedback until the end)
4. **Review** — present the consolidated drill blocks (date table, geography table, top traps, infraction hierarchy, EU timeline, institutional structure) without quizzing

The skill reads question content from `references/questions.md` and scenario guidance from `references/scenarios.md`. Both must be available when the skill runs.

## Session opening protocol

On first user message after the skill loads, do these steps in order:

### 1. Detect language

Look at the user's first message. If it's clearly in one language (English, Mandarin, French, or any other), use that language for everything except question stems and French civic vocabulary.

If the message is too short or ambiguous to tell (e.g., just "hi" or "start"), ask in three languages on one line:

> **Language? / 语言? / Langue?** (English / 中文 / Français / autre — préciser)

Wait for the user's choice. Lock that language in for the session.

### 2. Ask the remaining 3 setup questions

In the user's chosen language, ask these together as a single message (one batch, not three sequential turns):

> Quick setup:
>
> 1. **Device** — phone 📱 or desktop 💻?
> 2. **Scaffolding** — heavy (lots of vocab + explanations), medium (key vocab only), light (mostly French, just corrections)?
> 3. **Goal** — full walkthrough by theme, drill weak spots, mock exam, or just review?

Defaults if user skips a question:
- Device → **phone** (safer for layout)
- Scaffolding → **medium**
- Goal → **full walkthrough**

Once the user answers, lock the four parameters (`language`, `device`, `scaffolding`, `goal`) for the session. Then enter the appropriate mode.

## Layouts

Two render modes. Choose based on `device`.

### Phone layout (plain markdown, no code blocks)

Use for `device = phone`. Plain markdown reflows on narrow screens; code blocks do not.

**Scorecard at top of every drilling response:**

📊 **Theme {N}** · ▓▓▓▓▓▓░░░░ · {answered}/{total} · {percent}%

---

**Question block:**

**🎯 Q{batch_n} / {batch_total}** · Theme Q{theme_n}/{theme_total}

{question stem in French}

A. {option}
B. {option}
C. {option}
D. {option}

📚 *{vocab_word}* = {gloss} · *{vocab_word}* = {gloss}

*(Vocab line only when scaffolding ≥ medium and there are non-obvious words.)*

**Correct-answer response:**

✅ **Correct — {letter}**

{1–2 sentence reinforcement explaining why}

📊 {answered}/{total} · {percent}%

**Wrong-answer response:**

❌ **You said {letter} — correct is {letter}**

{2–3 sentence explanation, concept-level, addressing the trap}

📝 Added to drill list: "{short lock phrase}"

📊 {answered}/{total} · {percent}%

### Desktop layout (code-block shell aesthetic)

Use for `device = desktop`. Code blocks render cleanly on wide screens.

```
┌─────────────────────────────────────────────────┐
│ 📊 Theme {N} — {theme_name}                     │
│ ▓▓▓▓▓▓░░░░  {answered}/{total}  ·  {percent}%  │
└─────────────────────────────────────────────────┘

🎯 Question {batch_n} / {batch_total} · Theme Q{theme_n}/{theme_total}

   {question stem in French}

      A. {option}
      B. {option}
      C. {option}
      D. {option}

📚 Vocab: {word} = {gloss} · {word} = {gloss}
```

For correct/wrong responses on desktop, also wrap in code blocks with consistent visual structure.

## Drilling protocol (full walkthrough mode)

### Batch structure

- Present **10 questions at a time** within a single theme
- Number displayed questions batch-locally (`1/10`, `2/10`, etc.) and include the theme question ID beside it (`Theme Q11/36`) so users can answer either way without confusion
- Stop and ask the user for answers as a block (e.g., "1B 2A 3C 4D 5B 6B 7C 8A 9D 10B")
- The user may answer one batch at a time; do not auto-advance until they answer
- Grade all 10 in one response, going through each with ✅ or ❌
- If <10 questions remain in a theme, finish with whatever's left in a smaller batch

### Grading carefully

- Match each letter to the option text before declaring correct or incorrect
- If you shuffle answer options, store the presented A-D mapping and grade against the mapping shown to the user, not the original bank letters
- If the user's letter doesn't appear (e.g., they typed E or skipped one), flag it and ask
- Accept either batch-local answer numbers (`1B 2A ...`) or theme question numbers (`11B 12A ...`) as long as they unambiguously map to the current displayed batch
- Do NOT assume B for everything — verify the letter against the actual option
- If you make a grading error and the user pushes back, re-check immediately and correct, no defensiveness

### Explanations for misses

For each missed question:
- State the correct answer and the user's pick
- Explain in 2–3 sentences why the correct answer is correct AND why the user's pick is wrong (often a common trap)
- Surface the *underlying concept*, not just the fact (e.g., not "the maire is elected by the conseil municipal" but "the maire is elected indirectly via the council, which is why préfet keeps being a wrong answer — préfet represents the State, not the local executive")
- If multiple misses in the batch share a pattern (dates, geography, préfet confusion), call out the pattern at the end of the batch

### Vocab glosses

By scaffolding level:

- **Heavy**: gloss every administrative or non-obvious French word the first time it appears. Include English translations and 1-line context.
- **Medium**: gloss only words likely to be unfamiliar to a B1-or-lower learner (e.g., *préfet*, *prud'hommes*, *ostensibles*, *suffrage*, *laïcité*, *séparation des pouvoirs*). Skip cognates and basic vocabulary.
- **Light**: gloss only on user request, or when the word is genuinely obscure (e.g., *Schœlcher*, *prud'hommes*).

Vocab lines appear inline with the question (📚 line), not in the explanation.

### Miss tracking

Maintain a session-local miss list. For each missed question:
- Question number + theme
- Short lock phrase (e.g., "maire = élu par conseil municipal, pas par préfet")
- Pattern tag if applicable (e.g., "préfet confusion," "date," "geography")

Do NOT persist across sessions. At session end, offer the user the miss list as a copy-pasteable block.

### Theme transitions

At the end of each theme, do these in one message:

1. Print the **theme-level scorecard** (questions in theme, correct, percent)
2. List the **misses for the theme** with their lock phrases
3. Identify any **patterns** (dates weak, geography weak, préfet confusion, etc.)
4. Show the **consolidated drill block** for the theme (date table, geography table, etc. — see references/questions.md for theme-specific drill blocks)
5. Offer the user **3 choices**:
   - Continue to next theme
   - Drill weak spots from this theme before continuing
   - Stop here

Wait for the user's choice. Do not auto-advance.

## Mode-specific protocols

### Drill weak spots mode

Triggered by user choice. Re-presents only the questions the user previously missed in the current session. Same grading + explanation protocol. If the user gets a previously-missed question right twice, remove it from the drill list.

### Mock exam mode

Simulates the real CSP exam:

- **40 questions**: 28 randomly drawn from the question bank + 12 *mises en situation* (scenarios) generated from the patterns in `references/scenarios.md`
- **45-minute time limit** (announced at start, not enforced — user paces themselves)
- **No per-question feedback** during the mock — present all 40 questions first, then user submits all answers as one block
- After submission: full grading, theme breakdown, pass/fail indicator (pass = 32/40), miss list with explanations
- For the 12 scenarios, explain reasoning even on correct answers — the scenarios are the hardest part of the real exam

Alternative: **easy mock** = 40 questions from the pool with no scenarios. Offer this if the user requests an easier mock.

### Review mode

No quizzing. Just present the consolidated drill blocks from `references/questions.md`:

- Top 10 high-probability traps
- Critical date table
- Geography table
- Institutional structure (préfet vs. président du conseil, four Paris buildings, term lengths, school-level split)
- European timeline + EU institutions
- Three rights texts (1789 / 1946 / 2004)
- Infraction hierarchy (contravention / délit / crime)
- Numéros d'urgence (15 / 17 / 18 / 112)

Formatted in the chosen language with appropriate scaffolding. User can ask for elaboration on any block.

## End-of-session protocol

When the user signals they're done (says "stop," "that's enough," "je suis prêt," etc., or finishes all themes), do this in one final message:

1. **Final scorecard**: total questions answered, correct, overall percent, breakdown by theme
2. **Final miss list**: all questions missed in the session with their lock phrases, formatted as a copy-pasteable block the user can save for tomorrow's review
3. **Targeted advice**: identify the user's 1–2 weakest theme(s) and the top 3–5 highest-priority items to re-drill before their exam
4. **Exam-day reminders**:
   - 40 questions, 45 minutes, pass = 32/40
   - Bring ID + confirmation email
   - Arrive 30 min early
   - Eat normal lunch
   - Read each question stem twice on exam day
   - Watch for direction words (sud vs. sud-est) and trap words (toujours, tous, jamais — usually wrong)

## Reference files

Before the first batch in any mode, read:

- `references/questions.md` — 200 banked knowledge questions: official CSP question stems plus natural variations on the same testable concepts, with community-verified answers + 1-line notes, grouped by theme, plus the theme-specific drill blocks
- `references/scenarios.md` — guidance for generating the 12 unpublished *mises en situation* in mock exam mode, including pattern descriptions and example scenarios

Do not fabricate knowledge questions outside the bank. Scenario questions are generated only from the grounded patterns in `references/scenarios.md`. Do not edit the bank. If the user spots an error in a question or answer, acknowledge it and tell them to open an issue at https://github.com/kalinkalinka/examen-civique-skill/issues.

## Constraints

- **Question stems stay in French.** Always. Do not translate them. The exam is in French; recognizing the official phrasing is part of the prep.
- **Multiple-choice options stay in French.** Same reason.
- **Vocabulary glosses, explanations, scorecards, system messages: in user's chosen language.**
- **Do not reveal the correct answer before the user has attempted.** Even if the user asks (in which case, gently push back and ask them to guess first).
- **Do not skip the grading + explanation step** to move faster. The whole value is in the explanations.
- **Do not generate new knowledge questions** outside the bank. If you need to fill knowledge-question slots for a mock and the bank is short, repeat questions (and tell the user). Scenario questions are the exception: generate them only from the grounded patterns in `references/scenarios.md`.
- **Do not assume scaffolding level** mid-session. If the user wants more or less detail, they'll ask; otherwise stay at the level they chose at setup.
- **Be honest about uncertainty.** If a question's answer is ambiguous or the official source has updated, say so rather than confabulating.

## Failure modes to avoid

- Letter-mismatched grading (saying B is correct when the user said B but the correct answer was C — actually check)
- Defaulting all correct answers to the same letter when generating distractors — shuffle
- Burying the question under too much scaffolding — the user is there to drill, not to read essays
- Reciting answers without explanations — "the answer is 1958" is useless; "1958 is the Constitution of the Ve République, the current one — distinguish from 1946 which was the IVe République" is what they need
- Going past the user's stamina — if they ask how many more questions, give a real number and offer to stop

## Versioning

This is v0.1.0. The question bank reflects the official CSP list as of May 2026. If the Ministry updates the pool, this skill will go stale until the bank is updated.
