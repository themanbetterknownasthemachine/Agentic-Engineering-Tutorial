#!/usr/bin/env bash
# Setup-Wizard: fragt die Kernwerte ab, ersetzt die Platzhalter in CLAUDE.md,
# AGENTS.md und .mcp.json und entfernt den .template-Marker.
# Empfohlener erster Schritt in einem neuen Projekt.
#
# Verwendung: bash scripts/init-project.sh   (interaktiv)
set -euo pipefail

if [ ! -f .template ]; then
  echo "Kein .template-Marker - Projekt scheint bereits initialisiert. Abbruch." >&2
  exit 1
fi

ask() {  # ask "Frage" "default"
  local prompt="$1" default="${2:-}" answer
  if [ -n "$default" ]; then
    read -r -p "$prompt [$default]: " answer
    echo "${answer:-$default}"
  else
    read -r -p "$prompt: " answer
    echo "$answer"
  fi
}

echo "Projekt-Setup. Leerlassen ueberspringt das Feld (Platzhalter bleibt)."
PROJECT_NAME="$(ask 'Projektname (<PROJECT_NAME>)')"
DESCRIPTION="$(ask 'Einzeilige Beschreibung')"
STACK="$(ask 'Stack (<STACK>), z. B. dbt + Snowflake, Python forecasting')"
DEV_SCHEMA="$(ask 'Dev-Schema (<DEV_SCHEMA>), z. B. DBT_ABC')"
INFERENCE_DB="$(ask 'Inferenz-DB (<INFERENCE_DB>)')"
INFERENCE_SCHEMA="$(ask 'Inferenz-Schema (<INFERENCE_SCHEMA>)')"
QUALITY_BAR="$(ask 'Quality-Bar (<QUALITY_BAR>), z. B. WAPE < 8% auf Holdout')"

# In-place-Ersetzung nur fuer nicht-leere Antworten. Trennzeichen | statt /,
# da Werte Slashes/Punkte enthalten koennen.
FILES=(CLAUDE.md AGENTS.md docs/architecture.md docs/runbooks/development.md)
replace() {  # replace TOKEN VALUE
  local token="$1" value="$2"
  [ -z "$value" ] && return 0
  for f in "${FILES[@]}"; do
    [ -f "$f" ] || continue
    # BSD/GNU sed kompatibel: temporaere Datei
    sed "s|$token|$value|g" "$f" > "$f.tmp" && mv "$f.tmp" "$f"
  done
}

replace "<PROJECT_NAME>" "$PROJECT_NAME"
replace "<One-line description of what this repository does.>" "$DESCRIPTION"
replace "<STACK>" "$STACK"
replace "<DEV_SCHEMA>" "$DEV_SCHEMA"
replace "<INFERENCE_DB>" "$INFERENCE_DB"
replace "<INFERENCE_SCHEMA>" "$INFERENCE_SCHEMA"
replace "<QUALITY_BAR>" "$QUALITY_BAR"

echo ""
echo "Noch manuell zu erledigen:"
echo "  - .mcp.json: REPLACE_WITH_YOUR_SNOWFLAKE_MCP_COMMAND ersetzen"
echo "  - .env aus .env.example anlegen; profiles.yml.example anpassen (DWH)"
echo "  - verbliebene Platzhalter (z. B. V_<PROJEKT>_*) fuellen"
echo ""

rm -f .template
echo ".template entfernt. Pruefe jetzt: bash scripts/check-template.sh"
