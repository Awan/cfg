git_prompt_info() {
    local branch git_state

    branch=$(command git symbolic-ref --quiet --short HEAD 2>/dev/null) ||
        branch=$(command git rev-parse --short HEAD 2>/dev/null) ||
        return

    git_state=$(command git status --porcelain --ignore-submodules=dirty 2>/dev/null)

    if [[ -n $git_state ]]; then
        print " %F{cyan} $branch%f %F{yellow}*%f"
    else
        print " %F{cyan} $branch%f"
    fi
}
