# Phase 0: Setup (progress tracker)

**Status:** 🟡 In progress
**Goal:** Reproducible environment, config module, tests, lint, Git repo.

## Checklist
- [x] System details confirmed (OS, RAM, existing tools)
- [x] PowerShell execution policy set for the current user
- [x] Package/env manager installed (uv 0.13.7)
- [ ] Folder structure created
- [ ] Python version pinned
- [ ] `pyproject.toml` written
- [ ] Environment created (dependencies installed)
- [ ] `config.py` + `__init__.py` written
- [ ] `.env` / `.env.example`
- [ ] `.gitignore` verified
- [ ] Tests written and passing
- [ ] Lint passing
- [ ] First commit pushed to GitHub

## User environment
| Item | Value |
|---|---|
| OS | Windows 10/11 |
| RAM | 16 GB |
| Shell | Windows PowerShell 5.1 (VS Code terminal) |
| Python | System: 3.14.4 (default, C:\Python314), 3.13, 3.10. Project will use uv-managed 3.12 |
| Execution policy | CurrentUser = RemoteSigned ✅ |
| Project path | `D:\New_folder_(2)\2026_new start\projects\RAG\third-umpire` (contains spaces: always quote) |
| Editor | VS Code + integrated terminal |
| Git / GitHub | Git installed (GitHub account to confirm) |
| Docker | Docker Desktop installed |
| uv | 0.13.7 standalone at C:\Users\harsh\.local\bin ✅ |

## Decisions
| # | Decision | Reason |
|---|---|---|

## Issues encountered
| Date | Issue | Fix |
|---|---|---|
| 2026-11-07 | Execution policy `Restricted` blocked scripts | `Set-ExecutionPolicy RemoteSigned -Scope CurrentUser` |
| 2026-11-07 | uv not installed | Standalone installer; restarted VS Code to pick up PATH |
| 2026-11-07 | Project folder already held the first reference zip (unzipped 21:40) | Kept the reference files to save time; verifying with `uv sync` + tests |

## Changelog
| Date | Change |
|---|---|
| 2026-11-07 | Environment confirmed; uv installed; execution policy set. |
| 2026-11-07 | Pace change: reuse the reference skeleton, verify, move on to Phase 1. |
| 2026-11-07 | Doc reset to progress-tracking only; guidance happens in chat. |
