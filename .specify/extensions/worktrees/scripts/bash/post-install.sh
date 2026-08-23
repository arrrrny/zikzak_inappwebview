#!/usr/bin/env bash
# post-install.sh — runs after `specify extension add worktrees`
# Ensures .worktrees/ is in .gitignore immediately so the directory
# is ignored before any worktree is ever created.

set -euo pipefail

REPO_ROOT="$(git rev-parse --show-toplevel 2>/dev/null)" || exit 0

# Load dotworktrees_dir from config, fall back to .worktrees
CONFIG_FILE="$REPO_ROOT/.specify/extensions/worktrees/worktree-config.yml"
DOTWORKTREES_DIR=".worktrees"
if [[ -f "$CONFIG_FILE" ]]; then
  val=$(grep -E "^dotworktrees_dir:" "$CONFIG_FILE" 2>/dev/null | head -1 | sed 's/^[^:]*: *//; s/ *#.*//; s/^"//; s/"$//' || true)
  if [[ -n "$val" ]]; then DOTWORKTREES_DIR="$val"; fi
fi

GITIGNORE="$REPO_ROOT/.gitignore"

if ! grep -qxF "$DOTWORKTREES_DIR/" "$GITIGNORE" 2>/dev/null; then
  echo "$DOTWORKTREES_DIR/" >> "$GITIGNORE"
  echo "[worktrees] Added '$DOTWORKTREES_DIR/' to .gitignore" >&2
fi
