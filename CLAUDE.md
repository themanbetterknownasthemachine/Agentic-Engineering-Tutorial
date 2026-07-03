# Project: <PROJECT_NAME>

<One-line description of what this repository does.>

Pistor BIDA project. Stack: `<STACK>` (fill per project — e.g. dbt + Snowflake,
Python forecasting, Power BI, or Oracle; see AGENTS.md and `docs/domain-setup/`).
Keep this file concise (target < 200 lines). Detailed, path-specific conventions live in
`.claude/rules/` and load automatically; multi-step procedures live in `.claude/skills/`.

> Setup gate: if any angle-bracket placeholder (project name, stack, dev schema,
> quality bar, inference-object references) is still present in this file or AGENTS.md,
> the project is not set up. Stop and complete the checklist in README.md
> ("Pro Projekt anpassen") before building. Verify with `bash scripts/check-template.sh`.

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
