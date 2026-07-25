---
name: cold-read
description: Audit whether a handoff document is self-contained for a reader with no conversation context. Use for workstream agreements, upstream digests, proposed repository rules, or skill drafts when the next action must be possible from the document alone.
---

# Cold Read

Give only the document under review to a fresh agent that has not participated in the conversation. Ask it to list every unanswered question it would need answered to start the assigned work, without repeating questions already answered by the document. Require a severity for each: blocking start, blocks later, or minor.

For each question, either add the answer to the document, explicitly mark it Out of Scope or TBD, or reject it as unnecessary and report why.

Pass only when no question blocks starting. After editing, use a different fresh agent for one re-audit. Never re-audit with the first agent. If blocking questions remain after the second audit, return to `align`: the problem is an incomplete agreement, not another proofreading pass.
