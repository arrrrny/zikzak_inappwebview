# Cycle Log — 309-macos-domexception-crash

Append-only. One entry per cycle. Evidence over intention: entries marked
`NOT_EXECUTED` were not run, and the reason is recorded. Nothing in this file
claims a pass that was not observed on this machine.

---

## C1 — RED (reproduce the crash): NOT_EXECUTED — environment

- **Date**: 2026-09-04
- **Attempted on**: Linux x86_64 CI container (`Linux … 6.x`, no macOS SDK, no
  Xcode, no WebKit, no Apple GPU process). Flutter 3.47.2 / Dart 3.13.2 (Linux) is
  the only toolchain available.
- **Why it cannot run here**: the crash is a WebKit-internal memory fault
  (`CloneDeserializer::readDOMException`) in the macOS Web Content process/UI
  process bridge. Reproducing it requires running a real `WKWebView` on macOS.
- **The reproduction that must run on macOS** (maintainer/CI, exact commands):

  ```bash
  # 1. On macOS with Flutter + Xcode:
  cd zikzak_inappwebview_macos/example   # example app hosting the webview
  flutter run -d macos
  # 2. In the app, navigate to a page executing:
  #    <script>
  #      try { navigator.serviceWorker } catch (e) {}
  #      window.webkit.messageHandlers.consoleHandler.postMessage(
  #        new DOMException('boom', 'SecurityError'));
  #    </script>
  # 3. EXPECTED (pre-fix): process dies, crash report shows
  #    WebCore::CloneDeserializer::readDOMException →
  #    SerializedScriptValue::deserialize →
  #    ScriptMessageHandlerDelegate::didPostMessage
  ```

- **Red evidence recorded**: NONE (no executable red on this host). The red
  state is evidenced indirectly by the unguarded code path
  (`WeakScriptMessageHandler.swift` forwards `WKScriptMessage` untouched; every
  branch of `InAppWebView.userContentController(_:didReceive:)` reads
  `message.body` bare and feeds values straight into the method channel).
- **Honest status**: red NOT PROVED. No macOS-native test was written to a state
  of "failing first" on this machine.

---

## C2 — GREEN (fix): fix implemented; runnable gates executed on Linux, WebKit-level gates remain macOS-only

- **Date**: 2026-09-04
- **Fix**: see `fix.md`. Defensive deserialization choke point in
  `WeakScriptMessageHandler` (macOS): single guarded `message.body` read behind an
  ObjC `@try/@catch` shim (`ZikzakExceptionCatcher` target), recursive
  codec-safety sanitization (non-cloneable leaves → string), and a string error
  report to Dart (`onConsoleMessage`, ERROR level) when deserialization fails.
- **Runnable verification executed on this host** (Flutter 3.47.2 / Dart 3.13.2, Linux):

  | Gate | Command | Observed result |
  | --- | --- | --- |
  | analyze (macos pkg) | `cd zikzak_inappwebview_macos && flutter analyze` | 4 findings — all pre-existing in untouched files; zero in changed files |
  | test (macos pkg) | `cd zikzak_inappwebview_macos && flutter test` | **42 passed / 0 failed** ("All tests passed!") |
  | analyze (umbrella) | `cd zikzak_inappwebview && flutter analyze` | 37 findings — all pre-existing in untouched files (1 error in `test/proxy_tracing_controllers_test.dart`) |
  | test (umbrella) | `cd zikzak_inappwebview && flutter test` | **236 passed / 3 failed** — the 3 failures re-run on clean master (stash) and fail identically → PROVEN pre-existing |
  | platform isolation | `git status --porcelain` / `git diff --stat` | macOS files + `.specify/` only |
  | formatting | `git diff --check` | clean |
  | swift syntax | `swiftc -parse` (Swift 6.1.2, Linux) | PARSE OK ×3 (`WeakScriptMessageHandler.swift`, `InAppWebView.swift`, `Package.swift`) |

- **WebKit-level green NOT EXECUTED on this host.** Maintainer/CI commands
  (macOS): same repro as C1 after applying the fix — the process must stay alive
  and Dart must receive the string error; plus the XCTest commands recorded in
  `verification.md` Phase 5.
- **Honest status**: green NOT PROVED for B1–B4/B11 (macOS-only). Green PROVED
  only for the runnable gates listed in `verification.md` with real observed
  output.
