$ErrorActionPreference = "Stop"

$Root = Resolve-Path (Join-Path $PSScriptRoot "..")
Set-Location $Root

$CardTag = if ($env:CAREER_PLANNER_CARD_TAG) { $env:CAREER_PLANNER_CARD_TAG } else { "v0.2.7" }
$CardSource = "git+https://github.com/junggyubae/career-planner-card.git#$CardTag"

function Say($Message) {
  Write-Host ""
  Write-Host "== $Message =="
}

function Have($Command) {
  return $null -ne (Get-Command $Command -ErrorAction SilentlyContinue)
}

function Require($Command, $Message) {
  if (-not (Have $Command)) {
    throw $Message
  }
}

function Run-Drwn {
  param([Parameter(ValueFromRemainingArguments = $true)][string[]]$Args)
  & npx --yes --package darwinian-minds@latest drwn @Args
}

Say "Checking base tools"
if (-not (Have git) -and (Have winget)) {
  winget install -e --id Git.Git
}
if (-not (Have npm) -and (Have winget)) {
  winget install -e --id OpenJS.NodeJS.LTS
}

Require git "git is required to update the card submodule. Install Git, restart PowerShell, and rerun bootstrap."
Require npm "Node.js/npm is required to run darwinian-minds via npx. Install Node.js LTS, restart PowerShell, and rerun bootstrap."
Require npx "npx is required. It normally ships with npm."

if (-not (Have bun)) {
  Say "Installing Bun"
  powershell -c "irm bun.sh/install.ps1|iex"
  $BunBin = Join-Path $HOME ".bun\bin"
  $env:PATH = "$BunBin;$env:PATH"
}
Require bun "Bun is required by darwinian-minds. Restart PowerShell after installing Bun and rerun bootstrap."

Say "Updating card submodule"
if (Test-Path ".git") {
  git submodule update --init --recursive
} else {
  Write-Warning "No .git directory found; skipping submodule update."
}

Say "Materializing Career Planner skills"
Run-Drwn card clone --allow-untrusted-source $CardSource
Run-Drwn write

Say "Verifying skills"
$SkillPaths = @(
  ".codex/skills/info-retrieval/SKILL.md",
  ".codex/skills/career-compass/SKILL.md",
  ".codex/skills/finder/SKILL.md",
  ".codex/skills/alignment/SKILL.md",
  ".claude/skills/info-retrieval/SKILL.md",
  ".claude/skills/career-compass/SKILL.md",
  ".claude/skills/finder/SKILL.md",
  ".claude/skills/alignment/SKILL.md"
)
foreach ($Path in $SkillPaths) {
  if (-not (Test-Path $Path)) {
    throw "Missing generated skill: $Path"
  }
}

Say "Checking optional PDF compiler"
if (Have tectonic) {
  tectonic --version
} elseif (Have pdflatex) {
  pdflatex --version | Select-Object -First 1
} else {
  Write-Warning "No PDF compiler found. This is okay for onboarding; install Tectonic later for local PDF builds."
}

Say "Done"
Write-Host "Career Planner is ready. Start by uploading a CV, transcript, SOP, resume, or research statement in chat."
