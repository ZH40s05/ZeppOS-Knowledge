param(
  [string]$ProjectRoot = ".",
  [switch]$Force
)

$ErrorActionPreference = "Stop"
$root = (Resolve-Path -LiteralPath $ProjectRoot).Path
$target = Join-Path $root "PROJECT.md"
if ((Test-Path -LiteralPath $target) -and -not $Force) {
  Write-Output $target
  exit 0
}

$name = Split-Path -Leaf $root
$appId = ""
$type = ""
$appJson = Join-Path $root "app.json"
if (Test-Path -LiteralPath $appJson) {
  try {
    $app = Get-Content -Raw -Encoding UTF8 -LiteralPath $appJson | ConvertFrom-Json
    $appId = $app.app.appId
    if ($app.module.'data-widget') { $type = "SportsWidget data-widget" }
    elseif ($app.module.'secondary-widget') { $type = "SecondaryWidget" }
    elseif ($app.app.appType) { $type = "Normal app" }
  } catch {}
}

$content = @"
# $name Project Notes

## Scope

- Type: $type
- appId: $appId
- Status:
- Target devices:
- Entry files:

## Current Behavior

- Main user workflow:
- Important UI states:
- Data sources and permissions:

## Build And Verification

- Build command: ``zeus build``
- Preview / true-device notes:
- Known failing checks:

## Local Decisions

- Decision:
- Reason:
- Date:

## Dependencies And Reuse

- Shared code:
- Related projects:
- Reusable ZeppOS docs consumed:
- Knowledge conclusion type:

## Open Issues

- Issue:
- Evidence:
- Next action:
"@

Set-Content -LiteralPath $target -Encoding UTF8 -Value $content
Write-Output $target
