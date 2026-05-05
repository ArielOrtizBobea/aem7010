#!/bin/bash
# freeze-semester.sh - Render a per-semester branch and freeze the output as a
# static snapshot in main, served at /aem7010/<semester>/ forever.
#
# Usage:
#   ./freeze-semester.sh spring-2027
#
# Preconditions:
#   - Run from the root of the aem7010 repo
#   - Currently on branch `main`
#   - Working tree clean
#   - A branch named like the argument exists (locally or on origin)
#   - Quarto is installed and on PATH
#
# What it does:
#   1. Creates a temporary git worktree at the named branch
#   2. Runs `quarto render` inside the worktree
#   3. Copies the rendered output into main:/<semester>/
#   4. Removes the worktree
#   5. Prints next-steps reminder
#
# It does NOT:
#   - Edit index.qmd's offerings list (the label and dates are judgment calls)
#   - Commit, push, or publish
#
# Design note: this script copies a static snapshot. The byte-identical
# guarantee is the whole point of the per-semester URL convention.
# See docs in README.md.

set -euo pipefail

if [ $# -ne 1 ]; then
  echo "Usage: $0 <semester-slug>" >&2
  echo "Example: $0 spring-2027" >&2
  exit 1
fi

SEMESTER="$1"

# Validate slug shape
if ! [[ "$SEMESTER" =~ ^(spring|summer|fall|winter)-[0-9]{4}$ ]]; then
  echo "Error: semester slug must look like 'spring-2027' (season-YYYY)." >&2
  exit 1
fi

# Verify we are in the repo root
if [ ! -f _quarto.yml ] || [ ! -d .git ]; then
  echo "Error: must be run from the aem7010 repo root." >&2
  exit 1
fi

# Verify on main
CURRENT_BRANCH=$(git rev-parse --abbrev-ref HEAD)
if [ "$CURRENT_BRANCH" != "main" ]; then
  echo "Error: must be on 'main' branch (currently on '$CURRENT_BRANCH')." >&2
  exit 1
fi

# Verify clean tree
if ! git diff --quiet || ! git diff --cached --quiet; then
  echo "Error: working tree is not clean. Commit or stash first." >&2
  exit 1
fi

# Verify the branch exists somewhere
if ! git show-ref --verify --quiet "refs/heads/$SEMESTER" \
   && ! git show-ref --verify --quiet "refs/remotes/origin/$SEMESTER"; then
  echo "Error: no branch named '$SEMESTER' exists locally or on origin." >&2
  echo "Hint: push the per-semester branch first, e.g.:" >&2
  echo "        git push origin refs/heads/$SEMESTER:refs/heads/$SEMESTER" >&2
  exit 1
fi

# Verify quarto present
if ! command -v quarto >/dev/null 2>&1; then
  echo "Error: quarto is not installed or not on PATH." >&2
  exit 1
fi

WORKTREE_DIR="/tmp/aem7010-freeze-${SEMESTER}-$$"
TARGET_DIR="$SEMESTER"

cleanup() {
  if [ -d "$WORKTREE_DIR" ]; then
    echo "==> Cleaning up worktree at $WORKTREE_DIR"
    git worktree remove --force "$WORKTREE_DIR" 2>/dev/null || rm -rf "$WORKTREE_DIR"
  fi
}
trap cleanup EXIT

echo "==> Adding worktree for '$SEMESTER' at $WORKTREE_DIR"
git worktree add "$WORKTREE_DIR" "$SEMESTER"

echo "==> Rendering with Quarto in $WORKTREE_DIR"
( cd "$WORKTREE_DIR" && quarto render )

# Locate the render output. Quarto's project output-dir defaults to _site
# but the aem7010 convention uses docs.
RENDERED=""
for candidate in docs _site; do
  if [ -d "$WORKTREE_DIR/$candidate" ]; then
    RENDERED="$WORKTREE_DIR/$candidate"
    break
  fi
done
if [ -z "$RENDERED" ]; then
  echo "Error: no rendered output found in $WORKTREE_DIR (looked for docs/, _site/)." >&2
  exit 1
fi

echo "==> Copying $RENDERED -> $TARGET_DIR"
if [ -d "$TARGET_DIR" ]; then
  echo "    Note: $TARGET_DIR already exists. Removing before copy."
  rm -rf "$TARGET_DIR"
fi
cp -R "$RENDERED" "$TARGET_DIR"

cat <<EOF

==> Freeze complete: $TARGET_DIR/

Next steps (manual):
  1. Inspect the snapshot in your browser:
       open $TARGET_DIR/index.html
  2. Edit index.qmd to add a new offering entry at the top.
     Demote the previous "Most recent" badge to "Frozen".
  3. Commit and push:
       git add $TARGET_DIR index.qmd
       git commit -m "Freeze $SEMESTER"
       git push origin main
  4. Publish to gh-pages:
       quarto publish gh-pages

EOF
