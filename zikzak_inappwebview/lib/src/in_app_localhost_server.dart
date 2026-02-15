import 'dart:async';
import 'package:zikzak_inappwebview_platform_interface/zikzak_inappwebview_platform_interface.dart';

///{@macro zikzak_inappwebview_platform_interface.PlatformInAppLocalhostServer}
class InAppLocalhostServer {
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
              shared: shared),
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
}
