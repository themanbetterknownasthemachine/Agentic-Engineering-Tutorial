# notebooks/ - Exploration

Grundsatz: **Notebooks explorieren, `src/` produziert.** Sobald Logik
produktiv laufen soll, wandert sie nach `src/` und wird in `tests/` getestet.

## Konventionen
- Nummern-Prefix für die Reihenfolge: `01_explore_...`, `02_features_...`,
  `03_modell_...`.
- Kein Produktionscode im Notebook: importiere aus `src/`, definiere dort keine
  wiederverwendbare Logik.
- Outputs werden vor dem Commit gestrippt (nbstripout, via pre-commit) - so
  bleiben Diffs lesbar und es landen keine Daten/Secrets in Git.
- Keine Credentials im Notebook: Werte über Umgebungsvariablen laden.

## nbstripout aktivieren
Läuft automatisch über `.pre-commit-config.yaml`. Einmalig einrichten:

    uv tool install pre-commit && pre-commit install

Wird dieser Ordner im Projekt nicht gebraucht: `bash scripts/init-domain.sh <domaene>`
entfernt ihn (siehe `docs/domain-setup/`).
