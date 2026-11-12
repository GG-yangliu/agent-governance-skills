#!/bin/bash
# A/B self-test: run the same cases twice — without the skill, then with it.
# Usage:
#   SKILL_SRC=../<skill-repo> bash run_ab.sh
# Conventions:
#   cases/*.md      one case per file; within the first 5 lines, a line `skill: <skill-dir-name>`
#   SKILL_SRC       a directory containing <skill-name>/SKILL.md
# Output:
#   out/base_<tag>.txt / out/with_<tag>.txt
#
# The only variable is whether the skill file was read: everything else in the two
# prompts is identical. Point CLAUDE at a real executable, not a wrapper script.
set -u

CLAUDE="${CLAUDE:-claude}"
SKILL_SRC="${SKILL_SRC:?set SKILL_SRC=../<skill-repo>}"

cd "$(dirname "$0")" || exit 1
mkdir -p skills out

# 1) Copy the skills. A wrong path level fails silently, so fail loudly instead.
for f in "$SKILL_SRC"/*/SKILL.md; do
  [ -f "$f" ] || { echo "!! no */SKILL.md under $SKILL_SRC — check the SKILL_SRC level"; exit 1; }
  name=$(basename "$(dirname "$f")")
  cp "$f" "skills/$name.md" || { echo "!! copy failed: $name"; exit 1; }
done
n=$(ls -1 skills/*.md 2>/dev/null | wc -l)
echo "skills copied: $n"; ls -1 skills/ 2>/dev/null
[ "$n" -gt 0 ] || { echo "!! skills/ is empty — do not run the cases"; exit 1; }

# 2) Two runs per case
for c in cases/*.md; do
  [ -f "$c" ] || { echo "!! no cases under cases/"; exit 1; }
  tag=$(basename "$c" .md)
  sk=$(grep -m1 -E '^skill:[[:space:]]*' "$c" | sed -E 's/^skill:[[:space:]]*//' | tr -d '\r')
  if [ -z "$sk" ] || [ ! -f "skills/$sk.md" ]; then
    echo "!! [$tag] missing the skill: line, or skill $sk not found — skipped"
    continue
  fi
  echo "[$(date +%H:%M:%S)] base $tag"
  "$CLAUDE" -p "Read $c with the Read tool, then answer the question at the end of the file. Give the conclusion directly; tables and bullets are allowed." \
    --allowedTools "Read" > "out/base_$tag.txt" 2>&1
  echo "[$(date +%H:%M:%S)] with $tag ($sk)"
  "$CLAUDE" -p "First read skills/$sk.md with the Read tool (a skill file written for an AI agent), then read $c, then answer the question at the end of the file following that skill. Give the conclusion directly; tables and bullets are allowed." \
    --allowedTools "Read" > "out/with_$tag.txt" 2>&1
done

# 3) Invalid-run self-check
echo "== invalid-run check (anything listed here must be rerun, do not score it) =="
grep -l -E "could not read|unable to read|directory is empty|No such file|cannot read" out/*.txt 2>/dev/null || echo "none"
echo "done, outputs in out/"
