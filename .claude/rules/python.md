---
paths:
  - "**/*.py"
---

# Python rules

- Python 3.12, dependencies via uv (`uv add` / `uv sync`; keep `uv.lock` committed).
- Format/lint with Ruff, type-check with mypy; both must be green (`bash scripts/lint.sh`).
- Prefer pandas/numpy vectorization over row-wise loops.
- Keep functions small and testable; no I/O at module import time.
- Configuration via environment variables, never hardcoded credentials or paths.
