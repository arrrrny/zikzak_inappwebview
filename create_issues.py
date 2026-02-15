#!/usr/bin/env python3
"""
Create GitHub issues for zikzak_inappwebview modernization plan
Usage: python3 create_issues.py <github_token>
"""

import sys
import json
import requests

REPO_OWNER = "arrrrny"
REPO_NAME = "zikzak_inappwebview"

def create_issue(token, title, body, labels):
    """Create a GitHub issue"""
    url = f"https://api.github.com/repos/{REPO_OWNER}/{REPO_NAME}/issues"
    headers = {
        "Authorization": f"token {token}",
        "Accept": "application/vnd.github.v3+json"
    }
    data = {
        "title": title,
        "body": body,
        "labels": labels
    }

    response = requests.post(url, headers=headers, json=data)

    if response.status_code == 201:
        issue = response.json()
        print(f"✅ Created: #{issue['number']} - {title}")
        return True
    else:
        print(f"❌ Failed to create: {title}")
        print(f"   Error: {response.status_code} - {response.text}")
        return False

def main():
    if len(sys.argv) != 2:
        print("Usage: python3 create_issues.py <github_token>")
        print("\nGet your token from: https://github.com/settings/tokens")
        print("Required scopes: public_repo or repo")
        sys.exit(1)

    token = sys.argv[1]

    # Load issues from JSON file
    with open('issues_to_create.json', 'r') as f:
        issues = json.load(f)

    print(f"Creating {len(issues)} issues for {REPO_OWNER}/{REPO_NAME}...")
    print()

    success_count = 0
    for issue in issues:
        if create_issue(token, issue['title'], issue['body'], issue['labels']):
            success_count += 1

    print()
    print(f"✅ Successfully created {success_count}/{len(issues)} issues")

if __name__ == "__main__":
    main()
