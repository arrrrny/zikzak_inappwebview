# OpenHarmony ArkWeb platform

Tracking: [#462](https://github.com/arrrrny/zikzak_inappwebview/issues/462).

The core platform package owns native rendering and transport. Applications use
the existing inline-view, controller and cookie factories without replacing
their Dart backend during an OHOS build. No application-specific authentication,
navigation allowlist or permission policy belongs in the plugin.

1. Register an unendorsed OHOS platform package compatible with interface 6.4+.
2. Preserve the first requested document across native view initialization.
   Controller attachment must not race the component's declarative initial URL.
3. Preserve JavaScript JSON results and asynchronous handler replies, including
   native failures and handler removal. A disposed controller cannot send work.
4. Apply document scripts and runtime settings before acknowledging completion.
5. Read and mutate the system cookie jar, preserving HttpOnly attributes,
   host-only/domain boundaries and same-name path variants.
6. Deny media/geolocation access unless the application callback grants it;
   system permissions remain the application's responsibility.
7. Limit asynchronous navigation vetoes to main-frame GET requests. Do not
   replay POSTs without their bodies or subframes without their frame identity.
8. Keep unsupported APIs explicit; initial scope excludes browser windows,
   headless/adopted views, isolated content worlds, proxy and CDP capture.

Device acceptance lives in
`zikzak_inappwebview_ohos/example/integration_test/arkweb_test.dart`;
Dart channel contracts live in the package's `test/arkweb_contract_test.dart`.
