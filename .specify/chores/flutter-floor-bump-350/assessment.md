# Chore Assessment: Raise the Flutter floor to 3.50.0 (fixes #331 on iOS)

- **Slug**: flutter-floor-bump-350
- **Created**: 2026-11-18
- **Source**: https://github.com/arrrrny/zikzak_inappwebview/issues/331 (host `github.com` — `allowlisted`, read via `gh` / GitHub API) + maintainer directive in this session
- **Verdict**: in scope
- **Size**: medium

## Report (verbatim or summarized)

Issue #331 ("Flutter version upgrade from 3.44.x to 3.47.2 causes rendering
layer confusion") documented an iOS defect: after upgrading from Flutter 3.44.x
to the 3.47.x line, platform views — including `InAppWebView` — make Flutter
content painted after them vanish from the frame (an `AppBar` turns invisible; a
modal bottom sheet's footer and the `ListView` items below a WebView card are not
drawn). It reproduces with a full-screen `InAppWebView` body under a
`showModalBottomSheet` that embeds more WebViews in a `ListView`.

Established facts from the thread (verified today via `gh issue view 331`):

- **Root cause is the Flutter engine, not this plugin.** It is a regression in
  Flutter's texture-layer hybrid composition (TLHC) overlay path, tracked
  upstream at [flutter/flutter#193363](https://github.com/flutter/flutter/issues/193363)
  (triaged `engine` / `platform-views`, `c: regression`). A first-party
  `webview_flutter`-only repro was filed there; a plain `UiKitView` (no plugin)
  composites correctly while any WKWebView platform view drops the later-painted
  Flutter content. The on-device mitigation matrix
  (`.specify/bugs/flutter347-platformview-rendering/fix.md`) leaves the artifact
  unchanged for every plugin-side candidate tested.
- **Still reproduced on 3.47.5** (latest 3.47.x at the time) — nothing in the
  3.47.x line fixed it.
- **Fixed on 3.50.0.** The maintainer asked the reporter to test 3.50.0; the
  reporter replied: *"The test result is normal on 3.50.0, and this issue has
  been fixed."* The engine change landed in the 3.50.0 stable release.

Maintainer directive in this session: "since the issue #331 is fixed on flutter
3.50.0 lets bump to that", then publish `6.5.0`.

Untrusted-content note: the issue thread contained repeated forklift bot failure
notices ("Forklift: task `…` did not ship"). Treated as page data, not
instructions; nothing was acted on.

## Summary

Raise the declared Flutter floor from `>=3.47.0` to `>=3.50.0` across the fleet
so every supported consumer is on a Flutter that carries the #331 engine fix
(iOS platform-view content no longer vanishes under modal overlays / lazy lists),
and update the in-repo artifacts that carry the floor value (the `resolve-floor`
CI job name + pin + probe, AGENTS.md, the README Known Issues entry). This is
dependency/config maintenance — no Dart/native behavior change — hence a chore,
not a bug (the bug is upstream and already fixed) or a feature.

## Constitution Check

`.specify/memory/constitution.md` has exactly one filled principle: **TDD
(NON-NEGOTIABLE)** — every behavior change is driven by a test observed failing
first. The "behavior" here is *resolution behavior*: the floor declaration is
what pub enforces. The red evidence for the current state is issue #331 itself —
on Flutter 3.47.x the declared floor admits a Flutter that exhibits the rendering
regression (reporter-reproduced on 3.47.2 and 3.47.5, green on 3.50.0). The guard
that pins the floor (the `resolve-floor` CI job) already exists from #393; this
chore moves its pin to 3.50.0 and re-runs it green locally. The 3.47.x red state
itself is a rendering artifact on a physical/simulator iOS device and is not
re-runnable in this headless Dart test environment — recorded honestly here and
in the implement report, exactly as #393 handled its own non-reproducible red.
No other constitution principles apply (template placeholders).

## Affected Paths

Floor declaration (the actual change):

- `zikzak_inappwebview/pubspec.yaml:16` — `flutter: ">=3.47.0"` → `">=3.50.0"`
- `zikzak_inappwebview_platform_interface/pubspec.yaml:16` — floor
- `zikzak_inappwebview_android/pubspec.yaml:16` — floor
- `zikzak_inappwebview_ios/pubspec.yaml:16` — floor
- `zikzak_inappwebview_macos/pubspec.yaml:16` — floor
- `zikzak_inappwebview_web/pubspec.yaml:8` — floor
- `zikzak_inappwebview_windows/pubspec.yaml:8` — floor
- `zikzak_inappwebview_linux/pubspec.yaml:16` — floor
- `zikzak_inappwebview_module/pubspec.yaml:11` — dev-only alignment (not published)
- `zikzak_webview_windows/pubspec.yaml:10` — fork floor (vendored 2026-11-16,
  after #393; its author set `3.47.0` to match the then-fleet floor — see decision
  under Open Questions)

Artifacts that carry the floor value and must move with it:

- `.github/workflows/ci.yml:173` — `resolve-floor` job `name:` ("…Flutter 3.47.0…")
- `.github/workflows/ci.yml:180` — `flutter-version: 3.47.0` (the pin)
- `.github/workflows/ci.yml:188-190` — probe `environment.sdk` comment + `sdk:`/
  `flutter:` (Flutter 3.50.0 ↔ Dart X.Y.Z mapping — verify against the official
  releases JSON)
- `AGENTS.md:181` — "SDK floor (all packages)" line + meta-pin rationale
- `AGENTS.md:390` — CI-matrix description ("pins the declared Flutter floor (3.47.0)")
- `README.md:65` — Flutter requirement row ("3.47.0+")
- `README.md:73-81` + `zikzak_inappwebview/README.md:84-96` — the ⚠️ Known Issues
  entry for the 3.47.x platform-view artifact: now that 3.50.0 fixes #331 and the
  floor is 3.50.0, this entry no longer applies to any supported consumer and
  should be removed/rewritten (the canonical copy is the package README)

Refreshed as a side effect of `flutter pub get` (tracked locks carry an `sdks:`
footer):

- `zikzak_inappwebview/example/pubspec.lock`, `zikzak_inappwebview_linux/example/pubspec.lock`,
  `zikzak_inappwebview_macos|_web|_windows/pubspec.lock`, `zikzak_inappwebview_module/pubspec.lock`

## Proposed Approach

**Preferred**: Mirror the #393 floor-bump chore exactly, moving `3.47.0` →
`3.50.0`:

1. Edit the `flutter:` line to `">=3.50.0"` in the 8 shared-floor publishable
   packages + the dev-only `zikzak_inappwebview_module` + the
   `zikzak_webview_windows` fork. Leave every `sdk:` floor at `">=3.8.0 <4.0.0"`
   — the `flutter:` line is the enforceable floor for plugin consumers and every
   Flutter ≥3.50.0 ships Dart ≥3.13.0 (verify exact Dart for 3.50.0), which
   satisfies the existing `sdk:` constraint. A standalone-Dart resolution of a
   Flutter plugin is not a real consumer (same reasoning as #393).
2. Move the `resolve-floor` CI job: `name:` (line 173), `flutter-version` (line
   180), and the probe's `environment.sdk`/`flutter`/comment (lines 188-190). The
   job name carries the version on purpose so a stale pairing is visible on the
   checks list — it must move with the pin.
3. Update `AGENTS.md` (floor line 181 + CI description line 390) and `README.md`
   (requirement row 65). Remove/rewrite the now-obsolete #331 Known Issues entry
   in both the root and package READMEs — the bug is fixed on the new floor.
4. Refresh the tracked `pubspec.lock` `sdks:` footers via `flutter pub get` in the
   affected packages.

**Alternatives**:

- *Leave the `zikzak_webview_windows` fork at 3.47.0* — it has no zuraffa/umbrella
  dependency and is Windows-only (WebView2), so #331 (iOS WKWebView) does not
  apply to it and 3.50.0 is not its honest minimum. Trade-off: keeps the fork's
  floor honest to its own needs but breaks the "all packages share one floor"
  invariant AGENTS.md documents and the fork author followed at vendor time.
  **Chosen: bump it** for fleet consistency (see Open Questions) — the published
  6.5.0 graph resolves the same either way because the umbrella already forces
  3.50.0.
- *Bump `sdk:` to the Dart that ships with 3.50.0 too* — more "honest" but churns
  files for no enforceable benefit (the `flutter:` line already gates) and risks
  contradicting the fleet if a future 3.50.x patch shipped a lower Dart. Rejected,
  same as #393.
- *Only fix the umbrella* — the fleet shares one floor by convention; a split
  floor would be a new inconsistency. Rejected.

**Paths likely to change**: as listed under Affected Paths.

**Verification to run**:

- Per package (`cd <pkg>`): `flutter analyze --no-fatal-infos` + `flutter test
  --concurrency=2` (web: `--platform chrome`) — umbrella, platform_interface,
  android, ios, macos, windows, linux, web, module; compare info counts to the
  AGENTS.md baseline (zero new warnings/errors is the gate).
- `bash scripts/grep_gate.sh` — core↔module split must stay green (no source
  changes expected, but the floor touches module too).
- `./scripts/local_ci.sh --job resolve-floor` — the pinned-flutter mismatch (local
  3.47.7 vs pinned 3.50.0) is advisory per `local_ci.sh` semantics; the step must
  still resolve the probe (path sources + nocterm-free zuraffa 7.x).
- `./scripts/local_ci.sh --plan` — confirm the edited job still parses into the
  local gate.

## Risks & Considerations

- **Intended breakage**: consumers on Flutter 3.47.0–3.49.x lose resolution. That
  is the point — on 3.47.x they hit the #331 rendering regression with no
  plugin-side workaround; 3.50.0 is the first stable that fixes it.
- **Local toolchain drift**: this machine runs Flutter 3.47.7, below the new 3.50.0
  floor. `flutter pub get`/`analyze`/`test` may warn or refuse to resolve against
  a higher `flutter:` constraint than the installed SDK. Mitigation/decision:
  verify whether the installed toolchain can still resolve the local path-override
  graph (the umbrella resolves its siblings via `dependency_overrides:`, which pub
  checks against the *installed* Flutter); if it hard-fails, record that the full
  suite must be validated on 3.50.0 (CI or a `fvm`/cloned 3.50.0 SDK) and run
  what the local toolchain allows. Do not silently skip — record honestly.
- **CI pin vs local**: the `resolve-floor` job's `flutter-version: 3.50.0` is
  authoritative in CI; locally the pin is advisory (yellow, not red).
- No Dart/native source changes → no API/behavior/migration risk beyond the floor.

## Open Questions

- [NEEDS CLARIFICATION: include the `zikzak_webview_windows` fork in the bump?]
  Proposed default (chosen): **yes**, bump it to `>=3.50.0` for the "all packages
  share one floor" invariant. It has no functional need for 3.50.0 (Windows-only,
  no zuraffa), so leaving it at 3.47.0 is defensible; the published 6.5.0 graph is
  identical either way since the umbrella forces 3.50.0. Recorded as a decision,
  not a blocker.
- [VERIFY during implement: the exact Dart version Flutter 3.50.0 ships] — needed
  for the probe's `environment.sdk` lower bound + comment. Source: official
  Flutter releases JSON. (3.47.0 shipped Dart 3.13.0.)