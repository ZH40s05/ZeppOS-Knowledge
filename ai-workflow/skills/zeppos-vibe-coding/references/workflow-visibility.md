# 工作流可见化

通过 `ZeppOS-Knowledge/ai-workflow/status/` 让用户用中文看到 AI 当前在做什么、下一步做什么、准备修改和存档什么。

## 必备文件

- `ZeppOS-Knowledge/ai-workflow/status/README.md`: 用户入口。
- `ZeppOS-Knowledge/ai-workflow/status/STATUS.md`: 当前任务状态板。
- `ZeppOS-Knowledge/ai-workflow/PROTOCOL.md`: 可见化协议。
- `ZeppOS-Knowledge/ai-workflow/SUBAGENTS.md`: subagent 检索委派协议。
- `ZeppOS-Knowledge/ai-workflow/status/logs/YYYY-MM-DD.md`: 每日阶段日志。

## 必须更新的节点

在这些节点更新 `STATUS.md`：

1. 接受任务后，开始大范围读取前。
2. 确认任务边界后。
3. 启动或接收 subagent/explorer 检索任务时。
4. 编辑文件前，写明预计影响文件。
5. 验证完成后。
6. commit/push 完成后。
7. 阻塞或等待用户输入时。

阶段完成时追加当日日志。

面向用户的内容使用中文。命令、路径、API 标识保持原文。

优先使用本 skill 的 `scripts/Update-VibeCodingStatus.ps1`；在仓库内也可运行 canonical 副本 `ZeppOS-Knowledge/ai-workflow/skills/zeppos-vibe-coding/scripts/Update-VibeCodingStatus.ps1`。手动编辑更清晰时也可以。
