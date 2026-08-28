# Toy-Example: Referenzlösung für Phase A2

Getestete Musterlösung für [`../phase-a2-hands-on-skill-subagent.md`](../phase-a2-hands-on-skill-subagent.md) —
Fallback für den Moderator, falls eine Live-Demo hakt, oder zum Nachlesen. Die eigentliche
Lernerfahrung entsteht live im Workshop, nicht durch Kopieren dieser Dateien.

| Datei | Rolle |
|---|---|
| [`synthetic_data.py`](synthetic_data.py) | Erzeugt den winzigen, deterministischen Wareneingangs-Datensatz. Getestet: `python docs/rollout/toy-example/synthetic_data.py` → `wareneingang_toy.csv`. |
| [`spec-example.md`](spec-example.md) | Referenz-Spec für den Übungsfall (Ziel, Scope, Akzeptanzkriterium). |
| [`eval_wareneingang_toy.py`](eval_wareneingang_toy.py) | Referenz-Verifier (Kopie von `eval/examples/eval_forecast.py`, Schwellen aus der Spec). Getestet gegen eine naive Lag-7-Baseline: PASS (MAPE 0.6 %, Bias -0.6 %, 0 negative). |
| [`new-verifier-SKILL.md`](new-verifier-SKILL.md) | Ziel-Artefakt Hands-on 1: Inhalt für `.claude/skills/new-verifier/SKILL.md`. |
| [`verifier-contract-reviewer-AGENT.md`](verifier-contract-reviewer-AGENT.md) | Ziel-Artefakt Hands-on 2: Inhalt für `.claude/agents/verifier-contract-reviewer.md`. Frontmatter-Format geprüft gegen `code-reviewer.md`/`security-reviewer.md`. |

**Vor der Live-Session:** Beide Skill-/Agent-Dateien einmal echt in einer laufenden
Claude-Code-Session in diesem Projekt einsetzen (`.claude/skills/new-verifier/SKILL.md` bzw.
`.claude/agents/verifier-contract-reviewer.md`) und wirklich aufrufen — das kann diese
README nicht für dich übernehmen.
