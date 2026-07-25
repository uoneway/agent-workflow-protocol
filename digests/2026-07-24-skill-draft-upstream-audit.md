# Skill-Draft Upstream Audit

## Question

Are the current Korean skill drafts ready to become English runtime skills, and do their adaptations of the upstream workflows still fit this protocol?

## Conclusion

The adaptations are directionally sound: they retain the upstreams' useful ideas about shared understanding, fresh-context review, evidence gates, and safe setup, while deliberately rejecting large-scale automation that would conflict with this protocol's minimal, human-led model.

However, **none of the drafts should be promoted yet**. A runtime skill must have no unresolved behavioral choice, no conflict with the protocol, and all declared bundled resources present. The current set fails those conditions, most visibly in `promote` and `setup-workflow`.

## What was adopted, and why it fits

| Upstream | Reflected in the drafts | Deliberately not adopted | Assessment |
| --- | --- | --- | --- |
| [mattpocock/skills](https://github.com/mattpocock/skills) | One-question-at-a-time shaping, code cross-checks, primary-source research, lazy document creation, and setup discovery before writing. | A permanent plan archive, `CONTEXT.md`, broad issue-generation machinery, and a separate configuration-document layer. | Appropriate. This protocol needs reusable decisions and handoffs, not a second planning system. |
| [obra/superpowers](https://github.com/obra/superpowers) | Alternatives before commitment, a fresh-context spec audit, evidence before completion, and worktree naming. | A mandatory end-to-end pipeline, session hooks, and letting the reviewing agent directly rewrite the plan. | Appropriate. The fresh review is useful; keeping the informed session responsible for decisions preserves user control. |
| [garrytan/gstack](https://github.com/garrytan/gstack) | Challenge the default only with stated cost, promote repeatable learnings, and inspect adjacent backlog/state on completion. | Automatic cleanup, a large review chain, release-version migrations, and aggressive skill invocation. | Appropriate. The omitted automation would create more workflow than this repository is trying to sustain. |
| [GitHub Spec Kit](https://github.github.com/spec-kit/), [Agent OS](https://github.com/buildermethods/agent-os), [GSD Core](https://github.com/open-gsd/gsd-core), and [BMAD Method](https://github.com/bmad-code-org/BMAD-METHOD) | Setup pre-flight, marker-bounded ownership, explicit update mode, local settings, and brownfield discovery. | Full codebase mapping, file manifests, template compilers, large generated trees, and multi-role orchestration. | Appropriate for this scope. The retained pieces lower accidental overwrite risk; the omitted pieces would turn setup into a product of its own. |

The current active GSD lineage is `open-gsd/gsd-core`; the historical `gsd-build/get-shit-done` repository is archived. Future source tracking should make that distinction explicit.

## Promotion blockers

1. `promote` says it can run before or after merge, but the protocol requires the promotion cleanup to run **after merge on main** because `PROJECT_STATE.md` and `BACKLOG.md` are main-only.
2. `setup-workflow` declares two scripts and four templates, but none exists under `skills/setup-workflow/`. It cannot be an executable skill until those resources are implemented and validated.
3. `align`, `cold-read`, `kickoff`, `promote`, `research`, and `upstream-scout` still contain unresolved `[검토점]` decisions. The `research` name collision with the existing mattpocock skill needs an explicit choice before installation.
4. `upstream-scout` has an illustrative source table and an unresolved digest destination; its runtime form needs the actual `upstream-sources.md` inventory and a settled `digests/` convention.
5. Runtime skills must not depend on slash-command spelling or Korean review commentary. Their English form should describe the required handoff by capability and use the installed skill name only after the namespace decision is settled.

## Decision

Keep the drafts as the Korean review layer. Resolve the blockers in a review session, implement and validate the setup resources, then create each English `skills/<name>/SKILL.md` as an independent runtime artifact and delete its Korean draft in the same change.

## Sources

- [mattpocock/skills](https://github.com/mattpocock/skills)
- [superpowers skill-writing guidance](https://github.com/obra/superpowers/blob/main/skills/writing-skills/SKILL.md)
- [gstack skills guide](https://github.com/garrytan/gstack/blob/main/docs/skills.md)
- [GitHub Spec Kit reference](https://github.github.com/spec-kit/reference/agentic-sdd.html)
- [Agent OS workflows](https://buildermethods.com/agent-os/v2/workflows)
- [GSD Core](https://github.com/open-gsd/gsd-core)
- [BMAD Method documentation](https://github.com/bmad-code-org/BMAD-METHOD/blob/main/docs/index.md)
