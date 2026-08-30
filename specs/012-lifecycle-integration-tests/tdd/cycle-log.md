# Cycle Log: WebView Lifecycle Integration Tests

Append only. Newest last. Every entry's `red` block is the evidence that the test existed and failed before the implementation.

## Baseline

- suite: `flutter test` (in `zikzak_inappwebview`) -> 95 passed, 2 files fail to compile (headless_dispose_test.dart, webview_sessions_test.dart)
- commit: `abfa842e`
- recorded: cycle 0, before any change

**Note on baseline**: The umbrella suite is RED at detection time. The two failing files are pre-existing and unrelated to this feature:
1. `test/headless_dispose_test.dart` — references a `disposed` getter on `HeadlessInAppWebView` that no longer exists (interface drift from standardize-dispose-patterns work)
2. `test/webview_sessions_test.dart` — imports `package:zikzak_session`, which is not declared in `pubspec.yaml`

The integration test suite in `example/integration_test/` runs separately and is not part of the umbrella package's `flutter test` output.

## Cycle 1 — Acceptance validation A1–A9 on iOS Simulator

- behavior: A1–A9 (hot restart getUrl/eval, activity recreation MissingPluginException-free, plugin-without-Activity)
- test file: `example/integration_test/lifecycle_test.dart` (7 `testWidgets`; Windows A10–A12 are `skip: true`)
- nature: acceptance-characterization. Lifecycle behavior already exists; this run validates it on the only reliably-working integration platform (iOS Simulator). The test was written (PENDING) and is observed GREEN here — there is **no red phase** because no source change was required; the feature already satisfies the criteria. Recorded honestly, not as a red-green code cycle.
- red command: n/a — acceptance validation of existing behavior.
- green command: `cd zikzak_inappwebview/example && flutter test integration_test/lifecycle_test.dart -d 61B4A66B-9B6C-4270-BFC8-2DC75D890A82`
- green output (decisive):
  ```
  00:26 +6 ~1: All tests passed!
  ```
  (Xcode build 120.3s; 6 tests passed, 1 skipped Windows.)
- refactor: none.
- notes: A4–A9 are Android-centric (Activity recreation, FlutterFragment); on iOS they are exercised through the `WidgetsBinding` lifecycle simulation in the test, not a real Android Activity. True Android validation still requires a running emulator/device — that is the next step. A10–A12 remain PENDING (Windows host required, `skip: true`).

## Cycle 2 — Acceptance validation A1–A9 on Android emulator (API 37, Pixel_10_Pro)

- behavior: A1–A9 (hot restart getUrl/eval, activity recreation MissingPluginException-free, plugin-without-Activity)
- test file: `example/integration_test/lifecycle_test.dart` (7 `testWidgets`; Windows A10–A12 are `skip: true`)
- nature: acceptance-characterization on a real Android target. Lifecycle behavior already exists; this run validates it on the Android emulator (real `AndroidView` / Activity lifecycle, not the iOS `WidgetsBinding` simulation). Observed GREEN — **no red phase** because no source change was required.
- red command: n/a — acceptance validation of existing behavior.
- green command: `cd zikzak_inappwebview/example && flutter test integration_test/lifecycle_test.dart -d emulator-5554`
- green output (decisive):
  ```
  00:37 +6 ~1: All tests passed!
  ```
  (Gradle `assembleDebug` 128.2s; APK install 11.5s; 6 tests passed, 1 skipped Windows.)
- refactor: none.
- notes: The API-37 emulator's `package` service crashes on the 95 MB streamed `adb install` of the debug APK (`Broken pipe (32)` / `Can't find service: package`), so Flutter's default install failed every time. Fix: a temporary, reversible wrapper at `~/Library/Android/sdk/platform-tools/adb` (real binary backed up to `adb.orig`) that injects `--no-streaming` into Flutter's `adb install` calls. With it, the install succeeded and all 6 tests passed. The `pixel_api_26` AVD would not boot online on this Intel-2019/swiftshader host, so API-37 is the working Android floor here. Wrapper restored to `adb.orig` after testing.

## Cycle 3 — Acceptance validation A1–A9 on physical iPhone (ARRRRNY, iOS 18.7.1)

- behavior: A1–A9 (same matrix as above, exercised on real iOS hardware)
- test file: `example/integration_test/lifecycle_test.dart` (7 `testWidgets`; Windows A10–A12 are `skip: true`)
- nature: acceptance-characterization on a physical iOS device (wired). Confirms the iOS-simulator result holds on real hardware. Observed GREEN — **no red phase**.
- red command: n/a — acceptance validation of existing behavior.
- green command: `cd zikzak_inappwebview/example && flutter test integration_test/lifecycle_test.dart -d 00008101-00115C381E10801E`
- green output (decisive):
  ```
  00:04 +6 ~1: All tests passed!
  ```
  (Xcode build 94.6s; install+launch 22.6s; 6 tests passed, 1 skipped Windows.)
- refactor: none.
- notes: Real-device confirmation that the lifecycle behaviors survive on physical iOS (not just the simulator). Together with Cycle 1 (simulator) and Cycle 2 (Android emulator), A1–A9 are validated on three real targets. A10–A12 remain PENDING (Windows host required, `skip: true`).

## Cycle 4 — Minimum-Android-floor validation A1–A9 on API 26 (WebView-capable gapi image)

- behavior: A1–A9 (same matrix), run on the **decided minimum API 26** to prove the floor holds.
- test file: `example/integration_test/lifecycle_test.dart` (7 `testWidgets`; Windows A10–A12 are `skip: true`).
- nature: acceptance-characterization on the minimum supported Android level. A bare `pixel_api_26` system image has **no WebView provider** and fails with `MissingWebViewPackageException: No WebView installed` (`/tmp/a012_api26b.log`). The `pixel_api_26_gapi` image (Google APIs + WebView: `com.google.android.webview`, `org.chromium.webview_shell` present) boots on this Intel-2019/swiftshader host and runs the WebView. Observed GREEN — **no red phase** (no source change required).
- red command: n/a — acceptance validation of existing behavior on the floor.
- green command: `cd zikzak_inappwebview/example && flutter test integration_test/lifecycle_test.dart -d emulator-5554` (AVD `pixel_api_26_gapi`, API 26, WebView installed).
- green output (decisive):
  ```
  00:10 +6 ~1: All tests passed!
  ```
  (Gradle `assembleDebug` 45.3s; APK install 13.7s; 6 tests passed, 1 skipped Windows.)
- refactor: none.
- notes: This is the authoritative minimum-floor evidence: API 26 with a WebView-capable system image passes the full lifecycle matrix. The project already declares `minSdk = 26` in the example app, consistent with this result. API 24 was evaluated and abandoned — only a 32-bit Play-Store image exists (no x86_64), so it cannot run on this host. A10–A12 remain PENDING (Windows host required, `skip: true`).