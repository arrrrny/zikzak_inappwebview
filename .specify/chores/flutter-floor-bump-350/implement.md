# Chore Implementation: Raise the Flutter floor to 3.50.0 (fixes #331 on iOS)

- **Slug**: flutter-floor-bump-350
- **Implemented**: 2026-11-18
- **Assessment**: ./assessment.md
- **Status**: applied
- **Branch**: chore/flutter-floor-bump-350 (based on origin/master @ 852bdf0c)

## Summary

Every package now declares `flutter: ">=3.50.0"` (the first stable that carries
the #331 iOS platform-view "rendering layer confusion" fix — an engine
regression in Flutter's TLHC overlay path, flutter/flutter#193363, confirmed
fixed by the reporter on 3.50.0). The `resolve-floor` CI job and the
`build-linux` bootstrap pin moved 3.47.0 → 3.50.0, the probe's Dart floor moved
3.13.0 → 3.14.0 (the Dart that ships with Flutter 3.50.0, per the official
releases JSON), and the now-obsolete #331 "Known Issues" section was removed from
both READMEs. No Dart/Java/Swift/C++ source changed.

## Changes

| File | Change | Notes |
|------|--------|-------|
| `zikzak_inappwebview/pubspec.yaml` | modified | floor `>=3.47.0`→`>=3.50.0` |
| `zikzak_inappwebview_platform_interface/pubspec.yaml` | modified | floor → `>=3.50.0` |
| `zikzak_inappwebview_android/pubspec.yaml` | modified | floor → `>=3.50.0` |
| `zikzak_inappwebview_ios/pubspec.yaml` | modified | floor → `>=3.50.0` |
| `zikzak_inappwebview_macos/pubspec.yaml` | modified | floor → `>=3.50.0` |
| `zikzak_inappwebview_web/pubspec.yaml` | modified | floor → `>=3.50.0` |
| `zikzak_inappwebview_windows/pubspec.yaml` | modified | floor → `>=3.50.0` |
| `zikzak_inappwebview_linux/pubspec.yaml` | modified | floor → `>=3.50.0` |
| `zikzak_inappwebview_module/pubspec.yaml` | modified | dev-only alignment → `>=3.50.0` (not published) |
| `zikzak_webview_windows/pubspec.yaml` | modified | fork floor → `>=3.50.0` (see decision below) |
| `.github/workflows/ci.yml` | modified | `resolve-floor` job `name:` + `flutter-version` pin → 3.50.0; probe `environment.sdk` → `>=3.14.0 <4.0.0`, `flutter` → `>=3.50.0`, comment "Flutter 3.50.0 ships Dart 3.14.0"; **also** `build-linux` bootstrap name + `git clone --branch` 3.47.0 → 3.50.0 |
| `AGENTS.md` | modified | SDK-floor line (197) → 3.50.0 with #331 rationale; runtime-minimums line (302) → 3.50.0+; CI-matrix description (resolve-floor pin) → 3.50.0; dependency-bump-rule floor rationale (615-617) → 3.50.0 |
| `README.md` | modified | Flutter requirement row → 3.50.0+ (#331 note); removed the #331 Known Issues section (no longer applies to any supported consumer) |
| `zikzak_inappwebview/README.md` | modified | canonical Flutter requirement row `3.10.0+`→`3.50.0+` (fixed a pre-existing stale value — see Deviations); removed the #331 Known Issues section |
| `zikzak_webview_windows/README.md` | modified | "differences from upstream" floor note → 3.50.0 (tracks the fork's declared floor) |
| 6 tracked `pubspec.lock` files | modified | `sdks: flutter:` footer → `>=3.50.0` ONLY (footer-only; see Verification for why) |

Deliberately unchanged: all `sdk:` floors (`>=3.8.0 <4.0.0` — the `flutter:`
line is the enforceable floor and every Flutter ≥3.50.0 ships Dart ≥3.14.0
which satisfies it); every other direct-dependency range (per dart.dev, floors
stay at the oldest tested version — this chore is a floor bump, not a dependency
refresh); `zikzak_inappwebview_linux/tool/wire_parity/pubspec.lock` (resolves
platform_interface from **hosted** pub.dev, so its footer correctly tracks the
*published* floor, not this checkout's — the real resolver left it at 3.47.0 and
so did I); per-package CHANGELOGs (release commits own those).

## Verification

All runs on Flutter 3.50.0 / Dart 3.14.0 (the installed toolchain — the
assessment's "local drift" risk did not materialise; the machine is already on
3.50.0), `--concurrency=2` per the fleet guard. Branch based on `origin/master`
@ 852bdf0c (local master was 6 commits behind; rebased the fresh branch onto the
remote tip).

- `flutter analyze --no-fatal-infos` × 10 packages → umbrella 44, platform_interface
  77, android 197, ios 192, macos clean, windows clean, linux 4, web clean,
  module clean, webview_windows 6 — **identical to the AGENTS.md baseline**,
  zero new warnings/errors (infos only, all pre-existing).
- `flutter test --concurrency=2`: umbrella **278 pass**; platform_interface
  **314 pass**; android **39 pass**; ios **131 pass**; macos **166 pass**;
  windows **62 pass**; linux **71 pass**; web `--platform chrome` **1 pass**.
  (Counts exceed the 6.4.1-era AGENTS.md baseline because the branch is based on
  6 newer master commits that added tests.)
- `bash scripts/grep_gate.sh` → **PASS** (core↔module split intact).
- `./scripts/local_ci.sh --job resolve-floor` → **PASS** end-to-end on the new
  3.50.0 floor: probe resolves umbrella + platform_interface from `path`,
  `zuraffa` resolves to **7.5.0** (nocterm-free 7.x line).
- `./scripts/local_ci.sh --plan` → the edited `resolve-floor` job still parses
  into the local gate (5 steps).
- Lock diffs verified **footer-only** (1+/1- per file): running a bare
  `flutter pub get` re-resolves the *stale* master locks (siblings 6.3.4→6.4.1,
  `webview_windows 0.4.0`→`zikzak_webview_windows 0.5.0`, `listen` added,
  `0.7.12`→`0.7.14`). That drift is pre-existing master staleness unrelated to
  the floor bump, and bundling it would violate the repo `dependency-bump-rule`
  (upgrades must be deliberate, not silently swept into an unrelated PR). So the
  locks were reverted and only the `sdks: flutter:` footer line was changed,
  matching the #393 precedent's footer-only lock diffs.

### Pre-existing failure (NOT introduced by this chore)

`zikzak_inappwebview_module` tests **fail to compile** — but this reproduces
**identically on pristine `origin/master` (852bdf0c)**, before any of this
chore's changes:

```
../zikzak_inappwebview/lib/src/in_app_webview/headless_in_app_webview.dart:394:9:
  Error: No named parameter with the name 'onEvicted'.
```

Root cause: **PR #451** (`12cdd33c fix(headless): LRU cap eviction, notify Dart
owner…`, merged onto master) added an `onEvicted` parameter to
`PlatformHeadlessInAppWebViewCreationParams` in the **local** platform_interface
and uses it in the umbrella. `zikzak_inappwebview_module` depends on the umbrella
by `path:` but has **no `pubspec_overrides.yaml`**, so it resolves
platform_interface from **hosted 6.4.1** — which predates `onEvicted` — and the
umbrella source it compiles fails to typecheck. The module package is
`publish_to: none` and **outside the CI matrix**, so master CI never caught it.
This is a defect in #451's merge, not in this floor bump (which touches no
headless/platform_interface code). It does not block the 6.5.0 publish (module is
never published; a fresh platform_interface 6.5.0 built from local source carries
`onEvicted` and resolves it). Recorded here per the AGENTS.md misfire rule;
**recommend filing a separate bug** for the #451 module-breakage.

## Deviations from Assessment

- **`build-linux` bootstrap pin added to scope.** The assessment named only the
  `resolve-floor` job; implementation also moved the `build-linux` job's Flutter
  bootstrap (`name:` + `git clone --branch 3.47.0`→`3.50.0` at ci.yml:57,62).
  Required: build-linux builds the Linux example against the local path-overridden
  plugins, so leaving it pinned at 3.47.0 would make `flutter pub get` fail under
  the new `>=3.50.0` floor. (Logged as a scope expansion, not a contradiction.)
- **`zikzak_webview_windows` fork included.** The assessment proposed bumping it
  (fleet-consistency); done. It has no zuraffa/umbrella dep, so 3.50.0 is not its
  honest minimum, but the "all packages share one floor" invariant (AGENTS.md) and
  the fork author's vendor-time choice to match the fleet both favor including it;
  the published 6.5.0 graph resolves identically either way (umbrella forces 3.50.0).
- **Package README Flutter row was `3.10.0+`, not `3.47.0+`.** A pre-existing
  drift (#393 updated the root README's row but not the canonical package copy).
  Aligned to `3.50.0+` since this chore owns the floor value there.
- **Local toolchain already 3.50.0** (not 3.47.7 as the assessment assumed), so
  the "toolchain drift" risk was moot and the full suite ran natively on the new floor.

## Follow-ups

- **File a bug for the #451 module breakage** (`onEvicted` unresolved against
  hosted platform_interface 6.4.1) — add a `pubspec_overrides.yaml` to
  `zikzak_inappwebview_module` or bring it into the CI matrix.
- **The 6.3.4→6.4.1 lock staleness on master** (siblings + the
  `webview_windows`→`zikzak_webview_windows` rename) is a separate pre-existing
  condition; a dedicated `chore` (per the dependency-bump-rule) should refresh the
  tracked locks deliberately, on the publish-state tree.
- This chore is the floor-bump half of the 6.5.0 release; the publish itself is
  driven separately by `/skill:publish-manager`.