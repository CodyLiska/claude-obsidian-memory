# Decisions Log

> A running record of significant architectural and technical decisions across projects. Claude should append new entries here when a meaningful decision is made during a session.

---

## How to Use This File

- Each entry should answer: **what** was decided, **why**, and **what was considered but rejected**
- Claude should add an entry at the end of any session where a notable decision was made
- Keep entries concise — 3 to 5 lines is enough for most decisions

---

## Entry Format

```
### [Project Name] — [Short Decision Title]
**Date:** YYYY-MM-DD
**Decision:** What was decided
**Reason:** Why this choice was made
**Alternatives considered:** What else was evaluated and why it was rejected
```

---

## Log

### notion-template-market-research — Multi-query discovery via `discover_queries` list
**Date:** 2026-03-30
**Decision:** Replaced single `discover_query: str` config key with `discover_queries: list[str]`; one `GumroadDiscoverer` is created per query and all run sequentially per sort type
**Reason:** A single query misses templates that creators title differently ("second brain", "life OS", "notion planner") — they don't rank for "notion templates" but are real competitors
**Alternatives considered:** Per-sort-type query lists (unnecessary complexity); a single discoverer that loops queries internally (harder to parallelize later)

---

### notion-template-market-research — `has_more` computed from running totals, not server-echoed offset
**Date:** 2026-03-30
**Decision:** `parse_discover_props` now returns `(cards, results_total: int)` instead of `(cards, has_more: bool)`; `discover_sort` computes `has_more = total_fetched < results_total` using its own running count
**Reason:** The previous code relied on `inner.get('search_offset', 0)` being echoed back correctly by Gumroad's Inertia props — not guaranteed, and if it always returned 0 pagination would compute `has_more` incorrectly on every page after the first
**Alternatives considered:** Keep has_more in parser but pass the current offset as a parameter (still couples parser to discoverer state)

---

### notion-template-market-research — Dry-run rollback at end of `run_analysis`
**Date:** 2026-03-30
**Decision:** Added `session.rollback()` at the end of `run_analysis` when `client.dry_run=True`, wiping all flushes accumulated during the dry-run
**Reason:** The dry-run guard `if existing and not client.dry_run` only protected the checkpoint-load path — analysis functions still called `repo.save_analysis(session, ...)` which flushed to the DB, and `session.commit()` (both explicit and via `get_session` context manager) then persisted those records; subsequent real runs found all stages checkpointed and skipped everything, producing $0.00 cost and 0 products analyzed
**Alternatives considered:** Per-stage `if not client.dry_run: session.commit()` guards (fragile, must be maintained in every new stage); passing dry_run down to each repo function (too invasive)

---

### notion-template-market-research — Tags stored as `tags_json TEXT` in products table
**Date:** 2026-03-30
**Decision:** `CanonicalProduct.tags: list[str]` is serialized to a JSON string (`tags_json`) in `_canonical_to_db_data()` before hitting SQLAlchemy; a `tags_json TEXT` column was added to the products table via the existing `_migrate()` mechanism
**Reason:** SQLAlchemy's ORM doesn't natively handle `list[str]` columns — passing the list directly causes a TypeError; centralized serialization in one helper (`_canonical_to_db_data`) means both discovery and detail scraping paths stay consistent
**Alternatives considered:** ORM hybrid property with JSON encode/decode (more magic, harder to reason about); storing as comma-separated string (loses structure)

---
