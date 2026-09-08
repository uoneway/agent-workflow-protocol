---
name: upstream-scout
description: Detect whether tracked upstream skill repositories or blogs have a new minor-or-major release or another meaningful change, then prepare a decision digest. Use when the user asks to inspect upstreams or during the recurring workflow review.
---

# Upstream Scout

Read `upstream-sources.md` for the tracked sources and their saved review points. Compare each source with that point.

- For versioned sources, start substantive review only when the minor or major version changed.
- For unversioned repositories or blogs, start only for a meaningful new post, commit, or feature.
- If nothing qualifies, report `No material upstream change` and do not modify a digest, the protocol, or the tracking table.

For each changed source, collect the delta since its saved point. Use one background agent per source when useful. Require: factual changes, the underlying idea shift, possible contact points with this workflow, and the three highest-value new ideas with brief evidence. Fetch local clones only; do not merge or pull them.

Write the synthesis to `digests/YYYY-MM-DD-upstream-digest.md`, with per-source sections and an adoption-candidates summary at the top. Review related candidates together when comparison improves the decision. The current protocol is the default; justify a proposed change with what it misses and the cost of keeping it unchanged.

Only after that review, record accepted and rejected decisions in the protocol's change history and update the corresponding saved review point in `upstream-sources.md`, then delete the digest. Never copy upstream text or change the protocol without the digest and user review.

At the 2–3 week review cadence, perform detection first. The cadence does not itself authorize a full review.
