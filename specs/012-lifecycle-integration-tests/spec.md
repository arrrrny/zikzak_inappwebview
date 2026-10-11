# Feature Specification: WebView Lifecycle Integration Tests

**Feature Branch**: `012-lifecycle-integration-tests`

**Created**: 2026-08-22

**Status**: Draft

**Input**: GitHub issue #228 (sub-issue of #161, Epic: Architecture & tech debt reduction). The user requests a suite of integration tests that catch lifecycle regressions in the plugin across platforms. Concretely: (1) a hot-restart test — launch, navigate, hot restart, verify the WebView is still functional; (2) an activity-recreation test — rotate the device / move the app to background and back to foreground, and verify no `MissingPluginException` is raised; (3) a `FlutterFragment` test — verify plugin (method-channel) registration completes without requiring an `Activity`; (4) a Windows `Program Files` scenario — verify WebView2 initialises and navigates gracefully when its install/user-data directory is read-only. All platform-channel tests must be written against the current zorphy-based platform interface (post-#226 migration).

## User Scenarios & Testing

### User Story 1 - Hot restart keeps the WebView functional (Priority: P1)

A Flutter developer runs the app in debug mode, opens an `InAppWebView`, navigates to a page, and performs a hot restart from the tooling. After the restart, the WebView must still load pages and respond to controller calls (e.g., `evaluateJavascript`, `getUrl`). This guards against regressions where the platform channel / native view is torn down but not re-bound after a restart.

**Why this priority**: Hot restart is the single most-used debug iteration path in Flutter. A broken channel after restart silently breaks every consumer app's core flow, and the issue explicitly lists it first. It is the highest-value regression net.

**Independent Test**: Launch the app, wait for the WebView to finish loading a known URL, trigger a hot restart through the test harness, wait for re-init, then assert `controller.getUrl()` returns the expected URL and `evaluateJavascript('1+1')` returns `2`. No other scenario is required to validate this.

**Acceptance Scenarios**:

1. **Given** an `InAppWebView` that has loaded `https://example.com`, **When** a hot restart is performed and the app re-initialises, **Then** a subsequent `controller.getUrl()` returns a non-null, valid URL without throwing.
2. **Given** the WebView after a hot restart, **When** `controller.evaluateJavascript(source: '1 + 1')` is invoked, **Then** the call resolves to `2` (or its string form) rather than failing with a channel error.
3. **Given** a hot restart that occurs while the page is still loading, **When** the load completes after restart, **Then** the progress/`onLoadStop` callback fires exactly once for the final load with the correct URL.

---

### User Story 2 - Activity recreation without MissingPluginException (Priority: P2)

On Android, the host `Activity` can be destroyed and recreated by the framework during a configuration change (screen rotation) or when the app is sent to the background and returned to the foreground. The plugin must survive these transitions and keep its method channels registered so that controller calls do not throw `MissingPluginException`.

**Why this priority**: `MissingPluginException` after rotation/backgrounding is a classic, high-visibility crash class for WebView plugins and directly matches a task in the issue. It is critical for production robustness but is platform-specific to Android, so it ranks just below the universal hot-restart path.

**Independent Test**: On an Android emulator/device, open the WebView, then (a) rotate the device and (b) send the app to background and back. After each transition, assert that a controller call such as `getUrl()` or `evaluateJavascript` succeeds and that the test process logs/throws no `MissingPluginException`.

**Acceptance Scenarios**:

1. **Given** an `InAppWebView` is displayed, **When** the device orientation changes (configuration change) causing `Activity` recreation, **Then** no `MissingPluginException` is thrown and `controller.getUrl()` still resolves.
2. **Given** the WebView is visible, **When** the app transitions to background and then back to foreground, **Then** the plugin's method channels remain registered and controller calls succeed.
3. **Given** the WebView during an Activity recreation, **When** the native view is re-attached, **Then** the WebView content is preserved/restored rather than left blank or detached.

---

### User Story 3 - FlutterFragment registration without an Activity (Priority: P3)

Some embedding patterns (notably `FlutterFragment`) register the plugin before a host `Activity` is attached, or operate in contexts where `Activity` may legitimately be null. The plugin must finish its registration and allow controller creation / lifecycle binding without throwing because `Activity` is null.

**Why this priority**: This is an embedding-compatibility concern that affects a narrower set of integrators (manual `FlutterFragment` hosts), and the failure mode (registration error) is less likely to reach typical end users than the P1/P2 paths. It nonetheless prevents hard-to-diagnose crashes for those integrations, so it is included as P3.

**Independent Test**: Inflate a `FlutterFragment` (or equivalent test harness) in a state where no `Activity` is attached, register the plugin programmatically, and assert that registration completes and that creating/binding a WebView controller does not throw a null-`Activity` exception.

**Acceptance Scenarios**:

1. **Given** a `FlutterFragment` with no attached `Activity`, **When** the plugin registers its method channels, **Then** registration completes without throwing.
2. **Given** the plugin is registered without an `Activity`, **When** a WebView controller is created and later an `Activity` is attached, **Then** lifecycle callbacks bind successfully without a prior null-`Activity` failure.
3. **Given** the `FlutterFragment` is detached before an `Activity` becomes available, **When** plugin teardown runs, **Then** no exception is raised from cleanup code paths that reference the host.

---

### User Story 4 - Windows WebView2 handles read-only Program Files directories (Priority: P3)

On Windows, WebView2 writes runtime data (user-data folder, cache) under its install/user-data directory. When the app is installed under a read-only location such as `Program Files`, WebView2 must initialise and navigate gracefully instead of crashing or throwing an unhandled exception when it cannot write to that default path.

**Why this priority**: This is a Windows-desktop-specific edge condition that affects only installed/packaged desktop apps, not the common development run. It is important for shipped Windows builds but ranks lower than the universally-exercised hot-restart and Android lifecycle paths.

**Independent Test**: Run the Windows target with WebView2's user-data/cache directory pointed at a read-only path (simulating `Program Files`). Assert that WebView2 initialisation completes and a navigation to a local/remote URL succeeds without an unhandled exception.

**Acceptance Scenarios**:

1. **Given** WebView2 is configured with a read-only user-data directory, **When** the WebView is initialised, **Then** initialisation completes without throwing an unhandled exception.
2. **Given** the WebView initialised against a read-only directory, **When** a navigation to a valid URL is requested, **Then** the navigation completes (or fails gracefully with a catchable error) rather than crashing the process.
3. **Given** WebView2 cannot write to the default location, **When** a fallback writable directory is available, **Then** the plugin selects it and the WebView remains functional.

---

### Edge Cases

- **Hot restart mid-navigation**: The restart fires while a page is still loading; the test must still wait for and verify the post-restart load, not assume the pre-restart load finished.
- **Activity recreated while the WebView is mid-load**: The native view is detached/re-attached mid-request; the plugin must not orphan the channel or lose the in-flight load.
- **FlutterFragment attached/detached before an Activity exists**: Registration and early lifecycle calls must tolerate a null `Activity` and only act once one is attached.
- **WebView2 with no write permission and no fallback user-data folder**: The plugin must surface a catchable error rather than abort the process.
- **Multiple WebViews during recreation**: Several controllers exist simultaneously; channel re-binding must be per-instance, not global, so one view's recreation does not clobber another's channel.
- **Cold start vs. warm restart overlap**: Tests must distinguish a true hot restart (VM reuse) from a full restart to avoid false negatives.

## Requirements

### Functional Requirements

- **FR-001**: The system MUST include an integration test that launches an `InAppWebView`, navigates to a URL, performs a hot restart, and verifies the WebView remains functional (channel round-trip succeeds).
- **FR-002**: The system MUST include an Android integration test that exercises `Activity` recreation via both configuration change (rotation) and background→foreground transition, asserting no `MissingPluginException` is thrown.
- **FR-003**: The system MUST include a test verifying plugin (method-channel) registration completes successfully within a `FlutterFragment` context that provides no `Activity`.
- **FR-004**: The system MUST include a Windows test that initialises WebView2 with a read-only install/user-data directory and verifies it handles the restriction gracefully (no unhandled exception, navigation still possible).
- **FR-005**: All platform-channel interactions in these tests MUST use the current zorphy-based platform interface introduced by the #226 migration, not the legacy plugin API.
- **FR-006**: The hot-restart test MUST re-establish the platform-channel connection after restart and confirm a controller round-trip (e.g., `evaluateJavascript` or `getUrl`) succeeds post-restart.
- **FR-007**: The activity-recreation tests MUST cover both orientation/configuration-change recreation and background→foreground process lifecycle recreation.
- **FR-008**: The `FlutterFragment` test MUST register the plugin programmatically without a host `Activity` and verify that controller creation / lifecycle binding does not fail due to a null `Activity`.
- **FR-009**: The Windows WebView2 test MUST simulate a restricted-write directory (e.g., a `Program Files`-like read-only path) and assert the WebView still initialises and can navigate.
- **FR-010**: Each lifecycle test MUST be runnable through the standard Flutter `integration_test` (or platform-equivalent) harness and produce a deterministic pass/fail result suitable for CI.

### Key Entities

- **InAppWebView / InAppWebViewController**: The Flutter widget and its controller used by the tests to drive navigation and channel round-trips.
- **PlatformInterface (zorphy-based)**: The post-#226 platform abstraction layer that the tests must use for all platform-channel calls.
- **FlutterFragment (Android)**: The Android embedding fragment used to test plugin registration without a guaranteed `Activity`.
- **WebView2 (Windows)**: The Windows WebView runtime whose user-data/cache directory handling is exercised under read-only conditions.
- **Method / Platform Channels**: The native bridge whose registration and re-binding across lifecycle transitions is the core subject of these regression tests.

## Success Criteria

### Measurable Outcomes

- **SC-001**: The hot-restart integration test passes — a controller round-trip (`evaluateJavascript` / `getUrl`) succeeds after a hot restart.
- **SC-002**: The activity-recreation test passes with zero `MissingPluginException` occurrences across both rotation and background→foreground cycles.
- **SC-003**: The `FlutterFragment` registration test passes without an `Activity` present and without null-`Activity` exceptions.
- **SC-004**: The Windows WebView2 test passes under a simulated read-only install directory, with successful initialisation and navigation.
- **SC-005**: All four lifecycle test suites are reproducible and wired into per-platform CI so regressions are caught automatically.
- **SC-006**: The tests demonstrably exercise the zorphy-based platform interface, confirming no regression from the #226 migration.

## Assumptions

- Integration tests run on the appropriate targets: Android emulator/device for mobile scenarios, Windows host for the WebView2 scenario, and the existing `integration_test` harness.
- The zorphy-based platform interface from #226 is the active API at implementation time and is the contract the tests build against.
- A hot restart can be triggered programmatically within the test harness (e.g., via the Flutter driver or a test hook) rather than only through IDE tooling.
- The Windows read-only scenario can be emulated by pointing the WebView2 user-data/cache directory to a path with write access denied (mirroring a `Program Files` install).
- A CI environment with the necessary per-platform runners (emulator, Windows agent) is available to execute the suites.
- The four scenarios are treated as regression nets; they assert current correct behaviour rather than introducing new product features.
