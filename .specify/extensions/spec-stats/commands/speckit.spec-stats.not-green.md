---
description: "On-demand view of specs whose latest test evidence is red or unknown, with the exact evidence line quoted from tdd/cycle-log.md and the command that would produce evidence"
---

# Spec Stats — Not Green

Show specs whose TDD state is not green — a TDD list exists but no behavior has reached `DONE` (or the suite is red).

## User Input

```text
$ARGUMENTS
```

Optional flags:
- `--json` — machine-readable output

## Execution

```bash
node .specify/extensions/spec-stats/scripts/spec-stats.mjs not-green
```

The engine scans each feature with a `tdd/test-list.md` and reports those with zero `DONE` behaviors, quoting the loop mode (`full` / `outer-only` / `inside-out`) so the user knows whether the inner loop was ever derived. For red-suite evidence, point the user at the feature's `tdd/cycle-log.md`. Read-only.
