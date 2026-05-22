# Feature Specification: Screenshot and PDF Export

**Feature Branch**: `001-screenshot-pdf-export`

**Created**: 2026-05-22

**Status**: Draft

**Input**: User description: "Implement the export PDF and take screenshot, it is probably implemented already on ios, make sure android has it as well. ios,android,macos is priority linux nice to have. windows and web dont bother."

## User Scenarios & Testing *(mandatory)*

### User Story 1 - Capture WebView Screenshot on macOS (Priority: P1)

A developer using the library on macOS needs to programmatically capture a screenshot of the currently displayed web content within an InAppWebView, storing the result as a raw byte buffer for further use (e.g., saving to a file, sharing, or displaying in-app). iOS and Android developers can already do this; macOS support must reach parity with those platforms.

**Why this priority**: macOS is a critical platform for desktop testing and admin workflows. The screenshot feature is fully implemented on iOS and Android but completely absent on macOS, creating a significant platform gap.

**Independent Test**: Can be tested by opening any URL in a macOS InAppWebView, calling the `takeScreenshot` method, and verifying a non-null, non-empty byte buffer is returned. The buffer content should visually match the rendered page.

**Acceptance Scenarios**:

1. **Given** an InAppWebView displaying a loaded web page on macOS, **When** `takeScreenshot()` is called, **Then** a non-null `Uint8List` containing valid image data (PNG/JPEG) is returned.
2. **Given** an InAppWebView displaying a loaded web page on macOS, **When** `takeScreenshot()` is called with a `ScreenshotConfiguration` specifying JPEG format and quality 80, **Then** a valid JPEG byte buffer is returned.
3. **Given** an InAppWebView displaying a loaded web page on macOS, **When** `takeScreenshot()` is called with a rect capturing only a portion of the view, **Then** only that portion is captured in the resulting image.

---

### User Story 2 - Export WebView to PDF on Android (Priority: P1)

A developer using the library on Android needs to export the currently displayed web content as a PDF document. The iOS and macOS platforms already support this, but Android's implementation was previously disabled due to SDK compatibility issues. This feature must be re-enabled and working on modern Android SDK versions.

**Why this priority**: Android is the most used mobile platform and PDF export is an essential feature for document-based applications. Users expect feature parity with iOS.

**Independent Test**: Can be tested by opening any URL in an Android InAppWebView, calling `createPdf()`, and verifying a non-null byte buffer containing valid PDF data is returned. Additional testing should confirm `PdfConfiguration` options (e.g., page size) are respected.

**Acceptance Scenarios**:

1. **Given** an InAppWebView displaying a loaded web page on Android (API 21+), **When** `createPdf()` is called, **Then** a non-null `Uint8List` containing valid PDF data is returned.
2. **Given** an InAppWebView displaying content that spans multiple pages, **When** `createPdf()` is called with a `PdfConfiguration` specifying A4 page size, **Then** the resulting PDF reflects the A4 page dimensions and all content is included across pages.

---

### User Story 3 - Export WebView to PDF on Linux (Priority: P2)

A developer using the library on Linux needs to export web content as a PDF. Native C code for this feature already exists in the Linux implementation but is not wired to the Dart layer, making it unreachable from Flutter. The Dart controller must be updated to call the existing native implementation.

**Why this priority**: Linux is a "nice to have" platform per the user's request. The native C code already exists, so the effort is primarily wiring and testing rather than new implementation.

**Independent Test**: Can be tested by opening any URL in a Linux InAppWebView, calling `createPdf()`, and verifying a non-null byte buffer containing valid PDF data is returned.

**Acceptance Scenarios**:

1. **Given** an InAppWebView displaying a loaded web page on Linux, **When** `createPdf()` is called, **Then** a non-null `Uint8List` containing valid PDF data is returned.
2. **Given** an InAppWebView displaying a loaded web page on Linux, **When** `createPdf()` is called with a `PdfConfiguration`, **Then** the configuration options are respected in the generated PDF.

---

### User Story 4 - Take Screenshot on Linux (Priority: P2)

A developer using the library on Linux needs to capture a screenshot of the currently displayed web content. This is a "nice to have" feature that would bring Linux to parity with iOS and Android for screenshot capability.

**Why this priority**: Linux is "nice to have" per the user's request. This is a new implementation requiring both native and Dart code.

**Independent Test**: Can be tested by opening any URL in a Linux InAppWebView, calling `takeScreenshot()`, and verifying a non-null, non-empty byte buffer containing valid image data is returned.

**Acceptance Scenarios**:

1. **Given** an InAppWebView displaying a loaded web page on Linux, **When** `takeScreenshot()` is called, **Then** a non-null `Uint8List` containing valid image data is returned.
2. **Given** an InAppWebView displaying a loaded web page on Linux, **When** `takeScreenshot()` is called with a `ScreenshotConfiguration`, **Then** the configuration options (format, quality, rect) are respected.

---

### User Story 5 - Verify Existing Screenshot and PDF on iOS (Priority: P1)

Confirm that the already-implemented `takeScreenshot` and `createPdf` methods on iOS continue to work correctly across all supported iOS versions (14.0+).

**Why this priority**: iOS is the reference platform with both features implemented. Verification ensures existing functionality is not broken during development and establishes expected behavior for other platforms.

**Independent Test**: Run the existing test suite for the iOS platform, specifically exercising `takeScreenshot` and `createPdf` calls with various configurations.

**Acceptance Scenarios**:

1. **Given** an InAppWebView on iOS, **When** `takeScreenshot()` is called with default configuration, **Then** a valid PNG image byte buffer is returned.
2. **Given** an InAppWebView on iOS 14.0+, **When** `createPdf()` is called, **Then** a valid PDF byte buffer is returned.
3. **Given** an InAppWebView on iOS, **When** `createPdf()` is called on iOS 13.x (below minimum), **Then** the call fails gracefully with a clear error message.

---

### Edge Cases

- What happens when `takeScreenshot` or `createPdf` is called before the web page has finished loading?
- What happens when the InAppWebView has zero width or height (e.g., not yet laid out)?
- How does `takeScreenshot` handle content that extends beyond the visible viewport (scrollable content)?
- What happens when `createPdf` is called on a page using WebGL, canvas, or dynamic content that hasn't fully rendered?
- How do `takeScreenshot` and `createPdf` behave when called on a `HeadlessInAppWebView`?
- What happens when `createPdf` is called on Android with very large web content (potential out-of-memory)?
- How does the feature handle transparent backgrounds in web content (e.g., for PNG screenshots)?
- What happens when the webview has been disposed but a screenshot/PDF call is still in flight?

## Requirements *(mandatory)*

### Functional Requirements

- **FR-001**: The `InAppWebViewController.takeScreenshot()` method MUST return a valid image byte buffer (`Uint8List`) on iOS, Android, and macOS platforms.
- **FR-002**: The `InAppWebViewController.takeScreenshot()` method MUST accept a `ScreenshotConfiguration` parameter controlling format (PNG/JPEG), compression quality, source rect, and snapshot dimensions on all supported platforms.
- **FR-003**: The `InAppWebViewController.createPdf()` method MUST return a valid PDF byte buffer (`Uint8List`) on iOS, Android, macOS, and Linux platforms.
- **FR-004**: The `InAppWebViewController.createPdf()` method MUST accept a `PdfConfiguration` parameter controlling page size, margins, and orientation on all supported platforms.
- **FR-005**: The Android platform MUST have the `createPdf` feature re-enabled and working on Android API 21+ (the common WebView API baseline).
- **FR-006**: The macOS platform MUST implement the `takeScreenshot` feature using the platform's native web rendering snapshot capability, maintaining parity with the iOS implementation.
- **FR-007**: The Linux platform MUST wire the existing native `createPdf` implementation to the Dart `InAppWebViewController`.
- **FR-008**: The Linux platform MUST implement `takeScreenshot` functionality using the platform's native web rendering capture capability.
- **FR-009**: Both `takeScreenshot` and `createPdf` MUST return `null` on unsupported platforms (Windows, Web) without crashing, matching existing behavior for `createPdf` on those platforms.
- **FR-010**: Both `takeScreenshot` and `createPdf` MUST handle the case where no web content is loaded by returning `null` rather than throwing an exception.
- **FR-011**: The deprecated `IOSInAppWebViewController` Apple facade in the main package MUST continue to forward `createPdf` calls correctly, and MUST support `takeScreenshot` forwarding if not already present.

### Key Entities

- **ScreenshotConfiguration**: Defines the parameters for a screenshot operation — image format (JPEG/PNG), compression quality (0–100), source rect (region to capture), and snapshot dimensions. Currently defined in the platform interface.
- **PdfConfiguration**: Defines the parameters for PDF generation — page size (A4, letter, etc.), page margins, and orientation (portrait/landscape). Currently defined in the platform interface.

## Success Criteria *(mandatory)*

### Measurable Outcomes

- **SC-001**: Developers can capture a screenshot on macOS and receive a valid image byte buffer within 3 seconds for a typical web page.
- **SC-002**: Developers can export a PDF on Android and receive a valid PDF byte buffer within 5 seconds for content up to 10 pages.
- **SC-003**: Developers can export a PDF on Linux by calling `createPdf()` and receiving valid output (wiring the existing native code).
- **SC-004**: All existing `takeScreenshot` and `createPdf` functionality on iOS continues to work without regression.
- **SC-005**: Screenshot and PDF export methods return `null` gracefully (without crashing) when called on unsupported platforms (Windows, Web).
- **SC-006**: A developer using any of the three priority platforms (iOS, Android, macOS) has both `takeScreenshot` and `createPdf` fully functional.

## Assumptions

- The existing `ScreenshotConfiguration` and `PdfConfiguration` configuration types are sufficient for all target platforms and do not need extension.
- Android's `createPdf` was previously disabled due to a platform SDK compatibility issue that can be resolved using the platform's built-in rendering-to-PDF capability (no external dependency needed beyond the platform SDK).
- macOS and iOS share the same underlying web rendering engine, so the macOS screenshot implementation can follow the same approach used successfully on iOS.
- The Linux platform's native web rendering engine already supports PDF generation (existing native code) and can render content to an image surface for screenshots.
- The deprecated Apple-platform facade class serving as a compatibility layer is still used by some consumers and must be maintained for backward compatibility.
- The out-of-scope platforms (Windows, Web) should continue returning `null` without any new implementation or behavior change.
