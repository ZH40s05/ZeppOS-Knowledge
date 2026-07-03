# 知识路由

先使用 `ZeppOS-Knowledge/indexes/routing.yaml` 作为 ZeppOS 领域知识 canonical 路由表。`ZeppOS-Knowledge/monorepo/knowledge-map.yaml` 只作为当前 monorepo 的本地 overlay，用于项目文档、RE 原始证据链和历史 Claude memory。

如果路由需要搜索多个大型来源，或需要跨项目查找案例，先读取 `ZeppOS-Knowledge/ai-workflow/SUBAGENTS.md`。工具支持时，把检索任务分派给 subagent/explorer；subagent 应返回压缩证据包，不返回原始搜索输出。

## 来源类别

| 类别 | 用途 | 是否写入新结论 |
|------|---------|---------------------|
| `official` | 公开 SDK 行为、`app.json`、公开 API、设备列表、官方样例 | 否 |
| `self-knowledge` | 跨项目可复用的真机行为、框架经验、库经验、RE 开发摘要 | 是 |
| `project-docs` | 某个具体小程序/组件/库的决策 | 是 |
| `reverse-engineering` | 隐藏 API、原生页面、固件、sysprop、WiFi、可行性 | 是 |
| `historical-memory` | Claude memory 审计/迁移 | 否 |

## 回答纪律

回答 ZeppOS 能力/API 问题时，说明检查过哪些类别：

```text
已检查来源:
- official: <path or none>
- self-knowledge: <path or none>
- reverse engineering: <path or none>

结论类型: official / self-knowledge / true-device confirmed / RE confirmed / inferred / needs test
```

## 路由启发

- `app.json`、module、page、shortcut、config：先查官方 app-json。
- `@zos/*`、widget、sensor、storage、media、BLE：先查 `ZeppOS-Knowledge/official/docs/zeppos-docs/`；若真机行为不同，再查 `ZeppOS-Knowledge/self-knowledge/`。
- 官方样例：查 `ZeppOS-Knowledge/official/samples/zeppos-samples/`。
- 官方推荐库、社区库、自维护库：查 `ZeppOS-Knowledge/indexes/libraries.md`。
- `launchApp({ native: true })`、Screen 名称、map/POI：先查 `ZeppOS-Knowledge/self-knowledge/re-summary.md`，需要证据链时再查 RE 原生页面文档。
- `@zos/ai-flex`、`@zos/unsafe`、`NATIVE_*`、system/flex URI：先查 self-knowledge RE 摘要，需要证据链时再查 RE 隐藏 API。
- WiFi scan/connect/Blufi 可行性：先查 self-knowledge RE 摘要，需要证据链时再查 RE WiFi 文档。
- sysprop/HmZiplist/property hash：先查 self-knowledge RE 摘要，需要证据链时再查 RE sysprop reference。
- UI quirks、animation bypass、widget fallback assets：查 `ZeppOS-Knowledge/self-knowledge/runtime-quirks.md`。
- 项目特定 assets/pages/release 决策：查项目 `PROJECT.md`。
