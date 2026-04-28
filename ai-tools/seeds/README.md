# Session 8 seed files

These files are downloaded by students at the start of Session 8 via `curl`. They keep the in-class workflow simple: no API key setup, no agent design from scratch, no convention-writing under time pressure.

## Files

- **`CLAUDE.md`**: the project conventions seed. Students copy this into their `aem7010-ai/CLAUDE.md` as the standing context for Claude Code. It encodes the folder layout, the five-department list, the data schemas, the scraping conventions, the LLM classifier rules, and the `output/` versus `paper/` boundary.

- **`llm_responses.csv`**: the LLM classifier cache. One row per unique `placement` string in the five-department panel, with the model name, the date the call was made, the raw model response, and the parsed label. The file shipped here is a placeholder; **the instructor must regenerate it during the weekend pre-flight** by running `code/classify_llm.R` once with their own `ANTHROPIC_API_KEY` and committing the updated cache. Without this step, students will see the entire dataset labelled `uncached` in class.

- **`fact-checker.md`**: a Claude Code subagent definition. Read-only, takes a markdown report and a CSV path, and verifies that every numeric claim in the report's prose appears in the report's tables, figure captions, or notes section, or can be recomputed from the CSV. Used in the agents block of Session 8.

## Pre-flight checklist (instructor)

The weekend before each running of Session 8:

1. Pull the course repo and confirm the three files above exist.
2. Visit each of the five placement pages and confirm the table structure has not changed.
3. Run the scrapers from a fresh `aem7010-ai` repo and confirm row counts.
4. Run `code/classify_llm.R` with `ANTHROPIC_API_KEY` set to refresh `llm_responses.csv`. Commit and push.
5. Verify the three URLs resolve from a fresh terminal: `curl -I https://raw.githubusercontent.com/arielortizbobea/aem7010/main/ai-tools/seeds/CLAUDE.md` (and the other two) should return HTTP 200.
