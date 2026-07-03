---
name: handover
description: Close the outer loop of a piece of work. Move its spec from docs/specs/active/ to completed/ and produce a short handover summary. Use when a task is done and verified, or when the user runs /handover.
---

# Handover (close the loop)

Use when work is finished and its verifier passes. Do not run this on unfinished work.

Steps:
1. Confirm the work is done: the verifier passes (`python eval/eval_<thema>.py`
   or `dbtf test`, exit 0), tests/lint/typecheck are green. If not, stop and say so.
2. Identify the relevant spec in `docs/specs/active/`. If none exists, note that.
3. Move it to `docs/specs/completed/` (`git mv`), keeping the filename.
4. Append a short closing summary to the moved spec:
   - what was built, which files changed;
   - how it was verified (verifier + result);
   - any residual risks or follow-ups.
5. Write a 5-10 line handover message for the next person: what changed, how to
   run it, what to watch. Do not push or merge unless explicitly asked.
