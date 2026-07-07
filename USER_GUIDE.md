# User Guide

Career Planner helps you build a private career memory, discover research
opportunities, and generate tailored application materials from that memory.

The project is designed for Codex and Claude Code. The repo stores the workspace
shape; the `card/` submodule stores the reusable agent skills.

## 1. Recommended Agent Setup

Open Codex or Claude Code and paste:

```text
Set up this Career Planner repo for me:
https://github.com/junggyubae/career-planner

Clone or open it if needed, run the bootstrap, verify the skills, and then start
onboarding me. Ask me to upload my CV, transcript, SOP, resume, research
statement, or templates. Keep all personal files private and do not push them.
```

The repo includes agent instructions in `AGENTS.md`, a Claude bridge in
`CLAUDE.md`, and first-run scripts in `scripts/`.

## 2. Manual Setup

Use this section only if you want to run setup yourself or the agent asks for a
manual recovery step.

Career Planner expects a few local command-line tools.

| Tool | Why it is needed |
|------|------------------|
| `git` | Clone the repo and fetch the card submodule |
| `bun` | Runtime used by the `drwn` CLI package |
| `node` / `npm` | Run `darwinian-minds` through `npx` |
| `tectonic` | Optional lightweight PDF compiler |
| `pdflatex` | Optional heavier PDF compiler fallback |

Clone the project:

```bash
git clone --recurse-submodules https://github.com/junggyubae/career-planner.git
cd career-planner
```

Then run bootstrap:

```bash
scripts/bootstrap.sh
```

On Windows PowerShell:

```powershell
scripts/bootstrap.ps1
```

The bootstrap uses `npx --package darwinian-minds@latest drwn`, so you do not
need to install `drwn` globally.

If you already cloned the repo and only need to refresh the generated skills:

```bash
git submodule update --init --recursive
npx --yes --package darwinian-minds@latest drwn card clone --allow-untrusted-source git+https://github.com/junggyubae/career-planner-card.git#v0.2.5
npx --yes --package darwinian-minds@latest drwn write
```

Open the cloned `career-planner/` folder as a Codex workspace, then start a new
Codex thread from that repo root. The generated `.codex/skills/` folder should
include:

- `info-retrieval`
- `finder`
- `alignment`

## 3. Install Optional PDF Tools

PDF compilation is not required for onboarding, state building, Finder, or `.tex`
draft generation.

Alignment tries compilers in this order:

1. `tectonic`
2. `pdflatex`
3. no compiler — keep `.tex` drafts and install a compiler later

Tectonic is the recommended light option. On macOS with Homebrew:

```bash
brew install tectonic
```

If you already use a full LaTeX distribution, `pdflatex` remains supported. On
macOS, MacTeX often exposes it at `/Library/TeX/texbin/pdflatex`.

## 4. Understand The Workspace

Career Planner is organized around `state · goal · action`.

| Folder | Purpose | Git behavior |
|--------|---------|--------------|
| `state/` | Who you are: identity, experience, interests, beliefs, uploads | Private, git-ignored except skeleton READMEs |
| `goal/` | Where you are going: short-, mid-, and long-term goals | Private, git-ignored except skeleton README |
| `action/` | What you do: discovery reports and application bundles | Private, git-ignored except skeleton READMEs |
| `card/` | Reusable skills and templates | Public submodule |

The most important files you will gradually build are:

- `state/identity.md`
- `state/experience/*.md`
- `state/interests.md`
- `state/beliefs.md`
- `goal/goals.md`

`state/beliefs.md` is especially important. It captures values, working style,
non-negotiables, and the environments where you do your best work.

## 5. Build Your State

Use the **Info Retrieval** workflow when you want to add or refine your private
career memory.

For documents, upload the files directly in chat, then ask Career Planner to
import them:

```text
I uploaded my CV and transcript. Import them into my career state.
I uploaded my SOP draft. Save it and extract any useful state or goal facts.
```

The agent should save the original files under `state/uploads/`, keep them
untouched, extract grounded facts, and route those facts into `state/` and
`goal/`. Typical uploaded files include CVs, resumes, transcripts, SOP drafts,
research statements, and LaTeX CV/SOP templates.

LaTeX templates are treated specially: they stay in `state/uploads/` for
Alignment to use later, rather than being extracted as experience.

For interviews:

```text
Interview me to enrich my beliefs
Interview me about my research interests
Interview me about this experience
```

Info Retrieval should only refine and enrich. If new information conflicts with
existing state, the agent should stop and ask which version is correct.

Experience files live in `state/experience/` and use YAML frontmatter:

```yaml
---
title: Honorary Member, SNU Tomorrow's Engineers Membership (STEM)
type: activity
start: 2024-09
end: present
org: SNU Tomorrow's Engineers Membership (STEM)
tags: [mentoring, teaching, outreach, research]
highlight: Mentored students through teaching, outreach, and research activities
---
```

The YAML frontmatter is only the index. It should contain fields that need to be
sorted, summarized, or matched. Put richer details in the Markdown body:

```md
## Summary
One paragraph overview.

## Responsibilities
- What you did.

## Technical Work
- Methods, tools, systems, papers, or experiments.

## Outcomes
- Results, artifacts, presentations, publications, or impact.

## Reflection
What this experience says about your interests, values, or goals.

## Source
- `state/uploads/...`
```

`state/TIMELINE.md` is generated from experience frontmatter. Timeline entries
should be reverse-chronological and link back to their source experience files.

## 6. Discover PIs And Labs

Use **Finder** when you have a target school or institution.

```text
Find PIs at Stanford
Find labs at MIT that fit my state and goals.
```

Finder reads your `state/` and `goal/`, researches current faculty/labs, verifies
that each listed PI is currently affiliated and active, and writes a ranked report
to:

```text
action/discovery/<school>-<date>.md
```

Good Finder output should include:

- A real lab or faculty link
- Topical fit grounded in your state
- Belief or values fit grounded in `state/beliefs.md`
- Goal fit grounded in `goal/goals.md`
- A current-affiliation verification note
- Recent activity or recruiting signal when visible

## 7. Generate Application Materials

Use **Alignment** when you have a specific target URL, such as a lab, internship,
job, fellowship, or program page.

```text
Tailor an application for this URL: https://...
```

Alignment reads your state and goals, analyzes the target, then writes an
application bundle:

```text
action/applications/<target-slug>/
├── target.md
├── cv.tex
├── sop.tex
└── notes.md
```

If `tectonic` or `pdflatex` is installed, Alignment also writes `cv.pdf` and
`sop.pdf`.

The CV must be strictly one page. The SOP should use your real experience,
beliefs, and goals; it should not invent facts to satisfy the target.

## 8. PDF Requirements

Check PDF compiler availability with:

```bash
command -v tectonic || command -v pdflatex || test -x /Library/TeX/texbin/pdflatex
```

If `pdflatex` exists at `/Library/TeX/texbin/pdflatex` but Codex cannot find it,
add the TeX binary directory to the shell path before running PDF workflows:

```bash
export PATH="/Library/TeX/texbin:$PATH"
```

If `pdflatex` is unavailable, Alignment can still produce `.tex` files, but the
lighter recommended install is Tectonic.

## 9. Privacy Rules

The private files are intentionally ignored by Git. Before pushing, run:

```bash
git status --short --ignored
git check-ignore -v state/identity.md state/beliefs.md goal/goals.md action/BOARD.md
```

Do not push:

- Personal state files
- Goals
- Uploaded CVs, transcripts, SOPs, or templates
- Finder reports
- Application bundles
- Generated `.codex/`, `.claude/`, `.cursor/`, or `.mcp.json` files

The public repository should contain structure, docs, card pins, and non-personal
card logic only.

## 10. Troubleshooting

If setup looks stale, run the doctor:

```bash
scripts/doctor.sh
```

On Windows:

```powershell
scripts/doctor.ps1
```

If `npx ... drwn` reports that `bun` is missing, install Bun and restart your
shell:

```bash
brew install bun
```

or:

```bash
curl -fsSL https://bun.sh/install | bash
```

On Windows:

```powershell
powershell -c "irm bun.sh/install.ps1|iex"
```

Then restart PowerShell and run `bun --version`.

If Codex does not see the skills, run:

```bash
npx --yes --package darwinian-minds@latest drwn write
```

If the card pin is stale, run:

```bash
git submodule update --init --recursive
git -C card fetch --tags origin
```

If `drwn write` cannot resolve the card version, clone the exact git tag into the
local Darwinian store:

```bash
npx --yes --package darwinian-minds@latest drwn card clone --allow-untrusted-source git+https://github.com/junggyubae/career-planner-card.git#v0.2.5
npx --yes --package darwinian-minds@latest drwn write
```

If `drwn write` reports a corrupt card store after moving the repo between
machines, refresh the local lock and write again:

```bash
npx --yes --package darwinian-minds@latest drwn card update
npx --yes --package darwinian-minds@latest drwn write
```

If Alignment fails to build PDFs, check:

- `tectonic` or `pdflatex` is available to the shell
- LaTeX special characters are escaped
- Non-Latin characters were translated or romanized
- The CV has been tightened to one page

## 11. Maintainer Notes

The root project version is in `VERSION`. The reusable card version is in
`card/card.json` and the card repo's git tags.

Use [RELEASE.md](RELEASE.md) before publishing a new root or card bump.
