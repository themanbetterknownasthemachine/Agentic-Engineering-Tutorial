# Phase B — Review-Arbeitsblatt: Regeln & Leitplanken härten

Arbeitsgrundlage für die Domänen-Werkstätten. Ziel: aus den mitgelieferten **Beispiel**-Regeln
verbindliche Pistor-Regeln machen und im Template verankern.

**So benutzt du dieses Blatt:** Jede Zeile ist eine Entscheidung. Spalten:
- **Was** — die Regel / die zu treffende Entscheidung
- **Wo** — die Datei, in der sie lebt (Quelle der Wahrheit)
- **Aktueller Default** — was heute im Template steht
- **Entscheidung / Owner** — leer zum Ausfüllen im Termin

Die drei Ebenen bewusst **getrennt** bearbeiten — unterschiedliche Runden, unterschiedliche Leute:

| Ebene | Wer entscheidet | Termin |
|---|---|---|
| **1 — Firmweite Leitplanken** | kleiner Kreis (Lead/Security), einmal, verbindlich für alle | 1 separater Termin |
| **2 — Firmweiter Kontext** | Lead + je 1 Vertretung pro Domäne | im Leitplanken-Termin oder separat |
| **3 — Domänen-Konventionen** | die Praktiker:innen der jeweiligen Domäne | je 1 Werkstatt pro Domäne |

> **Grundprinzip: nicht mit leerem Blatt.** Der aktuelle Default ist der Vorschlag — ihr reagiert
> nur noch (passt / verschärfen / fehlt). Das ist schneller und verhindert Bikeshedding.

> **Verankern = jede getroffene Entscheidung sofort als ADR** in [`docs/adr/`](../adr/) festhalten
> (Muster: [`0001`](../adr/0001-record-architecture-decisions.md)). Das ist wörtlich das
> „im Template verankert" aus der DoD.

---

## Wie ändere ich welche Ebene? (das „Wie")

Innerhalb einer Ebene ist der Änderungsmechanismus immer gleich:

| Mechanismus | Datei(en) | Wirkung | Nach Änderung |
|---|---|---|---|
| **Kontext** (Hinweis) | `.claude/rules/*.md`, `CLAUDE.md` | beeinflusst Verhalten, erzwingt nicht | keine — lädt beim nächsten Session-Start |
| **Durchsetzung** (harter Block) | `.claude/hooks/_check.py`, `.claude/settings.json` (`deny`) | blockt technisch (Exit 2 / Permission) | **testen**: Aktion auslösen und prüfen, dass sie geblockt wird |
| **Erlaubnis** | `.claude/settings.json` (`allow`) | erlaubt Aktionen ohne Rückfrage | Session neu starten |

⚠️ **Wichtiger Fallstrick (aus [`security.md`](../../.claude/rules/security.md)):** Deny-Permission-Globs
können **keinen** Substring in der *Mitte* eines Bash-Kommandos matchen. `Bash(*DROP*)` gibt
falsche Sicherheit. Zuverlässiges DDL-Blocking gehört in den Hook (`_check.py`), **nicht** in die
Deny-Liste.

---

## Ebene 1 — Firmweite Leitplanken (Durchsetzung, verbindlich für alle)

Das sind die harten Blocks. Kleiner Kreis, einmal entscheiden.

| Was | Wo | Aktueller Default | Entscheidung / Owner |
|---|---|---|---|
| Welche SQL-Operationen sind hart gesperrt? | [`_check.py`](../../.claude/hooks/_check.py) (`DESTRUCTIVE_SQL`) | `DROP`, `DELETE`, `TRUNCATE` | |
| In welchem Kontext greift die SQL-Sperre? | [`_check.py`](../../.claude/hooks/_check.py) (`SQL_RUNNER`) | snowsql, `snow sql`, `dbt(f) run-operation`, sqlplus, sqlcmd, psql, sqlite3, MCP-Query | |
| Gibt es Prod-Schemas/-Rollen, in die **nie** geschrieben werden darf? | ggf. neu in `_check.py` | — (nicht abgedeckt) | |
| Welche Dateien gelten als Credentials (Lese-/Schreibsperre)? | [`_check.py`](../../.claude/hooks/_check.py) (`SECRET_FILE`) + [`settings.json`](../../.claude/settings.json) `deny` | `.env`, `*.p8`, `*.pem`, `*.key` (`.env.example` erlaubt) | |
| Fehlen Token-/Key-Dateimuster (z. B. `*.token`, `credentials.json`)? | s. o. | — | |
| Ist `git push` gesperrt? Auch `merge`/Force-Push? | [`settings.json`](../../.claude/settings.json) `deny` | nur `Bash(git push:*)` | |
| Deckt die **Allow-Liste** euren echten Workflow ab (nicht zu eng, nicht zu weit)? | [`settings.json`](../../.claude/settings.json) `allow` | dbtf build/test, uv run pytest/ruff/mypy, `python eval/`, `bash scripts/`, Read/Edit/Write/Grep/Glob | |
| Fail-closed-Verhalten des Hooks (kein Python → blockieren) — so gewollt? | [`protect-files.sh`](../../.claude/hooks/protect-files.sh) | ja, blockt | |

**Test nach jeder Änderung:** die verbotene Aktion in einer Claude-Session auslösen und prüfen,
dass sie wirklich mit „Blockiert durch protect-files.sh" abbricht.

---

## Ebene 2 — Firmweiter Kontext & Prozess (Hinweis, aber teamweit einheitlich)

Gilt für alle, ist aber Kontext (kein technischer Block).

| Was | Wo | Aktueller Default | Entscheidung / Owner |
|---|---|---|---|
| Immer geltende Security-Regeln (Text) | [`security.md`](../../.claude/rules/security.md) | Secrets, kein destr. SQL, kein Push/Merge ungefragt | |
| Nicht verhandelbare Regeln im Projektkontext | [`CLAUDE.md`](../../CLAUDE.md) („Non-negotiable rules") | s. Datei | |
| Definition of Done (firmweiter Teil) | [`CLAUDE.md`](../../CLAUDE.md) („Definition of done") | Tests/Lint/Typecheck grün, Quality-Bar, Doku, keine Secrets | |
| Verifier-Kontrakt (was ein gültiger Verifier erfüllt) | [`eval/README.md`](../../eval/README.md) | Exit 0=PASS, ohne Interaktion, deterministisch, vorher gebaut | |
| Secret-Handhabung (nur Env-Referenzen) | [`.mcp.json`](../../.mcp.json), [`.env.example`](../../.env.example) | `${VAR}`-Referenzen | |
| Testing-Grundsätze (teamweit) | [`testing.md`](../../.claude/rules/testing.md) | Tests je Änderung, keine roten Tests löschen | |
| Python-Baseline (teamweit) | [`python.md`](../../.claude/rules/python.md) | 3.12, uv, Ruff, mypy | |

---

## Ebene 3 — Domänen-Konventionen (je Werkstatt, je Owner)

Je Domäne eine eigene Runde mit den Leuten, die dort arbeiten. Nur die relevanten Blöcke bearbeiten.

### 3a — dbt / Snowflake (Owner: __________)
Quelle: [`dbt-snowflake.md`](../../.claude/rules/dbt-snowflake.md) · lädt bei `models/`, `macros/`, `seeds/`, `snapshots/`, `dbt_project.yml`, `packages.yml`

| Was | Aktueller Default | Entscheidung |
|---|---|---|
| Naming Staging / Mart | `stg_<source>__<entity>` / `mart_<bereich>__<thema>` | |
| Spaltennamen / `SELECT *` | UPPER_SNAKE_CASE, kein `SELECT *` | |
| Pflicht-Tests je Output | `not_null` + `unique` auf dem Key | |
| Zeitlogik | immer über DIM_DATE, `AT = 1` | |
| Ladeprozess | Stage + `COPY INTO` | |
| Tooling / Auth | `dbtf`-Wrapper, Key-Pair (`snowflake_jwt`) | |
| Verifier der Domäne | `dbtf test` (kein Python-Eval nötig) | |

### 3b — ML / Forecasting (Owner: __________)
Quelle: [`forecasting.md`](../../.claude/rules/forecasting.md) · lädt bei `src/forecast/`, `eval/`

| Was | Aktueller Default | Entscheidung |
|---|---|---|
| Feature-Leakage | verboten | |
| Halbtage (`IS_HALBTAG`) | als fragil behandeln, Koeffizienten prüfen | |
| Determinismus | Seeds in Training & Eval fixieren | |
| Negative Mengen | nie; clippen/modellieren, Verifier prüft | |
| Metriken bei Null-Werten | WAPE/sMAPE statt MAPE | |
| Quality-Bar (Schwellen) | pro Projekt (`<QUALITY_BAR>`) — Standardwert festlegen? | |
| Methodenwissen | kommt aus dem BIDA-ML-Starter (Skill+Notebook als Paar) | |

### 3c — Oracle (Owner: __________)
Quelle: [`oracle.md`](../../.claude/rules/oracle.md) · lädt bei `oracle/`

| Was | Aktueller Default | Entscheidung |
|---|---|---|
| Dialekt-Abgrenzung | Snowflake-Konventionen gelten NICHT | |
| Datumsformate | explizite Format-Masken, `TRUNC` für Tagesvergleich | |
| SQL-Sicherheit | Bind-Variablen, keine String-Konkatenation | |
| Joins | ANSI statt `(+)` | |
| PL/SQL | explizite Transaktionen, kein `WHEN OTHERS THEN NULL` | |

### 3d — Airflow / Data Engineering (Owner: __________)
Quelle: [`airflow.md`](../../.claude/rules/airflow.md) · lädt bei `dags/`

| Was | Aktueller Default | Entscheidung |
|---|---|---|
| Idempotenz | MERGE/Partition-Overwrite, keine blinden Appends | |
| Backfill | logisches Datum aus dem Data-Interval, nie `datetime.now()` | |
| Top-Level-Code | keine DB-/API-Calls/Imports auf Modulebene | |
| Fehlersichtbarkeit | `retries` + Alerting explizit | |
| `catchup` | bewusst je DAG setzen | |
| Secrets | über Connections/Variables/Secrets-Backend | |

---

## Checkliste zum Abschluss von Phase B
- [ ] Ebene 1 (Leitplanken) im kleinen Kreis entschieden und in `_check.py` / `settings.json` verankert
- [ ] Änderungen an Durchsetzung **getestet** (verbotene Aktion wird wirklich geblockt)
- [ ] Ebene 2 (firmweiter Kontext) durchgegangen und angepasst
- [ ] Je Domäne eine Werkstatt gemacht, Owner benannt, Regeldatei aktualisiert
- [ ] Jede Entscheidung als ADR in `docs/adr/` festgehalten
- [ ] Konsolidierter Review + Freigabe dokumentiert (Datum, Teilnehmende) → DoD #1 & #2 erfüllt
