# Project: <PROJECT_NAME>

<One-line description of what this repository does.>

This is a Pistor BIDA data/ML project (dbt + Snowflake, Python forecasting, Power BI).
Keep this file concise (target < 200 lines). Detailed, path-specific conventions live in
`.claude/rules/` and load automatically; multi-step procedures live in `.claude/skills/`.

## Shared core (single source of truth)
The operating principle, technology, architecture, commands, workflow, non-negotiable
rules, and definition of done live in AGENTS.md - shared with all coding agents:

@AGENTS.md

## Claude-Code-specific
- For new work, run `/spec` and `/criteria` before implementing; see @docs/WORKFLOW.md.
- Path-bound conventions load automatically from `.claude/rules/`
  (dbt-snowflake, oracle, dax, airflow, python, forecasting, testing, security).
- Read-only subagents for checking: `code-reviewer`, `security-reviewer`.

<!-- Maintainer note: this file is context, not enforcement. Hard blocks live in
     .claude/settings.json (permissions.deny) and .claude/hooks/protect-files.sh.
     This HTML comment is stripped before the file is injected into Claude's context. -->
