---
name: finder
description: PI Finder (v1). Use when the user wants to discover next-step research opportunities. The user must name a TARGET SCHOOL; deep-research PIs/labs at that school and rank them by fit against the user's memory AND beliefs. Output a ranked report to output/. Internships/industry roles and school-less discovery are Phase 2 — out of scope.
---

# Finder — PI Finder (v1)

Discover **Principal Investigators / labs** at a school the user names, ranked by genuine fit.

## Preconditions

- The user **must name a target school/institution**. If they haven't, ask for one before researching. (Open, school-less discovery is Phase 2.)

## Steps

1. **Read the full memory:** `basic-info/`, `experience/`, `interests/`, and **`beliefs/`**.
2. **Form a research profile:** skills, level (undergrad/MS/PhD-seeking), topical interests, and **values/beliefs** (what environment and style the user wants).
3. **Deep research the named school:** find PIs/labs whose work matches the profile. Prefer primary sources (lab pages, faculty directories, recent papers). Note recruiting signals when visible.
4. **Rank by fit** against both:
   - **Topical fit** — interests + experience ↔ the lab's research.
   - **Belief/values fit** — from `beliefs/` (mentorship style, lab culture, mission).
5. **Write a report** to `output/pi-finder/<school>-<date>.md`.

## Report format

For each PI (most-fitting first):

```markdown
### <PI name> — <Lab name>
- **Link:** <lab / faculty page URL>
- **Area:** <research area>
- **Why it fits (topical):** ties to specific memory facts (experience/interests)
- **Why it fits (beliefs):** ties to specific values in beliefs/
- **Signal:** <recruiting note, recent relevant paper, etc.>
```

End with a short **"gaps"** note: profile areas with no strong match at this school.

## Guardrails

- Never fabricate a PI, lab, or link — every entry must be a real, verifiable source.
- Ground every "why it fits" in specific memory facts; don't hand-wave.
- Read-only on `memory/`. Write only to `output/` (git-ignored).
