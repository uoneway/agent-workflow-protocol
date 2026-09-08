---
name: align
description: Reach shared understanding about an intended change before acting. Use when the user asks to align, shape, grill, clarify direction, or choose an approach.
---

# Align

Align until the user can delegate the next action with clear outcome, boundaries, and reasons to return. Alignment is the agreement itself; a document is optional.

Inspect the environment and current behavior before asking about facts you can discover. When direction is open, show two or three materially different approaches and their trade-offs.

Map the decisions and ask them in rounds. Group questions when seeing them together helps the user compare choices or notice a missing perspective. Give a recommended answer for each. State dependencies when an answer rests on an unsettled premise, and rebuild the next round after the user responds.

Route each unknown to its best source:

- inspect code, history, configuration, and live state for local facts;
- ask the user about goals and preferences, unless they explicitly delegated the choice;
- always ask immediately before an irreversible external effect, spend, or access only the user can grant;
- research external facts after narrowing the question with available local evidence;
- prototype when the answer requires seeing or trying an interaction.

Before proposing a material direction change, challenge the premise once: can the problem be avoided, is the approach unusually different from established practice, and did others abandon it? The user's current direction remains the default. Name the missing context and cost of being wrong when recommending a change.

Finish when these five parts are shared:

1. observable outcome;
2. example or evidence that will show success;
3. boundaries to preserve;
4. decisions delegated to the agent;
5. findings that require alignment again.

Do not exhaust every design branch. Leave reversible implementation choices and questions answerable by execution to the agent.

Keep the agreement in the conversation when the same context will act on it. Write a short issue or `docs/workstreams/<slug>.md` only when the agreement must cross to another session, agent, person, or worktree. Include the five parts above; omit file lists, task progress, commands, and facts derivable from git or code.

Use `cold-read` only when another executor must start from the agreement alone, ambiguity is expensive, self-review is risky, prior handoffs failed in this area, or the user requests it.

End with one explicit choice: act now, defer to the project's single backlog source, or stop. Do not act until the user chooses.
