# CLAUDE.md — Frontend Project

> This file is read automatically by Claude Code at the start of every session.
> Keep this file updated as the project evolves.

---

## Session Startup

The global `~/.claude/CLAUDE.md` handles vault startup reads (session-state, lessons-summary,
decisions-summary, conventions, recurring-tasks). This file adds project-specific context:

- Read `<your-vault-path>/<your-vault-name>/projects/[PROJECT-NAME].md` now if it exists
- Read `<your-vault-path>/<your-vault-name>/stack-notes/vue-tailwind.md` before the first frontend code task

---

## Ending a Session

Before typing `/exit`, always tell Claude: **"wrap up this session"**

When wrapping up, Claude will:

1. Prepend an entry to `session-log.md` (newest first) — note anything already written mid-session
2. Create or update `projects/[PROJECT-NAME].md` at the absolute vault path:
   `<your-vault-path>/<your-vault-name>/projects/[PROJECT-NAME].md`
3. Update `projects/index.md` to reflect current status and last worked date
4. Update this `CLAUDE.md` to reflect current state and next steps

Note: `decisions-log.md` and `lessons-learned.md` are written mid-session via MUST triggers
in the global CLAUDE.md — do not double-log at wrap-up unless something was missed.

---

## Project

**Name:** [PROJECT NAME]
**Status:** [In Progress / Paused / Complete]
**Last worked on:** [DATE]

### What this project is

[2-3 sentence description]

### Current state

[What's working, what's in progress, what's not started]

### Immediate next steps

[Be specific]

---

## Tech Stack

| Layer      | Choice           | Notes                         |
| ---------- | ---------------- | ----------------------------- |
| Frontend   | Vue 3 + Tailwind | Composition API, script setup |
| Build tool | Vite             |                               |
| State      | Pinia            |                               |
| Router     | Vue Router       |                               |
| Hosting    |                  |                               |

---

## Architecture Notes

---

## Known Issues / Blockers

---

## Important File Paths

- Entry point: `src/main.js`
- App root: `src/App.vue`
- Routes: `src/router/index.js`
- Store: `src/stores/`
- Components: `src/components/`
- Pages: `src/views/`

---

## Project-Specific Conventions
