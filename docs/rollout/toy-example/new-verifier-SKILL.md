---
name: new-verifier
description: Scaffold a new project verifier (eval/eval_<topic>.py) from the eval/examples/ template, with the topic's specific thresholds filled in. Use when starting a new spec that needs a machine-checkable verifier, or when the user runs /new-verifier.
---

# Verifier scaffolder

Help me create a new verifier for a topic, following the contract in `eval/README.md`
(exit code = reward signal, no interaction, deterministic, clear failure output, built
before implementation).

Steps:
1. Ask which topic this verifier is for (used as `eval/eval_<topic>.py`) and which
   `eval/examples/*.py` fits best as a starting point (forecast metrics vs. generic
   baseline-beat).
2. Ask for the concrete acceptance thresholds (e.g. MAPE/WAPE %, max |bias| %, whether
   negative predictions are allowed) — pull these from the active spec in
   `docs/specs/active/` if one exists, don't invent numbers.
3. Copy the chosen example to `eval/eval_<topic>.py`, rename the module docstring, and
   replace the threshold constants with the values from step 2.
4. Run the new verifier once against a tiny dummy input to confirm it executes without
   interaction and reports a clear PASS/FAIL — not that it necessarily passes yet.
5. Remind me: this file is built before the implementation and is not watered down later
   just to turn red into green.
