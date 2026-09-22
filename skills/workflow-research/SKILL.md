---
name: workflow-research
description: Investigate external evidence for a decision and preserve decision-relevant findings.
---

# Workflow Research

Start with the question, the decision it affects, and the finding that would change the current direction. For open exploration, the question alone is enough. Narrow the brief first with available environment and code evidence.

Use primary sources: official documentation, source code, specifications, or first-party APIs. Trace factual claims to the source that owns them and distinguish facts from interpretation. Delegate when the calling work can continue independently.

Return cited findings and their implications for the decision. If the research affects a decision, preserve a concise synthesis even when the immediate conversation also consumes it. Pure lookups that do not become decision evidence need no file. Follow the repository's location convention; if none exists, use `docs/_research/<slug>.md`. Update the existing synthesis for the same question instead of creating a parallel copy.

The synthesis must let a later reader retrace and reinterpret the evidence. Include:

- the question, scope, observation date, affected decision, and what could change it;
- observed facts separated from interpretation, counterevidence, and limitations;
- decision impact plus dated later additions or interpretation changes;
- a source inventory with title and owner, exact URL or path, access date, known publication date/version/commit, the claim each source supported, and any preserved-evidence path and integrity identifier.

When source volatility, reacquisition cost, exact wording/schema/measurements, or reinterpretation value makes original evidence worth preserving, read [evidence preservation](references/evidence-preservation.md). Keep preserved evidence outside default context and link it from the synthesis.

Do not silently overwrite old evidence or interpretation. Append a dated update or state what earlier interpretation is replaced and why. A source-less copy or a rewrite that could be mistaken for the original is not evidence.

Before proposing a material direction change, challenge its premise if that has not already been done for this decision. Do not copy upstream prose into the workflow or link raw evidence as a substitute for placing the adopted durable fact in its authoritative document.
