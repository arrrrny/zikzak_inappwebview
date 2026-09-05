import 'dart:async';
import 'package:zikzak_inappwebview_platform_interface/zikzak_inappwebview_platform_interface.dart';
import 'dispose_lifecycle.dart';

///{@macro zikzak_inappwebview_platform_interface.PlatformInAppLocalhostServer}
class InAppLocalhostServer implements Disposable {
  ///{@macro zikzak_inappwebview_platform_interface.PlatformInAppLocalhostServer}
  InAppLocalhostServer({
    int port = 8080,
    String directoryIndex = 'index.html',
    String documentRoot = './',
    bool shared = false,
  }) : this.fromPlatformCreationParams(
         PlatformInAppLocalhostServerCreationParams(
           port: port,
           directoryIndex: directoryIndex,
           documentRoot: documentRoot,
           shared: shared,
         ),
       );

  /// Constructs a [InAppLocalhostServer] from creation params for a specific
  /// platform.
  InAppLocalhostServer.fromPlatformCreationParams(
    PlatformInAppLocalhostServerCreationParams params,
  ) : this.fromPlatform(PlatformInAppLocalhostServer(params));

  /// Constructs a [InAppLocalhostServer] from a specific platform
  /// implementation.
  InAppLocalhostServer.fromPlatform(this.platform);

  /// Implementation of [PlatformInAppLocalhostServer] for the current platform.
  final PlatformInAppLocalhostServer platform;

  ///{@macro zikzak_inappwebview_platform_interface.PlatformInAppLocalhostServer.port}
  int get port => platform.port;

  ///{@macro zikzak_inappwebview_platform_interface.PlatformInAppLocalhostServer.directoryIndex}
  String get directoryIndex => platform.directoryIndex;

  ///{@macro zikzak_inappwebview_platform_interface.PlatformInAppLocalhostServer.documentRoot}
  String get documentRoot => platform.documentRoot;

  ///{@macro zikzak_inappwebview_platform_interface.PlatformInAppLocalhostServer.shared}
  bool get shared => platform.shared;

  ///{@macro zikzak_inappwebview_platform_interface.PlatformInAppLocalhostServer.start}
  Future<void> start() => platform.start();

  ///{@macro zikzak_inappwebview_platform_interface.PlatformInAppLocalhostServer.close}
  Future<void> close() => platform.close();

  ///{@macro zikzak_inappwebview_platform_interface.PlatformInAppLocalhostServer.isRunning}
  bool isRunning() => platform.isRunning();

  /// KeepAlive-aware disposal lifecycle (bug #295); see [dispose].
  DisposeLifecycle _lifecycle = DisposeLifecycle.notDisposed;

  /// Indicates if the server has been disposed.
  ///
  /// `true` once [dispose] has been called at least once, including a
  /// keepAlive dispose; a later plain `dispose()` completes the release
  /// lifecycle (bug #295, FR-007).
  bool get disposed => _lifecycle != DisposeLifecycle.notDisposed;

  /// Disposes the server, stopping it if it is still running,
  /// and releasing its resources.
  ///
  /// After disposal, this instance cannot be used anymore.
  ///
  /// KeepAlive-aware disposal guard (bug #295): disposal is a three-state
  /// lifecycle ([DisposeLifecycle.notDisposed] / [DisposeLifecycle.keepAliveHeld]
  /// / [DisposeLifecycle.released]). Per FR-011/U17 the [isKeepAlive] flag has
  /// no effect on server behavior — a running server is stopped on the first
  /// dispose either way — but the guard only swallows *identical* repeats
  /// (a repeat keepAlive dispose, and any dispose once fully released,
  /// FR-008), so a later plain `dispose()` still completes the release
  /// lifecycle instead of being rejected as a duplicate.
  @override
  void dispose({bool isKeepAlive = false}) {
    if (_lifecycle == DisposeLifecycle.released ||
        (_lifecycle == DisposeLifecycle.keepAliveHeld && isKeepAlive)) {
      return;
    }
    _lifecycle = isKeepAlive
        ? DisposeLifecycle.keepAliveHeld
        : DisposeLifecycle.released;
    if (isRunning()) {
      // Fire-and-forget (dispose is synchronous): swallow a rejected
      // close() future so it cannot surface as an unhandled async error.
      unawaited(close().catchError((_) {}));
    }
  }
}
