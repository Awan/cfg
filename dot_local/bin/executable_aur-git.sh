#!/bin/bash

# Navigate to your git directory
cd "$HOME/git" || exit

# Loop through every item in the directory
for dir in */; do
    # Check if it's actually a Git repository
    if [ -d "$dir/.git" ]; then
        printf '%s\n' '------------------------------------------'
        printf 'Checking %s...\n' "$dir"

        if ! pushd "$dir" > /dev/null; then
            printf 'Skipping %s: unable to enter repository.\n' "$dir" >&2
            continue
        fi

        UPSTREAM=${1:-'@{u}'}

        if ! git fetch; then
            printf 'Skipping %s: git fetch failed.\n' "$dir" >&2
            popd > /dev/null
            continue
        fi

        if ! git rev-parse --verify "$UPSTREAM" >/dev/null 2>&1; then
            printf 'Skipping %s: upstream ref not found: %s\n' "$dir" "$UPSTREAM" >&2
            popd > /dev/null
            continue
        fi

        if ! read -r ahead behind < <(git rev-list --left-right --count "HEAD...$UPSTREAM"); then
            printf 'Skipping %s: unable to compare local and upstream history.\n' "$dir" >&2
            popd > /dev/null
            continue
        fi

        if (( ahead == 0 && behind == 0 )); then
            printf '%s\n' 'Already up to date.'
        elif (( ahead > 0 && behind == 0 )); then
            printf 'Local branch is ahead of %s by %s commit(s); leaving it unchanged.\n' "$UPSTREAM" "$ahead"
        elif (( ahead == 0 && behind > 0 )); then
            printf 'Remote updates found in %s (%s commit(s)).\n' "$dir" "$behind"

            # Only fast-forward; never create an unexpected merge commit.
            if ! git merge --ff-only "$UPSTREAM"; then
                printf 'Skipping %s: fast-forward update failed.\n' "$dir" >&2
                popd > /dev/null
                continue
            fi

            read -r -p "Would you like to do some work in $dir? (y/n): " choice
            if [[ "$choice" =~ ^[Yy]$ ]]; then
                printf "Entering shell. Type 'exit' to resume checking other repos.\n"
                "${SHELL:-/bin/sh}"
            fi
        else
            printf 'Local and upstream branches have diverged (%s local, %s upstream); skipping automatic integration.\n' "$ahead" "$behind" >&2
        fi

        popd > /dev/null
    fi
done

printf '%s\n' '------------------------------------------'
printf '%s\n' 'All directories processed.'
