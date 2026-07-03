#!/usr/bin/env bash
# Fuehrt alle Pruefungen aus: lint, tests, projekt-spezifische Verifier.
# Exit != 0 wenn etwas fehlschlaegt - das ist das Reward-Signal des Loops.
set -euo pipefail
# Zuerst: sind alle Template-Platzhalter gefuellt? (im Template selbst ein No-op)
bash scripts/check-template.sh
bash scripts/lint.sh
bash scripts/test.sh
# Projekt-Verifier (Kontrakt: eval/README.md). Jedes eval/eval_*.py muss ohne
# Argumente lauffaehig sein; Beispiele unter eval/examples/ laufen bewusst nicht.
shopt -s nullglob
for verifier in eval/eval_*.py; do
  echo "Verifier: ${verifier}"
  uv run python "${verifier}"
done
shopt -u nullglob
echo "Alle Pruefungen durch."
