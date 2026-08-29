import 'package:flutter_test/flutter_test.dart';
import 'package:zikzak_inappwebview/zikzak_inappwebview.dart';
import 'package:zikzak_inappwebview_platform_interface/zikzak_inappwebview_platform_interface.dart';

/// Inline fake of [PlatformInAppLocalhostServer] so the dispose behavior can be
/// exercised without a real platform/HttpServer. Tracks whether [close] was
/// invoked and lets the test control [isRunning].
class _FakePlatformLocalhostServer extends PlatformInAppLocalhostServer {
  _FakePlatformLocalhostServer()
      : super.implementation(const PlatformInAppLocalhostServerCreationParams());

  bool isRunningValue = false;
  int closeCallCount = 0;

  @override
  bool isRunning() => isRunningValue;

  @override
  Future<void> close() {
    closeCallCount++;
    return Future.value();
  }
}

void main() {
  group('InAppLocalhostServer dispose (US2-AC3, FR-003/008/009)', () {
    test('U15: dispose() on a non-running server marks it disposed and does not close it', () {
      final fake = _FakePlatformLocalhostServer();
      final server = InAppLocalhostServer.fromPlatform(fake);

      server.dispose();

      expect(server.disposed, isTrue,
          reason: 'dispose() must mark the server as disposed');
      expect(fake.closeCallCount, 0,
          reason: 'close() must not be called when the server is not running');
    });

    test('U14: dispose() on a running server closes it and marks it disposed', () {
      final fake = _FakePlatformLocalhostServer();
      fake.isRunningValue = true;
      final server = InAppLocalhostServer.fromPlatform(fake);

      server.dispose();

      expect(server.disposed, isTrue,
          reason: 'dispose() must mark the server as disposed');
      expect(fake.closeCallCount, 1,
          reason: 'close() must be called exactly once when the server is running');
    });
  });
}
