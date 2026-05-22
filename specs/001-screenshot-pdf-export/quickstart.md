# Quickstart: Screenshot and PDF Export

**Feature**: Screenshot and PDF Export  
**Date**: 2026-05-22

## Usage After Implementation

### Take a Screenshot

```dart
// Basic screenshot (PNG, full viewport)
Uint8List? screenshot = await controller.takeScreenshot();
if (screenshot != null) {
  await File('screenshot.png').writeAsBytes(screenshot);
}

// JPEG screenshot with custom settings
Uint8List? jpeg = await controller.takeScreenshot(
  screenshotConfiguration: ScreenshotConfiguration(
    compressFormat: ScreenshotCompressFormat.JPEG,
    quality: 80,
    rect: ScreenshotConfigurationRect(
      x: 0, y: 0, width: 800, height: 600,
    ),
  ),
);
```

### Export to PDF

```dart
// Basic PDF export
Uint8List? pdf = await controller.createPdf();
if (pdf != null) {
  await File('document.pdf').writeAsBytes(pdf);
}

// PDF with A4 page size and margins
Uint8List? pdf = await controller.createPdf(
  pdfConfiguration: PDFConfiguration(
    pageSize: PDFConfigurationPageSize.A4,
    orientation: PDFConfigurationOrientation.PORTRAIT,
    margins: PDFConfigurationMargins(
      top: 20, bottom: 20, left: 20, right: 20,
    ),
  ),
);
```

## Platform Support After Implementation

| Feature | iOS | Android | macOS | Linux | Windows | Web |
|---------|:---:|:-------:|:-----:|:-----:|:-------:|:---:|
| `takeScreenshot` | ✅ | ✅ | ✅ | ✅ | ❌ | ❌ |
| `createPdf` | ✅ | ✅ | ✅ | ✅ | ❌ | ❌ |

## What Changed

### macOS
- `takeScreenshot` is newly implemented (uses native WKWebView snapshot API)
- `createPdf` already worked; verified no regressions

### Android
- `createPdf` was re-enabled (previously returned null due to compatibility issue)
- `takeScreenshot` already worked; verified no regressions

### Linux
- Both `takeScreenshot` and `createPdf` are newly available
- `createPdf` native code already existed; Dart controller now calls it
- `takeScreenshot` uses WebKitGTK's snapshot API

### iOS
- No functional changes; both features verified working

### Windows / Web
- No changes (remain unsupported, return null gracefully)
