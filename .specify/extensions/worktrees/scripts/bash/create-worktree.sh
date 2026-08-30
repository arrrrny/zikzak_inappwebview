#!/usr/bin/env bash
# spec-kit-worktree-parallel: create-worktree.sh
# Deterministic worktree creation for parallel agents/features.
# Called by the speckit.worktrees.create command or after_specify hook.
#
# Usage:
#   create-worktree.sh [options] <branch-name>
#
# Options:
#   --layout sibling|nested   Override config layout (default: sibling)
#   --path <dir>              Explicit worktree path (overrides layout)
#   --in-place                Skip worktree creation; no-op exit 0
#   --json                    Output JSON instead of key=value
#   --dry-run                 Compute paths without creating anything
#   --base-ref <ref>          Base ref for new branch (default: auto-detect)
#   --repo-root <dir>         Repository root (default: git rev-parse --show-toplevel)
#   --config <file>           Path to worktree-config.yml (default: auto-detect)
#   --help                    Show this help

set -euo pipefail

# --- defaults ---
LAYOUT="nested"
WORKTREE_PATH_OVERRIDE=""
IN_PLACE=false
JSON_MODE=false
DRY_RUN=false
BASE_REF=""
REPO_ROOT=""
CONFIG_FILE=""
BRANCH_NAME=""

# --- parse args ---
while [[ $# -gt 0 ]]; do
  case "$1" in
    --layout)      LAYOUT="$2"; shift 2 ;;
    --path)        WORKTREE_PATH_OVERRIDE="$2"; shift 2 ;;
    --in-place)    IN_PLACE=true; shift ;;
    --json)        JSON_MODE=true; shift ;;
    --dry-run)     DRY_RUN=true; shift ;;
    --base-ref)    BASE_REF="$2"; shift 2 ;;
    --repo-root)   REPO_ROOT="$2"; shift 2 ;;
    --config)      CONFIG_FILE="$2"; shift 2 ;;
    --help|-h)
      echo "Usage: $0 [options] <branch-name>"
      echo ""
      echo "Options:"
      echo "  --layout nested|sibling   Worktree location strategy (default: nested)"
      echo "  --path <dir>              Explicit worktree path (overrides layout)"
      echo "  --in-place                Skip worktree creation (no-op exit 0)"
      echo "  --json                    Output JSON instead of key=value"
      echo "  --dry-run                 Compute paths without creating anything"
      echo "  --base-ref <ref>          Base ref for new branch (default: auto-detect)"
      echo "  --repo-root <dir>         Repository root (default: git rev-parse)"
      echo "  --config <file>           Path to worktree-config.yml"
      echo "  --help                    Show this help"
      exit 0
      ;;
    -*)
      echo "Error: unknown option $1" >&2; exit 1 ;;
    *)
      if [[ -z "$BRANCH_NAME" ]]; then
        BRANCH_NAME="$1"
      else
        echo "Error: unexpected argument '$1' (branch already set to '$BRANCH_NAME')" >&2; exit 1
      fi
      shift ;;
  esac
done

if [[ -z "$BRANCH_NAME" ]]; then
  echo "Error: branch name is required" >&2
  echo "Usage: $0 [options] <branch-name>" >&2
  exit 1
fi

# --- resolve repo root ---
if [[ -z "$REPO_ROOT" ]]; then
  REPO_ROOT="$(git rev-parse --show-toplevel 2>/dev/null)" || {
    echo "Error: not inside a git repository" >&2; exit 1
  }
fi

# --- load config ---
load_config_value() {
  local key="$1" default="$2" file="$CONFIG_FILE"
  if [[ -z "$file" ]]; then
    # auto-detect: extension config in .specify
    for candidate in \
      "$REPO_ROOT/.specify/extensions/worktrees/worktree-config.yml" \
      "$REPO_ROOT/.specify/extensions/worktrees/config.yml"; do
      if [[ -f "$candidate" ]]; then file="$candidate"; break; fi
    done
  fi
  if [[ -n "$file" ]] && [[ -f "$file" ]]; then
    local val
    val=$(grep -E "^${key}:" "$file" 2>/dev/null | head -1 | sed 's/^[^:]*: *//; s/ *#.*//; s/^"//; s/"$//' || true)
    if [[ -n "$val" ]]; then echo "$val"; return; fi
  fi
  echo "$default"
}

if [[ "$IN_PLACE" == true ]]; then
  # --in-place: no worktree, just report and exit
  if $JSON_MODE; then
    printf '{"branch":"%s","worktree":false,"path":""}\n' "$BRANCH_NAME"
  else
    echo "WORKTREE=false"
    echo "BRANCH=$BRANCH_NAME"
  fi
  exit 0
fi

# Override layout from env or config
if [[ -z "$WORKTREE_PATH_OVERRIDE" ]]; then
  LAYOUT=$(load_config_value "layout" "$LAYOUT")
fi
AUTO_CREATE=$(load_config_value "auto_create" "true")
SIBLING_PATTERN=$(load_config_value "sibling_pattern" '{{repo}}--{{branch}}')
DOTWORKTREES_DIR=$(load_config_value "dotworktrees_dir" ".worktrees")

# env override
if [[ -n "${SPECIFY_WORKTREE_PATH:-}" ]]; then
  WORKTREE_PATH_OVERRIDE="$SPECIFY_WORKTREE_PATH"
fi

# --- resolve worktree target path ---
resolve_worktree_path() {
  if [[ -n "$WORKTREE_PATH_OVERRIDE" ]]; then
    if [[ "$WORKTREE_PATH_OVERRIDE" = /* ]]; then
      echo "$WORKTREE_PATH_OVERRIDE"
    else
      local _d _f
      _d=$(dirname "$WORKTREE_PATH_OVERRIDE")
      _f=$(basename "$WORKTREE_PATH_OVERRIDE")
      echo "$(cd "$REPO_ROOT" && cd "$_d" 2>/dev/null && pwd)/$_f"
    fi
    return
  fi

  local safe_branch
  safe_branch="$(echo "$BRANCH_NAME" | tr '/ ' '--')"

  case "$LAYOUT" in
    sibling)
      local parent base
      parent="$(dirname -- "$REPO_ROOT")"
      base="$(basename -- "$REPO_ROOT")"
      local name="$SIBLING_PATTERN"
      name="${name//\{\{repo\}\}/$base}"
      name="${name//\{\{branch\}\}/$safe_branch}"
      echo "${parent}/${name}"
      ;;
    nested)
      echo "${REPO_ROOT}/${DOTWORKTREES_DIR}/${safe_branch}"
      ;;
    *)
      echo "Error: unknown layout '$LAYOUT' (expected: sibling, nested)" >&2
      exit 1
      ;;
  esac
}

WT_TARGET=$(resolve_worktree_path)

# --- resolve base ref ---
resolve_base_ref() {
  if [[ -n "$BASE_REF" ]]; then echo "$BASE_REF"; return; fi
  if git -C "$REPO_ROOT" rev-parse --verify origin/main >/dev/null 2>&1; then echo "origin/main"
  elif git -C "$REPO_ROOT" rev-parse --verify main >/dev/null 2>&1; then echo "main"
  elif git -C "$REPO_ROOT" rev-parse --verify origin/master >/dev/null 2>&1; then echo "origin/master"
  elif git -C "$REPO_ROOT" rev-parse --verify master >/dev/null 2>&1; then echo "master"
  else echo "HEAD"
  fi
}

# --- dry-run ---
if [[ "$DRY_RUN" == true ]]; then
  if $JSON_MODE; then
    printf '{"branch":"%s","worktree":true,"path":"%s","layout":"%s","dry_run":true}\n' \
      "$BRANCH_NAME" "$WT_TARGET" "$LAYOUT"
  else
    echo "WORKTREE=true"
    echo "BRANCH=$BRANCH_NAME"
    echo "PATH=$WT_TARGET"
    echo "LAYOUT=$LAYOUT"
    echo "DRY_RUN=true"
  fi
  exit 0
fi

# --- guard: target must not exist ---
if [[ -e "$WT_TARGET" ]]; then
  echo "Error: worktree path already exists: $WT_TARGET" >&2
  echo "Remove it, set SPECIFY_WORKTREE_PATH, or pass --path to another directory." >&2
  exit 1
fi

# --- ensure .worktrees/ is gitignored for nested layout ---
if [[ "$LAYOUT" == "nested" ]]; then
  local_gitignore="$REPO_ROOT/.gitignore"
  if ! grep -qxF "$DOTWORKTREES_DIR/" "$local_gitignore" 2>/dev/null; then
    echo "$DOTWORKTREES_DIR/" >> "$local_gitignore"
  fi
fi

# --- create worktree ---
RESOLVED_BASE=$(resolve_base_ref)

if git -C "$REPO_ROOT" show-ref --verify --quiet "refs/heads/$BRANCH_NAME"; then
  # Branch exists locally — attach worktree to it
  if ! git -C "$REPO_ROOT" worktree add "$WT_TARGET" "$BRANCH_NAME" 2>/dev/null; then
    echo "Error: git worktree add failed for existing branch '$BRANCH_NAME' at '$WT_TARGET'." >&2
    exit 1
  fi
else
  # Create new branch + worktree from base ref
  if ! git -C "$REPO_ROOT" worktree add -b "$BRANCH_NAME" "$WT_TARGET" "$RESOLVED_BASE" 2>/dev/null; then
    echo "Error: git worktree add -b '$BRANCH_NAME' at '$WT_TARGET' from '$RESOLVED_BASE' failed." >&2
    echo "Run 'git fetch' or use --in-place if worktrees are not available." >&2
    exit 1
  fi
fi

echo "[worktrees] Created: $WT_TARGET (branch $BRANCH_NAME)" >&2

# --- output ---
if $JSON_MODE; then
  printf '{"branch":"%s","worktree":true,"path":"%s","layout":"%s"}\n' \
    "$BRANCH_NAME" "$WT_TARGET" "$LAYOUT"
else
  echo "WORKTREE=true"
  echo "BRANCH=$BRANCH_NAME"
  echo "PATH=$WT_TARGET"
  echo "LAYOUT=$LAYOUT"
fi
