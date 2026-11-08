# Phase 1: Data acquisition and exploration (progress tracker)

**Status:** 🟡 In progress
**Goal:** Cricsheet match data + people register downloaded locally; JSON structure understood; licence noted.

## Checklist
- [ ] `scripts/download_data.py` run: `all_json.zip` + `people.csv` in `data/raw`
- [ ] Match count and download size recorded
- [ ] JSON structure explored (meta, info, innings → overs → deliveries)
- [ ] Data quirks listed (to drive the Phase 2 schema)
- [ ] Licence/attribution recorded in README

## Data facts
| Item | Value |
|---|---|
| Match files | — |
| Zip size | — |
| Formats present | — |
| Date range | — |

## Decisions
| # | Decision | Reason |
|---|---|---|
| P1-1 | Download with a Python script, not by hand | Reproducible; anyone can rebuild `data/raw` |
| P1-2 | Use the all-matches JSON bundle | One download covers every format/league; filter later in SQL |

## Issues encountered
| Date | Issue | Fix |
|---|---|---|

## Changelog
| Date | Change |
|---|---|
| 2026-11-07 | Download script written. |
