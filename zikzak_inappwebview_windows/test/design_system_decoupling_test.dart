import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

/// Regression guard for issue #392 — decoupled design systems support.
///
/// Flutter is decoupling the Material and Cupertino libraries from the
/// framework: the in-framework libraries are frozen and will eventually be
/// deprecated and removed, while the standalone `pkg:material_ui` and
/// `pkg:cupertino_ui` packages are their live contributable replacements
/// (https://flutter.dev/blog/decoupling-material-cupertino).
///
/// A plugin must therefore not import `package:flutter/material.dart` or
/// `package:flutter/cupertino.dart`, so apps that migrate to the standalone
/// design-system packages with `dart fix` — and apps built after the
/// framework removal — keep compiling and working against this plugin.
/// Imports of the core `flutter/widgets.dart` / `flutter/painting.dart` /
/// `flutter/foundation.dart` / `flutter/services.dart` libraries are fine:
/// the decoupling effort explicitly keeps strengthening those.
///
/// This test walks every `.dart` file under `lib/` and asserts none of them
/// carries an `import`/`export` directive referencing the in-framework
/// design-system libraries. Both plain and conditional directives
/// (`import '...' if (...) '...'`) are covered.
void main() {
  test(
    'lib/ never imports the in-framework material/cupertino design systems',
    () {
      final libDir = Directory.fromUri(Directory.current.uri.resolve('lib'));
      expect(
        libDir.existsSync(),
        isTrue,
        reason:
            'lib/ not found under ${Directory.current.path} — the test must '
            'run from the package root (flutter test does this by default).',
      );

      const bannedUris = [
        'package:flutter/material.dart',
        'package:flutter/cupertino.dart',
      ];

      // Matches `import '...'` / `export '...'` directives at the start of a
      // line, allowing leading whitespace, and collects the URI literals of
      // the base directive plus every alternative in a conditional directive.
      final directivePattern = RegExp(
        r"""^\s*(?:import|export)\s+['"][^'"]+['"](?:\s+if\s*\([^)]*\)\s+['"][^'"]+['"])*""",
        multiLine: true,
      );
      final uriPattern = RegExp(r"""['"]([^'"]+)['"]""");

      final offenders = <String>[];
      var filesScanned = 0;
      var directivesChecked = 0;

      for (final entity in libDir.listSync(recursive: true)) {
        if (entity is! File || !entity.path.endsWith('.dart')) continue;
        filesScanned++;
        final content = entity.readAsStringSync();
        for (final match in directivePattern.allMatches(content)) {
          for (final uriMatch in uriPattern.allMatches(match.group(0)!)) {
            final uri = uriMatch.group(1)!;
            directivesChecked++;
            if (bannedUris.contains(uri)) {
              offenders.add('${entity.path}: $uri');
            }
          }
        }
      }

      // Sanity: the walker must actually have scanned the package sources.
      // If this fires, the test was run from an unexpected working directory
      // and checked nothing (a silent pass would be worse than a failure).
      expect(filesScanned, greaterThan(1));

      expect(
        offenders,
        isEmpty,
        reason:
            'Found ${offenders.length} reference(s) to the in-framework '
            'material/cupertino libraries while checking $directivesChecked '
            'directive(s) in $filesScanned Dart files under lib/ (issue #392: '
            'these libraries are frozen in the framework and decoupled into '
            'the standalone pkg:material_ui / pkg:cupertino_ui packages — '
            'import them no longer so apps on the decoupled design systems '
            'keep compiling). Offending directives:\n'
            '${offenders.join('\n')}',
      );
    },
  );
}
