---
name: kickoff
description: Start an approved workstream by making its main-branch state transition, then creating its branch and worktree. Use when the user says to start, kick off, or begin an Align-approved non-trivial task.
---

# Kickoff

Use this only for workstream-sized work. If no approved workstream agreement exists, ask whether to run `align` or whether the work is small enough to start without kickoff.

Make one start-transition commit that:

1. Removes the item from `docs/BACKLOG.md` and, when applicable, records the start on its issue.
2. Adds the active item to `docs/PROJECT_STATE.md` with only name, status, owner, and detail link.
3. Creates `docs/workstreams/<slug>.md`, preserving the approved agreement and adding a minimal execution state (before-start state and first slice as next step).
4. Lands any approved decision-log draft. Use the repository's configured global decision-ID sequence; if that configuration is absent, stop and ask rather than inventing a new sequence. An ID assigned anywhere other than `main` is provisional until promote confirms it.

Where to make that commit: it updates main-only documents, so it must land where no other workstream updates them at the same time. Commit on `main` when the session can be there. When the execution environment forces isolation, put the transition on a commit whose ancestry reaches `main` and let a merge carry it there. Stacking it on another workstream's branch satisfies the invariant but makes one pull request carry both workstreams; prefer a transition-only branch when review granularity matters.

Once the transition is recorded, create `feat/<slug>` and its worktree using the environment's own worktree convention rather than a fixed path. Enter that worktree before any development edit — creating a worktree is not entering it, and some environments refuse edits made from outside it. Write the branch and the actual worktree path at the top of the workstream document.

Keep `PROJECT_STATE.md` and `BACKLOG.md` main-only; update the workstream document from the feature branch.

Report the transition commit, the branch, the worktree path, whether the session entered that worktree, and the first slice. Do not create a worktree or branch before the transition is safely recorded.
