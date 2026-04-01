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

### notion-template-market-research — `marketplace_type` config field for reference vs selling platforms
**Date:** 2026-03-31
**Decision:** Added `marketplace_type: Literal['selling', 'reference']` to marketplace config models. Orchestrator reads this via the CLI and gates stages 3-5 (gap/suggestion/enrich) for reference platforms. Notion Gallery set to `reference`.
**Reason:** Notion Gallery is a free curator platform — no sales counts, no reviews, no purchase intent. Running suggestion generation on it produces meaningless output (you can't sell there). Trend and description analysis (stages 1-2) are still valid signal.
**Alternatives considered:** A `--reference` CLI flag — rejected because it requires the caller to remember to pass it every time. Config-driven is automatic and self-documenting.

---

### notion-template-market-research — 529 OverloadedError retry strategy
**Date:** 2026-03-31
**Decision:** Added a custom retry loop in `ClaudeClient.call()` for 529 errors: 30s → 60s → 120s (3 attempts) using `asyncio.sleep`, independent of the Anthropic SDK's built-in retry.
**Reason:** The SDK's default retry uses 0.4–0.9s delays, which are useless for overload conditions. In a run with 100 products, the API became overloaded and 75 products failed because each retry gave up after less than 1.5 seconds total wait.
**Alternatives considered:** Increasing SDK `max_retries` — the SDK doesn't expose configurable retry delays for 529 specifically, only for connection errors. Custom loop was the only way to get meaningful wait times.

---

### notion-template-market-research — Notion Gallery category slugs used as `sort_types`
**Date:** 2026-03-30
**Decision:** `NotionGalleryMarketplace.supported_sort_types()` returns category slugs (`work`, `school`, `personal`, etc.) rather than sort orders. The `run_discovery` pipeline iterates `sort_types` generically — one discovery run per entry — so categories map cleanly without changing the pipeline interface.
**Reason:** MarketplaceBase uses `sort_types` as the iteration unit for discovery. Notion Gallery has no sort orders (only `?sort=popular`, always fixed) but does have distinct category pages. Reusing `sort_types` for categories avoids adding a new abstraction.
**Alternatives considered:** Adding a separate `categories` concept to MarketplaceBase (over-engineering for one marketplace); a single discoverer that loops all categories internally (hides parallelism opportunity, breaks the per-sort-type result structure).

---

### notion-template-market-research — `marketplace` column added to `Analysis` for per-marketplace checkpointing
**Date:** 2026-03-30
**Decision:** Added nullable `marketplace TEXT` column to the `analyses` table; `get_latest_analysis` and `save_analysis` both accept an optional `marketplace` param; all 4 aggregate stage functions pass `marketplace` through to `save_analysis`; orchestrator passes `marketplace` to all checkpoint lookups.
**Reason:** Without a marketplace filter, `get_latest_analysis('trend_analysis')` returned the Gumroad row when running `--marketplace notion_gallery`, causing stages 2-5 to be skipped as already-checkpointed. Each marketplace needs its own independent checkpoint chain.
**Alternatives considered:** Separate `analyses` tables per marketplace (too much schema sprawl); a `run_id` scoping approach (run IDs aren't stable enough across partial pipeline re-runs).

---

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

### notion-template-market-research — DB-first competitor enrichment (Fix 1)
**Date:** 2026-03-31
**Decision:** Removed `name` and `sales_count` from Claude's `competitor_snapshot` output schema. Claude now returns `competitor_analyses: [{their_weakness, your_advantage}]` indexed by position. Python merges these with real DB competitor dicts to build the final `competitor_json`.
**Reason:** Claude was hallucinating competitor names and sales counts (-1/0 values) even when real products were passed in the prompt. Removing the identifying fields from Claude's output schema eliminates the hallucination path entirely — Claude can only analyze products it was shown, not invent new ones.
**Alternatives considered:** Stricter prompt instructions only (Fix 2 approach — insufficient alone); post-processing validation to strip hallucinated entries (fragile, needs a ground truth list anyway).

---

### notion-template-market-research — `product_groups` table for cross-platform deduplication
**Date:** 2026-03-31
**Decision:** Used a `product_groups` + `product_group_members` join table with a `canonical_group_id` FK on `products`, rather than a self-referencing `canonical_product_id` FK on `products`.
**Reason:** Self-referencing FK creates directed graph chasing (A→B, B→C requires multi-hop resolution). Separate tables give clean group membership, aggregate queries (sum sales across members), and idempotent re-runs without touching canonical pointers.
**Alternatives considered:** Self-referencing FK on products (simpler schema but multi-hop resolution bugs); separate analyses tables per marketplace (too much schema sprawl).

---

### notion-template-market-research — Creative Market uses JS DOM extraction (not JSON blob)
**Date:** 2026-03-31
**Decision:** Discovery uses `page.evaluate(_EXTRACT_PRODUCTS_JS)` — a JS snippet that finds product `<a>` tags by URL pattern (`/{shop}/{6+digits}-{slug}`) and walks up the DOM for card data. Detail scraping uses JSON-LD (`extract_json_ld`).
**Reason:** Creative Market is SSR HTML with no Next.js `__NEXT_DATA__` or Inertia `data-page` blob. URL pattern matching is resilient to class name changes. JSON-LD on detail pages contains structured product data (SKU, price, sales count).
**Alternatives considered:** CSS selector-based HTML parsing (brittle to class name changes); network request interception to find a hidden API (none found).

---

### notion-template-market-research — Etsy uses httpx API (not Playwright)
**Date:** 2026-03-31
**Decision:** Etsy marketplace is implemented using the official Etsy v3 OpenAPI via httpx, not Playwright. Auth is keystring-only (`x-api-key` header). No browser session is created for Etsy — the CLI bypasses `_check_playwright()` for the Etsy path entirely.
**Reason:** DataDome bot protection on Etsy blocks all Playwright approaches: curl (836-byte challenge page), headless Playwright (1599-byte challenge), stealth Playwright (1599-byte challenge), even headed Playwright (1617-byte challenge). The official API returns real JSON immediately with a valid keystring.
**Alternatives considered:** playwright-stealth + residential proxies (complex, brittle, still uncertain); curl-cffi browser impersonation (third-party dep, uncertain longevity); session cookie harvesting from manual login (too fragile).

---

### notion-template-market-research — Etsy rating stats derived from fetched reviews
**Date:** 2026-03-31
**Decision:** `EtsyListing.rating_average` and `rating_count` are populated by `compute_rating_stats(reviews)` after fetching all reviews, not from the listing API response. The listing object does not include these fields in the v3 API.
**Reason:** The Etsy v3 `/listings/active` and `/listings/{id}` endpoints do not return aggregate rating data. The only way to get a rating average is to derive it from the paginated reviews endpoint.
**Alternatives considered:** Parsing the listing HTML page for the star rating (requires Playwright, which DataDome blocks); accepting `rating_average=None` for all Etsy products (would make Etsy products invisible in rating-ranked suggestions).

---

### notion-template-market-research — `most_recent` Gumroad sort type kept commented out
**Date:** 2026-04-01
**Decision:** Tested `most_recent` as a fourth Gumroad sort type — it is a valid sort (Gumroad accepted it, paginated 200 results) but returned 0 new products not already covered by `trending`, `best_sellers`, and `hot_and_new` with 4 queries running.
**Reason:** With 4 queries per sort type, the 3 existing sorts already surface the full discoverable product set. `most_recent` is redundant and adds scraping time with no coverage benefit.
**Alternatives considered:** Adding it anyway as a freshness signal — rejected because the DB already tracks `discovered_at` and the 0 new products result speaks for itself.

---

### notion-template-market-research — Tags stored as `tags_json TEXT` in products table
**Date:** 2026-03-30
**Decision:** `CanonicalProduct.tags: list[str]` is serialized to a JSON string (`tags_json`) in `_canonical_to_db_data()` before hitting SQLAlchemy; a `tags_json TEXT` column was added to the products table via the existing `_migrate()` mechanism
**Reason:** SQLAlchemy's ORM doesn't natively handle `list[str]` columns — passing the list directly causes a TypeError; centralized serialization in one helper (`_canonical_to_db_data`) means both discovery and detail scraping paths stay consistent
**Alternatives considered:** ORM hybrid property with JSON encode/decode (more magic, harder to reason about); storing as comma-separated string (loses structure)

---
