# 库使用经验

本文件记录官方推荐库、社区库和 ZHAO 自维护库的中文使用经验。源码快照和许可证信息见 `indexes/libraries.md` 与 `manifest/sources.yaml`。

## ZML

- 结论类型: `official`
- 来源: `official/libraries/zml/`
- 用途: 简化小程序 Device App 与 Side Service 的通信、网络请求等流程。
- 推荐做法: 涉及蓝牙通信或侧服务通信时，先阅读官方架构文档和 ZML README，再决定是否引入。
- 限制: 仍需遵守 ZeppOS 小程序运行时能力边界，不代表可以访问未开放系统能力。

## zeppos-fx

- 结论类型: `officially referenced community`
- 来源: `community/libraries/zeppos-fx/`
- 用途: 为 ZeppOS UI 控件提供简单动画。
- 推荐做法: 用于常规 UI 动效前，先验证目标设备性能和控件兼容性。

## ZHAO 自维护库

- `Zepp-Adaptive-Button`: 当前 monorepo 的 `Library/Zepp-Adaptive-Button/` 子模块。
- `Zepp-Adaptive-UI`: 当前 monorepo 的 `Library/Zepp-Adaptive-UI/` 子模块。

这些库的发布、构建和版本策略仍在各自子模块中维护；跨项目经验可继续追加到本文件。
