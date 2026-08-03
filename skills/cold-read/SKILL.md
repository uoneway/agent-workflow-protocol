---
name: cold-read
description: Audit whether a handoff document is self-contained for a reader with no conversation context. Use for workstream agreements, upstream digests, proposed repository rules, or skill drafts when the next action must be possible from the document alone.
---

# Cold Read

Audit a handoff document by giving it to a fresh agent that did not participate in the conversation.

Give that agent the document **and whatever the document routes its reader to** — the files its own read-first list names, the skills its routing section points at. A document that was never meant to stand alone will fail an alone audit every time, and the resulting questions will be ones its references already answer. Match the audit's inputs to what the real implementer will actually open.

Ask the agent to list every unanswered question it would need answered to start the assigned work, without repeating questions any of those inputs already answer. Require a severity for each: blocking start, blocks later, or minor.

For each question, either add the answer to the document, explicitly mark it Out of Scope or TBD, or reject it as unnecessary and report why.

Pass only when a round raises no question that blocks starting. After editing, audit again with an agent that has not seen the document before; never re-audit with one that already read it.

Do not fix the number of rounds in advance. How many it takes tracks how thin the draft was when you started, and each round changes what the next one can see — a document long enough to contradict itself exposes contradictions that a short one had no room to hold. When successive rounds keep raising blocking questions that editing cannot close, sort them by what could answer them:

- **Answerable by agreement** — the agreement is incomplete, not the proofreading. Return to `align`.
- **Answerable only by observing a real system** — auditing again cannot resolve these. Write the unknown into the document as an unknown: the fallback behavior it forces, and how the first execution will capture the answer. Before concluding an unknown is unobservable, exhaust the read-only ways to observe it; a state-changing probe being unavailable does not mean the answer is unreachable.

Apply this to documents that expire — workstream agreements, digests, proposed rules, skill drafts. Auditing an enduring reference document drives it toward permanent length, because every round adds text that document must then carry forever.

This audit finds what a document fails to answer. It does not find what a document asserts wrongly; a confident false statement passes every round. Require whoever executes the document to report back where it was wrong.
