# 自有知识沉淀

当任务产生可复用结论、推翻假设、发现 quirk，或建立设备/固件相关结果时，记录到可分享的中文自有知识。

## 不写入自有知识的内容

- 临时调试猜测。
- 只从官方文档复制、没有本地验证或经验增量的信息。
- 只影响单个项目的实现细节；这类内容写入项目 `PROJECT.md`。
- 密钥、账号 token、真实 WiFi 凭据或不可分享素材。

## 写入位置

| 结论 | 写入位置 |
|--------|-------------|
| 跨项目 Runtime/UI/widget quirk | `ZeppOS-Knowledge/self-knowledge/runtime-quirks.md` |
| 库使用经验 | `ZeppOS-Knowledge/self-knowledge/libraries.md` |
| 跨项目复用经验 | `ZeppOS-Knowledge/self-knowledge/project-reuse.md` |
| Hidden API / ZeppFlow / aiFlex / unsafe 的开发摘要 | `ZeppOS-Knowledge/self-knowledge/re-summary.md` |
| Native Screen / map / POI / shortcut 的开发摘要 | `ZeppOS-Knowledge/self-knowledge/re-summary.md` |
| WiFi / SysProp / HmZiplist / hardware 的开发摘要 | `ZeppOS-Knowledge/self-knowledge/re-summary.md` |
| RE 原始证据链 | `ZeppOS_RE/docs/` 对应研究文档 |
| 单项目决策 | `<project>/PROJECT.md` |

## 条目格式

使用简短、可追溯证据的中文条目：

```markdown
### YYYY-MM-DD - 结论标题

- 分类:
- 设备 / 固件:
- 已核对官方 / 自有知识:
- 证据:
- 可复用结论:
- 项目影响:
```

如果目标文档在 `ZeppOS-Knowledge/` 或 `ZeppOS_RE/`，它是子模块；先提交并推送子模块，再提交根仓库指针。
