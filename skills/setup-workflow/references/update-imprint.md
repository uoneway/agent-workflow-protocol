# Update imprint

Use this path only after the existing marker passes the entrypoint's integrity check and its stamp differs from the bundled version.

Read the intervening change history in the canonical `AGENT_WORKFLOW_PROTOCOL.md`, using a local source checkout when available and otherwise the source link in [agents-block.md](../templates/agents-block.md). Summarize the decisions affecting this repository and identify any scope or authority changes.

An explicit update request covers replacing the intact managed block when the migration stays within that request's scope. Do not ask for the same agreement again. Resolve any additional scope before dependent changes. If the history is inaccessible, disclose that migration impact is unverified and ask whether to apply the bundled block unless the user has already authorized proceeding with that limitation.

Replace only the managed block with the current template, render [PROTOCOL_STAMP](../PROTOCOL_STAMP), and use [marker-hash.sh](../scripts/marker-hash.sh) `stamp` again. Leave project documents unchanged unless their migration was explicitly authorized. Treat legacy `PROJECT_STATE`, kickoff, promote, and similar artifacts as candidates, not automatic deletion targets.

Return to the entrypoint's verification and reporting requirements.
