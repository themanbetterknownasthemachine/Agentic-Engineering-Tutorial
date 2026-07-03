# Domänen-Setup: ML / Data Science

Einrichten: `bash scripts/init-domain.sh ml` (entfernt die unten gelisteten Ordner),
danach Änderungen prüfen und committen.

## Behalten
- `src/` - Trainings-/Inferenz-Code (z. B. `src/forecast/`)
- `eval/` - der Verifier ist hier Pflicht: Beispiel aus `eval/examples/` nach
  `eval/eval_<thema>.py` kopieren, Schwellen aus der Spec setzen
- `notebooks/` - Exploration
- `dags/` - Orchestrierung von Training/Inferenz (falls Airflow im Einsatz)
- `tests/`, `scripts/`, `.claude/`, `docs/`

## Entfernt durch init-domain.sh
- dbt-Stack: `models/`, `macros/`, `seeds/`, `snapshots/`, `tests/dbt/`,
  `dbt_project.yml`, `packages.yml`, `profiles.yml.example`, `.sqlfluff`
- `oracle/`

## Danach anpassen
- `CLAUDE.md`: Technology/Architecture auf den ML-Stack kürzen, `<QUALITY_BAR>` setzen.
- Nicht mehr passende Rules (`dbt-snowflake.md`, `oracle.md`) laden ohne
  ihre Pfade nie - können optional gelöscht werden.
- ML-Abhängigkeiten installieren: `uv sync --group ml` (siehe `pyproject.toml`).

## ML-Methodik aus dem BIDA-ML-Starter

Das Methodenwissen (wie man forecastet, klassifiziert, regressiert) lebt bewusst
**nicht** in diesem Template, sondern im
[BIDA-ML-Starter](https://github.com/themanbetterknownasthemachine/BIDA-ML-Starter) -
der ML-Methoden-Bibliothek. Es wird bei ML-Projektstart **ins Projekt** kopiert
(nicht ins Template - Anti-Drift).

### Methoden-Skills und Anleitungs-Notebooks

Skills und Notebooks sind ein Paar — immer gemeinsam kopieren, nie einzeln. Das
erledigt `scripts/new-ml-project.sh` automatisch. Für manuelles Vorgehen:

| ML-Typ         | Skill (Quelle)                 | Notebook (Quelle)                 | Ziel im Projekt                        |
|----------------|--------------------------------|-----------------------------------|----------------------------------------|
| Forecasting    | `skills/FORECASTING_SKILL.md`    | `notebooks/02_forecasting.ipynb`    | `.claude/skills/forecasting/SKILL.md`    |
| Klassifikation | `skills/CLASSIFICATION_SKILL.md` | `notebooks/03_classification.ipynb` | `.claude/skills/classification/SKILL.md` |
| Regression     | `skills/REGRESSION_SKILL.md`     | `notebooks/04_regression.ipynb`     | `.claude/skills/regression/SKILL.md`     |

Beim Kopieren: Frontmatter oben in der `SKILL.md` ergänzen (`name` + `description`,
Format wie die bestehenden Skills dieses Repos, z. B. `.claude/skills/spec/SKILL.md`).

Die Skills sind datenquellen-unabhängig. `src/data_loader.py` wird nur bei
Snowflake-Quellen gebraucht (sonst weglassen oder ersetzen).
