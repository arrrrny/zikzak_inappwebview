---
description: "On-demand execution — reads verified suite command from .specify/memory/tdd-profile.md, runs it for selected specs (--all, spec id/slug, or default active feature), captures pass/fail + duration + tail, appends run record to .specify/stats/runs.json, refreshes dashboard health column"
---

# Spec Stats — Runs

Execute the verified test suite for one or more specs and record the result.

## User Input

```text
$ARGUMENTS
```

Accepted forms:
- (nothing) — run for the active feature (from `.specify/feature.json`)
- `<spec>` `<spec>` … — run for the named spec directories
- `--all` — run for every spec directory
- `--dry-run` — print what would run without executing anything

## Execution

```bash
node .specify/extensions/spec-stats/scripts/spec-stats.mjs runs
# or: node .specify/extensions/spec-stats/scripts/spec-stats.mjs runs --all --dry-run
# or: node .specify/extensions/spec-stats/scripts/spec-stats.mjs runs specs/003-user-auth
```

The engine:
1. Reads the **verified full-suite command** from `.specify/memory/tdd-profile.md`. If absent, it stops and tells the user to run `/speckit.tdd.setup` — it never invents a command.
2. Runs that command inside each selected spec directory.
3. Captures pass/fail, duration (ms), and the last 5 lines of output.
4. Appends a bounded record to `.specify/stats/runs.json`.

**This is the only Spec Stats command that executes project commands.** Honors `--dry-run` and never mutates a spec or its tasks.
