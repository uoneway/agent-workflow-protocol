# skills — confirmed, executable skills

`skills/` contains the English runtime form of a confirmed workflow. Each skill must stand on its own: it contains only the instructions and bundled resources an agent needs while doing the work.

It is not a translated copy of a Korean document. The English runtime skill is written afresh for execution. The corresponding Korean decision record lives in `skill-rationales/<name>.md`: it preserves intent, trade-offs, and boundaries for human review, but is not a parallel runtime specification. Source analysis and adoption decisions remain in `upstream-sources.md`, not in the runtime skill.

Before adding a skill here, confirm that its open questions are resolved, any declared scripts or templates exist, and its YAML front matter and bundled resources have been validated. Add the runtime skill and remove its draft in the same change.

Install confirmed skills with `scripts/link-skills.sh`. It symlinks each skill to `~/.claude/skills/<name>` for Claude Code and `~/.agents/skills/<name>` for Codex. Plugin packaging is deferred until the workflow needs to distribute a stable bundle of skills, MCP, or hooks.

Confirmed skills: `align`, `kickoff`, `resume`, `promote`, `workflow-research`, `cold-read`, and `upstream-scout`. `setup-workflow` is still a Korean draft, though no longer for the original reason — its scripts and templates are built and validated and its open decisions are closed, so what remains is the English rewrite and the public repository its marker URL will point at.

The protocol has six stages but only four of them carry a skill. That is deliberate: skills attach to transitions a user can call for, while Develop's rules (park, mark, explain) hold for the whole of a session and belong in `AGENTS.md`, which loads every time. See `skill-rationales/resume.md` for the reasoning.
