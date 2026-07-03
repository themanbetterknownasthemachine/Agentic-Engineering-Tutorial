#!/usr/bin/env bash
# Richtet das Template fuer eine Domaene ein, indem nicht benoetigte
# Domaenen-Ordner entfernt werden. Details: docs/domain-setup/<domaene>.md
#
# Verwendung: bash scripts/init-domain.sh <ml|de|dwh>
set -euo pipefail

usage() {
  echo "Verwendung: bash scripts/init-domain.sh <ml|de|dwh>" >&2
  echo "  ml  = ML / Data Science      (docs/domain-setup/ml.md)" >&2
  echo "  de  = Data Engineering       (docs/domain-setup/de.md)" >&2
  echo "  dwh = Data Warehouse (dbt)   (docs/domain-setup/dwh.md)" >&2
  exit 64
}

[ $# -eq 1 ] || usage

dbt_stack=(models macros seeds snapshots tests/dbt dbt_project.yml packages.yml profiles.yml.example .sqlfluff)

case "$1" in
  ml)  remove=("${dbt_stack[@]}" oracle) ;;
  de)  remove=(notebooks) ;;
  dwh) remove=(oracle dags notebooks) ;;
  *)   usage ;;
esac

echo "Domaene '$1': entferne nicht benoetigte Ordner/Dateien ..."
for p in "${remove[@]}"; do
  if [ -e "$p" ]; then
    echo "  - $p"
    git rm -r -q --ignore-unmatch -- "$p" 2>/dev/null || true
    rm -rf -- "$p"
  fi
done

echo ""
echo "Fertig. Naechste Schritte:"
echo "  1. Aenderungen pruefen (git status) und committen."
echo "  2. docs/domain-setup/$1.md lesen: was noch manuell anzupassen ist."
echo "  3. CLAUDE.md an den konkreten Stack anpassen."
