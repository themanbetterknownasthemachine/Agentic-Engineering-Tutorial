"""Minimales, idempotentes Beispiel-DAG (passend zu .claude/rules/airflow.md).

Zeigt die Pflichten aus den Regeln:
- keine Top-Level-Berechnungen (nur Imports und die DAG-Definition)
- backfill-safe: die Logik nutzt die logische Datenintervall-Grenze, nie now()
- idempotent: derselbe logische Tag erzeugt dasselbe Ergebnis
- catchup bewusst gesetzt, retries/alerting explizit
"""

from __future__ import annotations

from datetime import timedelta

import pendulum
from airflow.decorators import dag, task

DEFAULT_ARGS = {
    "retries": 2,
    "retry_delay": timedelta(minutes=5),
}


@dag(
    dag_id="example_dbt_daily",
    schedule="0 5 * * *",
    start_date=pendulum.datetime(2026, 1, 1, tz="Europe/Zurich"),
    catchup=False,  # bewusst gesetzt; fuer Backfill auf True stellen
    default_args=DEFAULT_ARGS,
    tags=["example", "dbt"],
)
def example_dbt_daily():
    @task
    def resolve_run_date(data_interval_end: pendulum.DateTime | None = None) -> str:
        # data_interval_end kommt aus dem Kontext -> backfill-safe, kein now().
        assert data_interval_end is not None
        return data_interval_end.to_date_string()

    @task
    def build_marts(run_date: str) -> None:
        # Platzhalter fuer den eigentlichen, idempotenten Schritt (z. B. dbtf build).
        # Idempotenz: Ziel per MERGE / --full-refresh je Partition, kein blindes INSERT.
        print(f"Baue Marts idempotent fuer {run_date} (Platzhalter).")

    build_marts(resolve_run_date())


example_dbt_daily()
