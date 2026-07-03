# 知识消费与回写规则

本文件定义 ZeppOS-Knowledge 的消费、回写和快照维护规则。它适用于人类开发者，也适用于 Codex、Claude Code、Zcode 等 AI 编码工具。

## 消费入口

1. 先读 `README.md` 理解目录边界。
2. 再读 `indexes/README.md` 选择分类。
3. AI/脚本优先读 `indexes/routing.yaml` 做精确路由。
4. 需要确认来源、commit、许可证时读 `manifest/sources.yaml`。

## 写入位置

| 结论类型 | 写入位置 |
|----------|----------|
| 真机 runtime/UI/framework 行为 | `self-knowledge/runtime-quirks.md` |
| RE 结论的开发摘要 | `self-knowledge/re-summary.md` |
| 库选择和使用经验 | `self-knowledge/libraries.md` |
| 跨项目复用经验 | `self-knowledge/project-reuse.md` |
| 官方文档/样例/库快照来源 | `manifest/sources.yaml` 和相关 `indexes/*.md` |

## 不写入这里的内容

- 单项目本地决策；写入宿主项目 `PROJECT.md`。
- 原始 RE 证据链、固件包、密钥、账号、真实凭据或不可分享素材。
- 只从官方文档复制、没有本地验证或经验增量的信息。

## 提交前 gate

每次修改宿主项目或本知识库前，回答：

```text
本轮是否产生可复用 ZeppOS 知识？
- 否：说明原因。
- 是：列出已写入的 self-knowledge 或宿主项目 PROJECT.md 路径。
```

如果修改了本知识库，先在本仓库提交并推送，再回到宿主仓库提交子模块指针。
