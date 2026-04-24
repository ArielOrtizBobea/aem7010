# Session 7 handoff

Paste this into the first message of a new chat.

## Context

I am preparing **Session 7 of AEM 7010: Doing Applied Economics Research — Practical Skills** (Cornell Dyson PhD course, Ariel Ortiz-Bobea). The course runs April 8 to May 4, 2026. Session 7 is Wednesday, April 29, 2026, 8:40-9:55 AM, Warren 137.

Session 7 is the middle of a three-session AI module. The whole module uses one running exercise: scraping PhD placement pages from applied economics departments, then classifying placements.

- **Session 6** (done): chat only. Live demo of a chat-driven scrape of the Cornell Dyson placements page. Students then scrape a **different** department from a pre-vetted list (Berkeley ARE, Davis ARE, Minnesota APEC, Wisconsin AAE, Maryland AREC, MSU AFRE, Purdue Ag Econ), bring back the failure, and we debrief.
- **Session 7** (this one): agentic desktop AI (Cowork). The whole class returns to the Cornell Dyson page, this time with Cowork. This session teaches what changes when the agent can see files and run code.
- **Session 8** (May 4): code-native agent (Claude Code). Scale to five departments, add a rule-based plus LLM-based classifier, produce a short descriptive write-up.

## What lives in the repo

Repo root: `/Users/ao332/github/aem7010-practical-skills/`. Quarto website, renders to `docs/`.

- `ai-tools/session6.qmd` — full Session 6 tutorial companion. Read this first. Session 7 should match its tone and structure.
- `ai-tools/session7.qmd` — current **stub** with five anchored sections: `#recap-and-safety`, `#cowork-as-a-category`, `#guided-scrape`, `#stress-test`, `#debrief`. These are the headings to fill in.
- `ai-tools/session8.qmd` — stub, for cross-reference.
- `_quarto.yml` — sidebar already carries sub-entries for all three sessions. If you change anchors in session7.qmd, update the sidebar.

## Session 7 outline (locked)

Already in the stub. Do not reorganize without asking first.

1. **Recap and safety brief (~10 min)** — Mode A vs Mode B from Session 6. What changes with Cowork: file access, code execution, on-disk modifications. Git as the safety net. Cowork permissions walkthrough.
2. **Cowork as a category (~10 min)** — what Cowork is, category examples (Cowork, ChatGPT desktop, Gemini in Workspace). Teach the category, not the brand. What it is good and bad at.
3. **Guided scrape of Cornell Dyson placements (~30 min)** — live demo first, then students repeat on their own laptops. Target CSV: `placements_dyson.csv` with columns `name, year, placement, source_url`. Shared prompt handout with Mode B enforcement. Verification checklist. Everyone commits.
4. **Stress test: add a field (~10 min)** — students ask Cowork to add one of `is_postdoc`, `country`, or `placement_sector`. Watch for silent row loss or column reordering. Two students share what broke.
5. **Debrief and preview of Session 8 (~5 min)** — what worked, why Session 8 will be harder, homework is to install Claude Code.

Target page: <https://dyson.cornell.edu/programs/graduate/placements/>.

## Concrete deliverables to produce

These are Tasks #8, #9, #10 in my task list.

1. **Expand `ai-tools/session7.qmd`** from stub to full tutorial. Match the style of `session6.qmd`: prose-first, topical sentences, explicit anchor IDs, `.callout-note` and `.callout-warning` callouts where appropriate, `panel-tabset` if you need Terminal / RStudio / VS Code variants.
2. **Shared prompt handout** — the actual prompt students paste into Cowork. Mode B enforcement included (ask Cowork to write `scrape_dyson_cowork.R` and run it from a fresh R session, not to return the data directly).
3. **Verification checklist** — same format as Session 6.
4. **Fallback R script** `scrape_dyson_cowork.R` committed in the repo, so if Cowork misbehaves during the live demo the instructor has a working artifact to fall back on.
5. **Pre-flight note** — reminder that the instructor should manually check the Dyson page the weekend before April 29.

## User preferences

- R primary. Python only as a callout where relevant.
- Academic style: short sentences, topical sentences opening multi-paragraph sections.
- **No em-dashes.** Use periods, colons, or commas.
- The reproducible artifact is code, not chat. Enforce Mode B everywhere.

## First step for the new chat

Read `ai-tools/session6.qmd` end to end before writing anything in Session 7, so tone and structure carry across. Then open `ai-tools/session7.qmd` and expand it section by section.
