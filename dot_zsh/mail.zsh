#function mailsnow {
#    mails=(~/.local/share/email/x1c/INBOX/new/*(N))
#    (( $#mails )) && print  ✉ $#mails
#}

function mailsnow {
    local -a mails=(~/.local/share/email/x1c/INBOX/new/*(N))
    (( $#mails )) && print "✉ $#mails"
}
