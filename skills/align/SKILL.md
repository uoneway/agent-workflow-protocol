---
name: align
description: Shape a backlog item or new work into an agreed, implementation-ready workstream. Use when the user asks to align, shape, grill, clarify scope, or choose an approach before starting non-trivial work.
---

# Align

Turn an ambiguous request into a decision the user can understand and act on. Do not implement before the user selects an exit.

1. Offer two or three materially different approaches with their trade-offs when the direction is not already clear.
2. Grill one decision at a time. Discover codebase facts directly; ask the user only about preferences or authority; hand external facts to `workflow-research` with a three-line brief (question, decision affected, finding that would change the decision); use a prototype only when the answer requires seeing or trying an interaction.
3. Check claims about current behavior against the codebase. Use concrete edge-case scenarios when a domain boundary is at stake.
4. Explain important behavior, rules, and trade-offs in plain language before asking for a representative scenario, choice, or concern. This checks the explanation, not the user.

## After research

Run one precondition challenge before integrating findings: identify whether the problem can be avoided, whether the approach is unusually different from established practice and why, and whether others tried and abandoned it. The user's current direction remains the default. Propose a change only with the missing context and the cost of being wrong.

## Write the agreement

For workstream-scale work, draft the agreement in the repository's workstream format: Goal, Mental Model, Key Trade-off, Current Scope, Behavior Notes, and Out of Scope. Split scope into independently complete vertical slices. Draft a decision log when a decision is durable or expensive to reverse.

Ask for approval. For substantial work, run `cold-read` on the draft and give the user an opportunity to correct or extend their mental model.

End with one explicit exit: start now (`kickoff`), defer (promote the accepted item to the configured issue tracker or condense it into BACKLOG), or stop. If issue-tracker configuration is absent, ask rather than guessing. Skip this process for work small enough to begin directly.

Record that the approval happened and where the item now lives. A deferred item carries both in its issue or BACKLOG entry; `kickoff` copies them into the workstream document's `Source` and `Approved` fields. A later session cannot infer approval from the existence of a draft — an unapproved draft looks exactly the same.
