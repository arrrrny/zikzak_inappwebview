#!/bin/bash
set -e

# Publish the zikzak_webview_windows fork — the native WebView2 implementation
# that zikzak_inappwebview_windows compiles against.
#
# It is deliberately NOT part of the lockstep 6.x publish (scripts/publish.sh
# only walks the 8 platform packages): this package mirrors upstream
# webview_windows' version line and carries its own delta, so its version is
# 0.5.0 while everything else is 6.x. It must be on pub.dev BEFORE
# scripts/publish.sh runs, or zikzak_inappwebview_windows cannot resolve it.

GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m'

PROJECT_DIR="$( cd "$(dirname "$0")/.." >/dev/null 2>&1 ; pwd -P )"
PKG="$PROJECT_DIR/zikzak_webview_windows"

if [ ! -f "$PKG/pubspec.yaml" ]; then
    echo -e "${RED}✗ $PKG/pubspec.yaml not found.${NC}"
    exit 1
fi

NAME=$(grep "^name:" "$PKG/pubspec.yaml" | head -1 | sed 's/name: //' | tr -d '[:space:]')
VERSION=$(grep "^version:" "$PKG/pubspec.yaml" | head -1 | sed 's/version: //' | tr -d '[:space:]')

echo -e "${BLUE}=== Publishing $NAME $VERSION ===${NC}"

if ! [[ $VERSION =~ ^[0-9]+\.[0-9]+\.[0-9]+(-[0-9A-Za-z.-]+)?$ ]]; then
    echo -e "${RED}✗ Version '$VERSION' is not valid semver.${NC}"
    exit 1
fi

# Refuse to republish a version pub.dev already has: pub.dev versions are immutable.
HTTP_CODE=$(curl -s -o /dev/null -w "%{http_code}" "https://pub.dev/api/packages/$NAME")
if [ "$HTTP_CODE" = "200" ]; then
    if curl -s "https://pub.dev/api/packages/$NAME" | grep -q "\"version\":\"$VERSION\""; then
        echo -e "${YELLOW}⚠ $NAME $VERSION is already published on pub.dev — nothing to do.${NC}"
        exit 0
    fi
fi

# A dry run first: it validates the pubspec and the package layout without
# uploading anything.
echo -e "${BLUE}Dry run...${NC}"
(cd "$PKG" && flutter pub publish --dry-run)

echo -e "${YELLOW}Publishing $NAME $VERSION to pub.dev...${NC}"
(cd "$PKG" && flutter pub publish --force)

echo -e "${GREEN}✓ $NAME $VERSION published.${NC}"
echo -e "${YELLOW}pub.dev takes up to ~10 minutes to propagate a new version.${NC}"