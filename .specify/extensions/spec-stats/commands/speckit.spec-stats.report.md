---
description: "Main generator — scans all specs/*/, derives per-feature stage, task progress, health, last updated; when the TDD extension is installed, adds a deep TDD table (acceptance/unit/characterization counts, DONE, loop mode, tasks.md state); renders dashboard to configurable output path and writes .specify/stats/stats.json snapshot"
---

# Spec Stats — Report

Generate the spec portfolio dashboard for the current project.

## User Input

```text
$ARGUMENTS
```

Optional flags:
- `--json` — print the machine-readable `stats.json` to stdout (no files written)
- `--out <path>` — write the markdown dashboard to this path (overrides config `output_path`)
- `--render --in <stats.json>` — render an existing snapshot instead of re-scanning

## Execution

Run the bundled Node engine from the repository root:

```bash
node .specify/extensions/spec-stats/scripts/spec-stats.mjs report
# or: node .specify/extensions/spec-stats/scripts/spec-stats.mjs report --json
# or: node .specify/extensions/spec-stats/scripts/spec-stats.mjs report --out /tmp/stats.md
```

The engine:
1. Lists every `specs/<NNN>-<slug>/` directory.
2. Detects each feature's stage (`specified → planned → tasked → implementing → complete`) from file presence and `tasks.md` checkbox counts.
3. Detects whether the **TDD extension is installed** in this project (`.specify/memory/tdd-profile.md` or `.specify/extensions/tdd`). When installed, it reads each feature's `tdd/test-list.md` and renders the **TDD Deep Stats** table with columns: `#`, `feature`, `A` (acceptance behaviors), `U` (unit behaviors), `char` (characterization behaviors), `DONE` (behaviors in `DONE` state), `loop` (`full` / `outer-only` / `inside-out` / `absent`), and `tasks.md` (`updated` when TDD markers are present, else `absent`), plus a totals row.
4. Writes the dashboard to `output_path` (default `.specify/stats/SPEC-STATS.md`) and a `stats.json` snapshot beside it.

Report the output path (or the JSON) back to the user. This command is **read-only** — it never modifies specs, tasks, or code.
