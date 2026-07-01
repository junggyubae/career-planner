# Career Planner — Mind Card

**Shareable artifact.** This card bundles the logic (three skills) and non-personal default templates. It contains **no personal data** and can be published/cloned via Darwinian. Personal memory lives in the (git-ignored) `memory/` folder of whichever project the card is applied to.

## Skills

| Skill | Purpose | Reads | Writes |
|-------|---------|-------|--------|
| [info-retrieval](skills/info-retrieval/SKILL.md) | Grow memory via upload-refine or interview | `uploads/`, all memory | all memory (refine/enrich only) |
| [finder](skills/finder/SKILL.md) | PI Finder — discover PIs/labs at a named school | all memory (incl. `beliefs/`) | `output/pi-finder/*.md` |
| [alignment](skills/alignment/SKILL.md) | Tailored CV + SOP for a target URL → `.tex` + `.pdf` | all memory, template | `output/<target>/` + `output/_manager.md` |

## Templates

- [`templates/cv-template.tex`](templates/cv-template.tex) — default **modern one-page academic CV** (compiles with `pdflatex`).
- [`templates/sop-template.tex`](templates/sop-template.tex) — default statement of purpose.

Both are used only when the user has **not** provided their own template in `memory/uploads/`.

## Invariants (shared by all skills)

1. **Refine/enrich only.** Never destructively overwrite or delete user-authored memory.
2. **Never fabricate.** Every CV/SOP claim and PI rationale must trace to memory (or the analyzed target). Flag gaps; don't invent.
3. **Ask on conflict.** When new input contradicts existing memory, stop and ask the user to clarify.
4. **Privacy.** Never write personal data into the card; personal artifacts go under `memory/` or `output/` (git-ignored).

## Materializing as a Darwinian card

This directory is structured to become a Darwinian Mind Card source. To formalize it, use the Darwinian authoring flow (`darwinian:author-mind-card`) to create a card source from these skills + templates, then `darwinian:apply-mind-card` to install it. See PRD **US-002**.
