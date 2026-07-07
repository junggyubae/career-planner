# Release Checklist

Use this checklist before bumping the card or calling a Career Planner release ready.

The root Career Planner project version lives in `VERSION`. The `card/` submodule
has its own independent version in `card/card.json` and git tags.

## 1. Sync the card

```bash
git submodule update --init --recursive
git -C card fetch --tags origin
git submodule status --recursive
```

Confirm the root repo pins the intended `career-planner-card` commit or tag.

## 2. Materialize agent skills

```bash
scripts/bootstrap.sh
```

Confirm the generated Codex and Claude skill folders exist locally:

```bash
test -d .codex/skills/info-retrieval
test -d .codex/skills/finder
test -d .codex/skills/alignment
test -d .claude/skills/info-retrieval
test -d .claude/skills/finder
test -d .claude/skills/alignment
```

Generated folders are local workspace material and should remain ignored by Git.
The local `.agents/drwn/card.lock` file contains machine-specific store paths and
should not be committed.

## 3. Verify the privacy boundary

```bash
git status --short --ignored
git check-ignore -v state/identity.md state/beliefs.md goal/goals.md action/BOARD.md
```

Before pushing, confirm private files are ignored:

- `state/*.md` except tracked `README.md` skeleton files
- `state/experience/*.md` except `state/experience/README.md`
- `state/uploads/*`
- `goal/goals.md`
- `action/discovery/*`
- `action/applications/*`
- generated `.codex/`, `.claude/`, `.cursor/`, and `.mcp.json`
- `.agents/drwn/card.lock`

Only skeleton docs, card pins, and non-personal card logic should be tracked.

## 4. Check local dependencies

```bash
scripts/doctor.sh
command -v tectonic || command -v pdflatex || test -x /Library/TeX/texbin/pdflatex
```

Alignment can emit `.tex` without a PDF compiler. A release smoke test should
build both `cv.pdf` and `sop.pdf` when `tectonic` or `pdflatex` is available.

## 5. Smoke-test the workflows

Run one small pass through each skill:

1. **Info Retrieval:** add or refine one non-sensitive test experience, then confirm
   `state/TIMELINE.md` is reverse-chronological and each title links to its source
   `state/experience/*.md` file.
2. **Finder:** run one named-school PI search and confirm every included PI has a
   current-affiliation verification note plus an active-work signal.
3. **Alignment:** generate one application bundle from a target URL, compile both
   PDFs when `tectonic` or `pdflatex` is installed, and confirm the CV is one page.

## 6. Final push check

```bash
git status --short
git diff --cached --stat
git remote -v
```

Do not push if private state, uploads, generated applications, or local generated
agent folders appear in the staged changes.
