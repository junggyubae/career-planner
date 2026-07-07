#!/usr/bin/env bash
set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$ROOT"

CARD_TAG="${CAREER_PLANNER_CARD_TAG:-v0.2.7}"
CARD_SOURCE="git+https://github.com/junggyubae/career-planner-card.git#${CARD_TAG}"

say() {
  printf "\n== %s ==\n" "$1"
}

warn() {
  printf "Warning: %s\n" "$1" >&2
}

die() {
  printf "Error: %s\n" "$1" >&2
  exit 1
}

have() {
  command -v "$1" >/dev/null 2>&1
}

try_install_base_tools() {
  if have npm && have git && have curl; then
    return 0
  fi

  if have brew; then
    brew install git node curl
  elif have apt-get && have sudo; then
    sudo apt-get update
    sudo apt-get install -y git curl nodejs npm ca-certificates unzip
  fi
}

ensure_bun() {
  if have bun; then
    return 0
  fi

  say "Installing Bun"
  if have brew; then
    brew install bun
  elif have curl; then
    curl -fsSL https://bun.sh/install | bash
    export PATH="$HOME/.bun/bin:$PATH"
  fi

  have bun || die "Bun is required by darwinian-minds. Install Bun, restart the shell, and rerun bootstrap."
}

run_drwn() {
  npx --yes --package darwinian-minds@latest drwn "$@"
}

say "Checking base tools"
try_install_base_tools
have git || die "git is required to update the card submodule."
have npm || die "Node.js/npm is required to run darwinian-minds via npx."
have curl || warn "curl is missing; Bun auto-install may fail if Bun is not already installed."

ensure_bun

say "Updating card submodule"
if [ -d .git ]; then
  git submodule update --init --recursive
else
  warn "No .git directory found; skipping submodule update."
fi

say "Materializing Career Planner skills"
run_drwn card clone --allow-untrusted-source "$CARD_SOURCE"
run_drwn write

say "Verifying skills"
for path in \
  .codex/skills/info-retrieval/SKILL.md \
  .codex/skills/career-compass/SKILL.md \
  .codex/skills/finder/SKILL.md \
  .codex/skills/alignment/SKILL.md \
  .claude/skills/info-retrieval/SKILL.md \
  .claude/skills/career-compass/SKILL.md \
  .claude/skills/finder/SKILL.md \
  .claude/skills/alignment/SKILL.md
do
  test -f "$path" || die "Missing generated skill: $path"
done

say "Checking optional PDF compiler"
if have tectonic; then
  tectonic --version | sed -n '1p'
elif have pdflatex; then
  pdflatex --version | sed -n '1p'
elif [ -x /Library/TeX/texbin/pdflatex ]; then
  /Library/TeX/texbin/pdflatex --version | sed -n '1p'
else
  warn "No PDF compiler found. This is okay for onboarding; install Tectonic later for local PDF builds."
fi

say "Done"
printf "Career Planner is ready. Start by uploading a CV, transcript, SOP, resume, or research statement in chat.\n"
