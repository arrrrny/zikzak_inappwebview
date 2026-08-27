# spec-kit-worktree-parallel

[![Tests](https://github.com/dango85/spec-kit-worktree-parallel/actions/workflows/test.yml/badge.svg)](https://github.com/dango85/spec-kit-worktree-parallel/actions/workflows/test.yml)

**Contributing:** use a **branch + pull request** into `main` — see [CONTRIBUTING.md](CONTRIBUTING.md).

A [Spec Kit](https://github.com/github/spec-kit) extension for **default-on** git worktree isolation — work on multiple features (or run parallel agents) without checkout switching.

## Why another worktree extension?

The community [spec-kit-worktree](https://github.com/Quratulain-bilal/spec-kit-worktree) extension is a good starting point. This extension differs in three ways:

1. **Default-on** — worktrees are created automatically after `/speckit.specify`. Opt *out* with `--in-place`, rather than opting in.
2. **Nested layout by default** — worktrees live at `.worktrees/<branch>/` inside the repo (gitignored, self-contained). Sibling-dir layout (`../<repo>--<branch>`) is available as an option for IDE-per-feature workflows.
3. **Deterministic bash script** — a real script (`create-worktree.sh`) with `--json` output, `--dry-run`, `--base-ref`, and `SPECIFY_WORKTREE_PATH` override, suitable for CI and scripted workflows.

This extension **does not** change another extension’s configuration on install (for example it does not disable the Git extension’s hooks). You opt into hook changes explicitly in `.specify/extensions.yml` when you need them (see below).

## Installation

```bash
specify extension add worktrees --from https://github.com/dango85/spec-kit-worktree-parallel/archive/refs/tags/v1.3.2.zip
```

## Cursor IDE: best results with Spec Kit

Cursor implements **editor-native** isolation: **`/worktree`** keeps the **rest of that chat** in a **separate checkout**, with optional **`.cursor/worktrees.json`** to run setup (deps, env files) using **`$ROOT_WORKTREE_PATH`**. See the official **[Cursor worktrees](https://cursor.com/docs/configuration/worktrees)** documentation and the **[Cursor CLI `--worktree` flag](https://cursor.com/docs/cli/using.md#cli-worktrees)** for the same behavior outside the UI.

### Recommended pattern (agent focus = one tree)

1. **Start the feature** with **`/worktree …`** (or **`/best-of-n`** when comparing models). That aligns **agent tools and cwd** with Cursor’s isolated checkout.
2. Add **`.cursor/worktrees.json`** at your **main project root** so each new checkout gets a working dev environment (copy `.env`, install packages, migrations, etc.). Copy and edit **`examples/cursor-worktrees.spec-kit.example.json`** from this repo as a starting point for Spec Kit repos.
3. Run **`/speckit.specify`**, then plan / tasks / implement **in the same chat** so spec artifacts and edits stay in that checkout.

### How this extension fits (do not double-isolate by accident)

| Mechanism | Who creates it | Typical use |
|-----------|----------------|-------------|
| **Cursor `/worktree`** | Cursor (`~/.cursor/worktrees`, cleanup, setup hooks) | **Best default for Cursor users** — session root matches isolation. |
| **This extension (`after_specify`)** | `git worktree add` under **`.worktrees/`** or sibling dirs | **In-repo** worktrees, **CLI/CI**, **non-Cursor** editors, **list/clean** helpers. |

Using **both** at once for the same feature usually adds **confusion** (two different worktree locations and mental models). For **Cursor-heavy** teams:

- Prefer **`/worktree` + `.cursor/worktrees.json`** for isolation, and set **`auto_create: false`** in **`worktree-config.yml`** so this extension does **not** also spawn an in-repo worktree after every specify — invoke **`/speckit.worktrees.create`** manually when you still want a **git** worktree inside the repo (e.g. sibling layout for a second IDE window).

If you keep **`auto_create: true`**, you still get in-repo worktrees after specify; treat that as the **non-Cursor** or **second checkout** path and understand specs may land on the **primary** tree first (see **Parallel agents and the Git extension** below).

### Summary

- **Cursor:** isolation + agent focus → **`/worktree`** + **`worktrees.json`**.  
- **This extension:** **`git worktree`** automation, dashboards, cleanup — complements Cursor; it does **not** replace Cursor’s chat root behavior.

## Layout modes

### Nested (default)

Worktrees live inside the repo under `.worktrees/` (auto-gitignored):

```
my-project/
├── .worktrees/
│   ├── 005-user-auth/           ← worktree
│   ├── 006-chat/                ← worktree
├── specs/
├── src/
```

Self-contained — everything stays in one directory. `.worktrees/` is added to `.gitignore` at install time so worktree directories are never accidentally committed to the main repo. Work inside each worktree is committed on its own feature branch.

### Sibling

Each worktree is a sibling directory of the primary clone:

```
parent/
├── my-project/                  ← primary checkout (main)
├── my-project--005-user-auth/   ← worktree (005-user-auth branch)
├── my-project--006-chat/        ← worktree (006-chat branch)
```

Open each directory in its own IDE window. Switch with `layout: "sibling"` in `worktree-config.yml`.

## Parallel agents and the Git extension

**Git extension vs `git` on your PATH:** This extension requires the **`git` CLI** only. It does not require the Spec Kit **Git extension** (`speckit.git.*`). That distinction matters because the Git extension registers **`before_specify → speckit.git.feature`**, which runs `git checkout` / `git checkout -b` on **whatever directory the agent is using as the repo root**. On a **shared** primary clone, that moves `HEAD` for everyone and fights parallel worktrees.

**What this extension does instead:** `create-worktree.sh` uses **`git worktree add`** (and **`git worktree add -b`** for a new branch). That creates the feature branch **inside the new worktree** and leaves the primary checkout’s `HEAD` alone.

**If the Git extension is installed and you want a stable primary checkout:** edit **`.specify/extensions.yml`** and set **`enabled: false`** on the `before_specify` entry whose **`extension`** is **`git`** and **`command`** is **`speckit.git.feature`**. Your file may include extra keys (`optional`, `prompt`, …); only `enabled` needs to change.

```yaml
hooks:
  before_specify:
    - extension: git
      command: speckit.git.feature
      enabled: false
      optional: false
      # …other keys from your install stay as-is…
```

After disabling that hook, **feature branch naming** is no longer applied by `speckit.git.feature` before specify. Use **`create-new-feature.sh --dry-run --json`** from the Git extension if you still want the same numbering **without** a checkout, or agree on branch names in the specify step. **Branch from current `HEAD`** when creating a worktree: pass **`--base-ref HEAD`** to `create-worktree.sh` (default base is `main` / `origin/main` when present).

**`after_specify` ordering:** This extension’s hook runs **after** `/speckit.specify`. Spec files are written to the **current** working tree first, then the worktree is created. For **full** isolation, run specify **from the worktree root** (worktree-first workflow). A Spec Kit **preset** that overrides only the commands you need is the maintainers’ recommended way to encode that workflow explicitly; this repo does not ship that preset yet.

**Spec Kit 1.0.0:** The Git extension is expected to become **opt-in**. Do not assume `before_specify` / `speckit.git.feature` is always present; keep the worktree flow valid with Git extension off.

## Configuration

Create `.specify/extensions/worktrees/worktree-config.yml` to override defaults:

```yaml
layout: "nested"            # nested | sibling
auto_create: true           # Cursor + /worktree users: set false to avoid in-repo worktrees after every specify
sibling_pattern: "{{repo}}--{{branch}}"
dotworktrees_dir: ".worktrees"
```

## How worktrees stay isolated

- **On install** (`specify extension add`): `.worktrees/` is added to `.gitignore` so the directory is ignored before any worktree exists
- **On create** (`/speckit.worktrees.create`): the script double-checks `.gitignore` as a safety net
- **Commits stay on the right branch**: each worktree has its own working tree and index — `git add` and `git commit` inside a worktree only affect that worktree's branch, not the main repo
- **Cleanup**: `/speckit.worktrees.clean` removes worktree directories; it never deletes the git branch itself

## Commands

| Command | Description | Modifies files? |
|---------|-------------|-----------------|
| `/speckit.worktrees.create` | Spawn a worktree for a feature branch | Yes |
| `/speckit.worktrees.list` | Dashboard: status, artifacts, tasks | No |
| `/speckit.worktrees.clean` | Remove merged/stale worktrees | Yes |

## Hook

**`after_specify`** — automatically creates a worktree after a new feature is specified. Controlled by the `auto_create` config value.

## Script usage

The bash script can be called directly for automation:

```bash
# Create a nested worktree for branch 005-user-auth (default)
bash scripts/bash/create-worktree.sh --json 005-user-auth

# Sibling layout instead
bash scripts/bash/create-worktree.sh --json --layout sibling 005-user-auth

# Explicit path
bash scripts/bash/create-worktree.sh --json --path /tmp/my-worktree 005-user-auth

# Dry run (compute path without creating)
bash scripts/bash/create-worktree.sh --json --dry-run 005-user-auth

# Skip worktree (single-agent mode)
bash scripts/bash/create-worktree.sh --in-place 005-user-auth
```

## Environment variables

| Variable | Description |
|----------|-------------|
| `SPECIFY_WORKTREE_PATH` | Override computed worktree path entirely |
| `SPECIFY_FEATURE` | Current feature name (set by spec-kit) |

## Related

- [#61](https://github.com/github/spec-kit/issues/61) — Spawn worktree when creating new branch (36+ upvotes)
- [#1476](https://github.com/github/spec-kit/issues/1476) — Native worktree support for parallel agents
- [#1940](https://github.com/github/spec-kit/issues/1940) — Git operations extracted to extension (closed)

## Requirements

- Spec Kit >= 0.4.0
- Git >= 2.15.0 (worktree support)

## License

MIT
