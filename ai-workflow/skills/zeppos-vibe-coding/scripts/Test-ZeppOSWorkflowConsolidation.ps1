param(
  [string]$RepoRoot = "."
)

$ErrorActionPreference = "Stop"
function Resolve-ZeppOSRepoRoot([string]$StartPath) {
  $resolved = (Resolve-Path -LiteralPath $StartPath).Path
  $item = Get-Item -LiteralPath $resolved
  if (-not $item.PSIsContainer) { $item = $item.Directory }
  $dir = $item
  while ($dir) {
    if (Test-Path -LiteralPath (Join-Path $dir.FullName "ZeppOS-Knowledge\indexes\routing.yaml")) {
      return $dir.FullName
    }
    $dir = $dir.Parent
  }
  return $resolved
}

$repo = Resolve-ZeppOSRepoRoot -StartPath $RepoRoot
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
  "ZeppOS-Knowledge/ai-workflow/status/STATUS.md",
  "ZeppOS-Knowledge/monorepo/knowledge-map.yaml",
  "ZeppOS-Knowledge/monorepo/project-index.md",
  "ZeppOS-Knowledge/ai-workflow/skills/zeppos-vibe-coding/SKILL.md",
  "ZeppOS-Knowledge/ai-workflow/skills/zeppos-vibe-coding/scripts/Route-ZeppOSDocs.ps1",
  "ZeppOS-Knowledge/ai-workflow/skills/zeppos-vibe-coding/scripts/Update-VibeCodingStatus.ps1"
)

foreach ($item in $required) { Test-PathRequired -RelativePath $item }

if (Test-Path -LiteralPath (Join-Path $repo "docs")) {
  $fail.Add("root docs directory still exists")
} else {
  $pass.Add("root docs directory removed")
}

Test-FileMentions -RelativePath "AGENTS.md" -Pattern "ZeppOS-Knowledge/ai-workflow/status/STATUS.md"
Test-FileMentions -RelativePath "AGENTS.md" -Pattern "ZeppOS-Knowledge/monorepo/project-index.md"
Test-FileMentions -RelativePath "ZeppOS-Knowledge/ai-workflow/PROTOCOL.md" -Pattern "ZeppOS-Knowledge/ai-workflow/status/STATUS.md"
Test-FileMentions -RelativePath "ZeppOS-Knowledge/ai-workflow/ai-collaboration-workflow.md" -Pattern "ZeppOS-Knowledge/monorepo/project-index.md"
Test-FileMentions -RelativePath "ZeppOS-Knowledge/ai-workflow/skills/zeppos-vibe-coding/scripts/Route-ZeppOSDocs.ps1" -Pattern "ZeppOS-Knowledge\monorepo\knowledge-map.yaml"

foreach ($item in $pass) { Write-Output "[PASS] $item" }
foreach ($item in $fail) { Write-Output "[FAIL] $item" }

if ($fail.Count -gt 0) {
  exit 1
}
