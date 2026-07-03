# AI 协作工作流

本文档是跨 Codex、Claude Code、Zcode 等编码工具的共享工作协议。根入口保持短小，详细规则按需读取，核心目标是少加载、准定位、可迁移。

## 入口文件

| 文件 | 用途 |
|------|------|
| `AGENTS.md` | 共享根规则，所有工具优先遵循 |
| `*/AGENTS.md` | 目录级规则，只在目标目录相关时加载 |
| `CLAUDE.md` | Claude Code 兼容入口，转发到共享规则 |
| `.claude/memory/*.md` | 历史知识库，只按任务需要读取 |
| `ZeppOS-Knowledge/` | 统一外挂开发知识库子模块，官方快照 + 自有知识 + canonical 路由 + AI workflow/skill/tool |
| `.codex/` | 本地 Codex 配置，不作为共享规则 |

不要把同一份业务规则复制到多个工具私有配置里。需要更新长期规则时，优先改 `AGENTS.md` 或本目录。

## 任务分级

| 等级 | 适用任务 | 读取范围 |
|------|----------|----------|
| S | 单文件修复、文案、资源路径、小 UI 调整 | 目标文件 + 邻近配置 |
| M | 单项目功能、构建失败、页面联动 | 项目根配置 + 相关页面/工具模块 |
| L | 跨项目复用、迁移、架构整理、Git 归档 | `docs/project-index.md` + 精确搜索结果 |
| RE | 固件/隐藏 API/系统研究 | `ZeppOS-Knowledge/self-knowledge/re-summary.md` + 必要时 `ZeppOS_RE/AGENTS.md` 和对应研究文档 |

默认从 S 或 M 开始。只有证据显示需要更多上下文时再升级。

## 每个任务的启动顺序

1. 判断目标路径和项目类型。
2. 更新 `docs/vibe-coding/STATUS.md`，让用户看到当前任务、边界和下一步。
3. 读取根 `AGENTS.md` 和最近的目录级 `AGENTS.md`。
4. 读取目标项目的 `app.json`、`package.json` 或入口文件。
5. 需要 ZeppOS 知识或 AI workflow/tool 时，先读 `ZeppOS-Knowledge/indexes/routing.yaml` 和 `ZeppOS-Knowledge/indexes/README.md`；`docs/knowledge-map.yaml` 只作为本仓库 RE/项目文档 overlay。
6. 用 `rg` 精确搜索符号、页面名、appId、资源名。
7. 只打开命中的相关文件。
8. 编辑前更新 `STATUS.md` 的预计影响文件。
9. 修改后运行该项目最小可行验证。
10. 提交前执行知识回写检查：可复用结论写入 `ZeppOS-Knowledge/self-knowledge/` 或项目 `PROJECT.md`。
11. 验证和存档后更新 `STATUS.md` 并追加当日日志。

不要把“先全仓扫描”作为默认动作。

## Subagent 检索委派

文档搜索、案例查找、跨目录扫描默认视为上下文膨胀任务。若需要同时查 `ZeppOS-Knowledge/`、`ZeppOS_RE/docs/`、历史 `.claude/memory/` 或多个项目案例，主 agent 应优先分派 subagent/explorer 做只读检索，并继续处理不依赖该结果的本地工作。

委派规则见 `ZeppOS-Knowledge/ai-workflow/SUBAGENTS.md`。主 agent 保留最终判断、文件编辑、验证和 Git 存档责任；subagent 只返回中文证据包，包括结论摘要、已检查路径、关键证据、不确定点和建议主 agent 读取的最小文件集合。

没有 subagent 能力的工具仍按同一协议执行：先 `rg` 精确搜索，再只打开命中文件，并把结果压缩成证据包。

## 用户可见状态

用户固定阅读 `docs/vibe-coding/`：

| 文件 | 用途 |
|------|------|
| `README.md` | 说明如何观察 AI 运行态，并指向 canonical workflow |
| `STATUS.md` | 当前任务状态板 |
| `PROTOCOL.md` | 兼容入口，指向 `ZeppOS-Knowledge/ai-workflow/PROTOCOL.md` |
| `SUBAGENTS.md` | 兼容入口，指向 `ZeppOS-Knowledge/ai-workflow/SUBAGENTS.md` |
| `logs/YYYY-MM-DD.md` | 每日阶段日志 |

`STATUS.md` 需要回答：当前在做什么、影响范围是什么、下一步是什么、验证和存档状态是什么、哪些脏改动未纳入本轮。

## ZeppOS 知识读取策略

- 默认从 `ZeppOS-Knowledge/indexes/README.md` 和 `ZeppOS-Knowledge/indexes/routing.yaml` 路由。
- 手表端 API：`ZeppOS-Knowledge/official/docs/zeppos-docs/docs/reference/device-app-api/newAPI/`
- `app.json`：`ZeppOS-Knowledge/official/docs/zeppos-docs/docs/reference/app-json.mdx`
- 页面路由：`ZeppOS-Knowledge/official/docs/zeppos-docs/docs/guides/framework/device/router.md`
- 官方样例：`ZeppOS-Knowledge/official/samples/zeppos-samples/`
- 自有知识：`ZeppOS-Knowledge/self-knowledge/`
- `zeppos-docs/`、`zeppos-samples/` 默认不在根目录保留；需要更新快照时可临时拉取为更新源，不作为默认阅读入口。

## 历史知识读取策略

| 文件 | 何时读取 |
|------|----------|
| `.claude/memory/build-conventions.md` | Zeus 命令、设备 target、历史构建约定不确定时 |
| `.claude/memory/hidden-apis.md` | 隐藏 API、aiFlex、原生桥相关任务 |
| `.claude/memory/native-pages.md` | 原生 Screen 跳转任务 |
| `.claude/memory/project-glossary.md` | `docs/project-index.md` 不足以定位项目时 |

新沉淀的长期知识优先写入 `ZeppOS-Knowledge/self-knowledge/` 或项目 `PROJECT.md`。`.claude/memory/` 作为历史资料保留，不再作为唯一真源扩张。

## 用户发起任务的推荐格式

短任务：

```text
在 NormalApps/nearby-search 修复 <具体问题>，只改必要文件，验证 zeus build。
```

跨项目复用：

```text
把 SportsWidget/已提交/HealthRingsLite 的 <某逻辑> 参考迁移到 <目标项目>，先列相关文件再改。
```

Git 归档：

```text
把 <项目路径> 标记为已提交/已搁置，更新索引。
默认在验证后自动 commit 并 push；如果我写 no-commit 才不要提交。
```

自动存档开发：

```text
在 NormalApps/nearby-search 完成 <功能>。
每个构建通过的阶段自动 commit 并 push。
只提交本任务相关文件，不要包含已有脏改动；不能安全提交时主动提醒。
```

只本地存档不推送：

```text
在 <项目路径> 完成 <功能>。
auto-push: off。
阶段事件：构建通过、完成目录归档、完成子模块提交后 commit，但不要 push。
```

只修改不提交：

```text
在 <项目路径> 完成 <功能>。
no-commit：只改文件并验证，不要提交或推送。
```

RE 任务：

```text
在 ZeppOS_RE 中继续 <方向>，先读取对应研究文档，不扫描 firmware 全量目录。
```

## 工具迁移原则

- 共享约束放在仓库内的 `AGENTS.md`；可复用 workflow、skill 和工具脚本放在 `ZeppOS-Knowledge/ai-workflow/`。
- 工具私有目录只存本地状态、权限、MCP 配置或缓存。
- 切换工具时，只需要确认新工具会读取根规则；不会读取时，把 `AGENTS.md` 作为启动提示的一部分。
- 每次迁移后优先做一次小任务验证：读取目标项目、改一处低风险文件、运行项目级验证、检查 Git 状态。
