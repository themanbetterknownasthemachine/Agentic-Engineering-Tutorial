# Project: <PROJECT_NAME>

<One-line description of what this repository does.>

This is a Pistor BIDA data/ML project (dbt + Snowflake, Python forecasting, Power BI).
Keep this file concise (target < 200 lines). Detailed, path-specific conventions live in
`.claude/rules/` and load automatically; multi-step procedures live in `.claude/skills/`.

## Operating principle
Spec and verifier first, code second. Do not start coding without both.
- The human owns the spec (what should get better), the final judgment (is it deploy-ready?),
  and the understanding (what is happening technically).
- You own the implementation loop: write code, test it, read the failure, fix, repeat until
  the verifier passes.
For new work, run `/spec` and `/criteria` before implementing; see @docs/WORKFLOW.md.

## Technology
- Snowflake (Data Vault 2.0), dbt-core + dbt-snowflake, CLI: `dbtf`
- Python 3.12 (uv), pandas, scikit-learn, statsmodels, NeuralForecast, LightGBM
- Apache Airflow (orchestration), Power BI (consumption)
- Auth: Snowflake key-pair (`snowflake_jwt`). Dev schema: `DBT_BUT`.

## Architecture
- Transformations live in `models/` (dbt). Never write manual DDL in Snowsight.
- Time intelligence always via `DIM_DATE`; `AT = 1` = Pistor working-day logic.
- ML inference views: `BUT_LANDING.ML_INFERENCE.V_FORECAST_*`
- Detailed architecture: @docs/architecture.md

## Commands
- Install: `uv sync`
- Build + test (dbt): `dbtf build`
- Tests only: `dbtf test`
- Project verifier: `python eval/eval_<thema>.py` (contract + examples: `eval/README.md`)
- Lint + type check: `bash scripts/lint.sh`
- All checks: `bash scripts/verify.sh`

## Workflow
1. Understand the relevant models and existing tests first.
2. For larger work, propose a small spec in `docs/specs/active/` before coding (run `/spec`).
3. Make the smallest coherent change.
4. Add or update tests; run tests, lint, and type checks.
5. Summarize changed files and remaining risks.

## Non-negotiable rules
- IMPORTANT: never read, print, or modify `.env`, `*.p8`, or any credential files.
- IMPORTANT: never run `DROP`, `DELETE`, or `TRUNCATE` against Snowflake without explicit approval.
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

<!-- Maintainer note: this file is context, not enforcement. Hard blocks live in
     .claude/settings.json (permissions.deny) and .claude/hooks/protect-files.sh.
     This HTML comment is stripped before the file is injected into Claude's context. -->
