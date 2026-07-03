param(
  [string]$RepoRoot = ".",
  [string]$Status = "进行中",
  [string]$Task = "",
  [string]$Scope = "",
  [string]$Reading = "",
  [string]$Editing = "",
  [string]$Next = "",
  [string]$Validation = "",
  [string]$Archive = "",
  [string]$Dirty = "",
  [string]$Log = "",
  [string]$StatusDir = ""
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
if ($StatusDir) {
  if ([System.IO.Path]::IsPathRooted($StatusDir)) {
    $dir = $StatusDir
  } else {
    $dir = Join-Path $repo $StatusDir
  }
} else {
  $dir = Join-Path $repo "ZeppOS-Knowledge\ai-workflow\status"
}
$logDir = Join-Path $dir "logs"
New-Item -ItemType Directory -Force $logDir | Out-Null

$now = Get-Date -Format "yyyy-MM-dd HH:mm zzz"
$statusPath = Join-Path $dir "STATUS.md"

$content = @"
# 当前 Vibe Coding 状态

- 状态: $Status
- 当前任务: $Task
- 工作目录: ``$repo``
- 任务边界: $Scope
- 正在读取: $Reading
- 正在修改: $Editing
- 下一步: $Next
- 验证: $Validation
- 存档: $Archive
- 未纳入本轮的脏改动: $Dirty
- 更新时间: $now
"@

Set-Content -LiteralPath $statusPath -Encoding UTF8 -Value $content

if ($Log) {
  $date = Get-Date -Format "yyyy-MM-dd"
  $logPath = Join-Path $logDir "$date.md"
  if (-not (Test-Path -LiteralPath $logPath)) {
    Set-Content -LiteralPath $logPath -Encoding UTF8 -Value "# $date Vibe Coding 日志`n"
  }
  Add-Content -LiteralPath $logPath -Encoding UTF8 -Value "`n## $now`n`n$Log"
}

Write-Output $statusPath
