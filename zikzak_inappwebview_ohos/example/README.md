# ArkWeb device acceptance

Create the native shell with the OHOS Flutter SDK:

```sh
flutter create --platforms=ohos .
flutter pub get
```

Set the OHOS product's compatible/target SDK to API 23 or newer, declare Internet
permission and configure device signing in DevEco Studio. Then run:

```sh
flutter test integration_test/arkweb_test.dart -d <ohos-device> --concurrency=2
```

The test uses the registered production factories and the real ArkWeb engine.
Its inline HTML is a local fixture, with reserved `.invalid` origins; it does not
visit a real account or service. It checks first-document script ordering,
asynchronous JS handler results, JSON evaluation, HttpOnly/path-scoped cookies,
runtime user-agent updates and cancelled navigation. Device execution is
separate from the Dart-only channel contract tests.
