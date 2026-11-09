# Phase 0: Setup (progress tracker)

**Status:** ✅ Complete (commit 34c1608, pushed to github.com/harshitroy2605/Cricket_RAG, branch master)
**Goal:** Reproducible environment, config module, tests, lint, Git repo.

## Checklist
- [x] System details confirmed (OS, RAM, existing tools)
- [x] PowerShell execution policy set for the current user
- [x] Package/env manager installed (uv 0.13.7)
- [x] Folder structure created
- [x] Python version pinned
- [x] `pyproject.toml` written
- [x] Environment created (dependencies installed)
- [x] `config.py` + `__init__.py` written
- [x] `.env` / `.env.example`
- [x] `.gitignore` verified
- [x] Tests written and passing
- [x] Lint passing
- [x] First commit pushed to GitHub

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
| Git / GitHub | Git 2.52; repo harshitroy2605/Cricket_RAG (branch master) |
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
| 2026-11-07 | Project folder already held the first reference zip (unzipped 21:40) | Kept the reference files to save time; verified with `uv sync` + tests |
| 2026-11-08 | uv hardlink warning (cache on C:, project on D:) | `UV_LINK_MODE=copy` as a user env var |
| 2026-11-08 | Git LF→CRLF warnings | Added `.gitattributes` (`* text=auto eol=lf`) |

## Changelog
| Date | Change |
|---|---|
| 2026-11-07 | Environment confirmed; uv installed; execution policy set. |
| 2026-11-08 | Phase 0 verified on the user's machine: Python 3.12.16, 15 packages, 2 tests pass, ruff clean, pushed. |
| 2026-11-07 | Pace change: reuse the reference skeleton, verify, move on to Phase 1. |
| 2026-11-07 | Doc reset to progress-tracking only; guidance happens in chat. |
