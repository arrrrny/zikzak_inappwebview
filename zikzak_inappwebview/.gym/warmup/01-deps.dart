/// GYM warmup rep #1 — resolve the federated plugin dependencies.
///
/// zikzak_inappwebview is a federated Flutter plugin: its dependency
/// graph (`flutter: sdk: flutter`, sibling platform packages) resolves
/// through the Flutter tool. This rep runs `flutter pub get` and asserts
/// the produced `.dart_tool/package_config.json` references the plugin
/// root package AND a platform implementation package — proving the
/// federated graph actually resolved. Fails fast with a clear setup
/// error (never a misleading grade) when the Flutter SDK is absent.
///
/// Run from the plugin package root:
/// `dart run .gym/warmup/01-deps.dart`
///
/// A mis-fire (unexpected outcome, not a clean failure) is a DROP CARD —
/// see github.com/arrrrny/drop-card.
library;

import 'dart:io';

/// Entry point for warmup rep #1.
Future<void> main() async {
  final pubspec = File('pubspec.yaml');
  if (!pubspec.existsSync()) {
    stderr.writeln(
      'No pubspec.yaml in cwd=${Directory.current.path} — run this rep '
      'from the zikzak_inappwebview package root.',
    );
    exit(1);
  }

  final ProcessResult result;
  try {
    result = await Process.run('flutter', ['pub', 'get']);
  } on ProcessException catch (e) {
    stderr.writeln(
      'REP FAIL: 01-deps — the Flutter SDK is required to resolve this '
      'federated plugin (flutter pub get) but is not on PATH: $e.\n'
      'This is a setup error, not a grade. Install Flutter (>=3.38.6) '
      'and re-run.',
    );
    exit(1);
  }

  if (result.exitCode != 0) {
    stderr.writeln(
      'REP FAIL: 01-deps — `flutter pub get` exited ${result.exitCode}',
    );
    stderr.writeln(result.stdout);
    stderr.writeln(result.stderr);
    exit(result.exitCode == 0 ? 1 : result.exitCode);
  }

  final pkgConfig = File('.dart_tool/package_config.json');
  if (!pkgConfig.existsSync()) {
    stderr.writeln(
      'REP FAIL: 01-deps — pub get exited 0 but .dart_tool/'
      'package_config.json is missing. Mis-fire — drop a card: '
      'github.com/arrrrny/drop-card',
    );
    exit(1);
  }

  final configText = pkgConfig.readAsStringSync();
  if (!configText.contains('"name":"zikzak_inappwebview"') &&
      !configText.contains('"name": "zikzak_inappwebview"')) {
    stderr.writeln(
      'REP FAIL: 01-deps — package_config.json does not reference the '
      '`zikzak_inappwebview` root package. Mis-fire — drop a card.',
    );
    exit(1);
  }
  if (!configText.contains('zikzak_inappwebview_android')) {
    stderr.writeln(
      'REP FAIL: 01-deps — the federated graph did not resolve a '
      'platform implementation package (zikzak_inappwebview_android '
      'absent from package_config.json). Mis-fire — drop a card.',
    );
    exit(1);
  }

  stdout.writeln('REP OK: 01-deps — federated plugin dependencies '
      'resolved.');
}
