# Domänen-Setup: ML / Data Science

Einrichten: `bash scripts/init-domain.sh ml` (entfernt die unten gelisteten Ordner),
danach Änderungen prüfen und committen.

## Behalten
- `src/` - Trainings-/Inferenz-Code (z. B. `src/forecast/`)
- `eval/` - der Verifier ist hier Pflicht: Beispiel aus `eval/examples/` nach
  `eval/eval_<thema>.py` kopieren, Schwellen aus der Spec setzen
- `notebooks/` - Exploration
- `dags/` - Orchestrierung von Training/Inferenz (falls Airflow im Einsatz)
- `tests/`, `scripts/`, `.claude/`, `docs/`

## Entfernt durch init-domain.sh
- dbt-Stack: `models/`, `macros/`, `seeds/`, `snapshots/`, `tests/dbt/`,
  `dbt_project.yml`, `packages.yml`, `profiles.yml.example`, `.sqlfluff`
- `oracle/`

## Danach anpassen
- `CLAUDE.md`: Technology/Architecture auf den ML-Stack kürzen, `<QUALITY_BAR>` setzen.
- Nicht mehr passende Rules (`dbt-snowflake.md`, `oracle.md`) laden ohne
  ihre Pfade nie - können optional gelöscht werden.
