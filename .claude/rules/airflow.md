---
paths:
  - "dags/**"
---

# Airflow rules

- Tasks are idempotent: re-running the same logical date yields the same result
  (write via MERGE / partition overwrite, never blind appends).
- Backfill-safe: use the logical date from the data interval
  (`data_interval_start`/`data_interval_end`), never `datetime.now()` inside task logic.
- No top-level computation in DAG files: the scheduler parses them continuously;
  no DB calls, API calls, or heavy imports at module level.
- Define `retries` and alerting explicitly; failures must be visible, not swallowed.
- No secrets in DAG code: use Airflow Connections/Variables or the secrets backend.
- `catchup` is set consciously per DAG, never left to an implicit default.
