# Career Planner

A single **Darwinian Mind Card** that helps you plan your next career step — with a focus on academic / research paths. The card bundles three skills that operate over a private, file-based memory.

> Full spec: [.jg/prd-career-planner-card.md](.jg/prd-career-planner-card.md)

## The three blocks

1. **Info Retrieval** — grow your memory by **uploading** documents (CV, SOP) or being **interviewed** on a topic. Both paths only *refine / enrich* memory; nothing is destructively overwritten. On any conflict, the card asks you to clarify.
2. **Finder (PI Finder, v1)** — name a **target school**; the card deep-researches **PIs / labs** there ranked by fit against your memory and beliefs.
3. **Alignment** — paste a **target URL** (lab / internship / job); the card generates a tailored **CV + SOP** grounded strictly in your memory, output as **LaTeX → PDF** (via `pdflatex`).

## Layout

```
career-planner/
├── card/                     # SUBMODULE → junggyubae/career-planner-card
│   ├── card.json             #   Darwinian manifest (@junggyubae/career-planner-card)
│   └── skills/               #   info-retrieval · finder · alignment
│       └── alignment/templates/   # default cv/sop .tex (modern 1-page academic)
├── memory/                   # PRIVATE — git-ignored (your data stays local)
│   ├── basic-info/           #   identity: homepage, GitHub, LinkedIn, IDs…
│   ├── experience/           #   _manager.md index + one file per experience
│   ├── uploads/              #   raw uploaded CV/SOP + your own templates
│   ├── interests/            #   research/career interests (interview-derived)
│   └── beliefs/              #   values & beliefs (used for finding AND SOP voice)
├── output/                   # PRIVATE — git-ignored
│   ├── _manager.md           #   spine indexing every target/application
│   ├── <target-slug>/        #   lab.md + cv.{tex,pdf} + sop.{tex,pdf}
│   └── pi-finder/            #   PI Finder reports
└── .jg/                      # planning docs (PRD)
```

## Card as a submodule

The shareable card lives in its own repo — [junggyubae/career-planner-card](https://github.com/junggyubae/career-planner-card) — and is pinned here as a git submodule at `card/`. This keeps the card independently versioned and publishable while this repo holds your private memory.

```bash
# fresh clone: pull the card too
git clone --recurse-submodules https://github.com/junggyubae/career-planner.git
# already cloned:
git submodule update --init --recursive
# bump to a newer card release:
git -C card fetch --tags && git -C card checkout v0.1.1 && git add card && git commit -m "Bump card"
```

## Privacy model

- **The card is shareable.** The submodule carries only skills + non-personal default templates, so it can be published/cloned via Darwinian (`drwn card clone git+…`).
- **Your memory is private.** `memory/` and `output/` are git-ignored — your identity, experience, interests, and beliefs never leave your machine.

Requires `pdflatex` for PDF compilation (the card still emits `.tex` if it's missing).
