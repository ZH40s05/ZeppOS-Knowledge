# Git 归档与同步工作流

本仓库不是单一 npm monorepo，而是“主索引仓库 + 子模块 + 第三方代码 + 本地参考克隆”的混合资产库。Git 操作必须先分类再暂存。

## 资产分类

| 分类 | 示例 | Git 策略 |
|------|------|----------|
| 根仓库直接追踪 | `NormalApps/`、`SecondaryWidget/`、`SportsWidget/` 中自有项目 | 根仓库提交具体文件 |
| Git Submodule | `CustomTools/`、`Library/Zepp-Adaptive-Button/`、`Library/Zepp-Adaptive-UI/`、`ZeppOS_RE/` | 子模块先提交，根仓库再提交指针 |
| 开发知识库子模块 | `ZeppOS-Knowledge/` | 官方快照、自有知识和索引；子模块先提交推送，根仓库再提交指针 |
| 第三方代码 | `NormalApps/其它开发者/` | 默认只读；用户明确要求才改 |
| 临时参考克隆 | `zeppos-docs/`、`zeppos-samples/` | 默认不保留；更新 Knowledge 快照时按需临时拉取，ignore，不提交 |
| 工具本地状态 | `.codex/`、`.claude/worktrees*/` | ignore，不提交 |
| 构建输出 | `dist/`、`*.zpk`、`node_modules/` | ignore，不提交 |

## 开始工作前

```bash
git status --short --branch
git submodule status --recursive
```

如果任务进入子模块，再单独检查：

```bash
git -C <submodule-path> status --short --branch
```

发现未追踪嵌套 Git 仓库时，不要直接 `git add`。先决定它是：

1. 新子模块。
2. 需要导入根仓库的普通代码。
3. 本地参考资料，应加入 `.gitignore`。

## 暂存规则

禁止：

```bash
git add .
git add -A
git commit -am "..."
```

推荐：

```bash
git add -- path/to/file1 path/to/file2
git diff --cached --stat
git diff --cached
```

AI 工具默认像熟练 Git 协作者一样主动存档：阶段性事件完成、验证通过且可精确隔离本任务改动时，自动执行 `git add -- <files>`、`git commit` 和 `git push`。仍然禁止 reset、rebase、amend、force push，除非用户明确要求且说明影响范围。

## 默认自动存档与上传

默认开启。用户不需要额外说 `auto-commit: on`。

用户明确说出以下任一表达时，本任务跳过 commit 和 push：

- `no-commit`
- `auto-commit: off`
- `只改不提交`
- `不要提交`

用户明确说出以下任一表达时，本任务只本地 commit，不 push：

- `no-push`
- `auto-push: off`
- `先别推送`
- `只本地存档`

如果用户写出 `auto-push: on`，表示确认阶段 commit 后立即 push；这也是默认行为。任何情况下都不允许自动 force push。

AI 需要主动提醒存档时机：

- 开始较长任务时，说明会在阶段完成并验证后自动 commit/push。
- 阶段完成但不能安全提交时，说明阻塞原因、未提交文件和建议命令。
- 发现用户已有较多脏改动时，提醒先归档或明确本轮任务边界。
- 最终回复中报告 commit hash、push 结果、验证命令和未纳入提交的改动。

### 阶段性事件

可自动 commit 的阶段事件：

1. 一个功能切片完成，并通过该项目最小验证。
2. 修复一个明确 bug，并验证复现路径或构建结果。
3. 完成项目状态移动，例如开发中移动到 `已提交/` 或 `已搁置/`，并更新索引。
4. 完成文档/规则整理的一个独立主题。
5. 子模块内变更已提交，根仓库需要记录子模块指针。
6. 用户要求暂停、切换任务或结束当前工作前，且已有完整可解释的改动。

不可自动 commit/push 的情况：

1. 工作区存在与当前任务无关的脏改动，且无法用路径精确排除。
2. 验证失败，除非用户明确允许提交 WIP。
3. 变更包含未归类嵌套 Git 仓库、第三方代码区新增文件、大二进制或构建产物。
4. 需要删除、重命名大量文件但用户没有确认目标状态。
5. 涉及 secret、账号、本地绝对路径或工具缓存。
6. 当前分支没有上游分支时，不自动设置上游；只 commit 并提醒用户确认推送目标。

### 知识回写检查

每次自动 commit 前必须回答：

```text
本轮是否产生可复用 ZeppOS 知识？
- 否：说明原因。
- 是：列出已写入的 ZeppOS-Knowledge/self-knowledge/ 或 PROJECT.md 路径。
```

如果修改了 `ZeppOS-Knowledge/`，必须先在该子模块内提交并推送，再在根仓库提交子模块指针。

### 自动 commit 前检查

每次自动 commit 前必须执行并审阅：

```bash
git status --short --branch
git diff -- <files>
git diff --check -- <files>
```

然后只暂存本阶段文件：

```bash
git add -- <files>
git diff --cached --stat
git diff --cached --check
```

提交信息使用中文，说明目的，不写泛泛的 `update`：

```bash
git commit -m "更新 nearby-search 周边搜索页面"
```

默认提交后执行：

```bash
git push
```

如果用户设置 `auto-push: off` 或分支没有上游，只做 commit，并在最终回复中明确未推送原因。

### 子模块自动存档

子模块任务的阶段顺序固定：

1. 在子模块内检查、暂存、commit。
2. 默认先 push 子模块；若 `auto-push: off`，只提交不推送。
3. 回到根仓库，暂存子模块路径。
4. 根仓库 commit 子模块指针。
5. 默认再 push 根仓库；若 `auto-push: off`，只提交不推送。

示例：

```bash
git -C ZeppOS_RE status --short --branch
git -C ZeppOS_RE add -- <files>
git -C ZeppOS_RE commit -m "记录 WiFi 入口分析进展"
git -C ZeppOS_RE push
git add -- ZeppOS_RE
git commit -m "更新 ZeppOS_RE 子模块指针"
git push
```

## 子模块流程

修改子模块文件后：

```bash
git -C <submodule-path> status --short --branch
git -C <submodule-path> add -- <files>
git -C <submodule-path> commit -m "<message>"
git -C <submodule-path> push
git status --short
git add -- <submodule-path>
git commit -m "更新 <submodule-path> 指针"
```

如果只是查看或实验，不提交子模块指针。

`ZeppOS-Knowledge/` 也是子模块。更新官方文档、样例、库快照或自有知识时，先提交并推送该子模块，再提交根仓库子模块指针。

## 新增嵌套仓库

作为子模块：

```bash
git submodule add <url> <path>
git add -- .gitmodules <path>
```

作为普通代码导入：

1. 删除导入目录内部 `.git/`。
2. 保留许可证和来源说明。
3. 确认不是第三方只读区。
4. 精确暂存需要纳入的文件。

作为本地参考：

1. 在 `.gitignore` 写明路径和原因。
2. 不提交该目录内容。

## 项目状态归档

常规小程序：

- 开发中：`NormalApps/<project>/`
- 已提交：`NormalApps/已提交/<project>/`
- 已搁置：`NormalApps/已搁置/<project>/`

运动组件：

- 待提交：`SportsWidget/待提交/<project>/`
- 已提交：`SportsWidget/已提交/<project>/`

归档动作：

1. 移动目录。
2. 更新 `docs/project-index.md`。
3. 检查 `app.json`、资源路径和文档链接是否因移动失效。
4. 运行必要构建。
5. 精确暂存移动和索引文件。

## 当前需人工归类的典型目录

以下是 2026-07-03 审计时发现的未追踪或嵌套 Git 目录，后续处理前应先确认归类：

| 路径 | 当前判断 |
|------|----------|
| `Library/Zepp-Official-List/` | 嵌套 Git 仓库；若要长期维护，建议改为子模块或明确导入 |
| `NormalApps/其它开发者/QuickTrack/` | 第三方区内嵌套 Git 仓库；默认只读，不纳入根提交 |
| `ZeppOS_RE/Pill Reminder*`、`ZeppOS_RE/apps/fake-ui-framework/`、`ZeppOS_RE/scripts/*.py` | 子模块内实验文件；在 `ZeppOS_RE/` 内单独决定 |
| `package-lock.json` | 根仓库当前无依赖；无依赖 lock 可删除，提交前确认是否真的要引入根级 npm lock |

## 推荐提交信息

- `更新 nearby-search 周边搜索页面`
- `归档 RunningFtpTest 为待提交状态`
- `更新 ZeppOS_RE 子模块指针`
- `整理 AI 协作和 Git 归档规则`
