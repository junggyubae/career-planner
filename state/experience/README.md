# state/experience/ — one file per item

Each experience is `<YYYY-slug>.md` with YAML frontmatter:

```yaml
---
title: Community Robotics Workshop Mentor
type: activity            # research | work | project | education | award | leadership | activity
start: 2024-03            # YYYY-MM
end: 2024-06              # YYYY-MM | present
org: Neighborhood Makerspace
tags: [robotics, teaching, outreach]
highlight: Led weekend robotics workshops for local high-school students
---
Prose detail…
```

`TIMELINE.md` is **generated** from these frontmatter blocks (reverse-chronological) and links each entry back to its source Markdown file — don't hand-edit it.
