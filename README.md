# ZeppOS 开发知识库

这是一个面向 ZeppOS 开发者和 AI 编码工具的离线知识库快照，统一收纳官方文档、官方样例、官方推荐库、权威社区库索引和 ZHAO 维护的中文自有知识。

## 阅读入口

| 入口 | 内容 |
|------|------|
| `indexes/README.md` | 中文分类索引 |
| `indexes/routing.yaml` | AI/脚本使用的 canonical 路由表 |
| `CONTRIBUTING.md` | 知识消费、回写和快照维护规则 |
| `official/docs/zeppos-docs/` | ZeppOS 官方文档快照 |
| `official/samples/zeppos-samples/` | ZeppOS 官方样例快照 |
| `official/libraries/` | 许可证明确的官方推荐库快照 |
| `community/libraries/` | 许可证明确的社区库快照 |
| `self-knowledge/` | ZHAO 维护的中文自有知识 |
| `ai-workflow/` | AI 协作 workflow、skill 源文件、工具脚本和验证入口 |
| `ai-workflow/status/` | 用户可见运行态状态板和每日日志 |
| `monorepo/` | 当前宿主仓库的项目索引和 overlay 路由 |
| `manifest/sources.yaml` | 快照来源、commit、许可证和本地路径 |

## 使用原则

- 官方文档和官方样例是权威来源，只引用，不直接修改。
- 第三方库只有在许可证允许再分发时才完整快照；否则只在索引中记录来源。
- 自有知识用于记录官方文档未覆盖、真机验证、RE 摘要和跨项目经验。
- RE 原始证据链仍以 `ZeppOS_RE/docs/` 为准；本知识库只保存面向开发者的摘要。
- 更新快照时必须同步更新 `manifest/sources.yaml` 和相关中文索引。

## AI 路由建议

优先从 `indexes/README.md`、`indexes/routing.yaml` 和 `manifest/sources.yaml` 判断来源类别，再读取最小必要文件：

1. 官方 API、`app.json`、设备列表：读 `official/docs/zeppos-docs/`。
2. 示例工程：读 `official/samples/zeppos-samples/`。
3. 通信、BLE、存储、绘图等库：先读 `indexes/libraries.md`。
4. 真机差异和 runtime quirks：读 `self-knowledge/runtime-quirks.md`。
5. RE 结论的开发使用方式：读 `self-knowledge/re-summary.md`。
6. AI 协作、subagent、自动 Git、skill/tool 脚本：读 `ai-workflow/README.md`。
7. 当前任务状态：读 `ai-workflow/status/STATUS.md`。
8. 跨项目索引或宿主 overlay：读 `monorepo/README.md`。
