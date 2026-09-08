---
name: orient
description: Reconstruct a project's current direction and actual state before choosing or resuming work. Use when the user asks what to do next, returns to a project, or needs the current picture across active work.
---

# Orient

Reconstruct the current picture from authoritative sources instead of relying on chat memory or a manual status summary.

1. Read `AGENTS.md` and, when present, `VISION.md`.
2. Inspect relevant live state: git history and status, branches, worktrees, issues or pull requests, sessions, and current verification evidence available in the environment.
3. Read only the work agreement and decision records relevant to the likely next action.
4. Inspect the necessary code and recent changes.

Do not assume the default branch has the latest active-work state. Distinguish observed facts, inaccessible sources, and inferences. A missing source is `unverified`, not an empty or successful state.

Give the user a concise reorientation:

- the outcome the project or work is pursuing;
- what the live sources show has happened;
- what changed since the last settled choice;
- unresolved facts and decisions requiring the user;
- the recommended next action and why.

Adjust depth to the return distance and decision at hand. Offer deeper evidence, scenarios, or code when useful. Keep the reorientation in the conversation or product surface; do not store it as another status document.
