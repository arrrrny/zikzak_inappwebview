# Spec Stats — Spec Dashboard at a Glance

Generates a beautiful markdown dashboard showing every spec at a glance — stage, progress, health, last-updated — so you can see the whole portfolio without opening a dozen folders. Plus three on-demand views: `open` (unfinished), `not-green` (no green test evidence / failing), and `runs` (actually execute the recorded test command per spec on demand and record the result).

## What It Does

| Command | Purpose |
|---------|---------|
| `speckit.spec-stats.report` | Main generator — scans `specs/*/`, builds dashboard, writes `SPEC-STATS.md` + `stats.json` |
| `speckit.spec-stats.open` | View all specs not `complete` — stuck stage, next action, stale warnings |
| `speckit.spec-stats.not-green` | View specs with `red` or `unknown` health — evidence quoted, command to get green |
| `speckit.spec-stats.runs` | Execute the verified test command per spec, record results, refresh health |

**Only `speckit.spec-stats.runs` executes anything.** The other three are read-only scans.

### TDD deep stats

When the **TDD extension is installed** in the project (detected via `.specify/memory/tdd-profile.md` or `.specify/extensions/tdd`), the dashboard adds a **TDD Deep Stats** table. For every feature with a `tdd/test-list.md` it reports:

| Column | Meaning |
|--------|---------|
| `A` | acceptance behaviors (`A1`, `A2`, …) |
| `U` | unit behaviors (`U1`, `U2`, …) |
| `char` | characterization behaviors (`kind: characterization`) |
| `DONE` | behaviors in the `DONE` state |
| `loop` | `full` (outer + inner derived), `outer-only` (acceptance only), `inside-out`, or `absent` (no TDD list) |
| `tasks.md` | `updated` (TDD behavior markers present in `tasks.md`) or `absent` |

A `total` row sums the numeric columns. This lets you see, at a glance, how far each feature's red-green-refactor loop has progressed.

---

## Sample Rendered Dashboard (Illustrative)

> **Illustrative only** — based on forklift's three real specs (`001-nudge-stalled-panes`, `002-cr-ziki-kimi-fallback`, `003-agent-in-the-loop`). Test results are **not fabricated** — the actual scan will show real data.

```markdown
# Spec Stats Dashboard: forklift

*Generated: 2026-08-26T10:30:00Z | Repo: forklift | Active: 002-cr-ziki-kimi-fallback*

## Portfolio Summary

| Stage | Count |
|-------|-------|
| specified | 0 |
| planned | 1 |
| tasked | 0 |
| test-listed | 0 |
| implementing | 2 |
| complete | 0 |

**Overall**: 3 specs | 47/61 tasks done (77%) | Health: 🟢 1 🔴 0 ⚪ 2

---

## At a Glance

| Spec | Stage | Progress | Health | Last Updated |
|------|-------|----------|--------|--------------|
| 001-nudge-stalled-panes | implementing | ████████████░░ 82% (37/45) | ⚪ unknown | 2026-08-26 08:15 (a1b2c3d) |
| 002-cr-ziki-kimi-fallback | implementing | ██████████░░░░ 67% (41/61) | ✅ green | 2026-08-26 09:42 (e4f5g6h) |
| 003-agent-in-the-loop | planned | ░░░░░░░░░░░░ 0% (0/0) | ⚪ unknown | 2026-08-26 10:05 (i7j8k9l) |

---

## Detail: 001-nudge-stalled-panes

**Stage**: implementing (tasks checked, not all)
**Progress**: 37/45 tasks (82%)
- Phase 1: Setup — 2/2 ✅
- Phase 2: Foundational — 3/3 ✅
- Phase 3: US1 — 5/5 ✅
- Phase 4: US2 — 4/4 ✅
- Phase 5: US3 — 3/3 ✅
- Phase 6: Polish — 3/3 ✅
**Checklists**: requirements.md — 12/12 ✅
**Health**: ⚪ unknown — no TDD cycle-log.md evidence
**Last Updated**: 2026-08-26T08:15:00Z (git: a1b2c3d)
**Active**: ⭐ (current feature in .specify/feature.json)
**Branch**: 001-nudge-stalled-panes ✅

---

## Detail: 002-cr-ziki-kimi-fallback

**Stage**: implementing (tasks checked, not all)
**Progress**: 41/61 tasks (67%)
- Phase 1: Setup — 3/3 ✅
- Phase 2: Foundational — 3/3 ✅
- Phase 3: US1 — 6/6 ✅
- Phase 4: US2 — 4/4 ✅
- Phase 5: US3 — 2/2 ✅
- Phase 6: Supervisor Integration — 5/5 ✅
- Phase 7: Tests — 4/4 ✅
**Checklists**: requirements.md — 12/12 ✅
**Health**: ✅ green — cycle-log.md: `2026-08-26T09:42:00Z GREEN T024..T027 all pass`
**Last Updated**: 2026-08-26T09:42:00Z (git: e4f5g6h)
**Active**: ⭐
**Branch**: 002-cr-ziki-kimi-fallback ✅

---

## Detail: 003-agent-in-the-loop

**Stage**: planned (plan.md exists, no tasks.md)
**Progress**: 0/0 tasks (0%)
**Checklists**: none
**Health**: ⚪ unknown — no TDD artifacts
**Last Updated**: 2026-08-26T10:05:00Z (git: i7j8k9l)
**Active**: 
**Branch**: ❌

---

## Bugs (2)

| Bug | Status | Updated |
|-----|--------|---------|
| replace-python-agent-loop | open | 2026-08-24 |
| wss-timeout-long-tests | open | 2026-08-24 |

---

## Chores (0)

*None recorded*

---

## TUPEC Inventory

*Not present (no .specify/tupec/inventory.json)*

---

## Legend

- **Stage pipeline**: `specified` → `planned` → `tasked` → `test-listed` → `implementing` → `complete`
- **Health**: ✅ green (latest cycle green) | ❌ red (latest red/failing) | ⚪ unknown (no evidence)
- **Progress bar**: █ = 10% increment (10 chars total)
- **Active**: ⭐ = current feature in `.specify/feature.json`
- **Branch**: ✅ = local git branch matching feature dir exists | ❌ = no branch
```

---

## How Stage Detection Works

The stage is an **ordered pipeline** — the furthest reached stage is shown:

| Stage | Condition (furthest match wins) |
|-------|--------------------------------|
| `specified` | `spec.md` exists |
| `planned` | `plan.md` exists |
| `tasked` | `tasks.md` exists |
| `test-listed` | `tdd/test-list.md` exists |
| `implementing` | `tasks.md` has ≥1 checked task (`[x]` or `[X]`) |
| `complete` | `tasks.md` exists AND all tasks checked |

**Note**: A spec with `tasks.md` but zero checked tasks is `tasked`, not `implementing`. Only when at least one task is checked does it become `implementing`.

---

## Health / Green State Detection

Health is derived from **TDD evidence only** — never inferred from task completion:

| Health | Evidence |
|--------|----------|
| ✅ `green` | `tdd/cycle-log.md` exists AND latest entry contains `GREEN` or `✅` or `pass` (case-insensitive) |
| ❌ `red` | `tdd/cycle-log.md` exists AND latest entry contains `RED` or `❌` or `fail` or `error` (case-insensitive) |
| ⚪ `unknown` | No `tdd/cycle-log.md`, or file exists but no recognizable evidence |

**Critical**: `unknown` is the honest default. A spec with all tasks checked but no TDD evidence is `unknown`, not `green`.

---

## Command Reference

### `speckit.spec-stats.report`

```bash
# Full scan + render (writes .specify/stats/SPEC-STATS.md + .specify/stats/stats.json)
speckit.spec-stats.report

# Scan only → stdout JSON (no files written)
speckit.spec-stats.report --json

# Scan only → custom output path
speckit.spec-stats.report --out /tmp/stats.json

# Render only from existing stats.json → custom markdown path
speckit.spec-stats.report --render --in .specify/stats/stats.json --out /tmp/report.md

# Help
speckit.spec-stats.report --help
```

**Subcommands** (also callable directly via `node .specify/extensions/spec-stats/scripts/spec-stats.mjs`):
- `scan` — emit stats.json
- `render` — stats.json → markdown
- `report` — scan + render (default)
- `open` — on-demand open view
- `not-green` — on-demand not-green view
- `record-run` — append a run record to runs.json

### `speckit.spec-stats.open`

```bash
# Show all specs not in 'complete' stage
speckit.spec-stats.open

# Show with stale warning (default 14 days)
speckit.spec-stats.open --stale-after 14

# JSON output
speckit.spec-stats.open --json
```

Shows: spec, stage, next artifact/command needed, days since last touch, stale flag.

### `speckit.spec-stats.not-green`

```bash
# Show specs with red or unknown health
speckit.spec-stats.not-green

# JSON output
speckit.spec-stats.not-green --json
```

Shows: spec, health, exact evidence line from cycle-log.md (or "no evidence recorded"), command to run for evidence (`__SPECKIT_COMMAND_TDD_RUN__` or suite command from `.specify/memory/tdd-profile.md`).

### `speckit.spec-stats.runs`

```bash
# Run tests for active feature (default)
speckit.spec-stats.runs

# Run tests for all specs
speckit.spec-stats.runs --all

# Run tests for specific spec(s) by id/slug
speckit.spec-stats.runs 001-nudge-stalled-panes
speckit.spec-stats.runs 002-cr-ziki-kimi-fallback 003-agent-in-the-loop

# Dry run — print what would run without executing
speckit.spec-stats.runs --dry-run --all

# Help
speckit.spec-stats.runs --help
```

**Critical behavior**:
- Reads the **verified suite command** from `.specify/memory/tdd-profile.md` (stop with clear message if absent — does not guess)
- Runs the command for each selected spec (in the spec directory or repo root as configured)
- Captures: pass/fail, duration (ms), tail of stdout/stderr (last 50 lines)
- Appends a run record to `.specify/stats/runs.json` (bounded by `runs_history_limit`)
- Refreshes the dashboard's health column from these runs on next `report`

---

## Configuration Reference

`.specify/extensions/spec-stats/spec-stats-config.yml` (from `config-template.yml`):

```yaml
output_path: ".specify/stats/SPEC-STATS.md"   # Dashboard output file
specs_dir: "specs"                             # Specs root directory
sort_by: "number"                              # number | last_updated | progress | stage
include_bugs: true                             # Include Bugs section
include_chores: true                           # Include Chores section
include_tupec: true                            # Include TUPEC inventory line
use_git: true                                  # Use git log for last-updated
stale_after_days: 14                           # Stale threshold for 'open' view
runs_history_limit: 50                         # Max run records in runs.json
emoji: true                                    # Emoji in legend/health column
```

---

## Output File Layout

```
.specify/stats/
├── SPEC-STATS.md      # Human-readable dashboard (main output)
├── stats.json         # Machine-readable snapshot (for other commands/tooling)
└── runs.json          # Bounded history of test runs (for 'runs' command)
```

**`stats.json` schema** (simplified):
```json
{
  "generatedAt": "2026-08-26T10:30:00.000Z",
  "repoName": "forklift",
  "activeFeature": "002-cr-ziki-kimi-fallback",
  "summary": {
    "total": 3,
    "byStage": { "specified": 0, "planned": 1, "tasked": 0, "test-listed": 0, "implementing": 2, "complete": 0 },
    "totalTasks": 61,
    "doneTasks": 47,
    "health": { "green": 1, "red": 0, "unknown": 2 }
  },
  "features": [
    {
      "id": "001-nudge-stalled-panes",
      "slug": "nudge-stalled-panes",
      "number": 1,
      "stage": "implementing",
      "progress": { "checked": 37, "total": 45, "percent": 82, "byPhase": { "Phase 1": "2/2", ... } },
      "checklists": { "requirements.md": { "checked": 12, "total": 12 } },
      "health": "unknown",
      "healthEvidence": null,
      "lastUpdated": "2026-08-26T08:15:00.000Z",
      "lastUpdatedGit": { "date": "2026-08-26T08:15:00.000Z", "sha": "a1b2c3d" },
      "active": true,
      "branchExists": true
    }
    ...
  ],
  "bugs": [ ... ],
  "chores": [ ... ],
  "tupec": { "kept": 0, "chopped": 0, "added": 0, "locked": false }
}
```

---

## Install

```bash
specify extension add spec-stats
```

Registers `speckit.spec-stats.*` commands and copies `config-template.yml` to `.specify/extensions/spec-stats/spec-stats-config.yml`.

---

## Requirements

- Spec Kit `>=0.9.0`
- Node.js (for `spec-stats/scripts/spec-stats.mjs`)
- Git (optional, for last-commit enrichment)

---

## Notes

- **Read-only by default**: `report`, `open`, `not-green` never modify specs, tasks, or code — only their own output files under `.specify/stats/`.
- **`runs` is the only command that executes project test commands**. It honors `--dry-run` and never invents or mutates a test command.
- **Deterministic output**: The scanner + renderer produce stable markdown across runs (no timestamps in table rows except the header, stable sort).
- **Honest health**: Never claims `green` without TDD evidence — `unknown` is the default.