# User Guide

Career Planner helps you build a private career memory, discover research
opportunities, and generate tailored application materials from that memory.

The project is designed for Codex. The repo stores the workspace shape; the
`card/` submodule stores the reusable agent skills.

## 1. Install The CLI Tools

Career Planner expects a few local command-line tools.

| Tool | Why it is needed |
|------|------------------|
| `git` | Clone the repo and fetch the card submodule |
| `bun` | Runtime used by the `drwn` CLI package |
| `node` / `npm` | Install `darwinian-harness`, which provides `drwn` |
| `drwn` | Materialize the card skills into Codex and Claude folders |
| `pdflatex` | Compile tailored CV/SOP `.tex` files into PDFs |

On macOS with Homebrew:

```bash
brew install git bun node
npm install -g darwinian-harness
brew install --cask mactex-no-gui
```

If you already have MacTeX installed, you may not need the `mactex-no-gui`
install. The binary is often available at `/Library/TeX/texbin/pdflatex`.

On Debian or Ubuntu:

```bash
sudo apt-get update
sudo apt-get install -y git curl nodejs npm texlive-latex-base texlive-latex-recommended texlive-latex-extra
curl -fsSL https://bun.sh/install | bash
npm install -g darwinian-harness
```

After installing Bun with the shell script, restart your terminal or source your
shell profile so `bun` is on `PATH`.

Verify the tools:

```bash
git --version
bun --version
npm --version
drwn status
command -v pdflatex || test -x /Library/TeX/texbin/pdflatex
```

`pdflatex` is only required for the final PDF build in Alignment. You can still
build state, run Finder, and generate `.tex` drafts without it.

## 2. Install And Open The Project

Clone the project with its card submodule:

```bash
git clone --recurse-submodules https://github.com/junggyubae/career-planner.git
cd career-planner
```

If you already cloned it:

```bash
git submodule update --init --recursive
```

Install or refresh the Darwinian card in your local store, then materialize the
Codex and Claude skill folders:

```bash
drwn card clone --allow-untrusted-source git+https://github.com/junggyubae/career-planner-card.git#v0.2.4
drwn write
```

Open the repo in Codex. The generated `.codex/skills/` folder should include:

- `info-retrieval`
- `finder`
- `alignment`

## 3. Understand The Workspace

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

## 4. Build Your State

Use the **Info Retrieval** workflow when you want to add or refine your private
career memory.

For uploads:

```text
Use my uploaded CV to update my state
```

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

`state/TIMELINE.md` is generated from experience frontmatter. Timeline entries
should be reverse-chronological and link back to their source experience files.

## 5. Discover PIs And Labs

Use **Finder** when you have a target school or institution.

```text
Find PIs at Stanford
Find labs at Georgia Tech that fit my state and goals
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

## 6. Generate Application Materials

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
├── cv.pdf
├── sop.tex
├── sop.pdf
└── notes.md
```

The CV must be strictly one page. The SOP should use your real experience,
beliefs, and goals; it should not invent facts to satisfy the target.

## 7. PDF Requirements

Alignment uses `pdflatex` to build PDFs. Check availability with:

```bash
command -v pdflatex || test -x /Library/TeX/texbin/pdflatex
```

If `pdflatex` exists at `/Library/TeX/texbin/pdflatex` but Codex cannot find it,
add the TeX binary directory to the shell path before running PDF workflows:

```bash
export PATH="/Library/TeX/texbin:$PATH"
```

If `pdflatex` is unavailable, Alignment can still produce `.tex` files, but the
release-quality deliverable is a built PDF.

## 8. Privacy Rules

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

## 9. Troubleshooting

If `drwn` is missing:

```bash
npm install -g darwinian-harness
drwn status
```

If `drwn` reports that `bun` is missing, install Bun and restart your shell:

```bash
brew install bun
```

or:

```bash
curl -fsSL https://bun.sh/install | bash
```

If Codex does not see the skills, run:

```bash
drwn write
```

If the card pin is stale, run:

```bash
git submodule update --init --recursive
git -C card fetch --tags origin
```

If `drwn write` cannot resolve the card version, clone the exact git tag into the
local Darwinian store:

```bash
drwn card clone --allow-untrusted-source git+https://github.com/junggyubae/career-planner-card.git#v0.2.4
drwn write
```

If Alignment fails to build PDFs, check:

- `pdflatex` is available to the shell
- LaTeX special characters are escaped
- Non-Latin characters were translated or romanized
- The CV has been tightened to one page

## 10. Maintainer Notes

The root project version is in `VERSION`. The reusable card version is in
`card/card.json` and the card repo's git tags.

Use [RELEASE.md](RELEASE.md) before publishing a new root or card bump.
