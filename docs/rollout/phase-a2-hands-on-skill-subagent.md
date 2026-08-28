# Phase A2 — Hands-on: eigenen Skill & Subagent bauen

Ergänzung zu [`schulung-agenda.md`](schulung-agenda.md) (Phase A). Dort **sieht** das Team dem
Loop beim Bauen zu; hier **baut** jede:r zum ersten Mal selbst zwei eigene Bausteine — einen
Skill und einen Subagent — an einem winzigen, ungefährlichen Übungsfall. Kein Rubber-Stamp,
kein Zuschauen: jede:r verlässt den Termin mit einem eigenen, funktionierenden Skill und
Subagent, die danach echt weiterverwendbar sind (kein Wegwerf-Exercise).

- **Dauer:** 90–120 Min
- **Teilnehmende:** wer produktiv mit dem Template arbeiten wird (nicht zwingend das ganze Team)
- **Voraussetzung:** Phase A absolviert; [`docs/HANDBUCH.md`](../HANDBUCH.md) Teil C.2
  (Skills/Subagents) gelesen
- **Vorbereitung durch dich:** einmal komplett selbst durchgespielt — Referenzlösung und
  Testnachweis in [`toy-example/`](toy-example/)

## Warum eine eigene Hands-on-Einheit?

Phase A zeigt den Loop an einem laufenden Pilotprojekt — überzeugend, aber passiv. Einen
eigenen Skill oder Subagent zu bauen fühlt sich anders an als einem zuzuschauen, und ist
genau das Werkzeug, mit dem das Team später eigene BIDA-Konventionen selbst einbetten wird
(Brücke zu Phase B, siehe unten).

## Das Übungsbeispiel

Dieselbe Fallstudie wie [`docs/WORKFLOW.md`](../WORKFLOW.md) (Paletten pro Tag am
Wareneingang) — dort nur beschrieben, hier mit einem winzigen synthetischen Datensatz
tatsächlich durchgespielt. Bewusst **ohne Rauschen und ohne Snowflake-Zugriff**: Das Ziel
dieses Termins ist Skill-/Subagent-Bau, nicht Prognose-Schwierigkeit. Mit der naiven
Vorwochen-Baseline ist der Verifier praktisch sofort grün — das ist Absicht, nicht ein
zu leichtes Beispiel.

## Die zwei zu bauenden Artefakte

1. **Skill `/new-verifier`** — scaffoldet `eval/eval_<thema>.py` aus `eval/examples/`
   anhand von Themenname und Schwellen aus der Spec. Direkt wiederverwendbar für echte
   BIDA-Projekte danach.
2. **Subagent `verifier-contract-reviewer`** (read-only) — prüft einen Verifier gegen die
   5 Regeln aus [`eval/README.md`](../../eval/README.md) und meldet Verstöße. Ergänzt
   `code-reviewer`/`security-reviewer` um eine dritte, enger fokussierte Prüfung.

Beide sind bewusst thematisch an die "Verifier first"-Philosophie angelehnt statt an ein
beliebiges Spielzeug-Thema — das Team übt an etwas, das im Alltag wirklich zählt.

## Ablauf

| Zeit | Block | Ziel |
|---|---|---|
| 10 Min | **1. Aufwärmen** | Skill vs. Subagent kurz auffrischen; Ideen sammeln ("was nervt heute schon als Handgriff?"). |
| 15 Min | **2. Übungsfall aufsetzen** | Toy-CSV erzeugen, `/spec` auf das Übungsziel anwenden. |
| 15 Min | **3. Verifier von Hand bauen** | Ohne Skill — zeigt den manuellen Weg, bevor Schritt 4 ihn automatisiert. |
| 30 Min | **4. Hands-on: `/new-verifier` bauen** | Der eigentliche neue Skill. |
| 30 Min | **5. Hands-on: `verifier-contract-reviewer` bauen** | Der eigentliche neue Subagent. |
| 10 Min | **6. Reflexion** | Wo im BIDA-Alltag lohnt sich ein eigener Skill/Subagent? → Input für Phase B. |

## Redeleitfaden pro Block

### 1. Aufwärmen (10 Min)
- Kurzer Rückgriff auf [`HANDBUCH.md`](../HANDBUCH.md) Teil C.2: Skill = wiederverwendbarer
  Ablauf im *gleichen* Kontext, per `/name` aufrufbar; Subagent = *isolierter* Kontext mit
  eigenem, oft eingeschränktem Tool-Zugriff (z. B. `code-reviewer`: nur `Read, Grep, Glob`).
- Frage ans Team: "Welchen wiederkehrenden Handgriff macht ihr heute manuell, der eigentlich
  immer gleich abläuft?" — Antworten notieren, tauchen in Block 6 wieder auf.

### 2. Übungsfall aufsetzen (15 Min)
1. `python docs/rollout/toy-example/synthetic_data.py` → `wareneingang_toy.csv`.
2. `/spec` laufen lassen (Ziel: Tagesprognose Paletten, 14 Tage, Akzeptanzkriterium MAPE
   < 12 %, |Bias| ≤ 5 %, keine negativen Werte — siehe [`toy-example/spec-example.md`](toy-example/spec-example.md)
   als Referenz, falls das Interview stockt).

**Warum:** Ohne eigene, kleine Spec fehlt der Aufhänger für die beiden Hands-on-Blöcke danach.

### 3. Verifier von Hand bauen (15 Min)
`eval/examples/eval_forecast.py` nach `eval/eval_wareneingang_toy.py` kopieren, Schwellen aus
der Spec eintragen. Einmal laufen lassen (gegen eine naive Lag-7-Baseline als `y_pred`) —
PASS zeigen.

**Warum:** Der manuelle Weg muss einmal spürbar gewesen sein, damit der Unterschied zu
Schritt 4 (derselbe Schritt per Skill) einleuchtet — analog zum "erst ohne Skill, dann mit
Skill"-Kontrast aus dem Snowflake-CoCo-Guide.

### 4. Hands-on: `/new-verifier` bauen (30 Min)
1. Gemeinsam `.claude/skills/new-verifier/SKILL.md` schreiben (Referenz zum Vergleichen
   danach: [`toy-example/new-verifier-SKILL.md`](toy-example/new-verifier-SKILL.md)) —
   Frontmatter `name` + `description` wie bei den bestehenden Skills in `.claude/skills/spec/`.
2. `/new-verifier` aufrufen, für ein **zweites**, fiktives Thema (z. B. "wareneingang_v2")
   denselben Scaffolding-Schritt wiederholen lassen.
3. Kontrast benennen: Schritt 3 (manuell, ~15 Min) vs. dieser Schritt (Skill, Sekunden) —
   das ist der Hebel, den ein guter Skill bringt.

**Warum:** Ein Skill lohnt sich erst, wenn man den manuellen Weg kennt — sonst wirkt er wie
Magie statt wie eine Abkürzung für etwas Verstandenes.

### 5. Hands-on: `verifier-contract-reviewer` bauen (30 Min)
1. Gemeinsam `.claude/agents/verifier-contract-reviewer.md` schreiben, nach Vorbild von
   [`code-reviewer.md`](../../.claude/agents/code-reviewer.md) (Frontmatter `tools: Read, Grep, Glob`
   — read-only, damit er prüfen, aber nichts ändern kann). Referenz zum Vergleichen:
   [`toy-example/verifier-contract-reviewer-AGENT.md`](toy-example/verifier-contract-reviewer-AGENT.md).
2. Gegen `eval/eval_wareneingang_toy.py` laufen lassen, Findings gemeinsam lesen.
3. Optional: absichtlich einen Verstoß einbauen (z. B. Schwelle ohne Bezug zur Spec ändern)
   und zeigen, dass der Subagent das aufgreift.

**Warum:** Ein zweiter, read-only Kritiker mit engem Fokus ist güns­tiger zu bauen und
vertrauenswürdiger zu lesen als ein Allzweck-Reviewer — genau das Prinzip hinter
`code-reviewer`/`security-reviewer`.

### 6. Reflexion (10 Min)
- Zurück zu den Antworten aus Block 1: welche davon wären als Skill oder Subagent gut
  aufgehoben?
- Überleitung zu Phase B ([`review-arbeitsblatt.md`](review-arbeitsblatt.md), Ebene 3 —
  Domänen-Konventionen): neue Skill-/Subagent-Ideen dort als Kandidaten einbringen.

## Nach dem Termin
- Ideen für weitere Skills/Subagents sammeln und in die Phase-B-Werkstätten einspeisen.
- Wer will, behält `/new-verifier` und `verifier-contract-reviewer` für echte Projekte —
  beide sind keine Wegwerf-Übung, sondern sofort nützlich.
