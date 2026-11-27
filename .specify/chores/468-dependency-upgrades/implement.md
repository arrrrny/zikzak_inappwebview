# Chore Implementation: Take the dependency upgrades that 6.6.0 left behind

- **Slug**: 468-dependency-upgrades
- **Implemented**: 2026-11-27
- **Assessment**: ./assessment.md
- **Status**: applied

## Summary

The seven **tracked** lockfiles were re-resolved with `flutter pub upgrade`, so
the versions a builder or an example app actually gets now match what the
declared constraints already allow: `zorphy`/`zorphy_annotation 2.4.6 → 2.5.1`,
`zuraffa`/`zuraffa_session 7.5.0 → 7.6.1`, `synchronized → 3.6.1+1`,
`build_runner → 2.17.1`, plus transitive patch/minor bumps (`built_value
8.13.0 → 8.13.1`, `hive_ce 2.23.3 → 2.24.0`, `isolate_channel 0.6.2 → 0.6.3`,
`jni 1.1.2 → 1.2.1`, `jni_flutter 1.0.4+1 → 1.1.0`) and the `module`/`example`
locks' `zikzak_*` family `6.5.0 → 6.6.0`. `tool/versions.dart`'s `zorphy` and
`zuraffa` constants follow to `2.5.1` / `7.6.1`; `dart run
tool/update_readmes.dart` produced no README churn (it reads `packageVersion`
alone). **No `pubspec.yaml` constraint changed** — measurement (assessment §1)
shows every caret already admits the resolved version, so raising one would
shrink the published contract instead of widening it.

## Changes

| File | Change | Notes |
|------|--------|-------|
| `zikzak_inappwebview/example/pubspec.lock` | modified | 10 deps: zorphy/zuraffa family, built_value, hive_ce, isolate_channel, jni, jni_flutter, built_collection 5.1.2→6.0.0 |
| `zikzak_inappwebview_linux/example/pubspec.lock` | modified | full re-resolve; lock was missing 52 entries, zorphy_annotation → 2.5.1 |
| `zikzak_inappwebview_linux/tool/wire_parity/pubspec.lock` | modified | platform_interface 6.5.0→6.6.0, zorphy_annotation → 2.5.1; footer already `flutter: ">=3.50.0"` |
| `zikzak_inappwebview_macos/pubspec.lock` | modified | zorphy_annotation 2.4.6 → 2.5.1 |
| `zikzak_inappwebview_web/pubspec.lock` | modified | zorphy_annotation 2.4.6 → 2.5.1 |
| `zikzak_inappwebview_windows/pubspec.lock` | modified | jni 1.1.2→1.2.1, jni_flutter 1.0.4+1→1.1.0, zorphy_annotation → 2.5.1 |
| `zikzak_inappwebview_module/pubspec.lock` | modified | zikzak_* family 6.5.0→6.6.0, zorphy/zuraffa family, built_value/hive_ce/isolate_channel/jni/jni_flutter, built_collection 5.1.2→6.0.0 |
| `tool/versions.dart` | modified | zorphy/zorphy_annotation 2.4.6→2.5.1; zuraffa/zuraffaFlutter/zuraffaSession 7.5.0→7.6.1. Documentation only — no script reads these constants (`update_readmes.dart` uses `packageVersion`), so no README churn |
| `.specify/chores/468-dependency-upgrades/{assessment,implement}.md` | added | this chore's record |

Deliberately unchanged:

- **Every `pubspec.yaml` constraint.** `synchronized ^3.4.1`,
  `zuraffa_session ^7.5.0`, `build_runner ^2.4.13` already admit the resolved
  versions (proved in the assessment), and the repo's rule is "Do not raise
  every constraint to the locked version … preserve the supported lower bound
  otherwise".
- `flutter_lints`/`lints 6.x`, `cupertino_icons 2.0.0`, `built_collection
  6.0.0` (where it is a held major rather than a transitive that rode in) —
  majors, the "needs changelog review" class the issue says a human must
  decide.
- `material_color_utilities 0.13.0` and `test_api 0.7.14` (Flutter SDK pins).
- The five gitignored locks, every CHANGELOG, and `.github/workflows/`.

## Verification

All runs at this branch with **Flutter 3.50.1 / Dart 3.14.x** — at the declared
floor and the version `resolve-floor` pins — `--concurrency=2` per the fleet
guard.

- `flutter analyze --no-fatal-infos` → umbrella **44 infos**, platform_interface
  **77 infos**, macos/web/windows-fork/module **clean**, examples **30 / 2**,
  wire_parity **clean** — all **0 warnings, 0 errors**, identical to the
  AGENTS.md baseline.
- `flutter test --concurrency=2` → umbrella **278 pass**, platform_interface
  **314 pass**, plus the macos/windows/linux/webview_windows/module suites.
- `bash scripts/grep_gate.sh` → `PASS: no intelligence-layer code in plugin
  core.`
- `flutter pub outdated` after the upgrade, per lock-owning package: **zero**
  "upgradable dependencies are locked (in pubspec.lock) to older versions"
  anywhere; only the deliberate major/SDK holds remain.
- Not reproducible on this host (recorded, not skipped silently):
  `zikzak_inappwebview_web` tests need Chrome (`flutter test --platform chrome`);
  the package's `flutter analyze` is clean and its lock only moved
  `zorphy_annotation`, so this is an environment gap, not a regression.

## Misfire record (per AGENTS.md misfire rule)

None. The host's default Flutter is 3.50.1, which satisfies the repo's
`>=3.50.0` floor, so no toolchain workaround was needed (unlike #454, which ran
on a 3.47.9 host). No code misfire occurred.

## Deviations from Assessment

- None on scope.

## Follow-ups

- The majors (`flutter_lints ^6`, `cupertino_icons 2.0.0`, `built_collection
  6.0.0` where held) remain for a future release's own changelog-review chore,
  per the issue's suggested split.