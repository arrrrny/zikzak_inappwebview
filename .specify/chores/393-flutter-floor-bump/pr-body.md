## Summary

Declares the **real minimum Flutter version** on every publishable package and
adds the CI guard that keeps it honest. Follow-up to
#393 ([comment 6493010108](https://github.com/arrrrny/zikzak_inappwebview/issues/393#issuecomment-6493010108)):

`zikzak_inappwebview` declared `flutter: ">=3.38.6"`, but every zuraffa 7.x
(pulled in by `zuraffa_session`, i.e. by every 6.2.2+ consumer) needs
`meta ^1.19.0` — and Flutter pins `meta` exactly up to 3.44.x. On Flutter
3.38–3.44, pub therefore reported a solver failure blaming this package and
suggesting a downgrade to 5.x, instead of naming the real minimum. This PR
makes the declared floor the true one.

## Changes

- **`flutter: ">=3.38.6"` → `">=3.47.0"`** in all 8 publishable packages
  (fleet-wide floor by convention). Flutter 3.47.0 ships Dart 3.13.0 (official
  releases JSON). `sdk:` floors stay at `>=3.8.0 <4.0.0` — the `flutter:` line
  is the enforceable floor for plugin consumers.
- **`zuraffa_session: ^1.1.0` → `">=1.2.1 <8.0.0"`** in the umbrella: the
  floor is the first version on the zuraffa-7 line (nocterm-free — the
  equatable-^3 conflict from #393 section 1 can no longer enter any consumer
  graph), and the open top admits the fleet realignment (`zuraffa_session
  7.3.0`, published 2026-10-29, dep-identical to 1.2.1 except
  `zuraffa: ^7.3.0`). Fresh resolution lands on `zuraffa_session 7.3.0 →
  zuraffa 7.3.0`; the zuraffa-6 CLI subtree drops out of consumer locks
  (~580 fewer lines across the example + module locks).
- **New `resolve-floor` CI job (18th)**: pins `flutter-version: 3.47.0` and
  resolves a minimal consumer app — the issue's exact repro, `equatable:
  ^3.0.0` + this checkout via root `dependency_overrides` — then asserts the
  checkout resolved from `path` and that `zuraffa` resolved to a nocterm-free
  7.x. The pin and the pubspec floor must move together (documented in both
  places; the job name carries the version).
- **Dev-only `zikzak_inappwebview_module`** aligned: `flutter >=3.47.0`,
  `sdk >=3.8.0`, `flutter_lints ^6.0.0`.
- **AGENTS.md**: SDK-floor line and CI matrix description updated.
- Tracked `pubspec.lock` files refreshed by `flutter pub get`.
- Spec-kit chore records under `.specify/chores/393-flutter-floor-bump/`
  (assessment, issue linkage, implement report).

Deliberately unchanged: all other direct-dependency ranges (each caret already
admits the latest published version, and floors stay at the oldest tested
version per dart.dev guidance), per-package CHANGELOGs (release commits own
those), and all Dart/native source — no behavior changes.

## Verification

Local gate on Flutter 3.47.7 / Dart 3.13.5, `--concurrency=2` per the fleet
guard:

- `flutter analyze --no-fatal-infos` × 9 packages — pass; issue counts
  identical to the documented baseline (infos only, zero warnings/errors).
- `flutter test --concurrency=2` × 9 packages — **891 tests green**
  (umbrella 269, platform_interface 309, macos 138, ios 82, windows 36,
  linux 9, android 20, module 27, web/Chrome 1).
- `bash scripts/grep_gate.sh` — PASS.
- `./scripts/local_ci.sh --job resolve-floor` — PASS end-to-end: probe
  resolves, umbrella + platform_interface from `path`, `zuraffa 7.3.0`,
  `equatable 3.0.0`, `nocterm` absent from the lockfile.
- Not locally reproducible (recorded in the implement report): the 3.44.8 red
  state (single Flutter SDK installed here) and CI's exact 3.47.0 pin — the
  new CI job is the durable check for both.

Assessment: `.specify/chores/393-flutter-floor-bump/assessment.md` ·
Implement report:
`.specify/chores/393-flutter-floor-bump/implement.md`

Refs #393 (already closed as completed — this implements the floor request
from the follow-up comment; not `Closes` since the issue is closed).
