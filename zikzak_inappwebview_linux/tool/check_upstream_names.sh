#!/usr/bin/env bash
# Fails if upstream flutter_inappwebview names survive in lib/ or linux/,
# except the ones zikzak keeps on purpose.
set -euo pipefail
cd "$(dirname "$0")/.."
allowed='flutter_headless_inappwebview|flutterInAppWebViewPlatformReady|github\.com/pichillilorenzo|pub\.dev/packages/flutter_inappwebview|Copyright'
hits=$(grep -rnE 'pichillilorenzo|flutter_inappwebview|flutter_inappbrowser|FlutterInappwebview|FLUTTER_INAPPWEBVIEW' lib linux \
  | grep -vE "$allowed" || true)
if [ -n "$hits" ]; then
  echo "Upstream names left:"; echo "$hits" | head -50
  echo "($(echo "$hits" | wc -l) lines)"; exit 1
fi
echo "OK: no upstream names left"
