import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

/// Regression guard for issue #257.
///
/// `zikzak_inappwebview_platform_interface` 5.0.1 shipped
/// `lib/src/in_app_webview/modules/platform_settings_delegate.dart` with
///
///     import '../in_app_webview_settings.dart';
///
/// — a file that did not exist (the class lives under
/// `lib/src/domain/entities/in_app_webview_settings/`). Every consumer of
/// the published package failed to compile with
///
///     Error: Error when reading '.../in_app_webview_settings.dart':
///     No such file or directory
///     Type 'InAppWebViewSettings' not found.
///
/// The analyzer reports `uri_does_not_exist` for such directives, but no
/// test surface caught it before the package was published, because the
/// broken file is only reachable through the consumer's build.
///
/// This test walks every `.dart` file under `lib/` and asserts that every
/// relative `import`/`export`/`part` URI resolves to a real file, so a
/// dangling relative import can never ship to pub.dev again.
void main() {
  test(
    'every relative import/export/part URI in lib/ resolves to a real file',
    () {
      final libDir = Directory.fromUri(Directory.current.uri.resolve('lib'));
      expect(
        libDir.existsSync(),
        isTrue,
        reason:
            'lib/ not found under ${Directory.current.path} — the test must '
            'run from the package root (flutter test does this by default).',
      );

      final dangling = <String>[];
      var filesScanned = 0;
      var directivesChecked = 0;

      // Matches `import '...'`, `export '...'`, `part '...'` (also with
      // double quotes) at the start of a line, allowing leading whitespace.
      // `part of '...'` is intentionally not matched: after `part ` the
      // regex requires a quote, and a `part of` directive targets the
      // owning library, which exists by construction.
      final directivePattern = RegExp(
        r"""^\s*(?:import|export|part)\s+['"]([^'"]+)['"]""",
        multiLine: true,
      );

      for (final entity in libDir.listSync(recursive: true)) {
        if (entity is! File || !entity.path.endsWith('.dart')) continue;
        filesScanned++;
        final content = entity.readAsStringSync();
        for (final match in directivePattern.allMatches(content)) {
          final uri = match.group(1)!;
          // `dart:` and `package:` URIs are resolved by the SDK / pub, not
          // by the filesystem layout checked here.
          if (uri.startsWith('dart:') || uri.startsWith('package:')) continue;
          directivesChecked++;
          final targetPath = entity.uri.resolve(uri).toFilePath();
          if (!File(targetPath).existsSync()) {
            dangling.add(
              '${entity.path}: $uri -> $targetPath (missing)',
            );
          }
        }
      }

      // Sanity: the walker must actually have scanned the package sources.
      // If this fires, the test was run from an unexpected working directory
      // and checked nothing (a silent pass would be worse than a failure).
      expect(filesScanned, greaterThan(100));

      expect(
        dangling,
        isEmpty,
        reason:
            'Found ${dangling.length} dangling relative URI(s) while checking '
            '$directivesChecked directives in $filesScanned Dart files under '
            'lib/. The analyzer would report "Target of URI doesn\'t exist" '
            '(issue #257 regression — a broken import previously shipped to '
            'pub.dev in 5.0.1). Offending directives:\n'
            '${dangling.join('\n')}',
      );
    },
  );
}
