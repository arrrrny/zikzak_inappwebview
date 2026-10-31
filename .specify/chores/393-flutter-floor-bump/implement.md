# Chore Implementation: Raise the Flutter floor to 3.47.0 and refresh dependency floors

- **Slug**: 393-flutter-floor-bump
- **Implemented**: 2026-10-29
- **Assessment**: ./assessment.md
- **Status**: applied

## Summary

Every publishable package now declares the real minimum — `flutter: >=3.47.0` —
so pub reports "requires Flutter >=3.47.0" on 3.38–3.44 instead of a solver
failure that suggests downgrading to 5.x (#393 comment 6493010108); the
umbrella's `zuraffa_session` constraint stays at master's `^7.3.0` (the
branch's proposed `">=1.2.1 <8.0.0"` widening was resolved away in the master
merge — the 6.3.2 release prep had adopted `^7.3.0`, the fleet-realigned
nocterm-free line, so the merged diff carries no `zuraffa_session` change);
and a new `resolve-floor` CI job
resolves a minimal consumer (the issue's exact repro: `equatable: ^3.0.0` +
this checkout) on the declared floor, asserting path resolution and a zuraffa
7.x result. No Dart, Java, or Swift source changed.
## Changes

| File | Change | Notes |
|------|--------|-------|
| `zikzak_inappwebview/pubspec.yaml` | modified | floor `>=3.38.6`→`>=3.47.0` only — the branch's `zuraffa_session` widening was resolved to master's `^7.3.0` in the merge commit (comment untouched from master's 6.3.2 form) |
| `zikzak_inappwebview_platform_interface/pubspec.yaml` | modified | floor → `>=3.47.0` |
| `zikzak_inappwebview_android/pubspec.yaml` | modified | floor → `>=3.47.0` |
| `zikzak_inappwebview_ios/pubspec.yaml` | modified | floor → `>=3.47.0` |
| `zikzak_inappwebview_macos/pubspec.yaml` | modified | floor → `>=3.47.0` |
| `zikzak_inappwebview_web/pubspec.yaml` | modified | floor → `>=3.47.0` |
| `zikzak_inappwebview_windows/pubspec.yaml` | modified | floor → `>=3.47.0` |
| `zikzak_inappwebview_linux/pubspec.yaml` | modified | floor → `>=3.47.0` |
| `zikzak_inappwebview_module/pubspec.yaml` | modified | dev-only alignment: `sdk >=3.8.0`, `flutter >=3.47.0`, `flutter_lints ^5.0.0`→`^6.0.0` |
| `.github/workflows/ci.yml` | modified | new `resolve-floor` job (18th): pins `flutter-version: 3.47.0`, writes `.consumer-probe` (equatable ^3.0.0 + root `dependency_overrides` to all 8 checkout packages), `flutter pub get`, asserts path sources + zuraffa 7.x |
| `AGENTS.md` | modified | SDK-floor line (181) now `flutter: >=3.47.0` with the meta-pin rationale; CI section (358) describes the 18-job matrix incl. `resolve-floor` |
| `zikzak_inappwebview/example/pubspec.lock` | modified | `sdks:` footer only: `flutter ">=3.44.0"`→`">=3.47.0"` (master's merge had already adopted the `zuraffa_session 7.3.0` resolution, so no dep lines differ) |
| `zikzak_inappwebview_module/pubspec.lock` | modified | refreshed: `flutter_lints 5.1.1→6.1.0`, `analyzer 5.0.0→6.0.0` (from the dev-dep alignment), `sdks:` footer → `>=3.47.0` |
| `zikzak_inappwebview_macos|_web|_windows/pubspec.lock` | modified | 1-line `sdks:` footer refreshes |
Deliberately unchanged: `sdk:` floors (`>=3.8.0 <4.0.0` — the `flutter:` line
is the enforceable floor for plugin consumers and every Flutter ≥3.47.0 ships
Dart ≥3.13.0), all other direct-dependency ranges (each caret already admits
the latest published version — `synchronized` resolved to 3.5.0,
`zorphy`/`zorphy_annotation` 2.4.4, `analyzer` 14.6.0 — and per dart.dev
guidance floors stay at the oldest tested version), per-package CHANGELOGs
(release commits own those), the dated "Known repository state" snapshot in
AGENTS.md (historical record).

## Verification

All runs in `/tmp/zikzak_inappwebview-393` at this branch, Flutter 3.47.7 /
Dart 3.13.5, `--concurrency=2` per the fleet guard:

- `flutter analyze --no-fatal-infos` × 9 packages → all pass; issue counts
  identical to the AGENTS.md baseline (umbrella 23, platform_interface 77,
  android 197, ios 192, linux 5 infos; macos/web/windows/module clean) —
  infos only, zero new warnings/errors.
- `flutter test --concurrency=2`: umbrella **269 pass**; platform_interface
  **309 pass**; macos **138**; ios **82**; windows **36**; linux **9**;
  android **20**; module **27**; web `--platform chrome` **1 pass**.
- `bash scripts/grep_gate.sh` → PASS (core↔module split intact).
- `./scripts/local_ci.sh --job resolve-floor` → PASS end-to-end: probe
  resolves on the floor graph, umbrella + platform_interface resolve from
  `path`, `zuraffa` resolves to **7.3.0**, `equatable` to **3.0.0**,
  `nocterm` **absent** from the lockfile.
- Lock check in the umbrella/module: `zuraffa_session 7.3.0 → zuraffa 7.3.0`,
  `nocterm` absent.
- `./scripts/local_ci.sh --plan` → the new job parses into the local gate
  (5 steps; pinned-flutter mismatch reported as advisory, matching
  `local_ci.sh`'s documented semantics).
- Not reproducible locally (recorded, not skipped silently): the 3.44.8 red
  state (only Flutter 3.47.7 installed here; downloading a second SDK judged
  out of proportion) and CI's exact `flutter-version: 3.47.0` — both are what
  the CI job exists to check; the red evidence for the TDD contract is the
  issue's solver transcript (reporter-reproduced on published 6.3.1).

## Misfire record (per AGENTS.md misfire rule)

The first `resolve-floor` run failed (exit 1): the probe draft declared all 8
packages as direct `path:` dependencies, and pub rejected the graph —
`zikzak_inappwebview_linux from path depends on
zikzak_inappwebview_platform_interface from hosted` (one package may not mix
sources across dependents; root `dependency_overrides` were not in play).
Root cause was in the probe fixture I authored in this task, not in existing
repo behavior (the example app and both build jobs already use root
overrides), so no separate GitHub issue was filed for it — the failure, root
cause, and fix are recorded here and in the code comment on the probe's
`dependency_overrides` block, and the job was re-run green immediately above.

## Deviations from Assessment

- **No new GitHub issue filed** although `.specify/extensions/chore/chore-config.yml`
  has `auto_create_issue: true`: the chore is already tracked as #393 (closed
  as completed) and filing a duplicate would pollute the tracker — the
  config's own comment warns against exactly this when driving from an
  existing issue. `issue.md` records the linkage instead; the PR references
  #393.
- **Probe wiring changed from the assessment's sketch**: the assessment
  described "path dependencies on all 8 checkout packages"; implementation
  uses root `dependency_overrides` (see misfire record). Same graph, correct
  pub semantics.
- Assessment's verification list said "optionally run the new job id" — it
  was run for real (`--job resolve-floor`), not skipped.

## Follow-ups

- When the Flutter floor next moves: update the eight `flutter:` lines, the
  `resolve-floor` pin AND its job name (they carry the version for a reason),
  and the probe's `environment.sdk` comment (Flutter 3.47.0 ↔ Dart 3.13.0).
- The README's ⚠️ Known Issues entry for the Flutter 3.47.x iOS
  platform-view artifact (upstream flutter/flutter#193363) now applies to
  every supported consumer, since 3.47.0 is the floor. No action in this
  chore (no rendering claim is made); revisit only if upstream ships a fix.
- If a consumer ever needs the pre-3.47 line again, the escape hatch is
  pinning `zikzak_inappwebview 6.1.x` (pre-`zuraffa_session`) — the same
  suggestion pub printed before this change, minus the misleading solver
  output.
