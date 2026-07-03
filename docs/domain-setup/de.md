# Domänen-Setup: Data Engineering

Einrichten: `bash scripts/init-domain.sh de` (entfernt die unten gelisteten Ordner),
danach Änderungen prüfen und committen.

## Behalten
- `dags/` - Airflow-Orchestrierung (Kern der Domäne)
- dbt-Stack (`models/`, `dbt_project.yml`, ...) - falls Transformationen über dbt laufen
- `oracle/` - falls Oracle-Quellsysteme angebunden werden
- `src/` - Lade-/Hilfslogik in Python
- `eval/` - Verifier für Pipeline-Ergebnisse (z. B. Row-Counts, Freshness);
  für reine dbt-Strecken ist `dbtf test` der Verifier
- `tests/`, `scripts/`, `.claude/`, `docs/`

## Entfernt durch init-domain.sh
- `notebooks/`

## Danach anpassen
- Nicht gebrauchte Teile (z. B. `oracle/` ohne Oracle-Quelle, oder den dbt-Stack
  ohne dbt) manuell löschen.
- `CLAUDE.md`: Technology/Architecture auf den tatsächlichen Stack anpassen.
