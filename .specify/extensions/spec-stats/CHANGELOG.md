# Changelog

## 1.2.0 - 2026-08-30

- **New `reconcile` command**: fixes stale `tasks.md` checkboxes by cross-referencing actual implementation state. Two strategies: (1) behavior-based — marks tasks with DONE behavior markers in `tdd/test-list.md` as checked; (2) file-existence-based — marks tasks referencing existing files as checked. Supports `--dry-run`, `--all`, specific spec targets, and `--drop-mark checked|unchecked` for DROPPED behaviors.

## 1.1.0 - 2026-08-28

- **Namespace fix**: commands renamed `speckit.stats.*` → `speckit.spec-stats.*` (and command files) so the extension installs under its own namespace.
- **Implemented the extension** that was previously documentation-only: added `scripts/spec-stats.mjs` (Node ESM engine) and the four command files (`report`, `open`, `not-green`, `runs`).
- **TDD deep stats**: when the TDD extension is installed in the project, `report` emits a TDD Deep Stats table per feature — `A` (acceptance), `U` (unit), `char` (characterization), `DONE`, `loop` (full / outer-only / inside-out / absent), and `tasks.md` (updated / absent) — plus a totals row. Parsed from each feature's `tdd/test-list.md` and `tasks.md` markers.
- Stage detection, task-progress, and git last-updated retained; read-only `open`/`not-green` views and `runs` (verified-suite executor with `--dry-run`) implemented.

## 1.0.0 - 2026-08-26

- Initial release: spec portfolio dashboard with stage, progress, health, last-updated
- Four commands: `report` (main generator), `open` (unfinished specs), `not-green` (health issues), `runs` (on-demand test execution)
- Deterministic Node.js ESM scanner + renderer (`spec-stats.mjs`) with subcommands: `scan`, `render`, `report`, `open`, `not-green`, `record-run`
- Stage detection pipeline: specified → planned → tasked → test-listed → implementing → complete
- Task progress from tasks.md (accepts [x]/[X]), checklist progress from checklists/*.md
- Health from tdd/cycle-log.md evidence (green/red/unknown — never claims green without evidence)
- Last updated from filesystem mtime + optional git log (commit date + short sha)
- Active feature marker from .specify/feature.json, branch presence detection
- Bugs (.specify/bugs/*), Chores (.specify/chores/*), TUPEC inventory line support
- Configurable output, sort, inclusions, stale threshold, runs history limit, emoji
- stats.json machine snapshot + runs.json bounded history