param(
  [Parameter(Mandatory = $true)]
  [string]$Summary,
  [string]$Topic = "runtime",
  [string]$Evidence = "",
  [string]$Devices = "",
  [string]$OfficialDocs = "",
  [string]$Impact = "",
  [string]$RepoRoot = ".",
  [string]$TargetDoc = ""
)

$ErrorActionPreference = "Stop"
$repo = (Resolve-Path -LiteralPath $RepoRoot).Path

if (-not $TargetDoc) {
  switch -Regex ($Topic) {
    "ai|flex|unsafe|hidden|NATIVE|speech|tts|stt|screen|native|launchApp|map|poi|shortcut|wifi|wlan|blufi|network|sysprop|hmziplist|property|hash|hardware|soc|chip|hid|ble" {
      $TargetDoc = "ZeppOS-Knowledge/self-knowledge/re-summary.md"
      break
    }
    "library|zml|zeppos-fx|fx|adaptive|zaui|zabt" {
      $TargetDoc = "ZeppOS-Knowledge/self-knowledge/libraries.md"
      break
    }
    "project|reuse|shared|pattern" {
      $TargetDoc = "ZeppOS-Knowledge/self-knowledge/project-reuse.md"
      break
    }
    default { $TargetDoc = "ZeppOS-Knowledge/self-knowledge/runtime-quirks.md" }
  }
}

$path = Join-Path $repo $TargetDoc
if (-not (Test-Path -LiteralPath $path)) {
  throw "target doc not found: $path"
}

$date = Get-Date -Format "yyyy-MM-dd"
$entry = @"

### $date - $Summary

- 分类: $Topic
- 设备 / 固件: $Devices
- 已核对官方 / 自有知识: $OfficialDocs
- 证据: $Evidence
- 可复用结论: $Summary
- 项目影响: $Impact
"@

Add-Content -LiteralPath $path -Encoding UTF8 -Value $entry
Write-Output $path
