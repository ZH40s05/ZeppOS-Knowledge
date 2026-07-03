# Git Archive

Follow `ZeppOS-Knowledge/ai-workflow/git-archive-workflow.md` when present. Root `docs/` has been merged into `ZeppOS-Knowledge/`. These are the hard defaults:

- Commit and push after each verified stage unless the user says `no-commit`, `auto-commit: off`, `no-push`, or `auto-push: off`.
- Never use `git add .`, `git add -A`, `commit -am`, force push, reset, rebase, or amend automatically.
- Always inspect `git status --short --branch`.
- Only stage task-related files with `git add -- <files>`.
- Leave unrelated dirty files alone and report them.

## Submodules

Known submodules:

- `CustomTools/`
- `Library/Zepp-Adaptive-Button/`
- `Library/Zepp-Adaptive-UI/`
- `ZeppOS_RE/`
- `ZeppOS-Knowledge/`

If a target doc or code file lives inside a submodule:

1. Commit and push inside the submodule.
2. Return to the root repo.
3. Commit and push the submodule pointer.

Do not auto-classify untracked nested Git repos. Report them and use the repository workflow.

## Knowledge Gate

Before commit, state whether the task produced reusable ZeppOS knowledge.

- If no: explain why.
- If yes: write it to `ZeppOS-Knowledge/self-knowledge/` or the target project `PROJECT.md`.

If `ZeppOS-Knowledge/` changed, commit/push that submodule first, then commit/push the root pointer.
