---
name: setup-workflow
description: Install or update the Agent Workflow Protocol in a repository when the user requests setup or migration.
---

# Setup Workflow

Leave a repository with the smallest durable imprint needed to use the Agent Workflow Protocol. Preserve existing instructions and documents; do not copy the full protocol or create descriptions of state that can be reconstructed from code, git, worktrees, issues, or sessions.

Run [`scripts/detect-repo-state.sh`](scripts/detect-repo-state.sh) against the repository root before proposing changes. Treat its JSON as observed routing data, not as a semantic classification of the repository's documents. Inspect candidate documents only far enough to identify unique product intent, boundaries, expensive decisions, external evidence, and competing sources of authority.

## Select the relevant path

Read the bundled [`PROTOCOL_STAMP`](PROTOCOL_STAMP). It is the applicable version even when the protocol source repository is unavailable. Use [`scripts/marker-hash.sh`](scripts/marker-hash.sh) `check` for existing markers before treating any imprint as current.

- No local imprint: read [new imprint](references/new-imprint.md).
- Intact local imprint with the same stamp: leave the managed block and project documents unchanged.
- Intact local imprint with a different stamp: read [update imprint](references/update-imprint.md).
- Duplicate, orphaned, reversed, unhashed, or modified markers: show the relevant difference and ask how to recover the managed region. Do not choose a copy or overwrite it. Continue only work independent of that recovery choice.

For an undecided machine placement, an existing `global` choice, or an explicit routing reconfiguration request, read [machine routing](references/machine-routing.md). A valid saved `local-only` choice needs no machine changes.

## Ownership and scope

A setup or update request authorizes the relevant local managed block within that request's scope. Reuse existing agreement; ask only about unresolved choices or additional scope. Preserve bytes outside managed markers. Moving unique truth or deleting existing documents requires explicit authorization covering those targets. A repository setup request alone does not authorize machine-wide routing changes.

Do not create `ARCHITECTURE.md`, `GLOSSARY.md`, decision records, research notes, workstreams, or other placeholders during setup. Those belong to the work that first proves they are needed.

A repository-local marker takes precedence over global routing. The absence of setup never blocks direct use of `orient`, `align`, `workflow-research`, or `cold-read`.

## Verify and report

Run `marker-hash.sh check` for every block written or updated. Confirm by direct inspection that each start/end marker occurs exactly once, links resolve, required content is non-empty, and bytes outside managed regions were preserved. Report what was imprinted, why each optional document or global change was or was not made, any migration candidates left untouched, and the verification evidence.
