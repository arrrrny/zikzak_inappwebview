/// Reads version constants from tool/versions.dart and updates all README.md
/// files that contain hardcoded version strings.
///
/// Usage:
///     dart run tool/update_readmes.dart
import 'dart:io';

import 'versions.dart' as v;

void main() {
  final root = Directory.current.path;

  final updates = <String>[];

  // 1. Root README and umbrella README: ^4.6.0 → ^{packageVersion}
  final readmeFiles = [
    '$root/README.md',
    '$root/zikzak_inappwebview/README.md',
  ];

  for (final path in readmeFiles) {
    final file = File(path);
    if (!file.existsSync()) continue;

    final content = file.readAsStringSync();

    // Update zikzak_inappwebview install snippet version
    final updated = content.replaceAllMapped(
      RegExp(r'(zikzak_inappwebview:\s*\^)\d+\.\d+\.\d+'),
      (m) => '${m.group(1)}${v.packageVersion}',
    );

    if (updated != content) file.writeAsStringSync(updated);
    updates.add(path);
  }

  // 2. AGENTS.md — keep the recorded package version in sync
  final agentsMd = File('$root/AGENTS.md');
  if (agentsMd.existsSync()) {
    final content = agentsMd.readAsStringSync();
    final updated = content.replaceAllMapped(
      RegExp(r'Every package is at `[\d.]+`, and README installation snippets match\.'),
      (m) =>
          'Every package is at `${v.packageVersion}`, and README installation snippets match.',
    );
    if (updated != content) agentsMd.writeAsStringSync(updated);
    updates.add('$root/AGENTS.md');
  }

  print('Checked ${updates.length} files:');
  for (final path in updates) {
    print('  $path');
  }
  if (updates.isEmpty) {
    print('  (no files to check)');
  }
}
