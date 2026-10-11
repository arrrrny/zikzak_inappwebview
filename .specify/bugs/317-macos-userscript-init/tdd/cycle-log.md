# Cycle Log — 317-macos-userscript-init

Append-only. One entry per cycle. Evidence over intention: entries marked
`NOT_EXECUTED` were not run, and the reason is recorded. Nothing in this file
claims a pass that was not observed on this machine.

---

## C1 — RED: reds EXECUTED at three gates (Dart parity gate, Swift rule repro, green-shape control)

- **Date**: 2026-09-06
- **Environment**: Linux x86_64 (Debian 13). Flutter 3.47.2 / Dart 3.13.2
  (Linux). Swift 6.1.2 (Linux tarball, `swiftc` usable via local
  `libncurses6` compat shim: `LD_LIBRARY_PATH=/home/z/tools/swift-shim`).
  **No macOS SDK, no Xcode, no WebKit, no FlutterMacOS.**
- **Base commit**: `0c51cce8` (master), branch `fix/317-macos-userscript-init`.

### Pre-fix baselines (captured before any source change)

- `cd zikzak_inappwebview_macos && flutter analyze` → **4 issues** (1 info
  `unnecessary_import` at `lib/src/cookie_manager.dart:5:8`, 3 warnings in
  `test/context_menu_test.dart:409` and `test/headless_repro_test.dart:50,52`).
- `cd zikzak_inappwebview_macos && flutter test` → **42 passed / 0 failed**.
- `cd zikzak_inappwebview/zikzak_inappwebview && flutter analyze` → **37 issues**.
- `cd zikzak_inappwebview/zikzak_inappwebview && flutter test` → **245 passed /
  2 failed** (pre-existing; both re-identified below in C4).

### C1a — RED executed: Dart native-source parity gate

New test file
`zikzak_inappwebview_macos/test/user_script_initializer_parity_test.dart`
(6 tests) reads the native
`macos/zikzak_inappwebview_macos/Sources/zikzak_inappwebview_macos/Types/UserScript.swift`
and enforces iOS↔macOS initializer parity.

```bash
cd zikzak_inappwebview_macos && flutter test test/user_script_initializer_parity_test.dart
```

Observed (real, pre-fix):

```
00:00 +4 -2: Some tests passed.

Failing tests:
  test/user_script_initializer_parity_test.dart: ... overrides init(source:injectionTime:forMainFrameOnly:in:) — #317
  test/user_script_initializer_parity_test.dart: ... the #317 override delegates to super with the contentWorld form
```

Failed for the right reason: the #317 initializer does not exist in the
pre-fix source (`Actual: <null>` from `expect(match, isNotNull,
reason: '#317 initializer must exist')`).

### C1b — RED executed: Swift shape-exact rule repro

`.specify/bugs/317-macos-userscript-init/tdd/swift_repro/red_repro.swift`:
WKUserScript/WKContentWorld stood in by local stubs exposing both designated
initializers (WebKit is unavailable on Linux); the `UserScript` subclass is the
pre-fix macOS shape (3 initializers, verbatim from `0c51cce8`); the construction
site is the exact initializer shape named in issue #317.

```bash
swiftc -typecheck red_repro.swift
```

Observed output (real):

```
red_repro.swift:84:5: error: missing argument for parameter 'groupName' in call
65 |     public init(
   |            `- note: 'init(groupName:source:injectionTime:forMainFrameOnly:in:)' declared here
...
84 |     source: "window.flutter_inappwebview = {};",
   |     `- error: missing argument for parameter 'groupName' in call
```

exit code 1. The compiler confirms the issue title: the only `in:`-form
initializer available on the pre-fix macOS subclass requires `groupName` —
`init(source:injectionTime:forMainFrameOnly:in:)` is not implemented.

### C1c — GREEN-shape control (same cycle, prevents a red with no reachable green)

`.specify/bugs/317-macos-userscript-init/tdd/swift_repro/green_repro.swift`:
same stand-ins and same construction site; the subclass carries the fourth
initializer exactly as the iOS implementation declares it.

```bash
swiftc -typecheck green_repro.swift
```

Observed (real): zero diagnostics, exit code 0.

---

## C2 — GREEN: implementation lands; all runnable gates green

- **Date**: 2026-09-06
- **Change**: `zikzak_inappwebview_macos/macos/zikzak_inappwebview_macos/Sources/zikzak_inappwebview_macos/Types/UserScript.swift`
  — added the missing initializer, iOS-identical (placement between the base
  override and the groupName variants, matching the iOS file), plus a header
  comment referencing #317. 15 insertions, 0 deletions. No other source file
  touched.

```swift
public override init(
    source: String, injectionTime: WKUserScriptInjectionTime, forMainFrameOnly: Bool,
    in contentWorld: WKContentWorld
) {
    super.init(
        source: source, injectionTime: injectionTime, forMainFrameOnly: forMainFrameOnly,
        in: contentWorld)
    self.contentWorld = contentWorld
}
```

### C2a — GREEN executed: Dart parity gate

```bash
cd zikzak_inappwebview_macos && flutter test test/user_script_initializer_parity_test.dart
```

Observed (real, post-fix): `00:00 +6: All tests passed!`

### C2b — GREEN executed: full macOS package suite

```bash
cd zikzak_inappwebview_macos && flutter analyze   # 4 issues — byte-identical pre-existing set
cd zikzak_inappwebview_macos && flutter test      # 00:01 +48: All tests passed!
```

48 = 42 baseline + 6 new parity tests. Umbrella gates (real): analyze 37
issues (identical pre-existing set), test **245 passed / 2 failed** — the same
2 pre-existing failures as the pre-fix baseline (details in C4).

### Cycle-log correction recorded (test bug, not a weakened gate)

After the fix, C2's first run still failed one parity test. Root cause was a
defect in the test's own body-extraction regex (a tempered lookahead
`(?!init\()` stopped the capture at `super.init(`, truncating the initializer
body before `in: contentWorld` / `self.contentWorld = contentWorld` could be
observed). The regex was repaired (lazy capture to the declaration's closing
brace; capture group 0 → 1). The assertions themselves were never weakened; the
pre-fix red in C1a did not depend on the defective capture (it failed at
`expect(match, isNotNull)`).

---

## C3 — REFACTOR + test strength (deliberate mutants): none required in source; mutants CAUGHT

- **Date**: 2026-09-06
- Refactor: none required — the added initializer is a verbatim iOS-parity copy.

No mutation tool in the profile (`mutation: null` in tdd-profile.md), so
deliberate mutants per the rubric, one at a time, on the changed file, each
restored exactly and re-verified green:

### M1 — remove the #317 initializer entirely

```bash
# mutant applied to Sources/.../Types/UserScript.swift (block deleted)
cd zikzak_inappwebview_macos && flutter test test/user_script_initializer_parity_test.dart
```

Observed (real): `00:00 +1 -1: ... overrides init(source:injectionTime:forMainFrameOnly:in:) — #317 [E]`
→ **CAUGHT**. Restored from backup; `git diff` back to 15 insertions.

### M2 — drop `self.contentWorld = contentWorld` from the new initializer

```bash
# mutant applied (super delegation kept, contentWorld recording dropped)
cd zikzak_inappwebview_macos && flutter test test/user_script_initializer_parity_test.dart
```

Observed (real): `00:00 +4 -1: ... the #317 override delegates to super with the contentWorld form [E]`
→ **CAUGHT**. Restored; `diff` against pre-mutant backup: empty; suite re-run
`00:00 +6: All tests passed!`.

### Syntax gate on the real changed file

```bash
swiftc -parse UserScript.swift
```

Observed (real): exit code 0 (parse-only; type-check against WebKit is
impossible on Linux — recorded as B10, syntax-only).

---

## C4 — VERIFY: full gates vs baseline (numbers, not claims)

- **Date**: 2026-09-06

| Gate | Pre-fix baseline | Post-fix | Verdict |
| --- | --- | --- | --- |
| `cd zikzak_inappwebview_macos && flutter analyze` | 4 issues (1 info, 3 warnings) | 4 issues, identical set | no regression |
| `cd zikzak_inappwebview_macos && flutter test` | 42 passed / 0 failed | **48 passed / 0 failed** (42 + 6 new) | green |
| `cd zikzak_inappwebview/zikzak_inappwebview && flutter analyze` | 37 issues | 37 issues, identical set | no regression |
| `cd zikzak_inappwebview/zikzak_inappwebview && flutter test` | 245 passed / 2 failed | **245 passed / 2 failed**, same 2 | failures PROVEN pre-existing |
| `git diff --check` | — | clean | zero formatting diffs |

The 2 umbrella failures are PROVEN pre-existing: the baseline run predates any
Dart/Swift change (working tree then contained only `.specify` tool config
edits, which are not Dart inputs):

1. `test/proxy_tracing_controllers_test.dart` — **compile error**:
   `_FakePlatformProxyController.clearProxyOverride` has fewer named arguments
   than overridden `PlatformProxyController.clearProxyOverride`
   (`test/proxy_tracing_controllers_test.dart:24:16`).
2. `test/domain_controllers_behavioral_test.dart` — `U14 loadSimulatedRequest
   delegates to parent identically`: `Expected: null / Actual:
   URLResponse(url: https://example.com, ...)` at
   `test/domain_controllers_behavioral_test.dart:194`.

Neither file nor its subject is touched by this fix (diff = 1 Swift file + 1
new macOS-package test + bug records).

---

## C5 — NOT_EXECUTED gates (macOS-only), with exact commands

- **Date**: 2026-09-06

1. **Real compile gate** (B3):

   ```bash
   cd zikzak_inappwebview_macos && flutter build macos
   ```

   NOT_EXECUTED — observed on this host: `Could not find a subcommand named
   "macos" for "flutter build".` (Linux host; requires macOS + Xcode).
   Run in CI/macOS before merge.

2. **Runtime gate** (B4):

   ```dart
   // macOS desktop target:
   InAppWebView(
     initialUrlRequest: URLRequest(url: WebUri('https://flutter.dev')),
     initialUserScripts: UnmodifiableListView<UserScript>([
       UserScript(source: 'window.__317 = true;',
                  injectionTime: UserScriptInjectionTime.AT_DOCUMENT_START,
                  forMainFrameOnly: true),
     ]),
   )
   ```

   Expected: no crash; `window.__317` observable from the first page load
   (e.g. via `evaluateJavascript` in `onLoadStop`). NOT_EXECUTED — requires a
   macOS host. The deserialization entry point (`UserScript.fromMap`) is
   unchanged by this fix and is covered by the parity gate's static
   deserialization assertions; the initializer it (and any dynamic consumer
   path) relies on now exists with full WKUserScript API parity.
