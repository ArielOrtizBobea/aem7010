# aem7010

Course site for **AEM 7010: Doing Applied Economics Research — Practical Skills**, taught at Cornell's Dyson School. Live at <https://arielortizbobea.github.io/aem7010/>.

## Repo layout

```
aem7010/
├── index.qmd              landing page (offerings list), served at /aem7010/
├── _quarto.yml            site config (landing-only; per-semester sources live elsewhere)
├── cornell.scss           Cornell theme overrides
├── images/                site logos and favicon
├── spring-2026/           frozen static snapshot, served at /aem7010/spring-2026/
├── spring-YYYY/           future frozen snapshots
├── freeze-semester.sh     script to add a new snapshot
├── preview.command        double-click to launch `quarto preview` locally
└── README.md
```

The Quarto source for each semester lives on a same-named git **branch and tag** (e.g., `spring-2026`). `main` does not contain editable course source. Once a semester is frozen, its branch is the canonical record of as-taught material.

## Why pinned per-semester URLs

Every advertised semester URL stays truthful forever. `arielortizbobea.github.io/aem7010/spring-2026/` will always show the Spring 2026 site exactly as taught, byte-identical, even after later semesters are added. This is the URL-level analog of git branches: a former student or colleague can cite "the version that taught X in Spring 2026" at a stable address.

The bare path `/aem7010/` is just a thin index of offerings. It is not a moving target tracking the latest semester.

## How to freeze a new semester

Once a semester ends and you are ready to freeze it:

1. Make sure the per-semester branch is pushed and tagged. For example:
   ```bash
   git checkout spring-2027
   git tag spring-2027
   git push origin refs/heads/spring-2027:refs/heads/spring-2027
   git push origin spring-2027   # the tag
   ```

2. Switch to `main` and run the freeze script:
   ```bash
   git checkout main
   ./freeze-semester.sh spring-2027
   ```
   The script renders the per-semester branch in a temporary worktree, copies the rendered output into `main:/spring-2027/`, and removes the worktree.

3. Edit `index.qmd`. Add a new offering entry at the top of the offerings list. Demote the previous "Most recent" badge to "Frozen".

4. Commit, push, and publish:
   ```bash
   git add spring-2027 index.qmd
   git commit -m "Freeze spring-2027"
   git push origin main
   quarto publish gh-pages
   ```

## Local preview

Double-click `preview.command`, or run:
```bash
quarto preview
```

## Deploy

The live site is served from the `gh-pages` branch via GitHub Pages. To deploy `main` after changes:
```bash
quarto publish gh-pages
```

`docs/` is gitignored. The local `quarto render` output never enters `main`; only `quarto publish gh-pages` updates the live site.

## Editing a past offering

Don't, as a rule. Past offerings are frozen by design. If a typo or factual error must be corrected, edit the static HTML in `spring-YYYY/` directly and note the correction in a visible spot, or open an issue and decide on a case-by-case basis. Re-rendering with newer Quarto/themes would break byte-identity, which defeats the purpose of pinning.
