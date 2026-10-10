# skills — confirmed, executable skills

`skills/` contains the English runtime form of a confirmed workflow. Each skill must stand on its own: it contains only the instructions and bundled resources an agent needs while doing the work.

It is not a translated copy of a Korean document. The English runtime skill is written afresh for execution. The corresponding Korean decision record lives in `skill-rationales/<name>.md`: it preserves intent, trade-offs, and boundaries for human review, but is not a parallel runtime specification. Source analysis and adoption decisions remain in `upstream-sources.md`, not in the runtime skill.

Before adding a skill here, confirm that its open questions are resolved, any declared scripts or templates exist, and its YAML front matter and bundled resources have been validated. Add the runtime skill and remove its draft in the same change.

State the goal, constraints, authorization boundaries, and completion criteria, and let the model choose the steps. Recognize existing intent and authorization before asking for new decisions. Specify when reading or verification is sufficient. Reasoning depth is a runtime setting, not something to ask for in prose.

Keep descriptions precise about the request they serve. Load substantial mode-specific guidance only when that mode applies; short single-purpose skills can remain self-contained. Preserve operational safeguards such as ownership and integrity checks. Evaluate changes with the models and workflows that use these skills rather than assuming a simpler prompt is always better.

Publish confirmed skills with `scripts/link-skills.sh`. This repository remains the source of truth; the script copies each confirmed skill into `~/dotfiles/config/ai/skills`, records which names it owns, and delegates local installation and verification to dotfiles. Dotfiles then links the shared deployment snapshot into `~/.claude/skills/<name>` for Claude Code and `~/.codex/skills/<name>` for Codex. Do not edit the dotfiles copy directly. Use `--config-dir PATH` for another config checkout or `--publish-only` when only the deployment snapshot should change. Plugin packaging is deferred until the workflow needs to distribute a stable bundle of skills, MCP, or hooks.

Confirmed skills: `setup-workflow`, `orient`, `align`, `workflow-research`, and `cold-read`.

Skills that only maintain this repository, such as `upstream-scout`, are not published. They live in `.agents/skills/<name>/` for Codex, with a `.claude/skills/<name>` symlink for Claude Code, and load only inside this repository. Do not give a repository-local skill the same name as a published one.

Skills are not a stage-for-stage implementation of the protocol. `orient` and `align` are callable transitions; Act and Reorient are normal agent behavior. `workflow-research` and `cold-read` are conditional tools. Retired `kickoff`, `resume`, and `promote` rationales remain under `skill-rationales/` as decision history.
