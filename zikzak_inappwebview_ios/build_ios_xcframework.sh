#!/usr/bin/env bash
#
# build_ios_xcframework.sh
# -----------------------
# Rebuilds a universal XCFramework for the
# `zikzak_inappwebview_ios` plugin that is compatible with
# modern SDKs (iOS 17 / 18, macOS 15, visionOS, …) by ensuring
# no obsolete Swift overlay dylibs are referenced.
#
# Usage:
#   chmod +x build_ios_xcframework.sh
#   ./build_ios_xcframework.sh
#
# Requirements:
#   • Xcode 15 (or newer) with its command-line tools selected
#   • This script must be run from the plugin’s root directory:
#       zikzak_inappwebview/zikzak_inappwebview_ios
#
# The resulting XCFramework is written to:
#   dist/zikzak_inappwebview_ios.xcframework
# and can then be committed and referenced in the podspec.
set -euo pipefail

###############################################################################
# Configuration – adjust if necessary
###############################################################################
SCHEME="zikzak_inappwebview_ios"
CONFIGURATION="Release"

# Where the intermediate .xcarchive bundles will be placed
ARCHIVE_DIR="build/archives"

# Final XCFramework location
OUTPUT_DIR="dist"
OUTPUT_XCFRAMEWORK="$OUTPUT_DIR/${SCHEME}.xcframework"

# SDK identifiers
IOS_SDK="iphoneos"
SIMULATOR_SDK="iphonesimulator"

# Minimum supported iOS version. Keep this in sync with the podspec.
MIN_IOS_VERSION="13.0"

###############################################################################
# Helpers
###############################################################################
function msg() {
  echo -e "\033[1;34m› $1\033[0m"
}

###############################################################################
# Clean up any previous build artefacts
###############################################################################
msg "Cleaning previous build artefacts…"
rm -rf "$ARCHIVE_DIR" "$OUTPUT_XCFRAMEWORK"

###############################################################################
# Build for physical devices
###############################################################################
msg "Archiving device slice (${IOS_SDK})…"
xcodebuild archive \
  -scheme "$SCHEME" \
  -configuration "$CONFIGURATION" \
  -sdk "$IOS_SDK" \
  -archivePath "$ARCHIVE_DIR/device" \
  SKIP_INSTALL=NO \
  BUILD_LIBRARY_FOR_DISTRIBUTION=YES \
  IPHONEOS_DEPLOYMENT_TARGET="$MIN_IOS_VERSION"

###############################################################################
# Build for simulators
###############################################################################
msg "Archiving simulator slice (${SIMULATOR_SDK})…"
xcodebuild archive \
  -scheme "$SCHEME" \
  -configuration "$CONFIGURATION" \
  -sdk "$SIMULATOR_SDK" \
  -archivePath "$ARCHIVE_DIR/simulator" \
  SKIP_INSTALL=NO \
  BUILD_LIBRARY_FOR_DISTRIBUTION=YES \
  IPHONEOS_DEPLOYMENT_TARGET="$MIN_IOS_VERSION"

###############################################################################
# Create XCFramework
###############################################################################
msg "Creating XCFramework…"
mkdir -p "$OUTPUT_DIR"
xcodebuild -create-xcframework \
  -framework "$ARCHIVE_DIR/device.xcarchive/Products/Library/Frameworks/${SCHEME}.framework" \
  -framework "$ARCHIVE_DIR/simulator.xcarchive/Products/Library/Frameworks/${SCHEME}.framework" \
  -output "$OUTPUT_XCFRAMEWORK"

###############################################################################
# Verification: ensure no Swift overlay dylibs remain
###############################################################################
msg "Verifying that no obsolete Swift overlays are linked…"
if otool -L "$OUTPUT_XCFRAMEWORK/ios-arm64/${SCHEME}.framework/${SCHEME}" \
    | grep -q "/usr/lib/swift/libswift"; then
  echo "❌  ERROR: Swift overlay dylibs found – build invalid."
  exit 1
fi

msg "✅  XCFramework successfully generated at:"
echo "   $OUTPUT_XCFRAMEWORK"
