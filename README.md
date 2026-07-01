# Career Planner

A single **Darwinian Mind Card** that helps you plan your next career step — with a focus on academic / research paths. The card is the **policy** in an RL-shaped model: it maps your **state** + **goal** → **action**.

> Full spec: [.jg/prd-career-planner-card.md](.jg/prd-career-planner-card.md)

## The model — `state · goal · action`

- **`state/`** `s` — who you are (identity, experience, interests, beliefs, understanding)
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
│   ├── beliefs.md            #   your values & how you work — drives Finder fit AND SOP voice
│   ├── understanding.md      #   living self-synthesis — your current thesis; the agent reads it first
│   └── uploads/              #   raw CV/SOP + your own templates
├── goal/                     # PRIVATE — goals.md (short / mid / long-term)
├── action/                   # PRIVATE — git-ignored (what you do)
│   ├── discovery/            #   Finder reports
│   └── applications/         #   <slug>/ target.md + cv.{tex,pdf} + sop.{tex,pdf} + notes.md; derived BOARD.md
└── .jg/                      # planning docs (PRD)
```

### Inside `state/` — the three interview-derived files

`identity.md` and `experience/` are facts pulled from your CV. The other three are the **self-knowledge** the card leans on hardest — usually captured through the Info-Retrieval *interview*, not an upload:

- **`interests.md` — what pulls you.** The topics, problems, and open questions you're drawn to (e.g. "efficient inference", "training dynamics of RNNs"). **Finder** matches these against a lab's research to judge *topical* fit, and **Alignment** uses them to argue why a target excites you.
- **`beliefs.md` — your values & how you work.** What you optimize for, the environment you want (mentorship style, lab culture, pace), and your non-negotiables. This is the **culture/values** lens: **Finder** ranks labs on fit beyond just topic, and **Alignment** sets the *voice* of your SOP so it sounds like you.
- **`understanding.md` — your living self-synthesis.** A short "who I am and my current thesis about my path" — where you are, what you're leaning toward, the strengths you lead with. It's the executive summary the agent **reads first** to frame everything else, and the one page *you'd* actually reread. Keep it current; refine it whenever your direction shifts.

Together they answer *what excites me*, *how I want to work*, and *where I'm heading* — the difference between a generic CV and materials that sound like a specific person.

## Card as a submodule

The shareable card lives in its own repo — [junggyubae/career-planner-card](https://github.com/junggyubae/career-planner-card) — and is pinned here as a git submodule at `card/`. This keeps the card independently versioned and publishable while this repo holds your private memory.

```bash
# fresh clone: pull the card too
git clone --recurse-submodules https://github.com/junggyubae/career-planner.git
# already cloned:
git submodule update --init --recursive
# bump to a newer card release:
git -C card fetch --tags && git -C card checkout v0.2.0 && git add card && git commit -m "Bump card"
```

## Privacy model

- **The card is shareable.** The submodule carries only skills + non-personal default templates, so it can be published/cloned via Darwinian (`drwn card clone git+…`).
- **Your data is private.** `state/`, `goal/`, and `action/` are git-ignored — your identity, experience, interests, beliefs, goals, and applications never leave your machine.

Requires `pdflatex` for PDF compilation (the card still emits `.tex` if it's missing).
