# Vibe Coding 运行态

这里是用户观察 AI 编程工具当前状态的固定入口。根仓库不再保留 `docs/`；状态、日志、workflow、skill/tool 和知识索引都集中在 `ZeppOS-Knowledge/`。

## 阅读顺序

1. `STATUS.md` - 当前任务状态板。
2. `logs/` - 每日阶段日志。
3. `../README.md` - AI workflow、skill/tool 和验证入口。
4. `../../indexes/routing.yaml` - ZeppOS 知识、workflow、宿主 overlay 的 canonical 路由。
5. `../../monorepo/project-index.md` - 需要跨项目查找时使用的宿主项目索引。

## 规则

- AI 接受任务、确认边界、准备编辑、启动或接收 subagent、验证完成、commit/push 完成、遇到阻塞时更新 `STATUS.md`。
- 有实质阶段进展时追加 `logs/YYYY-MM-DD.md`。
- post-push 的最终状态可保留为本地实时状态，避免为了写提交号形成无限提交循环。
