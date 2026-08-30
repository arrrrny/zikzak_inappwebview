#!/usr/bin/env bash
# Automated structural gate: ensures no intelligence-layer code remains
# in the plugin core after the two-tier split.
#
# Spec: 003 (FR-006)
#
# Usage: bash scripts/grep_gate.sh
# Exit 0 = pass, exit 1 = fail

set -euo pipefail

CORE_DIR="zikzak_inappwebview/lib/src"

# Patterns that MUST NOT appear in the plugin core.
# These represent intelligence-layer identifiers.
PATTERNS=(
  "WebViewPool"
  "CaptureSource"
  "CassetteEngine"
  "DialogueDismissPort"
  "RecipePort"
  "NavigationTrackerPort"
  "VCRWrapper"
  "webview_pool"
  "capture_service"
  "cassette_engine"
)

# Carve-out: raw capture-event plumbing IS allowed in core.
# These patterns are permitted and excluded from the gate.
CARVEOUT_PATTERNS=(
  "network_capture_interceptor_js"
)

PASS=true

for pattern in "${PATTERNS[@]}"; do
  # Check if the pattern appears in dart files in the core
  matches=$(rg -l "$pattern" "$CORE_DIR" --type dart 2>/dev/null || true)

  if [ -n "$matches" ]; then
    # Check carve-outs
    for carveout in "${CARVEOUT_PATTERNS[@]}"; do
      if echo "$matches" | grep -q "$carveout"; then
        # This match is in a carved-out file — skip
        continue 2
      fi
    done
    echo "FAIL: '$pattern' found in core:"
    echo "$matches"
    PASS=false
  fi
done

# Also verify module does not import platform_interface directly
MODULE_DIR="zikzak_inappwebview_module/lib"
if [ -d "$MODULE_DIR" ]; then
  pi_imports=$(rg "zikzak_inappwebview_platform_interface" "$MODULE_DIR" --type dart 2>/dev/null || true)
  if [ -n "$pi_imports" ]; then
    echo "FAIL: module imports platform_interface directly:"
    echo "$pi_imports"
    PASS=false
  fi
fi

if [ "$PASS" = true ]; then
  echo "PASS: no intelligence-layer code in plugin core."
  exit 0
else
  echo ""
  echo "Grep gate FAILED — see violations above."
  exit 1
fi
