# Machine routing

Use the detector's placement observation and any explicit user choice. If placement is undecided, ask once whether to add global routing or remain repository-local. Record `{"placement":"global"}` or `{"placement":"local-only"}` in `${XDG_CONFIG_HOME:-$HOME/.config}/agent-workflow-protocol/setup-state.json`. Respect a valid saved choice unless the user asks to reconfigure it. Do not repurpose `HOME` or `XDG_CONFIG_HOME` as task variables.

For `local-only`, do not touch machine instruction files. For a saved or newly chosen `global` placement, use [global-routing.md](../templates/global-routing.md) in each detected tool's instruction file: `~/.claude/CLAUDE.md` for Claude Code and `~/.codex/AGENTS.md` for Codex.

Apply the entrypoint's same integrity and ownership rules to existing global blocks with marker name `agent-workflow-protocol-global`. An intact block at the bundled stamp needs no rewrite. For a different stamp, follow [update imprint](update-imprint.md) using the global template and marker name; malformed or modified regions need an explicit recovery choice. For an absent block, append the rendered template once. Preserve all bytes outside managed markers and stamp written blocks with [marker-hash.sh](../scripts/marker-hash.sh).

A repository-local marker takes precedence. Return to the entrypoint's verification and reporting requirements.
