"""Verifier fuer den Wareneingangs-Uebungsfall (Phase A2). Kontrakt: eval/README.md.

Angepasste Kopie von eval/examples/eval_forecast.py mit den Schwellen aus
docs/rollout/toy-example/spec-example.md. Exit-Code 0 = PASS, != 0 = FAIL.
Erwartet eine Parquet-Datei mit den Spalten y_true und y_pred.

Beispiel:
    python docs/rollout/toy-example/eval_wareneingang_toy.py --holdout holdout_toy.parquet
"""

import argparse
import sys
from typing import NoReturn

import numpy as np
import pandas as pd

THRESHOLD_MAPE = 12.0  # Prozent, auf Zeilen mit y_true != 0 (aus der Spec)
MAX_ABS_BIAS_PCT = 5.0  # erlaubter mittlerer Bias in Prozent des Mittelwerts (aus der Spec)
REQUIRED_COLUMNS = ("y_true", "y_pred")


def fail_setup(message: str) -> NoReturn:
    """Setup-Fehler klar benennen und mit Exit 2 abbrechen (FAIL, aber kein Metrik-FAIL)."""
    print(f"SETUP-FEHLER: {message}", file=sys.stderr)
    sys.exit(2)


def mape_excluding_zeros(y_true: pd.Series, y_pred: pd.Series) -> tuple[float, int]:
    """MAPE nur ueber Zeilen mit y_true != 0; gibt (MAPE, Anzahl ausgeschlossener Zeilen) zurueck."""
    nonzero = y_true != 0
    n_excluded = int((~nonzero).sum())
    if not bool(nonzero.any()):
        fail_setup("alle y_true-Werte sind 0 - MAPE nicht definiert, WAPE/sMAPE verwenden.")
    yt = y_true[nonzero]
    yp = y_pred[nonzero]
    return float(np.mean(np.abs((yt - yp) / yt)) * 100), n_excluded


def main() -> None:
    ap = argparse.ArgumentParser()
    ap.add_argument(
        "--holdout", default="holdout_toy.parquet", help="Parquet mit Spalten y_true, y_pred"
    )
    args = ap.parse_args()

    try:
        df = pd.read_parquet(args.holdout)
    except FileNotFoundError:
        fail_setup(f"Holdout-Datei '{args.holdout}' nicht gefunden.")

    missing = [c for c in REQUIRED_COLUMNS if c not in df.columns]
    if missing:
        fail_setup(
            f"Spalte(n) {missing} fehlen in '{args.holdout}'. "
            f"Vorhanden: {list(df.columns)}. Erwartet: {list(REQUIRED_COLUMNS)}."
        )
    if df.empty:
        fail_setup(f"'{args.holdout}' enthaelt keine Zeilen.")

    m, n_excluded = mape_excluding_zeros(df["y_true"], df["y_pred"])
    bias = float(np.mean(df["y_pred"] - df["y_true"]))
    mean_true = float(np.mean(df["y_true"]))
    bias_pct = bias / mean_true * 100 if mean_true != 0 else float("inf")
    n_negative = int((df["y_pred"] < 0).sum())

    print(
        f"MAPE      = {m:6.2f} %   (Schwelle < {THRESHOLD_MAPE} %, "
        f"{n_excluded} Zeilen mit y_true == 0 ausgeschlossen)"
    )
    print(
        f"Bias      = {bias:+10.1f}   ({bias_pct:+.1f} % vom Mittelwert, "
        f"erlaubt +/- {MAX_ABS_BIAS_PCT} %)"
    )
    print(f"Negative  = {n_negative:6d}     (erlaubt: 0)")

    ok = m < THRESHOLD_MAPE and abs(bias_pct) <= MAX_ABS_BIAS_PCT and n_negative == 0
    print("RESULT    =", "PASS" if ok else "FAIL")
    sys.exit(0 if ok else 1)


if __name__ == "__main__":
    main()
