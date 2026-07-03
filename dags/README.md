# dags/ - Airflow-DAGs

Orchestrierung (Laden, dbt-Laeufe, Training, Inferenz) als Airflow-DAGs.

- Regeln (Idempotenz, Backfill, keine Top-Level-Berechnungen):
  `.claude/rules/airflow.md` (laedt automatisch fuer diesen Ordner).
- Ein DAG pro Datei; Dateiname = DAG-Id.

Wird dieser Ordner im Projekt nicht gebraucht: `bash scripts/init-domain.sh <domaene>`
entfernt ihn (siehe `docs/domain-setup/`).
