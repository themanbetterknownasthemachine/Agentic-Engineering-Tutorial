# Security rules

- IMPORTANT: never read, print, or commit `.env`, `*.p8`, or any credentials.
- No secrets in `.mcp.json`, settings, skills, or code. Reference env vars instead.
- Never run DROP, DELETE, or TRUNCATE against a database without explicit approval.
- Do not push or merge unless explicitly requested.
- Mark generated files clearly so they are never mistaken for source.

## How enforcement works (two layers)

These rules are context. The hard blocks are enforced in two layers:

1. **Primary: `.claude/hooks/protect-files.sh`** (PreToolUse hook, exit 2).
   It runs `_check.py`, which inspects the tool payload and blocks:
   - reads/edits/writes whose *path* is a credential file (`.env`, `.env.local`,
     `*.p8`, `*.pem`, `*.key`) — `.env.example` is allowed;
   - destructive SQL (`DROP`/`DELETE`/`TRUNCATE`) only when the command actually
     runs SQL (`snowsql`, `snow sql`, `dbt(f) run-operation`, `sqlplus`, `sqlcmd`,
     `psql`, `sqlite3`) or via an MCP query tool.
   The hook is fail-closed: no Python interpreter → block.

2. **Second layer: `.claude/settings.json` `permissions.deny`.**
   This is a coarse backstop, not the main defense. Note the deliberate absence of
   `Bash(*DROP *)`-style rules: Claude Code permission globs cannot match a
   substring in the *middle* of a Bash command, so such a rule gives false
   confidence. Reliable DDL blocking lives in the hook (layer 1). The deny list
   keeps only patterns that match reliably (credential-file paths, `git push`).
