# Behavioral validation

## Initial document lifecycle

Red was observed on an API 26 device through the public 6.4.1 umbrella widget:
an initial HTML document was passed to ArkWeb after controller attachment, then
replaced by the component's initial `about:blank` load. The native load log showed
the data document aborting; the expected inline heading and JS result were absent.

The fix gates native operations on completion of the declarative initial blank
document, rather than on controller attachment. Internal bootstrap page events
are not reported as application document loads. The device acceptance scenario
checks that its first inline script observes a document-start value and that
the same document can exchange a structured asynchronous JavaScript reply.

## Dart boundary scenarios

Six channel scenarios pass: asynchronous JS replies/handler removal, default
media denial, app-facing navigation callback identity, JSON/error propagation,
disposal and native-cookie host/path filtering. These are transport contracts;
they do not replace ArkTS compilation or device acceptance.
