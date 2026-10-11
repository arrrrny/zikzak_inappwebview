// Local relying party host for the passkey test page.
//
// Serves three things over plain HTTP on localhost:
//
//   GET /                                          -> passkey_demo/index.html
//   GET /.well-known/apple-app-site-association    -> the AASA for the host app
//   GET /apple-app-site-association                -> same document (legacy path)
//
// Passkeys in a WKWebView only work for a relying party the host app holds a
// validated `webcredentials` association for, so the AASA has to be reachable
// at the very origin the page is served from. Putting this server behind a
// TLS-terminating tunnel (see README) gives the page an https origin whose
// AASA we control.
//
// Usage:
//   dart run passkey_demo/server.dart --team-id ABCDE12345 --bundle-id com.example.example
//   dart run passkey_demo/server.dart --port 8787

import 'dart:convert';
import 'dart:io';

const _defaultPort = 8080;

Future<void> main(List<String> args) async {
  final port = _intArg(args, '--port') ?? _defaultPort;
  final teamId = _stringArg(args, '--team-id') ?? Platform.environment['PASSKEY_TEAM_ID'];
  final bundleId =
      _stringArg(args, '--bundle-id') ?? Platform.environment['PASSKEY_BUNDLE_ID'];

  final page = File('${_scriptDir()}/index.html');
  if (!page.existsSync()) {
    stderr.writeln('page not found: ${page.path}');
    exitCode = 1;
    return;
  }

  final aasa = _appleAppSiteAssociation(teamId, bundleId);

  final server = await HttpServer.bind(InternetAddress.loopbackIPv4, port);
  stdout
    ..writeln('passkey test host listening on http://localhost:${server.port}/')
    ..writeln('  page     : ${page.path}')
    ..writeln('  app id   : ${teamId ?? '<unset>'}.${bundleId ?? '<unset>'}')
    ..writeln('  aasa     : ${jsonEncode(aasa)}');

  await for (final request in server) {
    final path = request.uri.path;
    stdout.writeln('${request.method} $path');
    try {
      switch (path) {
        case '/':
        case '/index.html':
          request.response
            ..headers.contentType = ContentType.html
            ..headers.set('Cache-Control', 'no-store')
            ..write(await page.readAsString());
        case '/.well-known/apple-app-site-association':
        case '/apple-app-site-association':
          request.response
            ..headers.contentType = ContentType.json
            ..headers.set('Cache-Control', 'no-store')
            ..write(jsonEncode(aasa));
        default:
          request.response.statusCode = HttpStatus.notFound;
          request.response.write('not found');
      }
    } catch (e) {
      request.response.statusCode = HttpStatus.internalServerError;
      request.response.write('$e');
    } finally {
      await request.response.close();
    }
  }
}

Map<String, Object?> _appleAppSiteAssociation(String? teamId, String? bundleId) {
  if (teamId == null || bundleId == null) return <String, Object?>{};
  return <String, Object?>{
    'webcredentials': <String, Object?>{
      'apps': <String>['$teamId.$bundleId'],
    },
  };
}

String _scriptDir() {
  final self = Platform.script;
  if (self.scheme != 'file') return Directory.current.path;
  return File.fromUri(self).parent.path;
}

String? _stringArg(List<String> args, String name) {
  final i = args.indexOf(name);
  if (i == -1 || i + 1 >= args.length) return null;
  return args[i + 1];
}

int? _intArg(List<String> args, String name) => int.tryParse(_stringArg(args, name) ?? '');
