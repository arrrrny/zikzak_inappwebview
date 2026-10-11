# Cycle Log — 312-macos-usercontentcontroller-public

Append-only. One entry per cycle. Evidence over intention: entries marked
`NOT_EXECUTED` were not run, and the reason is recorded. Nothing in this file
claims a pass that was not observed on this machine.

---

## C1 — RED: two reds — one EXECUTED (language rule), one NOT_EXECUTED (macOS build)

- **Date**: 2026-09-05
- **Environment**: Linux x86_64 (Debian 13). Flutter 3.47.2 / Dart 3.13.2
  (Linux). Swift 6.1.2 (Linux tarball, `swiftc` usable with a local
  `libncurses6` compat shim). **No macOS SDK, no Xcode, no WebKit, no
  FlutterMacOS.**

### C1a — RED executed: Swift access-control rule (shape-exact, `swiftc -typecheck`)

Repro files (committed under the task record, mirrored at
`scripts/swift_repro/`): a `public protocol` + `public class` conforming to it
with the witness declared internal — the exact access-control shape of
`InAppWebView.swift:2318` pre-fix, with WebKit types stood in by local stubs
(WebKit is unavailable on Linux).

```bash
swiftc -typecheck red_repro.swift
```

Observed output (real):

```
red_repro.swift:30:10: error: method 'userContentController(_:didReceive:)'
must be declared public because it matches a requirement in public protocol
'ScriptMessageHandler'
   |
30 |     func userContentController(
   |          |- error: method 'userContentController(_:didReceive:)' must be
   |          |      declared public because it matches a requirement in public
   |          |      protocol 'ScriptMessageHandler'
   |          `- note: mark the instance method as 'public' to satisfy the
   |                requirement
RED_EXIT=1
```

This is the same diagnostic rule and wording family as the real macOS error in
issue #312 (`... must be declared public because it matches a requirement in
public protocol 'WKScriptMessageHandler'`). RED recorded: exit 1, compiler
diagnostic reproduced.

### C1b — RED for the real macOS build: NOT_EXECUTED — environment

- **Attempted** (real, observed):

  ```bash
  cd zikzak_inappwebview_macos && flutter build macos
  ```

  Output on this host: `Could not find a subcommand named "macos" for "flutter
  build".` — the subcommand does not exist off macOS. The build cannot be
  attempted here, let alone fail with the target error.

- **Red evidence for the real build**: the user-reported build log in issue
  #312 (`InAppWebView.swift:2318:10: error: method
  'userContentController(_:didReceive:)' must be declared public because it
  matches a requirement in public protocol 'WKScriptMessageHandler'`,
  reproduced verbatim in `issue.md`), plus the in-tree confirmation that the
  witness at line 2318 lacks the modifier while the class is public and the
  conformance is declared.
- **Honest status**: the macOS-build red is NOT PROVED by execution on this
  machine. It is evidenced indirectly (compiler-rule red executed + issue
  build log + source inspection).

---

## C2 — GREEN: fix applied; runnable gates executed on this host

- **Date**: 2026-09-05
- **Fix**: add `public` to the 2-arg
  `userContentController(_:didReceive:)` declaration at
  `zikzak_inappwebview_macos/macos/zikzak_inappwebview_macos/Sources/zikzak_inappwebview_macos/InAppWebView.swift:2318`.
  One token. The #309 defensive deserialization logic (the 4-arg sanitized
  variant, `WeakScriptMessageHandler.defensivelyDeserializeBody`,
  `sanitizeValueForMessageCodec`, the ObjC exception boundary) is untouched.

### C2a — GREEN executed: language-rule repro

```bash
swiftc -typecheck green_repro.swift   # identical to red_repro.swift + `public`
```

Observed: exit 0, zero diagnostics. The modifier the compiler's fix-it names
("mark the instance method as 'public'") is exactly the one-token change
applied to the real file.

### C2b — GREEN executed: gates on this host (Flutter 3.47.2 / Dart 3.13.2, Swift 6.1.2)

| Gate | Command | Clean tree (fix stashed) | Fixed tree | Verdict |
| --- | --- | --- | --- | --- |
| analyze (macos pkg) | `cd zikzak_inappwebview_macos && flutter analyze` | 4 findings (1 info, 3 warnings; exit 1) | 4 findings, byte-identical set; zero in changed code | unchanged — no regression |
| test (macos pkg) | `cd zikzak_inappwebview_macos && flutter test` | 42 passed / 0 failed | **42 passed / 0 failed** | green, unchanged |
| analyze (umbrella) | `cd zikzak_inappwebview/zikzak_inappwebview && flutter analyze` | — | 37 findings (all pre-existing per 309 baseline) | unchanged |
| test (umbrella) | `cd zikzak_inappwebview/zikzak_inappwebview && flutter test` | **236 passed / 3 failed** (re-run with fix stashed) | 236 passed / 3 failed — same 3 failures | failures PROVEN pre-existing |
| swift parse | `swiftc -parse InAppWebView.swift` + `WeakScriptMessageHandler.swift` | — | PARSE OK ×2 (exit 0) | syntax clean |
| platform isolation | `git status --porcelain` / `git diff --stat` | — | 1 Swift file + `.specify/bugs/312-*/` records only | confined |
| formatting | `git diff --check` | — | clean | zero diffs |

Umbrella failures (identical on clean and fixed trees; all pre-existing,
unchanged from the 309 run's baseline):

1. `test/proxy_tracing_controllers_test.dart` — file load error `[E]`
2. `test/domain_controllers_behavioral_test.dart` U14 — loadSimulatedRequest delegates to parent identically
3. `test/in_app_webview_dispose_test.dart` U9 — later dispose(isKeepAlive:false) after dispose(isKeepAlive:true) forwards false

### C2c — GREEN for the real macOS build: NOT_EXECUTED — environment

Maintainer/CI command (macOS with Xcode):

```bash
cd zikzak_inappwebview_macos && flutter build macos
# EXPECT: BUILD SUCCEEDED; zero occurrences of
# "must be declared public because it matches a requirement"
```

- **Honest status**: macOS-build green NOT PROVED on this machine. PROVED on
  this machine: the Swift compiler accepts the post-fix access-control shape
  and rejects the pre-fix shape (C1a/C2a), and the real file parses.

---

## C3 — REFACTOR: none required

- **Date**: 2026-09-05
- The change is a single access modifier; there is nothing to refactor without
  violating the hard constraint (fix ONLY the access modifier).
