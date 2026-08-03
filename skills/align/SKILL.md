---
name: align
description: Shape a backlog item or new work into an agreed, implementation-ready workstream. Use when the user asks to align, shape, grill, clarify scope, or choose an approach before starting work.
---

# Align

Turn an ambiguous request into a decision the user can understand and act on. Do not implement before the user selects an exit.

1. Offer two or three materially different approaches with their trade-offs when the direction is not already clear.
2. Grill one decision at a time, routing each question to where its answer lives. Discover codebase facts directly. Ask the user about preferences — unless they explicitly delegated the decision, in which case decide it on stated grounds and record it in a decision log so they can overturn it. Always ask about authority: an irreversible external effect, a spend, or an access only the user holds. Delegation never covers that; when approval cannot be obtained, stop and record what blocked. Hand external facts to `workflow-research` with a three-line brief (question, decision affected, finding that would change the decision). Use a prototype only when the answer requires seeing or trying an interaction — and treat a prototype that needs an irreversible external effect as an authority question, not a time cost.
3. Check claims about current behavior against the codebase. Use concrete edge-case scenarios when a domain boundary is at stake.
4. Explain important behavior, rules, and trade-offs in plain language before asking for a representative scenario, choice, or concern. This checks the explanation, not the user.

## After research

Run one precondition challenge before integrating findings: identify whether the problem can be avoided, whether the approach is unusually different from established practice and why, and whether others tried and abandoned it. The user's current direction remains the default. Propose a change only with the missing context and the cost of being wrong.

## Write the agreement

Draft the agreement in the repository's workstream format: Goal, Mental Model, Key Trade-off, Current Scope, Behavior Notes, and Out of Scope. Split scope into independently complete vertical slices. Draft a decision log when a decision is durable or expensive to reverse.

Ask for approval, and run `cold-read` on every draft you write. Do not gate that audit on how large the work looks — writing a draft already means the work was shaped, and re-measuring its size is a second gate on the same fact. Separately, when the change bears on a decision the user will make next, give them an opportunity to correct or extend their mental model; that one spends their time, so let the need decide it.

End with one explicit exit: start now (`kickoff`), defer (promote the accepted item to the configured issue tracker or condense it into BACKLOG), or stop. If issue-tracker configuration is absent, ask rather than guessing. If the grill shows the work needs none of these documents, say so and let the user start directly — that is a finding, not a gate you failed.

Record that the approval happened and where the item now lives. A deferred item carries both in its issue or BACKLOG entry; `kickoff` copies them into the workstream document's `Source` and `Approved` fields. A later session cannot infer approval from the existence of a draft — an unapproved draft looks exactly the same.
