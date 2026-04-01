# Global Claude Instructions

> This file provides standing instructions that apply to every Claude Code session,
> regardless of which project is being worked on. Project-level CLAUDE.md files
> take precedence where they conflict.
>
> **Setup:** Replace `<your-vault-path>` and `<your-vault-name>` with your actual vault details.

---

## Identity

You are working with a developer who builds web apps, APIs, mobile apps, and scripts
across multiple machines. The Obsidian vault (`<your-vault-name>`) is the memory bank
for all projects.

---

## Standing Instructions

### At the start of every session

1. Read `<your-vault-name>/conventions.md` — always follow these standards
2. Read the last 2-3 entries in `<your-vault-name>/session-log.md` — understand recent context
3. Check if a project file exists in `<your-vault-name>/projects/[project-name].md` and read it
4. Check `<your-vault-name>/lessons-learned.md` before debugging anything — the fix may already be documented
5. Read `<your-vault-name>/recurring-tasks.md` — these rules apply for the entire session

### During every session

- Follow `conventions.md` standards without being reminded
- Follow all rules in `recurring-tasks.md` — especially the **Write to the Vault Immediately** section
- Write to `lessons-learned.md` immediately when a bug is resolved after multiple attempts — do not wait until wrap-up
- Write to `decisions-log.md` immediately when a significant architectural decision is made — do not wait until wrap-up
- When learning something new and reusable about a tool or framework, suggest adding it to the relevant `stack-notes/` file
- Never read from or reference any credentials folder in the vault — that folder is off limits

### At the end of every session

- Wait for the user to say **"wrap up this session"** before writing wrap-up entries
- Always update `<your-vault-name>/session-log.md` — note anything already written mid-session so it is not double-logged
- Update `<your-vault-name>/projects/index.md` — reflect any status changes and today's date
- Conditionally update `decisions-log.md` and `lessons-learned.md` if anything was not already written mid-session
- Create or update the project file at `<your-vault-name>/projects/[project-name].md`
- Update `CLAUDE.md` in the project root to reflect current state and next steps

---

## Vault Structure

```
<your-vault-name>/
  <your-vault-name>/
    CLAUDE.md              ← this file (global instructions)
    conventions.md         ← coding standards
    decisions-log.md       ← architectural decisions log
    lessons-learned.md     ← bugs and gotchas log
    recurring-tasks.md     ← standing rules for every session
    session-log.md         ← per-session activity log
    windows-setup.md       ← setup guide for Windows machines
    projects/
      index.md             ← all projects overview
      [project-name].md    ← per-project deep context
    stack-notes/
      vue-tailwind.md
      node-express-mongo.md
      react-native.md
      phaser.md
      python.md
    templates/
      CLAUDE.md
      CLAUDE-api.md
      CLAUDE-frontend.md
      CLAUDE-python.md
      CLAUDE-game.md
```

---

## Vault Path Reference

Replace these with your actual paths after setup:

- **Vault root:** `<your-vault-path>/`
- **Memory root:** `<your-vault-path>/<your-vault-name>/`
- **Projects root:** `<your-vault-path>/<your-vault-name>/projects/`
- **Dev root:** `<your-dev-root>/`

---

## Off-Limits

- Never read, reference, or write to any credentials folder in the vault
- Never store API keys, passwords, tokens, or secrets in any memory bank file
- Never commit sensitive data to any project file
