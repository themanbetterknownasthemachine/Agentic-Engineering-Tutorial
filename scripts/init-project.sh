#!/usr/bin/env bash
# Setup-Wizard: fragt die Kernwerte ab, ersetzt die Platzhalter in CLAUDE.md
# und den Docs und entfernt den .template-Marker.
# Empfohlener erster Schritt in einem neuen Projekt.
#
# Verwendung:
#   bash scripts/init-project.sh          (interaktiv, braucht ein Terminal)
#   printf 'Name\nBeschr\n...\n' | bash scripts/init-project.sh   (nicht-interaktiv)
# Ohne Terminal und ohne gepipte Antworten schlaegt `read` fehl - dann die
# Platzhalter stattdessen manuell fuellen (Checkliste in README.md).
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
PROJEKT="$(ask 'Kuerzel fuer Objektnamen (<PROJEKT>), z. B. WARENEINGANG')"
QUALITY_BAR="$(ask 'Quality-Bar (<QUALITY_BAR>), z. B. WAPE < 8% auf Holdout')"

# In-place-Ersetzung nur fuer nicht-leere Antworten. Trennzeichen | statt /,
# da Werte Slashes/Punkte enthalten koennen; & und | im Wert werden escaped.
FILES=(CLAUDE.md docs/architecture.md docs/runbooks/development.md)
replace() {  # replace TOKEN VALUE
  local token="$1" value="$2" esc
  [ -z "$value" ] && return 0
  # sed-Sonderzeichen in der Ersetzung entschaerfen: \ & | (Delimiter)
  esc="$(printf '%s' "$value" | sed -e 's/[\\&|]/\\&/g')"
  for f in "${FILES[@]}"; do
    [ -f "$f" ] || continue
    sed "s|$token|$esc|g" "$f" > "$f.tmp" && mv "$f.tmp" "$f"
  done
}

replace "<PROJECT_NAME>" "$PROJECT_NAME"
replace "<One-line description of what this repository does.>" "$DESCRIPTION"
replace "<STACK>" "$STACK"
replace "<DEV_SCHEMA>" "$DEV_SCHEMA"
replace "<INFERENCE_DB>" "$INFERENCE_DB"
replace "<INFERENCE_SCHEMA>" "$INFERENCE_SCHEMA"
replace "<PROJEKT>" "$PROJEKT"
replace "<QUALITY_BAR>" "$QUALITY_BAR"

# --- Projekt-README generieren ----------------------------------------------
# Die mitgelieferte README beschreibt das TEMPLATE ("Use this template",
# einmalige Einrichtung usw.) - in einem echten Projekt ist das Fremdinhalt.
# Daher hier durch eine schlanke Projekt-README ersetzen. Fallbacks sorgen dafuer,
# dass auch bei uebersprungenen Feldern etwas Sinnvolles im README steht.
readme_name="${PROJECT_NAME:-$(basename "$PWD")}"
readme_desc="${DESCRIPTION:-TODO: kurze Beschreibung des Projekts.}"
readme_stack="${STACK:-TODO: Stack eintragen (siehe docs/domain-setup/)}"

# Quoted-Heredoc (<<'EOF'): keine Shell-Interpretation, damit die Markdown-
# Backticks unversehrt bleiben. Werte danach ueber Tokens einsetzen.
cat > README.md <<'EOF'
# @@NAME@@

@@DESC@@

**Stack:** @@STACK@@

Dieses Projekt basiert auf dem Agentic-Engineering-Starter-Template. Die firmweiten
Regeln und Leitplanken liegen in `.claude/` und wirken automatisch; der dauerhafte
Projektkontext steht in [`CLAUDE.md`](CLAUDE.md).

## Setup

```bash
uv sync                     # Abhaengigkeiten installieren
cp .env.example .env        # Secrets eintragen (wird nie committet)
```

## Entwicklung

```bash
bash scripts/verify.sh      # alle Pruefungen (lint, tests, Verifier)
bash scripts/lint.sh        # Ruff + mypy
bash scripts/test.sh        # Tests
```

Die massgebliche Befehlsliste steht in [`CLAUDE.md`](CLAUDE.md).

## Arbeitsweise

Erst Spec, dann Verifier, dann implementieren lassen (in der Schleife gegen ein
pruefbares Erfolgssignal):

1. `/spec` — Spec nach `docs/specs/active/`
2. `/criteria` — Definition of Done in `CLAUDE.md`
3. Verifier bauen (`eval/eval_<thema>.py`; bei dbt: `dbtf test`)
4. Delegieren: bauen lassen, bis der Verifier gruen ist
5. `/review`, dann Freigabe und `/handover`

Details: [`docs/WORKFLOW.md`](docs/WORKFLOW.md) (Beispiel-Durchlauf) und
[`docs/HANDBUCH.md`](docs/HANDBUCH.md) (Struktur- und Konzeptreferenz).
EOF

# Tokens ersetzen; sed-Sonderzeichen in den Werten entschaerfen (Delimiter |).
esc_readme() { printf '%s' "$1" | sed -e 's/[\\&|]/\\&/g'; }
sed "s|@@NAME@@|$(esc_readme "$readme_name")|g; \
     s|@@DESC@@|$(esc_readme "$readme_desc")|g; \
     s|@@STACK@@|$(esc_readme "$readme_stack")|g" README.md > README.md.tmp \
  && mv README.md.tmp README.md
echo "README.md als schlanke Projekt-README neu generiert."

# --- Template-Governance-Dateien entfernen ----------------------------------
# docs/rollout/ (Schulungs-Agenda, Review-Arbeitsblatt) dient der EINFUEHRUNG des
# Templates im Team - in einem konkreten Projekt hat es nichts verloren.
if [ -d docs/rollout ]; then
  rm -rf docs/rollout
  echo "docs/rollout/ entfernt (Template-Einfuehrungsmaterial, nicht projektrelevant)."
fi

echo ""
echo "Noch manuell zu erledigen:"
echo "  - .mcp.json: REPLACE_WITH_YOUR_SNOWFLAKE_MCP_COMMAND ersetzen"
echo "    (bewusst nicht automatisch - Ersetzung in JSON ist zu fehleranfaellig)"
echo "  - .env aus .env.example anlegen; profiles.yml.example anpassen (DWH)"
echo ""

rm -f .template
echo ".template entfernt. Pruefe jetzt: bash scripts/check-template.sh"
