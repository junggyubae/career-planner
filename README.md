# Career Planner

Career Planner is an agent workspace for building a private career memory,
discovering research opportunities, and drafting tailored application materials.

Your personal files stay local in `state/`, `goal/`, and `action/`.

## Start

Open Codex or Claude Code and paste:

```text
Set up this Career Planner repo for me:
https://github.com/junggyubae/career-planner

Clone or open it if needed, run the bootstrap, verify the skills, and then start
onboarding me. Ask me to upload my CV, transcript, SOP, resume, research
statement, or templates. Keep all personal files private and do not push them.
```

The agent should handle Git, Bun, Darwinian, and skill setup for you.

## What Happens

- Uploads are saved in `state/uploads/`
- Career facts go into `state/`
- Goals go into `goal/`
- Discovery reports and applications go into `action/`
- PDFs are optional: Tectonic is preferred when installed, `pdflatex` is a fallback

## Use It

After setup, ask:

```text
I uploaded my CV and transcript. Import them into my career state.
Interview me to enrich my beliefs.
Find PIs at Stanford.
Tailor an application for this URL: https://...
```

## More

- [USER_GUIDE.md](USER_GUIDE.md) — workflows and manual setup
- [docs/ONBOARDING.md](docs/ONBOARDING.md) — agent-facing first-run flow
- [RELEASE.md](RELEASE.md) — maintainer checklist
- [card/README.md](card/README.md) — reusable card details
