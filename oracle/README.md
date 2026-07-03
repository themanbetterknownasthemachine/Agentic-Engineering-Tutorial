# oracle/ - Oracle-SQL und PL/SQL

Skripte und Objekte fuer Oracle-Quellsysteme (Views, Packages, Abzugslogik).

- Dialekt-Regeln: `.claude/rules/oracle.md` (laedt automatisch fuer diesen Ordner).
- Achtung: Snowflake-Konventionen (DIM_DATE, COPY INTO) gelten hier NICHT.
- Empfohlene Struktur: `oracle/views/`, `oracle/packages/`, `oracle/scripts/`.

Wird dieser Ordner im Projekt nicht gebraucht: `bash scripts/init-domain.sh <domaene>`
entfernt ihn (siehe `docs/domain-setup/`).
