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
> Fill the `<PLACEHOLDER>` values for your project and keep only the tools you use.
> Only the language/tooling line is required for every project; the rest is per-domain.
> See `docs/domain-setup/`.

- Language/tooling (all projects): Python 3.12 (uv), Ruff, mypy, pytest.
- Data platform (choose one): Snowflake + dbt (`.claude/rules/dbt-snowflake.md`)
  or Oracle (`.claude/rules/oracle.md`).
- Forecasting (ML projects only): pandas, scikit-learn, statsmodels,
  NeuralForecast, LightGBM — keep only what you actually use.
- Orchestration (optional): Apache Airflow (`dags/`, `.claude/rules/airflow.md`).
- Consumption (optional): Power BI (`powerbi/`, `.claude/rules/dax.md`).
- Dev schema: `<DEV_SCHEMA>`

## Architecture
> Fill the `<PLACEHOLDER>` values; adjust for the project's platform. Firm-stable
> dbt/Snowflake conventions (DIM_DATE/AT=1, COPY INTO, naming, `dbtf`, key-pair auth)
> are NOT repeated here — they live in `.claude/rules/dbt-snowflake.md` (load path-bound).

- Transformations live in `models/` (dbt); never hand-write DDL in the warehouse UI.
- ML inference objects: `<INFERENCE_DB>.<INFERENCE_SCHEMA>.V_<PROJEKT>_*`
- Optional domain folders (`powerbi/`, `oracle/`, `dags/`, `notebooks/`):
  see `docs/domain-setup/`.
- Detailed architecture: `docs/architecture.md`

## Commands
- Install: `uv sync`
- Project verifier: `python eval/eval_<thema>.py` (contract + examples: `eval/README.md`)
- Lint + type check: `bash scripts/lint.sh`
- All checks: `bash scripts/verify.sh`
- Template check (open placeholders): `bash scripts/check-template.sh`
- dbt (DWH only): `dbtf build`, `dbtf test` (see `.claude/rules/dbt-snowflake.md`)

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
