---
name: setup-workflow
description: Apply or update the Agent Workflow Protocol in a repository while preserving project-owned instructions and avoiding derived status documentation. Use when the user asks to set up, transplant, or refresh this workflow in a repo.
---

# Setup Workflow

Leave a repository with the smallest durable imprint needed to use the Agent Workflow Protocol. Preserve existing instructions and documents; do not copy the full protocol or create descriptions of state that can be reconstructed from code, git, worktrees, issues, or sessions.

Run [`scripts/detect-repo-state.sh`](scripts/detect-repo-state.sh) against the repository root before proposing changes. Treat its JSON as observed routing data, not as a semantic classification of the repository's documents. Inspect candidate documents only far enough to identify unique product intent, boundaries, expensive decisions, external evidence, and competing sources of authority.

## Align the imprint

Infer answers from the repository when reliable, and group only the remaining choices that benefit from user judgment:

- For each existing document, recommend keeping it, moving unique durable truth to the appropriate authority, turning it into a generated view, or treating it as a deletion candidate. Deletion always requires explicit approval.
- Create or designate one `VISION.md`-equivalent only when product purpose, audience, boundaries, or kill conditions exist outside the code and need a durable authority.
- Create [`templates/BACKLOG.md`](templates/BACKLOG.md) only when real deferred candidates need preservation and the project has no issue tracker. Never use it for active status or session notes.
- If machine routing has not been decided, ask once whether to add global routing or remain repository-local. Record `{"placement":"global"}` or `{"placement":"local-only"}` in `${XDG_CONFIG_HOME:-$HOME/.config}/link-workflow/setup-state.json`. Respect a valid saved choice unless the user asks to reconfigure it.

Do not create `ARCHITECTURE.md`, `GLOSSARY.md`, decision records, research notes, workstreams, or other placeholders during setup. Those belong to the work that first proves they are needed.

## Apply a new imprint

Read the bundled [`PROTOCOL_STAMP`](PROTOCOL_STAMP), render it into [`templates/agents-block.md`](templates/agents-block.md), append the block once to `AGENTS.md`, and use [`scripts/marker-hash.sh`](scripts/marker-hash.sh) `stamp` to replace the hash placeholder. Preserve all content outside the managed markers. The bundled stamp is the applicable version even when the protocol source repository is not locally available.

Create the agreed `VISION.md`-equivalent or `BACKLOG.md` only when its condition is met and there is substantive content. If Claude Code is in use and `CLAUDE.md` is absent, offer a thin `@AGENTS.md` pointer; never replace an existing file automatically.

For a saved or newly chosen `global` placement, render [`templates/global-routing.md`](templates/global-routing.md) into each detected tool's instruction file: `~/.claude/CLAUDE.md` for Claude Code and `~/.codex/AGENTS.md` for Codex. Stamp it with marker name `agent-workflow-protocol-global`. Do not touch machine instruction files for `local-only` placement. A request to set up one repository does not authorize changing global routing without this choice.

## Update an existing imprint

Use `marker-hash.sh check` before deciding that an imprint is current. Duplicate, orphaned, reversed, unhashed, or modified markers are unsafe: show the relevant difference and ask how to recover the managed region instead of choosing a copy or overwriting it.

When the marker is intact, compare its `P-NNNN` stamp with the bundled `PROTOCOL_STAMP`:

- If they match, leave the managed block and project documents unchanged.
- If they differ, read the intervening change history from the canonical `AGENT_WORKFLOW_PROTOCOL.md`, using a local source checkout when available and otherwise the source link in the template. Summarize only the decisions that affect this repository. With the user's agreement, replace only the managed block with the current template and stamp it again. If the history is inaccessible, disclose that migration impact is unverified before asking whether to apply the bundled block.
- Treat legacy `PROJECT_STATE`, kickoff, promote, and similar artifacts as migration candidates. Move unique truth or delete files only within the scope the user explicitly approves.

Apply the same integrity and ownership rules to an existing global routing block. A repository-local marker takes precedence over global routing, and the absence of setup never blocks direct use of `orient`, `align`, `workflow-research`, `cold-read`, or `upstream-scout`.

## Verify and report

Run `marker-hash.sh check` for every block written or updated. Confirm by direct inspection that each start/end marker occurs exactly once, links resolve, required content is non-empty, and bytes outside managed regions were preserved. Report what was imprinted, why each optional document or global change was or was not made, any migration candidates left untouched, and the verification evidence.
