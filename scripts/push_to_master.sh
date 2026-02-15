#!/bin/bash
set -e

# Color codes for better readability
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m' # No Color

echo -e "${BLUE}=== ZIKZAK PUSH TO master TOOL ===${NC}"

# Get current branch
CURRENT_BRANCH=$(git branch --show-current)
echo -e "${YELLOW}Current branch: $CURRENT_BRANCH${NC}"

# Extract version from branch name if it follows the pattern publish-X.Y.Z
VERSION=""
if [[ "$CURRENT_BRANCH" =~ ^publish-([0-9]+\.[0-9]+\.[0-9]+)$ ]]; then
    VERSION="${BASH_REMATCH[1]}"
    echo -e "${GREEN}Detected version: $VERSION${NC}"
fi

# Check for uncommitted changes
if ! git diff-index --quiet HEAD --; then
    echo -e "${RED}You have uncommitted changes. Please commit them before proceeding.${NC}"
    echo -e "${YELLOW}Do you want to commit all changes now? (y/n)${NC}"
    read -r commit_changes
    if [[ "$commit_changes" == "y" || "$commit_changes" == "Y" ]]; then
        echo -e "${YELLOW}Enter commit message:${NC}"
        read -r commit_message

        git add .
        git commit -m "$commit_message"
        echo -e "${GREEN}Changes committed successfully!${NC}"
    else
        echo -e "${RED}Operation aborted. Please commit your changes first.${NC}"
        exit 1
    fi
fi

# Confirm before proceeding
echo -e "${YELLOW}This will merge changes from '$CURRENT_BRANCH' into 'master' and push to remote.${NC}"
echo -e "${RED}Make sure you have tested your changes before proceeding.${NC}"
echo -e "${YELLOW}Do you want to continue? (y/n)${NC}"
read -r confirm
if [[ "$confirm" != "y" && "$confirm" != "Y" ]]; then
    echo -e "${RED}Operation aborted.${NC}"
    exit 1
fi

# Check if master branch exists
if ! git show-ref --verify --quiet "refs/heads/master"; then
    echo -e "${RED}Error: 'master' branch does not exist.${NC}"
    exit 1
fi

# Checkout master branch
echo -e "${BLUE}Checking out master branch...${NC}"
git checkout master

# Pull latest changes from remote master to avoid conflicts
echo -e "${BLUE}Pulling latest changes from remote master...${NC}"
if git remote | grep -q "origin"; then
    git pull origin master || {
        echo -e "${YELLOW}Pull from origin failed. Continuing with local merge...${NC}"
    }
else
    echo -e "${YELLOW}No remote named 'origin' found. Skipping pull operation.${NC}"
fi

# Merge changes from current branch
echo -e "${BLUE}Merging changes from '$CURRENT_BRANCH' into 'master'...${NC}"
git merge "$CURRENT_BRANCH" || {
    echo -e "${RED}Merge conflict occurred.${NC}"
    echo -e "${YELLOW}Please resolve conflicts manually, then run:${NC}"
    echo -e "  git add ."
    echo -e "  git commit -m \"Merge $CURRENT_BRANCH into master\""
    echo -e "  git push origin master"
    exit 1
}

# Create and push git tag if version was detected
if [ -n "$VERSION" ]; then
    echo -e "${BLUE}Creating git tag $VERSION on master...${NC}"
    git tag "$VERSION" || {
        echo -e "${YELLOW}Tag $VERSION already exists. Skipping tag creation.${NC}"
    }
fi

# Push to remote
echo -e "${BLUE}Pushing changes to remote master...${NC}"
if git remote | grep -q "origin"; then
    git push origin master || {
        echo -e "${RED}Push failed. Please push manually:${NC}"
        echo -e "  git push origin master"
        exit 1
    }
    echo -e "${GREEN}Changes successfully pushed to remote master!${NC}"

    # Push tag if it was created
    if [ -n "$VERSION" ]; then
        echo -e "${BLUE}Pushing tag $VERSION to remote...${NC}"
        git push origin "$VERSION" || {
            echo -e "${RED}Failed to push tag. Please push manually:${NC}"
            echo -e "  git push origin $VERSION"
        }
        echo -e "${GREEN}Tag $VERSION pushed to remote successfully!${NC}"
    fi
else
    echo -e "${YELLOW}No remote named 'origin' found. Skipping push operation.${NC}"
    echo -e "${YELLOW}Please push manually when remote is configured.${NC}"
    if [ -n "$VERSION" ]; then
        echo -e "${YELLOW}Don't forget to push the tag: git push origin $VERSION${NC}"
    fi
fi

# Ask if user wants to delete the branch
if [ "$CURRENT_BRANCH" != "master" ]; then
    echo -e "${YELLOW}Do you want to delete the '$CURRENT_BRANCH' branch? (y/n)${NC}"
    read -r delete_branch
    if [[ "$delete_branch" == "y" || "$delete_branch" == "Y" ]]; then
        git branch -D "$CURRENT_BRANCH" || {
            echo -e "${RED}Failed to delete branch.${NC}"
            exit 1
        }
        echo -e "${GREEN}Branch '$CURRENT_BRANCH' deleted successfully.${NC}"
    else
        echo -e "${BLUE}Branch '$CURRENT_BRANCH' was kept.${NC}"
    fi
fi

echo -e "${GREEN}All operations completed successfully!${NC}"
echo -e "${BLUE}You are now on the 'master' branch with all changes merged and pushed.${NC}"
