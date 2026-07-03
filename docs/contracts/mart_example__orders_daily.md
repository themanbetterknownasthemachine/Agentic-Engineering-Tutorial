# Data Contract: mart_example__orders_daily

- **Owner:** BIDA (Beispiel)
- **Status:** active
- **Version:** 1.0.0
- **Consumer:** Beispiel-Report / Demo

## Zweck
Bestellungen pro Kalendertag (Anzahl und Summe) - Demo für einen erzwungenen Contract.

## Schema
| Spalte       | Typ    | Beschreibung                     | Nullable |
|--------------|--------|----------------------------------|----------|
| ORDER_DATE   | DATE   | Kalendertag (Schlüssel)          | nein     |
| ORDER_COUNT  | NUMBER | Anzahl Bestellungen an dem Tag   | ja       |
| TOTAL_AMOUNT | NUMBER | Summe der Beträge an dem Tag     | ja       |

## Qualitätszusagen
- **Key:** `ORDER_DATE` ist unique + not_null (dbt-Test) und im Contract als
  `not_null`-Constraint verankert.
- **Freshness:** in echten Projekten hier den SLA eintragen.
- **Wertebereiche:** `TOTAL_AMOUNT >= 0`.

## Änderungen
Schema wird über `contract: enforced` in `models/marts/schema.yml` durchgesetzt;
Typ-/Spaltenänderungen brechen den dbt-Build und erfordern eine neue Major-Version.
