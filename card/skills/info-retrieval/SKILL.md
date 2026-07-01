---
name: info-retrieval
description: Use to build and enrich the user's career memory. Two paths — (1) UPLOAD: the user provides a document (CV, SOP, transcript), save it to memory/uploads/ and refine its facts into the right memory folders; (2) INTERVIEW: the user wants to say more about a topic, present a list of focused questions then iterate, and refine/enrich the target memory file. Both paths only refine/enrich — never overwrite. Ask on any conflict.
---

# Info Retrieval

Grow the user's memory. This skill is the **only** writer of `memory/`. It performs **refine and enrichment only** — it never destructively overwrites or deletes user-authored content.

## Choose a path

Ask (or infer): **upload a document**, or **explain more (interview)**?

## Path A — Upload → refine

1. **Save raw file** to `memory/uploads/` (keep the original untouched).
2. **Extract facts** from the document.
3. **Detect conflicts** against existing memory (e.g. a role with different dates/titles).
   - On any conflict: **STOP and ask the user** which is correct. Never auto-resolve.
4. **Route facts** to the correct folder:
   - identity/contact/links → `memory/basic-info/profile.md`
   - jobs/research/projects/education/awards → a file per experience in `memory/experience/`
   - research/career interests → `memory/interests/`
   - values/beliefs → `memory/beliefs/`
5. **Update the spine:** add/adjust rows in `memory/experience/_manager.md` (reverse-chronological).
6. **Never invent** facts not present in the source.

> If the uploaded file is a CV/SOP **template** (`.tex`), leave it in `uploads/` for Alignment to use — don't extract it as experience.

## Path B — Interview → refine/enrich

1. **Pick a topic** with the user: a specific experience, an interest, or a belief.
2. **Present a LIST of focused questions** for that topic (not one at a time).
3. Let the user **answer the subset they want** — unanswered questions don't block progress.
4. **Iterate** with follow-ups until the user signals they're done.
5. **Refine/enrich** the target memory file: add new detail *and* sharpen existing facts. Do not overwrite prior content wholesale.
6. **Update** `_manager.md` or the relevant index if the change affects it.

## Where facts live

| Fact kind | Destination |
|-----------|-------------|
| name, contact, homepage, GitHub, LinkedIn, IDs, affiliation | `basic-info/profile.md` |
| an experience (research/work/project/education/award) | `experience/<slug>.md` + row in `_manager.md` |
| a research/career interest | `interests/*.md` |
| a value or belief | `beliefs/*.md` |
| raw uploaded document or user template | `uploads/` |

## Guardrails

- Refine/enrich only — no destructive overwrite or deletion.
- Ask the user on any conflict.
- Never fabricate; store only what the user provided.
- Everything you write lives under `memory/` (git-ignored, private).
