param(
  [string]$RepoRoot = "."
)

$ErrorActionPreference = "Stop"
$repo = (Resolve-Path -LiteralPath $RepoRoot).Path
$fail = New-Object System.Collections.Generic.List[string]
$pass = New-Object System.Collections.Generic.List[string]

function Test-PathRequired {
  param([string]$RelativePath)
  $full = Join-Path $repo $RelativePath
  if (Test-Path -LiteralPath $full) {
    $pass.Add("exists: $RelativePath")
  } else {
    $fail.Add("missing: $RelativePath")
  }
}

function Test-FileMentions {
  param(
    [string]$RelativePath,
    [string]$Pattern
  )
  $full = Join-Path $repo $RelativePath
  if (-not (Test-Path -LiteralPath $full)) {
    $fail.Add("missing: $RelativePath")
    return
  }
  $text = Get-Content -Raw -Encoding UTF8 -LiteralPath $full
  if ($text -match [regex]::Escape($Pattern)) {
    $pass.Add("bridge ok: $RelativePath -> $Pattern")
  } else {
    $fail.Add("canonical pointer missing: $RelativePath -> $Pattern")
  }
}

$required = @(
  "ZeppOS-Knowledge/ai-workflow/README.md",
  "ZeppOS-Knowledge/ai-workflow/PROTOCOL.md",
  "ZeppOS-Knowledge/ai-workflow/SUBAGENTS.md",
  "ZeppOS-Knowledge/ai-workflow/ai-collaboration-workflow.md",
  "ZeppOS-Knowledge/ai-workflow/git-archive-workflow.md",
  "ZeppOS-Knowledge/ai-workflow/project-docs-guide.md",
  "ZeppOS-Knowledge/ai-workflow/skills/zeppos-vibe-coding/SKILL.md",
  "ZeppOS-Knowledge/ai-workflow/skills/zeppos-vibe-coding/scripts/Route-ZeppOSDocs.ps1",
  "ZeppOS-Knowledge/ai-workflow/skills/zeppos-vibe-coding/scripts/Update-VibeCodingStatus.ps1"
)

foreach ($item in $required) { Test-PathRequired -RelativePath $item }

if (Test-Path -LiteralPath (Join-Path $repo "docs/vibe-coding/skills/zeppos-vibe-coding/SKILL.md")) {
  $fail.Add("old skill source still exists: docs/vibe-coding/skills/zeppos-vibe-coding/SKILL.md")
} else {
  $pass.Add("old skill source removed from docs/vibe-coding/skills/zeppos-vibe-coding/")
}

Test-FileMentions -RelativePath "docs/vibe-coding/PROTOCOL.md" -Pattern "ZeppOS-Knowledge/ai-workflow/PROTOCOL.md"
Test-FileMentions -RelativePath "docs/vibe-coding/SUBAGENTS.md" -Pattern "ZeppOS-Knowledge/ai-workflow/SUBAGENTS.md"
Test-FileMentions -RelativePath "docs/ai-collaboration-workflow.md" -Pattern "ZeppOS-Knowledge/ai-workflow/ai-collaboration-workflow.md"
Test-FileMentions -RelativePath "docs/git-archive-workflow.md" -Pattern "ZeppOS-Knowledge/ai-workflow/git-archive-workflow.md"
Test-FileMentions -RelativePath "docs/project-docs-guide.md" -Pattern "ZeppOS-Knowledge/ai-workflow/project-docs-guide.md"

foreach ($item in $pass) { Write-Output "[PASS] $item" }
foreach ($item in $fail) { Write-Output "[FAIL] $item" }

if ($fail.Count -gt 0) {
  exit 1
}
