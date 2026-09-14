/// Reads version constants from tool/versions.dart and updates all README.md
/// files that contain hardcoded version strings.
///
/// Usage:
///     dart run tool/update_readmes.dart
import 'dart:io';

import 'versions.dart' as v;

void main() {
  final root = Directory.current.path;

  final updates = <String, List<RegExpReplacement>>{};

  // 1. Root README and umbrella README: ^4.6.0 → ^{packageVersion}
  final readmeFiles = [
    '$root/README.md',
    '$root/zikzak_inappwebview/README.md',
  ];

  for (final path in readmeFiles) {
    final file = File(path);
    if (!file.existsSync()) continue;

    var content = file.readAsStringSync();

    // Update zikzak_inappwebview install snippet version
    content = content.replaceAllMapped(
      RegExp(r'(zikzak_inappwebview:\s*\^)\d+\.\d+\.\d+'),
      (m) => '${m.group(1)}$packageVersion',
    );

    file.writeAsStringSync(content);
    updates[path] = [RegExpReplacement()];
  }

  // 2. AGENTS.md — fix the stale "6.0.0" / "^4.6.0" note
  final agentsMd = File('$root/AGENTS.md');
  if (agentsMd.existsSync()) {
    var content = agentsMd.readAsStringSync();
    content = content.replaceAllMapped(
      RegExp(r'Every package is at `[\d.]+`, but `README\.md` still tells consumers to install `\^[\d.]+`\.'),
      (m) =>
          'Every package is at `$packageVersion`, and README installation snippets match.',
    );
    agentsMd.writeAsStringSync(content);
    updates['$root/AGENTS.md'] = [RegExpReplacement()];
  }

  print('Updated ${updates.length} files:');
  for (final path in updates.keys) {
    print('  $path');
  }
  if (updates.isEmpty) {
    print('  (no changes needed)');
  }
}
