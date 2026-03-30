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

### [Python / SQLAlchemy / Pydantic] — Dry-run flag didn't prevent DB writes in analysis orchestrator

**Date:** 2026-03-30
**Problem:** `notion-scout analyze --dry-run` estimated costs correctly but also wrote real checkpoint records to the DB (trend_analysis, gap_analysis, suggestions, enrichment). The subsequent real `analyze` run found everything already checkpointed and produced `$0.0000` cost and `products_analyzed=0`.
**Root cause:** The dry-run guard `if existing and not client.dry_run: continue` only skipped re-using *existing* checkpoints — it did not prevent new checkpoints from being written. Analysis functions called `repo.save_analysis(session, ...)` which flushed inserts, and `session.commit()` (both explicit mid-stage and implicitly by the `get_session` context manager at close) persisted them.
**Fix:** Added `if client.dry_run: session.rollback()` at the end of `run_analysis` before returning. This rolls back all flushes accumulated during the dry-run in a single call; the context manager's subsequent `session.commit()` then commits an empty transaction.
**Watch out for:** Any pipeline that uses a session-scoped dry-run flag needs the rollback *before* the session closes, not after. The `get_session` context manager commits on clean exit — a rollback inside the function body is the only reliable place to undo dry-run writes.

---

### [macOS] — iCloud Drive paths with spaces break terminal cd

**Date:** 2026-03-24
**Problem:** `cd` into Obsidian vault path failed with "too many arguments"
**Root cause:** iCloud Drive path contains spaces (e.g. `Mobile Documents`, vault name with spaces)
**Fix:** Wrap path in quotes: `cd "/Users/<your-username>/Library/Mobile Documents/iCloud~md~obsidian/Documents/<your-vault-name>"`
**Watch out for:** Any tool or script that constructs this path needs to escape spaces — check MCP config, shell scripts, and any automation that references the vault path

---
