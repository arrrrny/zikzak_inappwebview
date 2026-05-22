# Data Model: Screenshot and PDF Export

**Feature**: Screenshot and PDF Export  
**Date**: 2026-05-22

## Existing Entities (No New Entities Required)

Both configuration entities already exist in `zikzak_inappwebview_platform_interface` and require no changes.

### ScreenshotConfiguration

Defined at: `zikzak_inappwebview_platform_interface/lib/src/types/screenshot_configuration.dart`

| Field | Type | Description | Default |
|-------|------|-------------|---------|
| rect | `ScreenshotConfigurationRect?` | Region of the WebView to capture (x, y, width, height). Null = entire viewport | null |
| snapshotWidth | `double?` | Width to scale the output to. Height is proportional. Null = native resolution | null |
| compressFormat | `ScreenshotCompressFormat` | Output format: PNG or JPEG | PNG |
| quality | `int` | JPEG compression quality (0-100). Ignored for PNG | 100 |
| afterScreenUpdates | `bool` | Whether to wait for pending rendering changes | true |

**Platform support**:
- iOS/macOS: All fields supported via `WKSnapshotConfiguration`
- Android: All fields supported via manual Bitmap manipulation
- Linux: `compressFormat` and `quality` supported; rect cropping may be limited by `webkit_web_view_get_snapshot()` API

### PDFConfiguration

Defined at: `zikzak_inappwebview_platform_interface/lib/src/types/pdf_configuration.dart`

| Field | Type | Description | Default |
|-------|------|-------------|---------|
| rect | `PDFConfigurationRect?` | Region of the WebView to capture as PDF. Null = entire viewport | null |
| pageSize | `PDFConfigurationPageSize?` | Target page dimensions (supports A0-A6, Letter, Legal, Tabloid, etc.) | platform default |
| orientation | `PDFConfigurationOrientation?` | Portrait or Landscape | Portrait |
| margins | `PDFConfigurationMargins?` | Page margins (top, bottom, left, right) | null (platform default) |

**Platform support**:
- iOS/macOS: `rect` only (WKPDFConfiguration only supports rect)
- Android: All fields via `PrintAttributes` + `PdfDocument.PageInfo`
- Linux: Limited to what `WebKitPrintOperation` + `GtkPrintSettings` supports

## State Transitions

Both operations are stateless — they read the current WebView content and return bytes. No persisted state.

### Operation Flow

```
takeScreenshot(config) → Dart controller → Method Channel → Native handler → Platform API → bytes
createPdf(config)      → Dart controller → Method Channel → Native handler → Platform API → bytes
```

### Return Value Contract

Both methods return `Future<Uint8List?>`:
- **Non-null Uint8List**: Success — valid image/PDF data
- **null**: Operation failed gracefully (e.g., no content loaded, platform below minimum version, unsupported platform)
- **No throw**: Methods must not throw exceptions to callers; failures are surfaced as null returns

### Platforms returning null (by design)

| Method | Windows | Web | Explanation |
|--------|---------|-----|-------------|
| `takeScreenshot` | UnimplementedError (base) | UnimplementedError (base) | Not overridden; base throws |
| `createPdf` | null return | null return | Override returns null per FR-009 |

**Note on UnimplementedError vs null**: Per FR-009, unsupported platforms should "return null without crashing." The current Windows and Web `takeScreenshot` implementations throw `UnimplementedError`. A minimal fix to return null instead should be applied for those platforms to satisfy FR-009, even though they are out of scope for new implementation.
