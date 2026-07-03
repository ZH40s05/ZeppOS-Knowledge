param(
  [Parameter(Mandatory = $true)]
  [string]$Query,
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
$knowledgeMapPath = Join-Path $repo "ZeppOS-Knowledge\indexes\routing.yaml"
$overlayMapPath = Join-Path $repo "ZeppOS-Knowledge\monorepo\knowledge-map.yaml"

function Get-RoutePriority {
  param([string]$Class)

  switch ($Class) {
    "self-knowledge" { return 50 }
    "official" { return 45 }
    "official-library" { return 44 }
    "official-samples" { return 43 }
    "knowledge-index" { return 42 }
    "library-index" { return 41 }
    "community-library" { return 40 }
    "ai-workflow" { return 38 }
    "ai-skill" { return 37 }
    "project-docs" { return 30 }
    "reverse-engineering" { return 20 }
    "historical-memory" { return 10 }
    default { return 0 }
  }
}

function Convert-RoutePath {
  param(
    [string]$Path,
    [string]$Prefix
  )

  if (-not $Prefix) {
    return $Path
  }
  if ($Path -match '^(?:[A-Za-z]:|/|https?://|ZeppOS-Knowledge/|ZeppOS_RE/|\.claude/)') {
    return $Path
  }
  return ($Prefix.TrimEnd("/", "\") + "/" + $Path).Replace("\", "/")
}

function Read-RouteEntries {
  param(
    [string]$MapPath,
    [string]$PathPrefix
  )

  if (-not (Test-Path -LiteralPath $MapPath)) {
    return @()
  }

  $text = Get-Content -Raw -Encoding UTF8 -LiteralPath $MapPath
  $result = @()
  $blocks = [regex]::Split($text, "(?m)^\s*-\s+id:\s+")
  foreach ($block in $blocks | Select-Object -Skip 1) {
    $idLine, $rest = $block -split "`n", 2
    $id = $idLine.Trim()
    $path = ([regex]::Match($block, "(?m)^\s+path:\s+(.+)$")).Groups[1].Value.Trim()
    $class = ([regex]::Match($block, "(?m)^\s+class:\s+(.+)$")).Groups[1].Value.Trim()
    $topics = ([regex]::Match($block, "(?m)^\s+topics:\s+\[(.+)\]")).Groups[1].Value
    $when = ([regex]::Match($block, "(?m)^\s+when:\s+(.+)$")).Groups[1].Value.Trim()
    $score = 0
    foreach ($token in ($Query -split "[\s,，。:：/\\()]+")) {
      if (-not $token) { continue }
      if ($topics -match [regex]::Escape($token) -or $when -match [regex]::Escape($token) -or $id -match [regex]::Escape($token)) {
        $score += 1
      }
    }
    if ($score -gt 0) {
      $result += [pscustomobject]@{
        score = $score
        priority = Get-RoutePriority -Class $class
        id = $id
        class = $class
        path = Convert-RoutePath -Path $path -Prefix $PathPrefix
        topics = $topics
        when = $when
      }
    }
  }

  return $result
}

$entries = @()
$entries += Read-RouteEntries -MapPath $knowledgeMapPath -PathPrefix "ZeppOS-Knowledge"
$entries += Read-RouteEntries -MapPath $overlayMapPath -PathPrefix ""

if ($entries.Count -eq 0 -and -not (Test-Path -LiteralPath $knowledgeMapPath) -and -not (Test-Path -LiteralPath $overlayMapPath)) {
  throw "knowledge route maps not found: $knowledgeMapPath, $overlayMapPath"
}

if ($entries.Count -eq 0) {
  $fallback = @(
    [pscustomobject]@{ score = 0; id = "official-device-api"; class = "official"; path = "ZeppOS-Knowledge/official/docs/zeppos-docs/docs/reference/device-app-api/newAPI/"; topics = "api"; when = "fallback official API search" },
    [pscustomobject]@{ score = 0; id = "self-runtime-quirks"; class = "self-knowledge"; path = "ZeppOS-Knowledge/self-knowledge/runtime-quirks.md"; topics = "runtime"; when = "fallback self-knowledge reusable notes" }
  )
  $fallback | ConvertTo-Json -Depth 4
  exit 0
}

$entries |
  Sort-Object @{ Expression = "score"; Descending = $true }, @{ Expression = "priority"; Descending = $true } |
  Select-Object -First 8 score, id, class, path, topics, when |
  ConvertTo-Json -Depth 4
