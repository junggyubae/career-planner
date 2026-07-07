# Career Planner Agent Guide

This repository is an agent workspace for building a user's private career
state, goals, discovery reports, and application materials.

## First Run

When a user opens or clones this repo and asks to set up Career Planner, do the
setup for them. Do not ask the user to run CLI commands unless automation fails.

1. Run the bootstrap script for the current platform:
   - macOS/Linux: `scripts/bootstrap.sh`
   - Windows PowerShell: `scripts/bootstrap.ps1`
2. If bootstrap fails because a required system tool is missing, install the
   smallest practical dependency and retry.
3. Run the doctor script if you need a compact setup report:
   - macOS/Linux: `scripts/doctor.sh`
   - Windows PowerShell: `scripts/doctor.ps1`
4. After setup, start onboarding. Ask the user to upload their CV, transcript,
   SOP, resume, research statement, or existing CV/SOP templates. Save uploaded
   documents under `state/uploads/` and extract grounded facts into `state/` and
   `goal/`.

## Workflows

- Use Info Retrieval when the user uploads documents or wants to be interviewed
  about identity, experience, interests, beliefs, or goals.
- Use Career Compass when the user wants a trajectory review, short-/mid-/long-term
  goals, next-step recommendations, gap analysis, or advice on what to do next.
- Use Finder when the user names a school and wants PI/lab discovery.
- Use Paper Briefing when the user wants to go deeper on candidate PIs/labs,
  review abstract-level paper evidence, prepare interview points, or generate
  SOP talking points from lab papers.
- Use Alignment when the user provides a target URL and wants tailored CV/SOP
  materials.

## Privacy

Never commit or push personal data. These paths are private and git-ignored:

- `state/` contents except skeleton `README.md` files
- `goal/` contents except skeleton `README.md`
- `action/` contents except skeleton `README.md` files
- `.codex/`, `.claude/`, `.cursor/`, `.mcp.json`
- `.agents/drwn/card.lock` and generated Darwinian files

Before any push, run `git status --short --ignored` and confirm only public docs,
scripts, card pins, and non-personal card logic are staged.

## PDF Toolchain

PDF compilation is useful but not required for onboarding. Prefer the light path:

1. `tectonic` if installed
2. `pdflatex` if installed
3. Leave `.tex` drafts in place and tell the user how to install Tectonic later

Do not install full TeX Live or MacTeX during first-run onboarding unless the
user explicitly asks for that heavier fallback.
