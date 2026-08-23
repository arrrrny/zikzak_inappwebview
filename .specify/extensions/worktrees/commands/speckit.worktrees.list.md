---
description: "Dashboard of all active worktrees with spec-artifact and task progress"
---

# List Worktrees

Show all active git worktrees with their feature branch status, spec artifact availability, and task completion progress.

## User Input

```text
$ARGUMENTS
```

You **MUST** consider the user input before proceeding (if not empty). The user may request:
- `compact` — one-line-per-worktree summary
- `stale` — show only stale/idle worktrees
- A specific branch name — show details for that worktree only

## Prerequisites

1. Verify the project is a git repository
2. Verify `git worktree list` returns results

## Outline

1. **List all worktrees**: Run `git worktree list --porcelain` and parse the output.
   Extract for each worktree: path, branch, HEAD commit, prunable status.
   Identify the primary checkout vs. linked worktrees.

2. **Read config**: Load `layout` from `worktree-config.yml` to determine whether to look for worktrees in `.worktrees/` (nested) or sibling directories (sibling). For sibling layout, also list directories matching the sibling pattern `../<repo>--*`.

3. **Gather feature status per worktree**:
   - **Branch name**: The checked-out branch
   - **Spec artifacts**: Check `specs/<branch>/` for spec.md, plan.md, tasks.md, research.md, data-model.md
   - **Task progress**: If `specs/<branch>/tasks.md` exists, count `- [x]` vs `- [ ]` lines
   - **Last activity**: `git log -1 --format='%ar' <branch>` (e.g., "2 hours ago")
   - **Merge status**: `git branch --merged main | grep <branch>`
   - **Uncommitted changes**: `git -C <worktree-path> status --porcelain | wc -l`

4. **Classify status**:

   | Status | Condition |
   |--------|-----------|
   | Active | Commits within 7 days, unmerged |
   | Idle | No commits for 7-30 days, unmerged |
   | Stale | No commits for 30+ days, unmerged |
   | Merged | Branch merged into main/master |
   | Orphaned | Branch deleted but worktree exists |

5. **Output dashboard**:

   ```markdown
   ## Active Worktrees

   | # | Branch | Path | Status | Artifacts | Tasks | Last Activity | Dirty |
   |---|--------|------|--------|-----------|-------|---------------|-------|
   | 1 | 003-user-auth | ../MyProject--003-user-auth | Active | spec plan tasks | 12/18 (67%) | 2h ago | 3 files |
   | 2 | 005-api-gateway | ../MyProject--005-api-gateway | Merged | spec plan tasks | 8/8 (100%) | 3d ago | clean |

   **Summary**: 2 worktrees + primary checkout | 1 ready to clean (merged)

   **Recommended actions:**
   - Run `/speckit.worktrees.clean` to remove merged worktree (005-api-gateway)
   ```

## Rules

- **Read-only** — this command never modifies any files or worktrees
- **Include primary checkout** — show the main working directory for context
- **Show all worktrees** — regardless of layout; list both sibling and nested if mixed
- **Accurate counts** — task progress must reflect actual checkbox state in tasks.md
