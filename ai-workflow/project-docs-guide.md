# ZeppOS 项目文档指南

项目文档记录某个具体小程序、组件、库或工具的本地事实。它不是可复用 ZeppOS 知识库；可复用结论应写入 `ZeppOS-Knowledge/self-knowledge/`。

## Location

Use `PROJECT.md` in the project root:

```text
NormalApps/<project>/PROJECT.md
SportsWidget/已提交/<project>/PROJECT.md
SecondaryWidget/已提交/<project>/PROJECT.md
Library/<library>/PROJECT.md
CustomTools/PROJECT.md
ZeppOS_RE/apps/<app>/PROJECT.md
```

If a project already has substantial docs, keep `PROJECT.md` as the short routing page and link to deeper docs.

## 模板

```markdown
# <Project Name> Project Notes

## Scope

- Type:
- appId:
- Status:
- Target devices:
- Entry files:

## Current Behavior

- Main user workflow:
- Important UI states:
- Data sources and permissions:

## Build And Verification

- Build command:
- Preview / true-device notes:
- Known failing checks:

## Local Decisions

- Decision:
- Reason:
- Date:

## Dependencies And Reuse

- Shared code:
- Related projects:
- Reusable ZeppOS docs consumed:
- Knowledge conclusion type:

## Open Issues

- Issue:
- Evidence:
- Next action:
```

## 路由规则

- 可复用 ZeppOS 行为写入 `ZeppOS-Knowledge/self-knowledge/`。
- 隐藏 API、固件、sysprop、原生 Screen 或可行性研究的原始证据链写入 `ZeppOS_RE/docs/`；开发摘要写入 `ZeppOS-Knowledge/self-knowledge/re-summary.md`。
- 项目特定 UX、布局、appId、页面、资源和发布决策写入项目 `PROJECT.md`。
- 项目文档必须列出已消费的 `ZeppOS-Knowledge/` 条目，帮助下一轮 AI 不重复搜索。
