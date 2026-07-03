#!/usr/bin/env bash
# Laeuft einmal beim Erstellen des Devcontainers: Toolchain + Dependencies.
set -euo pipefail

# uv (Paket-/Env-Manager)
curl -LsSf https://astral.sh/uv/install.sh | sh
export PATH="$HOME/.local/bin:$PATH"

# Projekt-Dependencies inkl. dev-Gruppe (ruff, mypy, pytest)
uv sync

# sqlfluff + dbt-Templater fuer SQL-Linting (siehe .sqlfluff)
uv tool install sqlfluff --with sqlfluff-templater-dbt --with dbt-snowflake || true

# pre-commit-Hooks aktivieren, falls konfiguriert
if [ -f .pre-commit-config.yaml ]; then
  uv tool install pre-commit || true
  pre-commit install || true
fi

echo "Devcontainer bereit. 'bash scripts/verify.sh' fuehrt alle Pruefungen aus."
