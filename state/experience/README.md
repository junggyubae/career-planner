# state/experience/ — one file per item

Each experience is `<YYYY-slug>.md` with YAML frontmatter:

```yaml
---
title: Honorary Member, SNU Tomorrow's Engineers Membership (STEM)
type: activity            # research | work | project | education | award | leadership | activity
start: 2024-09            # YYYY-MM
end: present              # YYYY-MM | present
org: SNU Tomorrow's Engineers Membership (STEM)
tags: [mentoring, teaching, outreach, research]
highlight: Mentored students through teaching, outreach, and research activities
---

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

The YAML frontmatter is the index: it powers sorting, timeline generation, and
quick matching. Put richer details in the Markdown body below the frontmatter.

`TIMELINE.md` is **generated** from these frontmatter blocks (reverse-chronological) and links each entry back to its source Markdown file — don't hand-edit it.
