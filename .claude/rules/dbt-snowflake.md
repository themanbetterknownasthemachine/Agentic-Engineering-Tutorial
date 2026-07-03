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
