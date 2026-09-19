zmodload zsh/datetime

# Capture the command start time.
function cmd_start_timer {
    CMD_START_TIME=$EPOCHREALTIME
}

add-zsh-hook preexec cmd_start_timer

function prompt_status_info {
    LAST_CMD_STATUS=$?

    if (( LAST_CMD_STATUS != 0 )); then
        STATUS_INFO=" %F{red}✗ ${LAST_CMD_STATUS}%f"
    else
        STATUS_INFO=
    fi

    if [[ -n $CMD_START_TIME ]]; then
        local elapsed=$(( EPOCHREALTIME - CMD_START_TIME ))
        unset CMD_START_TIME
        elapsed=${elapsed%.*}

        if (( elapsed >= 3 )); then
            if (( elapsed >= 60 )); then
                DURATION_INFO=" %F{yellow}$(( elapsed / 60 ))m$(( elapsed % 60 ))s%f"
            else
                DURATION_INFO=" %F{yellow}${elapsed}s%f"
            fi
        else
            DURATION_INFO=
        fi
    else
        DURATION_INFO=
    fi
}

add-zsh-hook precmd prompt_status_info

# Run before other precmd hooks so $? is still the command's exit status.
precmd_functions=( prompt_status_info ${precmd_functions:#prompt_status_info} )
