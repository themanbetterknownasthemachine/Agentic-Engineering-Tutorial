#!/usr/bin/env bash
# PostToolUse-Hook (Edit|Write): leichte Validierung nach Datei-Aenderungen. Nicht-blockierend.

py_bin=""
for c in python3 python py; do
  if "$c" -c "" >/dev/null 2>&1; then
    py_bin="$c"
    break
  fi
done
[ -z "$py_bin" ] && exit 0

file="$("$py_bin" "$(dirname "$0")/_file.py")"
case "$file" in
  *.py)  command -v ruff >/dev/null 2>&1 && ruff check "$file" || true ;;
  *.sql) command -v sqlfluff >/dev/null 2>&1 && sqlfluff lint "$file" || true ;;
esac
exit 0
