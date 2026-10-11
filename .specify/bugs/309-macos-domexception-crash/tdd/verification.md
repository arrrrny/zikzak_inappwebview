# TDD Verification — 309-macos-domexception-crash

- **verified_at**: `4dbe3171` (base) + working tree committed as the fix commit on `fix/309-macos-domexception-crash`
- **standard**: `.specify/extensions/tdd/templates/tdd-test-quality-rubric.md` (resolved: extension copy; no overrides/presets present)
- **feature dir**: `.specify/bugs/309-macos-domexception-crash/` (via `.specify/feature.json`)
- **environment**: Linux x86_64 (Debian 13), Flutter 3.47.2 / Dart 3.13.2 (Linux host), Swift 6.1.2 (Linux, syntax gate only). **No macOS SDK, no Xcode, no WebKit.**
- **audit independence**: NOT independent — the same session that wrote the fix wrote this report. Fail-closed applies throughout.

## Verdict: PASS_WITH_GAPS

The runnable gates are green and the platform-isolation constraint is PROVEN.
The WebKit-level red/green cycle (B1–B4, B11) was **not executed** because it
requires macOS hardware; this is a recorded gap, not a pass. Test strength is
**unmeasured** (no mutation tooling for Swift on this host; profile records
`mutation: null`).

## Suite runs (observed on this host)

| Gate | Command | Observed result |
| --- | --- | --- |
| analyze (macos pkg) | `cd zikzak_inappwebview_macos && flutter analyze` | 4 findings (1 info, 3 warnings), **all in files untouched by this change** (`lib/src/cookie_manager.dart`, `test/context_menu_test.dart`, `test/headless_repro_test.dart`); zero findings in changed files. Exit non-zero pre-exists. |
| test (macos pkg) | `cd zikzak_inappwebview_macos && flutter test` | **42 passed / 0 failed** ("All tests passed!") |
| analyze (umbrella) | `cd zikzak_inappwebview && flutter analyze` | 37 findings incl. 1 error (`test/proxy_tracing_controllers_test.dart:24` invalid_override) — **all pre-existing, file untouched by this change**; package contains none of this diff |
| test (umbrella) | `cd zikzak_inappwebview && flutter test` | **236 passed / 3 failed**. The 3 failures (U14 loadSimulatedRequest, U9 dispose-forwarding, proxy_tracing load error) were **re-run on a clean master tree (changes stashed) and fail identically** → PROVEN pre-existing, not introduced by this change |
| formatting | `git diff --check` | clean — zero whitespace/formatting diffs; diff contains functional changes only |
| swift syntax | `swiftc -parse` (Swift 6.1.2 Linux) | PARSE OK for `WeakScriptMessageHandler.swift`, `InAppWebView.swift`, `Package.swift` |
| platform isolation | `git status --porcelain` / `git diff --stat` | changes confined to `zikzak_inappwebview_macos/**` + `.specify/` bug artifacts; iOS/Android/web/Windows/Linux untouched |

Note: the task's chained `flutter analyze && flutter test` form stops at analyze
on both packages because pre-existing analyzer findings make analyze exit
non-zero. Tests were therefore run as separate commands; counts above are real.

## Test-first evidence (per behavior)

| ID | Behavior | Classification | Basis |
| --- | --- | --- | --- |
| B1 (AC1) | Guarded read; ObjC exception boundary in `WeakScriptMessageHandler` | **NO_TEST (macOS-only)** | No macOS XCTest was executed — impossible on this host. Implementation exists and parses. |
| B2 (AC2) | String error reported to Dart (`onConsoleMessage`, level 3) on deserialization failure | **NO_TEST (macOS-only)** | Same as B1. |
| B3 (AC3) | Recursive codec-safe conversion of non-cloneable leaves | **NO_TEST (macOS-only)** | Same as B1. |
| B4 (AC4) | Legitimate traffic passes through unchanged in shape | **NO_TEST (macOS-only)** | Same as B1. Existing 42 macOS-package Dart tests green after the change, but they never exercise the Swift path. |
| B5 (AC5) | Only macOS files changed | **PROVEN** | `git status --porcelain` inspected directly. |
| B6 (AC5) | analyze macos pkg | **PROVEN** (pre-existing findings only) | Observed output above. |
| B7 (AC5) | test macos pkg | **PROVEN** | 42/42 observed. |
| B8 (AC5) | analyze umbrella | **PROVEN** (pre-existing findings only) | Observed output above. |
| B9 (AC5) | test umbrella | **PROVEN** (pre-existing failures only) | 236/3 with baseline re-run proof. |
| B10 (AC5) | Swift syntax gate | **PROVEN (shallow)** | `swiftc -parse` only; **no type-check** against WebKit/FlutterFramework (impossible on Linux). |
| B11 (AC1–3) | WebKit-level red→green crash repro | **NOT_EXECUTED** | Requires macOS + Xcode; exact commands recorded in `tdd/cycle-log.md` C1. |

## Red-phase evidence

- Red was **not** executed (no macOS). No macOS-native test was authored and
  left failing first. By the rubric this makes the fix **test-after** for
  B1–B4/B11. The red repro is fully specified in `tdd/cycle-log.md` C1 for a
  macOS maintainer/CI to run.
- Baseline discipline: the umbrella suite's 3 failures were isolated to master
  before counting them against this change (stash → re-run → same failures →
  restore).

## Smells / discrepancies found

1. **Structural — test gap in Swift**: `defensivelyDeserializeBody` /
   `sanitizeValueForMessageCodec` have no executable tests anywhere in the repo
   (macOS Xcode test target does not exist). Remediation R1.
2. **Minor — legacy fallback path re-reads the body**: if a foreign
   (non-sanitizing) delegate is ever registered through
   `WeakScriptMessageHandler`, its handler still calls `message.body` itself;
   the defensive read happens once in the wrapper but the foreign delegate's own
   body read is not intercepted. Today all six zikzak registrations use the
   sanitizing path, so the exposed surface is empty. Remediation R3.
3. **Info — pre-existing analyzer/test debt** in both packages (findings listed
   above) predates this change and is out of scope per the hard constraints
   (fix only the macOS script message handler deserialization).

## Remediation tasks (do not gate this PR)

- **R1** (high): add an Xcode test target for `zikzak_inappwebview_macos` and
  port the cycle-log C1/C2 scenarios into XCTest cases
  (`WeakScriptMessageHandlerTests`: exception-containing body, DOMException-like
  opaque object, NSDate/URL leaves, plain JSON-string callHandler body).
- **R2** (high): run the WebKit-level repro (cycle-log C1) on macOS CI and paste
  the crash-absent result into this file's addendum.
- **R3** (medium): decide whether foreign delegates should be force-cast to
  `DefensivelyDeserializedScriptMessageHandling` at registration time so the
  legacy path can be deleted.
- **R4** (low): sweep the pre-existing analyzer findings in both packages once a
  maintainer confirms they are not load-bearing for other in-flight branches.
