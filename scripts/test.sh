#!/usr/bin/env bash
# Fuehrt Tests aus und sammelt Fehlschlaege (kein Ausstieg beim ersten roten Check).
set -uo pipefail

fail=0

# dbt-Tests: nur wenn ein dbt-Projekt existiert.
if [ -f dbt_project.yml ]; then
  if command -v dbtf >/dev/null 2>&1; then
    # dbtf vorhanden -> echter Test. Rote dbt-Tests sind ein echtes FAIL.
    dbtf test || fail=1
  else
    # dbtf fehlt (z. B. lokal ohne dbt-Toolchain): sichtbare WARNUNG, KEIN FAIL,
    # sonst waere verify.sh dauerhaft rot und wuerde ignoriert. In CI ist dbt
    # installiert, dort greift der echte Test.
    echo "WARNUNG: dbt_project.yml vorhanden, aber dbtf ist nicht installiert." >&2
    echo "         dbt-Tests werden lokal UEBERSPRUNGEN (kein FAIL)." >&2
    echo "         dbt installieren oder DWH-Domaene entfernen (scripts/init-domain.sh)." >&2
  fi
fi

uv run python -m pytest || fail=1

exit $fail
