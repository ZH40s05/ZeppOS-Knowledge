# Project Docs

Project docs capture local facts for one app/widget/library. They are not a replacement for reusable ZeppOS self-knowledge in `ZeppOS-Knowledge/self-knowledge/`.

## When To Create Or Update

- Starting work in a project with no `PROJECT.md`.
- Adding/removing pages, permissions, appId, target devices, assets, or build assumptions.
- Making a project-specific UX or architecture decision.
- Discovering a project-specific bug, workaround, or release blocker.

## Location

Create `PROJECT.md` in the concrete project root, next to `app.json` or `package.json`.

## Minimum Content

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

Keep this file concise and local. Put cross-project runtime conclusions in `ZeppOS-Knowledge/self-knowledge/`; keep RE evidence chains in `ZeppOS_RE/docs/`.
