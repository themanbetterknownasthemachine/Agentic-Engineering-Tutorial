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

## Failure policy per task

Declare the intended failure behaviour per task, explicitly and visible in the DAG code.
A bare `retries=3` is a default, not a decision.

- RETRY: transient failure (network, Snowflake timeout). Retry with backoff.
- FALLBACK: primary source or model unavailable. Use the defined alternative.
- SKIP: optional branch (e.g. enrichment). The pipeline continues, the gap is logged.
- REPAIR: validation failed. Correct the data, re-run the step once, then escalate.
- ESCALATE: plausibility bar violated. Alert a human, never retry automatically.
- STOP: budget or safety limit reached. Hard abort, no downstream task runs.

Why: without an explicit policy the "retry or escalate?" question gets answered ad hoc
per DAG. The expensive case is a task that succeeds technically but delivers implausible
numbers: a blind retry ships them, ESCALATE stops them.
