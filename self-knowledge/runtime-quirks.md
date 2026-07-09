# Runtime Quirks

本文件记录跨项目可复用的 ZeppOS 真机行为、UI 细节和 runtime 差异。它不是官方 API 文档；公共 API 仍以 `official/docs/zeppos-docs/` 为准。

## UI 与 Framework 行为

| 主题 | 结论 | 证据 | 范围 |
|------|------|------|------|
| `setTimeout` 延迟创建 widget | 在 `Page.build()` 内使用 `setTimeout(() => { createWidget(...) }, 1)` 延迟创建 widget，可在特定渲染负载下跳过页面侧滑入场动画。观察条件为至少 25 个不可见 circle 或 15 个不可见 button；`setScrollMode` 仍需在 timeout 前调用。 | 从历史 `.claude/memory/hidden-apis.md` 迁移；ZHAO 真机经验。 | 普通小程序 Page UI，结论类型：`true-device confirmed`。 |
| `SLIDE_SWITCH` 系统 fallback 图标 | 对 `widget.SLIDE_SWITCH`，完全省略 `select_bg`、`un_select_bg` 和 `slide_src` 可触发系统 fallback 开关图形；传空字符串不等价。该 fallback 仅确认用于 `SLIDE_SWITCH`，`CHECKBOX_GROUP` 和 `RADIO_GROUP` 仍需显式图片。新系统上 fallback 图形可能小且左上对齐，需读回 `w/h` 后手动对齐。 | ZHAO 真机测试，2026-06-28；从历史 memory 迁移。 | UI widget，结论类型：`true-device confirmed`。 |

### 2026-07-10 - `createModal` 确认交互优先放在独立 Page

- 结论类型: `true-device confirmed`
- 适用范围: 普通小程序中由列表页、按键代理或自定义焦点系统触发的 `createModal` 确认/警告页。
- 已验证设备/固件: ZHAO PaceStrategy 实机反馈；nearby-search 已采用独立说明页模式。
- 官方文档: 未见官方明确说明；这是实机交互经验。
- 证据: PaceStrategy 在原列表页直接弹同步确认 modal 时，可能与列表/应用按键监听争抢；nearby-search 通过 `page/about`、`page/hide_info` 独立页面承载 modal，可隔离原页面按键监听。独立 modal 页在用户确认或取消后如果先执行 `modal.show(false)`，页面本身没有其他内容，会短暂露出空白黑屏。
- 推荐做法: 需要确认用户操作时，从原页面 `push` 到独立确认页，让确认页在 `build()` 中创建并显示 `createModal`；确认/取消回调里直接执行 `back()`、`exit()` 或 `replace()` 等导航，不要在跳转前主动隐藏 modal。若原页面使用 zolist 等自定义按键系统，优先用该列表对象的 `push()` 方法进入确认页，以便释放原页面按键监听。
- 限制与风险: 该结论来自真机交互反馈，具体按键争抢表现可能随设备、固件和页面框架不同而变化；独立 modal 页如果还承载其它可见内容，是否需要在 `onDestroy()` 隐藏 modal 可按页面实际结构判断。

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
