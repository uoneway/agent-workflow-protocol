---
name: cold-read
description: Audit whether a handoff supports a fresh start when context gaps are costly or the user requests an independent handoff audit.
---

# Cold Read

Give a fresh agent the artifact and every source it explicitly routes the real executor to. Do not give it the originating conversation.

Ask for unanswered questions with three severities: blocks starting, blocks later, or minor. Do not repeat questions answered by the provided sources.

A question blocks starting only when its answer is needed to choose a safe first action within the agreement. A fact the executor can discover during that action is not a reason to delay the handoff.

Resolve each finding by adding irreducible intent or a real boundary, marking an unknown with its fallback and observation plan, or rejecting the question with a reason. Do not copy code structure, progress, commands, or other live facts into the artifact merely to satisfy the audit; point to their authoritative source or make the executor inspect it.

Pass when no question blocks starting. Re-audit changed artifacts with an agent that has not seen an earlier version when the remaining risk justifies another round.

If questions require user agreement, return to `align`. If only a real system can answer them, preserve the unknown, fallback, and first observation instead of auditing again.

This audit finds missing context, not false assertions. The executor must still verify claims against authoritative sources and report contradictions.

If a fresh agent is unavailable, disclose that independent review could not be performed. A self-check may still help, but does not count as an independent pass. Defer the affected handoff only when independent review is required by the agreement or applicable policy; continue independent work.
