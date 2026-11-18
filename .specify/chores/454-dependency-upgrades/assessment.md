# Chore Assessment: Take the dependency upgrades that 6.5.0 left behind

- **Slug**: 454-dependency-upgrades
- **Created**: 2026-11-18
- **Source**: https://github.com/arrrrny/zikzak_inappwebview/issues/454 (host `github.com`, fetched via `gh` / GitHub API)
- **Verdict**: in scope
- **Size**: small

## Report (summarized)

Issue #454 was filed automatically by the dependency-bump rule after the
**6.5.0** release. It reports **39 upgradable dependencies** from a
`flutter pub outdated` run in `zikzak_inappwebview/` and splits them into
"constraint blocks the upgrade" (`material_ui`, `synchronized`,
`build_runner`), "lockfile holds them" (36 transitives), and "not upgradable"
(`material_color_utilities`, `test_api`, `built_collection`). Its suggested
next step is to assess each one, naming `synchronized`, `material_ui` and the
`zorphy` family as the likely-safe caret bumps and `build 4→5`,
`code_assets 1→2`, `package_config 2→3` as majors needing changelog review.

## Measurement (this run, before any change)

All numbers below were measured on `master` @ `7ce5c6c5` (the commit the issue
names) with **Flutter 3.50.0 / Dart 3.14.0** — the repo's own floor and the
version CI pins (`.github/workflows/ci.yml`, `resolve-floor`). This host's
default Flutter 3.47.9 cannot resolve the repo at all
(`Because zikzak_inappwebview requires Flutter SDK version >=3.50.0, version
solving failed`), so the SDK was cloned at the declared floor for the
measurement.

### 1. A fresh resolve already takes almost every row

`rm -f pubspec.lock && flutter pub get` in `zikzak_inappwebview/` resolves:

| Package | Issue says | Fresh resolve |
| --- | --- | --- |
| `material_ui` | 1.9.0, "constraint allows only 1.9.x" | **1.11.1** |
| `synchronized` | 3.4.1, "constraint allows only 3.4.x" | **3.6.1+1** |
| `build_runner` | 2.16.1, "constraint allows 2.17.1; lockfile holds it" | **2.17.1** |
| `zorphy`, `zorphy_annotation` | 2.4.3 → 2.4.6 | **2.4.6** |
| `archive` | 4.5.2 → 4.7.1 | **4.7.1** |
| `code_assets` | 1.2.1 → 2.2.0 | **2.2.0** |
| `package_config` | 2.2.0 → 3.0.0 | **3.0.0** |
| `record_use` | 0.6.0 → 1.1.1 | **1.1.1** |

`flutter pub outdated` on that fresh resolve reports **three** transitive
packages behind `Latest` and **none** upgradable or resolvable-newer:

```
built_collection           *5.1.2  *5.1.2  *5.1.2  6.0.0
material_color_utilities   *0.13.0 *0.13.0 *0.13.0 0.13.1
test_api                   *0.7.14 *0.7.14 *0.7.14 0.7.15
```

So the issue's three "constraint blocks the upgrade" rows are **not** blocked:
`^1.9.0`, `^3.4.1` and `^2.4.13` are carets, and each caret already admits the
version the issue calls upgradable. The 39-row list is the shape of a
**stale local `pubspec.lock`** (gitignored for the umbrella, `_android`,
`_ios`, `_linux` and `_platform_interface`), not of the declared constraints.
No constraint change is warranted for any of those rows, and per the repo's own
dependency-bump rule — "Do not raise every constraint to the locked version…
preserve the supported lower bound otherwise" — raising them would be a
downgrade of the published contract, not an upgrade.

### 2. The drift that is real: the seven tracked lockfiles

`.gitignore` keeps `pubspec.lock` out of five packages, so only seven locks are
tracked; AGENTS.md names them as "the ones whose drift changes what a builder
or the example apps get". Measured there, the drift is real:

| Tracked lock | Locked behind | Notable |
| --- | --- | --- |
| `zikzak_inappwebview/example` | 37 upgradable | `material_ui 1.9.0`, `synchronized 3.4.1`, `zorphy(_annotation) 2.4.3`, `archive 4.5.2`, `code_assets 1.2.1`, `package_config 2.2.0`, `record_use 0.6.0`, `build 4.0.10`, `url_launcher_*`, `vm_service 15.3.0`, `web 1.1.1`, `webdriver 3.1.0` |
| `zikzak_inappwebview_linux/example` | 12 upgradable | `material_ui 1.9.0`, `zorphy(_annotation) 2.4.3`, `build 4.0.11`, `cupertino_ui 1.1.5`, `platform 3.1.6` |
| `zikzak_inappwebview_linux/tool/wire_parity` | 2 upgradable | `zikzak_inappwebview_platform_interface 6.3.4` (two minors behind), `zorphy_annotation 2.4.4`; footer still `flutter: ">=3.47.0"` — the stale footer #393 recorded |
| `zikzak_inappwebview_macos` | 2 upgradable | `material_ui 1.11.0`, `cupertino_ui 1.1.6` |
| `zikzak_inappwebview_web` | 2 upgradable | same |
| `zikzak_inappwebview_windows` | 2 upgradable | same |
| `zikzak_inappwebview_module` | 2 upgradable | same, plus its lock carried the whole `zikzak_*` family at **6.3.4** and the retired `webview_windows 0.4.0` instead of the fork |

### 3. What is genuinely held

- `material_color_utilities 0.13.0` and `test_api 0.7.14` — Flutter SDK pins.
  `test_api` moves 0.7.12 → 0.7.14 in `wire_parity` only because that lock was
  resolved by an older SDK.
- `built_collection 5.1.1/5.1.2` — transitive pin of `built_value`; `6.0.0`
  is a major this repo does not control.
- `flutter_lints` in the umbrella example (`^4.0.0`) and in
  `zikzak_inappwebview_module` (`^5.0.0`) — majors behind the fleet's `^6.0.0`.
  Deliberately **not** touched: a constraint edit needs the changelog review
  the issue itself asks for, and it is not what 6.5.0 left behind.

## Summary

Take the upgrades that are actually being withheld — the seven tracked
lockfiles — by re-resolving each with `flutter pub upgrade`, and make
`tool/versions.dart`'s `zorphy` constants tell the truth about the resolved
`2.4.6`. No `pubspec.yaml` constraint changes: every one of them already admits
the resolved version, and the repo's rule is to keep the published lower bound.

## Constitution Check

`.specify/memory/constitution.md` has one filled principle: TDD
(NON-NEGOTIABLE) — every behavior change is driven by a test that failed first.
The "behavior" here is **resolution behavior**, and the red evidence is
recorded above: `flutter pub outdated` in each lock-owning package reporting
"37 / 12 / 2 upgradable dependencies are locked (in pubspec.lock) to older
versions", with `wire_parity`'s footer still reading `flutter: ">=3.47.0"` a
release after the floor moved. The green evidence is the same command
reporting none, plus the per-package analyze/test sweep (a lockfile bump is
only allowed to land if the tree still compiles and its suites still pass).
No other constitution principles apply (template placeholders).

## Affected Paths

- `zikzak_inappwebview/example/pubspec.lock`
- `zikzak_inappwebview_linux/example/pubspec.lock`
- `zikzak_inappwebview_linux/tool/wire_parity/pubspec.lock`
- `zikzak_inappwebview_macos/pubspec.lock`
- `zikzak_inappwebview_web/pubspec.lock`
- `zikzak_inappwebview_windows/pubspec.lock`
- `zikzak_inappwebview_module/pubspec.lock`
- `tool/versions.dart` — `zorphyVersion` / `zorphyAnnotationVersion`
  `2.4.3` → `2.4.6` (the resolved version; documentation only — no script reads
  these two constants, `update_readmes.dart` uses `packageVersion` alone)

Deliberately unchanged: every `pubspec.yaml`, every CHANGELOG (release commits
own those), `.github/workflows/`, and the five gitignored locks.

## Proposed Approach

**Preferred**: `flutter pub upgrade` inside each of the seven lock-owning
directories (Flutter, not `dart pub`, because six of the seven are Flutter
packages), then the version-constant touch-up in `tool/versions.dart`, then the
per-package `flutter analyze --no-fatal-infos` + `flutter test
--concurrency=2` sweep and `bash scripts/grep_gate.sh`.

**Alternatives**:
- Bump the three "constraint-blocked" carets anyway — rejected: they are not
  blocked, and raising a published lower bound excludes consumers for no gain
  (the repo's own rule).
- `flutter pub upgrade --major-versions` on the examples — rejected: it edits
  `pubspec.yaml` constraints (`flutter_lints ^4.0.0`, `sdk: ^3.12.2`) and is
  exactly the change the issue says needs a human decision per package.
- Take `built_collection 6.0.0` / `lints 6` too — rejected: transitive or
  dev-only majors with no consumer benefit in this chore.

**Verification to run**: per-package `flutter analyze --no-fatal-infos` and
`flutter test --concurrency=2` (web with `--platform chrome`), `bash
scripts/grep_gate.sh`, and `./scripts/local_ci.sh --plan` to confirm the
workflow still parses.

## Risks & Considerations

- **A lockfile bump reaches CI**: `build-linux` and the macOS/iOS build jobs
  `flutter pub get` the example apps, so the refreshed example locks are what
  CI compiles. That is the point, and it is why the example apps' `flutter
  analyze` is part of the gate rather than optional.
- **Majors crossed as transitives** (`build 4→5`, `code_assets 1→2`,
  `package_config 2→3`, `record_use 0.6→1.1.1`, `jni 1.0→1.1.2`) ride in on
  the re-resolve. They are dev-time tooling (build_runner / hooks / native
  assets), not runtime API this repo calls; the analyze/test sweep is what
  proves it.
- **Windows native code is not compiled here** (no Windows toolchain, no CI
  runner), so a green `_windows` suite says nothing about its C++. Unchanged
  by this chore — no native source is touched.
- **Toolchain**: verification needs Flutter ≥3.50.0; the default Flutter on
  this host (3.47.9) refuses to resolve the repo. Recorded, not worked around
  by lowering the floor.

## Open Questions

- None. The issue's own "Suggested next step" is a per-package assessment; this
  assessment answers it for all 39 rows in one place instead of splitting them
  into 39 chores, because measurement shows 36 of them are already taken by a
  fresh resolve and only the lockfile drift needs a decision.