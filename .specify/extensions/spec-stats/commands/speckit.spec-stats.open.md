---
description: "On-demand view of everything not complete: what stage each is stuck at, what the immediate next artifact/command is, oldest-untouched first, stale warnings past stale_after_days"
---

# Spec Stats — Open

Show every spec that is **not** complete, oldest-untouched first, with stale warnings.

## User Input

```text
$ARGUMENTS
```

Optional flags:
- `--stale-after <days>` — override config `stale_after_days` (default 14)
- `--json` — machine-readable output

## Execution

```bash
node .specify/extensions/spec-stats/scripts/spec-stats.mjs open
# or: node .specify/extensions/spec-stats/scripts/spec-stats.mjs open --stale-after 7
```

The engine lists each incomplete feature with its current stage, progress (`checked/total`), last-updated date, and a `⚠️ stale` flag when untouched past the threshold. Read-only.
