#!/usr/bin/env bash
set -euo pipefail
uv run ruff check .
uv run ruff format --check .
# python -m statt Entrypoint-Shim: die generierten *.exe-Launcher sind unsigniert
# und werden auf gehaerteten Windows-Clients (AppLocker/Smart App Control) geblockt.
uv run python -m mypy src eval
