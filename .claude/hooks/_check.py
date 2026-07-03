"""Prueft PreToolUse-Payloads auf gefaehrliche Operationen (stdin: JSON).

Gibt bei Treffer eine Begruendung auf stdout aus; protect-files.sh blockt dann
mit Exit 2. Praezisiert, um False Positives zu vermeiden:

- Credential-Dateien: bei Edit/Write/NotebookEdit zaehlt nur der Dateipfad,
  nicht der Inhalt (Doku darf ueber .env & Co. SCHREIBEN).
- Destruktives SQL wird nur geblockt, wenn das Kommando nach SQL-Ausfuehrung
  aussieht (snowsql, snow sql, dbt(f) run-operation, sqlplus, ...) oder ein
  MCP-Query-Tool aufgerufen wird - nicht bei jedem Vorkommen des Wortes.
"""

import json
import re
import sys

# .env / .env.local usw. als Pfad-Token, aber nicht .env.example (keine Secrets)
SECRET_FILE = re.compile(
    r"(^|[\\/\s\"'=(])\.e"
    r"nv(\.(?!example\b)\w+)?([^\w.\-]|$)"
    r"|\.(p"
    r"8|pem)\b"
    r"|(^|[\\/\s\"'=(])[\w.\-]+\.key([^\w.\-]|$)",
    re.IGNORECASE,
)

# Kommandos, die SQL gegen eine Datenbank ausfuehren koennen
SQL_RUNNER = re.compile(
    r"\b(snowsql|snow\s+sql|dbtf?\s+run-operation|sqlplus|sqlcmd|psql|sqlite3)\b",
    re.IGNORECASE,
)
# bewusst ohne schliessende Wortgrenze: faengt auch Makro-/Prozedurnamen
# wie truncate_stage im SQL-Runner-Kontext (fail-closed)
DESTRUCTIVE_SQL = re.compile(r"\b(DROP|DELETE|TRUNCATE)", re.IGNORECASE)


def check(tool: str, tool_input: dict) -> str | None:
    if tool in ("Read", "Edit", "Write", "NotebookEdit"):
        path = str(tool_input.get("file_path") or tool_input.get("notebook_path") or "")
        if SECRET_FILE.search(path):
            return "Zugriff auf Credential-Dateien"
        return None

    if tool == "Bash":
        cmd = str(tool_input.get("command", ""))
        if SECRET_FILE.search(cmd):
            return "Zugriff auf Credential-Dateien"
        if SQL_RUNNER.search(cmd) and DESTRUCTIVE_SQL.search(cmd):
            return "destruktives SQL (DROP/DELETE/TRUNCATE) via CLI"
        return None

    if tool.startswith("mcp__"):
        haystack = " ".join(str(v) for v in tool_input.values())
        if DESTRUCTIVE_SQL.search(haystack):
            return "destruktives SQL (DROP/DELETE/TRUNCATE) via MCP"
        return None

    return None


def main() -> None:
    try:
        data = json.load(sys.stdin)
    except Exception:
        return
    reason = check(str(data.get("tool_name", "")), data.get("tool_input", {}) or {})
    if reason:
        print(reason)


if __name__ == "__main__":
    main()
