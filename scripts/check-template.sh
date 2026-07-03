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

# Konvention: Fill-in-Platzhalter sind <UPPER_SNAKE> in spitzen Klammern
# (z. B. <PROJECT_NAME>, <DEV_SCHEMA>, <QUALITY_BAR>). Neue Platzhalter dieser
# Form werden AUTOMATISCH erzwungen - keine Liste pflegen. Ausgenommen ist nur
# <PLACEHOLDER> selbst (generisches Wort im erklaerenden Text).
PLACEHOLDER_RE='<[A-Z][A-Z0-9_]+>'

# Bekannte Platzhalter, die der Konvention NICHT folgen (explizit ergaenzen):
EXTRA=(
  "REPLACE_WITH_YOUR_SNOWFLAKE_MCP_COMMAND"
  "<One-line description"
)

found=0
for f in "${FILES[@]}"; do
  [ -f "$f" ] || continue

  # Konventions-Tokens einsammeln, generisches <PLACEHOLDER> herausfiltern.
  tokens="$(grep -oE "$PLACEHOLDER_RE" "$f" | grep -vx '<PLACEHOLDER>' || true)"

  # Nicht-konforme, bekannte Platzhalter ergaenzen.
  for e in "${EXTRA[@]}"; do
    if grep -Fq "$e" "$f"; then
      tokens="${tokens}"$'\n'"${e}"
    fi
  done

  tokens="$(printf '%s\n' "$tokens" | sed '/^$/d' | sort -u)"
  [ -z "$tokens" ] && continue

  found=1
  while IFS= read -r t; do
    grep -Fn "$t" "$f" | sed "s|^|  ${f}:|"
  done <<< "$tokens"
done

if [ "$found" -ne 0 ]; then
  echo "" >&2
  echo "check-template: offene Platzhalter gefunden. Setup abschliessen" >&2
  echo "(README.md 'Pro Projekt anpassen' oder scripts/init-project.sh)." >&2
  exit 1
fi

echo "check-template: keine offenen Platzhalter. OK."
exit 0
