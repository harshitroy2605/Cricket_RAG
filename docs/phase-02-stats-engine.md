# Phase 2: Data pipeline, dbt medallion on DuckDB (progress tracker)

**Status:** 🟡 Built and verified in the dev workspace · ⏳ full build on the user's machine pending
**Goal:** Cricsheet JSON → bronze/silver/gold tables in DuckDB with dbt, fully tested.

## Checklist
- [x] dbt project `transform/` (dbt Core 1.12 + dbt-duckdb 1.11)
- [x] Bronze: typed JSON load with an explicit schema contract (`macros/cricsheet_schema.sql`)
- [x] Silver: 7 staging models (matches, registry, match_players, innings, deliveries, wickets, people)
- [x] Gold: dim_matches, dim_players, fct_deliveries, fct_batting_innings, fct_bowling_innings
- [x] Seeds: match_types, wicket_kinds, competition_aliases (partial)
- [x] 40 data tests + 4 singular tests + 1 unit test: 58/58 pass on the fixture
- [x] Scale test: 4,800 matches (~12M balls) in 88s at a 3 GB memory limit, 57/57 pass
- [x] pytest integration test runs dbt on the real fixture and checks the scorecard (4/4 pass)
- [ ] Full build on the user's machine (23,241 matches)
- [ ] Complete competition alias list from the distinct competition names

## Layers
| Layer | Models | Materialisation | Purpose |
|---|---|---|---|
| Bronze | bronze_matches, bronze_people | table | Raw, structure unchanged; rebuild source for everything |
| Silver | stg_* (+ ephemeral int_innings) | table | Typed, one grain per table, ids resolved, quirks handled |
| Gold | dim_*, fct_* | table | Analysis-ready; what text-to-SQL will query in Phase 5 |
| Reference | seeds | table | Business rules as data (format families, wicket rules, aliases) |

## Verification on the fixture (SA v AUS, Perth 2016)
| Check | Expected (real scorecard) | Got |
|---|---|---|
| Khawaja, 4th innings | 97 lbw | 97 lbw ✅ |
| Warner, 4th innings | 35 run out | 35 run out ✅ |
| Nevill, 4th innings | 60 not out | 60, not out ✅ |
| Rabada, 4th innings | 5/92 | 5/92 ✅ |

## Build results (user machine)
| Item | Value |
|---|---|
| Build time | — |
| DB size | — |
| Tests | — |

## Decisions
| # | Decision | Reason |
|---|---|---|
| P2-1 | DuckDB as the analytical store | Columnar OLAP, in-process, single file |
| P2-7 | dbt Core 1.12, not dbt v2 | v2 is 2 months old (Sept 2026) and has DuckDB feature gaps; most production teams still run v1; models port to v2 later |
| P2-8 | Bronze parsed once with an explicit schema | Re-parsing JSON text in each silver model ran out of memory at 5% of the data; a typed schema is also a data contract |
| P2-9 | Business rules in seeds (wicket_kinds, match_types) | Rules are data; a relationships test fails on unseen values |
| P2-10 | Stats derived per ball, not per over | The Hundred uses 5-ball overs |
| P2-11 | Super-over innings excluded from batting/bowling marts | Standard scoring convention |
| P2-12 | Memory limit and threads come from env vars (default 4 GB, 2 threads) | DuckDB spills to disk under the limit; the limit must sit well below physical RAM |
| P2-13 | Pipeline integration test in pytest | One command proves the whole pipeline end to end; reused in CI (Phase 7) |

## Issues encountered
| Date | Issue | Fix |
|---|---|---|
| 2026-11-08 | pyarrow can't cast date strings | Moot: Python loader retired |
| 2026-11-08 | OOM at 1,200 matches (JSON re-parsed per model) | Typed bronze via `read_json(columns=...)` |
| 2026-11-08 | OS killed the build at a 6 GB limit on a 7 GB machine | Configurable limit; verified at 3 GB |
| 2026-11-08 | `by` is a reserved word in struct definitions | Quote it: `"by"` |
| 2026-11-08 | DuckDB 2.0 deprecated `x -> expr` lambdas | `lambda x: expr` |
| 2026-11-08 | dbt unit test: empty mock input / uneven expected rows | One non-matching mock row; identical columns in every expected row |
| 2026-11-08 | DuckDB 2.0 removed `relation.fetchone()` | `con.execute(...).fetchone()` |

## Changelog
| Date | Change |
|---|---|
| 2026-11-08 | Rebuilt as a dbt medallion pipeline; Python loader removed; scale-tested; integration test added. |
| 2026-11-08 | Python loader retired in favour of dbt (D8). |
| 2026-11-08 | Phase 2a ingestion written (superseded). |
