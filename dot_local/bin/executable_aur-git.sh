#!/bin/bash

# Navigate to your git directory
cd ~/git || exit

# Loop through every item in the directory
for dir in */; do
    # Check if it's actually a git repository
    if [ -d "$dir/.git" ]; then
        echo "------------------------------------------"
        echo "Checking $dir..."

        pushd "$dir" > /dev/null

        # Fetch and check if the local branch is behind the remote
        git fetch
        UPSTREAM=${1:-'@{u}'}
        LOCAL=$(git rev-parse @)
        REMOTE=$(git rev-parse "$UPSTREAM")

        if [ "$LOCAL" != "$REMOTE" ]; then
            echo "✨ Updates found in $dir"
            git pull

            # Ask if you want to work
            read -p "Would you like to do some work in $dir? (y/n): " choice
            if [[ "$choice" =~ ^[Yy]$ ]]; then
                echo "Entering shell. Type 'exit' to resume checking other repos."
                $SHELL
            fi
        else
            echo "Already up to date."
        fi

        popd > /dev/null
    fi
done

echo "------------------------------------------"
echo "All directories processed."
