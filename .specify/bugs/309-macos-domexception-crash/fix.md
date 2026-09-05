# Fix Report — 309-macos-domexception-crash

- **Branch**: `fix/309-macos-domexception-crash`
- **Fixes**: https://github.com/arrrrny/zikzak_inappwebview/issues/309
- **Constraints honored**: macOS script message handler deserialization only; no
  iOS/Android/other-platform handler changed; one PR.

## What was wrong

Every zikzak macOS script message handler is registered through
`WeakScriptMessageHandler`, which forwarded `WKScriptMessage` untouched, and every
branch of `InAppWebView.userContentController(_:didReceive:)` read
`message.body` bare (6 read sites). `message.body` is the WebKit
serialized-value deserialization boundary: a page posting a `DOMException`
crashes inside `CloneDeserializer::readDOMException` (issue #309), and values
that do deserialize but are foreign to the Flutter standard message codec put a
second crash vector behind the same unguarded read.

## The fix (3 files + 1 new shim target)

1. **`Sources/ZikzakExceptionCatcher/`** (new ObjC target):
   `ZikzakCatchException(block)` — a standard `@try/@catch` shim, because Swift
   cannot catch `NSException`. Wired into `Package.swift` as a dependency of the
   existing Swift target (no other build change).
2. **`WeakScriptMessageHandler.swift`** (rewritten): now the defensive choke
   point —
   - `defensivelyDeserializeBody(of:)` reads `message.body` **exactly once**
     inside `ZikzakCatchException`; if WebKit's deserializer throws, the
     exception becomes a plain string error (handler name + reason).
   - `sanitizeValueForMessageCodec(_:)` recursively converts anything the
     Flutter standard message codec cannot carry (opaque objects such as a
     DOMException result, `NSDate`, `NSURL`, unsupported nested leaves) to its
     string representation; plain string/number/bool/data/containers pass
     through unchanged in shape.
   - Delegates conforming to the new internal
     `DefensivelyDeserializedScriptMessageHandling` protocol receive the
     sanitized body + optional error string; unknown delegates keep legacy
     forwarding.
3. **`InAppWebView.swift`** (macOS only): conforms to the protocol; the
   `WKScriptMessageHandler` entry point now routes through the sanitized
   variant; all six body reads consume `sanitizedBody`; when
   `deserializationError != nil` the error is reported to Dart as a normal
   string via `onConsoleMessage` (level 3 = ERROR) instead of crashing or
   dropping silently.

## Behavior after the fix

- Legitimate traffic (JSON-string `callHandler` bodies, `[String: Any]`
  console/find/webmessage/scroll bodies) reaches Dart exactly as before.
- A body that fails to deserialize → Dart receives a console ERROR string naming
  the handler; the process stays alive.
- A body that deserializes but contains non-cloneable leaves → leaves arrive in
  Dart as strings; the process stays alive.

## Known limitation (recorded, not hidden)

The issue's SIGSEGV occurs inside WebKit's own C++ frame. No userspace catch can
survive a true memory fault; this fix guarantees (a) every catchable
deserialization failure becomes a string error, (b) nothing non-cloneable ever
reaches Dart, and (c) the body is read once through the exception boundary. The
WebKit-level red/green run remains a recorded gap for macOS CI — see
`tdd/verification.md` (verdict `PASS_WITH_GAPS`) and `tdd/cycle-log.md` C1.

## Verification summary

Real observed results on this host (Flutter 3.47.2 / Dart 3.13.2, Linux):
macOS package `flutter test` **42/42 green**; umbrella `flutter test` **236
passed / 3 failed with all 3 PROVEN pre-existing on clean master**; `git diff
--check` clean; `swiftc -parse` clean on all changed Swift files. Full audit:
`tdd/verification.md`.
