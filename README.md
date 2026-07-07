# Career Planner

Career Planner is an agent workspace for building a private career memory,
discovering research opportunities, briefing lab papers, and drafting tailored
application materials.

Your personal files stay local in `state/`, `goal/`, and `action/`.

## Start

Open Codex or Claude Code and paste:

```text
Set up this Career Planner repo for me:
https://github.com/junggyubae/career-planner

Clone or open it if needed, run the bootstrap, verify the skills, and then start
onboarding me. Use scripts/bootstrap.sh on macOS/Linux or scripts/bootstrap.ps1
on Windows, then run the matching doctor script if you need to verify setup. Ask
me to upload my CV, transcript, SOP, resume, research statement, or templates.
Keep all personal files private and do not push them.
```

The agent should handle Git, Bun, Darwinian, and skill setup for you.

## What Happens

- Uploads are saved in `state/uploads/`
- Career facts go into `state/`
- Goals go into `goal/`
- Roadmaps, discovery reports, paper briefings, and applications go into `action/`
- PDFs are optional: Tectonic is preferred when installed, `pdflatex` is a fallback

## Use It

After setup, start one task at a time. Copy and paste one task command at a time
into your AI session based on what you want to focus on.

### Import Documents

```text
I uploaded my CV and transcript. Import them into my career state.
```

```text
I uploaded my SOP draft. Save it and extract useful state and goal facts.
```

### Build Self-Knowledge

```text
Interview me to enrich my beliefs.
```

```text
Interview me about my research interests.
```

Use the voice feature if you have it. Speaking your experience and beliefs out
loud is often faster than typing, and it gives you room to challenge yourself,
notice what feels unclear, and explore more freely.

### Plan Next Steps

```text
Review my career trajectory and recommend next steps.
```

```text
Create short-term, mid-term, and long-term goals from my state and beliefs.
```

```text
Find the biggest gaps in my profile and suggest what I should do next.
```

### Discover Opportunities

```text
Find PIs at Stanford.
```

```text
Find labs at MIT that fit my state and goals.
```

### Deepen Lab Fit

```text
Review abstracts for the MIT labs Finder found and prepare paper briefings.
```

```text
Help me prioritize these PIs using paper briefings and my beliefs.
```

### Draft Applications

```text
Tailor an application for this URL: https://...
```

```text
Tailor my CV and SOP for this internship posting: https://...
```

## More

- [USER_GUIDE.md](USER_GUIDE.md) — workflows and manual setup
- [docs/ONBOARDING.md](docs/ONBOARDING.md) — agent-facing first-run flow
- [RELEASE.md](RELEASE.md) — maintainer checklist
- [card/README.md](card/README.md) — reusable card details
