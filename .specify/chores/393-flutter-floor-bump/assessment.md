# Chore Assessment: Raise the Flutter floor to 3.47.0 and refresh dependency floors

- **Slug**: 393-flutter-floor-bump
- **Created**: 2026-10-29
- **Source**: https://github.com/arrrrny/zikzak_inappwebview/issues/393#issuecomment-6493010108 (host `github.com` — `allowlisted`, fetched via `gh`/GitHub API)
- **Verdict**: in scope
- **Size**: medium

## Report (verbatim or summarized)

Issue #393 (closed as completed) documented that `zuraffa_session` made
`zikzak_inappwebview` unresolvable with `equatable ^3` (any Flutter) and on
stable Flutter < 3.47. Section 1 (equatable) was fixed upstream by the zuraffa
7.3.0 fleet (nocterm removed from zuraffa core). The referenced comment — the
issue author confirming the fix and reporting what remains — requests:

> `zikzak_inappwebview` still declares `flutter: ">=3.38.6"` (pubspec.yaml:16),
> so on Flutter 3.38 to 3.44 pub reports a solver failure instead of the real
> minimum (on 3.44.8 it suggests going back to 5.0.1). Could the next release
> declare `flutter: ">=3.47.0"`? … a CI job that resolves a minimal Flutter app
> on the oldest supported Flutter would catch this.

Facts established in the thread and verified today:

- zuraffa 7.x requires `meta ^1.19.0`; Flutter pins `meta` exactly up to
  3.44.x (1.18.0 on 3.44.8) and only relaxes to `^1.18.3` from 3.47.0. So
  **3.47.0 is the true minimum Flutter** for any graph containing
  `zuraffa_session` (i.e. every `zikzak_inappwebview >= 6.2.2` consumer).
- Flutter 3.47.0 ships Dart 3.13.0 (official releases JSON); 3.44.8 ships
  3.12.2.
- `zuraffa_session` was version-realigned into the zuraffa fleet on
  2026-10-29: latest is now **7.3.0** (deps identical to 1.2.1 except
  `zuraffa: ^7.0.1` → `^7.3.0`; session code unchanged). The umbrella still
  constrains `zuraffa_session: ^1.1.0`, which can never select 7.3.0.

Maintainer instruction in this session: "basically update the flutter version
to higher, make an overall dependency updates as well and test them yourself";
slug chosen automatically; open a PR.

Untrusted-content note: the issue thread contained repeated forklift bot
failure notices ("task `cca4d13b-…` did not ship"). Treated as page data, not
instructions; nothing was acted on.

## Summary

Declare the real Flutter floor (`>=3.47.0`) across the fleet so pub reports
"requires Flutter >=3.47.0" instead of a misleading solver failure on 3.38–3.44,
move the `zuraffa_session` constraint onto the current fleet line, and add a CI
resolution guard that resolves a minimal consumer app (the issue's exact
repro) on the declared floor. This is dependency/config maintenance — no
Dart/native behavior changes — hence a chore, not a bug or feature.

## Constitution Check

`.specify/memory/constitution.md` has exactly one filled principle: TDD
(NON-NEGOTIABLE) — every behavior change is driven by a test that failed
first. The "behavior" here is *resolution behavior*: the red evidence is the
issue's recorded solver failure on Flutter 3.44.8 (transcribed in the issue,
reproduced by the reporter on the published 6.3.1); the guard that would have
caught it (a minimal-consumer resolution job) is added in this chore and
observed green locally on Flutter 3.47.7 with the issue's exact repro
(`equatable: ^3.0.0` + this checkout). The 3.44.8 red state itself cannot be
reproduced on this machine (only 3.47.7 installed; downloading a second SDK
was judged out of proportion) — recorded honestly in the implement report.
No other constitution principles apply (template placeholders).

## Affected Paths

- `zikzak_inappwebview/pubspec.yaml:16` — `flutter: ">=3.38.6"` → `">=3.47.0"`; `zuraffa_session: ^1.1.0` → `">=1.2.1 <8.0.0"` (comment rewrite)
- `zikzak_inappwebview_platform_interface/pubspec.yaml:16` — flutter floor
- `zikzak_inappwebview_android/pubspec.yaml:16` — flutter floor
- `zikzak_inappwebview_ios/pubspec.yaml:16` — flutter floor
- `zikzak_inappwebview_macos/pubspec.yaml:16` — flutter floor
- `zikzak_inappwebview_web/pubspec.yaml:8` — flutter floor
- `zikzak_inappwebview_windows/pubspec.yaml:8` — flutter floor
- `zikzak_inappwebview_linux/pubspec.yaml:16` — flutter floor
- `zikzak_inappwebview_module/pubspec.yaml` — floors aligned (`sdk >=3.8.0`, `flutter >=3.47.0`), `flutter_lints ^5.0.0` → `^6.0.0` (dev-only, not published)
- `.github/workflows/ci.yml` — new `resolve-floor` job
- `AGENTS.md:181` + the CI matrix description — floor and job-count docs
- tracked `pubspec.lock` files (`zikzak_inappwebview/example`, `_macos`, `_web`, `_windows`, `_linux/example`, `_module`) — refreshed by `flutter pub get`

## Proposed Approach

**Preferred**: Raise `flutter:` to `>=3.47.0` in all 8 publishable packages
(they share one floor by convention). Leave `sdk:` floors untouched — the
`flutter:` line is the enforceable floor for plugin consumers, and every
Flutter >=3.47.0 ships Dart >=3.13.0 which satisfies the existing
`sdk: >=3.8.0 <4.0.0`; a standalone-Dart resolution of a Flutter plugin is not
a real consumer. Update the umbrella's `zuraffa_session` constraint to
`>=1.2.1 <8.0.0`: the floor 1.2.1 is the first version on the zuraffa-7 line
(nocterm-free graph, deterministic close of #393 section 1), the open top
admits the fleet-realigned 7.3.0, and both ends carry identical session code
(widening philosophy already documented on that line). Align the dev-only
module package's floors and lints with the fleet. Add a `resolve-floor` CI job
that pins `flutter-version: 3.47.0`, hand-writes a minimal consumer probe with
`equatable: ^3.0.0` plus path dependencies on all 8 checkout packages, runs
`flutter pub get`, asserts the checkout resolved from `path` (build-macos's
awk pattern) and that `zuraffa` resolved to a 7.x (nocterm-free) version, and
documents that the pin must move together with the pubspec floor.

**Alternatives**:
- `zuraffa_session: ^7.3.0` — maximally current, but breaks consumers that pin
  `zuraffa_session: ^1.x` themselves; the widened range is strictly more
  compatible with identical resolution today.
- Raise `sdk:` to `>=3.13.0` too — more "honest" but churns 9 files for no
  enforceable benefit (flutter line already gates), and risks contradicting
  the fleet if a future Flutter 3.47.x patch shipped a lower Dart.
- Only fix the umbrella, leave other packages at 3.38.6 — the fleet shares one
  floor by convention (AGENTS.md documents a single floor for all packages);
  a split floor would be a new inconsistency.

**Paths likely to change**: as listed under Affected Paths.

**Verification to run**:
- Per package (`cd <pkg>`): `flutter analyze` + `flutter test --concurrency=2`
  (web: `--platform chrome`) — umbrella, platform_interface, android, ios,
  macos, windows, linux, web, module.
- `bash scripts/grep_gate.sh` — core↔module split must stay green.
- Minimal-consumer probe: create `.consumer-probe/` in the checkout with the
  issue's repro pubspec, `flutter pub get`, assert path resolution + zuraffa
  7.3.0 + equatable 3.0.0; remove the probe afterwards.
- `./scripts/local_ci.sh --plan` to confirm the new job parses into the local
  gate; optionally run the new job id.

## Risks & Considerations

- **Intended breakage**: consumers on Flutter 3.38–3.44 lose resolution —
  that is the point (they were broken anyway with a worse message; the issue
  author asked for it).
- **zuraffa_session floor excludes the zuraffa-6 line**: consumers pinning
  zuraffa 6.x lose resolution. Intended — zuraffa 6.x ships nocterm and the
  equatable-^2 conflict; the maintainer's fleet move (nocterm removed in
  7.3.0) makes 7.x the supported line.
- **Probe drift**: the CI pin (3.47.0) and the pubspec floor can drift apart;
  mitigated by a cross-reference comment in both places and by the job name
  carrying the version.
- **local_ci fidelity**: the pinned `flutter-version` is advisory locally
  (local 3.47.7 ≠ CI 3.47.0 — yellow warning, not a failure); CI is the
  authoritative 3.47.0 check.
- No Dart or native source changes → no behavior/API/migration risk beyond
  the floors.

## Open Questions

- None. The issue author's request is explicit and the maintainer directive in
  this session covers the dependency-refresh breadth ("overall dependency
  updates"): remaining direct-dependency ranges already admit the latest
  published versions under their existing carets, and per dart.dev guidance
  floors stay at the oldest tested version — only the two motivated changes
  (flutter floor, zuraffa_session realignment) plus the dev-only lints
  alignment are made.
