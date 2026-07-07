#!/usr/bin/env bash
set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$ROOT"

if [ -x "$HOME/.bun/bin/bun" ]; then
  export PATH="$HOME/.bun/bin:$PATH"
fi

check_cmd() {
  if command -v "$1" >/dev/null 2>&1; then
    printf "ok   %s: %s\n" "$1" "$(command -v "$1")"
  else
    printf "miss %s\n" "$1"
  fi
}

check_file() {
  if [ -e "$1" ]; then
    printf "ok   %s\n" "$1"
  else
    printf "miss %s\n" "$1"
  fi
}

printf "Career Planner doctor\n\n"
check_cmd git
check_cmd npm
check_cmd bun
check_cmd npx
check_cmd tectonic
check_cmd pdflatex
if [ -x /Library/TeX/texbin/pdflatex ]; then
  printf "ok   /Library/TeX/texbin/pdflatex\n"
fi

printf "\nGenerated skills\n"
check_file .codex/skills/info-retrieval/SKILL.md
check_file .codex/skills/career-compass/SKILL.md
check_file .codex/skills/finder/SKILL.md
check_file .codex/skills/alignment/SKILL.md
check_file .claude/skills/info-retrieval/SKILL.md
check_file .claude/skills/career-compass/SKILL.md
check_file .claude/skills/finder/SKILL.md
check_file .claude/skills/alignment/SKILL.md

printf "\nPrivacy ignores\n"
git check-ignore -v state/identity.md state/beliefs.md goal/goals.md action/BOARD.md .codex .claude .cursor .mcp.json .agents/drwn/card.lock || true
