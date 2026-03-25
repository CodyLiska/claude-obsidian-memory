# Recurring Tasks

> Things Claude should always do or check regardless of project.
> These are standing rules that apply across every session.

---

## Before Starting Work

- Check `lessons-learned.md` before debugging — the fix may already be documented
- Check if a `.env.example` exists before assuming env var names — never guess secrets
- If the project has a test suite, run it before making changes to confirm baseline
- If `package.json` or `requirements.txt` exists, check it to understand dependencies before suggesting new ones

---

## While Working — Write to the Vault Immediately When These Occur

Do not wait until wrap-up for these — write them as soon as they happen:

- **Bug resolved after multiple attempts** → immediately append to `lessons-learned.md` and tell Cody: "I've logged this to lessons-learned.md"
- **Architectural or technical decision made** → immediately append to `decisions-log.md` and tell Cody: "I've logged this decision to decisions-log.md"
- **New reusable pattern or tool knowledge gained** → flag it to Cody: "This might be worth adding to stack-notes — want me to log it?"
- **Something surprising or non-obvious discovered** → flag it to Cody before moving on

Entry format for immediate lessons-learned write:

```
### [Tag] — [Short Problem Title]
**Date:** YYYY-MM-DD
**Problem:** What went wrong
**Root cause:** Why it happened
**Fix:** What actually solved it
**Watch out for:** Any related gotchas
```

Entry format for immediate decisions-log write:

```
### [Project Name] — [Short Decision Title]
**Date:** YYYY-MM-DD
**Decision:** What was decided
**Reason:** Why this choice was made
**Alternatives considered:** What else was evaluated and why it was rejected
```

---

## Before Wrapping Up

- Confirm any new files created are in the right location
- If new env vars were added, update `.env.example` if one exists
- If the project has a test suite, confirm it still passes
- If a new dependency was added, confirm it's in `package.json` or `requirements.txt`
- Update `CLAUDE.md` in the project root to reflect current state and next steps
- Update `projects/index.md` with current status and today's date
- Create or update `11_Claude-Memory/projects/[project-name].md`
- Append to `session-log.md` — note anything already written mid-session so it's not double-logged

---

## Never Do

- Never read, reference, or write to `99_Credentials/` in the Obsidian vault
- Never store API keys, passwords, or tokens in any memory bank file
- Never run `rm -rf` without confirming the exact path first
- Never push to `main` or `master` directly — always suggest a branch
- Never install global npm packages without flagging it — use local installs
- Never assume a port is free — check before starting a server

---

## Platform Reminders

- **iCloud paths** always have spaces — quote them in any shell command
- **WSL** cannot access iCloud Drive — run Claude Code from Windows Terminal for vault access
- **macOS** — use `python3` not `python`, `brew` for system tools
- **Windows** — use PowerShell not CMD where possible, `%USERPROFILE%` not `~` in some contexts
