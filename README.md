# BIDA Claude Code Projekt-Template

Ein push-fertiges Skelett, um ein neues Projekt so aufzusetzen, dass du Claude Code (Agentic
Engineering) optimal nutzen kannst. Es folgt einer sauberen, konventionellen Softwarestruktur
und ergänzt sie um den `.claude`-Ordner mit Kontext, Regeln, Skills, Subagents und Leitplanken.

## Die Grundidee

> Erst sagst **du**, was gebaut werden soll (Spec) und woran man Erfolg misst (Verifier) –
> dann baut **Claude** den Code in einer Schleife, bis das Erfolgssignal grün ist.

Die Arbeitsteilung dahinter:

- **Der Mensch besitzt drei Dinge:** die Spec (was soll besser werden?), die finale Bewertung
  (ist es wirklich deploy-reif?) und das Verständnis (was passiert da fachlich?).
- **Der Agent besitzt eine Sache:** die Implementierung in der Schleife – Code schreiben, testen,
  Fehler sehen, korrigieren, bis es passt.

Der ganze Sinn des Templates ist, diese Arbeitsteilung von Anfang an sauber aufzustellen, statt
Claude blind drauflos coden zu lassen. Den vollständigen Ablauf von der Spec bis zur produktiven
View findest du in [`docs/WORKFLOW.md`](docs/WORKFLOW.md).

## Pro Projekt anpassen (Checkliste)

Beim Start eines neuen Projekts nur diese Dateien anfassen, der Rest des Skeletts bleibt unverändert:

- [ ] **Domäne wählen**: `bash scripts/init-domain.sh <ml|de|dwh|pbi>` entfernt nicht
      benötigte Domänen-Ordner (siehe `docs/domain-setup/`)
- [ ] **AGENTS.md**: `<PROJECT_NAME>`, Stack, Architektur, `<QUALITY_BAR>` setzen
      (geteilte Quelle der Wahrheit; CLAUDE.md importiert sie)
- [ ] **CLAUDE.md**: `<PROJECT_NAME>` und Beschreibung ersetzen (Kern liegt in AGENTS.md)
- [ ] **.env**: aus `.env.example` kopieren und Werte eintragen (wird nie committet)
- [ ] **.mcp.json**: Platzhalter `REPLACE_WITH_YOUR_SNOWFLAKE_MCP_COMMAND` durch den echten Snowflake-MCP-Befehl ersetzen
- [ ] **README.md / docs/architecture.md**: optional an das konkrete Projekt anpassen

Unverändert bleiben: `.claude/rules/`, `.claude/skills/`, `.claude/agents/`, `.claude/hooks/`, `.claude/settings.json`, `scripts/` und `.gitignore`.

## Einmalige Einrichtung (nur einmal pro Template-Repo)

Das macht eine Person einmalig, danach nie wieder:

1. Dieses Template einmal nach GitHub pushen.
2. Im Repo unter Settings die Option "Template repository" aktivieren.

Danach steht das Repo allen im Team als Vorlage zur Verfügung. Beim Anlegen oder Klonen eines
konkreten Projekts ist dieser Schritt nicht mehr nötig.

## Neues Projekt starten

Das machst du (oder ein Teammitglied) bei jedem neuen Projekt:

1. Auf GitHub oben rechts "Use this template" klicken, ein neues Repo anlegen und klonen.
   (Ohne GitHub: den Template-Ordner kopieren und umbenennen.)
2. Domäne wählen (`bash scripts/init-domain.sh <ml|de|dwh|pbi>`) und die Dateien aus der
   Checkliste oben anpassen: `AGENTS.md` (Kern), `CLAUDE.md`, `.env` (aus `.env.example`),
   `.mcp.json` und optional `README.md` / `docs/architecture.md`.
3. `claude` im Projekt-Root starten. Mit `/memory` prüfen, welche Dateien geladen sind, und
   optional `/init` laufen lassen, um die `CLAUDE.md` aus dem echten Code zu verfeinern.
4. `/spec` laufen lassen, kleine abgegrenzte Spec nach `docs/specs/active/`.
5. `/criteria` laufen lassen, Definition of Done in `CLAUDE.md` übernehmen.
6. Verifier bauen, bevor implementiert wird: passendes Beispiel aus `eval/examples/` nach
   `eval/eval_<thema>.py` kopieren (Kontrakt: `eval/README.md`); für DWH sind dbt-Tests der Verifier.
7. MCP und Wissensbasis anbinden; Permissions und Hooks sind bereits aktiv.

Einen vollständigen Beispiel-Durchlauf von der Spec bis zur produktiven View, inklusive einer
`/spec`-Session, einer Beispiel-Spec und einem Eval-Skript, findest du in
[`docs/WORKFLOW.md`](docs/WORKFLOW.md).

## Struktur und was jeder Baustein tut

- **CLAUDE.md** - dauerhafter, immer gültiger Projektkontext. Wird bei jeder Session als
  Kontext geladen und überlebt `/compact`. Kurz halten (unter 200 Zeilen).
- **.claude/rules/** - modulare Regeln. Dateien mit `paths`-Frontmatter laden nur, wenn Claude
  an passenden Dateien arbeitet (spart Kontext); Dateien ohne `paths` laden immer. Hier:
  `security.md` (immer), `python.md`, `forecasting.md`, `dbt-snowflake.md`, `oracle.md`,
  `dax.md`, `airflow.md`, `testing.md` - je an ihre Domänen-Pfade gebunden.
- **.claude/skills/** - wiederholbare Abläufe, je mit `/name` aufrufbar oder vom Modell bei
  Bedarf genutzt. Hier: `spec` (Interview zum Spec bauen), `criteria` (Evaluationskriterien),
  `review` (zweites Modell als Kritiker), `handover` (äußeren Loop schließen).
- **.claude/agents/** - spezialisierte Subagents mit eingegrenzter Fähigkeit. `code-reviewer`
  und `security-reviewer` sind read-only (`tools: Read, Grep, Glob`), können also prüfen, aber
  nichts ändern. Subagents nutzen, um Fähigkeit einzugrenzen, nicht nur um zu parallelisieren.
- **.claude/settings.json** - Berechtigungen (allow/deny) und Hook-Konfiguration. Geteilt,
  wird committet.
- **.claude/hooks/** - Skripte für Lifecycle-Events. `protect-files.sh` ist ein PreToolUse-Hook
  (Exit-Code 2), der Zugriffe auf Credential-Dateien und destruktives SQL im Ausführungskontext
  blockt (Details und Zwei-Schichten-Logik: `.claude/rules/security.md`). `validate-changes.sh`
  ist ein PostToolUse-Hook, der nach Edits Ruff bzw. sqlfluff laufen lässt.
- **AGENTS.md** - geteilter Kern-Kontext für alle Coding-Agents (auch Codex/VS-Code).
  CLAUDE.md importiert ihn per `@AGENTS.md` (eine Quelle der Wahrheit).
- **.mcp.json** - geteilte MCP-Server (Snowflake, GitHub). Nur env-Referenzen, keine Secrets.
- **docs/** - `architecture.md`, `adr/`, `specs/active` und `specs/completed`, `runbooks/`,
  `domain-setup/` (pro Domäne behalten/löschen) und `contracts/` (Data-Contracts-Vorlage).
- **eval/** - der Verifier-Baukasten (Exit-Code als Reward-Signal). Kontrakt in `eval/README.md`,
  kopierbare Beispiele in `eval/examples/`.
- **models/, macros/, seeds/** - dbt-Grundgerüst (Beispielmodelle + Tests, `.sqlfluff`).
- **Domänen-Ordner** - `powerbi/`, `oracle/`, `dags/`, `src/`, `notebooks/` (je mit README);
  nicht benötigte per `bash scripts/init-domain.sh <ml|de|dwh|pbi>` entfernen.
- **scripts/** - `setup`, `lint`, `test`, `verify`, `init-domain` als ausführbare Einstiegspunkte.

## Wichtig: Kontext gegen Durchsetzung

CLAUDE.md und Rules sind **Kontext**, keine erzwungene Konfiguration. Sie beeinflussen das
Verhalten, erzwingen es aber nicht. Was niemals passieren darf, gehört in eine **Deny-Permission**
in `settings.json` oder in einen **PreToolUse-Hook**. Genau das macht `protect-files.sh`.

## Secrets

Nie Secrets in `.mcp.json`, Settings, Skills oder Code. Immer env-Referenzen (`${VAR}`) und die
Werte in `.env` oder der Umgebung. `.gitignore` schützt `.env`, `*.p8` und `settings.local.json`.

## Hinweis zu persönlichen Einstellungen

- Für persönliche, nicht committete Anweisungen den Import aus dem Home-Verzeichnis nutzen
  (`@~/.claude/<datei>.md`). Das funktioniert auch über mehrere git worktrees; `CLAUDE.local.md`
  tut das nicht und gilt in einer Doku-Quelle als veraltet.
