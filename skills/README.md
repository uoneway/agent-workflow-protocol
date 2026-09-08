# skills — confirmed, executable skills

`skills/` contains the English runtime form of a confirmed workflow. Each skill must stand on its own: it contains only the instructions and bundled resources an agent needs while doing the work.

It is not a translated copy of a Korean document. The English runtime skill is written afresh for execution. The corresponding Korean decision record lives in `skill-rationales/<name>.md`: it preserves intent, trade-offs, and boundaries for human review, but is not a parallel runtime specification. Source analysis and adoption decisions remain in `upstream-sources.md`, not in the runtime skill.

Before adding a skill here, confirm that its open questions are resolved, any declared scripts or templates exist, and its YAML front matter and bundled resources have been validated. Add the runtime skill and remove its draft in the same change.

Write for a capable model, not a compliant one. State the goal, the constraints, and the boundaries — where approval is required, what counts as done — and let the model choose the steps. Enumerating every step is what older models needed; on current ones it measurably lowers quality, and both Anthropic's and OpenAI's published guidance converged on this independently. Reasoning depth is a runtime setting, not something to ask for in prose.

Publish confirmed skills with `scripts/link-skills.sh`. This repository remains the source of truth; the script copies each confirmed skill into `~/dotfiles/config/ai/skills`, records which names it owns, and delegates local installation and verification to dotfiles. Dotfiles then links the shared deployment snapshot into `~/.claude/skills/<name>` for Claude Code and `~/.codex/skills/<name>` for Codex. Do not edit the dotfiles copy directly. Use `--config-dir PATH` for another config checkout or `--publish-only` when only the deployment snapshot should change. Plugin packaging is deferred until the workflow needs to distribute a stable bundle of skills, MCP, or hooks.

Confirmed skills: `orient`, `align`, `workflow-research`, `cold-read`, and `upstream-scout`. `setup-workflow` remains a Korean draft and is being redesigned for the minimal-document protocol adopted in P-0020 through P-0024.

Skills are not a stage-for-stage implementation of the protocol. `orient` and `align` are callable transitions; Act and Reorient are normal agent behavior. `workflow-research`, `cold-read`, and `upstream-scout` are conditional tools. Retired `kickoff`, `resume`, and `promote` rationales remain under `skill-rationales/` as decision history.
