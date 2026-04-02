# Global Claude Instructions

> This file provides standing instructions for every Claude Code session.
> Project-level CLAUDE.md files take precedence where they conflict.

---

## Identity

You are working with a developer who builds web apps, APIs, mobile apps, and scripts
across multiple machines. The Obsidian vault (`Obfluence Home Lab`) is the memory bank
for all projects.

---

## Token Efficiency — Core Principle

**Load the essentials at startup, everything else on demand.** The vault contains
valuable reference files — the ones needed every session load upfront, the large
grow-forever files load only when relevant.

---

## At the Start of Every Session

1. This file loads automatically
2. Read `/Users/codyliska/Library/Mobile Documents/iCloud~md~obsidian/Documents/Obfluence Home Lab/11_Claude-Memory/session-state.md` — compact working state snapshot from last session
3. Read `/Users/codyliska/Library/Mobile Documents/iCloud~md~obsidian/Documents/Obfluence Home Lab/11_Claude-Memory/lessons-summary.md` and `/Users/codyliska/Library/Mobile Documents/iCloud~md~obsidian/Documents/Obfluence Home Lab/11_Claude-Memory/decisions-summary.md` — one-liner indexes that surface known pitfalls and prior decisions at a glance
4. Read `/Users/codyliska/Library/Mobile Documents/iCloud~md~obsidian/Documents/Obfluence Home Lab/11_Claude-Memory/conventions.md` and `/Users/codyliska/Library/Mobile Documents/iCloud~md~obsidian/Documents/Obfluence Home Lab/11_Claude-Memory/recurring-tasks.md` — coding standards and standing rules that apply to every session
5. If a project-level `CLAUDE.md` exists, it will load automatically — follow its instructions
6. **Do not** read lessons-learned.md, decisions-log.md, session-log.md, or stack-notes at startup — pull them on demand per the Vault Index below

### Trigger Checklist

You MUST follow these before acting — skipping them causes mistakes:

- **When debugging any issue:** you MUST check `lessons-summary.md` for a matching entry first — if found, load `lessons-learned.md` for the full fix before investigating
- **Before any architectural decision** (file structure, framework choice, pattern selection, dependency decisions): you MUST check `decisions-summary.md` first — if relevant, load `decisions-log.md` for full context before responding
- **When a bug is resolved after multiple attempts:** you MUST write to `lessons-learned.md` and update `lessons-summary.md` immediately — do not wait for wrap-up
- **When a significant technical decision is made:** you MUST write to `decisions-log.md` and update `decisions-summary.md` immediately — do not wait for wrap-up

---

## Vault Index — Read on Demand

These files exist in `/Users/codyliska/Library/Mobile Documents/iCloud~md~obsidian/Documents/Obfluence Home Lab/11_Claude-Memory/`. Read them **only** when the described trigger occurs:

| File                   | What it contains                                                                           | When to read it                                                                            |
| ---------------------- | ------------------------------------------------------------------------------------------ | ------------------------------------------------------------------------------------------ |
| `conventions.md`       | Coding standards (indentation, naming, error handling, framework patterns)                 | **Read at startup** (step 4 above)                                                         |
| `recurring-tasks.md`   | Standing rules: vault write triggers, wrap-up checklist, never-do list, platform reminders | **Read at startup** (step 4 above)                                                         |
| `lessons-summary.md`   | One-liner index of known bugs and fixes (category + brief description)                     | **Read at startup** (step 3 above) — you MUST also check this before debugging             |
| `lessons-learned.md`   | Full bugs and fixes log with details                                                       | When debugging and lessons-summary.md shows a relevant entry — load for the full fix       |
| `decisions-summary.md` | One-liner index of architectural decisions (category + brief description)                  | **Read at startup** (step 3 above) — you MUST also check this before any arch decision     |
| `decisions-log.md`     | Full architectural decisions log with rationale                                            | When making an architectural decision and decisions-summary.md shows a relevant entry      |
| `session-log.md`       | Full session history (append-only)                                                         | Only when asked about session history or when wrapping up (to avoid double-logging)        |
| `projects/index.md`    | All projects overview                                                                      | When asked about project status or during wrap-up                                          |
| `projects/[name].md`   | Per-project deep context                                                                   | When starting work on a specific project (project CLAUDE.md may reference this)            |
| `stack-notes/*.md`     | Framework reference (Vue, Node/Express/Mongo, React Native, Phaser, Python)                | When working with that specific framework and unsure of conventions                        |
| `windows-setup.md`     | Windows/WSL setup guide                                                                    | Only on Windows machines or when troubleshooting cross-platform issues                     |

---

## During Every Session

- Follow `conventions.md` standards (loaded at startup)
- Follow `recurring-tasks.md` rules (loaded at startup)
- Write to `lessons-learned.md` immediately when a bug is resolved after multiple attempts — do not wait until wrap-up
- Write to `decisions-log.md` immediately when a significant architectural decision is made — do not wait until wrap-up
- When learning something new and reusable about a tool or framework, suggest adding it to the relevant `stack-notes/` file
- Never read from or reference any credentials folder in the vault — that folder is off limits

### Subagent Delegation

Use subagents to keep exploration out of the main context window:

- **Vault reads for reference**: When you need to check a vault file for background context (not for an immediate code task), consider delegating to the `vault-reader` subagent — it reads the file in its own context and returns a summary
- **Codebase exploration**: Use the built-in Explore subagent for file discovery and code search
- **Test runs**: Delegate test execution to a subagent when test output would be large

### Compaction Awareness

- When you notice context is getting heavy (long debugging sessions, many file reads), proactively suggest `/compact` at natural breakpoints
- When compacting, preserve: (1) current task and requirements, (2) all file paths read or modified, (3) decisions made this session, (4) working state of anything in progress
- After compaction, re-read `session-state.md` to recover critical context

---

## Wrapping Up a Session

Wait for the user to say **"wrap up this session"**, then:

1. Update `/Users/codyliska/Library/Mobile Documents/iCloud~md~obsidian/Documents/Obfluence Home Lab/11_Claude-Memory/session-state.md` — overwrite with current session's working state snapshot
2. Prepend to `/Users/codyliska/Library/Mobile Documents/iCloud~md~obsidian/Documents/Obfluence Home Lab/11_Claude-Memory/session-log.md` (newest first) — note anything already written mid-session so it is not double-logged
3. Update `/Users/codyliska/Library/Mobile Documents/iCloud~md~obsidian/Documents/Obfluence Home Lab/11_Claude-Memory/projects/index.md` — reflect any status changes and today's date
4. Conditionally update `decisions-log.md` and `lessons-learned.md` if anything was not already written mid-session
5. Create or update the project file at `/Users/codyliska/Library/Mobile Documents/iCloud~md~obsidian/Documents/Obfluence Home Lab/11_Claude-Memory/projects/[project-name].md`
6. Update `CLAUDE.md` in the project root to reflect current state and next steps

---

## Vault Structure

```
11_Claude-Memory/
  CLAUDE.md              ← this file (global instructions)
  conventions.md         ← coding standards (read at startup)
  decisions-log.md       ← architectural decisions log (read when deciding)
  lessons-learned.md     ← bugs and gotchas log (read when debugging)
  recurring-tasks.md     ← standing rules (read at startup)
  session-log.md         ← full session history (read only at wrap-up)
  session-state.md       ← compact working state snapshot (read at session start)
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

- **Vault root:** `/Users/codyliska/Library/Mobile Documents/iCloud~md~obsidian/Documents/`
- **Memory root:** `/Users/codyliska/Library/Mobile Documents/iCloud~md~obsidian/Documents/Obfluence Home Lab/`
- **Projects root:** `/Users/codyliska/Library/Mobile Documents/iCloud~md~obsidian/Documents/Obfluence Home Lab/projects/`
- **Dev root:** `<your-dev-root>/`

---

## Off-Limits

- Never read, reference, or write to any credentials folder in the vault
- Never store API keys, passwords, tokens, or secrets in any memory bank file
- Never commit sensitive data to any project file
