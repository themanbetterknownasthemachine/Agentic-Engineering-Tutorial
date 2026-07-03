#!/usr/bin/env bash
# new-ml-project.sh — automatisiertes Setup eines neuen ML-Projekts aus diesem Template.
#
# Ersetzt die manuellen Schritte 1-4 der README-Checkliste fuer ML-Projekte:
# fragt vier Kernwerte ab, dann laeuft alles automatisch: Domaene einrichten,
# CLAUDE.md-Platzhalter fuellen, Methoden-Skill+Notebook aus dem BIDA-ML-Starter
# ziehen, ml-Dependencies installieren, Checks laufen lassen.
#
# Benoetigt: bash, git, uv. Sonst keine externen Abhaengigkeiten.
# Laeuft nur im ungefuellten Template (.template-Marker vorhanden).
set -euo pipefail

# --- Konstanten --------------------------------------------------------------
BML_URL="https://github.com/themanbetterknownasthemachine/BIDA-ML-Starter.git"
BML_TMP="/tmp/bml-setup"

step() { printf '→ %s' "$1"; }
ok() { printf '  \xe2\x9c\x93\n'; }
die() {
  printf '\nFEHLER: %s\n' "$1" >&2
  exit 1
}

# --- A) Abfragen -------------------------------------------------------------
read -r -p "Projektname (z. B. forecast-warengruppe-x): " PROJECT_NAME
read -r -p "Dev-Schema (z. B. DBT_XYZ): " DEV_SCHEMA
read -r -p "ML-Typ? [forecast / classification / regression / all]: " ML_TYPE
read -r -p "Snowflake als Datenquelle? [j/n]: " USE_SNOWFLAKE

PROJECT_NAME="${PROJECT_NAME// /}"
[ -n "$PROJECT_NAME" ] || die "Projektname darf nicht leer sein."
[ -n "$DEV_SCHEMA" ] || die "Dev-Schema darf nicht leer sein."
case "$ML_TYPE" in
  forecast | classification | regression | all) ;;
  *) die "Ungueltiger ML-Typ '$ML_TYPE' (forecast|classification|regression|all)." ;;
esac
case "$USE_SNOWFLAKE" in
  j | J | ja | y | Y) USE_SNOWFLAKE=j ;;
  n | N | nein) USE_SNOWFLAKE=n ;;
  *) die "Bitte j oder n fuer Snowflake angeben." ;;
esac

# --- B1) Template-Marker pruefen (Skript laeuft nur im ungefuellten Template) -
step "Pruefe .template-Marker"
[ -f .template ] || die "Kein .template-Marker gefunden. Dieses Skript laeuft nur im ungefuellten Template, nicht in einem bereits eingerichteten Projekt."
ok

# --- B2) Domaene einrichten --------------------------------------------------
step "init-domain.sh ml"
bash scripts/init-domain.sh ml >/dev/null
ok

# --- B3) CLAUDE.md-Platzhalter ersetzen -------------------------------------
step "CLAUDE.md: <PROJECT_NAME>, <DEV_SCHEMA>"
esc() { printf '%s' "$1" | sed -e 's/[&/\]/\\&/g'; }
sed -i "s/<PROJECT_NAME>/$(esc "$PROJECT_NAME")/g; s/<DEV_SCHEMA>/$(esc "$DEV_SCHEMA")/g" CLAUDE.md
ok

# --- B4) Methoden-Skill + Notebook aus dem BIDA-ML-Starter ------------------
# Skill und Notebook sind ein Paar und werden immer gemeinsam kopiert.
# Quell-/Zielpfade sind identisch mit der Tabelle in docs/domain-setup/ml.md.
step "Klone BIDA-ML-Starter -> $BML_TMP"
rm -rf "$BML_TMP"
git clone --depth 1 --quiet "$BML_URL" "$BML_TMP"
ok

copy_pair() {
  # $1 Skill-Quelle (im BML-Repo)   $2 Notebook-Quelle (im BML-Repo)   $3 Skillname
  local skill_src="$1" nb_src="$2" name="$3"
  local skill_dst=".claude/skills/${name}/SKILL.md"
  local nb_dst="notebooks/$(basename "$nb_src")"

  step "Skill+Notebook-Paar '${name}'"
  [ -f "${BML_TMP}/${skill_src}" ] || die "Skill-Quelle ${skill_src} nicht im BIDA-ML-Starter gefunden."
  [ -f "${BML_TMP}/${nb_src}" ] || die "Notebook-Quelle ${nb_src} nicht im BIDA-ML-Starter gefunden."
  mkdir -p ".claude/skills/${name}" notebooks

  # Kurzbeschreibung = erste inhaltliche Zeile (keine Ueberschrift, nicht leer).
  local desc
  desc="$(grep -m1 -E '^[^#[:space:]]' "${BML_TMP}/${skill_src}" || true)"
  [ -n "$desc" ] || desc="Methodik aus dem BIDA-ML-Starter (${name})."
  desc="${desc//\\/}"
  desc="${desc//\"/}"

  # Frontmatter (Format wie bestehende Skills dieses Repos) + Original-Inhalt.
  {
    printf -- '---\n'
    printf 'name: %s\n' "$name"
    printf 'description: "%s"\n' "$desc"
    printf -- '---\n\n'
    cat "${BML_TMP}/${skill_src}"
  } >"$skill_dst"

  cp "${BML_TMP}/${nb_src}" "$nb_dst"
  ok
}

case "$ML_TYPE" in
  forecast) copy_pair "skills/FORECASTING_SKILL.md" "notebooks/02_forecasting.ipynb" "forecasting" ;;
  classification) copy_pair "skills/CLASSIFICATION_SKILL.md" "notebooks/03_classification.ipynb" "classification" ;;
  regression) copy_pair "skills/REGRESSION_SKILL.md" "notebooks/04_regression.ipynb" "regression" ;;
  all)
    copy_pair "skills/FORECASTING_SKILL.md" "notebooks/02_forecasting.ipynb" "forecasting"
    copy_pair "skills/CLASSIFICATION_SKILL.md" "notebooks/03_classification.ipynb" "classification"
    copy_pair "skills/REGRESSION_SKILL.md" "notebooks/04_regression.ipynb" "regression"
    ;;
esac

step "Raeume $BML_TMP auf"
rm -rf "$BML_TMP"
ok

# --- B5) Snowflake optional --------------------------------------------------
if [ "$USE_SNOWFLAKE" = "n" ]; then
  step "Ohne Snowflake: src/data_loader.py + src/config.py -> src/snowflake/"
  mkdir -p src/snowflake
  for f in data_loader.py config.py; do
    [ -f "src/$f" ] && mv "src/$f" "src/snowflake/$f"
  done
  cat >src/snowflake/README.md <<'EOF'
# Snowflake-Bausteine (nicht aktiv)

Dieses Projekt wurde ohne Snowflake als Datenquelle eingerichtet. `data_loader.py`
und `config.py` stammen aus dem BIDA-ML-Starter und wurden hierher verschoben.
Bei Snowflake-Bedarf zurueck nach `src/` schieben; sonst durch einen eigenen
Loader fuer die tatsaechliche Datenquelle ersetzen.
EOF
  ok
  echo "  Hinweis: snowflake-* Pakete der ml-Group werden fuer dieses Projekt nicht"
  echo "           benoetigt und koennen aus pyproject.toml (Group 'ml') entfernt werden."
fi

# --- B6) Dependencies installieren -------------------------------------------
step "uv sync --group ml"
uv sync --group ml
ok

# --- B7) Template-Check ------------------------------------------------------
step "check-template.sh"
if ! bash scripts/check-template.sh; then
  die "check-template.sh meldet offene Platzhalter — Setup pruefen."
fi
ok

# --- B8) Verifier ------------------------------------------------------------
echo "→ verify.sh …"
if ! bash scripts/verify.sh; then
  echo "" >&2
  echo "HINWEIS: verify.sh rot — Setup pruefen, dann manuell erneut ausfuehren." >&2
fi

# --- B9) Abschluss -----------------------------------------------------------
cat <<EOF

✓ ML-Projekt "${PROJECT_NAME}" ist bereit.

Naechste Schritte in Claude Code:
  1. /spec          -> Problem beschreiben, Spec entsteht in docs/specs/active/
  2. /criteria      -> Definition of Done + Quality-Bar setzen
  3. eval/examples/eval_baseline_beat.py nach eval/eval_<thema>.py kopieren,
     <QUALITY_BAR> eintragen, einmal laufen lassen (bewusst rot — kein Modell da)
  4. Delegieren: "Implementiere gemaess Spec. Fertig wenn
     python eval/eval_<thema>.py und bash scripts/verify.sh gruen sind."
  5. /review        -> deine finale Bewertung

Manuelle Nacharbeit: Frontmatter in .claude/skills/*/SKILL.md (name/description)
pruefen und verfeinern; restliche <PLATZHALTER> in CLAUDE.md via /spec, /criteria.
EOF
