#!/usr/bin/env bash
set -euo pipefail
# dbt-Tests nur, wenn ein dbt-Projekt existiert - dann aber ohne Fehler zu schlucken.
# verify.sh ist das Reward-Signal des Loops und darf nie faelschlich PASS liefern.
if [ -f dbt_project.yml ]; then
  if ! command -v dbtf >/dev/null 2>&1; then
    echo "FEHLER: dbt_project.yml vorhanden, aber dbtf ist nicht installiert." >&2
    echo "Entweder dbt-Toolchain installieren oder die DWH-Domaene entfernen (scripts/init-domain.sh)." >&2
    exit 1
  fi
  dbtf test
fi
uv run python -m pytest
