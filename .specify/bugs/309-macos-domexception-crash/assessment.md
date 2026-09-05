# Bug Assessment: macOS crash — WebKit deserialization of DOMException in script message handler

- **Slug**: 309-macos-domexception-crash
- **Created**: 2026-09-04
- **Source**: https://github.com/arrrrny/zikzak_inappwebview/issues/309
- **Verdict**: confirmed-by-report (crash signature and repro path are consistent with the code); reproduction requires macOS hardware
- **Severity**: critical

## Report (verbatim or summarized)

On macOS, a page whose JavaScript creates a `DOMException` (permission APIs,
notifications, service workers, fetch errors) and passes it through the zikzak
bridge crashes the host app with `EXC_BAD_ACCESS (SIGSEGV)` inside
`WebCore::CloneDeserializer::readDOMException`, reached via
`SerializedScriptValue::deserialize` → `ScriptMessageHandlerDelegate::didPostMessage`.

## Symptom

Intermittent hard crash (SIGSEGV, not a catchable exception) of the whole Flutter
app on macOS, only when page JS posts fragile/non-cloneable values (DOMException
and friends) into a script message handler registered by the plugin.

## Reproduction

macOS only. Run any Flutter app embedding the zikzak macOS webview; load a page
that executes e.g.
`window.webkit.messageHandlers.consoleHandler.postMessage(new DOMException('x','SecurityError'))`
(or triggers the same through the bridge), and the process dies inside WebKit's
clone deserializer. Cannot be reproduced on Linux/Windows — WebKit is required.

## Suspected Code Paths

- `zikzak_inappwebview_macos/macos/.../WeakScriptMessageHandler.swift` — the
  registration wrapper for **every** macOS script message handler
  (`consoleHandler`, `callHandler`, `onFindResultReceived`,
  `onWebMessagePortMessageReceived`, `onWebMessageListenerPostMessageReceived`,
  `onScrollChangedReceived`). It forwards `WKScriptMessage` untouched; nothing
  guards the `message.body` deserialization.
- `zikzak_inappwebview_macos/macos/.../InAppWebView.swift`
  `userContentController(_:didReceive:)` (line ~2315) — every branch casts
  `message.body as? [String: Any]` and passes nested values straight into
  `invokeMethod`, so both WebKit deserialization and the Flutter standard message
  codec are exposed to non-cloneable values.

## Root Cause Hypothesis

`WKScriptMessage.body` is consumed without any defensive layer. WebKit's
deserializer (`CloneDeserializer::readDOMException`) has a memory-unsafe path for
`DOMException` payloads; values that do deserialize but are foreign to the Flutter
standard message codec (or arrive as opaque objects) put a second, catchable
crash vector behind the same unguarded read.

## Proposed Remediation

Make the macOS `WeakScriptMessageHandler` a defensive choke point (macOS
equivalent of the iOS reference path):

1. Read `message.body` exactly once per message, wrapped in an ObjC
   `@try/@catch` shim so WebKit exceptions thrown during deserialization become a
   normal string error instead of propagating.
2. Recursively convert values that are not expressible in the Flutter standard
   message codec (non-cloneable objects, dates, URLs, opaque types) to their
   string representation before anything reaches Dart.
3. On deserialization failure, report a plain string error to Dart
   (`onConsoleMessage`, ERROR level) instead of crashing or dropping silently.

Hard constraints: fix ONLY the macOS script message handler deserialization; do
not change iOS/Android/other platform handlers; one PR for the bug.

## Risks & Considerations

- The SIGSEGV itself occurs inside WebKit's C++ frame; no userspace handler can
  catch a true memory fault. The fix removes the catchable failure modes at the
  Swift boundary and guarantees a string report; it cannot make a WebKit-internal
  segfault survivable, and that limitation is recorded in verification.
- The ObjC exception shim must not disturb the plugin's SwiftPM build layout.
- Behavioral risk is low: sanitized bodies keep the documented
  `[String: Any]` shape for all legitimate plugin traffic (the official
  `callHandler` bridge already posts JSON strings).

## Open Questions

- None blocking. Whether macOS CI exists to run the WebKit-level repro is
  recorded as a verification gap if absent.
