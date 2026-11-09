# Phase 1: Data acquisition and exploration (progress tracker)

**Status:** ✅ Complete
**Goal:** Cricsheet match data + people register downloaded locally; JSON structure understood; licence noted.

## Checklist
- [x] `scripts/download_data.py` run: `all_json.zip` + `people.csv` in `data/raw`
- [x] Match count and download size recorded
- [x] JSON structure explored (meta, info, innings → overs → deliveries)
- [x] Data quirks listed (to drive the Phase 2 schema)
- [ ] Licence/attribution recorded in README

## Data facts
| Item | Value |
|---|---|
| Match files | 23,241 |
| Zip size | 149.0 MB (`all_json.zip`); `people.csv` 1.2 MB |
| Formats present | T20 14,425 · ODI 3,237 · MDM 2,242 · ODM 2,094 · Test 923 · IT20 320 (male 18,527 / female 4,714; club 12,389 / international 10,852) |
| Date range | Test from 2001-12-19 · ODI from 2002-06-27 · T20 from 2005-02-17 · latest 2026-11-03 |
| Deliveries | 11,739,488 |
| Parse failures | 0 (single data_version 1.3.0) |
| People register | 18,698 people, 22 columns (Cricsheet id + other sites' ids) |

## Quirks found (drive the schema)
| Quirk | Count | Handling |
|---|---|---|
| Multi-day `dates` list | all multi-day | `start_date`, `end_date`, `n_days` |
| No `event` | 89 matches | `competition_raw` nullable |
| Sponsor-renamed competitions (e.g. NatWest T20 Blast / Vitality Blast / Vitality Blast Men) | many | Canonical competition alias table (Phase 2b) |
| `balls_per_over` = 5 (The Hundred) | 389 | Stats computed per ball, not per over |
| No `overs` limit in multi-day | 3,165 | `overs_limit` nullable |
| No winner: draw / no result / tie | 1,038 / 498 / 205 | `result` column; win % must handle |
| Tie-breaker `eliminator` / `bowl_out` | 110 / 2 | `eliminator` column |
| `method` D/L, VJD, Awarded | 1,027 / 5 / 5 | `method` column |
| `missing` data flag | 2,831 matches | `has_missing_data` + raw JSON |
| Super-over innings | 228 | `is_super_over`; excluded from normal stats |
| Forfeited innings (no overs) | 14 | `forfeited` |
| `non_boundary` 4s (run, not hit) | 1,323 | Excluded from boundary counts |
| Wides / no-balls | 205,569 / 58,851 | `is_legal_ball` |
| Retired hurt / retired not out | 467 / 45 | `is_dismissal` = false |
| Non-bowler wickets (run out etc.) | ~23k | `credited_to_bowler` |
| Two wickets on one delivery | 25 | Separate `wickets` table |
| Typo key `playeer_out` | 1 | Parser fallback + warning |
| `replacements` (impact/concussion subs) | 2,834 | Raw JSON kept |
| Registry ids for people and venues | 100% | Use ids, not names, as keys |

## Decisions
| # | Decision | Reason |
|---|---|---|
| P1-1 | Download with a Python script, not by hand | Reproducible; anyone can rebuild `data/raw` |
| P1-3 | Profile all files before designing the schema (`scripts/explore_data.py`) | Catch optional fields and rare events up front; avoid silent ingestion bugs |
| P1-2 | Use the all-matches JSON bundle | One download covers every format/league; filter later in SQL |

## Issues encountered
| Date | Issue | Fix |
|---|---|---|

## Changelog
| Date | Change |
|---|---|
| 2026-11-08 | Profiling complete (0 parse failures, 11.7M deliveries). Quirks table recorded. Phase 1 closed. |
| 2026-11-08 | Data downloaded (23,241 matches). Profiling script written and tested on a sample file. |
| 2026-11-07 | Download script written. |
