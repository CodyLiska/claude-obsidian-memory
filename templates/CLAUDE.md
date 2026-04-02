# CLAUDE.md — Development Root

> This file provides base instructions for any Claude Code session started
> anywhere under <your-dev-root>/. Project-level CLAUDE.md
> files take precedence where they conflict.

---

## Memory Bank

At the start of every session, read these files from the Obsidian vault:

- `<your-vault-path>/<your-vault-name>/conventions.md`
- `<your-vault-path>/<your-vault-name>/session-log.md` — last 2 entries only

Then check if a project-level CLAUDE.md exists in the current directory and read it.
If a project file exists at `<your-vault-name>/projects/[project-name].md`, read that too.

---

## Ending a Session

Before typing `/exit`, always tell Claude: **"wrap up this session"**

Claude will update `session-log.md` and the project file before you exit.

---

## Default Standards

Follow all conventions in `conventions.md` unless the project-level CLAUDE.md
specifies otherwise. Key defaults:

- Vue + Tailwind for frontend
- Node + Express + MongoDB for backend
- React Native for mobile
- 2 spaces, single quotes, semicolons always
- Mixed functional/class organization — whatever fits
- Comments on complex logic and non-obvious code only

---

## Project Location

All projects live under:

```
<your-dev-root>/
```

---

## Off-Limits

- Never store secrets, API keys, or tokens in any memory bank file
