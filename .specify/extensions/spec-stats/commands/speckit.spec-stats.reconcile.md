---
description: "Reconcile tasks.md checkboxes against actual implementation — cross-references TDD test-list.md DONE behaviors and file existence to mark tasks that were implemented but never checked"
---

# Spec Stats — Reconcile

Fix stale `tasks.md` checkboxes by cross-referencing actual implementation state.
When features are implemented without updating the task checkboxes (common in
fast-paced development), this command corrects the tracking to match reality.

## How it works

For each spec, the reconcile engine applies two strategies:

1. **Behavior-based** (fast, no execution): If a task has behavior markers
   (e.g., `[A1]`, `[U8]`) and the corresponding behaviors are `DONE` in
   `tdd/test-list.md`, the task is marked `[x]`. DROPPED behaviors are left
   unchecked by default (configurable via `--drop-mark`).

2. **File-existence-based** (for tasks without behavior markers): If a task
   references a file path (e.g., `` `lib/src/foo.dart` ``) and the file exists
   in the codebase, the task is marked `[x]`.

Tasks that cannot be auto-verified are reported as "needs manual check."

## User Input

```text
$ARGUMENTS
```

Accept any of:

- `--all` — reconcile all specs in the project
- `<spec>...` — specific spec IDs or slugs (e.g., `011`, `herdr-pane-management`)
- `--dry-run` — show what would change without writing files
- `--drop-mark checked|unchecked` — how to handle DROPPED behaviors (default: `unchecked`)
- `--out <path>` — write report to this path instead of stdout

When no spec is specified and no active feature is set, reconciles all specs.

## Execution

Run the bundled Node engine from the repository root:

```bash
node .specify/extensions/spec-stats/scripts/spec-stats.mjs reconcile --all --dry-run
# Review what would change

node .specify/extensions/spec-stats/scripts/spec-stats.mjs reconcile --all
# Apply changes

node .specify/extensions/spec-stats/scripts/spec-stats.mjs reconcile 011 012
# Reconcile specific specs
```

The engine:
1. Reads `tdd/test-list.md` for each spec (if present) and extracts DONE/DROPPED behavior IDs.
2. Reads `tasks.md` and finds tasks with behavior markers like `[A1]`, `[U8]`.
3. For each unchecked task:
   - If ALL its behavior markers are DONE → mark `[x]`
   - If any marker is DROPPED and `--drop-mark checked` → mark `[x]`
   - If no behavior markers but referenced files exist → mark `[x]`
   - Otherwise → leave unchecked, report as "needs manual check"
4. Writes the updated `tasks.md` (unless `--dry-run`).
5. Reports a summary of changes.

## Report format

```
# Spec Stats — Reconcile

- **011-zuraffa-tui-dashboard**: 76 checked, 0 already done, 2 need manual check
  ✓ Create TUI dashboard entry point in `bin/tui_dashboard.dart` — files exist: bin/tui_dashboard.dart
  ...

- **012-herdr-pane-management**: 112 checked, 0 already done, 6 need manual check
  ✓ [A1] Acceptance test... — behaviors [A1] all DONE
  ...

**Total**: 188 tasks reconciled, 0 already correct, 8 need manual check
```

## Guardrails

- **Read-only by default**: Use `--dry-run` to preview changes before applying.
- **Never removes checks**: Only adds `[x]` marks, never unchecks a task.
- **Preserves formatting**: Only modifies the `[ ]` → `[x]` character, leaving the rest of each line intact.
- **Idempotent**: Running reconcile twice produces no additional changes.
