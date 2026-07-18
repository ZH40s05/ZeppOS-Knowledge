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
- 推荐做法: 需要确认用户操作时，从原页面 `push` 到独立确认页，让确认页在 `build()` 中创建并显示 `createModal`；确认/取消回调里直接执行 `back()`、`exit()` 或 `replace()` 等导航，不要在跳转前主动隐藏 modal。若原页面使用 Zepp Style List（ZSList）等自定义按键系统，优先用该列表对象的 `push()` 方法进入确认页，以便释放原页面按键监听。
- 限制与风险: 该结论来自真机交互反馈，具体按键争抢表现可能随设备、固件和页面框架不同而变化；独立 modal 页如果还承载其它可见内容，是否需要在 `onDestroy()` 隐藏 modal 可按页面实际结构判断。

### 2026-07-12 - Settings `Select` 首屏值遮罩不能与原生标题并存

- 结论类型: `true-device confirmed`
- 适用范围: Zepp OS 手机端 `AppSettingsPage` 中需要用应用自有文本补偿受控 `Select.value` 首屏不显示的场景。
- 已验证设备/固件: PaceStrategy 手机端 Settings 截图确认；手机型号、Zepp 客户端版本未记录。
- 官方文档: 未见官方说明；实现模式与 `NormalApps/PaceStrategy/GRUN_app-side/setting.js` 的现有兼容处理交叉核对。
- 证据: 同时传入非空 `Select.title` 并持续覆盖当前选值，会在手机容器中把原生标题、原生选值和应用遮罩一起渲染，出现大号标题与选值重叠。只修正标题和遮罩后，三列时分秒仍会溢出容器，TextInput 的原生标签也可能与值重复。GRUN 把字段封装为两列 36 px 控件，并把原生 `label` / `title`、Select 内部背景和边框一起清空。
- 推荐做法: 整套复用 GRUN 控件契约：父容器 `display: flex; flex-wrap: wrap; gap: 8px`；字段 `flex: 0 0 calc(50% - 4px)`；Select 高 36 px、内部 `backgroundColor: transparent`、`border: none`；TextInput 使用外部短标签并把原生 `label` 留空。为每个 Select 建立稳定且唯一的 ID；初始渲染时在相对定位容器内用 `pointerEvents: 'none'` 的绝对定位 Text 显示当前 option 名称；`onChange` 后撤销遮罩。重复控件的 ID 必须包含行号或记录 ID。
- 限制与风险: 这是手机容器兼容补丁，不应把遮罩长期保留；原生 Select 首屏值显示问题是否在所有 Zepp 客户端版本存在仍需分版本验证。

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

### 2026-07-17 - Settings H5 支持 `navigator.clipboard.writeText`

- 结论类型: `true-device confirmed`
- 适用范围: Zepp OS 手机端 `AppSettingsPage` 的用户点击回调中复制短文本或策略密钥。
- 已验证设备 / 固件: PaceStrategy 真机反馈；设备型号、Zepp 客户端与固件版本未记录。
- 官方文档: 未找到对应公开 Settings Clipboard API 说明。
- 证据: PaceStrategy 分享按钮调用 `navigator.clipboard.writeText(PPS1 密钥)` 后，真机确认密钥已写入系统剪贴板。
- 推荐做法: 在用户手势回调中尝试 `navigator.clipboard.writeText`，以成功/失败提示反馈结果；不要在窄宽 `TextInput` 中保留长密钥作为复制兜底，原生输入框会发生横向文本溢出并遮挡后续内容。
- 限制与风险: 仅确认一次真实设备环境，尚未覆盖不同手机、Zepp 客户端版本、非手势触发或剪贴板权限被拒绝的情形；调用仍需保留失败处理。

### 2026-07-19 - `Vibrator` 按能力选择场景 API，并保留旧 mode 实测映射

- 结论类型: `true-device confirmed` + project evidence
- 适用范围: Device App 中需要同时兼容 API_LEVEL 2.0 传统振动模式和 API_LEVEL 3.6 场景 API 的触觉反馈。
- 已验证设备 / 固件: 用户直接安装由 Zepp Style List（ZSList，当时名 zolist）example 编译的构建，在 Amazfit Balance 上确认调用流程；具体固件和 API_LEVEL 未记录。用户反馈模式错位问题在 Zepp OS 4 前后已被修复，但精确版本节点尚未确认。
- 官方文档: `official/docs/zeppos-docs/docs/reference/device-app-api/newAPI/sensor/Vibrator.mdx` 将基础 `Vibrator` API 标为 API_LEVEL 2.0，将 `start(Array<Action>)`、`getType()` 和 `STRONG_SHORT` 标为 API_LEVEL 3.6；2.0 示例明确先 `setMode()` 再 `start()`。官方资料未说明旧 mode 映射 bug 或其修复版本，API 4.2 样例仍可见 `setMode()` → `start()`。
- 证据: Balance 上用非文档参数形式启动时没有振动，改为 `setMode(mode)` → `start()` 后能够振动，但旧 mode 的实际效果与枚举名称不符。`NormalApps/已提交/Shimmer/page/page.js` 的真机记录显示，受影响固件上 `VIBRATOR_SCENE_SHORT_STRONG` 实际为短轻，`VIBRATOR_SCENE_DURATION` 实际为短中；Shimmer 未记录能稳定产生精确短强效果的旧 mode。
- 推荐做法: 先能力检测 `getType()`，可用时传 Action 数组调用场景 API，例如 `{ type: vibrationType.STRONG_SHORT, duration: 20 }`；接口缺失或调用失败时，才回退到文档规定的 `setMode()` → `start()`。旧路径仅使用已在目标固件实测过的错位映射，并在产品说明中标注为降级效果；不要硬编码“Zepp OS 4”作为切换阈值。
- 限制与风险: 修复的具体系统或固件版本、Balance 测试固件和 API_LEVEL 都未记录。若新场景 API 在已修复系统上异常失败，旧路径的 `VIBRATOR_SCENE_DURATION` 可能恢复为标准长时振动，因此必须保留异常日志并继续按设备复测。
