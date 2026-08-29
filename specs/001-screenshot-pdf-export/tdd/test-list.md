---
feature: 001-screenshot-pdf-export
loop: outside-in
profile: .specify/memory/tdd-profile.md
spec_criteria: 12
planned_at: abfa842e
updated_at: 94c745ab
suite_baseline: green
---

# Test List: Screenshot and PDF Export

## Outer loop: acceptance behaviors

One per acceptance criterion in `spec.md`. Each stays red until the feature works end to end through its real entry point.

| id  | behavior                                                    | traces | kind    | state   | test                                        |
| --- | ----------------------------------------------------------- | ------ | ------- | ------- | ------------------------------------------- |
| A1  | macOS takeScreenshot returns non-null Uint8List with valid PNG image data | US1-AC1 | example | DONE    | zikzak_inappwebview/example/integration_test/macos_take_screenshot_test.dart › A1 macOS takeScreenshot returns non-null valid PNG image bytes |
| A2  | macOS takeScreenshot with JPEG format and quality 80 returns valid JPEG byte buffer | US1-AC2 | example | PENDING |                                             |
| A3  | macOS takeScreenshot with rect captures only specified portion of the view | US1-AC3 | example | PENDING |                                             |
| A4  | Android createPdf returns non-null Uint8List with valid PDF data | US2-AC1 | example | DONE    | zikzak_inappwebview/example/integration_test/android_create_pdf_test.dart › A4 Android createPdf returns non-null valid PDF bytes |
| A5  | Android createPdf with A4 page size produces PDF with A4 dimensions and all content across pages | US2-AC2 | example | DONE    | zikzak_inappwebview/example/integration_test/android_create_pdf_test.dart › A5 Android createPdf with A4 page size produces A4 pages with all content |
| A6  | Linux createPdf returns non-null Uint8List with valid PDF data | US3-AC1 | example | PENDING |                                             |
| A7  | Linux createPdf with PDFConfiguration respects configuration options in generated PDF | US3-AC2 | example | PENDING |                                             |
| A8  | Linux takeScreenshot returns non-null Uint8List with valid image data | US4-AC1 | example | PENDING |                                             |
| A9  | Linux takeScreenshot with ScreenshotConfiguration respects format, quality, and rect options | US4-AC2 | example | PENDING |                                             |
| A10 | iOS takeScreenshot with default configuration returns valid PNG image byte buffer | US5-AC1 | example | PENDING |                                             |
| A11 | iOS createPdf on iOS 14.0+ returns valid PDF byte buffer | US5-AC2 | example | PENDING |                                             |
| A12 | iOS createPdf on iOS 13.x (below minimum) fails gracefully with clear error message | US5-AC3 | example | PENDING |                                             |
| A13 | Android takeScreenshot returns non-null Uint8List with valid PNG image data | FR-001, US1-parity | example | DONE    | zikzak_inappwebview/example/integration_test/android_take_screenshot_test.dart › A13 Android takeScreenshot returns non-null valid PNG image bytes |
| A14 | Android takeScreenshot with rect captures only the specified portion of the view | FR-002 | example | DONE    | zikzak_inappwebview/example/integration_test/android_take_screenshot_test.dart › A14 Android takeScreenshot with rect captures only the specified portion of the view |

## Inner loop: unit behaviors

Grouped by the component from `plan.md` that owns them. Each line names one observable result.

### `zikzak_inappwebview_macos/macos/Classes/InAppWebView.swift`

| id  | behavior                                                  | traces     | kind     | state   | test                                   |
| --- | --------------------------------------------------------- | ---------- | -------- | ------- | -------------------------------------- |
| U1  | Native Swift handler for takeScreenshot method channel call uses WKWebView.takeSnapshot with WKSnapshotConfiguration | US1, FR-006 | example  | PENDING |                                        |
| U2  | Swift handler converts NSImage to PNG bytes when compressFormat is PNG | US1-AC1 | example  | PENDING |                                        |
| U3  | Swift handler converts NSImage to JPEG bytes with specified quality when compressFormat is JPEG | US1-AC2 | example  | PENDING |                                        |
| U4  | Swift handler applies rect cropping from ScreenshotConfiguration to WKSnapshotConfiguration | US1-AC3 | example  | PENDING |                                        |
| U5  | Swift handler returns null gracefully when web content is not loaded | FR-010 | example  | PENDING |                                        |

### `zikzak_inappwebview_macos/lib/src/in_app_webview/in_app_webview_controller.dart`

| id  | behavior                                                  | traces     | kind     | state   | test                                   |
| --- | --------------------------------------------------------- | ---------- | -------- | ------- | -------------------------------------- |
| U6  | Dart takeScreenshot override invokes method channel 'takeScreenshot' with screenshotConfiguration.toMap() | US1, FR-006 | example  | DONE    | test/screenshot_pdf_delegation_test.dart › U6 takeScreenshot delegates to platform with the screenshotConfiguration |                                        |
| U7  | Dart override returns the Uint8List from channel or null on failure | US1, FR-010 | example  | DONE    | test/screenshot_pdf_delegation_test.dart › U7 takeScreenshot returns the platform Uint8List or null |                                        |

### `zikzak_inappwebview_android/android/src/.../webview/in_app_webview/InAppWebView.java`

| id  | behavior                                                  | traces     | kind     | state   | test                                   |
| --- | --------------------------------------------------------- | ---------- | -------- | ------- | -------------------------------------- |
| U8  | Native Java createPdf uses WebView.createPrintDocumentAdapter and PdfDocument to generate PDF bytes | US2, FR-005 | example  | PENDING |                                        |
| U9  | Java createPdf applies page size from PDFConfiguration via PrintAttributes.MediaSize | US2-AC2 | example  | PENDING |                                        |
| U10 | Java createPdf applies orientation and margins from PDFConfiguration | US2-AC2 | example  | PENDING |                                        |
| U11 | Java createPdf writes PDF to temp file in cache dir, reads bytes, returns via channel, cleans up file | US2, FR-010 | example  | PENDING |                                        |
| U12 | Java createPdf returns null gracefully when web content is not loaded | FR-010 | example  | PENDING |                                        |

### `zikzak_inappwebview_android/android/src/.../webview/WebViewChannelDelegateMethods.java`

| id  | behavior                                                  | traces     | kind     | state   | test                                   |
| --- | --------------------------------------------------------- | ---------- | -------- | ------- | -------------------------------------- |
| U13 | WebViewChannelDelegateMethods enum includes CREATE_PDF entry | US2 | example  | PENDING |                                        |

### `zikzak_inappwebview_android/android/src/.../webview/InAppWebViewInterface.java`

| id  | behavior                                                  | traces     | kind     | state   | test                                   |
| --- | --------------------------------------------------------- | ---------- | -------- | ------- | -------------------------------------- |
| U14 | InAppWebViewInterface declares createPdf method signature | US2 | example  | PENDING |                                        |

### `zikzak_inappwebview_android/android/src/.../webview/WebViewChannelDelegate.java`

| id  | behavior                                                  | traces     | kind     | state   | test                                   |
| --- | --------------------------------------------------------- | ---------- | -------- | ------- | -------------------------------------- |
| U15 | WebViewChannelDelegate switch handles CREATE_PDF case and dispatches to webView.createPdf() | US2 | example  | PENDING |                                        |

### `zikzak_inappwebview_android/lib/src/in_app_webview/in_app_webview_controller.dart`

| id  | behavior                                                  | traces     | kind     | state   | test                                   |
| --- | --------------------------------------------------------- | ---------- | -------- | ------- | -------------------------------------- |
| U16 | Dart createPdf override invokes method channel 'createPdf' with pdfConfiguration.toMap() | US2, FR-005 | example  | DONE    | zikzak_inappwebview_android/test/in_app_webview/android_screenshot_pdf_delegation_test.dart › U16 createPdf delegates to channel with pdfConfiguration.toJson() |
| U17 | Dart override returns the Uint8List from channel or null on failure | US2, FR-010 | example  | DONE    | zikzak_inappwebview_android/test/in_app_webview/android_screenshot_pdf_delegation_test.dart › U17 createPdf returns the channel Uint8List or null |

### `zikzak_inappwebview_linux/linux/in_app_webview.cc`

| id  | behavior                                                  | traces     | kind     | state   | test                                   |
| --- | --------------------------------------------------------- | ---------- | -------- | ------- | -------------------------------------- |
| U18 | Native C createPdf handler (existing) parses pdfConfiguration arguments and uses WebKitPrintOperation | US3 | characterization | BASELINE |                                        |
| U19 | Native C createPdf applies pageSize, orientation, margins from PDFConfiguration via GtkPrintSettings | US3-AC2 | example  | PENDING |                                        |
| U20 | Native C takeScreenshot handler uses webkit_web_view_get_snapshot() to obtain cairo_surface_t | US4, FR-008 | example  | PENDING |                                        |
| U21 | Native C takeScreenshot converts cairo surface to PNG bytes when compressFormat is PNG | US4-AC1 | example  | PENDING |                                        |
| U22 | Native C takeScreenshot converts cairo surface to JPEG bytes with quality when compressFormat is JPEG | US4-AC2 | example  | PENDING |                                        |
| U23 | Native C takeScreenshot applies rect cropping from ScreenshotConfiguration | US4-AC2 | example  | PENDING |                                        |
| U24 | Native C handlers return null gracefully when web content is not loaded | FR-010 | example  | PENDING |                                        |

### `zikzak_inappwebview_linux/lib/src/in_app_webview/in_app_webview_controller.dart`

| id  | behavior                                                  | traces     | kind     | state   | test                                   |
| --- | --------------------------------------------------------- | ---------- | -------- | ------- | -------------------------------------- |
| U25 | Dart createPdf override invokes method channel 'createPdf' with pdfConfiguration.toMap() | US3 | example  | DONE    | zikzak_inappwebview_linux/test/in_app_webview/screenshot_pdf_delegation_test.dart › U25 createPdf delegates to channel with pdfConfiguration.toJson() |
| U26 | Dart takeScreenshot override invokes method channel 'takeScreenshot' with screenshotConfiguration.toMap() | US4 | example  | DONE    | zikzak_inappwebview_linux/test/in_app_webview/screenshot_pdf_delegation_test.dart › U26 takeScreenshot delegates to channel with screenshotConfiguration.toJson() |
| U27 | Dart overrides return Uint8List from channel or null on failure | US3, US4, FR-010 | example  | DONE    | zikzak_inappwebview_linux/test/in_app_webview/screenshot_pdf_delegation_test.dart › U27 overrides return the channel Uint8List or null |

### `zikzak_inappwebview_ios/ios/Classes/InAppWebView/InAppWebView.swift`

| id  | behavior                                                  | traces     | kind     | state   | test                                   |
| --- | --------------------------------------------------------- | ---------- | -------- | ------- | -------------------------------------- |
| U28 | iOS takeScreenshot implementation intact: uses WKWebView.takeSnapshot with WKSnapshotConfiguration | US5-AC1 | characterization | BASELINE |                                        |
| U29 | iOS createPdf implementation intact: uses WKWebView.createPDF with WKPDFConfiguration | US5-AC2 | characterization | BASELINE |                                        |
| U30 | iOS createPdf returns null on iOS 13.x (below @available iOS 14.0) | US5-AC3 | characterization | BASELINE |                                        |

### `zikzak_inappwebview_ios/lib/src/in_app_webview/in_app_webview_controller.dart`

| id  | behavior                                                  | traces     | kind     | state   | test                                   |
| --- | --------------------------------------------------------- | ---------- | -------- | ------- | -------------------------------------- |
| U31 | iOS takeScreenshot Dart override invokes method channel correctly (line 1910) | US5-AC1 | characterization | BASELINE |                                        |
| U32 | iOS createPdf Dart override invokes method channel correctly (line 2528) | US5-AC2 | characterization | BASELINE |                                        |

### `zikzak_inappwebview_ios/ios/Classes/InAppWebView/WebViewChannelDelegate.swift`

| id  | behavior                                                  | traces     | kind     | state   | test                                   |
| --- | --------------------------------------------------------- | ---------- | -------- | ------- | -------------------------------------- |
| U33 | WebViewChannelDelegate dispatches takeScreenshot and createPdf correctly | US5 | characterization | BASELINE |                                        |

### `zikzak_inappwebview/lib/src/in_app_webview/apple/in_app_webview_controller.dart`

| id  | behavior                                                  | traces     | kind     | state   | test                                   |
| --- | --------------------------------------------------------- | ---------- | -------- | ------- | -------------------------------------- |
| U34 | Deprecated IOSInAppWebViewController forwards takeScreenshot to platform controller | FR-011 | example  | DONE    | test/screenshot_pdf_delegation_test.dart › U34 deprecated IOSInAppWebViewController forwards takeScreenshot to its platform controller |                                        |
| U35 | Deprecated facade forwards createPdf correctly (existing) | FR-011 | characterization | BASELINE |                                        |

### `zikzak_inappwebview_platform_interface/lib/src/in_app_webview/platform_inappwebview_controller.dart`

| id  | behavior                                                  | traces     | kind     | state   | test                                   |
| --- | --------------------------------------------------------- | ---------- | -------- | ------- | -------------------------------------- |
| U36 | Platform interface declares takeScreenshot and createPdf abstract methods with correct signatures | FR-001, FR-003 | characterization | BASELINE |                                        |
| U37 | Platform interface @endtemplate doc comments reflect macOS screenshot and Android/Linux PDF availability | T024 | example  | PENDING |                                        |

### `zikzak_inappwebview_windows/lib/src/in_app_webview_windows_controller.dart`

| id  | behavior                                                  | traces     | kind     | state   | test                                   |
| --- | --------------------------------------------------------- | ---------- | -------- | ------- | -------------------------------------- |
| U38 | Windows takeScreenshot override returns null without throwing | FR-009 | example  | DONE    | zikzak_inappwebview_windows/test/screenshot_pdf_delegation_test.dart › U38 takeScreenshot returns null without throwing |

### `zikzak_inappwebview_web/lib/src/in_app_webview_web_controller.dart`

| id  | behavior                                                  | traces     | kind     | state   | test                                   |
| --- | --------------------------------------------------------- | ---------- | -------- | ------- | -------------------------------------- |
| U39 | Web takeScreenshot override returns null without throwing | FR-009 | example  | DONE    | zikzak_inappwebview_web/test/screenshot_pdf_delegation_test.dart › U39 takeScreenshot returns null without throwing |

### `zikzak_inappwebview_macos/macos/Classes/InAppWebView.swift` (createPdf verification)

| id  | behavior                                                  | traces     | kind     | state   | test                                   |
| --- | --------------------------------------------------------- | ---------- | -------- | ------- | -------------------------------------- |
| U40 | macOS createPdf implementation intact: uses WKWebView.createPDF with WKPDFConfiguration | T021 | characterization | BASELINE |                                        |

### `zikzak_inappwebview_android/lib/src/in_app_webview/in_app_webview_controller.dart` (takeScreenshot verification)

| id  | behavior                                                  | traces     | kind     | state   | test                                   |
| --- | --------------------------------------------------------- | ---------- | -------- | ------- | -------------------------------------- |
| U41 | Android takeScreenshot implementation intact: Dart override and Java handler exist and work | T022 | characterization | DONE    | zikzak_inappwebview_android/test/in_app_webview/android_screenshot_pdf_delegation_test.dart › U41 Android takeScreenshot delegates screenshotConfiguration and returns the channel bytes or null |

## Invariants and edge cases still to place

Behaviors that belong to the feature but do not yet have a home component. Each must become a numbered line above before the feature is done, or be dropped with a reason.

- Both takeScreenshot and createPdf return null when called before web page has finished loading (Edge case 1)
- Both return null when InAppWebView has zero width/height (not yet laid out) (Edge case 2)
- takeScreenshot handles scrollable content beyond visible viewport (Edge case 3)
- createPdf handles WebGL/canvas/dynamic content that hasn't fully rendered (Edge case 4)
- Both methods behave correctly on HeadlessInAppWebView (Edge case 6)
- createPdf handles very large web content on Android without OOM (Edge case 7)
- takeScreenshot handles transparent backgrounds in web content for PNG (Edge case 8)
- Both methods handle webview disposal while call is in flight (Edge case 9)

## Out of scope

Things a reader may expect on this list and the one-line reason they are absent.

- Windows createPdf implementation: Windows is explicitly out of scope per spec.md assumptions
- Web createPdf implementation: Web is explicitly out of scope per spec.md assumptions
- Windows takeScreenshot implementation: Windows is explicitly out of scope per spec.md assumptions
- Web takeScreenshot implementation: Web is explicitly out of scope per spec.md assumptions
- Android screenshot on API < 21: min API is 21, no requirement below
- Linux screenshot on non-WebKitGTK: only WebKitGTK backend supported
- Performance benchmarking: measurable outcomes are success criteria, not test behaviors
- PDF password protection/encryption: not in spec requirements
- Screenshot video recording: not in spec requirements

## Verification commands

Copied verbatim from `.specify/memory/tdd-profile.md` at planning time, so this file is readable on its own:

- Single test: `flutter test {file} --plain-name "{name}"`
- File tests: `flutter test {file}`
- Full suite: `flutter test`
- Coverage: `flutter test --coverage`
- Mutation: null (mutation_test package absent)
- Acceptance: null (no integration_test/ dir in repo yet)
- Property: null (glados absent)
- Contract: null