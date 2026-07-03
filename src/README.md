# src/ - produktiver Python-Code

Package-Layout: pro Fachthema ein Unterpaket, z. B. `src/forecast/`,
`src/ingest/`. Notebooks explorieren, `src/` produziert - Logik, die
produktiv laufen soll, gehoert hierher und wird in `tests/` getestet.

`scripts/lint.sh` prueft `src/` mit Ruff und mypy.
