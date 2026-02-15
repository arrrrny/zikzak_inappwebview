#!/bin/bash
set -e

# Color codes for better readability
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m' # No Color

ROOT_DIR="$(pwd)"

echo -e "${BLUE}=== ZIKZAK PUBLISH REVERT TOOL ===${NC}"
echo -e "${YELLOW}This script will revert changes made by prepare_for_publish.sh${NC}"

# Check if user is on a publish branch
CURRENT_BRANCH=$(git branch --show-current)
if [[ ! $CURRENT_BRANCH == publish-* ]]; then
    echo -e "${RED}Error: You are not on a publish branch (current: $CURRENT_BRANCH)${NC}"
    echo -e "${YELLOW}This script should only be run on a publish branch created by prepare_for_publish.sh${NC}"

    echo -e "${YELLOW}Do you want to continue anyway? (y/n)${NC}"
    read -r continue_anyway
    if [[ "$continue_anyway" != "y" && "$continue_anyway" != "Y" ]]; then
        echo -e "${RED}Operation aborted.${NC}"
        exit 1
    fi
fi

# Ask which branch to return to
echo -e "${YELLOW}Enter the branch name to return to (default: main):${NC}"
read -r target_branch
if [ -z "$target_branch" ]; then
    target_branch="main"
fi

# Check if target branch exists
if ! git show-ref --verify --quiet "refs/heads/$target_branch"; then
    echo -e "${RED}Error: Branch '$target_branch' does not exist.${NC}"
    exit 1
fi

# Confirm the operation
echo -e "${RED}WARNING: This will discard all changes made for publishing!${NC}"
echo -e "${YELLOW}Are you sure you want to revert to branch '$target_branch' and discard all publish changes? (y/n)${NC}"
read -r confirm
if [[ "$confirm" != "y" && "$confirm" != "Y" ]]; then
    echo -e "${RED}Operation aborted.${NC}"
    exit 1
fi

# Check for uncommitted changes
if ! git diff-index --quiet HEAD --; then
    echo -e "${YELLOW}You have uncommitted changes. Do you want to discard them? (y/n)${NC}"
    read -r discard_changes
    if [[ "$discard_changes" != "y" && "$discard_changes" != "Y" ]]; then
        echo -e "${RED}Please commit or stash your changes before reverting.${NC}"
        exit 1
    fi

    echo -e "${BLUE}Discarding uncommitted changes...${NC}"
    git reset --hard HEAD
fi

# Switch back to target branch
echo -e "${BLUE}Switching to branch '$target_branch'...${NC}"
git checkout "$target_branch"

# Ask if user wants to delete the publish branch
echo -e "${YELLOW}Do you want to delete the '$CURRENT_BRANCH' branch? (y/n)${NC}"
read -r delete_branch
if [[ "$delete_branch" == "y" || "$delete_branch" == "Y" ]]; then
    echo -e "${BLUE}Deleting branch '$CURRENT_BRANCH'...${NC}"
    git branch -D "$CURRENT_BRANCH"
    echo -e "${GREEN}Branch '$CURRENT_BRANCH' deleted successfully.${NC}"
fi

# Run restore_dev_setup.sh to ensure development dependencies are correct
echo -e "${BLUE}Restoring development setup...${NC}"
"$ROOT_DIR/scripts/restore_dev_setup.sh"

echo -e "${GREEN}Successfully reverted all publish changes!${NC}"
echo -e "${GREEN}You are now on branch '$target_branch' with development dependencies restored.${NC}"
