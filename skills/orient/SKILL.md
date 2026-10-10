---
name: orient
description: Recover current direction and relevant live state when resuming work or choosing what to do next.
---

# Orient

Use the conversation and work agreement for established intent and delegation; verify claims about current state against authoritative sources.

Read applicable `AGENTS.md` instructions. Consult `VISION.md` or its equivalent when product direction affects the next choice, and relevant decision records when their boundaries matter. Inspect the live sources that could change that choice: code, recent changes, git status and history, branches, worktrees, issues, pull requests, sessions, or verification evidence. This is a source menu, not a required inventory.

Stop gathering context when the next action can be recommended with its material uncertainties identified. A narrow resumption does not require reconstructing the entire project.

Do not assume the default branch has the latest active-work state. Distinguish observed facts, inaccessible sources, and inferences. A missing source is `unverified`, not an empty or successful state.

Give the user a concise reorientation:

- the outcome the project or work is pursuing;
- what the live sources show has happened;
- what changed since the last settled choice;
- unresolved facts and decisions requiring the user;
- the recommended next action and why.

Lead with any decision the user must make. Link each claim that could change that decision to its source and to how it was established: run, read, or inferred. Do not tag every sentence. The reorientation must make sense without rereading the earlier conversation.

Adjust depth to the return distance and decision at hand. Offer deeper evidence, scenarios, or code when useful. Keep the reorientation in the conversation or product surface; do not store it as another status document.
