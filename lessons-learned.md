# Lessons Learned

> Hard-won knowledge from bugs, bad assumptions, and things that took too long to figure out. Claude should check this file when debugging and add entries when something notable is resolved.

---

## How to Use This File

- Add an entry any time a bug or problem took more than 30 minutes to solve
- Be specific — vague entries like "iCloud paths are weird" are less useful than the actual fix
- Tag each entry with the relevant tech so it's easy to scan

---

## Entry Format

```
### [Tag] — [Short Problem Title]
**Date:** YYYY-MM-DD
**Problem:** What went wrong
**Root cause:** Why it happened
**Fix:** What actually solved it
**Watch out for:** Any related gotchas to keep in mind
```

---

## Log

### [macOS] — iCloud Drive paths with spaces break terminal cd

**Date:** 2026-03-24
**Problem:** `cd` into Obsidian vault path failed with "too many arguments"
**Root cause:** iCloud Drive path contains spaces (e.g. `Mobile Documents`, vault name with spaces)
**Fix:** Wrap path in quotes: `cd "/Users/<your-username>/Library/Mobile Documents/iCloud~md~obsidian/Documents/<your-vault-name>"`
**Watch out for:** Any tool or script that constructs this path needs to escape spaces — check MCP config, shell scripts, and any automation that references the vault path

---
