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
Prose detail…
```

`TIMELINE.md` is **generated** from these frontmatter blocks (reverse-chronological) and links each entry back to its source Markdown file — don't hand-edit it.
