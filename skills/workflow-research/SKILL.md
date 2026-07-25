---
name: workflow-research
description: Research external facts that affect a workflow decision, such as service behavior, APIs, standards, or ecosystem practice. Use as Align's research handoff or when the user asks for decision-oriented research with an evidence-backed Markdown result.
---

# Workflow Research

Obtain a brief before researching: the question, the decision it affects, and the finding that would change the caller's mind. Proceed with an open-ended investigation only when the caller explicitly says that no decision is affected.

Delegate the investigation when that lets the calling work continue. Require primary sources: official documentation, source code, specifications, or first-party APIs. Trace each factual claim to the source that owns it.

Write one cited result at `docs/_research/YYYY-MM-DD-<slug>.md`. If a file for the same topic already exists, update it, rename it with today's date, and add an Update History entry instead of creating a parallel file. End with `## Implications`, summarizing in three to five lines what the findings mean for the brief's decision.

Return the file path and the implications to the caller. Remind the caller to run one precondition-challenge round before changing direction.

Never link `_research/` files from durable reference documents. Incorporate the needed fact into the durable document instead.
