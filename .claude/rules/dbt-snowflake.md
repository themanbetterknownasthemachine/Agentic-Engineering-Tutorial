---
paths:
  - "models/**"
  - "macros/**"
  - "seeds/**"
  - "snapshots/**"
  - "dbt_project.yml"
  - "packages.yml"
---

# dbt / Snowflake rules

Firm-stable conventions (identical across Pistor dbt/Snowflake projects). They live
here, not in CLAUDE.md, so they load path-bound and stay project-independent.

## Tooling
- dbt CLI is `dbtf` (Pistor wrapper): `dbtf build`, `dbtf test`, `dbtf run-operation`.
- Snowflake auth is key-pair (`authenticator: snowflake_jwt`); never passwords.
  Profile template: `profiles.yml.example` (values from env vars).

## dbt conventions
- Staging models: `stg_<source>__<entity>` (double underscore); marts: `mart_<bereich>__<thema>`.
- Column names UPPER_SNAKE_CASE. No `SELECT *`.
- Every mart/output table needs a `not_null` + `unique` test on its key (schema.yml).
- Transformations in dbt only; never manual DDL in Snowsight. Schema changes go
  through a dbt model change.
- `dbtf test` is the verifier for DWH work; keep it green.

## Snowflake specifics
- Time intelligence always via DIM_DATE; `AT = 1` = Pistor working-day logic.
- CSV file formats: use `DATE_FORMAT`, not `DATE_INPUT_FORMAT`.
- Large loads: Stage + `COPY INTO` (Snowsight "Load Data" ignores custom file formats).

## Layer model (Pistor data architecture)
Firm-wide layered flow (Data Vault 2.0). Full reference + diagram: `docs/datenarchitektur.md`.
Source systems → Landing (temp) → Data Lake (persistent) / Staging (temp) → Raw Vault +
Business Vault (Hub/Link/Satellite) → Consumption generic (persistent tables) →
Consumption Dataset (virtual views) → Tabular Model → Report. Orchestration: Airflow.

- Consumption generic: persistent tables, generic names without report reference (`Dim_Kunde`).
- Consumption Dataset: virtual views, dataset-specific names with a report prefix
  (`SMB_Dim_Kunde`), plus filtering of unauthorized data.
- Build each transformation in the layer where it belongs; never skip layers with ad-hoc DDL.

> Draft: the exact prefix scheme and how these consumption names map to dbt model names
> (`stg_`/`mart_`) are TO BE CONFIRMED in the Phase-B dbt workshop — not final yet.
