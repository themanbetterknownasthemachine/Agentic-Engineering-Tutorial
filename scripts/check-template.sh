#!/usr/bin/env bash
# Prueft, ob im Projekt noch offene Template-Platzhalter stehen.
# Exit 0 = sauber (oder noch unkonfiguriertes Template), Exit 1 = offene Platzhalter.
#
# Solange die Marker-Datei .template existiert, ist dies das unkonfigurierte
# Template - Platzhalter sind dann erwartet und der Check passt. Ein neues Projekt
# entfernt .template (manuell oder via scripts/init-project.sh); ab dann wird
# erzwungen, dass keine Platzhalter mehr uebrig sind.
set -euo pipefail

if [ -f .template ]; then
  echo "check-template: .template vorhanden -> unkonfiguriertes Template, Platzhalter erwartet. OK."
  exit 0
fi

FILES=(CLAUDE.md .mcp.json)

# Konkrete Fill-in-Tokens (bewusst NICHT das generische Wort PLACEHOLDER,
# damit erklaerender Text nicht faelschlich anschlaegt).
TOKENS=(
  "<PROJECT_NAME>"
  "<STACK>"
  "<DEV_SCHEMA>"
  "<QUALITY_BAR>"
  "<INFERENCE_DB>"
  "<INFERENCE_SCHEMA>"
  "<LANDING_DB>"
  "<PROJEKT>"
  "<One-line description"
  "REPLACE_WITH_YOUR_SNOWFLAKE_MCP_COMMAND"
)

found=0
for f in "${FILES[@]}"; do
  [ -f "$f" ] || continue
  for t in "${TOKENS[@]}"; do
    if grep -Fq "$t" "$f"; then
      # -n fuer Zeilennummern, -F fuer festen String (spitze Klammern nicht als Regex)
      grep -Fn "$t" "$f" | sed "s|^|  ${f}:|"
      found=1
    fi
  done
done

if [ "$found" -ne 0 ]; then
  echo "" >&2
  echo "check-template: offene Platzhalter gefunden. Setup abschliessen" >&2
  echo "(README.md 'Pro Projekt anpassen' oder scripts/init-project.sh)." >&2
  exit 1
fi

echo "check-template: keine offenen Platzhalter. OK."
exit 0
