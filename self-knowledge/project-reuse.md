# 项目复用记录

本文件记录跨项目可复用的实现经验。单项目事实仍写在对应项目的 `PROJECT.md`。

## 写入格式

```markdown
### YYYY-MM-DD - 主题

- 结论类型:
- 来源项目:
- 可复用范围:
- 依赖文档:
- 推荐做法:
- 不适用场景:
```

### 2026-07-11 - MessageBuilder 大数据同步应使用紧凑传输层

- 结论类型: 跨项目通信与同步可靠性经验。
- 来源项目: `NormalApps/PaceStrategy` 真机同步；用户报告 4 条以上计划明显变慢、6 条计划超时，典型 6 条 10 km 完整 JSON 约 13.6 KB，需要 4 个 MessageBuilder 分片。
- 可复用范围: Device App 与 Side Service 之间通过官方样例 MessageBuilder 传输可增长的列表、分段记录或其他大 JSON 数据。
- 依赖文档: `official/samples/zeppos-samples/application/2.0/todo-list/shared/message*.js`、`official/libraries/zml/src/shared/message.js`。
- 推荐做法: 将落盘模型和传输模型分离；传输模型使用带版本号的紧凑字段/数组编码，接收端还原标准模型后重新计算 checksum 再落盘；请求超时按真实载荷留出余量；生产包关闭 MessageBuilder 的完整十六进制与 JSON 调试日志；轮询只读状态时不要重复写回未变化的大 payload；分片重组使用排序后一次 `Buffer.concat`，并在超时和错误路径移除监听器。
- 不适用场景: 始终小于单个 MessageBuilder payload、字段固定且无增长可能的短控制消息；这类消息保持普通 JSON 更易维护。
