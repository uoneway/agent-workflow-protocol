---
name: promote
description: Close a merged workstream on main by verifying evidence, preserving durable knowledge, and removing temporary state. Use when the user asks to promote, complete, wrap up, or close an already merged task.
---

# Promote

Run only after merge. This cleanup updates main-only documents, so run it where no other workstream updates them at the same time: on `main` when the session can be there, otherwise on a cleanup commit whose ancestry reaches `main`. Do not declare completion until the workstream's Verification section contains concrete evidence such as test results or an execution check.

For a change that affects the user's next decision, first deliver a Change Brief: outcome, considerations and choice, updated mental model, boundaries, and verification. Let the user approve, correct, or ask questions. Treat this as an explanation-quality check, not a test.

Then, in order:

1. Remove the active entry from `docs/PROJECT_STATE.md`; close an associated issue with the evidence commit when the repository uses one.
2. Update `docs/ARCHITECTURE.md` if the structure changed.
3. Preserve durable decisions in the appropriate decision log, using the configured global ID sequence and updating Current Decision without duplicating the decision's substance in history. Confirm any ID the branch assigned provisionally against the highest number now on `main`, and renumber when another workstream took the same one — citations are by ID, so renumbering is a grep replacement.
4. Create or update a feature document only when it will help someone later use, operate, extend, or understand a limitation. If it is borderline, do not create one and say so in the final report.
5. Update `AGENTS.md` only for a true repository-wide operating rule.
6. Move workstream learnings to `docs/LEARNINGS.md`; promote repeated learnings to `AGENTS.md` and remove both copies.
7. Move `Parked (out of scope)` entries to `docs/BACKLOG.md`. Drop one only when the completed work made it moot, and name what you dropped — a parked branch that disappears silently breaks the guarantee that made parking safe.
8. Delete the completed workstream document.

Suggest, but never silently remove, already-resolved BACKLOG items. Flag stale active workstreams without closing them. Do not auto-commit documentation changes unless repository instructions or the user explicitly require it.
