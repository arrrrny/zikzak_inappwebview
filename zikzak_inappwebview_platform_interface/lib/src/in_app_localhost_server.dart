// Conditional export: real implementation on native (dart:io available),
// stub on Web/WASM (dart:io unavailable).
export 'in_app_localhost_server_stub.dart'
    if (dart.library.io) 'in_app_localhost_server_native.dart';
