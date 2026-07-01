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
├── card/                     # SHAREABLE — logic only, no personal data
│   ├── card.md               #   card manifest / overview
│   ├── skills/               #   info-retrieval · finder · alignment
│   └── templates/            #   default cv-template.tex · sop-template.tex
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

## Privacy model

- **The card is shareable.** It carries only skills + non-personal default templates, so it can be published/cloned via Darwinian.
- **Your memory is private.** `memory/` and `output/` are git-ignored — your identity, experience, interests, and beliefs never leave your machine.

Requires `pdflatex` for PDF compilation (the card still emits `.tex` if it's missing).
