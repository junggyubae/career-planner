---
name: alignment
description: Use when the user provides a target URL (a lab, internship, or job) and wants tailored application materials. Resolve a template (the user's own from memory/uploads/ or the bundled default), analyze the target, match it against memory, and generate a tailored CV and SOP grounded strictly in memory. Render as LaTeX and compile to PDF with pdflatex. Beliefs shape SOP voice and fit. Never fabricate.
---

# Alignment — tailored CV + SOP from a target URL

Given a **target URL**, produce a CV and SOP tailored to it, grounded strictly in the user's memory, delivered as **`.tex` compiled to `.pdf`**.

## Steps

1. **Resolve the template.** Ask the user: use **your own template** or the **default**?
   - If `memory/uploads/` contains a user template (e.g. `cv-template.tex`, `sop-template.tex`), use it.
   - Otherwise use the bundled default: `card/templates/cv-template.tex` and `card/templates/sop-template.tex` (modern one-page academic CV).
2. **Fetch & analyze the target** at the URL: extract requirements, focus areas, keywords, and what the target values. If the page is unreachable, ask the user to paste the content.
3. **Read memory:** `basic-info/`, `experience/`, `interests/`, `beliefs/`.
4. **Match memory ↔ target:** select the most relevant experience and framing. Use **`beliefs/`** to argue genuine fit and to set the SOP's voice.
5. **Render `.tex`:**
   - **CV** — fill the template's placeholders from memory (identity from `profile.md`, entries from `experience/`).
   - **SOP** — narrative in the user's voice, arguing fit to this specific target, grounded in real experience + beliefs.
6. **Create the target folder** `output/<target-slug>/` and write:
   - `lab.md` — the analyzed target (lab/PI/role, requirements, keywords, source URL).
   - `cv.tex`, `sop.tex` — the tailored materials.
7. **Compile to PDF** with `pdflatex` (into the same folder):
   ```
   pdflatex -interaction=nonstopmode -output-directory output/<target-slug> output/<target-slug>/cv.tex
   ```
   producing `cv.pdf` and `sop.pdf`. If `pdflatex` is unavailable, still emit the `.tex` and tell the user how to install/compile.
8. **Update the spine:** add/update a row in `output/_manager.md` (date, target, type, status, link to the folder, coverage note).
9. **Coverage note:** in `lab.md` and the `_manager.md` row, list any target requirement not backed by memory (flag the gap — do **not** invent to fill it).

## Guardrails

- **100% of claims must trace to memory.** Never fabricate experience, skills, or dates.
- Beliefs inform SOP voice **and** the fit argument — not just a list of experience.
- Read-only on `memory/`. Write only to `output/` (git-ignored).
- Keep templates compiling on a vanilla `pdflatex` toolchain — avoid exotic packages.
