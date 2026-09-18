# Update the Git portion of the prompt before each prompt is displayed.
# The result is stored in GIT_PROMPT_INFO so the prompt itself does not
# execute Git commands during expansion.

function git_prompt_info {
    local branch git_state

    branch=$(command git symbolic-ref --quiet --short HEAD 2>/dev/null) ||
        branch=$(command git rev-parse --short HEAD 2>/dev/null) || {
            GIT_PROMPT_INFO=
            return
        }

    # Check whether the repository has any staged, unstaged, deleted,
    # renamed, or untracked changes.
    git_state=$(command git status --porcelain --ignore-submodules=dirty 2>/dev/null)

    if [[ -n $git_state ]]; then
        GIT_PROMPT_INFO=" %F{cyan} ${branch}%f %F{yellow}*%f"
    else
        GIT_PROMPT_INFO=" %F{cyan} ${branch}%f"
    fi
}

add-zsh-hook precmd git_prompt_info
