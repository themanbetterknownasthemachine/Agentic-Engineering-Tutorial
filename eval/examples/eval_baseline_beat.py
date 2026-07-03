"""Generischer ML-Verifier: das Modell muss die Baseline schlagen (Kontrakt: eval/README.md).

Fuer JEDE ML-Aufgabe (Forecasting, Klassifikation, Regression) gilt: eine sinnvolle
Baseline zu schlagen ist Pflicht. Ein Modell, das die Baseline nicht schlaegt, ist
wertlos - egal wie gut die absolute Metrik aussieht.

Der Verifier laedt die Vorhersagen von Baseline und Modell aus einer results-JSON-Datei
und gibt Exit-Code 0 (PASS) nur zurueck, wenn BEIDE Bedingungen erfuellt sind:
  (a) das Modell schlaegt die Baseline (WAPE Modell < WAPE Baseline), UND
  (b) das Modell erfuellt die Quality-Bar (WAPE Modell <= WAPE_QUALITY_BAR).

WAPE statt MAPE: WAPE = sum(|y_true - y_pred|) / sum(|y_true|). Kein
y_true == 0-Problem pro Zeile (nur die Summe im Nenner muss != 0 sein).

Erwartetes JSON-Format:
    {
      "y_true":          [12.0, 8.0, ...],
      "y_pred":          [11.5, 8.4, ...],   # Modell
      "y_pred_baseline": [15.0, 6.0, ...]    # Baseline (z. B. Naive/Saisonal)
    }

Exit-Code 0 = PASS (Reward-Signal fuer den Agenten), != 0 = FAIL.

Aufruf:
    python eval/eval_baseline_beat.py
    python eval/eval_baseline_beat.py --results results_april_2026.json
"""

import argparse
import json
import sys
from typing import NoReturn

import numpy as np

# --- Schwellen und Pfade -----------------------------------------------------
# <PLATZHALTER: aus /criteria-Ergebnis setzen>
RESULTS_PATH = "results.json"
# <PLATZHALTER: aus /criteria-Ergebnis setzen> - maximal erlaubte WAPE des Modells in %.
WAPE_QUALITY_BAR = 15.0
# -----------------------------------------------------------------------------

REQUIRED_KEYS = ("y_true", "y_pred", "y_pred_baseline")


def fail_setup(message: str) -> NoReturn:
    """Setup-Fehler klar benennen und mit Exit 2 abbrechen (FAIL, aber kein Metrik-FAIL)."""
    print(f"SETUP-FEHLER: {message}", file=sys.stderr)
    sys.exit(2)


def wape(y_true: np.ndarray, y_pred: np.ndarray) -> float:
    """Weighted Absolute Percentage Error in Prozent.

    WAPE = sum(|y_true - y_pred|) / sum(|y_true|) * 100. Robust gegen einzelne
    y_true == 0; nur die Summe aller |y_true| muss != 0 sein.
    """
    denom = float(np.sum(np.abs(y_true)))
    if denom == 0.0:
        fail_setup("Summe der |y_true| ist 0 - WAPE nicht definiert.")
    return float(np.sum(np.abs(y_true - y_pred)) / denom * 100)


def load_arrays(path: str) -> tuple[np.ndarray, np.ndarray, np.ndarray]:
    """results-JSON laden und als drei gleich lange float-Arrays zurueckgeben."""
    try:
        with open(path, encoding="utf-8") as f:
            data = json.load(f)
    except FileNotFoundError:
        fail_setup(f"Ergebnisdatei '{path}' nicht gefunden.")
    except json.JSONDecodeError as exc:
        fail_setup(f"'{path}' ist kein gueltiges JSON: {exc}.")

    missing = [k for k in REQUIRED_KEYS if k not in data]
    if missing:
        fail_setup(f"Schluessel {missing} fehlen in '{path}'. Erwartet: {list(REQUIRED_KEYS)}.")

    arrays = {k: np.asarray(data[k], dtype=float) for k in REQUIRED_KEYS}
    lengths = {k: v.shape[0] for k, v in arrays.items()}
    if len(set(lengths.values())) != 1:
        fail_setup(f"Arrays haben unterschiedliche Laengen: {lengths}.")
    if next(iter(lengths.values())) == 0:
        fail_setup(f"'{path}' enthaelt keine Werte.")

    return arrays["y_true"], arrays["y_pred"], arrays["y_pred_baseline"]


def main() -> None:
    ap = argparse.ArgumentParser()
    ap.add_argument(
        "--results",
        default=RESULTS_PATH,
        help="JSON mit y_true, y_pred (Modell), y_pred_baseline (Baseline)",
    )
    args = ap.parse_args()

    y_true, y_pred, y_pred_baseline = load_arrays(args.results)

    wape_model = wape(y_true, y_pred)
    wape_baseline = wape(y_true, y_pred_baseline)
    improvement_pp = wape_baseline - wape_model

    beats_baseline = wape_model < wape_baseline
    meets_quality_bar = wape_model <= WAPE_QUALITY_BAR

    print(f"WAPE Modell    = {wape_model:6.2f} %   (Quality-Bar <= {WAPE_QUALITY_BAR} %)")
    print(f"WAPE Baseline  = {wape_baseline:6.2f} %")
    print(f"Verbesserung   = {improvement_pp:+6.2f} pp")

    if not beats_baseline:
        print(
            f"FAIL: Modell schlaegt die Baseline nicht - WAPE {wape_model:.2f} % vs. "
            f"Baseline {wape_baseline:.2f} % ({-improvement_pp:.2f} pp schlechter).",
            file=sys.stderr,
        )
    if not meets_quality_bar:
        print(
            f"FAIL: Quality-Bar verfehlt - WAPE {wape_model:.2f} % > {WAPE_QUALITY_BAR} % "
            f"(um {wape_model - WAPE_QUALITY_BAR:.2f} pp).",
            file=sys.stderr,
        )

    ok = beats_baseline and meets_quality_bar
    print("RESULT         =", "PASS" if ok else "FAIL")
    sys.exit(0 if ok else 1)


if __name__ == "__main__":
    main()
