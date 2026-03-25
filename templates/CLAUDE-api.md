# CLAUDE.md — API / Backend Project

> This file is read automatically by Claude Code at the start of every session.
> Keep this file updated as the project evolves.

---

## Memory Bank

At the start of every session, read these files from the Obsidian vault:

- `<your-vault-path>/11_Claude-Memory/conventions.md`
- `<your-vault-path>/11_Claude-Memory/session-log.md`
- `<your-vault-path>/11_Claude-Memory/stack-notes/node-express-mongo.md`
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

[2-3 sentence description]

### Current state

[What's working, what's in progress, what's not started]

### Immediate next steps

[Be specific]

---

## Tech Stack

| Layer     | Choice             | Notes |
| --------- | ------------------ | ----- |
| Runtime   | Node.js            |       |
| Framework | Express            |       |
| Database  | MongoDB + Mongoose |       |
| Auth      |                    |       |
| Hosting   |                    |       |

---

## Architecture Notes

### Folder structure

```
/src
  /routes       ← one file per resource
  /models       ← Mongoose schemas
  /middleware   ← auth, validation, error handling
  /controllers  ← business logic
  server.js     ← entry point
.env
```

---

## Known Issues / Blockers

---

## Important File Paths

- Entry point: `server.js` or `src/server.js`
- Routes: `src/routes/`
- Models: `src/models/`
- Middleware: `src/middleware/`
- Environment: `.env`

---

## API Conventions

- All responses follow: `{ success: true/false, data/error: ... }`
- All async routes use try/catch
- Validate request body before processing
