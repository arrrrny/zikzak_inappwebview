/// Centralized version constants for the zikzak_inappwebview monorepo.
///
/// Single source of truth for all published-package versions and key
/// dependency versions. The [updateReadmes] script reads this file and
/// rewrites README references automatically — never hand-edit a version
/// string in a README; update it here and re-run:
///
///     dart run tool/update_readmes.dart
library;

/// All zikzak_inappwebview published-package versions.
///
/// Every package in the monorepo ships the same version number.
/// Update once here; the prepare_for_publish.sh script propagates it.
const String packageVersion = '6.0.2';

/// Key third-party dependency versions that appear in README installation
/// snippets and should stay in sync across the project.
const String zorphyVersion = '2.4.0';
const String zorphyAnnotationVersion = '2.4.0';
const String zuraffaVersion = '6.3.0';
const String zuraffaFlutterVersion = '6.3.0';
const String zuraffaSessionVersion = '6.3.0';
