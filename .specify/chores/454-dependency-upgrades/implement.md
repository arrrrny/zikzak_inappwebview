# Chore Implementation: Take the dependency upgrades that 6.5.0 left behind

- **Slug**: 454-dependency-upgrades
- **Implemented**: 2026-11-18
- **Assessment**: ./assessment.md
- **Status**: applied

## Summary

The seven **tracked** lockfiles were re-resolved with `flutter pub upgrade`, so
the versions a builder or an example app actually gets now match what the
declared constraints already allow: `material_ui 1.9.0/1.11.0 → 1.11.1`,
`zorphy`/`zorphy_annotation → 2.4.6`, `archive 4.5.2 → 4.7.1`,
`synchronized 3.4.1 → 3.6.1+1`, `url_launcher_*`/`vm_service`/`web`/
`webdriver` patch bumps, the `module` lock's whole `zikzak_*` family
`6.3.4 → 6.5.0`, and its retired `webview_windows 0.4.0` replaced by the
`zikzak_webview_windows 0.5.0` fork the Windows facade compiles against.
`tool/versions.dart`'s two `zorphy` constants follow to `2.4.6`.
**No `pubspec.yaml` constraint changed** — measurement (assessment §1) shows
every caret already admits the resolved version, so raising one would shrink
the published contract instead of widening it.

## Changes

| File | Change | Notes |
|------|--------|-------|
| `zikzak_inappwebview/example/pubspec.lock` | modified | 38 deps re-resolved; adds `jni_util 1.0.0` |
| `zikzak_inappwebview_linux/example/pubspec.lock` | modified | 12 deps re-resolved |
| `zikzak_inappwebview_linux/tool/wire_parity/pubspec.lock` | modified | 5 deps; adds `listen 1.0.1`, `zikzak_inappwebview_platform_interface 6.3.4 → 6.5.0`, `zorphy_annotation 2.4.4 → 2.4.6`, `test_api 0.7.12 → 0.7.14`, and the stale `sdks: flutter ">=3.47.0"` footer → `">=3.50.0"` (the footer #393 recorded as still stale) |
| `zikzak_inappwebview_macos/pubspec.lock` | modified | `material_ui 1.11.0 → 1.11.1`, `cupertino_ui 1.1.6 → 1.1.7` |
| `zikzak_inappwebview_web/pubspec.lock` | modified | same two |
| `zikzak_inappwebview_windows/pubspec.lock` | modified | same two |
| `zikzak_inappwebview_module/pubspec.lock` | modified | 12 deps; the `zikzak_*` family `6.3.4 → 6.5.0`, `webview_windows 0.4.0` → `zikzak_webview_windows 0.5.0`, `material_ui`/`cupertino_ui` bumps |
| `tool/versions.dart` | modified | `zorphyVersion`, `zorphyAnnotationVersion` `2.4.3` → `2.4.6` — the resolved version. Documentation only: no script reads these two constants (`update_readmes.dart` uses `packageVersion`), so no README churn |
| `.specify/chores/454-dependency-upgrades/{assessment,implement}.md` | added | this chore's record |

Deliberately unchanged:

- **Every `pubspec.yaml` constraint.** `material_ui ^1.9.0`,
  `synchronized ^3.4.1`, `build_runner ^2.4.13` and `zorphy(_annotation)
  ^2.4.3` already admit the versions the issue calls upgradable (proved in the
  assessment), and the repo's rule is "Do not raise every constraint to the
  locked version … preserve the supported lower bound otherwise".
- `flutter_lints` (`^4.0.0` in the umbrella example, `^5.0.0` in `_module`,
  behind the fleet's `^6.0.0`) and `cupertino_icons ^1.0.8` (latest 2.0.0) —
  majors, and exactly the "needs changelog review" class the issue says a human
  must decide. They remain visible in `flutter pub outdated` as
  "N dependencies are constrained to versions that are older than a resolvable
  version".
- `material_color_utilities 0.13.0` and `test_api 0.7.14` (Flutter SDK pins)
  and `built_collection 5.1.2` (transitive pin of `built_value`) — not this
  repo's to widen.
- The five gitignored locks, every CHANGELOG (release commits own those), and
  `.github/workflows/`.

## Verification

All runs at this branch with **Flutter 3.50.0 / Dart 3.14.0** — the declared
floor and the version `resolve-floor` pins — `--concurrency=2` per the fleet
guard. This host's default Flutter 3.47.9 cannot resolve the repo at all
(`Because zikzak_inappwebview requires Flutter SDK version >=3.50.0, version
solving failed`), so the SDK was cloned at the floor for the run.

- `flutter analyze --no-fatal-infos` × 9 packages + 2 examples + `wire_parity`
  → all exit 0, **0 warnings, 0 errors**, info counts identical to the
  AGENTS.md baseline (platform_interface 77, umbrella 44, android 197, ios 192,
  windows-fork 6, linux 4, macos/web/module clean; examples 30 / 2 / 0).
- `flutter test --concurrency=2` → umbrella **278 pass**, platform_interface
  **314 pass**, macos **177 pass**, ios **131 pass**, linux **71 pass**,
  windows **62 pass**, android **39 pass**, module **27 pass**,
  `zikzak_webview_windows` **2 pass**. **1101 tests, 0 failures.**
- `bash scripts/grep_gate.sh` → `PASS: no intelligence-layer code in plugin
  core.`
- `./scripts/local_ci.sh --job resolve-floor` → **all 3 runnable steps pass**:
  the minimal-consumer probe resolves on the floor graph with
  `zorphy 2.4.6`, `zorphy_annotation 2.4.6`, `web 1.1.2`, `vm_service 15.4.0`,
  `zuraffa 7.5.0`, and both `zikzak_inappwebview` and
  `zikzak_inappwebview_platform_interface` resolving from `path`.
- `flutter pub outdated` after the upgrade, per lock-owning package: **zero**
  "upgradable dependencies are locked (in pubspec.lock) to older versions"
  anywhere; only the deliberate constraint holds listed above remain
  (`flutter_lints`, `cupertino_icons`, `test_api`, `material_color_utilities`,
  `built_collection`).
- Not reproducible on this host (recorded, not skipped silently):
  `zikzak_inappwebview_web` tests need Chrome (`flutter test --platform
  chrome`) and this machine has no `google-chrome`/`chromium` binary — the run
  fails at load time with `Failed to find "google-chrome" in the search path`,
  before any Dart is compiled, so it is an environment gap and not a
  regression (the package's `flutter analyze` is clean and its lock only moved
  `material_ui`/`cupertino_ui` patch versions). `./scripts/local_ci.sh --plan`
  also reports `resolve-floor` step 4 as failing with
  `working-directory does not exist: .consumer-probe` — the probe directory is
  created by step 3, which `--plan` does not run; pre-existing, unrelated to
  this change (the real `--job resolve-floor` run above is the evidence).

## Misfire record (per AGENTS.md misfire rule)

Two environment fingerprints, both classified **environmental** rather than
code defects, per the repo's test-environment section:

1. `flutter pub get` refused to resolve with the host's default Flutter 3.47.9
   (`requires Flutter SDK version >=3.50.0`). Workaround: cloned Flutter 3.50.0
   at the declared floor and ran everything against it. No repo file was
   changed to accommodate the older SDK.
2. `flutter test --platform chrome` for `zikzak_inappwebview_web` cannot start:
   `Failed to find "google-chrome" in the search path`. No Chrome is installed
   on this host and installing one is out of proportion for a lockfile chore;
   the package's analyze is clean and the failure precedes any compilation.
   Recorded here and in the PR body rather than reported as repo redness.

Neither required a GitHub issue: both are host provisioning gaps, and the
assessment records them as such.

## Deviations from Assessment

- None on scope. The assessment's "verification to run" list was executed in
  full except the `--platform chrome` web suite and the `--plan` invocation
  (both blocked as described above, with the real job run instead).
- `resolve-floor` was run for real (`--job resolve-floor`), which the
  assessment listed as optional — it is the strongest available proof that the
  refreshed tree still resolves in the publish-like state.

## Follow-ups

- If a future release wants the majors (`flutter_lints ^6`, `cupertino_icons
  2.0.0`, `built_collection 6.0.0`), that is its own chore with a changelog
  review, per the issue's own suggested split.
- `tool/versions.dart`'s `zorphy*` constants have no consumer script; if they
  are meant to be authoritative, `update_readmes.dart` should read them (it
  currently reads `packageVersion` only).
