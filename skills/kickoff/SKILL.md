---
name: kickoff
description: Start an approved workstream by making its main-branch state transition, then creating its branch and worktree. Use when the user says to start, kick off, or begin an Align-approved task.
---

# Kickoff

Being called is the judgement that this work warrants a workstream — do not re-estimate its size. What you do check is approval, which is a recorded fact rather than an inference: look for it on the item's issue or BACKLOG entry, or in this session. If it is absent, ask whether to run `align` first.

Make one start-transition commit that:

1. Transitions the item at its source — remove it from `docs/BACKLOG.md` when it lived there, or record the start on its issue when it came from the tracker. An item shaped into an issue already left BACKLOG at align's exit, so there is nothing to remove.
2. Adds the active item to `docs/PROJECT_STATE.md` with only name, status, owner, and detail link.
3. Creates `docs/workstreams/<slug>.md`, preserving the approved agreement and adding a minimal execution state (before-start state and first slice as next step). Fill the joint fields at the top — `Source` (issue number or BACKLOG entry), `Approved` (when the agreement passed align's review gate), `Branch`, `Worktree`. Later skills read these fields instead of reconstructing what an earlier skill did.
4. Lands any approved decision-log draft. Use the repository's configured global decision-ID sequence; if that configuration is absent, stop and ask rather than inventing a new sequence. An ID assigned anywhere other than `main` is provisional until promote confirms it.

Where to make that commit: it updates main-only documents, so it must land where no other workstream updates them at the same time. Commit on `main` when the session can be there. When the execution environment forces isolation, put the transition on a commit whose ancestry reaches `main` and let a merge carry it there. Stacking it on another workstream's branch satisfies the invariant but makes one pull request carry both workstreams; prefer a transition-only branch when review granularity matters.

Once the transition is recorded, create `feat/<slug>` and its worktree using the environment's own worktree convention rather than a fixed path. Enter that worktree before any development edit — creating a worktree is not entering it, and some environments refuse edits made from outside it. Write the branch and the actual worktree path at the top of the workstream document.

Keep `PROJECT_STATE.md` and `BACKLOG.md` main-only; update the workstream document from the feature branch.

Report the transition commit, the branch, the worktree path, whether the session entered that worktree, and the first slice. Do not create a worktree or branch before the transition is safely recorded.
