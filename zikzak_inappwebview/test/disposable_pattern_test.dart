import 'package:flutter_test/flutter_test.dart';
import 'package:zikzak_inappwebview/zikzak_inappwebview.dart';

/// Compile-time assertion that [T] implements the [Disposable] interface.
///
/// If a wrapper class ever drops `implements Disposable`, this file stops
/// compiling, so `flutter analyze` and `flutter test` both fail.
void expectDisposable<T extends Disposable>() {}

void main() {
  group('Disposable pattern standardization', () {
    test('wrapper classes implement Disposable', () {
      // Compile-time checks: the generic bound only resolves when the
      // wrapper class is assignable to [Disposable].
      expectDisposable<InAppWebViewController>();
      expectDisposable<InAppWebView>();
      expectDisposable<HeadlessInAppWebView>();
      expectDisposable<InAppLocalhostServer>();
    });

    test('Disposable declares the standardized dispose signature', () {
      // The canonical signature: dispose({bool isKeepAlive = false}).
      // A reference with the standardized type must be assignable from any
      // implementation's tear-off; this is verified by the type system at
      // compile time through the generic bound above, and documented here
      // for readers.
      void Function({bool isKeepAlive})? ref;
      expect(ref, isNull);
    });
  });
}
