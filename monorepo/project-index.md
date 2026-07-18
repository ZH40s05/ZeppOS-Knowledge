# ZeppOS 项目索引

本文件是按需读取的项目目录索引。根 `AGENTS.md` 不再内联完整表格，以减少 AI 工具默认上下文。

## 顶层目录

| 目录 | 类型 | 说明 |
|------|------|------|
| `NormalApps/` | 常规小程序 | `appType: "app"`, `module: page` |
| `SecondaryWidget/` | 副屏组件 | `module: secondary-widget` |
| `SportsWidget/` | 运动数据组件 | `module: data-widget`, `extType: workout` |
| `Library/` | 开源库 | Git Submodule 或待归类库 |
| `CustomTools/` | 社区工具 | Git Submodule，GitHub Pages 部署 |
| `ZeppOS_RE/` | 逆向工程 | Git Submodule，系统级研究 |

## 状态目录

- `已提交/` — 已向 Zepp 官方应用商店提交。
- `已搁置/` — 不再或短期内不再推进开发。
- `待提交/` — 待提交。
- 分类根目录 — 开发中的项目直接放在此处，例如 `NormalApps/nearby-search/`。
- `其它开发者/` — 第三方代码，默认禁止修改。
- `骑行素材/` — 纯设计素材，非项目。

## NormalApps

| 项目 | 路径 | appId | 状态 |
|------|------|-------|------|
| GeologicalCompass | `NormalApps/已提交/GeologicalCompass/` | — | 已提交 |
| JumpJump | `NormalApps/已提交/JumpJump/` | — | 已提交 |
| PixelCompass | `NormalApps/已提交/PixelCompass/` | — | 已提交 |
| Shimmer | `NormalApps/已提交/Shimmer/` | — | 已提交 |
| ZeekBench | `NormalApps/已提交/ZeekBench/` | — | 已提交 |
| nearby-search | `NormalApps/nearby-search/` | 1103031 | 开发中 |
| GNSS | `NormalApps/已搁置/GNSS/` | — | 已搁置 |
| watchmusic | `NormalApps/已搁置/watchmusic/` | — | 已搁置 |

## SecondaryWidget

| 项目 | 路径 | 状态 |
|------|------|------|
| HealthCenter | `SecondaryWidget/已提交/HealthCenter/` | 已提交 |
| HealthRings | `SecondaryWidget/已提交/HealthRings/` | 已提交 |
| secscreen | `SecondaryWidget/已提交/secscreen/` | 已提交 |
| ToolCard | `SecondaryWidget/已提交/ToolCard/` | 已提交 |
| WoodenFish | `SecondaryWidget/已提交/WoodenFish/` | 已提交 |

## SportsWidget

| 项目 | 路径 | appId | 状态 |
|------|------|-------|------|
| BatteryAssistant | `SportsWidget/已提交/BatteryAssistant/` | — | 已提交 |
| BurningMonitor | `SportsWidget/已提交/BurningMonitor/` | — | 已提交 |
| ClimbingRecord | `SportsWidget/已提交/ClimbingRecord/` | — | 已提交 |
| ConsumptionMonitor | `SportsWidget/已提交/ConsumptionMonitor/` | — | 已提交 |
| ContestScoreboard | `SportsWidget/已提交/ContestScoreboard/` | — | 已提交 |
| CooperVo2MaxTest | `SportsWidget/已提交/CooperVo2MaxTest/` | — | 已提交 |
| CyclingFtpTest | `SportsWidget/已提交/CyclingFtpTest/` | — | 已提交 |
| DirectPath | `SportsWidget/已提交/DirectPath/` | — | 已提交 |
| DivingAssistant | `SportsWidget/已提交/DivingAssistant/` | — | 已提交 |
| Garmin-UI | `SportsWidget/已提交/Garmin-UI/` | — | 已提交 |
| HeadingAssistant | `SportsWidget/已提交/HeadingAssistant/` | — | 已提交 |
| HeadingCompass | `SportsWidget/已提交/HeadingCompass/` | — | 已提交 |
| HealthRingsLite | `SportsWidget/已提交/HealthRingsLite/` | — | 已提交 |
| MaritimeAssistant | `SportsWidget/已提交/MaritimeAssistant/` | — | 已提交 |
| MountaineeringOximetry | `SportsWidget/已提交/MountaineeringOximetry/` | — | 已提交 |
| PixelCompassS | `SportsWidget/已提交/PixelCompassS/` | — | 已提交 |
| RaceTime | `SportsWidget/已提交/RaceTime/` | — | 已提交 |
| RacingPanel | `SportsWidget/已提交/RacingPanel/` | — | 已提交 |
| RunningBasicTraining | `SportsWidget/已提交/RunningBasicTraining/` | — | 已提交 |
| RunningEconomy | `SportsWidget/已提交/RunningEconomy/` | — | 已提交 |
| SafeLocationCard | `SportsWidget/已提交/SafeLocationCard/` | — | 已提交 |
| SportsCompass | `SportsWidget/已提交/SportsCompass/` | — | 已提交 |
| SportsFlashlight | `SportsWidget/已提交/SportsFlashlight/` | — | 已提交 |
| SportsGeologicalCompass | `SportsWidget/已提交/SportsGeologicalCompass/` | — | 已提交 |
| SportsGNSSAssistant | `SportsWidget/已提交/SportsGNSSAssistant/` | — | 已提交 |
| SportsGNSSData | `SportsWidget/已提交/SportsGNSSData/` | — | 已提交 |
| SportsGNSSMap-ChF | `SportsWidget/已提交/SportsGNSSMap/SportsGNSSMap-ChF/` | 1062329 | 已提交 |
| SportsGNSSMap-Int | `SportsWidget/已提交/SportsGNSSMap/SportsGNSSMap-Int/` | 1053813 | 已提交 |
| SportsLocation | `SportsWidget/已提交/SportsLocation/` | — | 已提交 |
| SportsQuickPay | `SportsWidget/已提交/SportsQuickPay/` | — | 已提交 |
| StairClimbingWorkout | `SportsWidget/已提交/StairClimbingWorkout/` | — | 已提交 |
| TabataTraining | `SportsWidget/已提交/TabataTraining/` | — | 已提交 |
| RunningFtpTest | `SportsWidget/待提交/RunningFtpTest/` | — | 待提交 |

## Library

| 库 | npm 包 | 用途 | 状态 |
|----|--------|------|------|
| Zepp-Adaptive-Button (`zabt`) | `@zh40s05/zepp-adaptive-button` | 物理按键 + 触屏自适应融合 | Submodule |
| Zepp-Adaptive-UI (`zaui`) | `@zh40s05/zepp-adaptive-ui` | 多屏幕自适应缩放 (P0-P3) | Submodule |
| Zepp-Style-List | `@zh40s05/zslist` | 社区维护的 ZeppOS 系统风格列表控件 | Submodule (`Library/Zepp-Style-List/`) |

## CustomTools

| 项目 | 路径 | 说明 |
|------|------|------|
| sports-data-compare | `CustomTools/` | 单文件 HTML，FIT 心率 + GPX 轨迹对比，GitHub Pages 部署 |

## ZeppOS_RE

详见 `ZeppOS_RE/AGENTS.md`。研究方向包括原生页面导航、固件逆向、沙箱逃逸、WiFi 注入、Shortcut 格式、HmZiplist、SysProp 属性、硬件信息、蓝牙 HID、隐藏 API / aiFlex、小程序 WiFi 连接。

## 关联项目

| 项目 A | 项目 B | 关系 |
|--------|--------|------|
| `NormalApps/已提交/PixelCompass/` | `SportsWidget/已提交/PixelCompassS/` | 小程序版 vs 运动扩展版 |
| `NormalApps/已提交/GeologicalCompass/` | `SportsWidget/已提交/SportsGeologicalCompass/` | 小程序版 vs 运动扩展版，共享 compass 渲染核心 |
| `SportsWidget/已提交/SportsGNSSMap/SportsGNSSMap-ChF/` | `SportsWidget/已提交/SportsGNSSMap/SportsGNSSMap-Int/` | 国行 vs 国际版，代码相同仅 i18n 不同 |
