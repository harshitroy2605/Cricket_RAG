# Third Umpire 🏏

A cricket assistant built as a RAG engineering showcase:

1. **Historical Q&A** over ball-by-ball data (matches, players, teams, leagues, time ranges)
2. **Rule book** grounded in the MCC Laws of Cricket and format-specific playing conditions
3. **Claim checking**: tests a statement about the past against the data and shows the evidence

> ⚠️ Third Umpire describes the past. It does not predict match outcomes and is not for betting or fantasy games.

**Status:** Phase 0 (setup). See [`docs/00-roadmap.md`](docs/00-roadmap.md).

## Quick start

```bash
uv sync                  # creates .venv and installs deps
cp .env.example .env     # then fill in keys when a phase needs them
uv run pytest            # should pass
```

## Data attribution

Match data from [Cricsheet](https://cricsheet.org), used under its stated licence (attribution required).
The Laws of Cricket are © Marylebone Cricket Club. Playing conditions are © their issuing bodies.
This project indexes them for retrieval, shows short excerpts with citations, and links to the official sources.
