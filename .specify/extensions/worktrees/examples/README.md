# Examples

## Cursor + Spec Kit (`cursor-worktrees.spec-kit.example.json`)

Cursor can isolate a chat in a **separate checkout** using **`/worktree`** and configure bootstrap with **`.cursor/worktrees.json`** ([Cursor worktrees docs](https://cursor.com/docs/configuration/worktrees)).

1. Copy `cursor-worktrees.spec-kit.example.json` to **`.cursor/worktrees.json`** at your **project root** (the tree you open in Cursor — usually your main clone).
2. Edit the arrays: add **`npm ci`**, **`uv sync`**, migrations, etc., after the copy lines as your stack requires.
3. Start a feature chat with **`/worktree …`**, then run **`/speckit.specify`** and the rest of Spec Kit **in that same chat** so agent tools use the isolated checkout.

The example uses **`$ROOT_WORKTREE_PATH`** so secrets and a **local-only** `.specify` (if you copy it from the primary tree) follow the Cursor worktree. If `.specify` is **fully committed** in git, the clone may already include it — keep or drop the `cp -R .specify` line accordingly.

This file is **not** installed into target projects by `specify extension add`; it lives in this repo for you to copy when you set up Cursor.
