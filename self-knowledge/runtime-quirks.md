# Runtime Quirks

本文件记录跨项目可复用的 ZeppOS 真机行为、UI 细节和 runtime 差异。它不是官方 API 文档；公共 API 仍以 `official/docs/zeppos-docs/` 为准。

## UI 与 Framework 行为

| 主题 | 结论 | 证据 | 范围 |
|------|------|------|------|
| `setTimeout` 延迟创建 widget | 在 `Page.build()` 内使用 `setTimeout(() => { createWidget(...) }, 1)` 延迟创建 widget，可在特定渲染负载下跳过页面侧滑入场动画。观察条件为至少 25 个不可见 circle 或 15 个不可见 button；`setScrollMode` 仍需在 timeout 前调用。 | 从历史 `.claude/memory/hidden-apis.md` 迁移；ZHAO 真机经验。 | 普通小程序 Page UI，结论类型：`true-device confirmed`。 |
| `SLIDE_SWITCH` 系统 fallback 图标 | 对 `widget.SLIDE_SWITCH`，完全省略 `select_bg`、`un_select_bg` 和 `slide_src` 可触发系统 fallback 开关图形；传空字符串不等价。该 fallback 仅确认用于 `SLIDE_SWITCH`，`CHECKBOX_GROUP` 和 `RADIO_GROUP` 仍需显式图片。新系统上 fallback 图形可能小且左上对齐，需读回 `w/h` 后手动对齐。 | ZHAO 真机测试，2026-06-28；从历史 memory 迁移。 | UI widget，结论类型：`true-device confirmed`。 |

## 新条目格式

```markdown
### YYYY-MM-DD - 标题

- 结论类型:
- 适用范围:
- 已验证设备/固件:
- 官方文档:
- 证据:
- 推荐做法:
- 限制与风险:
```
