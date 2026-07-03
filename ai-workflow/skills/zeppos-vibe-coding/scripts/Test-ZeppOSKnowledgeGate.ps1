param(
  [string]$RepoRoot = ".",
  [string[]]$ChangedFiles = @(),
  [switch]$Staged
)

$ErrorActionPreference = "Stop"
$repo = (Resolve-Path -LiteralPath $RepoRoot).Path

if (-not $ChangedFiles -or $ChangedFiles.Count -eq 0) {
  Push-Location $repo
  try {
    if ($Staged) {
      $ChangedFiles = @(git diff --name-only --cached)
    } else {
      $ChangedFiles = @(git diff --name-only)
    }
  } finally {
    Pop-Location
  }
}

$ChangedFiles = @($ChangedFiles | Where-Object { $_ -and $_.Trim() })
$fail = New-Object System.Collections.Generic.List[string]
$warn = New-Object System.Collections.Generic.List[string]
$pass = New-Object System.Collections.Generic.List[string]

function Test-AnyChanged {
  param([string]$Pattern)
  return @($ChangedFiles | Where-Object { $_ -match $Pattern }).Count -gt 0
}

function Get-ProjectRootForFile {
  param([string]$RelativePath)

  if ($RelativePath -match '^NormalApps/其它开发者/') {
    return $null
  }
  if ($RelativePath -notmatch '^(NormalApps|SecondaryWidget|SportsWidget)/') {
    return $null
  }

  $fullPath = Join-Path $repo $RelativePath
  if (Test-Path -LiteralPath $fullPath -PathType Container) {
    $dir = $fullPath
  } else {
    $dir = Split-Path -Parent $fullPath
  }

  while ($dir -and $dir.StartsWith($repo, [System.StringComparison]::OrdinalIgnoreCase)) {
    if (Test-Path -LiteralPath (Join-Path $dir "app.json")) {
      return $dir
    }
    if ($dir -eq $repo) {
      break
    }
    $dir = Split-Path -Parent $dir
  }

  return $null
}

$hasReDocs = Test-AnyChanged '^ZeppOS_RE/docs/'
$hasSelfKnowledge = Test-AnyChanged '^ZeppOS-Knowledge/self-knowledge/'
$hasKnowledgeSnapshot = Test-AnyChanged '^ZeppOS-Knowledge/(official|community)/(docs|samples|libraries)/'
$hasManifest = Test-AnyChanged '^ZeppOS-Knowledge/manifest/sources\.yaml$'
$hasIndexes = Test-AnyChanged '^ZeppOS-Knowledge/indexes/'

if ($hasReDocs -and -not $hasSelfKnowledge) {
  $fail.Add("检测到 ZeppOS_RE/docs/ 有研究文档变更，但没有同步 ZeppOS-Knowledge/self-knowledge/ 的可消费中文摘要。")
}

if ($hasKnowledgeSnapshot -and -not $hasManifest) {
  $fail.Add("检测到 ZeppOS-Knowledge 官方/社区快照变更，但没有同步 manifest/sources.yaml。")
}

if ($hasSelfKnowledge -and -not $hasIndexes) {
  $warn.Add("检测到自有知识变更；请确认 ZeppOS-Knowledge/indexes/ 中的中文索引是否需要同步。")
}

$projectRoots = @()
foreach ($file in $ChangedFiles) {
  $root = Get-ProjectRootForFile -RelativePath $file
  if ($root) {
    $projectRoots += $root
  }
}

$projectRoots = @($projectRoots | Sort-Object -Unique)
foreach ($projectRoot in $projectRoots) {
  if (-not (Test-Path -LiteralPath (Join-Path $projectRoot "PROJECT.md"))) {
    $relative = Resolve-Path -LiteralPath $projectRoot -Relative
    $warn.Add("项目 $relative 尚无 PROJECT.md；若本轮消费了知识库条目，请补充项目级记录。")
  }
}

if ($fail.Count -eq 0 -and $warn.Count -eq 0) {
  $pass.Add("知识回写 gate 通过。")
}

foreach ($item in $pass) { Write-Output "[PASS] $item" }
foreach ($item in $warn) { Write-Output "[WARN] $item" }
foreach ($item in $fail) { Write-Output "[FAIL] $item" }

if ($fail.Count -gt 0) {
  exit 1
}
