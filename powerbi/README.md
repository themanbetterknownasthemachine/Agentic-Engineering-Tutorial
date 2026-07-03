# powerbi/ - Power-BI-Artefakte

Hier liegen Power-BI-Projekte im **PBIP-Format mit TMDL** - das ist das
Pflicht-Format fuer Git in diesem Template:

- In Power BI Desktop: Datei > Optionen > Vorschaufunktionen >
  "Power BI Projekt (.pbip) speichern" aktivieren und **als .pbip speichern**.
- Committet werden die entpackten Ordner (`*.SemanticModel/`, `*.Report/`)
  mit TMDL-Definitionen - dadurch sind Diffs und Reviews moeglich.
- **Nie `.pbix`-Binaerdateien committen.**

Konventionen fuer Measures und DAX: `.claude/rules/dax.md`
(laedt automatisch, sobald in diesem Ordner gearbeitet wird).

Wird dieser Ordner im Projekt nicht gebraucht: `bash scripts/init-domain.sh <domaene>`
entfernt ihn (siehe `docs/domain-setup/`).
