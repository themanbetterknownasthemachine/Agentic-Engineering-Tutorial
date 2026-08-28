# Spec: Wareneingangs-Forecast (Phase-A2-Übungsfall)

**Status:** Übungsfall für den Hands-on-Workshop (Phase A2) · nicht produktiv

Dieselbe Fallstudie wie in [`docs/WORKFLOW.md`](../../WORKFLOW.md), diesmal real durchgespielt
statt nur beschrieben. Referenz-Lösung — dein `/spec`-Interview wird nicht wortgleich sein,
das ist gewollt.

## Ziel

Tagesgenaue Prognose des Wareneingangsvolumens (Paletten pro Tag), damit die Kapazität am
Wareneingang (Personal, Tore, Stellplätze) vorausschauend geplant werden kann.

## Scope

| Dimension    | Festlegung                        |
|--------------|------------------------------------|
| Zielgröße    | `PALETTEN` (Paletten pro Tag)      |
| Granularität | 1 Standort, 1 Wert pro Tag         |
| Horizont     | 14 Tage                           |
| Kadenz       | Einmaliger Übungslauf (kein täglicher Produktivlauf) |

## Datenquelle

`docs/rollout/toy-example/synthetic_data.py` erzeugt `wareneingang_toy.csv`
(Spalten `RUESTDATUM`, `PALETTEN`), 120 Tage, Mo–Fr, deterministisch (kein Rauschen).

## Features (Startset)

- Wochentag (klare Saisonalität im Übungsdatensatz enthalten)
- Lag 7 (Vorwoche) als naive Baseline

## Validierung / Holdout

Letzte 4 Wochen als Holdout, 14-Tage-Fenster.

## Akzeptanzkriterium (Verifier)

`eval_wareneingang_toy.py` gibt Exit 0 nur wenn:

1. **MAPE < 12 %** auf dem Holdout.
2. **|Bias| ≤ 5 %** vom Ist-Mittelwert.
3. **Keine negativen Prognosen.**

(Siehe [`eval_wareneingang_toy.py`](eval_wareneingang_toy.py) für die Umsetzung.)

## Output

Nur Übungszweck — kein echter Output-View, kein Produktiv-Deploy.
