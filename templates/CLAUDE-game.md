# CLAUDE.md — Game Dev Project

> This file is read automatically by Claude Code at the start of every session.
> Keep this file updated as the project evolves.

---

## Memory Bank

At the start of every session, read these files from the Obsidian vault:

- `<your-vault-path>/11_Claude-Memory/conventions.md`
- `<your-vault-path>/11_Claude-Memory/session-log.md`
- `<your-vault-path>/11_Claude-Memory/stack-notes/phaser.md`
- `<your-vault-path>/11_Claude-Memory/projects/[PROJECT-NAME].md` if it exists

---

## Ending a Session

Before typing `/exit`, always tell Claude: **"wrap up this session"**

When wrapping up, Claude will:

1. Append an entry to `session-log.md`
2. Append to `decisions-log.md` if a significant decision was made
3. Append to `lessons-learned.md` if a notable bug was resolved
4. Create or update `projects/[PROJECT-NAME].md` at the absolute vault path:
   `<your-vault-path>/11_Claude-Memory/projects/[PROJECT-NAME].md`
5. Update `projects/index.md` to reflect current status and last worked date

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
