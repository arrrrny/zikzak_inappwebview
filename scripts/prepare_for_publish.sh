#!/bin/bash
set -e

# Color codes for better readability
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m' # No Color

# Check if version argument is provided
if [ "$#" -eq 0 ]; then
    echo -e "${YELLOW}No version argument provided. Attempting to detect version from zikzak_inappwebview/pubspec.yaml...${NC}"
    # Use full path to pubspec, and ensure PROJECT_DIR is defined before use
    PROJECT_DIR_FIXED="$( cd "$(dirname "$0")/.." >/dev/null 2>&1 ; pwd -P )"
    DETECTED_VERSION=$(grep "^version:" "$PROJECT_DIR_FIXED/zikzak_inappwebview/pubspec.yaml" | sed 's/version: //' | tr -d '[:space:]')
    
    if [ -n "$DETECTED_VERSION" ]; then
        echo -e "${GREEN}Detected version: $DETECTED_VERSION${NC}"
        VERSION=$DETECTED_VERSION
    else
        echo -e "${RED}Error: Could not detect version from pubspec.yaml.${NC}"
        echo -e "Usage: $0 <version_number>"
        exit 1
    fi
else
    VERSION=$1
fi
BRANCH_NAME="publish-$VERSION"
ROOT_DIR="$(pwd)"

# Validate semantic version format (simple check)
if ! [[ $VERSION =~ ^[0-9]+\.[0-9]+\.[0-9]+$ ]]; then
    echo -e "${RED}Error: Version should follow semantic versioning (e.g., 1.2.5)${NC}"
    exit 1
fi

echo -e "${BLUE}=== Preparing to publish version $VERSION ===${NC}"

# Create a new branch for publishing
git checkout -b $BRANCH_NAME
echo -e "${GREEN}Created branch: $BRANCH_NAME${NC}"

# List of all packages to update (v3.0: all platforms)
PACKAGES=(
    "zikzak_inappwebview_internal_annotations"
    "zikzak_inappwebview_platform_interface"
    "zikzak_inappwebview_android"
    "zikzak_inappwebview_ios"
    "zikzak_inappwebview_web"
    "zikzak_inappwebview_macos"
    "zikzak_inappwebview_windows"
    "zikzak_inappwebview_linux"
    "zikzak_inappwebview"
)

# Update versions in all package pubspec.yaml files
for pkg in "${PACKAGES[@]}"; do
    echo -e "${BLUE}Updating version in $pkg to $VERSION${NC}"
    # Check if the package directory exists
    if [ ! -d "$ROOT_DIR/$pkg" ]; then
        echo -e "${RED}Warning: Package directory '$pkg' not found. Skipping.${NC}"
        continue
    fi

    # Update version in pubspec.yaml
    if [ -f "$ROOT_DIR/$pkg/pubspec.yaml" ]; then
        # Use sed for reliable version replacement
        sed -i '' "s/^version:.*/version: $VERSION/" "$ROOT_DIR/$pkg/pubspec.yaml"

        # Verify the update
        new_version=$(grep "^version:" "$ROOT_DIR/$pkg/pubspec.yaml" | sed 's/version: //' | tr -d '[:space:]')
        if [ "$new_version" != "$VERSION" ]; then
            echo -e "${RED}Failed to update version for $pkg to $VERSION. Current version: $new_version${NC}"
        else
            echo -e "${GREEN}Successfully updated $pkg to version $VERSION${NC}"
        fi
    else
        echo -e "${RED}Warning: pubspec.yaml not found in $pkg. Skipping.${NC}"
    fi

    # Update version in iOS podspec if it exists
    if [ "$pkg" == "zikzak_inappwebview_ios" ] && [ -f "$ROOT_DIR/$pkg/ios/zikzak_inappwebview_ios.podspec" ]; then
        echo -e "${BLUE}Updating iOS podspec version in $pkg to $VERSION${NC}"
        # Use sed to update the version line in podspec
        sed -i '' "s/s\.version.*=.*/s.version          = '$VERSION'/" "$ROOT_DIR/$pkg/ios/zikzak_inappwebview_ios.podspec"



        # Verify the podspec update
        podspec_version=$(grep "s.version" "$ROOT_DIR/$pkg/ios/zikzak_inappwebview_ios.podspec" | sed "s/.*= *'//" | sed "s/'.*//")
        if [ "$podspec_version" != "$VERSION" ]; then
            echo -e "${RED}Failed to update podspec version for $pkg to $VERSION. Current version: $podspec_version${NC}"
        else
            echo -e "${GREEN}Successfully updated iOS podspec in $pkg to version $VERSION${NC}"
        fi
    fi
done

# Function to convert path dependencies to versioned dependencies AND update existing versions
convert_path_to_versioned() {
    local file="$1"
    local version="$2"
    local exclude_pkg="$3"

    echo -e "${YELLOW}Converting path dependencies and updating versioned dependencies to $version in $file${NC}"

    # List of zikzak packages to convert/update (v3.0: all platforms)
    local packages=(
        "zikzak_inappwebview_internal_annotations"
        "zikzak_inappwebview_platform_interface"
        "zikzak_inappwebview_android"
        "zikzak_inappwebview_ios"
        "zikzak_inappwebview_web"
        "zikzak_inappwebview_macos"
        "zikzak_inappwebview_windows"
        "zikzak_inappwebview_linux"
        "zikzak_inappwebview"
    )

    # Create a temporary file
    local temp_file="${file}.tmp"
    cp "$file" "$temp_file"

    # Process each zikzak package
    for pkg in "${packages[@]}"; do
        # Skip excluded package (useful for examples that must keep path dependency on their parent)
        if [ "$pkg" == "$exclude_pkg" ]; then
            continue
        fi

        # Method 1: Replace single-line versioned dependencies (package: ^1.2.3)
        sed -i '' "s/^[[:space:]]*${pkg}:[[:space:]]*\^[0-9][0-9]*\.[0-9][0-9]*\.[0-9][0-9]*[[:space:]]*$/  ${pkg}: ^${version}/" "$temp_file"

        # Method 2: Replace single-line versioned dependencies (package: 1.2.3)
        sed -i '' "s/^[[:space:]]*${pkg}:[[:space:]]*[0-9][0-9]*\.[0-9][0-9]*\.[0-9][0-9]*[[:space:]]*$/  ${pkg}: ^${version}/" "$temp_file"

        # Method 3: Handle multi-line path dependencies
        # This uses a more complex sed command to find the package line and replace the entire dependency block
        sed -i '' "/^[[:space:]]*${pkg}:[[:space:]]*$/,/^[[:space:]]*[^[:space:]]/ {
            /^[[:space:]]*${pkg}:[[:space:]]*$/ {
                c\\
  ${pkg}: ^${version}
                d
            }
            /^[[:space:]]*path:[[:space:]]*/ d
            /^[[:space:]]*version:[[:space:]]*/ d
        }" "$temp_file"

        # Method 4: Handle malformed dependencies where version and path are on separate lines
        # First, find lines with "package: ^version" and mark them for replacement
        awk -v pkg="$pkg" -v version="$version" '
        BEGIN { in_malformed = 0 }
        {
            if ($0 ~ "^[[:space:]]*" pkg ":[[:space:]]*\\^[0-9]+\\.[0-9]+\\.[0-9]+[[:space:]]*$") {
                print "  " pkg ": ^" version
                in_malformed = 1
                next
            }
            if (in_malformed && $0 ~ /^[[:space:]]*path:/) {
                in_malformed = 0
                next
            }
            in_malformed = 0
            print $0
        }' "$temp_file" > "${temp_file}.fixed"
        mv "${temp_file}.fixed" "$temp_file"

        # Remove generators dependency from dev_dependencies (it causes conflicts during publish)
        sed -i '' '/^[[:space:]]*generators:/d' "$temp_file"
        sed -i '' '/path:.*dev_packages\/generators/d' "$temp_file"
    done

    mv "$temp_file" "$file"

    echo -e "${GREEN}Updated zikzak dependencies to version ^$version in $file${NC}"
}


# Update dependencies in each package to use versioned dependencies instead of path
echo -e "${BLUE}Updating dependencies to use versioned references${NC}"

# Update dependencies in ALL packages
for pkg in "${PACKAGES[@]}"; do
    if [ -f "$ROOT_DIR/$pkg/pubspec.yaml" ]; then
        convert_path_to_versioned "$ROOT_DIR/$pkg/pubspec.yaml" "$VERSION"
    else
        echo -e "${RED}Warning: pubspec.yaml not found in $pkg. Skipping.${NC}"
    fi

    # Also update dependencies in example app if it exists
    if [ -f "$ROOT_DIR/$pkg/example/pubspec.yaml" ]; then
        echo -e "${BLUE}Updating dependencies in $pkg example${NC}"
        # Pass the current package name as exclude_pkg so its path dependency is preserved
        convert_path_to_versioned "$ROOT_DIR/$pkg/example/pubspec.yaml" "$VERSION" "$pkg"
    fi
done

# Generate changelog content from git history
echo -e "${BLUE}Generating changelog from git history...${NC}"
CHANGELOG_CONTENT=""
LAST_TAG=$(git describe --tags --abbrev=0 2>/dev/null || echo "")

if [ -z "$LAST_TAG" ]; then
    echo -e "${YELLOW}No tags found. Analyzing all commits...${NC}"
    LOGS=$(git log --pretty=format:"%s")
else
    echo -e "${YELLOW}Analyzing commits since $LAST_TAG...${NC}"
    LOGS=$(git log --pretty=format:"%s" "$LAST_TAG..HEAD")
fi

# Extract Features, Changes, and Fixes
# We use grep with ignore-case (-i) and look for lines starting with the keywords
# We use || true to prevent script exit if grep finds nothing (due to set -e)
FEATURES=$(echo "$LOGS" | grep -i "^Feature:" | sed 's/^/* /' || true)
CHANGES=$(echo "$LOGS" | grep -i "^Changed:\|^Change:" | sed 's/^/* /' || true)
FIXES=$(echo "$LOGS" | grep -i "^Fixed:\|^Fix:" | sed 's/^/* /' || true)

if [ ! -z "$FEATURES" ]; then
    CHANGELOG_CONTENT="${CHANGELOG_CONTENT}${FEATURES}
"
fi
if [ ! -z "$CHANGES" ]; then
    CHANGELOG_CONTENT="${CHANGELOG_CONTENT}${CHANGES}
"
fi
if [ ! -z "$FIXES" ]; then
    CHANGELOG_CONTENT="${CHANGELOG_CONTENT}${FIXES}
"
fi

# If no content found, use a default message
if [ -z "$CHANGELOG_CONTENT" ]; then
    CHANGELOG_CONTENT="* Prepare for publishing version $VERSION"
fi

echo -e "${YELLOW}Generated Changelog Content:${NC}"
echo -e "$CHANGELOG_CONTENT"

# Ask for the commit message that will be used for both Git commit and CHANGELOG files
echo -e "${YELLOW}Enter a commit message title for version $VERSION (default: 'Prepare for publishing version $VERSION'):${NC}"
read -r COMMIT_MESSAGE
if [ -z "$COMMIT_MESSAGE" ]; then
    COMMIT_MESSAGE="Prepare for publishing version $VERSION"
fi

# Update CHANGELOG.md files with new version
CURRENT_DATE=$(date +"%Y-%m-%d")
for pkg in "${PACKAGES[@]}"; do
    if [ -f "$ROOT_DIR/$pkg/CHANGELOG.md" ]; then
        echo -e "${BLUE}Updating CHANGELOG.md in $pkg${NC}"
        # Add new version entry at the top of the CHANGELOG
        # We use a temporary file to handle the multiline insertion correctly
        TEMP_CHANGELOG="$ROOT_DIR/$pkg/CHANGELOG.md.tmp"
        echo -e "## $VERSION - $CURRENT_DATE\n" > "$TEMP_CHANGELOG"
        echo -e "$CHANGELOG_CONTENT" >> "$TEMP_CHANGELOG"
        echo -e "* Updated dependencies to use hosted references\n" >> "$TEMP_CHANGELOG"
        cat "$ROOT_DIR/$pkg/CHANGELOG.md" >> "$TEMP_CHANGELOG"
        mv "$TEMP_CHANGELOG" "$ROOT_DIR/$pkg/CHANGELOG.md"
    else
        echo -e "${RED}Warning: CHANGELOG.md not found in $pkg. Creating new CHANGELOG.md${NC}"
        echo -e "## $VERSION - $CURRENT_DATE\n" > "$ROOT_DIR/$pkg/CHANGELOG.md"
        echo -e "$CHANGELOG_CONTENT" >> "$ROOT_DIR/$pkg/CHANGELOG.md"
        echo -e "* Updated dependencies to use hosted references\n" >> "$ROOT_DIR/$pkg/CHANGELOG.md"
    fi
done

# Function to check if a package version is already published on pub.dev
check_package_on_pubdev() {
    local package_name=$1
    local version=$2

    echo -e "${YELLOW}Checking if $package_name version $version is already on pub.dev...${NC}"

    # Use curl to query the pub.dev API
    local response=$(curl -s "https://pub.dev/api/packages/$package_name")
    local http_code=$(curl -s -o /dev/null -w "%{http_code}" "https://pub.dev/api/packages/$package_name")

    # Check if the package exists
    if [ "$http_code" != "200" ]; then
        echo -e "${BLUE}Package $package_name not found on pub.dev. Will be published for the first time.${NC}"
        return 1
    fi

    # Check if the version exists in the package versions
    if echo "$response" | grep -q "\"version\":\"$version\""; then
        echo -e "${RED}Version $version of $package_name is already published on pub.dev!${NC}"
        return 0
    else
        echo -e "${GREEN}Version $version of $package_name is not yet published. Ready to publish.${NC}"
        return 1
    fi
}

# Check all packages on pub.dev and display a summary
echo -e "${BLUE}\n=== Checking packages on pub.dev ===${NC}"
echo -e "${BLUE}\n=== Publication Status Summary ===${NC}"

for pkg in "${PACKAGES[@]}"; do
    # Extract package name from directory
    pkg_name=$(basename "$pkg")

    if check_package_on_pubdev "$pkg_name" "$VERSION"; then
        echo -e "${pkg_name}: ${RED}Already published${NC}"
    else
        echo -e "${pkg_name}: ${GREEN}Not published (ready to publish)${NC}"
    fi
done

# Verify that no path dependencies remain
echo -e "${BLUE}\n=== Verifying no path dependencies remain ===${NC}"
found_path_deps=false

for pkg in "${PACKAGES[@]}"; do
    if [ -f "$ROOT_DIR/$pkg/pubspec.yaml" ]; then
        if grep -q "path:" "$ROOT_DIR/$pkg/pubspec.yaml"; then
            echo -e "${RED}Warning: Path dependencies still found in $pkg/pubspec.yaml${NC}"
            echo -e "${YELLOW}Remaining path dependencies:${NC}"
            grep -A1 -B1 "path:" "$ROOT_DIR/$pkg/pubspec.yaml"
            found_path_deps=true
        else
            echo -e "${GREEN}✓ No path dependencies in $pkg${NC}"
        fi
    fi
done

if [ "$found_path_deps" = true ]; then
    echo -e "\n${RED}⚠️  Some packages still have path dependencies. Please review and fix manually.${NC}"
else
    echo -e "\n${GREEN}✅ All path dependencies successfully converted to versioned dependencies!${NC}"
fi

echo -e "${GREEN}All packages updated to version $VERSION with versioned dependencies${NC}"

# Automatically commit changes
echo -e "${BLUE}Committing changes...${NC}"
git add .
git commit -m "$COMMIT_MESSAGE" -m "$CHANGELOG_CONTENT"
echo -e "${GREEN}Changes committed successfully!${NC}"



echo -e "${YELLOW}Next steps:${NC}"
echo -e "1. Merge to master using: ./scripts/push_to_master.sh (this will create and push the git tag automatically)"
echo -e "2. Publish packages in order using the publish.sh script"
echo -e ""
echo -e "${BLUE}To revert to development setup (path dependencies), use:${NC}"
echo -e "./scripts/restore_dev_setup.sh"
echo -e ""
echo -e "${RED}To completely revert all publish changes (including git branch):${NC}"
echo -e "./scripts/revert_publish_changes.sh"
