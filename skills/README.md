# skills — confirmed, executable skills

`skills/` contains the English runtime form of a confirmed workflow. Each skill must stand on its own: it contains only the instructions and bundled resources an agent needs while doing the work.

It is not a translated copy of a Korean document. The English runtime skill is written afresh for execution. The corresponding Korean decision record lives in `skill-rationales/<name>.md`: it preserves intent, trade-offs, and boundaries for human review, but is not a parallel runtime specification. Source analysis and adoption decisions remain in `upstream-sources.md`, not in the runtime skill.

Before adding a skill here, confirm that its open questions are resolved, any declared scripts or templates exist, and its YAML front matter and bundled resources have been validated. Add the runtime skill and remove its draft in the same change.

Install confirmed skills with `scripts/link-skills.sh`. It symlinks each skill to `~/.claude/skills/<name>` for Claude Code and `~/.agents/skills/<name>` for Codex. Plugin packaging is deferred until the workflow needs to distribute a stable bundle of skills, MCP, or hooks.

Confirmed skills: `align`, `kickoff`, `promote`, `workflow-research`, `cold-read`, and `upstream-scout`. `setup-workflow` remains a Korean draft until its declared scripts and templates exist and have been validated.
