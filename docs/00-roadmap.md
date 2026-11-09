# Third Umpire: Cricket RAG + Stats Agent (progress tracker)

Historical Q&A over ball-by-ball data · rule book (MCC Laws + format playing conditions) · evidence-backed claim checking. No predictions or betting.

## Project principle (applies to every decision)
**Build with the tools and patterns that industry job descriptions ask for, and understand the concept behind each.** No project-specific workarounds when a standard tool or pattern exists. Every choice is recorded with the industry concept it demonstrates.

## Target stack (revised 2026-11-08)
| Layer | Tool / pattern | Industry concept |
|---|---|---|
| Data pipeline | ELT + medallion (bronze/silver/gold) with **dbt-core + dbt-duckdb** | Modular SQL models, lineage, data tests, docs |
| Analytical store | DuckDB | Columnar OLAP |
| RAG framework | **LangChain** (loaders, splitters, retrievers, chat models) | Standard RAG building blocks |
| Agent | **LangGraph** | Stateful agent graphs, tool calling, guard nodes |
| Vector DB | **Qdrant** (Docker locally; Qdrant Cloud free tier for deploy) | Hybrid dense+sparse search, RRF fusion, payload filtering |
| Re-ranking | Cross-encoder via LangChain | Two-stage retrieval |
| Structured Q&A | Text-to-SQL over gold marts, with guardrails | Structured + unstructured routing |
| LLM | Groq free tier (gpt-oss-120b) via `langchain-groq` | Provider-agnostic model integration |
| Evaluation | **RAGAS** + golden dataset | Faithfulness, context precision/recall |
| Observability | **Langfuse** | LLM tracing, cost/latency monitoring |
| API | FastAPI (async, Pydantic, streaming) | Production LLM serving |
| Packaging | Docker + docker-compose | Multi-service local stack |
| CI/CD | GitHub Actions → GHCR → Azure Container Apps | Automated test/eval gates and deploys |
| Stretch | Terraform/Bicep, Dagster/Prefect, Streamlit UI | IaC, orchestration, demo UI |

## Phase status
| Phase | Planned day | Status | Doc |
|---|---|---|---|
| 0. Setup | Day 1 | ✅ Complete | `phase-00-setup.md` |
| 1. Data acquisition and exploration | Day 1 | ✅ Complete | `phase-01-data.md` |
| 2. Data pipeline: dbt medallion on DuckDB | Day 2 | 🟡 Built; awaiting full run | `phase-02-stats-engine.md` |
| 3. Rules corpus → Qdrant (LangChain loaders/splitters) | Day 3 | ⚪ Pending | — |
| 4. Retrieval quality: custom vs default components, embedding fine-tune, hybrid, filters, re-rank, RAGAS | Day 4 | ⚪ Pending | — |
| 5. LangGraph agent: text-to-SQL, rules, claim tester, guardrails, Langfuse | Day 5 | ⚪ Pending | — |
| 6. FastAPI + docker-compose + end-to-end eval | Day 6 | ⚪ Pending | — |
| 7. CI/CD + Azure Container Apps deploy | Day 7 | ⚪ Pending | — |

## Decision log
| # | Date | Decision | Reason |
|---|---|---|---|
| D1 | 2026-11-07 | Name: Third Umpire | Reviews claims against evidence |
| D2 | 2026-11-07 | ~~Hand-rolled RAG core~~ → **superseded by D6** | |
| D3 | 2026-11-07 | Cricsheet as the match data source | Open licence; ESPNcricinfo prohibits scraping |
| D4 | 2026-11-07 | Host on Azure Container Apps | Monthly free grant persists; AWS Free plan closes after 6 months |
| D5 | 2026-11-07 | LLM: Groq free tier, gpt-oss-120b | Free, strong tool calling |
| D6 | 2026-11-08 | LangChain + LangGraph for RAG and agent | Most-requested frameworks in current AI/RAG job descriptions |
| D7 | 2026-11-08 | Qdrant replaces FAISS + hand-rolled BM25 | Industry vector DB; native hybrid search and payload filters; free self-host + free cloud tier |
| D8 | 2026-11-08 | dbt medallion (ELT) replaces the Python loader and custom checks | Standard data-transformation tool; data tests and lineage built in |
| D9 | 2026-11-08 | RAGAS for evaluation, Langfuse for tracing | Standard RAG eval metrics and LLM observability |
| D10 | 2026-11-08 | Frameworks for orchestration; core RAG components built by hand and plugged into LangChain interfaces (custom splitter, embeddings wrapper, retriever, re-ranker), each compared with the LangChain default in an ablation table | Shows framework fluency plus the ability to build and tune each component |
| D11 | 2026-11-08 | Fine-tune the embedding model (and optionally the re-ranker) on cricket-rules Q&A pairs; compare with the base model | Demonstrates model adaptation, not just API use |
| D12 | 2026-11-08 | dbt Core 1.12 rather than dbt v2 | v2 is new (Sept 2026) with DuckDB feature gaps; v1 is what most teams run |

## Budget-tier reference (for client proposals)
| Component | Tier 0 Free (ours) | Tier 1 Small client | Tier 2 Growth | Tier 3 Enterprise |
|---|---|---|---|---|
| LLM | Groq free, gpt-oss-120b | Cheap hosted API model | Strong router + cheap writer, caching | Azure OpenAI / Bedrock, private networking |
| Embeddings | bge-small local | bge-base / hosted small | Hosted large / multilingual | Fine-tuned |
| Vector store | FAISS file | Qdrant small / pgvector | Managed Qdrant / Pinecone / Azure AI Search | Azure AI Search / OpenSearch + RBAC |
| Re-ranker | MiniLM cross-encoder | bge-reranker-base | Hosted rerank API | Fine-tuned |
| Structured data | DuckDB | Postgres | Postgres + MVs / ClickHouse | Warehouse |
| Data source | Cricsheet + public docs | Same | Licensed data feed | Official partnership |
| Hosting | ACA scale-to-zero | ACA min 1 replica | Multi-replica + Redis | AKS, multi-region |
| Observability | Logs + JSONL traces | Langfuse | Langfuse/LangSmith + App Insights | Enterprise APM, audit |
| Evaluation | Own harness + LLM judge | + RAGAS/DeepEval | CI-gated evals | + human review |

## Changelog
| Date | Change |
|---|---|
| 2026-11-08 | Phase 2 rebuilt in dbt (58 checks, scale-tested). D10–D12 recorded. |
| 2026-11-08 | Stack revised to industry-standard tools (D6–D9); principle recorded. Phase 2 reworked as a dbt medallion pipeline. |
| 2026-11-08 | Phase 1 complete; Phase 2a ingestion code ready. |
| 2026-11-08 | Phase 0 complete. |
| 2026-11-07 | Plan created. Docs switched to progress-tracking only. |
