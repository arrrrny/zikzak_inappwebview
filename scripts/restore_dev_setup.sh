#!/bin/bash
# ZikZak InAppWebView 2.0.0
# -------------------------
# restore_dev_mode.sh
#
# This script converts all package dependencies to path dependencies
# for local development, making it easier to develop and test changes
# across multiple packages simultaneously.
#

echo "🔥 ZikZak InAppWebView - Restoring Development Mode 🔥"
echo "Converting all dependencies to path dependencies..."

# Root directory of the project
ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
echo "Root directory: $ROOT_DIR"

# Function to update pubspec.yaml for development mode
update_for_dev_mode() {
  local package_dir=$1
  local pubspec_file="$package_dir/pubspec.yaml"
  local path_prefix="../"

  if [[ "$package_dir" == *"/example" ]]; then
    path_prefix="../../"
  fi

  if [ ! -f "$pubspec_file" ]; then
    echo "⚠️ Pubspec file not found at $pubspec_file"
    return
  fi

  echo "Processing $pubspec_file (depth prefix: $path_prefix)"

  # Uncomment any commented path dependencies for dev_dependencies
  sed -i.tmp -E "s|^    #([ ]+path: $path_prefix"zikzak_inappwebview".*)[ ]#[ ]Commented for publishing|\1|g" "$pubspec_file"

  # Also convert versioned dev_dependencies to path dependencies
  awk -v prefix="$path_prefix" '
  BEGIN {
    in_dev_dependencies = 0;
    packages["zikzak_inappwebview_platform_interface"] = 1;
    packages["zikzak_inappwebview_internal_annotations"] = 1;
    packages["zikzak_inappwebview_android"] = 1;
    packages["zikzak_inappwebview_ios"] = 1;
    packages["zikzak_inappwebview_web"] = 1;
    packages["zikzak_inappwebview_macos"] = 1;
    packages["zikzak_inappwebview_windows"] = 1;
    packages["zikzak_inappwebview_linux"] = 1;
  }

  # Track when we enter dev_dependencies section
  /^dev_dependencies:/ {
    in_dev_dependencies = 1;
    print;
    next;
  }

  # Convert versioned dependencies to path in dev_dependencies
  in_dev_dependencies && /^  zikzak_inappwebview/ {
    pkg_name = $1;
    sub(/:$/, "", pkg_name);

    if (packages[pkg_name]) {
      # If this is a package we care about, and its a versioned dep (not already path-based)
      if ($0 !~ /path:/) {
        print "  " pkg_name ":";
        print "    path: " prefix pkg_name;
        getline; # Skip the version line if there is one
        next;
      }
    }
  }

  # Reset flag when leaving dev_dependencies section
  in_dev_dependencies && /^[a-zA-Z]/ && !/^  / {
    in_dev_dependencies = 0;
  }

  # Print all other lines unchanged
  { print }
  ' "$pubspec_file" > "${pubspec_file}.new"

  # Only move the new file if it was created successfully
  if [ -s "${pubspec_file}.new" ]; then
    mv "${pubspec_file}.new" "$pubspec_file"
  else
    echo "⚠️ Warning: awk processing failed for $pubspec_file"
  fi

  sed -i.tmp -E "s|zikzak_inappwebview_internal_annotations: \\^[0-9]+\\.[0-9]+\\.[0-9]+|zikzak_inappwebview_internal_annotations:\\n    path: ${path_prefix}zikzak_inappwebview_internal_annotations|g" "$pubspec_file"

  # Replace zikzak_inappwebview_platform_interface dependency
  sed -i.tmp -E "s|zikzak_inappwebview_platform_interface: \\^[0-9]+\\.[0-9]+\\.[0-9]+|zikzak_inappwebview_platform_interface:\\n    path: ${path_prefix}zikzak_inappwebview_platform_interface|g" "$pubspec_file"

  # Replace android dependency
  sed -i.tmp -E "s|zikzak_inappwebview_android: \\^[0-9]+\\.[0-9]+\\.[0-9]+|zikzak_inappwebview_android:\\n    path: ${path_prefix}zikzak_inappwebview_android|g" "$pubspec_file"

  # Replace iOS dependency
  sed -i.tmp -E "s|zikzak_inappwebview_ios: \\^[0-9]+\\.[0-9]+\\.[0-9]+|zikzak_inappwebview_ios:\\n    path: ${path_prefix}zikzak_inappwebview_ios|g" "$pubspec_file"

  # Replace web dependency
  sed -i.tmp -E "s|zikzak_inappwebview_web: \\^[0-9]+\\.[0-9]+\\.[0-9]+|zikzak_inappwebview_web:\\n    path: ${path_prefix}zikzak_inappwebview_web|g" "$pubspec_file"

  # Replace macos dependency
  sed -i.tmp -E "s|zikzak_inappwebview_macos: \\^[0-9]+\\.[0-9]+\\.[0-9]+|zikzak_inappwebview_macos:\\n    path: ${path_prefix}zikzak_inappwebview_macos|g" "$pubspec_file"

  # Replace windows dependency
  sed -i.tmp -E "s|zikzak_inappwebview_windows: \\^[0-9]+\\.[0-9]+\\.[0-9]+|zikzak_inappwebview_windows:\\n    path: ${path_prefix}zikzak_inappwebview_windows|g" "$pubspec_file"

  # Replace linux dependency
  sed -i.tmp -E "s|zikzak_inappwebview_linux: \\^[0-9]+\\.[0-9]+\\.[0-9]+|zikzak_inappwebview_linux:\\n    path: ${path_prefix}zikzak_inappwebview_linux|g" "$pubspec_file"

  # Clean up temporary files
  rm -f "${pubspec_file}.tmp"

  echo "✅ Updated $pubspec_file to use path dependencies"
}

# Process each package (v3.0: all platforms)
for package in zikzak_inappwebview zikzak_inappwebview_android zikzak_inappwebview_ios zikzak_inappwebview_web zikzak_inappwebview_macos zikzak_inappwebview_windows zikzak_inappwebview_linux zikzak_inappwebview_platform_interface; do
  if [ -d "$ROOT_DIR/$package" ]; then
    update_for_dev_mode "$ROOT_DIR/$package"
    # Also update example if it exists
    if [ -d "$ROOT_DIR/$package/example" ]; then
      update_for_dev_mode "$ROOT_DIR/$package/example"
    fi
  else
    echo "⚠️ Directory not found: $ROOT_DIR/$package"
  fi
done



# Run flutter pub get on all packages (v3.0: all platforms)
echo "Running 'flutter pub get' on all packages..."
for package in zikzak_inappwebview zikzak_inappwebview_platform_interface zikzak_inappwebview_android zikzak_inappwebview_ios zikzak_inappwebview_web zikzak_inappwebview_macos zikzak_inappwebview_windows zikzak_inappwebview_linux; do
  if [ -d "$ROOT_DIR/$package" ]; then
    echo "Getting dependencies for $package..."
    (cd "$ROOT_DIR/$package" && flutter pub get)
  fi
done

# Nuclear cleaning mode - Obliterate any caching issues that might persist
DEEP_CLEAN=false
if [[ "$1" == "-f" || "$1" == "--force" ]]; then
    DEEP_CLEAN=true
fi

echo ""
echo "🔥 INITIATING NUCLEAR CLEANING MODE 🔥"

if [ "$DEEP_CLEAN" = true ]; then
  echo "☢️ NUCLEAR CLEANING: PURGING ALL PUB CACHES ☢️"

  # Delete .dart_tool directories to force complete rebuild
  find "$ROOT_DIR" -name ".dart_tool" -type d -exec rm -rf {} +

  # Clean Flutter build directories
  find "$ROOT_DIR" -name "build" -type d -exec rm -rf {} +

  # Run package cache cleaning
  echo "Purging Dart pub cache..."
  dart pub cache clean --all

  # Run Flutter clean on each package (v3.0: all platforms)
  for package in zikzak_inappwebview zikzak_inappwebview_platform_interface zikzak_inappwebview_android zikzak_inappwebview_ios zikzak_inappwebview_web zikzak_inappwebview_macos zikzak_inappwebview_windows zikzak_inappwebview_linux; do
    if [ -d "$ROOT_DIR/$package" ]; then
      echo "Running flutter clean in $package..."
      (cd "$ROOT_DIR/$package" && flutter clean)
    fi
  done

  echo "🧨 NUCLEAR CLEANING COMPLETE! ALL CACHES OBLITERATED! 🧨"
fi

# Verify dev setup is correct
echo ""
echo "🔬 VERIFYING DEVELOPMENT SETUP 🔬"
verify_issues=0

# Verify each package has proper path dependencies (v3.0: all platforms)
for package in zikzak_inappwebview zikzak_inappwebview_android zikzak_inappwebview_ios zikzak_inappwebview_web zikzak_inappwebview_macos zikzak_inappwebview_windows zikzak_inappwebview_linux; do
  if [ -f "$ROOT_DIR/$package/pubspec.yaml" ]; then
    # Check that the package has path dependencies and NO versioned dependencies
    # More robust pattern matching for commented path dependencies
    commented_paths=$(grep "#.*path:.*\.\.\/zikzak_inappwebview.*# Commented for publishing" "$ROOT_DIR/$package/pubspec.yaml" 2>/dev/null | wc -l)

    # More robust pattern matching for versioned dependencies
    versioned_deps=$(grep "zikzak_inappwebview.*: \^[0-9]" "$ROOT_DIR/$package/pubspec.yaml" 2>/dev/null | wc -l)

    # Check if we actually have the expected path dependencies
    expected_deps=0
    missing_path_deps=0

    # Count ACTUAL path dependencies for zikzak packages
    actual_path_deps=$(grep "path:.*\.\.\/zikzak_inappwebview" "$ROOT_DIR/$package/pubspec.yaml" 2>/dev/null | wc -l)

    # Check if this is the main package that needs other dependencies
    if [ "$package" = "zikzak_inappwebview" ]; then
      # Main package should have several path dependencies to platform packages (v3.0: all platforms)
      expected_deps=6 # iOS, Android, Web, MacOS, Windows, Linux
      if [ "$actual_path_deps" -lt 6 ]; then
        missing_path_deps=1
      fi
    elif [[ "$package" = *"_android"* || "$package" = *"_ios"* || "$package" = *"_web"* || "$package" = *"_macos"* || "$package" = *"_windows"* || "$package" = *"_linux"* ]]; then
      # Platform packages need at least platform_interface
      expected_deps=1
      if [ "$actual_path_deps" -lt 1 ]; then
        missing_path_deps=1
      fi
    fi

    if [ "$commented_paths" -gt 0 ]; then
      echo "⚠️ WARNING: $package still has $commented_paths commented path dependencies!"
      verify_issues=$((verify_issues + 1))
    fi

    if [ "$versioned_deps" -gt 0 ]; then
      echo "⚠️ WARNING: $package still has $versioned_deps versioned dependencies!"
      verify_issues=$((verify_issues + 1))
    fi

    if [ "$missing_path_deps" -gt 0 ]; then
      echo "⚠️ WARNING: $package is missing expected path dependencies! Found $actual_path_deps, expected ~$expected_deps"
      verify_issues=$((verify_issues + 1))
    else
      echo "✅ $package: Found $actual_path_deps path dependencies (expected ~$expected_deps)"
    fi
  fi
done

if [ $verify_issues -eq 0 ]; then
  echo "✅ VERIFICATION COMPLETE: Development setup is PERFECT!"
else
  echo "⚠️ VERIFICATION FOUND $verify_issues ISSUES: You may need to manually fix some dependencies."
fi

echo ""
echo "🔥🔥🔥 DEVELOPMENT MODE SETUP COMPLETE! 🔥🔥🔥"
echo "All packages now use path dependencies for MAXIMUM DEVELOPMENT POWER!"
echo "You can now make changes across packages and test them together like a CODING BEAST!"
echo ""
