# Chore Assessment: Take the dependency upgrades that 6.6.0 left behind

- **Slug**: 468-dependency-upgrades
- **Created**: 2026-11-27
- **Source**: https://github.com/arrrrny/zikzak_inappwebview/issues/468 (host `github.com`, fetched via `gh` / GitHub API)
- **Verdict**: in scope
- **Size**: small

## Report (summarized)

Issue #468 was filed automatically by the dependency-bump rule after the
**6.6.0** release. It reports the upgrades `flutter pub outdated` listed as
held back, split into "held by our own constraint" (`synchronized`,
`zuraffa_session`, `build_runner`), transitive pins, and SDK pins
(`material_color_utilities`, `test_api` — not ours to widen). It names
`synchronized 3.5.0 → 3.6.1+1`, `zuraffa_session 7.5.0 → 7.6.1`,
`build_runner 2.16.2 → 2.17.1`, and the `zorphy`/`zorphy_annotation`/
`zuraffa` family `2.4.x/7.5.x → 2.5.1/7.6.1` (single-sourced in
`tool/versions.dart`). Its suggested next step is to take the constraint-
respecting set, evaluate the majors separately, and re-run the per-package
analyze + test gate.

This is the direct successor of chore #454 (6.5.0), whose assessment established
the method reused here: the issue's "constraint blocks the upgrade" rows are a
**stale gitignored `pubspec.lock`**, not the declared constraints, and the real
drift lives in the seven **tracked** lockfiles.

## Measurement (this run, before any change)

Measured on `master` @ `19b13d24` with **Flutter 3.50.1 / Dart 3.14.x** — at
the repo's declared floor (`flutter: >=3.50.0`) and the version CI's
`resolve-floor` pins.

### 1. A fresh resolve already takes every constraint-respecting row

`rm -f pubspec.lock && flutter pub get` in `zikzak_inappwebview/` resolves:

| Package | Issue says | Fresh resolve |
| --- | --- | --- |
| `synchronized` | 3.5.0, "constraint allows 3.6.1+1" | **3.6.1+1** |
| `zuraffa_session` | 7.5.0 → 7.6.1 | **7.6.1** |
| `zuraffa` | 7.5.1 → 7.6.1 | **7.6.1** |
| `zorphy`, `zorphy_annotation` | 2.4.x → 2.5.1 | **2.5.1** |
| `build_runner` | 2.16.2 → 2.17.1 | **2.17.1** |

`flutter pub outdated` on that fresh resolve reports only the two Flutter-SDK
pins behind `Latest` and **none** upgradable-or-resolvable-newer:

```
material_color_utilities   *0.13.0  *0.13.0  *0.13.0  0.13.1
test_api                   *0.7.14  *0.7.14  *0.7.14  0.7.15
```

So the issue's "our declared constraints hold them" rows are **not** blocked:
`synchronized ^3.4.1`, `zuraffa_session ^7.5.0` and `build_runner ^2.4.13` are
carets that already admit the resolved versions. The list is the shape of a
stale local `pubspec.lock` (gitignored for the umbrella, `_android`, `_ios`,
`_linux` and `_platform_interface`), not of the declared constraints. No
constraint change is warranted, and per the repo's own dependency-bump rule —
"Do not raise every constraint to the locked version… preserve the supported
lower bound otherwise" — raising them would shrink the published contract.

### 2. The drift that is real: the seven tracked lockfiles

`.gitignore` keeps `pubspec.lock` out of five packages, so only seven locks are
tracked. Measured there before the upgrade, the drift is real:

| Tracked lock | Held behind (upgradable) |
| --- | --- |
| `zikzak_inappwebview/example` | 10: `zorphy(_annotation) 2.4.6→2.5.1`, `zuraffa(_session) 7.5.0→7.6.1`, `built_value 8.13.0→8.13.1`, `hive_ce 2.23.3→2.24.0`, `isolate_channel 0.6.2→0.6.3`, `jni 1.1.2→1.2.1`, `jni_flutter 1.0.4+1→1.1.0`, `built_collection 5.1.2→6.0.0` |
| `zikzak_inappwebview_linux/example` | 1 (+ stale lock): `zorphy_annotation 2.4.6→2.5.1`; the lock was missing 52 resolved entries |
| `zikzak_inappwebview_linux/tool/wire_parity` | 2: `zikzak_inappwebview_platform_interface 6.5.0→6.6.0`, `zorphy_annotation 2.4.6→2.5.1` |
| `zikzak_inappwebview_macos` | 1: `zorphy_annotation 2.4.6→2.5.1` |
| `zikzak_inappwebview_web` | 1: `zorphy_annotation 2.4.6→2.5.1` |
| `zikzak_inappwebview_windows` | 3: `jni 1.1.2→1.2.1`, `jni_flutter 1.0.4+1→1.1.0`, `zorphy_annotation 2.4.6→2.5.1` |
| `zikzak_inappwebview_module` | (lock already current; re-resolve bumps the `zikzak_*` family 6.5.0→6.6.0) |

## What is genuinely held

- `material_color_utilities 0.13.0` and `test_api 0.7.14` — Flutter SDK pins,
  not ours to widen.
- `built_collection 6.0.0`, `flutter_lints 6.0.0`/`lints 6.1.0`,
  `cupertino_icons 2.0.0` — majors. `flutter pub upgrade` (no
  `--major-versions`) does not cross a major, so these stay held; taking them is
  the separate changelog-review chore the issue itself calls for.

## Summary

Take the upgrades actually being withheld — the seven tracked lockfiles — by
re-resolving each with `flutter pub upgrade`, and make `tool/versions.dart`'s
`zorphy`/`zuraffa` constants tell the truth about the resolved `2.5.1`/`7.6.1`.
No `pubspec.yaml` constraint changes.

## Constitution Check

`.specify/memory/constitution.md` has one filled principle: TDD
(NON-NEGOTIABLE). The "behavior" here is **resolution behavior**; the red
evidence is `flutter pub outdated` in each lock-owning package reporting
"N upgradable dependencies are locked (in pubspec.lock) to older versions"
(quoted above). The green evidence is the same command reporting none, plus the
per-package analyze/test sweep (a lockfile bump may only land if the tree still
compiles and its suites still pass).

## Affected Paths

- `zikzak_inappwebview/example/pubspec.lock`
- `zikzak_inappwebview_linux/example/pubspec.lock`
- `zikzak_inappwebview_linux/tool/wire_parity/pubspec.lock`
- `zikzak_inappwebview_macos/pubspec.lock`
- `zikzak_inappwebview_web/pubspec.lock`
- `zikzak_inappwebview_windows/pubspec.lock`
- `zikzak_inappwebview_module/pubspec.lock`
- `tool/versions.dart` — `zorphyVersion`/`zorphyAnnotationVersion` `2.4.6` →
  `2.5.1`, `zuraffaVersion`/`zuraffaFlutterVersion`/`zuraffaSessionVersion`
  `7.5.0` → `7.6.1` (documentation only — `update_readmes.dart` reads
  `packageVersion`, so no README churn)

Deliberately unchanged: every `pubspec.yaml`, every CHANGELOG, `.github/`, and
the five gitignored locks.

## Proposed Approach

`flutter pub upgrade` inside each of the seven lock-owning directories (Flutter,
not `dart pub`, because six of the seven are Flutter packages), the
version-constant touch-up in `tool/versions.dart` followed by
`dart run tool/update_readmes.dart`, then the per-package `flutter analyze
--no-fatal-infos` + `flutter test --concurrency=2` sweep and `bash
scripts/grep_gate.sh`.

## Risks & Considerations

- **A lockfile bump reaches CI**: the build jobs `flutter pub get` the example
  apps, so the refreshed example locks are what CI compiles.
- **Majors crossed as transitives** (`built_collection 5.1.2→6.0.0` in the
  example/module locks) ride in on the re-resolve; they are dev-time tooling,
  and the analyze/test sweep is what proves it.
- **Windows native code is not compiled here** — unchanged by this chore; no
  native source is touched.

## Open Questions

- None.