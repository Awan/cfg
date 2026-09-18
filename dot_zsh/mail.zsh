# Update the mail portion of the prompt before each prompt is displayed.
# Store the result in MAIL_PROMPT_INFO so the prompt itself does not need
# to execute the Maildir check during expansion.

function mailsnow {
    local -a mails=(~/.local/share/email/x1c/INBOX/new/*(N))

    if (( $#mails )); then
        MAIL_PROMPT_INFO=" %F{red}✉ $#mails%f"
    else
        MAIL_PROMPT_INFO=
    fi
}

add-zsh-hook precmd mailsnow
