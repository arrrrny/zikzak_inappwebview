// Regression for #249 / #255 / #257.
//
// Published zikzak_inappwebview_platform_interface 5.0.1 shipped a stale
// relative `import '../in_app_webview_settings.dart';` in
// `lib/src/in_app_webview/modules/platform_settings_delegate.dart`. That
// relative path resolved against `lib/src/in_app_webview/modules/` to
// `lib/src/in_app_webview/in_app_webview_settings.dart` — the PRE-migration
// location, which the Zorphy migration had already moved away from. The
// published artifact was therefore un-importable: every consumer of
// `zikzak_inappwebview_platform_interface: ^5.0.0` failed to compile with
//
//   Error when reading
//   '.../zikzak_inappwebview_platform_interface-5.0.1/lib/src/in_app_webview/
//    in_app_webview_settings.dart': No such file or directory
//   import '../in_app_webview_settings.dart';
//
// The source on `master` was already corrected (the file imports the
// settings entity from its new home under
// `lib/src/domain/entities/in_app_webview_settings/`) and the fix shipped
// in 5.1.0. The existing delegate compile-time probe
// (`in_app_webview_controller_delegates_test.dart`) catches a missing type
// but does NOT catch the case where the package still compiles locally
// (e.g. because a stale copy of the file is sitting at the old path) yet
// ships a broken tarball. This test reads the source directly and asserts:
//
//   1. the canonical settings entity file lives at its migrated location;
//   2. the pre-migration settings file location is GONE (so no stale
//      relative import could ever silently resolve again);
//   3. platform_settings_delegate.dart carries the canonical import line;
//   4. platform_settings_delegate.dart does NOT carry the stale
//      pre-migration relative import (single or double quoted);
//   5. no `.dart` file under `lib/` carries ANY relative import that
//      resolves to the pre-migration settings path — a sweep that catches
//      the same class of bug in any other module file.
//
// Together these guard against a future Zorphy re-migration or codegen
// pass dropping the file (or an import) back at the old location and
// reshipping the 5.0.1 break.

import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

/// Resolve a path relative to the package root (the CWD when `flutter test`
/// runs the suite).
Uri _pkgRootUri() => Uri.directory(Directory.current.path);

File _fileFromPackagePath(String relativePath) =>
    File.fromUri(_pkgRootUri().resolve(relativePath));

// Canonical settings entity file — the post-migration home.
final File _settingsEntityFile = _fileFromPackagePath(
  'lib/src/domain/entities/in_app_webview_settings/in_app_webview_settings.dart',
);

// The settings delegate whose broken import shipped in 5.0.1.
final File _delegateFile = _fileFromPackagePath(
  'lib/src/in_app_webview/modules/platform_settings_delegate.dart',
);

// The PRE-migration settings file location. Must NOT exist; a stale
// relative import like `import '../in_app_webview_settings.dart';` issued
// from any file under `lib/src/in_app_webview/` would resolve here.
final File _preMigrationSettingsFile = _fileFromPackagePath(
  'lib/src/in_app_webview/in_app_webview_settings.dart',
);

// A regex that matches a Dart `import` directive and captures the path
// string. Handles single OR double quotes; tolerates leading whitespace
// and a `configurable-uri`-style `if (cond) '...'` clause (the captured
// path is always the FIRST quoted string after `import`). Uses a
// triple-quoted raw string so both `'` and `"` can appear inside.
final RegExp _importDirective = RegExp(
  r"""^\s*import\s+['"]([^'"]+)['"]""",
  multiLine: true,
);

void main() {
  group('InAppWebViewSettings source layout (regression #249/#255/#257)', () {
    test('the settings entity lives at the canonical migrated path', () {
      expect(
        _settingsEntityFile.existsSync(),
        isTrue,
        reason:
            'lib/src/domain/entities/in_app_webview_settings/in_app_webview_settings.dart '
            'must exist — the Zorphy migration moved the entity here, and every '
            'relative import of InAppWebViewSettings depends on this location.',
      );
    });

    test('the pre-migration settings file location is gone', () {
      expect(
        _preMigrationSettingsFile.existsSync(),
        isFalse,
        reason:
            'lib/src/in_app_webview/in_app_webview_settings.dart must NOT exist — '
            'a stale relative import like `import "../in_app_webview_settings.dart";` '
            'issued from lib/src/in_app_webview/modules/ would silently resolve '
            'against this file and reship the 5.0.1 publish-time break.',
      );
    });

    test(
      'platform_settings_delegate.dart imports the canonical migrated path',
      () {
        expect(
          _delegateFile.existsSync(),
          isTrue,
          reason:
              'lib/src/in_app_webview/modules/platform_settings_delegate.dart '
              'must exist (it is the settings-delegate facade for '
              'PlatformInAppWebViewController).',
        );
        final src = _delegateFile.readAsStringSync();

        // The canonical import line, exactly as the fixed source carries it.
        const canonicalImport =
            "import '../../domain/entities/in_app_webview_settings/in_app_webview_settings.dart';";
        expect(
          src.contains(canonicalImport),
          isTrue,
          reason:
              'platform_settings_delegate.dart must import InAppWebViewSettings '
              "from the canonical migrated path. Expected to find: "
              '$canonicalImport',
        );

        // The stale pre-migration relative import that shipped in 5.0.1.
        // Reject it in EITHER single-quote or double-quote form.
        const staleSingle =
            "import '../in_app_webview_settings.dart';";
        const staleDouble =
            'import "../in_app_webview_settings.dart";';
        expect(
          src.contains(staleSingle),
          isFalse,
          reason:
              'platform_settings_delegate.dart must NOT carry the stale '
              "pre-migration relative import `import '../in_app_webview_settings.dart';` "
              '— that import shipped in published 5.0.1 and broke every consumer of '
              'zikzak_inappwebview_platform_interface ^5.0.0.',
        );
        expect(
          src.contains(staleDouble),
          isFalse,
          reason:
              'platform_settings_delegate.dart must NOT carry the stale '
              'pre-migration relative import (double-quote variant) either.',
        );
      },
    );

    test(
      'no .dart file under lib/ imports the pre-migration settings path',
      () {
        final libDir = Directory.fromUri(_pkgRootUri().resolve('lib'));
        expect(
          libDir.existsSync(),
          isTrue,
          reason: 'lib/ must exist — this is a Dart package.',
        );

        final staleImports = <String>[];
        for (final entity in libDir.listSync(recursive: true)) {
          if (entity is! File) continue;
          if (!entity.path.endsWith('.dart')) continue;

          final src = entity.readAsStringSync();
          final importerUri = entity.uri;

          for (final match in _importDirective.allMatches(src)) {
            final rawPath = match.group(1)!;
            // Package imports are absolute; only relative imports can
            // accidentally resolve to a stale in-repo path.
            if (rawPath.startsWith('package:')) continue;
            if (rawPath.startsWith('dart:')) continue;

            // Only consider imports that touch the settings entity file.
            if (!rawPath.endsWith('in_app_webview_settings.dart')) continue;

            final resolved = importerUri.resolve(rawPath);
            if (resolved.toString() ==
                _preMigrationSettingsFile.uri.toString()) {
              staleImports.add(
                '${entity.path}: import \'$rawPath\' -> $resolved',
              );
            }
          }
        }

        expect(
          staleImports,
          isEmpty,
          reason:
              'No .dart file under lib/ may carry a relative import that '
              'resolves to lib/src/in_app_webview/in_app_webview_settings.dart '
              '(the pre-migration settings location). Stale imports found:\n'
              '  - ${staleImports.join('\n  - ')}',
        );
      },
    );
  });
}
