# AI 协作工作流

本目录集中保存 ZeppOS 仓库 AI 协作所需的可复用 workflow、skill、工具脚本、验证入口和运行态状态板。根仓库 `AGENTS.md`、`CLAUDE.md` 只保留启动约束；根仓库不再保留 `docs/`。

## 阅读顺序

| 文件 | 用途 |
|------|------|
| `ai-collaboration-workflow.md` | 跨 Codex、Claude Code、Zcode 的共享协作流程 |
| `PROTOCOL.md` | 用户可见状态板和日志规则 |
| `SUBAGENTS.md` | subagent/explorer 只读检索委派协议 |
| `git-archive-workflow.md` | 自动 commit/push、子模块和脏工作区分流规则 |
| `project-docs-guide.md` | 项目 `PROJECT.md` 写作和路由规则 |
| `status/` | 用户可见状态板和每日日志 |
| `skills/zeppos-vibe-coding/` | 可安装的 ZeppOS Vibe Coding skill 源文件、reference 和脚本 |

## 边界

- `status/` 是用户观察 AI 运行态的驾驶舱。
- `../monorepo/` 保存当前宿主仓库的项目索引和 overlay 路由；它不是单项目文档。
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
