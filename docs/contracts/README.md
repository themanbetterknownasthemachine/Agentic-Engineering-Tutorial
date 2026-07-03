# Data Contracts

Ein Data Contract macht die Zusage eines Datenprodukts explizit: Schema, Bedeutung,
Freshness und Verantwortlichkeit. Consumer (BI-Reports, ML, andere Teams) verlassen
sich darauf; Änderungen sind bewusst und versioniert.

## Zwei Ebenen

1. **Fachlich (dieses Verzeichnis):** eine Markdown-Datei pro Datenprodukt
   (`<mart_name>.md`), Vorlage siehe `_template.md`. Owner, SLA, Semantik.
2. **Technisch (dbt):** `contract: {enforced: true}` auf dem Mart erzwingt Schema
   und Datentypen beim Build - dbt bricht ab, wenn die Query vom Vertrag abweicht.
   Beispiel: `models/marts/mart_example__orders_daily.sql` + dessen `schema.yml`.

Wenn beides existiert, ist der Vertrag sowohl dokumentiert als auch maschinell
durchgesetzt.
