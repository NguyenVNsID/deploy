#!/bin/bash

# PULL ALL BRANCHES OF REPOS
# GitHub username
USERNAME="monkeytypegame"

# Function to fetch repositories
get_repositories() {
    curl -s "https://api.github.com/users/$USERNAME/repos" | jq -r '.[].name'
}

# Function to fetch branches for a repository
get_branches() {
    REPO=$1
    curl -s "https://api.github.com/repos/$USERNAME/$REPO/branches" | jq -r '.[].name'
}

# Main script
echo "Repositories for user $USERNAME:"
get_repositories | while read -r REPO; do
    echo "- $REPO"
    echo "  Branches:"
    get_branches "$REPO" | while read -r BRANCH; do
        echo "    - $BRANCH"
    done
done

# curl -H "Authorization: token YourPat" https://api.github.com/user/repos?type=private

# ADD, COMMIT & PUSH ALL BRANCHES OF LOCAL REPOS INTO ORIGIN REPO