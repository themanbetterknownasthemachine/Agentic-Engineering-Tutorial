#!/usr/bin/env bash
# Fuehrt alle Lint-/Typecheck-Schritte aus und sammelt Fehlschlaege
# (kein Ausstieg beim ersten roten Check).
set -uo pipefail

fail=0
uv run ruff check . || fail=1
uv run ruff format --check . || fail=1
# python -m statt Entrypoint-Shim: die generierten *.exe-Launcher sind unsigniert
# und werden auf gehaerteten Windows-Clients (AppLocker/Smart App Control) geblockt.
uv run python -m mypy src eval || fail=1

exit $fail
