---
paths:
  - "src/forecast/**"
  - "eval/**"
---

# Forecasting rules

- No feature leakage: never use features that are unknown at prediction time.
- Half-days (IS_HALBTAG) are statistically fragile (very few training rows):
  always sanity-check sign and magnitude of coefficients, never trust them blindly.
- Before deploying a forecast, the holdout must pass the project verifier
  `python eval/eval_<thema>.py` (exit 0). Contract: `eval/README.md`.
- Verifiers are deterministic: fix random seeds in training and evaluation.
- Quantities are never negative; clip or model accordingly and let the verifier check it.
- Prefer robust metrics (WAPE/sMAPE) when the target contains zeros.
