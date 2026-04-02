# CLAUDE.md — Game Dev Project

> This file is read automatically by Claude Code at the start of every session.
> Keep this file updated as the project evolves.

---

## Session Startup

The global `~/.claude/CLAUDE.md` handles vault startup reads (session-state, lessons-summary,
decisions-summary, conventions, recurring-tasks). This file adds project-specific context:

- Read `<your-vault-path>/<your-vault-name>/projects/[PROJECT-NAME].md` now if it exists
- Read `<your-vault-path>/<your-vault-name>/stack-notes/phaser.md` before the first game code task

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

[2-3 sentence description of the game — genre, mechanic, scope]

### Current state

[What's working, what's in progress, what's not started]

### Immediate next steps

[Be specific — next feature, next scene, next bug]

---

## Tech Stack

| Layer      | Choice     | Notes                 |
| ---------- | ---------- | --------------------- |
| Framework  | Phaser 3   |                       |
| Build tool | Vite       |                       |
| Language   | JavaScript |                       |
| Assets     |            | Tiled, Aseprite, etc. |

---

## Architecture Notes

### Scene list

| Scene        | Purpose              | Status |
| ------------ | -------------------- | ------ |
| BootScene    | Load minimal assets  |        |
| PreloadScene | Load all game assets |        |
| MenuScene    | Main menu            |        |
| GameScene    | Core gameplay        |        |

### Folder structure

```
/src
  /scenes
  /objects    ← Player, Enemy, etc.
  /assets
  /config
  main.js
```

---

## Known Issues / Blockers

---

## Important File Paths

- Entry point: `src/main.js`
- Game config: `src/config/`
- Scenes: `src/scenes/`
- Game objects: `src/objects/`

---

## Game-Specific Notes

[Physics settings, camera setup, tilemap details, etc.]
