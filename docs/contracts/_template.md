# Data Contract: <mart_name>

- **Owner:** <Team / Person>
- **Status:** draft | active | deprecated
- **Version:** 1.0.0
- **Consumer:** <BI-Report / ML-Modell / Team>

## Zweck
<Was beschreibt dieses Datenprodukt fachlich, eine Zeile.>

## Schema
| Spalte | Typ | Beschreibung | Nullable |
|--------|-----|--------------|----------|
| <KEY>  | <DATE/NUMBER/VARCHAR> | <...> | nein |
| ...    | ... | ... | ... |

## Qualitätszusagen
- **Key:** `<KEY>` ist unique + not_null (dbt-Test).
- **Freshness:** aktualisiert bis spätestens <HH:MM> am <Rhythmus, z. B. Werktag>.
- **Wertebereiche:** <z. B. Beträge >= 0, keine negativen Mengen>.

## Änderungen
Breaking Changes (Spalte entfernen/umbenennen, Typ ändern) erfordern eine neue
Major-Version und Abstimmung mit den Consumern.
