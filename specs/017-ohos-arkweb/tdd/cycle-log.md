# Behavioral validation

## Initial document lifecycle

Red was observed on an API 26 device through the public 6.4.1 umbrella widget:
an initial HTML document was passed to ArkWeb after controller attachment, then
replaced by the component's initial `about:blank` load. The native load log showed
the data document aborting; the expected inline heading and JS result were absent.

The fix gates document loads on completion of the declarative initial blank
document, rather than on controller attachment. Internal bootstrap page events
are not reported as application document loads. The device acceptance scenario
checks that its first inline script observes a document-start value and that
the same document can exchange a structured asynchronous JavaScript reply.

## Dart boundary scenarios

Six channel scenarios pass: asynchronous JS replies/handler removal, default
media denial, app-facing navigation callback identity, JSON/error propagation,
disposal and native-cookie host/path filtering. These are transport contracts;
they do not replace ArkTS compilation or device acceptance.

## Review fixes (#463)

The existing disposal scenario was extended to require exactly one native
release command. Added boundary scenarios cover values rejected by `dart:io`
before reaching ArkWeb, host/domain cookie expiration with preserved flags,
constant-count inventory reads during bulk deletion, detection of a native jar
that did not remove its domain cookie, and DNS/timeout/TLS error classification.
Before the fixes, all five affected scenarios failed. After integrating the
maintainer's fixes from #463 and #464 and combining overlapping scenarios,
twelve channel scenarios pass, as does Dart analysis with fatal infos.
The disposal scenario also reproduced an unhandled bootstrap cancellation when
the controller was disposed before the initial load completed. Startup now
consumes that cancellation only after disposal; live startup failures propagate.

Native review changes map mixed-content indices 0/1/2 to All/None/Compatible
and default to None, remove the unavailable `textZoom` setting, release native
resources on controller disposal, and acknowledge pre-mount configuration from
the model that the first build will consume. Mounted configuration still waits
for its frame. Stop/query/evaluation/configuration calls bypass bootstrap-page
readiness; document loads retain that synchronization to preserve the first
requested document. The latch records completion of ArkUI's initial blank page,
not completion of the requested network page.

The updated ArkTS compiled successfully as an unsigned HAR using the installed
HarmonyOS SDK. No device was connected for this fixes round, so runtime mixed
content enforcement, pre-mount timing and native disposal remain device checks.
Error-code mapping follows ArkWeb's documented WebNetErrorList/Chromium values,
not Android WebViewClient's error numbers.
