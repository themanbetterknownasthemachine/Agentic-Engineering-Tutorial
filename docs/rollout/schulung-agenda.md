# Phase A — Schulung & Kickoff: Agenda + Demo-Skript

Ziel dieses Termins: **gemeinsames Verständnis, noch keine Regel-Entscheidungen.** Das Team soll
verstehen, *was* das Template ist, *warum* es so aufgebaut ist und *wie* man damit arbeitet.
Die eigentliche Regel-Härtung passiert danach in den Domänen-Werkstätten (Phase B, siehe
[`review-arbeitsblatt.md`](review-arbeitsblatt.md)).

- **Dauer:** 60–90 Min
- **Teilnehmende:** ganzes Team (alle, die künftig mit dem Template arbeiten)
- **Vorbereitung durch Teilnehmende:** [`docs/HANDBUCH.md`](../HANDBUCH.md) vorab lesen (Pflicht)
- **Vorbereitung durch dich:** eines der zwei Pilotprojekte lauffähig für die Live-Demo

---

## Agenda

| Zeit | Block | Ziel |
|---|---|---|
| 5 Min | **1. Warum überhaupt** | Problem benennen: Claude nicht blind coden lassen. |
| 15 Min | **2. Das Konzept** | Spec → Verifier → Loop, Arbeitsteilung, Kontext vs. Durchsetzung. |
| 25 Min | **3. Live-Demo** | Am echten Pilotprojekt zeigen, wie es abläuft. |
| 15 Min | **4. Struktur-Rundgang** | Was liegt wo (`.claude/`, `docs/`, `eval/`, Domänen-Ordner). |
| 10 Min | **5. Ausblick Phase B** | Regeln sind Vorschläge — wie wir sie gemeinsam härten. |
| 10 Min | **6. Fragen** | Offene Punkte, Bedenken. |

---

## Redeleitfaden pro Block

### 1. Warum überhaupt (5 Min)
- Ohne Struktur rät der Agent eure Konventionen jedes Mal neu und macht schwer prüfbare Sprünge.
- Das Template stellt die Zusammenarbeit von Anfang an sauber auf: Kontext, Regeln, wiederholbare
  Abläufe und **harte Leitplanken**.

### 2. Das Konzept (15 Min) — die drei Kernideen
1. **Arbeitsteilung.** Der Mensch besitzt Spec, finale Bewertung und Verständnis; der Agent
   besitzt die Implementierung in der Schleife. → Whiteboard-Skizze: innerer vs. äußerer Loop.
2. **Spec → Verifier → Loop.** Erst sagen, was gebaut wird und woran man Erfolg misst (Verifier,
   Exit-Code als Signal), *dann* delegieren. Der Verifier wird **vor** dem Code gebaut.
3. **Kontext vs. Durchsetzung.** `CLAUDE.md`/Rules *beeinflussen* (Hinweis), Hooks/Deny-Permissions
   *erzwingen* (technischer Block). „Das darf nie passieren" → Durchsetzung, nicht Regeltext.

> Kernsatz zum Merken: *„Ein grüner Metrik-Wert ist nicht automatisch deploy-reif — die fachliche
> Freigabe bleibt beim Menschen."*

### 3. Live-Demo (25 Min) — Skript
Am echten Pilotprojekt, in dieser Reihenfolge. Sprich jeden Schritt laut mit „was" und „warum".

1. **Session starten.** `claude` im Projekt-Root. `/memory` zeigen → welche Dateien als Kontext
   geladen sind (CLAUDE.md + immer geltende Rules).
2. **`/spec` zeigen** (oder die bereits existierende Spec im Pilot öffnen). Betonen: kurz,
   abgegrenzt, in `docs/specs/active/`.
3. **`/criteria` + den Verifier zeigen.** `eval/eval_<thema>.py` öffnen → Exit-Code-Logik.
   Einmal laufen lassen, roten/grünen Ausgang zeigen.
4. **Den inneren Loop zeigen.** Eine kleine Aufgabe delegieren: „iteriere, bis der Verifier grün
   ist." Zeigen, wie Claude korrigiert.
5. **Leitplanke live auslösen (der Wow-Moment).** Claude bitten, eine `.env` zu lesen *oder* ein
   `DROP`/`DELETE` gegen die DB abzusetzen → der PreToolUse-Hook blockt mit Exit 2. Erklären:
   das ist Durchsetzung, kein bloßer Hinweis. (Quelle: [`_check.py`](../../.claude/hooks/_check.py))
6. **`/review` kurz zeigen** — zweites Modell als Kritiker, kein Rubber-Stamp.

### 4. Struktur-Rundgang (15 Min)
Kurz durch die Ordner, nicht auswendig — auf das HANDBUCH als Nachschlagewerk verweisen:
- `.claude/rules/` (path-gebunden), `skills/` (`/name`), `agents/` (read-only), `hooks/`, `settings.json`
- `docs/` (specs, adr, contracts, domain-setup, runbooks)
- `eval/` (Verifier-Kontrakt), dbt-Stack, Domänen-Ordner (`src/`, `dags/`, `oracle/`, `notebooks/`)

### 5. Ausblick Phase B (10 Min) — die entscheidende Ansage
- Klarstellen: **Die mitgelieferten Rules, Hooks und Deny-Permissions sind Beispiele/Defaults.**
  Sie müssen für unseren Stack verbindlich gemacht werden.
- Ankündigen: getrennte Domänen-Werkstätten (dbt, ML, ggf. Oracle/Airflow) + ein separater
  Termin für firmweite Leitplanken (Security/Hard Blocks).
- Jede Domäne bekommt einen **Owner** pro Regeldatei. Wer macht was? → schon hier Freiwillige notieren.

### 6. Fragen (10 Min)
Bedenken sammeln (die fließen als Input in Phase B).

---

## Nach dem Termin
- Notiere Freiwillige/Owner pro Domäne.
- Terminiere die Phase-B-Werkstätten mit [`review-arbeitsblatt.md`](review-arbeitsblatt.md) als Grundlage.
