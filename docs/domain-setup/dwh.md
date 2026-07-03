# Domänen-Setup: Data Warehouse (dbt + Snowflake)

Einrichten: `bash scripts/init-domain.sh dwh` (entfernt die unten gelisteten Ordner),
danach Änderungen prüfen und committen.

## Behalten
- dbt-Stack: `models/`, `macros/`, `seeds/`, `snapshots/`, `tests/dbt/`,
  `dbt_project.yml`, `packages.yml`, `profiles.yml.example`, `.sqlfluff`
- `src/`, `tests/`, `eval/` - bleiben als Python-Grundgerüst, damit
  `scripts/verify.sh` durchläuft; **der Verifier der Domäne ist `dbtf test`**,
  ein eigenes Python-Eval ist nicht nötig (siehe `eval/README.md`)
- `scripts/`, `.claude/`, `docs/`

## Entfernt durch init-domain.sh
- `oracle/`, `dags/`, `notebooks/`

## Danach anpassen
- `profiles.yml.example` nach `~/.dbt/profiles.yml` kopieren und Werte setzen.
- Beispielmodelle (`stg_example__orders`, `mart_example__orders_daily`) durch
  echte Modelle ersetzen; Tests (`unique`/`not_null` auf dem Key) beibehalten.
- `CLAUDE.md`: Schemas, Rollen, Datenbanknamen eintragen.
