# Toy-Example: Referenzmaterial für kickoff-ablauf.html

Getestete Bausteine für [`../kickoff-ablauf.html`](../kickoff-ablauf.html), Schritt 12
("Dein nächstes Projekt: Spec, Verifier, Loop") — Fallback für den Moderator, falls eine
Live-Demo hakt, oder zum Nachlesen. Die eigentliche Lernerfahrung entsteht live im Workshop,
nicht durch Kopieren dieser Dateien.

| Datei | Rolle |
|---|---|
| [`synthetic_data.py`](synthetic_data.py) | Erzeugt den winzigen, deterministischen Wareneingangs-Datensatz. Getestet: `python docs/rollout/toy-example/synthetic_data.py` → `wareneingang_toy.csv`. |
| [`spec-example.md`](spec-example.md) | Referenz-Spec für den Übungsfall (Ziel, Scope, Akzeptanzkriterium). |
| [`eval_wareneingang_toy.py`](eval_wareneingang_toy.py) | Referenz-Verifier (Kopie von `eval/examples/eval_forecast.py`, Schwellen aus der Spec). Getestet gegen eine naive Lag-7-Baseline: PASS (MAPE 0.6 %, Bias -0.6 %, 0 negative). |

## Skill, Subagent und Plugin (Schritte 6–11)

Anders als in einer früheren Fassung dieses Ordners gibt es hier **keine vorgefertigten**
`SKILL.md`/`AGENT.md`-Dateien mehr als Ziel-Artefakte. In `kickoff-ablauf.html` beschreiben
Teilnehmende in einem Prompt, was Claude bauen soll (`/new-dbt-model`-Skill,
`dbt-naming-reviewer`-Subagent, `bida-dbt-tools`-Plugin) — Claude schreibt die Dateien, nicht
der Mensch (siehe Schritt 7, 9, 11 in `kickoff-ablauf.html`).

**Vor der Live-Session:** Fahr die Prompts aus Schritt 6–11 einmal selbst in einer laufenden
Claude-Code-Session in diesem Projekt durch (Modell manuell anlegen, Skill per Prompt bauen
lassen, Subagent per Prompt bauen lassen, beide gegen dein Modell laufen lassen, zum Plugin
verpacken) — das kann diese README nicht für dich übernehmen, und die genauen Ergebnisse
hängen vom Modelloutput ab, nicht von einer fixen Vorlage.
