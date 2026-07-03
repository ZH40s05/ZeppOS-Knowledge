param(
  [string]$Path = "."
)

$ErrorActionPreference = "Stop"

function Resolve-FullPath([string]$p) {
  return (Resolve-Path -LiteralPath $p).Path
}

function Find-Up([string]$start, [string]$name) {
  $dir = Get-Item -LiteralPath $start
  if (-not $dir.PSIsContainer) { $dir = $dir.Directory }
  while ($dir) {
    $candidate = Join-Path $dir.FullName $name
    if (Test-Path -LiteralPath $candidate) { return $candidate }
    $dir = $dir.Parent
  }
  return $null
}

$cwd = Resolve-FullPath $Path
$gitRoot = (& git -C $cwd rev-parse --show-toplevel 2>$null)
$repoRoot = $gitRoot
if ($gitRoot -match "\\ZeppOS_RE$|\\CustomTools$|\\Library\\Zepp-Adaptive-(Button|UI)$") {
  $repoRoot = (Resolve-Path -LiteralPath (Join-Path $gitRoot "..\..")).Path
  if ($gitRoot -match "\\CustomTools$|\\ZeppOS_RE$") {
    $repoRoot = (Resolve-Path -LiteralPath (Join-Path $gitRoot "..")).Path
  }
}

$appJson = Find-Up $cwd "app.json"
$projectRoot = $null
if ($appJson) { $projectRoot = Split-Path -Parent $appJson }
else {
  $packageJson = Find-Up $cwd "package.json"
  if ($packageJson) { $projectRoot = Split-Path -Parent $packageJson }
}
if ($projectRoot) {
  $projectPackage = Join-Path $projectRoot "package.json"
  if (Test-Path -LiteralPath $projectPackage) { $packageJson = $projectPackage } else { $packageJson = $null }
}

$appInfo = $null
if ($appJson) {
  try {
    $appInfo = Get-Content -Raw -Encoding UTF8 -LiteralPath $appJson | ConvertFrom-Json
  } catch {
    $appInfo = @{ parseError = $_.Exception.Message }
  }
}

$agents = @()
if ($repoRoot) {
  $rootAgent = Join-Path $repoRoot "AGENTS.md"
  if (Test-Path -LiteralPath $rootAgent) { $agents += $rootAgent }
}
if ($projectRoot) {
  $repoRootFull = (Resolve-Path -LiteralPath $repoRoot).Path
  $dir = Get-Item -LiteralPath $projectRoot
  while ($dir -and $repoRootFull -and $dir.FullName.StartsWith($repoRootFull)) {
    $agent = Join-Path $dir.FullName "AGENTS.md"
    if ((Test-Path -LiteralPath $agent) -and ($agents -notcontains $agent)) { $agents += $agent }
    if ($dir.FullName -eq $repoRootFull) { break }
    $dir = $dir.Parent
  }
}

$result = [ordered]@{
  cwd = $cwd
  gitRoot = $gitRoot
  repoRoot = $repoRoot
  isSubmodule = ($gitRoot -ne $repoRoot)
  projectRoot = $projectRoot
  appJson = $appJson
  packageJson = $packageJson
  agents = $agents
  app = $appInfo
}

$result | ConvertTo-Json -Depth 10
