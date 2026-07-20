import 'dart:io';
import 'dart:async';
import 'dart:typed_data';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:flutter/widgets.dart';

import 'mime_type_resolver.dart';
import 'platform_in_app_localhost_server.dart';

/// Object specifying creation parameters for creating a [DefaultInAppLocalhostServer].
///
/// When adding additional fields make sure they can be null or have a default
/// value to avoid breaking changes. See [PlatformInAppLocalhostServerCreationParams] for
/// more information.
@immutable
class DefaultInAppLocalhostServerCreationParams
    extends PlatformInAppLocalhostServerCreationParams {
  /// Creates a new [DefaultInAppLocalhostServerCreationParams] instance.
  const DefaultInAppLocalhostServerCreationParams(
    // This parameter prevents breaking changes later.
    // ignore: avoid_unused_constructor_parameters
    PlatformInAppLocalhostServerCreationParams params,
  ) : super();

  /// Creates a [DefaultInAppLocalhostServerCreationParams] instance based on [PlatformInAppLocalhostServerCreationParams].
  factory DefaultInAppLocalhostServerCreationParams.fromPlatformInAppLocalhostServerCreationParams(
    PlatformInAppLocalhostServerCreationParams params,
  ) {
    return DefaultInAppLocalhostServerCreationParams(params);
  }
}

///{@macro zikzak_inappwebview_platform_interface.PlatformInAppLocalhostServer}
class DefaultInAppLocalhostServer extends PlatformInAppLocalhostServer {
  bool _started = false;
  HttpServer? _server;
  int _port = 8080;
  bool _shared = false;
  String _directoryIndex = 'index.html';
  String _documentRoot = './';
  AppLifecycleListener? _appLifecycleListener;
  Completer<void>? _bindCompleter;

  /// Creates a new [DefaultInAppLocalhostServer].
  DefaultInAppLocalhostServer(PlatformInAppLocalhostServerCreationParams params)
    : super.implementation(
        params is DefaultInAppLocalhostServerCreationParams
            ? params
            : DefaultInAppLocalhostServerCreationParams.fromPlatformInAppLocalhostServerCreationParams(
                params,
              ),
      ) {
    this._port = params.port;
    this._directoryIndex = params.directoryIndex;
    this._documentRoot = (params.documentRoot.endsWith('/'))
        ? params.documentRoot
        : '${params.documentRoot}/';
    this._shared = params.shared;
  }

  @override
  int get port => _port;

  @override
  String get directoryIndex => _directoryIndex;

  @override
  String get documentRoot => _documentRoot;

  @override
  bool get shared => _shared;

  @override
  Future<void> start() async {
    if (_started) {
      throw Exception('Server already started on http://localhost:$_port');
    }
    if (_bindCompleter != null) {
      return _bindCompleter!.future;
    }

    _started = true;
    _bindCompleter = Completer<void>();
    _registerLifecycleListener();

    try {
      _server = await HttpServer.bind('127.0.0.1', _port, shared: _shared);
      print('Server running on http://localhost:' + _port.toString());

      _server!.listen((HttpRequest request) async {
        Uint8List body = Uint8List(0);

        var path = request.requestedUri.path;
        path = (path.startsWith('/')) ? path.substring(1) : path;
        path += (path.endsWith('/')) ? _directoryIndex : '';
        if (path == '') {
          // if the path still empty, try to load the index file
          path = _directoryIndex;
        }
        path = _documentRoot + path;

        try {
          body = (await rootBundle.load(
            Uri.decodeFull(path),
          )).buffer.asUint8List();
        } catch (e) {
          print(Uri.decodeFull(path));
          print(e.toString());
          request.response.close();
          return;
        }

        var contentType = ContentType('text', 'html', charset: 'utf-8');
        if (!request.requestedUri.path.endsWith('/') &&
            request.requestedUri.pathSegments.isNotEmpty) {
          final mimeType = MimeTypeResolver.lookup(request.requestedUri.path);
          if (mimeType != null) {
            contentType = _getContentTypeFromMimeType(mimeType);
          }
        }

        request.response.headers.contentType = contentType;
        request.response.add(body);
        request.response.close();
      });
    } finally {
      _bindCompleter!.complete();
      _bindCompleter = null;
    }
  }

  void _registerLifecycleListener() {
    _appLifecycleListener?.dispose();
    _appLifecycleListener = AppLifecycleListener(onResume: _onResume);
  }

  void _onResume() {
    if (_server != null) {
      // After the app resumes from background, the underlying socket may no
      // longer be valid. Close the server and reset the state so the user
      // can restart it.
      _server!.close(force: true).catchError((_) {});
      _server = null;
      _started = false;
    }
  }

  @override
  Future<void> close() async {
    _appLifecycleListener?.dispose();
    _appLifecycleListener = null;
    if (_bindCompleter != null) {
      await _bindCompleter!.future;
    }
    if (_server == null) return;
    await _server!.close(force: true);
    print('Server running on http://localhost:$_port closed');
    _started = false;
    _server = null;
  }

  @override
  bool isRunning() {
    return this._server != null;
  }

  ContentType _getContentTypeFromMimeType(String mimeType) {
    final contentType = mimeType.split('/');
    String? charset;

    if (_isTextFile(mimeType)) {
      charset = 'utf-8';
    }

    return ContentType(contentType[0], contentType[1], charset: charset);
  }

  bool _isTextFile(String mimeType) {
    final textFile = RegExp(r'^text\/|^application\/(javascript|json)');
    return textFile.hasMatch(mimeType);
  }
}
