# Domänen-Setup: Power BI

Einrichten: `bash scripts/init-domain.sh pbi` (entfernt die unten gelisteten Ordner),
danach Änderungen prüfen und committen.

## Behalten
- `powerbi/` - PBIP/TMDL-Projekte (Pflicht-Git-Format, siehe `powerbi/README.md`)
- `src/`, `tests/`, `eval/` - bleiben als Grundgerüst, damit `scripts/verify.sh`
  durchläuft; ein Verifier kann hier z. B. TMDL-Konventionen prüfen
- `scripts/`, `.claude/`, `docs/`

## Entfernt durch init-domain.sh
- dbt-Stack: `models/`, `macros/`, `seeds/`, `snapshots/`, `tests/dbt/`,
  `dbt_project.yml`, `packages.yml`, `profiles.yml.example`, `.sqlfluff`
- `oracle/`, `dags/`, `notebooks/`

## Danach anpassen
- `CLAUDE.md`: Technology auf Power BI + Quell-DWH kürzen.
- DAX-Konventionen gelten automatisch über `.claude/rules/dax.md`.
