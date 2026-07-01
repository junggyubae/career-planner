# state/experience/ — one file per item

Each experience is `<YYYY-slug>.md` with YAML frontmatter:

```yaml
---
title: Undergraduate Researcher, LDS Lab (SNU)
type: research            # research | work | project | education | award | leadership | activity
start: 2024-12            # YYYY-MM
end: 2025-07              # YYYY-MM | present
org: Seoul National University
tags: [optimization, SAM]
highlight: Adaptive SAM variant; MIT URTC 2024
---
Prose detail…
```

`TIMELINE.md` is **generated** from these frontmatter blocks (reverse-chronological) — don't hand-edit it.
