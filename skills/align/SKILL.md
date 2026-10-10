---
name: align
description: Resolve material questions about outcomes, boundaries, and delegation when the user asks to align, shape a change, or choose an approach.
---

# Align

Recover the outcome, boundaries, and delegation already established by the current request and earlier agreement. Resolve only the material gaps needed for the next action. Alignment is the agreement itself; a document is optional.

Inspect the environment and current behavior before asking about facts you can discover. When direction is open, show two or three materially different approaches and their trade-offs.

Where this skill conflicts with the user's explicit instruction, follow the user within the authority they hold.

Ask about unsettled decisions that could change the outcome or boundaries. Group questions when seeing them together helps the user compare choices or notice a missing perspective. Give a recommended answer for each. State dependencies when an answer rests on an unsettled premise, and adapt any further questions to the response.

Route each unknown to its best source:

- inspect code, history, configuration, and live state for local facts;
- ask the user about goals and preferences, unless they explicitly delegated the choice;
- require authorization for irreversible external effects, spend, or access only the user can grant; reuse existing authorization within its scope, and ask when new authority or a changed scope is needed;
- research external facts after narrowing the question with available local evidence;
- prototype when the answer requires seeing or trying an interaction.

Before proposing a material direction change, challenge the premise once: can the problem be avoided, is the approach unusually different from established practice, and did others abandon it? The user's current direction remains the default. Name the missing context and cost of being wrong when recommending a change.

When confirming the agreement, you may play back the outcome and boundaries you understood, marking guesses as guesses. A playback is a way to confirm the five parts below, not a substitute for them.

Alignment is sufficient when these five parts are shared, including what is already clear from the request:

1. observable outcome;
2. example or evidence that will show success;
3. boundaries to preserve;
4. decisions delegated to the agent;
5. findings that require alignment again.

Do not exhaust every design branch. Leave reversible implementation choices and questions answerable by execution to the agent.

Keep the agreement in the conversation when the same context will act on it. Write a short issue or `docs/workstreams/<slug>.md` only when the agreement must cross to another session, agent, person, or worktree. Include the five parts above; omit file lists, task progress, commands, and facts derivable from git or code.

Use `cold-read` only when another executor must start from the agreement alone, ambiguity is expensive, self-review is risky, prior handoffs failed in this area, or the user requests it.

If execution was requested and no material decision remains, continue through the agreed work and its necessary verification. If the request was only to discuss or review, finish with the recommendation. Ask for a start, defer, or stop decision only when that choice remains open; deferred work belongs in the project's single backlog source. An unresolved decision blocks only work that depends on it.
