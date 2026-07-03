# AI 协作工作流

本目录集中保存 ZeppOS 仓库 AI 协作所需的可复用 workflow、skill、工具脚本和验证入口。根仓库 `AGENTS.md`、`CLAUDE.md` 只保留约束和跳转；运行态状态板仍在宿主仓库 `docs/vibe-coding/STATUS.md` 与 `docs/vibe-coding/logs/`。

## 阅读顺序

| 文件 | 用途 |
|------|------|
| `ai-collaboration-workflow.md` | 跨 Codex、Claude Code、Zcode 的共享协作流程 |
| `PROTOCOL.md` | 用户可见状态板和日志规则 |
| `SUBAGENTS.md` | subagent/explorer 只读检索委派协议 |
| `git-archive-workflow.md` | 自动 commit/push、子模块和脏工作区分流规则 |
| `project-docs-guide.md` | 项目 `PROJECT.md` 写作和路由规则 |
| `skills/zeppos-vibe-coding/` | 可安装的 ZeppOS Vibe Coding skill 源文件、reference 和脚本 |

## 边界

- `docs/vibe-coding/` 是宿主仓库运行态驾驶舱，只保留 `STATUS.md`、日志和兼容跳转；不要把其中的兼容页当作 canonical workflow 来源。
- `ZeppOS-Knowledge/indexes/routing.yaml` 是 AI/脚本路由的 canonical 入口，包含本目录的 workflow/tool 路由。
- 本目录不保存单项目实现决策；这类内容写到目标项目 `PROJECT.md`。
- 官方 API、官方样例、推荐库和自有知识仍分别位于 `official/`、`community/`、`self-knowledge/` 与 `indexes/`。

## 安装副本

修改 `skills/zeppos-vibe-coding/` 后，同步到本机工具安装目录：

```powershell
$skill = "ZeppOS-Knowledge\ai-workflow\skills\zeppos-vibe-coding"
Copy-Item -Recurse -Force $skill (Join-Path $env:USERPROFILE ".codex\skills")
Copy-Item -Recurse -Force $skill (Join-Path $env:USERPROFILE ".agents\skills")
```

同步后至少运行：

```powershell
& ZeppOS-Knowledge\ai-workflow\skills\zeppos-vibe-coding\scripts\Route-ZeppOSDocs.ps1 -Query "app.json page"
& ZeppOS-Knowledge\ai-workflow\skills\zeppos-vibe-coding\scripts\Test-ZeppOSWorkflowConsolidation.ps1
```
