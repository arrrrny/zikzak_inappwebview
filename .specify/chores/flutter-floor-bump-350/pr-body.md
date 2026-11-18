## Summary

Raises the declared Flutter floor from `>=3.47.0` to `>=3.50.0` across the fleet,
so every supported consumer is on the first Flutter stable that carries the #331
fix (iOS platform views no longer drop overlapping Flutter content — "rendering
layer confusion"). The regression was an engine bug in Flutter's texture-layer
hybrid composition overlay path ([flutter/flutter#193363](https://github.com/flutter/flutter/issues/193363)),
confirmed fixed by the reporter on 3.50.0; it was never a plugin code defect.

This is dependency/config maintenance — no Dart/native source changed.

Assessment: `.specify/chores/flutter-floor-bump-350/assessment.md`
Implementation: `.specify/chores/flutter-floor-bump-350/implement.md`

## Changes

| Area | Change |
|------|--------|
| 10 `pubspec.yaml` floors | `flutter: ">=3.47.0"` → `">=3.50.0"` (8 publishable + dev-only `module` + the `zikzak_webview_windows` fork) |
| `.github/workflows/ci.yml` | `resolve-floor` job name + `flutter-version` pin → 3.50.0; probe `sdk` → `>=3.14.0 <4.0.0` (Dart that ships with 3.50.0) + comment; **`build-linux` bootstrap pin 3.47.0 → 3.50.0** (builds the local example, so it must track the floor) |
| `AGENTS.md` | SDK-floor line + runtime-minimums + CI-matrix description + dependency-bump-rule rationale → 3.50.0 (#331) |
| `README.md` + package README | Flutter requirement → 3.50.0+; removed the now-obsolete #331 "Known Issues" section (no supported consumer is on a broken Flutter any more); fixed a stale `3.10.0+` value in the package README |
| `zikzak_webview_windows/README.md` | fork "differences from upstream" floor note → 3.50.0 |
| 6 tracked `pubspec.lock` | `sdks: flutter:` footer → `>=3.50.0` only (footer-only; no dependency drift bundled) |

`sdk:` floors stay `>=3.8.0 <4.0.0` — the `flutter:` line is the enforceable
floor and every Flutter ≥3.50.0 ships Dart ≥3.14.0, which satisfies it.

## Verification

Flutter 3.50.0 / Dart 3.14.0, `--concurrency=2`:

- `flutter analyze --no-fatal-infos` × 10 packages — identical to the AGENTS.md
  baseline (infos only; zero new warnings/errors).
- `flutter test` — umbrella 278, platform_interface 314, android 39, ios 131,
  macos 166, windows 62, linux 71, web (chrome) 1 — all pass.
- `scripts/grep_gate.sh` — PASS (core↔module split intact).
- `scripts/local_ci.sh --job resolve-floor` — PASS: probe resolves this checkout
  from `path`, zuraffa 7.5.0 (nocterm-free 7.x line).
- Lock diffs are footer-only (no dependency upgrades swept in, per the repo's
  dependency-bump-rule).

## Note

`zikzak_inappwebview_module` tests fail to compile, but this reproduces
**identically on pristine `master`** — a pre-existing break from #451 (the module
has no `pubspec_overrides`, so it compiles umbrella source against hosted
platform_interface 6.4.1 which predates the `onEvicted` param). The module is
`publish_to: none` and outside the CI matrix. Not introduced by, and not in scope
for, this chore; will be filed separately.

Closes #331.