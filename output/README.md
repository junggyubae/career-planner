# output/

Generated artifacts. **Private** (git-ignored) — everything here except this README stays local.

## Layout

```
output/
├── _manager.md                 # index of every target/application (the spine)
├── <target-slug>/              # one folder per aligned target
│   ├── lab.md                  #   the analyzed target: lab/PI/role, requirements, keywords
│   ├── cv.tex                  #   tailored CV (LaTeX)
│   ├── cv.pdf                  #   compiled CV
│   ├── sop.tex                 #   tailored SOP (LaTeX)
│   └── sop.pdf                 #   compiled SOP
└── pi-finder/                  # PI Finder reports
    └── <school>-<date>.md
```

## `_manager.md`

The **spine** of `output/`: a running index of every target you've worked on, in reverse-chronological order, with status and a link to its folder. Alignment adds/updates a row each time it generates materials for a target.

Each `<target-slug>/` folder holds the analyzed target (`lab.md`) alongside the tailored `cv.*` and `sop.*` files, so everything for one application stays together.
