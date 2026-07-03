#!/usr/bin/env bash
set -euo pipefail
# dbt-Tests nur, wenn ein dbt-Projekt existiert - dann aber ohne Fehler zu schlucken.
# verify.sh ist das Reward-Signal des Loops und darf nie faelschlich PASS liefern.
if [ -f dbt_project.yml ]; then
  dbtf test
fi
uv run pytest
