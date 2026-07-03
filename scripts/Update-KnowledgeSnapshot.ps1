param(
  [Parameter(Mandatory = $true)]
  [string]$Id,
  [Parameter(Mandatory = $true)]
  [string]$Source,
  [Parameter(Mandatory = $true)]
  [string]$Destination,
  [string]$Title = "",
  [string]$Class = "external",
  [string]$License = "unknown",
  [ValidateSet("full-copy", "index-only")]
  [string]$Distribution = "full-copy",
  [string]$SourceUrl = ""
)

$ErrorActionPreference = "Stop"
$repo = Split-Path -Parent $PSScriptRoot
$manifest = Join-Path $repo "manifest\sources.yaml"
$date = Get-Date -Format "yyyy-MM-dd"
$tmp = $null

function Copy-Snapshot($sourcePath, $destPath) {
  New-Item -ItemType Directory -Force -Path (Split-Path -Parent $destPath) | Out-Null
  if (Test-Path -LiteralPath $destPath) {
    Remove-Item -LiteralPath $destPath -Recurse -Force
  }
  robocopy $sourcePath $destPath /E /XD .git node_modules dist build .docusaurus .cache /XF *.zpk | Out-Null
  if ($LASTEXITCODE -ge 8) {
    throw "robocopy failed: $sourcePath -> $destPath ($LASTEXITCODE)"
  }
  $global:LASTEXITCODE = 0
}

if ($Source -match '^https?://') {
  $tmpRoot = Join-Path $repo ".snapshot-tmp"
  New-Item -ItemType Directory -Force -Path $tmpRoot | Out-Null
  $tmp = Join-Path $tmpRoot $Id
  if (Test-Path -LiteralPath $tmp) {
    Remove-Item -LiteralPath $tmp -Recurse -Force
  }
  git clone --depth 1 $Source $tmp | Out-Null
  $sourcePath = $tmp
  if (-not $SourceUrl) { $SourceUrl = $Source }
} else {
  $sourcePath = (Resolve-Path -LiteralPath $Source).Path
  if (-not $SourceUrl) {
    try { $SourceUrl = git -C $sourcePath remote get-url origin } catch { $SourceUrl = $Source }
  }
}

$commit = ""
try { $commit = git -C $sourcePath rev-parse HEAD } catch { $commit = "unknown" }

if ($Distribution -eq "full-copy") {
  Copy-Snapshot $sourcePath (Join-Path $repo $Destination)
}

$block = @"
  - id: $Id
    class: $Class
    title: $Title
    source_url: $SourceUrl
    source_commit: $commit
    snapshot_date: $date
    license: $License
    distribution: $Distribution
    local_path: $Destination
"@

$text = Get-Content -Raw -Encoding UTF8 -LiteralPath $manifest
$pattern = "(?ms)^  - id: $([regex]::Escape($Id))\r?\n.*?(?=^  - id: |\z)"
if ([regex]::IsMatch($text, $pattern)) {
  $text = [regex]::Replace($text, $pattern, $block)
} else {
  $text = $text.TrimEnd() + "`n`n" + $block + "`n"
}
Set-Content -LiteralPath $manifest -Encoding UTF8 -Value $text

if ($tmp -and (Test-Path -LiteralPath $tmp)) {
  Remove-Item -LiteralPath $tmp -Recurse -Force
}

Write-Output "Updated snapshot: $Id -> $Destination"
