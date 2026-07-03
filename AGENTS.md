# AGENTS.md - ZeppOS 开发知识库

本仓库是低侵入、可外挂的一站式 ZeppOS 开发知识库。无论它作为独立仓库打开，还是作为其它项目的子模块挂载，ZeppOS 领域知识都从这里开始读取。

## 入口顺序

1. `README.md` - 人类入口和目录说明。
2. `indexes/README.md` - 中文分类索引。
3. `indexes/routing.yaml` - AI/脚本使用的 canonical 路由表。
4. `CONTRIBUTING.md` - 知识消费、回写和快照维护规则。
5. `manifest/sources.yaml` - 官方快照、样例、库的来源、commit 和许可证。
6. `self-knowledge/README.md` - 自有知识写作规则。

## 边界

- `official/` 和 `community/` 是快照区，只更新版本，不直接打补丁。
- `self-knowledge/` 是 ZHAO 维护的中文可分享知识，记录真机差异、RE 摘要、库经验和跨项目复用结论。
- 不保存固件包、密钥、账号、真实凭据或不可再分发素材。
- 原始 RE 证据链可以留在宿主项目，进入本知识库时只写普通开发者可消费的摘要。

## 写入规则

- 新增可复用结论时，优先写入 `self-knowledge/` 的对应文件。
- 更新官方文档、样例或库快照时，必须同步 `manifest/sources.yaml` 和相关 `indexes/*.md`。
- 所有解释性自有知识使用中文；路径、API、命令和包名保留原文。
