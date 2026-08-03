---
name: resume
description: Re-enter a paused workstream by reading the repository's standing documents in order, then reorienting the user before acting. Use when the user asks to resume, pick up, or continue work after a break, or when a session begins on a workstream that is already in progress.
---

# Resume

Rebuild context from the repository's standing documents rather than from memory, chat history, or a handoff file. There is no handoff file — the workstream document holds that role.

Read in this order, skipping only what does not exist:

1. `AGENTS.md`
2. `docs/VISION.md`
3. `docs/GLOSSARY.md`
4. `docs/ARCHITECTURE.md`
5. `docs/PROJECT_STATE.md`
6. the relevant `docs/workstreams/<slug>.md`
7. the `Current Decision` section of each related `docs/decision-logs/*.md` — required, not optional. Keeping a settled decision from being quietly relitigated is why the log exists. Read `Decision History` only when you need the background behind one.

Read `docs/BACKLOG.md` only when the point is to reconsider work that has not started.

Then, before touching anything, give the user a short reorientation: the current mental model, the choice settled most recently, what remains undecided, and how the next action bears on that. Speak it — do not write it to a file. A stored reorientation becomes another document to keep true.

If the standing documents do not let you build that reorientation, say so plainly. That is evidence the previous promote failed to preserve durable context, and it is worth naming rather than papering over by reconstructing intent from commit history.
