$ErrorActionPreference = "Continue"

$Root = Resolve-Path (Join-Path $PSScriptRoot "..")
Set-Location $Root

$BunBin = Join-Path $HOME ".bun\bin"
if (Test-Path (Join-Path $BunBin "bun.exe")) {
  $env:PATH = "$BunBin;$env:PATH"
}

function Check-Command($Command) {
  $Found = Get-Command $Command -ErrorAction SilentlyContinue
  if ($Found) {
    Write-Host "ok   $Command`: $($Found.Source)"
  } else {
    Write-Host "miss $Command"
  }
}

function Check-File($Path) {
  if (Test-Path $Path) {
    Write-Host "ok   $Path"
  } else {
    Write-Host "miss $Path"
  }
}

Write-Host "Career Planner doctor"
Write-Host ""
Check-Command git
Check-Command npm
Check-Command bun
Check-Command npx
Check-Command tectonic
Check-Command pdflatex

Write-Host ""
Write-Host "Generated skills"
Check-File ".codex/skills/info-retrieval/SKILL.md"
Check-File ".codex/skills/career-compass/SKILL.md"
Check-File ".codex/skills/finder/SKILL.md"
Check-File ".codex/skills/alignment/SKILL.md"
Check-File ".claude/skills/info-retrieval/SKILL.md"
Check-File ".claude/skills/career-compass/SKILL.md"
Check-File ".claude/skills/finder/SKILL.md"
Check-File ".claude/skills/alignment/SKILL.md"

Write-Host ""
Write-Host "Privacy ignores"
git check-ignore -v state/identity.md state/beliefs.md goal/goals.md action/BOARD.md .codex .claude .cursor .mcp.json .agents/drwn/card.lock
