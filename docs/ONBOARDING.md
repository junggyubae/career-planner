# Onboarding Flow

This is the agent-facing first-run flow for Career Planner.

## Goal

Get the user from "I opened this GitHub repo in Codex or Claude Code" to a
working private career workspace without requiring them to know Git, npm, Bun,
Darwinian, or LaTeX.

## Setup

1. Run `scripts/bootstrap.sh` on macOS/Linux or `scripts/bootstrap.ps1` on
   Windows.
2. Verify the generated skills exist:
   - `.codex/skills/info-retrieval`
   - `.codex/skills/finder`
   - `.codex/skills/alignment`
   - `.claude/skills/info-retrieval`
   - `.claude/skills/finder`
   - `.claude/skills/alignment`
3. Treat PDF compilation as optional. Tectonic is preferred; `pdflatex` is a
   fallback. Missing PDF tools should not block onboarding.

## First Conversation

After setup, say briefly what is ready and ask the user to upload documents:

```text
Career Planner is ready. Upload any CV, resume, transcript, SOP, research
statement, or existing CV/SOP template you want me to use. I will keep the raw
files in state/uploads/, extract grounded facts into state/ and goal/, and ask
before resolving conflicts.
```

Then use Info Retrieval.

## Document Import

- Save raw uploaded files under `state/uploads/`.
- Do not overwrite existing state destructively.
- Extract facts into:
  - `state/identity.md`
  - `state/experience/*.md`
  - `state/interests.md`
  - `state/beliefs.md`
  - `goal/goals.md`
- Regenerate `state/TIMELINE.md` from experience frontmatter.
- Ask the user to resolve conflicts instead of guessing.

## Interview

If the user has no documents or wants to go deeper, interview them. Prioritize:

1. Current academic/professional status
2. Experiences and projects
3. Research/career interests
4. Beliefs, values, working style, and non-negotiables
5. Short-, mid-, and long-term goals

Beliefs matter most for fit and voice. Spend extra time there.

## Done

First-run onboarding is complete when:

- The workspace is bootstrapped or the blocker is clearly explained.
- Raw uploads, if any, are saved in `state/uploads/`.
- Initial `state/` and `goal/` files exist.
- The user knows the next available actions:
  - "Find PIs at <school>"
  - "Tailor an application for this URL: <url>"
  - "Interview me more about <topic>"
