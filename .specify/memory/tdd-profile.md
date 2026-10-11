---
detected_at: abfa842e # short SHA the profile was detected against
ecosystems: [flutter] # one entry per detected stack
default: flutter # which one the loop uses when a path is ambiguous
stacks:
  flutter:
    cwd: zikzak_inappwebview # working directory every command below runs in
    runner: flutter_test # package:test running under the Flutter toolchain
    single: 'flutter test {file} --plain-name "{name}"'
    file: 'flutter test {file}'
    suite: 'flutter test'
    watch: null # flutter test --watch is interactive; not verified here
    coverage: 'flutter test --coverage' # emits coverage/lcov.info in cwd
    mutation: null # mutation_test package absent (see notes)
    acceptance: 'cd zikzak_inappwebview/example && flutter test integration_test/{file} -d {device}'
    property: null # glados absent
    approval: null
    contract: null
    test_glob: "test/**/*_test.dart"
    exemplar: # one per test kind the stack can run
      unit: zikzak_inappwebview/test/disposable_pattern_test.dart
      entity: zikzak_inappwebview_platform_interface/test/types/console_message_test.dart
    helpers: [] # no shared test utilities; fakes are defined inline per file
verified: [single, file, suite, coverage, acceptance] # each was run successfully
suite_baseline: green # umbrella unit suite green (112 tests); the zikzak_session sessions test is now an ACTIVE passing exemplar, not quarantined
suite_seconds: 36 # observed wall time of the full suite (umbrella package)
---

# TDD Stack Profile

This is a Flutter/Dart monorepo (the `zikzak_inappwebview` plugin family). Every
package is an independent pub package and uses `flutter_test` (the `package:test`
runner under Flutter). There is **no CI gating command** (no `.github/workflows`,
Jenkinsfile, or Makefile test target), so the authoritative suite command is the
conventional `flutter test` run from the package directory.

## Command working directory (CRITICAL)

`flutter test` must run **inside the package that owns the test file**. Running it
from the repo root or the wrong package is the fastest way to get a false green,
because there is no root pubspec to resolve against. The `cwd` above is the
umbrella package (`zikzak_inappwebview`) — the default target because it holds the
richest behavior tests. When a feature's test lives in another package, `cd` into
**that** package and use the same command shapes.

Per-package test layout (counts are `*_test.dart` files under each `test/`):

| Package | cwd | test files | runner |
| --- | --- | --- | --- |
| zikzak_inappwebview | `zikzak_inappwebview` | 10 | flutter_test |
| zikzak_inappwebview_platform_interface | `zikzak_inappwebview_platform_interface` | 19 | flutter_test |
| zikzak_inappwebview_android | `zikzak_inappwebview_android` | 1 | flutter_test |
| zikzak_inappwebview_ios | `zikzak_inappwebview_ios` | 1 | flutter_test |
| zikzak_inappwebview_macos | `zikzak_inappwebview_macos` | 2 | flutter_test |
| zikzak_inappwebview_windows | `zikzak_inappwebview_windows` | 2 | flutter_test |
| zikzak_inappwebview_linux | `zikzak_inappwebview_linux` | 0 (no test dir) | n/a |
| zikzak_inappwebview_web | `zikzak_inappwebview_web` | 0 (no test dir) | n/a |

The same `flutter test {file} --plain-name "{name}"` single-test command was
verified in both `zikzak_inappwebview` and
`zikzak_inappwebview_platform_interface`, so it generalizes across packages.

## Conventions to match

- Test files are named `<name>_test.dart` and sit under the package's `test/`
  directory, mirroring the `src/` layout (e.g. `test/session_recipe/...`,
  `test/types/...`).
- Use `package:flutter_test/flutter_test.dart`. Assert with `expect(...)` and the
  matchers it provides (`isTrue`, `isFalse`, `isEmpty`, `hasLength`, `same`,
  `isNotNull`, `equals`, `throwsA`, with `reason:` for clarity).
- Structure with `group(...)` for the behavior and `test(...)` for each case. Name
  the test after the behavior; reference the spec's FR/US id in the group name
  when one applies (existing tests do this: `cookie mapping (FR-005)`).
- **Doubles:** there is no mocking library (no mockito). Use real objects, or
  small hand-written fakes defined inline in the test file — e.g.
  `_InMemoryPort implements SessionPort` in `webview_sessions_test.dart`, or
  `_ProbeDisposable implements Disposable` in `disposable_pattern_test.dart`.
  Prefer state-based assertions on observable results over interaction checks.
- **No shared test helpers exist.** Factories, matchers, and fixtures are NOT
  extracted into a common module; each test file builds its own minimal fixtures.
  The loop must not invent a helpers package — replicate the inline-fake style of
  the exemplars instead.
- Many existing tests are **compile-time probes** (they assert that an interface
  method/signature exists by referencing it, so a drift fails to compile). These
  are valid but they are not behavioral. New behavioral tests should call the real
  class and assert its observable output (the pattern in
  `webview_sessions_test.dart` — see the red-baseline note), not merely reference
  symbols.
- Never call `Date.now()`/`DateTime.now()` in production code under test without
  injecting a clock; if a behavior depends on time, pass it in (existing tests
  capture `DateTime.now().millisecondsSinceEpoch` into a local before use).

## Exemplars to imitate

- `zikzak_inappwebview/test/disposable_pattern_test.dart` — unit/group/expect
  shape, inline fake (`_ProbeDisposable`), no mocks. Passing.
- `zikzak_inappwebview_platform_interface/test/types/console_message_test.dart` —
  entity/fromJson regression style: construct the input map, call the parser,
  assert each field. Passing.
- Behavioral exemplar (ACTIVE, passing 13/13):
  `zikzak_inappwebview/test/webview_sessions_test.dart` — the desired behavioral
  style: real `FileSessionStore`, injected `SessionPort`/`evaluateJavascript`
  seams, asserting round-trip results and public-API behavior without a registered
  platform. Imitate this for new behavioral tests.

## Notes and constraints

- **Suite baseline is GREEN (112 tests in `zikzak_inappwebview`).** The historical
  reds were resolved:
  1. `test/headless_dispose_test.dart` — adapted to the current `Disposable` API;
     passes.
  2. `zikzak_session` is now a declared dependency (`zikzak_session: ^0.2.0` in
     `zikzak_inappwebview/pubspec.yaml`), so `lib/src/webview_sessions/` and
     `test/webview_sessions_test.dart` compile and pass (13/13). The test is
     ACTIVE at `test/webview_sessions_test.dart` — it is the behavioral exemplar,
     NOT quarantined; no `disabled/` copy exists.
  Full `flutter test` in `zikzak_inappwebview` is `All tests passed!` (112). A TDD
  loop can start on this green baseline.
- **Integration coverage is platform-partial.** The `integration_test/` layer runs
  and passes on the **iOS Simulator** (`38AC6290-6E3D-4FCC-BBD4-33F6DF0410D0`) for
  spec 002's `dismiss_dialogues_test.dart` (SC-002/003/004/005). It does **NOT**
  currently run on macOS desktop or Android emulator under `flutter test`:
  - macOS desktop (`-d macos`): `controller.loadData(...)` never completes — the
    native method-channel response is lost in the headless desktop WebView, so the
    call times out at 20s. Same for the pre-existing A2/A4 cases.
  - Android emulator (`emulator-5554`, API 37): the APK builds (`assembleDebug` ~20s)
    and `flutter test` reaches install, but `adb install` fails with
    `cmd: Can't find service: package` (emulator package-manager service
    unreachable), so the app never launches. Earlier the symptom was
    `onWebViewCreated` not firing; now it fails earlier, at install. Needs a working
    ADB bridge (restart emulator / `adb kill-server && adb start-server`) or a real
    device before the headless-WebView issue can even be reached.
  Both are environment/tooling limitations of driving `InAppWebView` headless, not
  feature regressions. Full mac/ios/android integration coverage is BLOCKED until a
  headless-WebView harness fix lands (tracked as T039/T040 in spec 002's tasks.md).
- The full umbrella suite takes ~36s, so a per-cycle full run is viable. Expect
  the first run in a package to spend most of that time on kernel/asset
  compilation; subsequent runs are faster.
- `flutter test --coverage` produced a 21 KB `coverage/lcov.info` (lcov format) in
  the cwd; `/speckit.tdd.verify` can use it for unmeasured-coverage checks.
- **No single-test command silently passes on a no-match.** Verified: a name that
  matches nothing prints `No tests ran. / No tests match "..."` and exits 79
  (non-zero). So red/green readings are trustworthy.
- `flutter test` here runs unit/widget tests on the headless test runner; no
  device is required for the `test/` suite. The acceptance/E2E layer DOES exist:
  `zikzak_inappwebview/example/integration_test/` holds three integration tests
  (`dismiss_dialogues_test.dart`, `get_html_test.dart`, `lifecycle_test.dart`). It
  runs on a device/simulator via
  `cd zikzak_inappwebview/example && flutter test integration_test/<file>.dart -d <device>`.
  **Observed platform status (2026-08-29):** the **iOS Simulator** (`38AC6290-...`,
  iPhone 16e) runs `dismiss_dialogues_test.dart` reliably — `00:20 +4: All tests
  passed!`. **macOS desktop (`-d macos`)** fails: `controller.loadData(...)` never
  completes (native method-channel response lost in the headless desktop WebView;
  times out at 20s). **Android emulator (`emulator-5554`, API 37)** was not successfully driven under
  `flutter test` -- the APK builds (`assembleDebug` ~20s) but `adb install` fails with
  `cmd: Can't find service: package`, so the app never launches (earlier the symptom
  was `onWebViewCreated` not firing; now it fails earlier at install). So of the three
  target platforms, only **iOS simulator** currently runs the integration suite
  end-to-end; macOS desktop and Android are blocked by tooling/environment limits
  (see the suite-baseline note above), NOT by
  feature code. Devices themselves are reachable: `flutter devices` shows the
  simulator, the Android emulator (`emulator-5554`), macOS desktop, Chrome, and a
  wireless iOS device. SDK at `~/Library/Android/sdk` (export `ANDROID_HOME`/
  `ANDROID_SDK_ROOT` if a shell needs it).
- `watch`, `mutation`, `property`, `approval`, and `contract` capabilities are
  **absent**: there is no mutation-testing or property-based library in the
  lockfile, no snapshot/approval tooling, and no contract-test setup. The audit
  (`/speckit.tdd.verify`) must fall back to trace checking and deliberate-mutant
  spot checks. Ecosystem defaults if the user later opts in: `mutation_test` for
  mutation, `glados` for property-based.

## Side effects observed during detection

Running `flutter pub get` (required before the first `flutter test`) modified
`zikzak_inappwebview/analysis_options.yaml` and
`zikzak_inappwebview/example/pubspec.lock`. These are normal pub side effects, not
part of this profile; revert them if you do not want them staged.
