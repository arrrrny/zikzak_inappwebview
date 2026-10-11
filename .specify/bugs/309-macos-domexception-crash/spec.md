# Bug Spec: Defensive deserialization of script message bodies on macOS (Bug #309)

## Problem

A page's JavaScript can post a `DOMException` (or another value that is fragile or
not expressible in the Flutter standard message codec) through any zikzak macOS
script message handler. The macOS handler path reads `WKScriptMessage.body` with
no defense, so WebKit deserialization failures and non-cloneable values crash the
host process (issue #309, SIGSEGV in `CloneDeserializer::readDOMException`).

## Acceptance Criteria

1. **AC1 — Guarded read.** Every `WKScriptMessage` delivered to the zikzak macOS
   plugin is consumed through a single defensive read of `message.body` located in
   `WeakScriptMessageHandler`; an ObjC `@try/@catch` boundary converts an
   exception thrown by WebKit's deserializer into a normal string error. The
   process does not crash for catchable deserialization failures.
2. **AC2 — String fallback.** On deserialization failure the plugin reports a
   human-readable string error to Dart (`onConsoleMessage`, ERROR level) instead
   of crashing or silently dropping the message; legitimate messages are unaffected.
3. **AC3 — Codec-safe payload.** Values that deserialize but are not expressible
   by the Flutter standard message codec (opaque objects, dates, URLs, unsupported
   nested leaves) are recursively converted to their string representation before
   being passed to Dart.
4. **AC4 — Platform isolation.** Only macOS files change
   (`zikzak_inappwebview_macos/**`); iOS, Android, web, Windows, Linux handlers
   are untouched.
5. **AC5 — No regression.** `flutter analyze` and `flutter test` pass in the
   touched Dart packages (`zikzak_inappwebview_macos`, `zikzak_inappwebview`) with
   no new failures and zero formatting diffs.

## Environment Boundary (recorded, not hidden)

The WebKit-level reproduction (SIGSEGV in `CloneDeserializer::readDOMException`)
requires macOS + Xcode. This fix was produced in a Linux CI environment where
Swift/WebKit cannot execute; AC1/AC2/AC3 are implemented at the Swift boundary and
verified by code review + Swift syntax parse + the Dart-side gates of AC5, but the
WebKit-level red/green run is NOT PROVED here. The exact macOS reproduction and
verification commands are recorded in `tdd/cycle-log.md` and `tdd/verification.md`.
