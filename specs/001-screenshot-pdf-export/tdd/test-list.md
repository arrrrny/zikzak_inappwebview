---
feature: 001-screenshot-pdf-export
loop: outside-in
profile: .specify/memory/tdd-profile.md
spec_criteria: 12
planned_at: f349d421
updated_at: f349d421
suite_baseline: green
---

# Test List: Screenshot and PDF Export

Trace ids used below:

- `US<n>-AS<m>` — acceptance scenario *m* of User Story *n* in `spec.md`
  (spec.md numbers its scenarios per story rather than with global `AC-` ids).
- `FR-0nn`, `SC-0nn` — functional requirement / success criterion ids in `spec.md`.

## Outer loop: acceptance behaviors

One per acceptance criterion in `spec.md`. The real entry point reachable from
`flutter_test` is the platform controller's public Dart API over a mocked
`MethodChannel` (`MethodChannel(...).setMockMethodCallHandler`, per the profile's
platform-package convention). Behaviors whose observable result is the *content*
of natively rendered bytes (real PNG/JPEG pixels, real A4 page geometry) are
`BLOCKED`: the profile records `acceptance: null` and the only e2e layer
(`zikzak_inappwebview/example/integration_test`) needs a device/emulator.

| id  | behavior                                                                                              | traces           | kind    | state                                                       | test |
| --- | ----------------------------------------------------------------------------------------------------- | ---------------- | ------- | ----------------------------------------------------------- | ---- |
| A1  | Calling `takeScreenshot()` on a macOS controller yields the non-null `Uint8List` the platform returned | US1-AS1, FR-001  | example | PENDING                                                     |      |
| A2  | A macOS `takeScreenshot(ScreenshotConfiguration(JPEG, quality 80))` reaches the platform with `compressFormat: jpeg` and `quality: 80` and yields its bytes | US1-AS2, FR-002 | example | PENDING |      |
| A3  | A macOS `takeScreenshot` with a source rect reaches the platform with that rect and yields only the cropped bytes | US1-AS3, FR-002 | example | PENDING |      |
| A4  | The rendered macOS screenshot pixels visually match the loaded page                                   | US1-AS1, SC-001  | example | BLOCKED — needs a real macOS host; profile `acceptance: null` |      |
| A5  | Calling `createPdf()` on an Android controller yields the non-null `Uint8List` the platform returned   | US2-AS1, FR-003, FR-005 | example | PENDING                                            |      |
| A6  | An Android `createPdf(PDFConfiguration(A4))` reaches the platform with the A4 page size and yields its bytes | US2-AS2, FR-004 | example | PENDING                                              |      |
| A7  | The generated Android PDF has A4 page dimensions and contains all multi-page content                    | US2-AS2, SC-002  | example | BLOCKED — needs an Android device/emulator; profile `acceptance: null` |      |
| A8  | Calling `createPdf()` on a Linux controller yields the non-null `Uint8List` the platform returned      | US3-AS1, FR-003, FR-007 | example | PENDING                                            |      |
| A9  | A Linux `createPdf(PDFConfiguration(...))` reaches the platform with the serialized configuration and yields its bytes | US3-AS2, FR-004 | example | PENDING                              |      |
| A10 | Calling `takeScreenshot()` on a Linux controller yields the non-null `Uint8List` the platform returned | US4-AS1, FR-008  | example | PENDING                                                     |      |
| A11 | A Linux `takeScreenshot(ScreenshotConfiguration(...))` reaches the platform with format, quality and rect and yields its bytes | US4-AS2, FR-002 | example | PENDING                          |      |
| A12 | Calling `takeScreenshot()` on an iOS controller with no configuration still yields the platform's bytes and sends a `null` configuration argument | US5-AS1, SC-004 | example | PENDING                     |      |
| A13 | Calling `createPdf()` on an iOS controller yields the non-null `Uint8List` the platform returned       | US5-AS2, SC-004  | example | PENDING                                                     |      |
| A14 | An iOS `createPdf()` rejected by the native side below the minimum OS version surfaces the platform's error message rather than a bare crash | US5-AS3 | example | PENDING                    |      |
| A15 | `takeScreenshot()` and `createPdf()` each yield `null` on Windows and on Web instead of throwing `UnimplementedError` | FR-009, SC-005 | example | PENDING                                |      |
| A16 | `takeScreenshot()` and `createPdf()` each yield `null` when the platform reports no loaded content, without throwing | FR-010 | example | PENDING                                    |      |
| A17 | The deprecated `IOSInAppWebViewController` facade forwards both `createPdf` and `takeScreenshot` to the underlying controller and returns its bytes | FR-011 | example | BLOCKED — umbrella `zikzak_inappwebview` suite is blocked (zuraffa pub-cache corruption — run `flutter pub cache repair`) |      |

## Inner loop: unit behaviors

Grouped by the component from `plan.md` that owns them. `plan.md` lists the
configuration types under `lib/src/types/`; their real location in this tree is
`lib/src/domain/entities/{screenshot,pdf}_configuration/` — paths below are the
real ones.

The profile records no property or mutation library, so every invariant
(round-trip, idempotence, ordering) is `kind: example`, sampled at its boundaries.

### `zikzak_inappwebview_macos/lib/src/in_app_webview/in_app_webview_controller.dart`

| id  | behavior                                                                                     | traces          | kind    | state   | test |
| --- | -------------------------------------------------------------------------------------------- | --------------- | ------- | ------- | ---- |
| U1  | Invokes the `takeScreenshot` channel method exactly once per call                            | US1-AS1, FR-001 | example | PENDING |      |
| U2  | Sends `screenshotConfiguration` as `null` when no configuration is given                     | FR-002          | example | PENDING |      |
| U3  | Sends the configuration's `toMap()` when a configuration is given                            | FR-002          | example | PENDING |      |
| U4  | Returns `null` when the channel returns `null`                                               | FR-010          | example | PENDING |      |
| U5  | Returns `null` rather than rethrowing when the channel raises a `PlatformException`           | FR-010          | example | PENDING |      |
| U6  | Existing `createPdf` behavior on macOS is unchanged by the screenshot addition               | SC-004          | example | PENDING |      |

### `zikzak_inappwebview_android/lib/src/in_app_webview/in_app_webview_controller.dart`

| id  | behavior                                                                                          | traces          | kind             | state    | test |
| --- | ------------------------------------------------------------------------------------------------- | --------------- | ---------------- | -------- | ---- |
| U7  | Current disabled `createPdf` returns `null` without touching the channel (pre-change behavior)     | FR-005          | characterization | BASELINE |      |
| U8  | Invokes the `createPdf` channel method exactly once per call                                      | US2-AS1, FR-003 | example          | PENDING  |      |
| U9  | Sends `pdfConfiguration` as `null` when no configuration is given                                  | FR-004          | example          | PENDING  |      |
| U10 | Sends the configuration's `toMap()` when a configuration is given                                  | US2-AS2, FR-004 | example          | PENDING  |      |
| U11 | Returns `null` when the channel returns `null`                                                     | FR-010          | example          | PENDING  |      |
| U12 | Returns `null` rather than rethrowing when the channel raises a `PlatformException`                | FR-010          | example          | PENDING  |      |
| U13 | Existing `takeScreenshot` behavior on Android is unchanged by the PDF change                       | SC-004          | example          | PENDING  |      |

### `zikzak_inappwebview_linux/lib/src/in_app_webview/in_app_webview_controller.dart`

| id  | behavior                                                                                            | traces          | kind             | state    | test |
| --- | --------------------------------------------------------------------------------------------------- | --------------- | ---------------- | -------- | ---- |
| U14 | Current controller surface for `createPdf`/`takeScreenshot` before wiring (pre-change behavior)     | FR-007, FR-008  | characterization | BASELINE |      |
| U15 | Invokes the `createPdf` channel method exactly once per call                                        | US3-AS1, FR-007 | example          | PENDING  |      |
| U16 | Sends the PDF configuration's `toMap()`, or `null` when absent                                      | US3-AS2, FR-004 | example          | PENDING  |      |
| U17 | Invokes the `takeScreenshot` channel method exactly once per call                                   | US4-AS1, FR-008 | example          | PENDING  |      |
| U18 | Sends the screenshot configuration's `toMap()`, or `null` when absent                               | US4-AS2, FR-002 | example          | PENDING  |      |
| U19 | Returns `null` when either channel call returns `null`                                              | FR-010          | example          | PENDING  |      |
| U20 | Returns `null` rather than rethrowing when either channel call raises a `PlatformException`          | FR-010          | example          | PENDING  |      |

### `zikzak_inappwebview_ios/lib/src/in_app_webview/in_app_webview_controller.dart`

| id  | behavior                                                                                     | traces          | kind    | state   | test |
| --- | -------------------------------------------------------------------------------------------- | --------------- | ------- | ------- | ---- |
| U21 | `takeScreenshot` invokes the channel and returns its bytes unmodified                        | US5-AS1, SC-004 | example | PENDING |      |
| U22 | `createPdf` invokes the channel and returns its bytes unmodified                             | US5-AS2, SC-004 | example | PENDING |      |
| U23 | A `PlatformException` from `createPdf` (unsupported OS version) surfaces its message to the caller | US5-AS3   | example | PENDING |      |

### `zikzak_inappwebview_windows/lib/src/in_app_webview_windows_controller.dart`

| id  | behavior                                                       | traces          | kind    | state   | test |
| --- | -------------------------------------------------------------- | --------------- | ------- | ------- | ---- |
| U24 | `takeScreenshot` returns `null` and never throws               | FR-009, SC-005  | example | PENDING |      |
| U25 | `createPdf` returns `null` and never throws                    | FR-009, SC-005  | example | PENDING |      |

### `zikzak_inappwebview_web/lib/src/in_app_webview_web_controller.dart`

| id  | behavior                                                                              | traces         | kind             | state    | test |
| --- | ------------------------------------------------------------------------------------- | -------------- | ---------------- | -------- | ---- |
| U26 | Current web controller surface for `takeScreenshot`/`createPdf` (pre-change behavior)  | FR-009         | characterization | BASELINE |      |
| U27 | `takeScreenshot` returns `null` and never throws                                      | FR-009, SC-005 | example          | PENDING  |      |
| U28 | `createPdf` returns `null` and never throws                                           | FR-009, SC-005 | example          | PENDING  |      |

### `zikzak_inappwebview/lib/src/in_app_webview/apple/in_app_webview_controller.dart`

| id  | behavior                                                                       | traces | kind             | state    | test |
| --- | ------------------------------------------------------------------------------ | ------ | ---------------- | -------- | ---- |
| U29 | Current `createPdf` forwarding of the deprecated Apple facade (pre-change)      | FR-011 | characterization | BASELINE — umbrella suite blocked (zuraffa pub-cache corruption) |      |
| U30 | `takeScreenshot` forwards to the wrapped controller and returns its bytes       | FR-011 | example          | BLOCKED — umbrella suite blocked (zuraffa pub-cache corruption)  |      |

### `zikzak_inappwebview_platform_interface/lib/src/domain/entities/screenshot_configuration/screenshot_configuration.dart`

| id  | behavior                                                                                        | traces | kind    | state   | test |
| --- | ----------------------------------------------------------------------------------------------- | ------ | ------- | ------- | ---- |
| U31 | `toMap()` emits every field the platforms read: `compressFormat`, `quality`, `rect`, `snapshotWidth`, `afterScreenUpdates` | FR-002 | example | PENDING |      |
| U32 | A configuration survives a `toMap()` → `fromMap()` round trip unchanged, sampled at quality `0` and `100` | FR-002 | example | PENDING |      |
| U33 | `quality: 0` is preserved rather than dropped as a falsy value (lower boundary)                  | FR-002 | example | PENDING |      |
| U34 | `quality: 100` is preserved (upper boundary)                                                     | FR-002 | example | PENDING |      |
| U35 | A `null` rect is emitted as an absent/`null` map entry, not as a zero rect                       | FR-002 | example | PENDING |      |

### `zikzak_inappwebview_platform_interface/lib/src/domain/entities/pdf_configuration/pdf_configuration.dart`

| id  | behavior                                                                     | traces | kind    | state   | test |
| --- | ---------------------------------------------------------------------------- | ------ | ------- | ------- | ---- |
| U36 | `toMap()` emits `rect`, `pageSize`, `orientation` and `margins`              | FR-004 | example | PENDING |      |
| U37 | A configuration survives a `toMap()` → `fromMap()` round trip unchanged      | FR-004 | example | PENDING |      |
| U38 | Zero margins are preserved rather than dropped (lower boundary)              | FR-004 | example | PENDING |      |
| U39 | Landscape orientation serializes distinctly from portrait                     | FR-004 | example | PENDING |      |

### `zikzak_inappwebview_platform_interface/lib/src/in_app_webview/platform_inappwebview_controller.dart`

| id  | behavior                                                                                                     | traces         | kind    | state   | test |
| --- | ------------------------------------------------------------------------------------------------------------ | -------------- | ------- | ------- | ---- |
| U40 | The default `takeScreenshot`/`createPdf` implementations of the abstract controller are overridable and their signatures accept an optional configuration and return `Future<Uint8List?>` | FR-001, FR-003 | example | PENDING |      |

## Invariants and edge cases still to place

Each must become a numbered line above before the feature is done, or be dropped
with a reason. These come from `spec.md` "Edge Cases" and have no owning
component in `plan.md` yet:

- A call made before the page finished loading must resolve (with bytes or `null`), never hang.
- A view with zero width or height must yield `null` rather than an invalid buffer.
- A `HeadlessInAppWebView` must serve both calls through the same controller contract.
- A call still in flight when the webview is disposed must resolve or fail cleanly, not crash.
- Repeated `takeScreenshot` calls with identical configuration must be idempotent in configuration sent (byte equality is not asserted — rendering may differ).
- Content extending beyond the viewport: no requirement fixes the expected result; needs a spec decision before a test.
- Very large Android content (OOM risk) — no measurable requirement in `spec.md`.
- Transparent backgrounds in PNG output — no requirement in `spec.md`.

## Out of scope

- Windows and Web implementations of screenshot/PDF: `spec.md` requires only a graceful `null` (FR-009); no capture behavior is specified.
- Extending `ScreenshotConfiguration` / `PDFConfiguration` with new fields: excluded by the spec's Assumptions.
- Native-side unit tests (Swift, Java, C): no native test harness exists in this repo; the profile records only `flutter_test`.
- Performance thresholds SC-001 (<3s) and SC-002 (<5s): timing on real hardware, not reachable from `flutter_test`.
- Golden/visual comparison of captured images: `flutter_test` goldens exist but no baseline images and no device rendering.

## Verification commands

Copied verbatim from `.specify/memory/tdd-profile.md` at planning time. Run each
from that package's own directory (the stack's `cwd`).

Default stack — `zikzak_inappwebview_platform_interface` (cwd `zikzak_inappwebview_platform_interface`):

- Single test: `flutter test --plain-name "{name}"`
- Full suite: `flutter test`
- Coverage: `flutter test --coverage`

`zikzak_inappwebview_macos` (cwd `zikzak_inappwebview_macos`):

- Single test: `flutter test --plain-name "{name}"`
- Full suite: `flutter test`
- Coverage: `flutter test --coverage`

`zikzak_inappwebview_android` (cwd `zikzak_inappwebview_android`):

- Single test: `flutter test --plain-name "{name}"`
- Full suite: `flutter test`
- Coverage: `flutter test --coverage`

`zikzak_inappwebview_ios` (cwd `zikzak_inappwebview_ios`):

- Single test: `flutter test --plain-name "{name}"`
- Full suite: `flutter test`
- Coverage: `flutter test --coverage`

`zikzak_inappwebview_linux` (cwd `zikzak_inappwebview_linux`):

- Single test: `flutter test --plain-name "{name}"`
- Full suite: `flutter test`
- Coverage: `flutter test --coverage`

`zikzak_inappwebview_windows` (cwd `zikzak_inappwebview_windows`):

- Single test: `flutter test --plain-name "{name}"`
- Full suite: `flutter test`
- Coverage: `flutter test --coverage`

`zikzak_inappwebview_web` (cwd `zikzak_inappwebview_web`):

- Single test: `flutter test --plain-name "{name}"`
- Full suite: `flutter test`
- Coverage: `flutter test --coverage`

Mutation: `null` in every stack — no mutation library in any `pubspec.lock`. Test
strength is checked with a deliberate-mutant spot check instead, per the
constitution.

Notes:

- `suite_baseline: green` refers to the default stack (300 passed, ~82s). The
  macos/android/ios/linux/windows stacks are recorded green from smoke runs.
- `zikzak_inappwebview` (umbrella) and `zikzak_inappwebview_module` are
  **blocked**: zuraffa pub-cache corruption — run `flutter pub cache repair`.
  A17, U29 and U30 live in the umbrella package and stay blocked until then.
- `zikzak_inappwebview_web` has zero test files, so U26 is a characterization
  baseline written before U27/U28 change anything.
