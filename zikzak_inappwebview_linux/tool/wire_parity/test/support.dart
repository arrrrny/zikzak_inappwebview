import 'dart:async' show ZoneSpecification, runZoned;
import 'dart:io' show Platform;
import 'dart:typed_data' show TypedData;

import 'package:flutter/foundation.dart' show TargetPlatform, debugDefaultTargetPlatformOverride;
import 'package:flutter_test/flutter_test.dart';

/// Known encoding differences between upstream and zikzak. Every entry names
/// the adapter in lib/src/util/wire.dart that resolves it, or says why none is
/// needed. A diff is printed as `DIFF <label>@<path>`; see [isExplainedBy]
/// for how keys match.
const knownDifferences = <String, String>{
  // Encode: Dart -> native.
  'UserScript.defaultWorld@contentWorld':
      'userScriptToWire: fills contentWorld with {name: page} when the script has none (upstream always sends it)',
  'HttpAuthResponse.action@action':
      'none needed: zikzak sends `action` as an int (CANCEL=0, PROCEED=1, USE_SAVED_HTTP_AUTH_CREDENTIALS=2), which is what '
          'linux/types/http_auth_response.cc:19 parses. Upstream omits it on Linux (its native value is null there), so with '
          'upstream every response is CANCEL; zikzak keeps `action`, which must not be dropped',
  'ClientCertResponse.action@selectedCertificate':
      'clientCertResponseToWire: adds `selectedCertificate: -1` (zikzak has no such field; -1 is the native default, '
          'linux/types/client_cert_response.cc:8)',
  'ScreenshotConfiguration.compressFormat@compressFormat':
      'screenshotConfigurationToWire: drops `compressFormat` (upstream sends none on Linux; native never reads it)',
  'WebViewEnvironmentSettings':
      'none: Linux has no WebViewEnvironment (see README Known gaps); this is a Linux-only upstream type, zikzak lacks cacheModel and '
          'the other upstream-only keys, and sends virtualHostMappings that Linux native ignores',
  'URLRequest@assumesHTTP3Capable':
      'none needed: iOS-only key zikzak has no field for; Linux native never reads it',
  'AttributedString':
      'none needed: zikzak encodes underlineStyle/strikethroughStyle/textEffect as enum names, upstream as ints/camelCase names; '
          'only PullToRefreshSettings.attributedTitle carries it and linux/ never reads it',
  'PermissionResponse.resource':
      'none needed: upstream encodes every resource except PROTECTED_MEDIA_ID as null on Linux and zikzak as null too; '
          'linux/types/permission_response.cc:22 only accepts int items, so neither reaches native',
  'InAppWebViewSettings.contentInsetAdjustmentBehavior':
      'inAppWebViewSettingsToWire / inAppWebViewSettingsFromWire: iOS-only key, zikzak sends/decodes the enum name, upstream an int (getSettings decode throws on the int); Linux native never reads or sends it, so it is dropped in both directions',
  'InAppWebViewSettings.selectionGranularity':
      'inAppWebViewSettingsToWire / inAppWebViewSettingsFromWire: iOS-only key, zikzak sends/decodes the enum name, upstream an int (getSettings decode throws on the int); Linux native never reads or sends it, so it is dropped in both directions',
  'InAppWebViewSettings.iframeReferrerPolicy':
      'inAppWebViewSettingsToWire / inAppWebViewSettingsFromWire: web-only key, zikzak sends the enum name, upstream the HTTP token (no-referrer), and zikzak\'s decoder throws on the token; Linux native never reads or sends it, so it is dropped in both directions',
  'InAppWebViewSettings.defaultVideoPoster':
      'none needed: zikzak encodes the Uint8List as a List<int> (upstream: Uint8List); Android-only key, Linux native never reads it',
  // Decode: native -> Dart.
  'NavigationAction.navigationType@sourceFrame.name': 'none needed: zikzak FrameInfo has no name/frameId; native sends no frame info (linux/types/navigation_action.cc)',
  'NavigationAction.navigationType@sourceFrame.frameId': 'none needed: see sourceFrame.name',
  'NavigationAction.navigationType@targetFrame.name': 'none needed: see sourceFrame.name',
  'NavigationAction.navigationType@targetFrame.frameId': 'none needed: see sourceFrame.name',
  'PermissionRequest.resource@frame.name': 'none needed: native always sends frame null (linux/types/permission_request.cc:19)',
  'PermissionRequest.resource@frame.frameId': 'none needed: native always sends frame null (linux/types/permission_request.cc:19)',
  'PermissionRequest.resource@resources':
      'permissionRequestFromWire: native sends resources as ints (permission_request.cc:11) but zikzak decodes ints only on iOS/macOS, '
          'so they would be dropped on Linux; the adapter maps the ints to PermissionResourceType',
  'FindSession.searchResultDisplayStyle@!throws':
      'findSessionFromWire: zikzak requires searchResultDisplayStyle as an enum name; the adapter supplies it (native does not send it) '
          'and maps an int',
  'FindSession.nativeShape@!throws':
      'findSessionFromWire: native sends only resultCount/highlightedResultIndex (find_session.cc:16); zikzak\'s decoder throws without '
          'searchResultDisplayStyle, so the adapter fills in a default',
  'WebResourceError.type@type':
      'webResourceErrorFromWire: native sends WebKit/WPE error codes (100-499, 1-64, ...), which zikzak\'s WebResourceErrorType decoder '
          'does not know and turns into null; the adapter maps native code -> zikzak type',
  'URLProtectionSpace.authenticationMethod@authenticationMethod':
      'none: lost, see README Known gaps; native sends NSURLAuthenticationMethod* strings (url_protection_space.cc:11-25) and zikzak\'s decoder '
          'loses the HTTPBasic/HTTPDigest/HTMLForm/Default ones',
  'ClientCertChallenge':
      'none: lost, see README Known gaps; zikzak drops isProxy, allowedCertificateAuthorities and mutuallyTrustedCertificates, '
          'all of which native sends (client_cert_challenge.cc:37-41), and no adapter recovers isProxy',
  'InAppWebViewSettings.withEnumKeys@!throws':
      'none needed: upstream sends selectionGranularity etc. as ints, zikzak decodes enum names; native getSettings never sends those iOS/web-only keys',
  'WebArchiveFormat.WEBARCHIVE':
      'none needed: WEBARCHIVE is iOS-only and has no native value on Linux (upstream encodes it as null); zikzak sends "webarchive", only MHT is meaningful',
  'WebArchiveFormat.fromNative.WEBARCHIVE': 'none needed: see WebArchiveFormat.WEBARCHIVE',
  'WebMessage.withPorts@!throws':
      'webMessageFromWire: zikzak\'s WebMessage.fromJson throws when `ports` holds maps (it expects IWebMessagePort objects); '
          'the adapter builds WebMessage from data/type only, as native never sends ports',
  'SslCertificate':
      'none needed: native always sends sslCertificate null (url_protection_space.cc:52); zikzak\'s SslCertificate.fromMap requires x509Certificate '
          'bytes and swallows the error otherwise',
  'InAppBrowserSettings.windowType@windowType':
      'none needed: zikzak sends the enum name (WINDOW/CHILD/TABBED) which linux/in_app_browser/in_app_browser_settings.cc:69 '
          'parses via windowTypeFromString; upstream sends none on Linux, so CHILD only works with zikzak',
};

final diffs = <String>[];

/// Set `WIRE_PARITY_VERBOSE=1` to print both encodings under every DIFF line.
final bool _verbose = Platform.environment['WIRE_PARITY_VERBOSE'] == '1';

/// A diff `label@path` is explained by key `Root` (the label is `Root` or
/// `Root.something`, any path) or by key `Root@path` (same, and that path).
bool isExplainedBy(String diff, String key) {
  final at = diff.indexOf('@');
  final label = diff.substring(0, at);
  final path = diff.substring(at + 1);
  final keyAt = key.indexOf('@');
  final keyRoot = keyAt < 0 ? key : key.substring(0, keyAt);
  if (!(label == keyRoot || label.startsWith('$keyRoot.'))) return false;
  return keyAt < 0 || key.substring(keyAt + 1) == path;
}

/// Registers the per-file check that every difference is listed.
void registerParityCheck() {
  // Upstream's native values and zikzak's permission encoding depend on the
  // platform; flutter_test defaults to android, so pin it to linux.
  setUp(() => debugDefaultTargetPlatformOverride = TargetPlatform.linux);
  tearDown(() => debugDefaultTargetPlatformOverride = null);
  tearDownAll(() {
    final unexplained = diffs.where((d) => !knownDifferences.keys.any((k) => isExplainedBy(d, k))).toList();
    expect(unexplained, isEmpty, reason: 'Each difference needs an adapter in lib/src/util/wire.dart and an entry in knownDifferences');
  });
}

/// Drops null-valued keys and sorts keys, recursively through maps and lists.
/// Leaf values and list types are left untouched so [firstDifference] can
/// compare them strictly.
Object? normValue(Object? v) => v is Map
    ? norm(v)
    : v is List && v is! TypedData
        ? v.map(normValue).toList(growable: false)
        : v;

Map<String, dynamic> norm(Map<dynamic, dynamic> m) {
  final keys = [for (final e in m.entries) if (e.value != null) e.key.toString()]..sort();
  return {for (final k in keys) k: normValue(m[k])};
}

/// Collects every difference between [a] and [b] as `path -> description`.
/// Strict: `2` vs `"2"`, `true` vs `"true"`, `4` vs `4.0` and `List<int>` vs
/// `Uint8List` all differ. Paths are dotted keys, with `[i]` for list items
/// (`''` for the root).
void collectDifferences(Object? a, Object? b, String path, Map<String, String> out) {
  String sub(String k) => path.isEmpty ? k : '$path.$k';
  if (a is Map || b is Map) {
    if (a is! Map || b is! Map) {
      out[path] = '${a.runtimeType} vs ${b.runtimeType}';
      return;
    }
    for (final k in {...a.keys, ...b.keys}) {
      collectDifferences(a[k], b[k], sub('$k'), out);
    }
    return;
  }
  if (a is List || b is List) {
    if (a is! List || b is! List) {
      out[path] = '${a.runtimeType} vs ${b.runtimeType}';
      return;
    }
    // Generic arguments (List<String> vs List<dynamic>) do not matter on the
    // wire, but typed data (Uint8List) vs a plain list does.
    if ((a is TypedData || b is TypedData) && a.runtimeType != b.runtimeType) {
      out[path] = '${a.runtimeType} vs ${b.runtimeType}';
      return;
    }
    if (a.length != b.length) {
      out[path] = 'length ${a.length} vs ${b.length}';
      return;
    }
    for (var i = 0; i < a.length; i++) {
      collectDifferences(a[i], b[i], '$path[$i]', out);
    }
    return;
  }
  if (a.runtimeType != b.runtimeType) {
    out[path] = '$a (${a.runtimeType}) vs $b (${b.runtimeType})';
  } else if (a != b) {
    out[path] = '$a vs $b';
  }
}

/// Compares two encodings; records and prints one `DIFF <label>@<path>` line
/// per differing path (null-valued keys and key order are ignored).
void expectSame(String type, Object? upstream, Object? zikzak) {
  final a = upstream is Map ? norm(upstream) : upstream;
  final b = zikzak is Map ? norm(zikzak) : zikzak;
  final found = <String, String>{};
  collectDifferences(a, b, '', found);
  for (final e in found.entries) {
    diffs.add('$type@${e.key}');
    // ignore: avoid_print
    print('DIFF $type@${e.key}: ${e.value}');
  }
  if (found.isNotEmpty && _verbose) {
    // ignore: avoid_print
    print('  upstream: $a\n  zikzak:   $b');
  }
}

String _un(Object? e) => (e as dynamic).name() as String;
String _zn(Object? e) => (e as Enum).name;

/// Encodes one object once per value of one enum field and compares each
/// encoding. Values are matched by name; a value zikzak lacks shows up as
/// `<missing>`. [buildU] / [buildZ] must set every other field to a
/// non-default value and return the encoded map.
void enumVariants<U, Z>(
  String label,
  Iterable<U> uv,
  Iterable<Z> zv,
  Object? Function(U) buildU,
  Object? Function(Z) buildZ,
) {
  for (final x in uv) {
    final y = zv.where((e) => _zn(e) == _un(x));
    expectSame('$label.${_un(x)}', buildU(x), y.isEmpty ? '<missing>' : buildZ(y.first));
  }
}

/// Decode direction: [upstreamMap] is what upstream's `toMap()` produces, i.e.
/// the payload shape upstream's native code emits. It is fed to zikzak's
/// decoder via [roundTrip] (`Type.fromJson(map).toJson()`); anything the
/// decoder loses or changes shows up as a DIFF, as does a decoder that throws.
void decode(String label, Map<dynamic, dynamic> upstreamMap, Object? Function(Map<String, dynamic>) roundTrip) {
  Object? result;
  // zikzak's decoders sometimes print and swallow their own exceptions; keep
  // that out of the test output and report it with the DIFF instead.
  final printed = <String>[];
  try {
    result = runZoned(
      () => roundTrip(Map<String, dynamic>.from(upstreamMap)),
      zoneSpecification: ZoneSpecification(print: (self, parent, zone, line) => printed.add(line)),
    );
  } catch (e) {
    final msg = e.toString().replaceAll('\n', ' ');
    diffs.add('$label@!throws');
    // ignore: avoid_print
    print('DIFF $label@!throws: ${msg.length > 220 ? msg.substring(0, 220) : msg}');
    return;
  }
  if (printed.isNotEmpty) {
    diffs.add('$label@!printed');
    // ignore: avoid_print
    print('DIFF $label@!printed: decoder swallowed an error: ${printed.first.split('\n').first}');
  }
  expectSame(label, upstreamMap, result);
}

/// [decode] once per upstream enum value; [build] returns the upstream map
/// with every other field set.
void decodeVariants<U>(String label, Iterable<U> values, Map<dynamic, dynamic> Function(U) build, Object? Function(Map<String, dynamic>) roundTrip) {
  for (final v in values) {
    decode('$label.${_un(v)}', build(v), roundTrip);
  }
}
