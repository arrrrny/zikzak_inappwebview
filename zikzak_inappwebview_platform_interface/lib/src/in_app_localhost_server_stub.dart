/// Stub implementation for platforms where dart:io is unavailable (Web, WASM).
///
/// InAppLocalhostServer is a native-only feature (it binds a TCP socket via
/// `dart:io`'s `HttpServer`). On Web/WASM this stub is used instead,
/// providing the same API surface but throwing [UnsupportedError] at runtime.
library zikzak_inappwebview_platform_interface.src.in_app_localhost_server_stub;

import 'package:flutter/foundation.dart';
import 'platform_in_app_localhost_server.dart';

/// Object specifying creation parameters for creating a [DefaultInAppLocalhostServer].
@immutable
class DefaultInAppLocalhostServerCreationParams
    extends PlatformInAppLocalhostServerCreationParams {
  const DefaultInAppLocalhostServerCreationParams(
    PlatformInAppLocalhostServerCreationParams params,
  ) : super();

  factory DefaultInAppLocalhostServerCreationParams.fromPlatformInAppLocalhostServerCreationParams(
    PlatformInAppLocalhostServerCreationParams params,
  ) {
    return DefaultInAppLocalhostServerCreationParams(params);
  }
}

///{@macro zikzak_inappwebview_platform_interface.PlatformInAppLocalhostServer}
class DefaultInAppLocalhostServer extends PlatformInAppLocalhostServer {
  bool _started = false;

  @override
  int get port => throw UnsupportedError(
    'InAppLocalhostServer is not supported on the Web or WASM platforms.',
  );

  @override
  String get directoryIndex => throw UnsupportedError(
    'InAppLocalhostServer is not supported on the Web or WASM platforms.',
  );

  @override
  String get documentRoot => throw UnsupportedError(
    'InAppLocalhostServer is not supported on the Web or WASM platforms.',
  );

  @override
  bool get shared => throw UnsupportedError(
    'InAppLocalhostServer is not supported on the Web or WASM platforms.',
  );

  DefaultInAppLocalhostServer(PlatformInAppLocalhostServerCreationParams params)
    : super.implementation(
        params is DefaultInAppLocalhostServerCreationParams
            ? params
            : DefaultInAppLocalhostServerCreationParams.fromPlatformInAppLocalhostServerCreationParams(
                params,
              ),
      );

  @override
  Future<void> start() async {
    throw UnsupportedError(
      'InAppLocalhostServer is not supported on the Web or WASM platforms. '
      'It requires dart:io (HttpServer), which is unavailable here.',
    );
  }

  @override
  Future<void> close() async {
    throw UnsupportedError(
      'InAppLocalhostServer is not supported on the Web or WASM platforms.',
    );
  }

  @override
  bool isRunning() => _started;
}
