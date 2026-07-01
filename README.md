# Career Planner

A single **Darwinian Mind Card** that helps you plan your next career step — with a focus on academic / research paths. The card is the **policy** in an RL-shaped model: it maps your **state** + **goal** → **action**.

> Full spec: [.jg/prd-career-planner-card.md](.jg/prd-career-planner-card.md)

## The model — `state · goal · action`

- **`state/`** `s` — who you are (identity, experience, interests, beliefs)
- **`goal/`** `g` — where you're going (short / mid / long-term)
- **`action/`** `a` — what you do: **discovery** (explore) + **applications** (exploit)

## The three blocks

1. **Info Retrieval** — grow your **state + goal** by **uploading** documents (CV, SOP) or being **interviewed**. Refine/enrich only; on conflict the card asks you to clarify.
2. **Finder (PI Finder, v1)** — name a **target school**; the card deep-researches **PIs / labs** there ranked by topical + belief + **goal** fit. → `action/discovery/`
3. **Alignment** — paste a **target URL**; the card generates a tailored **CV + SOP** grounded strictly in your `state`, output as **LaTeX → PDF**. → `action/applications/<slug>/`

## Layout

```
career-planner/
├── card/                     # SUBMODULE → junggyubae/career-planner-card (the policy)
│   ├── card.json             #   Darwinian manifest (@junggyubae/career-planner-card)
│   └── skills/               #   info-retrieval · finder · alignment
│       └── alignment/templates/   # default cv/sop .tex (modern 1-page academic)
├── state/                    # PRIVATE — git-ignored (who you are)
│   ├── identity.md           #   name, contact, links, current status
│   ├── experience/           #   one file per item (frontmatter) → derived TIMELINE.md
│   ├── interests.md          #   what pulls you — research/career interests & open questions
│   ├── beliefs.md            #   your core identity — values + how you act on them; drives Finder fit AND SOP voice
│   └── uploads/              #   raw CV/SOP + your own templates
├── goal/                     # PRIVATE — goals.md (short / mid / long-term)
├── action/                   # PRIVATE — git-ignored (what you do)
│   ├── discovery/            #   Finder reports
│   └── applications/         #   <slug>/ target.md + cv.{tex,pdf} + sop.{tex,pdf} + notes.md; derived BOARD.md
└── .jg/                      # planning docs (PRD)
```

### Inside `state/` — the interview-derived self-knowledge

`identity.md` and `experience/` are facts pulled from your CV. The other two are the **self-knowledge** the card leans on hardest — usually captured through the Info-Retrieval *interview*, not an upload:

- **`interests.md` — what pulls you.** The topics, problems, and open questions you're drawn to (e.g. "efficient inference", "training dynamics of RNNs"). **Finder** matches these against a lab's research to judge *topical* fit, and **Alignment** uses them to argue why a target excites you.
- **`beliefs.md` — your core identity.** Your values *and how you act on them* — what you optimize for, the principles behind your choices, the environment you want (mentorship, culture, pace), and your non-negotiables. In a world where facts and syntheses are cheap to generate, this is the **irreducibly human part** of you — so it's the anchor the card invests in most. **Finder** ranks labs on values/culture fit beyond topic; **Alignment** makes your SOP *sound like you* and argues genuine fit. Worth the most interview time.

Together they answer *what excites me* and *what I stand for* — the difference between a generic CV and materials that sound like a specific person. (Where you're heading lives in `goal/`.)

## Card as a submodule

The shareable card lives in its own repo — [junggyubae/career-planner-card](https://github.com/junggyubae/career-planner-card) — and is pinned here as a git submodule at `card/`. This keeps the card independently versioned and publishable while this repo holds your private memory.

```bash
# fresh clone: pull the card too
git clone --recurse-submodules https://github.com/junggyubae/career-planner.git
# already cloned:
git submodule update --init --recursive
# bump to a newer card release:
git -C card fetch --tags && git -C card checkout v0.2.1 && git add card && git commit -m "Bump card"
```

## Privacy model

- **The card is shareable.** The submodule carries only skills + non-personal default templates, so it can be published/cloned via Darwinian (`drwn card clone git+…`).
- **Your data is private.** `state/`, `goal/`, and `action/` are git-ignored — your identity, experience, interests, beliefs, goals, and applications never leave your machine.

Requires `pdflatex` for PDF compilation (the card still emits `.tex` if it's missing).
