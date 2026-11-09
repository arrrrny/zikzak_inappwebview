#!/usr/bin/env bash
# Applies zikzak's names to upstream flutter_inappwebview_linux sources.
# Idempotent; rerun after importing a newer upstream release.
set -euo pipefail
cd "$(dirname "$0")/.."

mvf() { [ -e "$1" ] && git mv "$1" "$2" 2>/dev/null || { [ -e "$1" ] && mv "$1" "$2"; } || true; }
mvf lib/flutter_inappwebview_linux.dart lib/zikzak_inappwebview_linux.dart
mvf linux/flutter_inappwebview_linux_plugin.cc linux/zikzak_inappwebview_linux_plugin.cc
mvf linux/flutter_inappwebview_linux_plugin_private.h linux/zikzak_inappwebview_linux_plugin_private.h
mvf linux/include/flutter_inappwebview_linux linux/include/zikzak_inappwebview_linux
mvf linux/include/zikzak_inappwebview_linux/flutter_inappwebview_linux_plugin.h \
    linux/include/zikzak_inappwebview_linux/zikzak_inappwebview_linux_plugin.h
mvf linux/test/flutter_inappwebview_linux_plugin_test.cc linux/test/zikzak_inappwebview_linux_plugin_test.cc

files=$(grep -rlE 'pichillilorenzo|flutter_inappwebview|flutter_inappbrowser|FlutterInappwebview|FLUTTER_INAPPWEBVIEW' lib linux || true)
[ -z "$files" ] && exit 0
# Order matters: specific rules first, then the generic ones.
sed -i -E \
  -e 's#package:flutter_inappwebview_platform_interface/flutter_inappwebview_platform_interface\.dart#package:zikzak_inappwebview_platform_interface/zikzak_inappwebview_platform_interface.dart#g' \
  -e 's#package:flutter_inappwebview_linux/#package:zikzak_inappwebview_linux/#g' \
  -e 's#com\.pichillilorenzo/flutter_headless_inappwebview#wtf.zikzak/flutter_headless_inappwebview#g' \
  -e 's#com\.pichillilorenzo/flutter_inappwebview#wtf.zikzak/zikzak_inappwebview#g' \
  -e 's#com\.pichillilorenzo/flutter_inappbrowser#wtf.zikzak/zikzak_inappbrowser#g' \
  -e 's#com\.pichillilorenzo/#wtf.zikzak/#g' \
  -e 's#com\.pichillilorenzo\.flutter_inappwebview#wtf.zikzak.zikzak_inappwebview#g' \
  -e 's#_JAVASCRIPT_BRIDGE_NAME = "flutter_inappwebview"#_JAVASCRIPT_BRIDGE_NAME = "zikzak_inappwebview"#g' \
  -e 's#window\._flutter_inappwebview_windowId#window._zikzak_inappwebview_windowId#g' \
  -e 's#window\.flutter_inappwebview#window.zikzak_inappwebview#g' \
  -e 's#_flutter_inappwebview_#_zikzak_inappwebview_#g' \
  -e 's#flutter_inappwebview_value#zikzak_inappwebview_value#g' \
  -e 's#namespace flutter_inappwebview_plugin#namespace zikzak_inappwebview#g' \
  -e 's#flutter_inappwebview_plugin::#zikzak_inappwebview::#g' \
  -e 's#flutter_inappwebview_linux_plugin#zikzak_inappwebview_linux_plugin#g' \
  -e 's#FlutterInappwebviewLinuxPlugin#ZikzakInappwebviewLinuxPlugin#g' \
  -e 's#FLUTTER_INAPPWEBVIEW_LINUX_PLUGIN#ZIKZAK_INAPPWEBVIEW_LINUX_PLUGIN#g' \
  -e 's#FLUTTER_INAPPWEBVIEW_#ZIKZAK_INAPPWEBVIEW_#g' \
  -e 's#include/flutter_inappwebview_linux/#include/zikzak_inappwebview_linux/#g' \
  -e 's#flutter_inappwebview_linux#zikzak_inappwebview_linux#g' \
  -e 's#\[flutter_inappwebview\]#[zikzak_inappwebview]#g' \
  -e 's#"flutter_inappwebview"#"zikzak_inappwebview"#g' \
  -e 's#FlutterInappwebviewWindowsPlugin#ZikzakInappwebviewWindowsPlugin#g' \
  -e 's#flutter_inappwebview_platform_interface#zikzak_inappwebview_platform_interface#g' \
  -e 's#flutter_inappwebview_content_rules#zikzak_inappwebview_content_rules#g' \
  -e "s#'flutter_inappwebview'#'zikzak_inappwebview'#g" \
  -e 's#`flutter_inappwebview`#`zikzak_inappwebview`#g' \
  -e 's#packages/flutter_inappwebview/#packages/zikzak_inappwebview/#g' \
  -e 's#/flutter_inappwebview([/"]|$)#/zikzak_inappwebview\1#g' \
  $files
