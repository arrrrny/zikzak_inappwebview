#!/bin/bash
set -e

# Color codes for better readability
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m' # No Color

readonly SCRIPT_PATH="$( cd "$(dirname "$0")" >/dev/null 2>&1 ; pwd -P )"
readonly PROJECT_DIR="$(dirname $SCRIPT_PATH)"

# The order of packages for publishing (v3.0: all platforms)
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

# Function to check if a package version is already published on pub.dev
check_package_on_pubdev() {
    local package_name=$1
    local version=$2

    echo -e "${BLUE}Checking if $package_name version $version is available on pub.dev...${NC}"

    # Use curl to query the pub.dev API
    local response=$(curl -s "https://pub.dev/api/packages/$package_name")
    local http_code=$(curl -s -o /dev/null -w "%{http_code}" "https://pub.dev/api/packages/$package_name")

    # Check if the package exists
    if [ "$http_code" != "200" ]; then
        echo -e "${YELLOW}Package $package_name not found on pub.dev. Will be published for the first time.${NC}"
        return 1
    fi

    # Check if the version exists in the package versions
    if echo "$response" | grep -q "\"version\":\"$version\""; then
        echo -e "${GREEN}Version $version of $package_name is already published on pub.dev!${NC}"
        return 0
    else
        echo -e "${YELLOW}Version $version of $package_name is not yet published. Ready to publish.${NC}"
        return 1
    fi
}

# Function to verify that a package dependency can actually be resolved by pub
verify_dependency_resolution() {
    local package_name=$1
    local version=$2

    echo -e "${BLUE}Verifying that $package_name version $version can be resolved by pub...${NC}"

    # Create a temporary directory for testing dependency resolution
    local temp_dir=$(mktemp -d)
    cd "$temp_dir"

    # Create a minimal pubspec.yaml to test dependency resolution
    cat > pubspec.yaml << EOF
name: dependency_test
version: 1.0.0

environment:
  sdk: '>=2.17.0 <4.0.0'
  flutter: ">=3.0.0"

dependencies:
  flutter:
    sdk: flutter
  $package_name: ^$version

dev_dependencies:
  flutter_test:
    sdk: flutter
EOF

    # Try to resolve dependencies
    local pub_get_output
    local pub_get_exit_code

    pub_get_output=$(flutter pub get 2>&1)
    pub_get_exit_code=$?

    # Clean up temporary directory
    cd "$PROJECT_DIR"
    rm -rf "$temp_dir"

    if [ $pub_get_exit_code -eq 0 ]; then
        echo -e "${GREEN}Dependency $package_name version $version is resolvable by pub!${NC}"
        return 0
    else
        echo -e "${YELLOW}Dependency $package_name version $version is not yet resolvable by pub.${NC}"
        echo -e "${YELLOW}Pub get output: $pub_get_output${NC}"
        return 1
    fi
}

# Function to check if all dependencies of a package are available on pub.dev
check_dependencies() {
    local package_dir="$1"
    local max_retries=30
    local retry_interval=30

    # Extract package version from pubspec.yaml
    local version=$(grep "^version:" "$PROJECT_DIR/$package_dir/pubspec.yaml" | sed 's/version: //' | tr -d '[:space:]')

    # Find all package dependencies that match our packages
    local dependencies=$(grep -E "zikzak_inappwebview_" "$PROJECT_DIR/$package_dir/pubspec.yaml" | grep -v "path:" | sed 's/^[ \t]*//;s/[ \t]*$//' | grep -o "zikzak_inappwebview_[a-z_]*")

    if [ -z "$dependencies" ]; then
        echo -e "${BLUE}No internal dependencies found for $package_dir.${NC}"
        return 0
    fi

    echo -e "${BLUE}Checking dependencies for $package_dir...${NC}"

    for dep in $dependencies; do
        echo -e "${YELLOW}Checking dependency: $dep${NC}"

        # Skip if dependency is the package itself
        if [ "$dep" = "$package_dir" ]; then
            continue
        fi

        # Try up to max_retries times with delay
        retry_count=0
        while [ $retry_count -lt $max_retries ]; do
            # First check if it's available via API
            if check_package_on_pubdev "$dep" "$version"; then
                # If API shows it's available, verify it can actually be resolved
                if verify_dependency_resolution "$dep" "$version"; then
                    break
                else
                    echo -e "${YELLOW}Package $dep is in API but not yet resolvable. This is normal - pub.dev needs time to process.${NC}"
                fi
            fi

            retry_count=$((retry_count + 1))
            if [ $retry_count -lt $max_retries ]; then
                echo -e "${YELLOW}Dependency $dep not fully available yet. Waiting ${retry_interval}s before retry ($retry_count/$max_retries)...${NC}"
                echo -e "${BLUE}Note: There can be a delay between API availability and dependency resolution on pub.dev${NC}"
                sleep $retry_interval
            else
                echo -e "${RED}Dependency $dep version $version is required but not resolvable after $max_retries retries ($(($max_retries * $retry_interval / 60)) minutes).${NC}"
                echo -e "${RED}Make sure it has been published and fully processed by pub.dev before proceeding.${NC}"
                return 1
            fi
        done
    done

    echo -e "${GREEN}All dependencies for $package_dir are available and resolvable on pub.dev!${NC}"
    return 0
}



# Function to publish a package
publish_package() {
    local package_dir="$1"

    echo -e "${BLUE}======================================${NC}"
    echo -e "${YELLOW}Publishing package: ${GREEN}$package_dir${NC}"
    echo -e "${BLUE}======================================${NC}"

    # Extract package version
    local version=$(grep "^version:" "$PROJECT_DIR/$package_dir/pubspec.yaml" | sed 's/version: //' | tr -d '[:space:]')

    # Check if package is already published
    if check_package_on_pubdev "$package_dir" "$version"; then
        echo -e "${GREEN}Skipping $package_dir version $version (already published)${NC}"
        return 0
    fi

    # Check if all dependencies are available on pub.dev
    if ! check_dependencies "$package_dir"; then
        echo -e "${RED}Cannot publish $package_dir yet due to missing dependencies.${NC}"
        return 1
    fi

    # Final verification: test pub get on the actual package
    echo -e "${BLUE}Final verification: testing pub get on $package_dir...${NC}"
    cd "$PROJECT_DIR/$package_dir"

    # Try pub get to ensure all dependencies can be resolved
    if ! flutter pub get; then
        echo -e "${RED}Failed to resolve dependencies for $package_dir. Cannot proceed with publishing.${NC}"
        return 1
    fi
    echo -e "${GREEN}All dependencies resolved successfully for $package_dir!${NC}"

    # Format the Dart code
    echo -e "${BLUE}Formatting Dart code...${NC}"
    if [ -d "lib" ]; then
        dart format lib/
    fi

    # Analyze the package
    echo -e "${BLUE}Analyzing package...${NC}"
    flutter analyze

    # Publish with dry-run first
    echo -e "${BLUE}Running dry-run...${NC}"
    flutter pub publish --dry-run

    echo -e "${BLUE}Publishing to pub.dev...${NC}"
    flutter pub publish -f
    echo -e "${GREEN}Package $package_dir published to pub.dev successfully!${NC}"

    return 0
}

# Main script execution
echo -e "${BLUE}Starting publication process in the correct order${NC}"
echo -e "${YELLOW}Packages will be published in this order:${NC}"
for package in "${PACKAGES[@]}"; do
    echo -e "- $package"
done
echo

# Confirm publication of all packages
echo -e "${YELLOW}Do you want to proceed with publishing all packages? (y/n)${NC}"
read -r proceed
if [ "$proceed" != "y" ] && [ "$proceed" != "Y" ]; then
    echo -e "${RED}Publication process aborted.${NC}"
    exit 0
fi

# Publish each package in the defined order
for package in "${PACKAGES[@]}"; do
    if ! publish_package "$package"; then
        echo -e "${RED}Publication process stopped at $package.${NC}"
        exit 1
    fi
done

# Create and push git tag
echo -e "${BLUE}Creating and pushing git tag...${NC}"
MAIN_PACKAGE="zikzak_inappwebview"
VERSION=$(grep "^version:" "$PROJECT_DIR/$MAIN_PACKAGE/pubspec.yaml" | sed 's/version: //' | tr -d '[:space:]')

if git tag "$VERSION"; then
    echo -e "${GREEN}Git tag $VERSION created successfully!${NC}"
    if git push origin "$VERSION"; then
        echo -e "${GREEN}Git tag $VERSION pushed to origin successfully!${NC}"
    else
        echo -e "${RED}Failed to push git tag $VERSION to origin.${NC}"
    fi
else
    echo -e "${YELLOW}Git tag $VERSION already exists or could not be created.${NC}"
fi

echo -e "${GREEN}All packages published successfully!${NC}"
echo -e ""
echo -e "${BLUE}Options for next steps:${NC}"
echo -e "1. ${YELLOW}To revert to development setup (keep branch):${NC}"
echo -e "   ./scripts/restore_dev_setup.sh"
echo -e ""
echo -e "2. ${YELLOW}To completely revert all publish changes (switch back to main):${NC}"
echo -e "   ./scripts/revert_publish_changes.sh"
echo -e ""
echo -e "3. ${YELLOW}To merge all changes into main and push:${NC}"
echo -e "   ./scripts/push_to_master.sh"
