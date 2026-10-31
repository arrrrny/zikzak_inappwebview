# Chore Assessment: Adopt Flutter decoupled design systems (material_ui / cupertino_ui)

- **Slug**: 392-decoupled-design-systems
- **Created**: 2026-10-31
- **Source**: https://github.com/arrrrny/zikzak_inappwebview/issues/392
- **Verdict**: in scope
- **Size**: medium

## Report (verbatim or summarized)

Issue #392 — "feat: add decoupled design systems support" (label: `spec`) —
body:

> https://flutter.dev/blog/decoupling-material-cupertino
>
> https://pub.dev/packages/material_ui
> https://pub.dev/packages/cupertino_ui

Referenced sources (fetched 2026-10-31):

- **Flutter blog — "Material and Cupertino decoupling are here"**
  (`https://flutter.dev/blog/decoupling-material-cupertino`): starting months
  ago and landing in August 2026, contributions to the Material and Cupertino
  libraries were frozen inside the Flutter framework and exact replicas were
  released on pub.dev as the 1.0.0 versions of `pkg:material_ui` and
  `pkg:cupertino_ui`. Broken out into their own packages, they can now be
  released on their own weekly schedules, decoupling Flutter framework
  upgrades from design-system updates. Reasons: security patches and other
  fixes no longer drag Material/Cupertino UI updates along with them;
  independent release cadence; simpler CI workflows.
- **`pub.dev/packages/material_ui`** — "The official Flutter Material UI
  Library, implementing Google's Material Design design system." Current:
  `material_ui 1.9.0`.
- **`pub.dev/packages/cupertino_ui`** — "The official Flutter Cupertino Design
  Library, implementing the iOS design system." Current: `cupertino_ui 1.1.5`.

## Summary

Migrate every import of framework-bundled `package:flutter/material.dart` and
`package:flutter/cupertino.dart` in this monorepo to the standalone
`package:material_ui/material_ui.dart` (^1.9.0) and
`package:cupertino_ui/cupertino_ui.dart` (^1.1.5), and declare both packages
in every publishable package's `pubspec.yaml`. This is maintenance
(behavior-preserving import/source swap), not a bug fix and not a new
user-facing capability — hence a chore.

## Constitution Check

- **III. Test-Driven Development (NON-NEGOTIABLE)** — the migration itself is
  behavior-preserving, so the TDD evidence is the existing suites remaining
  green after the swap (`flutter test --concurrency=2`, concurrency capped at
  2 per the fleet guard) plus `flutter analyze --no-fatal-infos` per package.
  No test is weakened or skipped; if any test asserts on the old import
  source, `spec.md` decides which side is wrong.
- **Misfire rule** — noted. No zuraffa code is involved; the rule should not
  trigger. If a misfire does occur (compile error, test failure), STOP,
  report to `arrrrny/zuraffa`, and continue with a workaround per the rule.
- **Forklift pool owns the PR** — the PR is opened, never merged by hand; the
  `Merge PR` stage belongs to the pool.

## Affected Paths

Import swaps (`package:flutter/material.dart` → `package:material_ui/material_ui.dart`):

- `zikzak_inappwebview/lib/src/in_app_webview/in_app_webview.dart:6`
- `zikzak_inappwebview_platform_interface/lib/src/util.dart:6`
- `zikzak_inappwebview_android/lib/src/in_app_webview/in_app_webview.dart:2`
- `zikzak_inappwebview_ios/lib/src/in_app_webview/in_app_webview.dart:1`
- `zikzak_inappwebview_windows/lib/src/in_app_webview_windows_platform.dart:5`
- `zikzak_inappwebview/example/lib/main.dart` (+ 6 more example screens: `in_app_browser_example.screen.dart`, `chrome_safari_browser_example.screen.dart`, `headless_in_app_webview.screen.dart`, `in_app_webiew_example.screen.dart`, `first_load_race.screen.dart`, `passkey_example.screen.dart`, `in_app_webview_edge_to_edge.screen.dart`)
- `zikzak_inappwebview_linux/example/lib/main.dart`
- `zikzak_inappwebview_module/lib` — any material/cupertino imports found there

Pubspec additions (all 8 publishable packages):

- `zikzak_inappwebview/pubspec.yaml`
- `zikzak_inappwebview_platform_interface/pubspec.yaml`
- `zikzak_inappwebview_android/pubspec.yaml`
- `zikzak_inappwebview_ios/pubspec.yaml`
- `zikzak_inappwebview_macos/pubspec.yaml`
- `zikzak_inappwebview_web/pubspec.yaml`
- `zikzak_inappwebview_windows/pubspec.yaml`
- `zikzak_inappwebview_linux/pubspec.yaml`

(`zikzak_inappwebview_module` is `publish_to: none` — it picks up the
dependencies transitively and is not edited.)

## Proposed Approach

**Preferred**: import-source swap, dependency-declared, package by package.

1. In each `pubspec.yaml` add
   `material_ui: ^1.9.0` and `cupertino_ui: ^1.1.5` under `dependencies:`
   (SDK constraints already satisfy `>=3.8.0 <4.0.0` / `flutter >=3.38.6`).
2. Swap the imports in the Dart files listed under **Affected Paths**:
   `package:flutter/material.dart` → `package:material_ui/material_ui.dart`,
   `package:flutter/cupertino.dart` → `package:cupertino_ui/cupertino_ui.dart`.
   No API surface changes: the two packages are exact replicas of the
   framework libraries, so every `MaterialApp`, `Widget`, `Color`, `Key`,
   `BuildContext`, etc. resolves identically.
3. `flutter pub get` in each package (no `env -u HTTPS_PROXY` wrapper — this
   environment does not set that variable; if a proxy ever breaks pub, fix the
   proxy, never bake the unset into the repo).
4. Verify per package: `flutter analyze --no-fatal-infos` (0 new warnings —
   warnings are fatal, infos are not) and
   `flutter test --concurrency=2` (existing suites must stay green).
5. `bash scripts/grep_gate.sh` must stay green: no module-tier identifier
   (`WebViewPool`, `CaptureSource`, `CassetteEngine`, `DialogueDismissPort`,
   `RecipePort`, `NavigationTrackerPort`, `capture_service`,
   `cassette_engine`, `webview_pool`) appears in core, and the module still
   does not import `zikzak_inappwebview_platform_interface` directly.
6. Branch `chore/392-decoupled-design-systems`, conventional commit
   `chore: adopt decoupled material_ui/cupertino_ui (arrrrny/zikzak_inappwebview#392)`,
   PR into `master` with `Closes #392`. The forklift pool reviews and merges.

**Alternatives**:

- **Feature-flag the swap** (`--no-branch`, apply on current branch): faster
  but pollutes `master` with an un-reviewed mechanical change; rejected.
- **Re-export shim** (keep `package:flutter/material.dart` and re-export from
  the new packages): zero code churn today but leaves the framework dependency
  in place, defeating the purpose; rejected.
- **Wait for upstream tooling**: the Flutter blog says the decoupling is done
  and the packages are live on pub.dev; waiting buys nothing; rejected.

## Risks & Considerations

- **Version drift**: `material_ui`/`cupertino_ui` release weekly; pin with
  caret constraints (`^1.9.0`, `^1.1.5`) so minor/patch updates flow in.
- **Web build size**: `material_ui` on `dart2js` previously broke on
  64-bit literals in `zuraffa 7.x` (see `arrrrny/zuraffa#1729`, fixed in
  7.2.0). `material_ui 1.9.0` itself compiles clean; the umbrella's
  `zuraffa_session: ^7.3.0` pin keeps the working combination.
- **Transitive pins**: `synchronized: ^3.4.1` and the platform packages are
  pinned `^6.3.3`; adding two dependencies does not change those.
- **Publish order**: 8 packages publish in dependency order (see
  `PUBLISH.md`); `material_ui`/`cupertino_ui` are pub.dev packages, not
  published by this repo, so publish order is unaffected.
- **Blast radius**: 25 files across 8 packages, all import-line changes plus
  pubspec additions; no logic touched. Risk: low.

## Open Questions

- [NEEDS CLARIFICATION: none — package names, versions, and the blog post all agree on the approach]
