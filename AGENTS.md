# Agent guide: <PROJECT_NAME>

<One-line description of what this repository does.>

Core context for ALL coding agents (Claude Code, Codex, VS-Code agents).
This file is the single source of truth for the shared core; CLAUDE.md imports
it and adds Claude-Code-specific context (rules, skills, hooks).

## Operating principle
Spec and verifier first, code second. Do not start coding without both.
- The human owns the spec (what should get better), the final judgment (is it deploy-ready?),
  and the understanding (what is happening technically).
- The agent owns the implementation loop: write code, test it, read the failure, fix,
  repeat until the verifier passes.

## Technology
> The stack below is the **default** (Snowflake + dbt). Trim or swap it per project
> — e.g. an Oracle project replaces the Snowflake/dbt lines and drops `models/`.
> Keep only what the project actually uses; see `docs/domain-setup/`.

- Data platform: Snowflake (Data Vault 2.0), dbt-core + dbt-snowflake, CLI: `dbtf`
  — **or** Oracle (see `.claude/rules/oracle.md`; no dbt/DIM_DATE there).
- Python 3.12 (uv), pandas, scikit-learn, statsmodels, NeuralForecast, LightGBM
- Apache Airflow (orchestration), Power BI (consumption)
- Auth (Snowflake): key-pair (`snowflake_jwt`). Dev schema: `DBT_BUT`.

## Architecture
> Platform-specific; applies to the default Snowflake stack. Adjust for the project's platform.

- Transformations live in `models/` (dbt). Never write manual DDL in Snowsight.
- Time intelligence always via `DIM_DATE`; `AT = 1` = Pistor working-day logic.
  (Snowflake-specific — does not apply to Oracle projects.)
- ML inference views: `BUT_LANDING.ML_INFERENCE.V_FORECAST_*`
- Optional domain folders (`powerbi/`, `oracle/`, `dags/`, `notebooks/`):
  see `docs/domain-setup/`.

## Commands
- Install: `uv sync`
- Build + test (dbt): `dbtf build`
- Tests only: `dbtf test`
- Project verifier: `python eval/eval_<thema>.py` (contract + examples: `eval/README.md`)
- Lint + type check: `bash scripts/lint.sh`
- All checks: `bash scripts/verify.sh`

## Workflow
1. Understand the relevant models and existing tests first.
2. For larger work, propose a small spec in `docs/specs/active/` before coding.
3. Make the smallest coherent change.
4. Add or update tests; run tests, lint, and type checks.
5. Summarize changed files and remaining risks.

## Non-negotiable rules
- IMPORTANT: never read, print, or modify `.env`, `*.p8`, or any credential files.
- IMPORTANT: never run `DROP`, `DELETE`, or `TRUNCATE` against a database without
  explicit approval.
- Never deploy an output that fails its verifier `eval/eval_<thema>.py` (exit != 0).
  For DWH work, `dbtf test` is the verifier.
- Schema changes go through a dbt model change, never ad-hoc DDL.
- Never delete failing tests to make the suite pass.
- Do not push or merge unless explicitly requested.

## Definition of done
A change is complete only when:
- relevant tests pass; lint passes; type checking passes;
- the project quality bar is met: <QUALITY_BAR>
  (define per project, e.g. for a forecast: MAPE/WAPE below threshold on holdout,
  bias near zero, no negative predictions, half-days checked);
- documentation is updated when behavior changes;
- no secrets or generated artifacts were committed.
