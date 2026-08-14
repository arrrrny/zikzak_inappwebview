import 'package:flutter_test/flutter_test.dart';
import 'package:zikzak_inappwebview/zikzak_inappwebview.dart';

/// Compile-time assertion that [T] implements the [Disposable] interface.
///
/// If a wrapper class ever drops `implements Disposable`, this file stops
/// compiling, so `flutter analyze` and `flutter test` both fail.
void expectDisposable<T extends Disposable>() {}

/// Probe implementing [Disposable] with the canonical signature:
/// `void dispose({bool isKeepAlive = false})`.
///
/// If the interface ever drifts (for example the named parameter is
/// renamed or its type changes), this override stops being a valid
/// implementation and the file no longer compiles.
class _ProbeDisposable implements Disposable {
  @override
  void dispose({bool isKeepAlive = false}) {}
}

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
      // Compile-time probe: tearing dispose off through the [Disposable]
      // interface type must yield exactly the canonical type
      // `void Function({bool isKeepAlive})`. A drifted interface
      // declaration fails this assignment at compile time.
      final Disposable probe = _ProbeDisposable();
      final void Function({bool isKeepAlive}) dispose = probe.dispose;
      expect(dispose, isNotNull);
    });
  });
}
