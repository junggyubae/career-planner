# PRD: Career Planner — Darwinian Mind Card

**Status:** Draft
**Owner:** dev@greekwaters.io
**Last updated:** 2026-06-30
**Runtime:** Darwinian Mind Card running inside Claude Code (agent + file-based memory)

---

## 1. Introduction / Overview

The **Career Planner** is a single **Darwinian Mind Card** that helps a person plan their next career step — with a bias toward academic and research paths (labs, internships, hiring companies). The card bundles a small set of skills that operate over a **file-based memory** stored as markdown inside the repo.

The card does three things (three "blocks"):

1. **Info Retrieval** — build and enrich the user's memory, either by refining an **uploaded document** (CV, SOP, etc.) or by running a focused **interview** on a topic. Both paths only refine/enrich memory.
2. **Finder (PI Finder in v1)** — the user names a **target school/institution**, and the card performs **deep research** to discover **Principal Investigators (PIs) / labs** at that school whose work fits the user's memory and beliefs.
3. **Alignment** — given a **URL** for a specific target (a lab, an internship, a job), generate a **tailored CV and SOP** grounded in the user's memory and beliefs, output as **LaTeX (`.tex`) compiled to `.pdf`**.

The whole system is deliberately simple: no separate app, no database. The **repo is the product**. Memory lives as markdown files that both the human and the agent can read, diff, and version with git.

**Problem it solves:** Career planning is fragmented — your history lives in old CVs, your goals live in your head, and tailoring materials for each opportunity is slow and repetitive. Career Planner centralizes a durable, structured memory of who you are and automates the two highest-friction tasks: *finding* the right next step and *aligning* your materials to it.

---

## 2. Goals

- Provide **one Mind Card** that exposes three skills over a shared, file-based memory.
- Make memory **human-readable and hand-editable** — every fact is a markdown file the user can inspect and edit.
- Let a user grow their memory two ways: **upload → refine**, and **interview → refine/enrich**.
- Given a target school, surface **real PIs/labs** via deep research, ranked by fit against the user's memory and beliefs.
- Generate a **tailored CV and SOP** for any target URL, drawing only from verified memory (no fabrication), delivered as **`.tex` + compiled `.pdf`** using the user's template or a bundled default.
- Keep the memory schema **stable and extensible** (basic info, experience, uploads, interests, beliefs).
- Enforce a clean **shareable-vs-private split**: the card (logic) is shareable; the memory (personal data) is git-ignored and never leaves the user's machine.
- Restrict memory mutations to **refine and enrichment only** — no destructive overwrite or deletion.

---

## 3. Non-Goals (Out of Scope for v1)

- **No standalone UI / web app / backend.** The card runs in Claude Code over the repo.
- **Finder v1 is PI-finding only.** The user must name a target school; Finder discovers PIs/labs there. Internships and company/industry roles, and job-board/ATS integrations (LinkedIn/Indeed/Greenhouse APIs, auto-apply), are **Phase 2**.
- **No school-less / fully-open discovery in v1.** Finder needs a school to scope research; open-ended "find me anything anywhere" is deferred.
- **No auto-submission** of applications or emails on the user's behalf.
- **No multi-user / accounts / auth.** Single-user, single-repo.
- **No DOCX/HTML output in v1.** Alignment outputs LaTeX compiled to PDF only; other formats can come later.
- **No automated background scheduling.** The card acts when invoked.

---

## 4. System Overview

### 4.1 The Card and its three blocks

```mermaid
flowchart TD
    U([User]) -->|invokes| Card

    subgraph Card["Career Planner — Mind Card"]
        direction TB
        IR["Block 1: Info Retrieval Skill"]
        FIND["Block 2: Finder Skill"]
        ALIGN["Block 3: Alignment Skill"]
    end

    subgraph MEM["Memory (markdown in repo)"]
        BI["basic-info/"]
        EXP["experience/"]
        UP["uploads/"]
        INT["interests/"]
        BEL["beliefs/"]
    end

    IR -->|refine upload / interview append| MEM
    MEM -->|reads context| FIND
    MEM -->|reads context| ALIGN
    FIND -->|opportunities report| U
    ALIGN -->|tailored CV + SOP| U

    UPLOAD[/CV, SOP, docs/] --> IR
    URL[/Target URL: lab / internship / job/] --> ALIGN
```

### 4.2 How the blocks relate

- **Info Retrieval writes** to memory. **Finder and Alignment read** from it. This read/write split keeps the source of truth clean.
- Info Retrieval has **two entry paths** that both end at the same place (enriched memory): the **upload path** and the **interview path**. **Both paths refine and enrich memory** — the interview is not merely appending, it refines existing facts too.
- The only operations allowed on memory are **refine** and **enrichment**. No skill destructively overwrites or deletes user-authored content.
- Finder and Alignment never invent facts — they are grounded strictly in what memory contains.

### 4.3 Why a card *and* a repo (the privacy split)

The card and the repo are separated on purpose, along a **shareable vs. private** boundary:

- **The card is shareable.** It bundles only the *logic* — the three skills, the interview scripts, the research/alignment behavior. It carries **no personal data**, so it can be published and reused by anyone via the Darwinian sharing flow.
- **The repo's memory is private.** `memory/` (and generated `output/`) is **git-ignored** so a user never accidentally pushes their CV, SOP, identity, interests, or beliefs to a public remote. The memory lives locally with the user.

```mermaid
flowchart LR
    subgraph Shareable["Shareable — published via Darwinian"]
        C["Career Planner Card<br/>(skills / logic only, no personal data)"]
    end
    subgraph Private["Private — stays on the user's machine"]
        R["repo memory/ + output/<br/>(git-ignored)"]
    end
    C -.operates on.-> R
    C ==>|can be published / cloned| Others([Other users])
    R -.->|never committed to a public remote| X((( )))
```

**Implication:** installing/sharing the card gives someone the *capability*; their own memory folder stays theirs. Two users can run the identical card against completely separate, private memories.

---

## 5. Memory Design

Memory is a set of subfolders under `memory/`. Every fact is a markdown file so it is diffable, greppable, and editable by hand.

### 5.1 Folder structure

```mermaid
flowchart TD
    M["memory/"]

    M --> BI["basic-info/"]
    BI --> BIp["profile.md<br/>(name, GitHub ID, LinkedIn ID,<br/>personal homepage, email, links)"]

    M --> EXP["experience/"]
    EXP --> EXPm["_manager.md<br/>(index of all experiences,<br/>in time order)"]
    EXP --> E1["2024-summer-lab-x.md"]
    EXP --> E2["2023-internship-y.md"]
    EXP --> E3["...one file per experience"]

    M --> UP["uploads/"]
    UP --> UPa["cv-2024.pdf / .md"]
    UP --> UPb["sop-draft.md"]
    UP --> UPt["cv-template.tex / sop-template.tex<br/>(user's own template, optional)"]
    UP --> UPc["...raw user-uploaded files"]

    M --> INT["interests/"]
    INT --> INTa["research-interests.md"]
    INT --> INTb["...interview-derived topics"]

    M --> BEL["beliefs/"]
    BEL --> BELa["values-and-beliefs.md"]
    BEL --> BELb["...interview-derived beliefs"]
```

### 5.2 Subfolder responsibilities

| Subfolder | Contents | Written by | Read by |
|-----------|----------|------------|---------|
| `basic-info/` | Identity: name(s), GitHub ID, LinkedIn ID, personal homepage, email, personal links | Info Retrieval | Finder, Alignment |
| `experience/` | `_manager.md` index (time-ordered) + one markdown file per experience | Info Retrieval | Finder, Alignment |
| `uploads/` | Raw files the user uploaded (CV, SOP, transcripts) **and the user's own CV/SOP template if provided** | Info Retrieval (upload path) | Info Retrieval (as source to refine); Alignment (reads user template) |
| `interests/` | Research/career interests captured via interview | Info Retrieval (interview path) | Finder, Alignment |
| `beliefs/` | Values and beliefs captured via interview | Info Retrieval (interview path) | **Finder (fit/ranking)** and **Alignment (SOP voice + fit)** |

### 5.3 The Experience Manager

`experience/_manager.md` is the **spine** of the experience subsystem:

- Maintains a **time-ordered list** of every experience with a one-line summary and a link to its detail file.
- Info Retrieval's **interview path** targets a specific experience file and **appends** deeper detail to it (and updates the manager summary if needed).
- Alignment and Finder read the manager first to understand the arc of the user's history, then drill into individual files as needed.

**Example `_manager.md` shape (illustrative):**

```markdown
# Experience Manager

| Date | Title | File | Summary |
|------|-------|------|---------|
| 2024-06 → 2024-08 | Research Intern, Lab X | [file](2024-summer-lab-x.md) | Built Y, learned Z |
| 2023-06 → 2023-08 | SWE Intern, Company Y | [file](2023-internship-y.md) | Shipped feature W |
```

---

## 6. Block Flows

### 6.1 Block 1 — Info Retrieval (two paths)

```mermaid
flowchart TD
    Start([User invokes Info Retrieval]) --> Q{Upload a document<br/>or explain more?}

    Q -->|Upload document| U1[Save raw file to uploads/]
    U1 --> U2[Parse & extract facts]
    U2 --> Uc{Conflict with<br/>existing memory?}
    Uc -->|Yes| Uq[Ask user to clarify<br/>which is correct]
    Uq --> U3
    Uc -->|No| U3[Route facts to correct subfolder:<br/>basic-info / experience / interests / beliefs]
    U3 --> U4[Update experience/_manager.md<br/>if new experiences found]
    U4 --> Done([Memory refined / enriched])

    Q -->|Explain more| I1[User picks a topic:<br/>an experience / interest / belief]
    I1 --> I2[Present a LIST of<br/>focused questions]
    I2 --> I3[User answers the ones they want]
    I3 --> I4{Follow-up or<br/>next question?}
    I4 -->|Iterate| I2
    I4 -->|Done| I5[Refine & enrich the<br/>target memory file]
    I5 --> I6[Update manager/index if relevant]
    I6 --> Done
```

**Upload path:** the user drops a CV/SOP/etc. The card saves the raw file to `uploads/`, extracts structured facts, and **refines them into the right subfolders**. New experiences are added as files and registered in `_manager.md`. **If any extracted fact conflicts with existing memory** (e.g. different dates or titles for the same role), the card **always stops and asks the user to clarify** which is correct — it never silently picks a winner.

**Interview path:** the user wants to say more about a topic. The card first **presents a list of focused questions** for that topic, the user answers the ones they want, and the card **iterates** with follow-ups. Answers **refine and enrich** the relevant memory file — adding new detail *and* sharpening existing facts. Both paths perform only refine/enrichment; neither destroys prior content.

### 6.2 Block 2 — Finder (PI Finder, deep research)

```mermaid
flowchart LR
    S([User invokes Finder]) --> S0[/User names a<br/>target school/institution/]
    S0 --> R1[Read memory:<br/>basic-info, experience,<br/>interests, beliefs]
    R1 --> R2[Form a research profile:<br/>skills, level, interests, beliefs/values]
    R2 --> R3[Deep research the school:<br/>discover PIs / labs there]
    R3 --> R4[Rank PIs by fit against<br/>profile + beliefs]
    R4 --> R5[Produce PI report:<br/>lab link, PI, why-it-fits,<br/>belief/interest alignment]
    R5 --> Out([Report delivered to user])
```

**v1 behavior:** the user **names a target school**. Finder reads the full memory (including `beliefs/`), forms a research profile, and runs **deep research scoped to that school** to surface **PIs / labs** there. Output is a **ranked report** — each PI has a lab link and a short "why this fits you" that references specific memory facts *and* belief/interest alignment.

**Phase 2 (noted, out of scope now):** internships and company/industry roles, school-less open discovery, structured source integrations (job boards, lab directories), saved searches, and periodic re-runs.

### 6.3 Block 3 — Alignment (URL → tailored CV + SOP)

```mermaid
flowchart LR
    S([User provides target URL]) --> T{Template?}
    T -->|User has one| Tu[Use user template<br/>from uploads/]
    T -->|None| Td[Use bundled default<br/>.tex template]
    Tu --> A1
    Td --> A1
    A1[Fetch & analyze target:<br/>lab / internship / job page] --> A2[Extract requirements,<br/>focus areas, keywords]
    A2 --> A3[Read memory:<br/>experience, interests,<br/>beliefs, basic-info]
    A3 --> A4[Match memory ↔ target:<br/>select most relevant evidence]
    A4 --> A5[Render tailored CV .tex<br/>grounded only in memory]
    A4 --> A6[Render tailored SOP .tex<br/>in user's voice + beliefs]
    A5 --> C[Compile .tex → .pdf]
    A6 --> C
    C --> Out([.tex + .pdf delivered])
```

**v1 behavior:** the user pastes a URL for a specific target. Alignment first resolves the **template**: it **asks whether the user has their own CV/SOP template** — if one exists in `uploads/`, it uses that; otherwise it uses the **bundled default template** (which we must create and ship with the card). It then fetches and analyzes the target, matches it against memory, and renders a **tailored CV and SOP as LaTeX (`.tex`)**, which it **compiles to `.pdf`**. Everything is grounded in memory — **no fabricated experience**. The SOP leans on `beliefs/` and `interests/` to sound like the user, and `beliefs/` also informs *why the user fits* the target.

### 6.4 End-to-end sequence (typical first session)

```mermaid
sequenceDiagram
    actor User
    participant Card as Career Planner Card
    participant Mem as memory/ (repo)

    User->>Card: Upload CV
    Card->>Mem: Save to uploads/, refine into basic-info & experience
    Card-->>User: Memory initialized

    User->>Card: "Ask me about my 2024 lab work"
    Card->>User: List of focused questions
    User->>Card: Answers (iterates with follow-ups)
    Card->>Mem: Refine/enrich experience file + update _manager.md

    User->>Card: Run Finder for "Stanford"
    Card->>Mem: Read full profile + beliefs
    Card-->>User: Ranked PIs/labs at Stanford (deep research)

    User->>Card: Align to <lab URL>
    Card->>User: Use your template or default?
    Card->>Mem: Read experience/interests/beliefs (+ user template)
    Card-->>User: Tailored CV + SOP as .tex + compiled .pdf
```

---

## 7. User Stories

### US-001: Scaffold the memory folder structure
**Description:** As a user, I want the repo to contain the memory folder skeleton so the card has a known place to read and write facts.

**Acceptance Criteria:**
- [ ] `memory/` contains `basic-info/`, `experience/`, `uploads/`, `interests/`, `beliefs/`
- [ ] `experience/_manager.md` exists with the time-ordered table header
- [ ] `basic-info/profile.md` exists with placeholder fields (name, GitHub, LinkedIn, personal homepage, email, links)
- [ ] Each subfolder has a short `README.md` (or top comment) explaining what belongs there

### US-002: Author the Career Planner Mind Card
**Description:** As a user, I want a single Darwinian Mind Card that registers the three skills so I can invoke the whole system from Claude Code.

**Acceptance Criteria:**
- [ ] A card source is created via the Darwinian authoring flow
- [ ] The card bundles three skills: Info Retrieval, Finder, Alignment
- [ ] The card applies cleanly to the project (materializes skills without errors)
- [ ] Inspecting the card shows all three skills active

### US-003: Info Retrieval — upload path
**Description:** As a user, I want to upload a CV/SOP and have it refined into memory so I don't have to type my history manually.

**Acceptance Criteria:**
- [ ] Raw uploaded file is saved under `uploads/`
- [ ] Facts are routed to the correct subfolder (basic-info / experience / interests / beliefs)
- [ ] Each distinct experience becomes its own file under `experience/`
- [ ] `experience/_manager.md` is updated with new rows in time order
- [ ] On any conflict with existing memory, the card **stops and asks the user to clarify** (never auto-resolves)
- [ ] No fact is invented — only what appears in the source is stored

### US-004: Info Retrieval — interview path
**Description:** As a user, I want the card to interview me about a topic so I can add depth the documents don't capture, and refine facts that are already there.

**Acceptance Criteria:**
- [ ] User can name a topic (a specific experience, interest, or belief)
- [ ] Card first presents a **list of focused questions** for the topic, then **iterates** with follow-ups
- [ ] User can answer a subset; unanswered questions don't block progress
- [ ] Answers **refine and enrich** the correct memory file — new detail is added and existing facts can be sharpened, but nothing is destructively overwritten
- [ ] Relevant index/manager entry is updated
- [ ] Interview ends when the user signals enough depth

### US-005: Finder — PI finder for a target school
**Description:** As a user, I want to name a school and get a ranked list of PIs/labs there that fit me.

**Acceptance Criteria:**
- [ ] Card requires the user to name a target school before researching
- [ ] Finder reads the full memory, including `beliefs/`, before researching
- [ ] Output is a ranked list of **PIs/labs at that school**
- [ ] Each item includes the lab link, PI name, and a "why it fits" tied to specific memory facts **and** belief/interest alignment
- [ ] The report is saved to `output/pi-finder/<school>-<date>.md`

### US-006: Alignment — tailored CV + SOP from a URL (LaTeX → PDF)
**Description:** As a user, I want to give a target URL and get a CV and SOP tailored to it, grounded in my memory, as polished PDFs.

**Acceptance Criteria:**
- [ ] Card asks whether to use the user's own template or the default; uses the user's `uploads/` template if present, else the bundled default
- [ ] Card fetches and summarizes the target's requirements/focus
- [ ] CV and SOP are generated using only facts present in memory
- [ ] SOP reflects the user's voice using `beliefs/` and `interests/`, and cites belief/interest fit to the target
- [ ] Each target gets its own folder `output/<target-slug>/` containing `lab.md` (analyzed target), `cv.tex`/`cv.pdf`, and `sop.tex`/`sop.pdf`
- [ ] Outputs are rendered as `.tex` **and compiled to `.pdf`** via `pdflatex`
- [ ] `output/_manager.md` is updated with a row per target (date, target, type, status, folder link, coverage note)
- [ ] A short "coverage note" flags any target requirement not backed by memory

### US-008: Bundle default LaTeX templates
**Description:** As a user without my own template, I want a good-looking default CV/SOP so I get a usable PDF out of the box.

**Acceptance Criteria:**
- [ ] A default `cv-template.tex` and `sop-template.tex` ship **with the card** (shareable, no personal data)
- [ ] Templates compile to PDF cleanly with a standard LaTeX toolchain
- [ ] Templates use clear placeholder fields that Alignment fills from memory
- [ ] Alignment falls back to these when the user has no template in `uploads/`

### US-007: Memory stays private and human-editable
**Description:** As a user, I want my memory to be plain, editable files that never get pushed to a public remote.

**Acceptance Criteria:**
- [ ] All memory is plain markdown
- [ ] `memory/` and `output/` are listed in `.gitignore` (personal data is never committed)
- [ ] The shareable card contains **no** personal data
- [ ] A user hand-editing a memory file does not break any skill

---

## 8. Functional Requirements

- **FR-1:** The system must expose exactly one Mind Card that bundles three skills: Info Retrieval, Finder, Alignment.
- **FR-2:** The system must store all memory as markdown files under `memory/` in the subfolders: `basic-info/`, `experience/`, `uploads/`, `interests/`, `beliefs/`.
- **FR-3:** Info Retrieval must support an **upload path**: save the raw file to `uploads/`, then refine extracted facts into the correct subfolders.
- **FR-4:** Info Retrieval must support an **interview path**: present a **list of focused questions** on a chosen topic, iterate with follow-ups, and refine/enrich the correct memory file with the answers.
- **FR-5:** Each experience must be a separate markdown file, registered in a time-ordered `experience/_manager.md` index.
- **FR-6:** Finder must require a **target school**, read the full memory (including `beliefs/`), then run deep research scoped to that school to produce a ranked **PI/lab** report with lab links and justifications grounded in memory and beliefs.
- **FR-7:** Alignment must accept a target URL, resolve a template (user-provided from `uploads/` or the bundled default), analyze the target, and generate a tailored CV and SOP grounded strictly in memory, rendered as **`.tex` and compiled to `.pdf`**.
- **FR-8:** No skill may fabricate facts not present in memory or the analyzed target; unsupported claims must be flagged, not invented.
- **FR-9:** The only operations any skill may perform on memory are **refine** and **enrichment** (via both the upload and interview paths). Destructive overwrite or deletion of user-authored content is not permitted.
- **FR-10:** `memory/` and `output/` must be git-ignored; the shareable card must contain no personal data.
- **FR-11:** When Info Retrieval detects a conflict between new input and existing memory, it must **stop and ask the user to clarify**; it must not auto-resolve.
- **FR-12:** The card must ship **default `cv-template.tex` and `sop-template.tex`** (containing no personal data) used when the user has not provided their own template.

---

## 9. Technical Considerations

- **Runtime:** Darwinian Mind Card + Claude Code. Use the `darwinian:author-mind-card` and `darwinian:apply-mind-card` flows to create and install the card; skills are standard Claude Code skills bundled in the card source.
- **Card convention (important):** a Darwinian card source is **not** stored inline in the consumer repo. Here the card lives in its **own public git repo** — [`junggyubae/career-planner-card`](https://github.com/junggyubae/career-planner-card) (manifest `card.json`, `skills/`, templates bundled under `skills/alignment/templates/`) — and is pinned into this repo as a **git submodule at `card/`**. This keeps the card independently versioned (currently `v0.1.1`), publicly shareable, and drwn-consumable (`drwn card clone git+https://github.com/junggyubae/career-planner-card.git#v0.1.1`). **This repo is the *consumer*** (holds private `memory/` + the submodule pointer). Editing flow: change the card repo → tag a release → bump the submodule pointer here.
- **No database:** the filesystem is the store. Prefer many small files over few large ones for clean diffs.
- **Output structure:** `output/` mirrors `experience/` in spirit — an `output/_manager.md` spine indexes every target, and each target gets a folder `output/<target-slug>/` holding `lab.md` + `cv.{tex,pdf}` + `sop.{tex,pdf}`. PI Finder reports go under `output/pi-finder/`.
- **Privacy boundary:** ship a `.gitignore` that excludes `memory/` and `output/` contents from every commit (re-including only READMEs / `.gitkeep` so the *structure* is shareable), so personal data can never be pushed. The repo itself can be public; the card is shared separately via `share-mind-card`.
- **Deep research (Finder):** v1 relies on the agent's research/web tooling, scoped to the named school. Keep the research contract (inputs = school + memory profile, output = ranked PI report) stable so Phase-2 targets (internships, industry) and source integrations can slot in behind it.
- **URL fetching (Alignment):** must degrade gracefully if a target page is unreachable (ask the user to paste the content).
- **LaTeX toolchain:** Alignment compiles `.tex` → `.pdf` with **`pdflatex`**. If `pdflatex` is not installed, the card should still emit the `.tex` and tell the user how to install/compile. Default templates must compile with a vanilla `pdflatex` toolchain (avoid exotic packages / non-standard fonts).
- **Templates:** default templates live **in the card source** (shareable). User templates live in `memory/uploads/` (private) and take precedence.
- **Grounding discipline:** consider a shared convention (e.g. a `sources:` footnote or memory-file references) so CV/SOP claims are traceable to memory.
- **Voice:** SOP generation should read `beliefs/` and `interests/` to match tone and argue fit, not just list experience.

---

## 10. Success Metrics

- A new user can go **upload → enriched memory** in a single session with no manual file editing.
- PI Finder returns **≥ 5 relevant, real PIs/labs** at the named school per run, each with a memory- and belief-grounded rationale.
- Alignment produces a CV + SOP for a given URL where **100% of claims trace to memory** (zero fabricated facts), delivered as a clean compiled PDF.
- Memory stays **fully human-readable** — a user can open any file and understand/edit it without the card.

---

## 11. Resolved Decisions

These were open questions, now decided:

1. **Basic-info identifiers:** enrich **as much as possible** — primary is the **personal homepage**, plus name/preferred name/pronouns, emails, phone, location, GitHub, LinkedIn, Google Scholar, ORCID, X/Twitter, ResearchGate, current affiliation/role, education summary, languages, and work authorization. *(Not just ORCID.)*
2. **Conflict handling:** the card **always asks the user to clarify** on any conflict; never auto-resolves.
3. **Interview depth:** the card **presents a list of questions, then iterates** with follow-ups; the user drives when to stop.
4. **Output format:** CV/SOP are **LaTeX (`.tex`) compiled to `.pdf` via `pdflatex`**. Use the user's uploaded template if provided; otherwise the **bundled default template** — a **modern one-page academic CV** (and a matching clean SOP). DOCX/HTML deferred.
5. **Finder scope (v1):** **PI Finder first** — the user names a **school**, and Finder discovers PIs/labs there. Internships/industry and open (school-less) discovery are Phase 2.
6. **Beliefs usage:** `beliefs/` informs **both** Finder ranking **and** Alignment's SOP voice/fit.

## 12. Remaining Open Questions

*None blocking — all major decisions resolved. Ready to build.*
```
