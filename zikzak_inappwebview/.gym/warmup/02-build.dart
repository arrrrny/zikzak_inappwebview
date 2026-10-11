/// GYM warmup rep #2 — compile the plugin.
///
/// Proves the plugin an operator is about to use actually compiles:
/// `dart analyze lib/` must report zero errors (the repo's pre-existing
/// lint-level issues elsewhere are tolerated; errors are not).
///
/// Run from the plugin package root:
/// `dart run .gym/warmup/02-build.dart`
///
/// A mis-fire (unexpected outcome, not a clean failure) is a DROP CARD —
/// see github.com/arrrrny/drop-card.
library;

import 'dart:io';

/// Entry point for warmup rep #2.
Future<void> main() async {
  final libDir = Directory('lib');
  if (!libDir.existsSync()) {
    stderr.writeln(
      'No lib/ in cwd=${Directory.current.path} — run this rep from the '
      'zikzak_inappwebview package root.',
    );
    exit(1);
  }

  final ProcessResult result;
  try {
    result = await Process.run('dart', ['analyze', 'lib/']);
  } on ProcessException catch (e) {
    stderr.writeln(
      'REP FAIL: 02-build — `dart analyze` could not run: $e.\n'
      'This is a setup error, not a grade.',
    );
    exit(1);
  }

  final out = '${result.stdout as String}${result.stderr as String}';
  if (out.contains(' error - ')) {
    stderr.writeln(
      'REP FAIL: 02-build — `dart analyze lib/` reports errors (the '
      'plugin does not compile):',
    );
    stderr.writeln(out);
    exit(1);
  }

  stdout.writeln('REP OK: 02-build — plugin lib/ compiles with zero '
      'errors.');
}
