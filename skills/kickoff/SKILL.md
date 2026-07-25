---
name: kickoff
description: Start an approved workstream by making its main-branch state transition, then creating its branch and worktree. Use when the user says to start, kick off, or begin an Align-approved non-trivial task.
---

# Kickoff

Use this only for workstream-sized work. If no approved workstream agreement exists, ask whether to run `align` or whether the work is small enough to start without kickoff.

On `main`, make one start-transition commit that:

1. Removes the item from `docs/BACKLOG.md` and, when applicable, records the start on its issue.
2. Adds the active item to `docs/PROJECT_STATE.md` with only name, status, owner, and detail link.
3. Creates `docs/workstreams/<slug>.md`, preserving the approved agreement and adding a minimal execution state (before-start state and first slice as next step).
4. Lands any approved decision-log draft. Use the repository's configured global decision-ID sequence; if that configuration is absent, stop and ask rather than inventing a new sequence.

After that commit, create `feat/<slug>` and a sibling worktree named `../<repo>-<slug>`. Keep `PROJECT_STATE.md` and `BACKLOG.md` main-only; update the workstream document from the feature branch.

Report the transition commit, branch, worktree path, and first slice. Do not create a worktree or branch before the main transition is safely recorded.
