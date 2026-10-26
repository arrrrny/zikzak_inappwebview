#!/usr/bin/env bash
# Regenerates the native WebAuthn/passkey JS shim (PluginScriptsJS/PasskeysJS.swift)
# in BOTH platform packages from the single canonical source:
#   zikzak_inappwebview_platform_interface/lib/src/web_authentication/passkeys_js_source.dart
#
# Issues #358 (macOS) and #384 (iOS): the shim overrides navigator.credentials
# — a security- and correctness-critical surface that must never drift between
# the two native copies. Edit the canonical Dart source, run this script,
# commit both rendered files. The source-contract suites pin all three copies
# identical:
#   zikzak_inappwebview_ios/test/passkey_bridge_test.dart
#   zikzak_inappwebview_macos/test/passkey_bridge_test.dart
set -euo pipefail

REPO_ROOT="$(cd "$(dirname "$0")/.." && pwd)"
CANONICAL="$REPO_ROOT/zikzak_inappwebview_platform_interface/lib/src/web_authentication/passkeys_js_source.dart"
TARGET_MACOS="$REPO_ROOT/zikzak_inappwebview_macos/macos/zikzak_inappwebview_macos/Sources/zikzak_inappwebview_macos/PluginScriptsJS/PasskeysJS.swift"
TARGET_IOS="$REPO_ROOT/zikzak_inappwebview_ios/ios/zikzak_inappwebview_ios/Sources/zikzak_inappwebview_ios/PluginScriptsJS/PasskeysJS.swift"

[ -f "$CANONICAL" ] || { echo "canonical shim source missing: $CANONICAL" >&2; exit 1; }

REPO_ROOT="$REPO_ROOT" CANONICAL="$CANONICAL" \
TARGET_MACOS="$TARGET_MACOS" TARGET_IOS="$TARGET_IOS" python3 <<'PYEOF'
import os

BS = chr(92)
Q3 = chr(39) * 3

dart = open(os.environ['CANONICAL']).read()
open_marker = 'const String passkeysJsSource = r' + Q3
open_idx = dart.index(open_marker) + len(open_marker)
body_start = dart.index(chr(10), open_idx) + 1
close_idx = dart.index(chr(10) + Q3, body_start)
body = dart[body_start:close_idx]
assert '$javascriptBridgeName' in body, 'placeholder missing from canonical body'
assert '(JAVASCRIPT_BRIDGE_NAME)' not in body, 'canonical must carry the placeholder, not Swift interpolation'

NL = chr(10)
header_lines = [
    '//',
    '//  PasskeysJS.swift',
    '//  zikzak_inappwebview',
    '//',
    '//  GENERATED FILE - do not edit by hand.',
    '//  Rendered by scripts/generate_passkeys_shim.sh from the canonical',
    '//  zikzak_inappwebview_platform_interface passkeys_js_source.dart',
    '//  (issues #358 macOS, #384 iOS). Edit the canonical source and',
    '//  regenerate; hand edits fail the source-contract drift tests.',
    '//',
]
doc_lines = [
    '/// WebAuthn/passkey JS shim: overrides `navigator.credentials.create/get`',
    '/// for PublicKeyCredential options and forwards the ceremony over the',
    "/// plugin" + chr(39) + "s JS-handler channel to the native `PasskeyBridge`",
    '/// (ASAuthorizationController). Generated - see the file header.',
]

for target, is_ios in ((os.environ['TARGET_MACOS'], False), (os.environ['TARGET_IOS'], True)):
    lines = list(header_lines)
    lines.append('import UIKit' if is_ios else 'import Foundation')
    lines.append('import WebKit')
    lines.append('')
    lines.append('let PASSKEYS_JS_PLUGIN_SCRIPT_GROUP_NAME = "IN_APP_WEBVIEW_PASSKEYS_JS_PLUGIN_SCRIPT"')
    lines.append('')
    lines.extend(doc_lines)
    lines.append('let PASSKEYS_JS_SOURCE = """')
    for line in body.split(NL):
        # Named placeholder -> Swift interpolation, then escape the remaining
        # backslashes so the emitted JS bytes match the canonical exactly.
        line = line.replace('$javascriptBridgeName', BS + '(JAVASCRIPT_BRIDGE_NAME)')
        parts = [p.replace(BS, BS + BS) for p in line.split(BS + '(JAVASCRIPT_BRIDGE_NAME)')]
        lines.append((BS + '(JAVASCRIPT_BRIDGE_NAME)').join(parts))
    lines.append('"""')
    if is_ios:
        lines.append('')
        lines.append('let PASSKEYS_JS_PLUGIN_SCRIPT = PluginScript(')
        lines.append('    groupName: PASSKEYS_JS_PLUGIN_SCRIPT_GROUP_NAME,')
        lines.append('    source: PASSKEYS_JS_SOURCE,')
        lines.append('    injectionTime: .atDocumentStart,')
        lines.append('    forMainFrameOnly: false,')
        lines.append('    requiredInAllContentWorlds: false,')
        lines.append('    messageHandlerNames: [])')
    with open(target, 'w') as f:
        f.write(NL.join(lines) + NL)
    print('rendered', target)
PYEOF
