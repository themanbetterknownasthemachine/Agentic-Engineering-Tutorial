"""Erzeugt einen winzigen, deterministischen Wareneingangs-Datensatz fuer Phase A2.

Kein echter Datenbezug noetig - reines Uebungsmaterial fuer den Hands-on-Workshop.
Bildet dieselbe Fallstudie ab wie docs/WORKFLOW.md (Paletten pro Tag am Wareneingang),
diesmal aber mit echten (synthetischen) Daten zum tatsaechlichen Durchspielen.

Aufruf:
    python docs/rollout/toy-example/synthetic_data.py
"""

from __future__ import annotations

import csv
import datetime as dt

START = dt.date(2026, 1, 5)  # ein Montag
N_DAYS = 120  # ca. 24 Wochen Historie - reicht fuer Holdout + saisonalen Vergleich
OUT_PATH = "wareneingang_toy.csv"

# Wochentags-Grundlast (Mo-Fr) plus leichter linearer Trend - bewusst kein Rauschen,
# damit Ergebnisse fuer alle Teilnehmenden identisch und leicht nachvollziehbar sind.
WEEKDAY_BASE = {0: 180, 1: 210, 2: 220, 3: 230, 4: 260}
TREND_PER_DAY = 0.3


def paletten(day: dt.date, day_index: int) -> int:
    return round(WEEKDAY_BASE[day.weekday()] + TREND_PER_DAY * day_index)


def business_days(start: dt.date, n: int) -> list[dt.date]:
    days: list[dt.date] = []
    d = start
    while len(days) < n:
        if d.weekday() < 5:
            days.append(d)
        d += dt.timedelta(days=1)
    return days


def main() -> None:
    days = business_days(START, N_DAYS)
    with open(OUT_PATH, "w", newline="", encoding="utf-8") as f:
        writer = csv.writer(f)
        writer.writerow(["RUESTDATUM", "PALETTEN"])
        for i, day in enumerate(days):
            writer.writerow([day.isoformat(), paletten(day, i)])
    print(f"{len(days)} Zeilen geschrieben nach {OUT_PATH} ({days[0]} .. {days[-1]})")


if __name__ == "__main__":
    main()
