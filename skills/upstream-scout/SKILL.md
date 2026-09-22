---
name: upstream-scout
description: Check tracked upstream changes during scheduled detection or an explicit upstream review.
---

# Upstream Scout

Read `upstream-sources.md` for the tracked sources and their saved review points. For an explicit review request, investigate the named source, version, or question even when it falls below the scheduled-detection thresholds. Otherwise compare each tracked source with its saved point using these thresholds:

- For versioned sources, start substantive review only when the minor or major version changed.
- For unversioned repositories or blogs, start only for a meaningful new post, commit, or feature.
- If nothing qualifies, report `No material upstream change` and do not modify the protocol or the tracking table.

For each source under review, collect the requested scope or the delta since its saved point. Use one background agent per source when useful. Report factual changes, the underlying idea shift, possible contact points with this workflow, and up to three worthwhile adoption candidates with brief evidence. Report no candidates when none merit adoption. Fetch local clones only; do not merge or pull them.

Present a concise synthesis with an adoption-candidates summary and per-source evidence. Review related candidates together when comparison improves the decision. The current protocol is the default; justify a proposed change with what it misses and the cost of keeping it unchanged. If the review must cross a context boundary, use the protocol's ordinary work-contract rule instead of creating a dedicated review packet.

Only after user review, record accepted and rejected decisions in the protocol's change history and update the corresponding saved review point in `upstream-sources.md`. Preserve decision-grade research and costly evidence according to the protocol's research rules. Never copy upstream text or change the protocol without user review.

At the 2–3 week review cadence, perform detection first. The cadence does not itself authorize a full review.
