# RE 结论开发摘要

本文件把 `ZeppOS_RE/docs/` 中的逆向工程结论转写为普通开发者可消费的中文摘要。原始证据链、实验记录和研究细节仍以 `ZeppOS_RE/docs/` 为准。

## 原生页面导航

- 结论类型: `RE confirmed`
- 推荐做法: 可以通过 `launchApp({ url: 'ScreenName', native: true })` 尝试跳转部分原生系统页面。
- 已验证: `MapPoiFirstLevelScreen` 可进入“探索周边”，GPS 锁定后可搜索 POI；`CompassScreen` 可进入指南针。
- 限制: `launchApp` 的 `params` 无法传递业务参数；shortcut 模块格式实验未成功。
- 原始证据链: `ZeppOS_RE/docs/map_screen_navigation_probe.md`

## 小程序 WiFi 连接

- 结论类型: `RE confirmed`
- 推荐做法: 普通 ZeppOS 小程序不要设计“直接扫描/连接 WiFi”的功能路径。
- 已验证: 固件存在完整 WiFi 栈，但 JS 运行时没有可用入口；`@zos/wifi`、`@zos/wlan`、`@zos/network`、`@zos/blufi` 等探测路径不可用。
- 限制: 除非官方 SDK 更新或进行固件级修改，否则小程序无法创建 WiFi 连接。
- 原始证据链: `ZeppOS_RE/docs/wifi_miniapp_feasibility.md`

## SysProp / HmZiplist

- 结论类型: `RE confirmed`
- 推荐做法: SysProp/HmZiplist 可用于理解系统属性存储和历史注入实验，但不应作为普通小程序稳定能力依赖。
- 已验证: HmZiplist 格式已破解，属性识别覆盖率高；文件级注入会被 RAM 权威副本覆盖。
- 限制: 不建议把外部文件注入作为产品功能方案。
- 原始证据链: `ZeppOS_RE/docs/sysprop_reference.md`、`ZeppOS_RE/docs/wifi_research.md`

## 隐藏 API / aiFlex

- 结论类型: `RE confirmed`
- 推荐做法: 隐藏 API 和 aiFlex 仅用于研究或受控探测，不作为上架小程序的稳定依赖。
- 已验证: `@zos/ai-flex` 更像 Page 层代理，需要 AppService 和 `NATIVE_*` 后端配合。
- 限制: 权限、系统版本、AppService 上下文都可能导致不可用。
- 原始证据链: `ZeppOS_RE/docs/zeppflow_hidden_apis.md`

## BLE HID

- 结论类型: `RE confirmed`
- 推荐做法: 不要把手表设计成手机可识别的 BLE HID 外设。
- 已验证: 手表 HID 实现仅支持 Host 模式，例如控制手机相机快门；不支持 Device 模式。
- 原始证据链: `ZeppOS_RE/AGENTS.md` 和已归档 HID 探测项目。
