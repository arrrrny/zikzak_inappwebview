# Tasks — 339-macos-useondownloadstart-is-dead

Implementation is complete (see `tdd/test-list.md`, `tdd/cycle-log.md`,
`tdd/verification.md`). This file carries the TDD remediation work the
verification verdict left open.

## Phase 1: TDD remediation

From `tdd/verification.md` (verdict PASS_WITH_GAPS — the gaps below are the
reason it is not PASS):

- [ ] T1 (HIGH, from Finding 1 / B11 gap): on a macOS host with Xcode, run the
  issue's end-to-end repro and confirm the Dart callback fires. Command:
  `cd zikzak_inappwebview/example && flutter run -d macos` with the repro
  snippet in `spec.md` (serve a `Content-Disposition: attachment` URL, tap it,
  expect `DOWNLOAD: <url>` to print). Proves the AC2–AC6 chain through the real
  WebKit entry point and clears the runtime gap that kept the verdict at
  PASS_WITH_GAPS. The downstream consumer offered to run exactly this
  (issue #339 / zuraffa_browser#214) — hand them a build or a branch ref.
- [ ] T2 (MED, from Finding 1): when a macOS runner is available, replace the
  source-scan contract for the download chain with (or complement it by) a
  native unit test that exercises `decidePolicyFor navigationResponse` with a
  stubbed `WKNavigationResponse` (`canShowMIMEType == false`) and asserts
  `.download` + a dispatched event at runtime. Prove done by running it in
  Xcode/zikzak_inappwebview_macos scheme on macOS. This closes the
  semantic-mutant residual risk recorded in Mutation results (M2 class).
