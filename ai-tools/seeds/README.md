# Session 8 seed files

These files are downloaded by students at the start of Session 8 via `curl`. They keep the in-class workflow simple: no API key setup, no agent design from scratch, no convention-writing under time pressure.

## Files

- **`CLAUDE.md`**: the project conventions seed. Students copy this into their `aem7010-ai/CLAUDE.md` as the standing context for Claude Code. It encodes the folder layout, the five-department list, the data schemas, the scraping conventions, the LLM classifier rules, and the `output/` versus `paper/` boundary.

- **`llm_responses.csv`**: the LLM classifier cache. One row per unique `placement` string in the five-department panel, with the model name, the date the call was made, the raw model response, and the parsed label. The file shipped here is a placeholder; **the instructor must regenerate it during the weekend pre-flight** by running `code/classify_llm.R` once with their own `ANTHROPIC_API_KEY` and committing the updated cache. Without this step, students will see the entire dataset labelled `uncached` in class.

- **`fact-checker.md`**: a Claude Code subagent definition. Read-only, takes a markdown report and a CSV path, and verifies that every numeric claim in the report's prose appears in the report's tables, figure captions, or notes section, or can be recomputed from the CSV. Used in the agents block of Session 8.

## Pre-flight checklist (instructor)

The weekend before each running of Session 8. Three steps, in this order. Skip any one and the room hits a real failure mode in class.

1. **Refresh the cache.** This is the one that quietly breaks the rest of the class if you forget. Run `code/classify_llm.R` once with your own `ANTHROPIC_API_KEY` set, on the full five-department panel from a fresh `aem7010-ai` clone. This produces a `data/cache/llm_responses.csv` with one row per unique placement string. Copy that file over `ai-tools/seeds/llm_responses.csv` in the course repo, commit, and push. Without this step, every cache lookup is a miss in class, every row is labelled `uncached`, and the analysis in block four becomes a degenerate figure of zeros.

2. **Spot-check the five placement pages.** Open each of [Cornell Dyson](https://dyson.cornell.edu/programs/graduate/placements/), [UC Berkeley ARE](https://are.berkeley.edu/graduate/job-market-placement), [UC Davis ARE](https://are.ucdavis.edu/graduate/phd-program/placement), [Minnesota Applied Economics](https://apec.umn.edu/graduate/job-placements), and [Wisconsin AAE](https://aae.wisc.edu/graduate-programs/placement/) in a browser and confirm each still renders a parseable PhD placement table. If any has switched to a JavaScript-rendered list or a search interface, swap it for a backup before class. Run the fallback `code/scrape_<dept>.R` scripts (which step 1 produced) from a fresh R session and confirm each CSV has at least 30 rows.

3. **Walk the agents demo end-to-end.** Run the fact-checker section once, in a Claude Code version matching what students will run. If the natural-language invocation does not spawn the subagent, note the working invocation syntax here in this README and update the tutorial's agents block to match.

## In-class fallback (instructor)

If Claude Code misbehaves on a student machine during the synchronous walkthrough, working versions of every script for this session live under `ai-tools/seeds/` in the course repo. They take a few seconds to run from the repo root and produce the same outputs. Use them as a reference, or as a literal drop-in if the room gets stuck on any single step.

## Sanity-check the URLs after pushing

Once the seed files are pushed, verify each curl URL the tutorial tells students to hit. From a fresh terminal:

```bash
curl -I https://raw.githubusercontent.com/arielortizbobea/aem7010/main/ai-tools/seeds/CLAUDE.md
curl -I https://raw.githubusercontent.com/arielortizbobea/aem7010/main/ai-tools/seeds/llm_responses.csv
curl -I https://raw.githubusercontent.com/arielortizbobea/aem7010/main/ai-tools/seeds/fact-checker.md
```

All three should return `HTTP/2 200` (or `HTTP/1.1 200 OK`).
