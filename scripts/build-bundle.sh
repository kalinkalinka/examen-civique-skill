#!/usr/bin/env bash
# Build the single-file skill bundle by concatenating SKILL.md + references/.
# Usage: ./scripts/build-bundle.sh
# Output: dist/skill-bundle.md

set -euo pipefail

REPO_ROOT="$(cd "$(dirname "$0")/.." && pwd)"
cd "$REPO_ROOT"

mkdir -p dist

{
  cat SKILL.md
  echo ""
  echo ""
  echo "---"
  echo ""
  echo "# Appendix A: Question bank"
  echo ""
  echo "*(Contents of \`references/questions.md\`. The skill instructs Claude to treat this section as if it were the file referenced in SKILL.md.)*"
  echo ""
  cat references/questions.md
  echo ""
  echo ""
  echo "---"
  echo ""
  echo "# Appendix B: Scenario guidance"
  echo ""
  echo "*(Contents of \`references/scenarios.md\`. The skill instructs Claude to treat this section as if it were the file referenced in SKILL.md.)*"
  echo ""
  cat references/scenarios.md
} > dist/skill-bundle.md

LINES=$(wc -l < dist/skill-bundle.md)
BYTES=$(wc -c < dist/skill-bundle.md)
echo "Built dist/skill-bundle.md"
echo "  $LINES lines, $BYTES bytes"
