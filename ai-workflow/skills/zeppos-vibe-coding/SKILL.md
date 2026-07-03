---
name: zeppos-vibe-coding
description: ZeppOS monorepo and miniapp/widget/library/RE development workflow. Use whenever Codex works in ZHAO's ZeppOS repository, edits ZeppOS app.json/page/widget code, needs ZeppOS-Knowledge official docs/samples/libraries/self-knowledge routing, project docs, subagent/explorer delegation for large doc or case searches, new finding capture, Zeus build/preview, or automatic Git archive/push behavior.
---

# ZeppOS Vibe Coding

在 `C:\Users\Cafero\OneDrive - ZHAO\ZeppOS` 或其子项目工作时使用本 skill。目标是保持主上下文窄、知识路由明确、用户可见、阶段验证后自动存档。

## 快速启动

1. 大范围读取前，用中文更新 `ZeppOS-Knowledge/ai-workflow/status/STATUS.md`。优先使用本 skill 的 `scripts/Update-VibeCodingStatus.ps1`；在仓库内也可运行 canonical 副本 `ZeppOS-Knowledge/ai-workflow/skills/zeppos-vibe-coding/scripts/Update-VibeCodingStatus.ps1`。
2. 从当前目录运行本 skill 的 `scripts/Get-ZeppOSContext.ps1`。
3. 读取返回的根 `AGENTS.md` 和最近的项目级 `AGENTS.md`。
4. 若需要 API/行为知识，运行本 skill 的 `scripts/Route-ZeppOSDocs.ps1 -Query "<question>"`，默认路由到 `ZeppOS-Knowledge/`。
5. 若检索会跨官方快照、自有知识、RE 文档、历史 memory 或多个项目案例，先读 `ZeppOS-Knowledge/ai-workflow/SUBAGENTS.md`，优先分派 subagent/explorer 做只读证据包。
6. 主 agent 只读取路由后真正需要的官方/自有/项目文档。
7. 编辑文件前，在 `STATUS.md` 写明预计影响文件和下一步。
8. 发现可复用新结论时，用本 skill 的 `scripts/Record-ZeppOSFinding.ps1` 记录到 `ZeppOS-Knowledge/self-knowledge/`，或直接编辑路由到的文档。
9. 项目特定上下文变化时，用本 skill 的 `scripts/New-ZeppOSProjectDoc.ps1` 创建/更新项目 `PROJECT.md`。
10. 验证和存档后，更新 `STATUS.md` 并追加 `ZeppOS-Knowledge/ai-workflow/status/logs/YYYY-MM-DD.md`。
11. 阶段验证完成后，默认精确 commit 并 push，除非用户说 `no-commit` 或 `auto-push: off`。

## 用户可见工作流

实质性工作前读取 `references/workflow-visibility.md`。用户固定中文驾驶舱是 `ZeppOS-Knowledge/ai-workflow/status/STATUS.md` 和 `ZeppOS-Knowledge/ai-workflow/status/logs/`；完整 workflow、subagent 协议和 skill/tool 源文件以 `ZeppOS-Knowledge/ai-workflow/` 为准。

当搜索资料或查找案例会膨胀上下文时，读取仓库内 `ZeppOS-Knowledge/ai-workflow/SUBAGENTS.md`，让 subagent/explorer 返回中文证据包；主 agent 保留最终判断、编辑、验证和 Git 存档责任。

涉及知识消费或回写时，读取 `ZeppOS-Knowledge/CONTRIBUTING.md`。提交前必须说明本轮是否产生可复用 ZeppOS 知识，以及是否已写入 `ZeppOS-Knowledge/self-knowledge/` 或项目 `PROJECT.md`。

## 知识路由

当任务涉及 API 支持、可行性、隐藏 API、UI/runtime quirks、官方文档、官方样例、库、自有知识、RE 结论，或不确定知识应读写到哪里时，读取 `references/knowledge-routing.md`。

不要把新发现写入 `.claude/memory/`。Claude memory 只作为迁移输入。

## 结论沉淀

记录新结论前读取 `references/self-knowledge-writeback.md`。按范围路由：

- 官方 SDK 行为：引用 `ZeppOS-Knowledge/official/docs/zeppos-docs/`，不编辑官方快照。
- 可复用自有知识：`ZeppOS-Knowledge/self-knowledge/`。
- 隐藏 API、原生 Screen、固件、sysprop、WiFi、可行性：原始证据写 `ZeppOS_RE/docs/`，开发摘要写 `ZeppOS-Knowledge/self-knowledge/re-summary.md`。
- 单项目决策：项目 `PROJECT.md`。

## 项目文档

开始新的小程序/组件/库任务、创建项目文档，或发现能节省未来上下文的项目特定决策时，读取 `references/project-docs.md`。项目文档不是可复用 ZeppOS 知识库。

## 构建与存档

优先遵循仓库规则。关键默认值：

- `zeus build` 在具体项目目录内运行。
- `zeus preview` 是交互式命令，没有 `--target`。
- 使用精确的 `git add -- <files>`。
- 阶段验证完成后默认 commit 并 push。
- 子模块先在子模块内 commit/push，再回根仓库提交指针；`ZeppOS-Knowledge/` 也按子模块处理。

commit/push、脏工作区分流或子模块同步前，读取 `references/git-archive.md`。
