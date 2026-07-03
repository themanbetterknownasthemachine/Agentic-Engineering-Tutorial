#!/usr/bin/env bash
# Fuehrt ALLE Pruefungen aus und steigt NICHT beim ersten roten Check aus.
# Fehlschlaege werden gesammelt; am Ende Gesamt-Exit != 0, wenn irgendetwas rot war.
# Dieser Exit-Code ist das Reward-Signal des Loops.
set -uo pipefail

fail=0

echo "== check-template =="
bash scripts/check-template.sh || fail=1

echo "== lint =="
bash scripts/lint.sh || fail=1

echo "== tests =="
bash scripts/test.sh || fail=1

echo "== Projekt-Verifier (eval/eval_*.py) =="
# Jedes eval/eval_*.py muss ohne Argumente lauffaehig sein (Kontrakt: eval/README.md);
# Beispiele unter eval/examples/ laufen bewusst nicht mit.
shopt -s nullglob
for verifier in eval/eval_*.py; do
  echo "Verifier: ${verifier}"
  uv run python "${verifier}" || fail=1
done
shopt -u nullglob

echo ""
if [ "$fail" -ne 0 ]; then
  echo "verify.sh: mindestens eine Pruefung ist FEHLGESCHLAGEN." >&2
  exit 1
fi
echo "verify.sh: alle Pruefungen durch."
