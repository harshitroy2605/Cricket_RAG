# Third Umpire: Cricket RAG + Stats Agent (progress tracker)

Historical Q&A over ball-by-ball data · rule book (MCC Laws + format playing conditions) · evidence-backed claim checking. No predictions or betting.

## Phase status
| Phase | Planned day | Status | Doc |
|---|---|---|---|
| 0. Setup | Day 1 | 🟡 In progress | `phase-00-setup.md` |
| 1. Data acquisition and exploration | Day 1 | 🟡 In progress | `phase-01-data.md` |
| 2. Stats engine (DuckDB) | Day 2 | ⚪ Pending | — |
| 3. Rules corpus | Day 3 | ⚪ Pending | — |
| 4. Retrieval (hybrid + re-rank) | Day 4 | ⚪ Pending | — |
| 5. Agent and guardrails | Day 5 | ⚪ Pending | — |
| 6. API and evaluation | Day 6 | ⚪ Pending | — |
| 7. Deploy (Azure Container Apps) | Day 7 | ⚪ Pending | — |

## Decision log
| # | Date | Decision | Reason |
|---|---|---|---|
| D1 | 2026-11-07 | Name: Third Umpire | Reviews claims against evidence |
| D2 | 2026-11-07 | Hand-rolled RAG core (no LangChain/LlamaIndex) | Showcase depth |
| D3 | 2026-11-07 | Cricsheet as the match data source | Open licence; ESPNcricinfo prohibits scraping |
| D4 | 2026-11-07 | Host on Azure Container Apps | Monthly free grant persists; AWS Free plan closes after 6 months |
| D5 | 2026-11-07 | LLM: Groq free tier, gpt-oss-120b | Free, strong tool calling |

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
| 2026-11-07 | Plan created. Docs switched to progress-tracking only. |
