---
description: "Remove merged, orphaned, or stale worktrees and reclaim disk space"
---

# Clean Worktrees

Remove worktrees for branches that have been merged or are no longer needed. Safely cleans up worktree directories and reclaims disk space.

## User Input

```text
$ARGUMENTS
```

You **MUST** consider the user input before proceeding (if not empty). The user may specify:
- A branch name (e.g., `005-api-gateway`) — remove that worktree only
- `merged` — remove all merged worktrees
- `stale` — remove stale worktrees (30+ days inactive)
- `all` — remove all worktrees (with strong warning)
- No input — remove merged and orphaned only (safest default)

## Prerequisites

1. Verify the project is a git repository
2. Verify worktrees exist (run `git worktree list` — should show more than the primary checkout)

## Outline

1. **Scan worktrees**: List all linked worktrees and classify them:
   - **Merged**: Branch merged into main/master — safe to remove
   - **Orphaned**: Branch deleted but worktree directory exists — safe to remove
   - **Stale**: No commits for 30+ days, not merged — warn before removing
   - **Active**: Recent activity, not merged — refuse unless `all` specified
   - **Dirty**: Has uncommitted changes — extra warning regardless of status

2. **Build cleanup plan**: Based on user input, determine what to remove.

   | User Input | Targets |
   |-----------|---------|
   | Specific branch | That worktree only (with confirmation) |
   | `merged` | All merged worktrees |
   | `stale` | All stale worktrees (30+ days) |
   | `all` | Everything except the primary checkout |
   | No input | Merged + orphaned only |

3. **Present cleanup plan** (always show before acting):

   ```markdown
   ## Worktree Cleanup Plan

   | # | Branch | Path | Status | Dirty | Action |
   |---|--------|------|--------|-------|--------|
   | 1 | 005-api-gateway | ../MyProject--005-api-gateway | Merged | clean | REMOVE |
   | 2 | 002-old-feature | ../MyProject--002-old-feature | Orphaned | clean | REMOVE |
   | 3 | 004-chat-system | ../MyProject--004-chat-system | Idle | 2 files | KEEP |

   **Will remove**: 2 worktrees
   **Will keep**: 1 worktree

   Proceed? (confirm before executing)
   ```

4. **Wait for user confirmation** before executing any removal.

5. **Check for uncommitted changes** before each removal:
   - Run `git -C <path> status --porcelain`
   - If dirty, list the files and ask for explicit confirmation
   - Skip removal if the user declines

6. **Execute cleanup** for each confirmed worktree:
   - Run `git worktree remove <path>` (or `git worktree remove --force <path>` if confirmed for dirty)
   - If locked, run `git worktree unlock <path>` first
   - Run `git worktree prune` after all removals

7. **Report summary**:
   - How many worktrees removed
   - How many remain
   - Any that were skipped (with reason)

## Rules

- **Never remove without confirmation** — always present the plan and wait for approval
- **Never remove the primary checkout** — only linked worktrees
- **Warn about uncommitted changes** — refuse to remove dirty worktrees unless explicitly confirmed
- **Safe defaults** — with no input, only merged and orphaned are targeted
- **Prune after cleanup** — always run `git worktree prune`
- **Never delete branches** — removing a worktree does not delete the git branch
- **Works for both layouts** — handle sibling dirs and `.worktrees/` dirs equally
